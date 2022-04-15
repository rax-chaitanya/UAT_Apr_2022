public with sharing class CompensationInfoController {
    @AuraEnabled
    public static String partnerLevelType(){
        Id accountId = [Select name,id,contactid,AccountId from User where id =: UserInfo.getUserId()].AccountId;
        Account company=[SELECT Id,Partner_Level__c FROM Account WHERE  id = : accountId ];
        return String.valueOf(company.Partner_Level__c);
          
    }
}