public without sharing class GAR_MoveDateController {

    private static final String SYSTEM_ADMINISTRATOR = 'System Administrator';
    
    @AuraEnabled
    public static Object validateAndLoadRecord(Id recordId){
        Map<String, Object> result = new Map<String, Object>();
        result.put('isSuccess', false);
        result.put('Today', ''+Date.today().year()+'-'+Date.today().month()+'-'+Date.today().day());
        Realignment_Request_Item__c item = [SELECT Id, 
                                           Account__c, 
                                            Account__r.type__c, 
                                            Move_Date__c, 
                                            Processed__c,
                                            Request_Status__c,
                                            Account_Realignment_Request__c, 
                                            Account_Realignment_Request__r.Approver__c, 
                                            Submitter__c, 
                                            Account_Realignment_Request__r.Approver__r.Region__c, Account_Realignment_Request__r.Approver_Type__c, 
                                            Previous_Account_Owner__c,
                                            Previous_Account_Owner__r.Region__c
                                            FROM Realignment_Request_Item__c 
                                            WHERE Id =: recordId LIMIT 1];
        if(item.Processed__c || item.Request_Status__c == 'Rejected'){
            result.put('Message', 'Realignemnt Move Date cannot be changed for this record');
            return result;
        }
        Account account = new Account(
          Id = item.Account__c  
        );
        account.Owner = new User(
            Id = item.Previous_Account_Owner__c,
            Region__c = item.Previous_Account_Owner__r.Region__c
        );
        List<String> validBusinessManagers = AccountRealignmentUtility.getBusinessManagers(account);
        validBusinessManagers = validBusinessManagers == null ? new List<String>() : validBusinessManagers;
        User loggedInUser = [SELECT Id, Name, Profile.Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        if(validBusinessManagers.contains(UserInfo.getUserId()) || SYSTEM_ADMINISTRATOR.equalsIgnoreCase(loggedInUser.Profile.Name)){
            result.put('Record', item);
            result.put('isSuccess', true);
        }
        else if(item.Account_Realignment_Request__r.Approver__c == UserInfo.getUserId() && (item.Request_Status__c != 'Approved' || item.Request_Status__c != 'Auto Approved')){
            result.put('Record', item);
            result.put('isSuccess', true);
        }else{
            result.put('Message', 'You are not allowed to change the Realignemnt Move Date');
        }
        return result;
    }
    
    @AuraEnabled
    public static void saveRecord(Realignment_Request_Item__c record){
        System.debug('record :'+record);
        Database.update(record);
    }
}