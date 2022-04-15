@isTest
public class AccountRedirectController_Test {
 @isTest
    static void getAccountIdTest(){
        
      Account comp = new Account(Name = 'test', BillingCountry = 'United States', ShippingCountry = 'United States',RecordTypeId =Label.Standard_Company_RecordTypeId);
                insert comp;
        
        Account acc = [Select Id,Company_Number__c from Account where Company_Name__c =: comp.Id];
       // acc.Account_Number__c = '5687864';
        update acc;
        
       String accId = AccountRedirectController.getAccountId(acc.Company_Number__c);
        
       // System.assert(accId == acc.Id);
        String accId1 = AccountRedirectController.getAccountId('');
        
        System.assert(accId1 == null);
        
    }
}