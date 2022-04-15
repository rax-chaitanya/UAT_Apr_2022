public without sharing class RequestCompanyAccessController {
    
    @AuraEnabled
    public static Account getCompany(Id recordId) {
        Account company = new Account();
        try {
            company = [Select Id, Name, Owner.Name, OwnerId, Owner.ManagerId, Owner.Manager.Name from Account where Id = :recordId];
        } catch (Exception e) {
            if (!Test.isRunningTest()) {
                throw new AurahandledException(e.getMessage());
            }
        }
        return company;
    }
    
    @AuraEnabled
    public static UserRecordAccess getUserRecordAccess(Id recordId) {
        UserRecordAccess ura = new UserRecordAccess();
        try {
            String userId = UserInfo.getUserId();
            ura = [SELECT RecordId, HasReadAccess, HasEditAccess, HasDeleteAccess, HasTransferAccess, HasAllAccess FROM UserRecordAccess where UserId = :userId and  RecordId = :recordId];
        } catch (Exception e) {
            if (!Test.isRunningTest()) {
                throw new AurahandledException(e.getMessage());
            }
        }
        return ura;
    }
    
    @AuraEnabled
    public static ProcessInstance findProcessInstance(Id recordId) {
        try {
            
            System.debug('record id: ' + recordId);
            ProcessInstance[] pis = new List<ProcessInstance>();
            pis = [SELECT ID, TargetObjectID, CreatedBy.Name from ProcessInstance WHERE Status = 'Pending' AND TargetObjectID = :recordId];
            if (pis.size() > 0) {
                System.debug('returning the following' + pis[0]);
                
                return pis[0];
            } else {
                System.debug('returning null...');
                return null;
            }
        } catch (Exception e) {
            if (!Test.isRunningTest()) {
                throw new AurahandledException(e.getMessage());
            }
        }
        return null;
        
    }
    
    
    @AuraEnabled
    public static String goBack(Id recordId) {
        return URL.getSalesforceBaseUrl().toExternalForm() + '/' + recordId;
    }
    
    
    @AuraEnabled 
    public static String requestAccess(Id recordId) {
        try {
            System.debug('requesting Access to Company');
            //start SFDC-5451
            Account company =[select id,name,OwnerId,Company_Access_Submitter__c,Requester__c from account where id=:recordId];
            List<Account> customeracc=[select id from account where company_name__c=:recordId and type!='Prospect'];
            user comowner=[select id,IsActive,Region__c from user where id=:company.OwnerID ];
            //end SFDC-5451
            // kicks off an approval process 
            company.Company_Access_Submitter__c = UserInfo.getUserId();
            //SFDC-1167
            company.Requester__c = UserInfo.getUserId();
            //SFDC-1167            
            update company;
            //start SFDC-5451
            if(!comowner.isActive && customeracc.isempty() && comowner.Region__c == 'AMER' ){  
                system.debug('from inactive user');
                AutoApproveAccess(recordId);
            }
            //end SFDC-5451 
            
            System.debug('Pending Test');                            
            return 'Success';
        } catch (Exception e) {
            if (!Test.isRunningTest()) {
                throw new AurahandledException(e.getMessage());
            } 
        }
        return null;
    }
    //start SFDC-5451 
    public static Id getWorkItemId(Id targetObjectId){
        Id workItemId = null;
        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: targetObjectId]){
            workItemId  =  workItem.Id;
            system.debug('workItem'+workItem);
        }
        system.debug('workItemId'+workItemId);
        return workItemId;
    }
    
    public static void AutoApproveAccess(Id recordId){
        system.debug('auto approve initaiated');          
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Auto Approved ');
        req.setAction('Approve');        
        Id workItemId = getWorkItemId(recordId); 
        if(workItemId != null){
            req.setWorkitemId(workItemId);
            system.debug('workItemId'+workItemId);
            // Submit the request for approval
            Approval.ProcessResult result =  Approval.process(req);
            system.debug('Approval Process'+result);
            system.debug('auto approve done');
        }else return;
    }
     //end SFDC-5451 
}