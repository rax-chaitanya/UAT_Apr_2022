public class RealignmentRequestItemHelper{
    public static void processAccounts(){
        //Commented For GTMO-608
        if(AccountRealignmentUtility.canProcessRealignmentRequests() || Test.isRunningTest()){
            Map<Id,Account> AccountOwnerUpdateMap = new Map<Id,Account>();
            for(Realignment_Request_Item__c requestItem : (List<Realignment_Request_Item__c>)Trigger.new){
                if((requestItem.Request_Status__c == 'Approved' || requestItem.Request_Status__c == 'Auto Approved') && requestItem.Move_Date__c <= Date.today() && !requestItem.Processed__c){
                    AccountOwnerUpdateMap.put(requestItem.Account__c,new Account(
                        Id = requestItem.Account__c,
                        OwnerId= requestItem.New_Account_Owner__c,
                        ByPassGARProcessing__c = System.now()
                    ));
                    requestItem.Processed__c = true;
                }
            }
            Database.update(AccountOwnerUpdateMap.values());
        }
    }
    
    public static void processEmailNotifications(){
        Map<Id, Map<String, Set<Id>>> emailItemMap = new Map<Id, Map<String, Set<Id>>>();
        for(Realignment_Request_Item__c requestItem : (List<Realignment_Request_Item__c>)Trigger.new){
            Realignment_Request_Item__c oldRecord = ((Map<Id, Realignment_Request_Item__c>)Trigger.oldMap).get(requestItem.Id);
            if(requestItem.Processed__c && !oldRecord.Processed__c){
                populateEmailItemMap(emailItemMap, requestItem);
            }
        }
        if(!emailItemMap.isEmpty()){
            
            List<GAR_Email_Recipient__c> emailRecipients = new List<GAR_Email_Recipient__c>();
            List<GAR_Email_Item__c> emailItems = new List<GAR_Email_Item__c>();
            
            for(Id requestId : emailItemMap.keySet()){
                for(String recipientUser : emailItemMap.get(requestId).keySet()){
                    String recipientType = recipientUser.substringBefore(':');
                    String recipientUserId = recipientUser.substringAfter(':');
                    GAR_Email_Recipient__c recipient = new GAR_Email_Recipient__c(
                        Recipient__c = recipientUserId,
                        Recipient_Type__c = recipientType,
                        Account_Realignment_Request__c = requestId
                    );
                    emailRecipients.add(recipient);
                    for(Id requestItemId : emailItemMap.get(requestId).get(recipientUser)){
                        emailItems.add(new GAR_Email_Item__c(
                            Realignment_Request_Item__c = requestItemId,
                            GAR_Email_Recipient__r = recipient
                        ));
                    }
                }
            }
            
            Database.insert(emailRecipients);
            for(GAR_Email_Item__c emailItem : emailItems){
                emailItem.GAR_Email_Recipient__c = emailItem.GAR_Email_Recipient__r.Id;
            }
            Database.insert(emailItems);
            for(GAR_Email_Recipient__c emailRecipient : emailRecipients){
                emailRecipient.Ready_to_send__c = true;
            }
            Database.update(emailRecipients);
        }
    }
    
    private static void populateEmailItemMap(Map<Id, Map<String, Set<Id>>> emailItemDS, Realignment_Request_Item__c requestItem){
        
        if(!emailItemDS.containsKey(requestItem.Account_Realignment_Request__c)){
            emailItemDS.put(requestItem.Account_Realignment_Request__c, new Map<String, Set<Id>>());
        }
        
        Map<String, Set<Id>> emailItemMap = emailItemDS.get(requestItem.Account_Realignment_Request__c);
        
        //PREVIOUS OWNER
        String recipientKey = 'Previous Owner:' + requestItem.Previous_Account_Owner__c;
        addEmailItem(emailItemMap, requestItem.Previous_Account_Owner__c, recipientKey, requestItem);
        
        
        //NEW OWNER
        recipientKey = 'New Owner:' + requestItem.New_Account_Owner__c;
        addEmailItem(emailItemMap, requestItem.New_Account_Owner__c, recipientKey, requestItem);
        
        //OWNER'S COMMON MANAGER
        if(requestItem.Previous_Account_Owners_Manager__c == requestItem.New_Account_Owners_Manager__c){
            recipientKey = 'Owners Common Manager:' + requestItem.Previous_Account_Owners_Manager__c;
            addEmailItem(emailItemMap, requestItem.Previous_Account_Owners_Manager__c, recipientKey, requestItem);
        }
        //OWNER'S INDIVIDUAL MANAGERS
        else{
            
            //PREVIOUS OWNER'S MANAGER
            recipientKey = 'Previous Owners Manager:' + requestItem.Previous_Account_Owners_Manager__c;
            addEmailItem(emailItemMap, requestItem.Previous_Account_Owners_Manager__c, recipientKey, requestItem);
            
            
            //NEW OWNER'S MANAGER
            recipientKey = 'New Owners Manager:' + requestItem.New_Account_Owners_Manager__c;
            addEmailItem(emailItemMap, requestItem.New_Account_Owners_Manager__c, recipientKey, requestItem);
            
        }
    }
    
    private static void addEmailItem(Map<String, Set<Id>> emailItemMap, Id recipientId, String recipientKey, Realignment_Request_Item__c requestItem){
        if(recipientId!=null){
            if(!emailItemMap.containsKey(recipientKey)){
                emailItemMap.put(recipientKey, new Set<Id>());
            }
            emailItemMap.get(recipientKey).add(requestItem.Id);
        }
    }
    
     //sfdc-6892: if the records more than 100 batch class will execute and this sync method will be executed from RealignmentRequestItemHandler
    public static void grantCompanyTeamMembership(){
        List<AccountTeamMember> teamMembers = new List<AccountTeamMember>();        
        for(Realignment_Request_Item__c requestItem : (List<Realignment_Request_Item__c>)Trigger.new){
            Realignment_Request_Item__c oldRecord = ((Map<Id, Realignment_Request_Item__c>)Trigger.oldMap).get(requestItem.Id);
            if(requestItem.Processed__c && !oldRecord.Processed__c){
                AccountTeamMember teamMember = new AccountTeamMember(
                    AccountId = requestItem.Company_ID__c,
                    UserId = requestItem.New_Account_Owner__c,
                    ACCOUNTACCESSLEVEL = 'Edit',
                    OpportunityACCESSLEVEL = 'Edit',
                    ContacTACCESSLEVEL = 'Edit',
                    CaseACCESSLEVEL = 'Edit',
                    TeamMemberRole = 'Additional Sales Rep'    
                );
                teamMembers.add(teamMember);
            }
        }
        if(!teamMembers.isEmpty()){
            Database.insert(teamMembers, false);
        }
    }
    //SFDC-6892: To Reduce CPU Time Limit on Account realignment request Approval 
    //if the sync process executed then this future method will be invocked and reduce time execution
    //added by sundarayya e
    @future
    public static void grantCompTeamMemberFuture(Set<Id> rrItemIdSet){
        List<AccountTeamMember> teamMembers = new List<AccountTeamMember>();
        for(Realignment_Request_Item__c requestItem : [Select Id, Company_ID__c, New_Account_Owner__c from Realignment_Request_Item__c where Id IN : rrItemIdSet]){
            AccountTeamMember teamMember = new AccountTeamMember(
                AccountId = requestItem.Company_ID__c,
                UserId = requestItem.New_Account_Owner__c,
                ACCOUNTACCESSLEVEL = 'Edit',
                OpportunityACCESSLEVEL = 'Edit',
                ContacTACCESSLEVEL = 'Edit',
                CaseACCESSLEVEL = 'Edit',
                TeamMemberRole = 'Additional Sales Rep'
            );
            teamMembers.add(teamMember);
        }
        if(!teamMembers.isEmpty()){
            Database.insert(teamMembers, false);
        }
    }
    //sfdc-6892 ends
}