public without sharing class PaymentController {
    @auraenabled
    Public static Object getUrls(){
        Map<String,List<sObject>> result = new Map<String,List<sObject>>();
        result.put('territoryCountry',getCountryTerritory());
        //result.put('country',getCountry());
        result.put('W9Urls',getDUrls('w9'));
        result.put('supplierUrls',getDUrls('supplier'));
        result.put('achUrls',getDUrls('ach'));
        return result;
    }
    @auraenabled
    Public static List<sobject> getDUrls(String searchStr){
        
        List<ContentDistribution> listDistributions = new List<ContentDistribution>([SELECT Id, Name, ContentDownloadUrl, ContentDocumentId FROM ContentDistribution Where Name Like : '%'+searchStr+'%' AND ContentDocumentId In(SELECT Id FROM ContentDocument Where ParentId =:Label.PaymentFormsFolder)]);
        
        return listDistributions;
    }
   
    Public static List<User> getCountryTerritory(){
        List<User> partnerUser = new List<User>();

        partnerUser = [Select Id,AccountId,Account.Territory__c,Account.BillingCountry From User Where Id =: UserInfo.getUserId() Limit 1];
        
        
        
        return partnerUser;
    }
}