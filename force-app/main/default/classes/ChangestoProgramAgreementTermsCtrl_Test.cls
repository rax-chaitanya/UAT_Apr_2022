/**

* Created Date: 08/06/2020
* Description:  Test Class for ChangestoProgramAgreementTermsController 
*  
* */

@isTest(seeAllData=true)
private class ChangestoProgramAgreementTermsCtrl_Test {
    static testMethod void validateRecords() {
        Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId(); 
        Id conRID= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId(); 
        
        Account a1 = new Account(Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =system.today(),Partner_Level__c='Referral',Program_Of_Interest__c='Referral Only',RecordTypeId= accRID,Name='Test Account1234',BillingCountry='India',ShippingCountry='India',Contract_Type__c='LATAM Referral Agreement');
        insert a1;
        
        Contact c = new Contact(RecordTypeId= conRID,firstname='Test Contact1',LastName='Test Last1',AccountId=a1.id,Email = System.now().millisecond() + 'test1@test.com',phone='123456789');
        insert c;
        
        a1.Primary_Member__c = c.Id;
        
        update a1;
        Test.startTest();
        runByUSer(c.id);
        Test.stopTest();  
    }
    
    
    @future
    private static void runByUSer(ID conid)
    {
        Profile portalProfile = [select Id from Profile where UserType = 'PowerPartner'].get(2);
        User user = new User(Username = System.now().millisecond() + 'test12345667@test.com',SSO_Username__c='testP12347',FederationIdentifier='test12347',ContactId = conid,ProfileId = portalProfile.Id,Alias = 'test1237',Email = 'test12345555767@test.com',EmailEncodingKey = 'UTF-8',LastName = 'RaxTesty1',CommunityNickname = 'test123457',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
        Database.insert(user);
        System.runAs(user){ 
            ChangestoProgramAgreementTermsController.getPatRecords(10);
            ChangestoProgramAgreementTermsController.loadPatRecords(10,1);
        }
    }
    
}