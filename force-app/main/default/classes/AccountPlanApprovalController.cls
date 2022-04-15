public class AccountPlanApprovalController {

    public static final Id US_RECORDTYPE_ID = Schema.SObjectType.Account_Plan__c.getRecordTypeInfosByName().get('US - Account Plan').getRecordTypeId();

    @AuraEnabled
    public static Object validateAction(Id recordId){
        Map<String, Object> result = new Map<String, Object>();
        result.put('status', 'SUCCESS');
        
        Account_Plan__c accountPlanRecord = [SELECT Id, Status__c, RecordTypeId FROM Account_Plan__c WHERE Id =: recordId];
        if(Approval.isLocked(recordId)){
            result.put('status', 'ERROR');
            
            if(accountPlanRecord.Status__c =='Approved'){
                result.put('message', System.label.AccountPlanRecordApproved);
            }
            else{
                result.put('message', System.label.AccountPlanRecordUnderApproval);   
            }
            return result;
        }
        
        if(accountPlanRecord.RecordTypeId != US_RECORDTYPE_ID){
            result.put('status', 'ERROR');
            result.put('message', System.Label.AccountPlanInvalidSubmitter);
            return result;
        }
        
        User userInfo = [SELECT Id, Name, Profile.Name FROM User WHERE Id =: UserInfo.getUserId()];
        if(!System.Label.AccountPlanApprovalProfiles.containsIgnoreCase(userInfo.Profile.Name)){
            result.put('status', 'ERROR');
            result.put('message', System.Label.AccountPlanInvalidSubmitter);
            return result;
        }
        return result;
    }
    
    @AuraEnabled
    public static Boolean submitForApproval(Id recordId, String comments){
        try{
            Account_Plan__c accountPlanRecord = [SELECT Id, Company__c, Company__r.OwnerId FROM Account_Plan__c WHERE Id=:recordId];
            accountPlanRecord.Company_Owner__c = accountPlanRecord.Company__r.OwnerId;
            
            User userInfo = [SELECT Id, ManagerId FROM User WHERE Id=: UserInfo.getUserId()];
            accountPlanRecord.Submitter_Manager__c = userInfo.ManagerId;
            
            Database.update(accountPlanRecord);
            
            //Submit for approval
            return invokeApprovalProcess(recordId, comments);
        }
        catch(Exception e){    return false;    }
    }
    
    private static boolean invokeApprovalProcess(Id objectId, String comments){
        // Create an approval request for the account
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments(comments);
        req.setObjectId(objectId);
        
        // Submit on behalf of a specific submitter
        req.setSubmitterId(UserInfo.getUserId()); 
        
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req);
        
        // Verify the result
        return result.isSuccess();
    }
}