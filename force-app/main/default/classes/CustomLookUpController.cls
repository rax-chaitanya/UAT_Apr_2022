/**
* Created Date: 08/18/2020
* Description:  Controller class for Partner Lead registration form will return Lead recordstype Id and list of records.
* Story : SFDC-4456
* Author : Sundarayya E
* */
public without sharing class CustomLookUpController {
    //method will return the default Lead record type for lead creation from partner portal
    @AuraEnabled        
    public static Id RecordTypeId(){
        //system.debug('Lead Record TypeId@@'+Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead').getRecordTypeId());
        return Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead').getRecordTypeId();
    }
   
    @AuraEnabled
    public static Map<Id, String> getChildAcc(){
        Boolean IsMasterAgent = false;
        Id userId = UserInfo.getUserId();
        
        Map<Id, String> accMap = new Map<Id, String>();
       // Map<Id, UserRecordAccess> HasAccessMap = new Map<Id,UserRecordAccess>();
        
        //List<Id> accIds = new List<Id>();
             
        //List<Account> accList = new List<Account>();
        List<User> userInfo = [Select Id, Name, ContactId, AccountId, Account.Partner_Level__c from User where Id =: userId];
        //system.debug('user details'+userInfo);
        if(userInfo[0].Account.Partner_Level__c == 'Master Agent'){
            //accIds.add(userInfo[0].AccountId);
            IsMasterAgent = true;
        }
        
        if(IsMasterAgent){
            List<Account> accList = [Select Id,Name,ParentId from Account where (Partner_Account_Status__c = 'Approved') and (ParentId =: userInfo[0].AccountId)
                                    ORDER BY Name ASC];
            //system.debug('accList'+);
            for(Account a : accList){
                //accList.add(a);
                //accIds.add(a.Id);
                if(!accMap.containsKey(a.id)){
                    accMap.put(a.Id, a.Name);
                }
            }
        }

        //accList.sort();
        //system.debug('Map values'+accMap);
        return accMap;
    }
    
}