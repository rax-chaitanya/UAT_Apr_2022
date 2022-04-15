public without sharing class GAR_ApprovalController {
    private static final String SYSTEM_ADMINISTRATOR = 'System Administrator';
    @AuraEnabled
    public static Object validateAndLoadRecord(Id recordId){
        Map<String, Object> result = new Map<String, Object>();
        result.put('isSuccess', false);
        Account_Realignment_Request__c request = getRequestDetails(recordId);
        
        Set<String> validApprovers = getValidApprovers(request);
        User loggedInUser = [SELECT Id, Name, Profile.Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        if(request.Status__c == 'Approved' || request.Status__c == 'Auto Approved' || request.Status__c == 'Rejected'){
            result.put('Message', System.Label.GAR_Approval_Request_Processed_Message + request.Status__c);
            return result;
        }
        if(request.Approver__c != loggedInUser.Id && !validApprovers.contains(loggedInUser.Id) && !SYSTEM_ADMINISTRATOR.equalsIgnoreCase(loggedInUser.Profile.Name)){
            result.put('Message', System.Label.GAR_Approval_Invalid_User_Message);
            return result;
        }
        if(request.Approver__c == loggedInUser.Id || validApprovers.contains(loggedInUser.Id) || SYSTEM_ADMINISTRATOR.equalsIgnoreCase(loggedInUser.Profile.Name)){
            result.put('Record', request);
            result.put('isSuccess', true);
        }
        return result;
    }
    
    @AuraEnabled
    public static Account_Realignment_Request__c processDML(String action, Account_Realignment_Request__c request, List<Realignment_Request_Item__c> items, String comments){
        List<Realignment_Request_Item__c> rejectedItems = new List<Realignment_Request_Item__c>();
        System.debug('request : '+JSON.serialize(request));
        for(Realignment_Request_Item__c item : items){
            if(item.Request_Status__c == 'Rejected'){
                rejectedItems.add(item);
            }
        }
        if(!rejectedItems.isEmpty()){
            Database.update(rejectedItems);
        }
        Account_Realignment_Request__c result = getRequestDetails(request.Id);
        return result;
    }
    
    @AuraEnabled
    public static Account_Realignment_Request__c processApproval(String action, Account_Realignment_Request__c request, List<Realignment_Request_Item__c> items, String comments){
        
        ProcessInstance approvalInstance = [SELECT Id, TargetObjectId, (SELECT Id FROM Workitems) FROM ProcessInstance WHERE TargetObjectId =: request.Id Order by CreatedDate LIMIT 1];
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments(comments);
        req.setAction(action);
        req.setWorkitemId(approvalInstance.Workitems[0].Id);
        Approval.ProcessResult approvalResult =  Approval.process(req);
        
        Account_Realignment_Request__c result = getRequestDetails(request.Id);
        return result;
    }
    
    private static Set<String> getValidApprovers(Account_Realignment_Request__c request){
        Set<String> approvers = new Set<String>();
        approvers.add(request.Approver__c);
        if(!request.Realignment_Request_Items__r.isEmpty()){
            Account account = [SELECT Id, Name, Owner.Region__c,Owner.Sub_Region__c FROM Account WHERE Id =: request.Realignment_Request_Items__r[0].Account__c];
            approvers.addAll(AccountRealignmentUtility.getBusinessManagers(account));
        }
        return approvers;
    }
    
    private static Account_Realignment_Request__c getRequestDetails(String recordId){
        Account_Realignment_Request__c request = [SELECT Id, 
                                                  Name, 
                                                  Approver__c, 
                                                  Status__c,
                                                  Approver_Type__c,
                                                  (SELECT Id, 
                                                   Name, 
                                                   Account__c, 
                                                   Account__r.Name, 
                                                   Account__r.Company_Number__c,
                                                   Submitter__c, 
                                                   Submitted_date__c, 
                                                   Previous_Account_Owner__c, 
                                                   Previous_Account_Owner__r.Name, 
                                                   Previous_Account_Owner__r.UserRole.Name, 
                                                   Previous_Account_Owner__r.IsActive, 
                                                   New_Account_Owner__c, 
                                                   New_Account_Owner__r.Name, 
                                                   New_Account_Owner__r.UserRole.Name, 
                                                   New_Account_Owner__r.IsActive, 
                                                   Request_Status__c, 
                                                   Approver_Comments__c, 
                                                   Move_Date__c, 
                                                   Account_Number__c, 
                                                   Reason_for_Move__c 
                                                   FROM Realignment_Request_Items__r) 
                                                  FROM Account_Realignment_Request__c WHERE Id =: recordId LIMIT 1];
        return request;
    }
}