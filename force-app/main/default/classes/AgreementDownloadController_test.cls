@isTest(seeAllData=true)
public class AgreementDownloadController_test {
    private static testmethod void agreementDownloadTest(){ 
        Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId(); 
        Id conRID= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId();         
        Account a1 = new Account(Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =system.today(),Partner_Level__c='Reseller',RecordTypeId= accRID,Name='Test Account1234',BillingCountry='India',ShippingCountry='India', Contract_Type__c = 'Global Strategic Partner Agreement (RGS Only)',Contact_Status__c ='Active');
        insert a1;
        Contact c = new Contact(RecordTypeId= conRID,firstname='Test Contact',LastName='Test Last',AccountId=a1.id,Email = System.now().millisecond() + 'test@test.com');
        insert c;
        a1.Primary_Member__c = c.Id;
        update a1;
        Profile portalProfile = [select Id from Profile where UserType = 'PowerPartner' limit 1];
        User user1 = new User(Username = System.now().millisecond() + 'test1234566@test.com',SSO_Username__c='testP1234',FederationIdentifier='test1234',ContactId = c.Id,ProfileId = portalProfile.Id,Alias = 'test123',Email = 'test1234555576@test.com',EmailEncodingKey = 'UTF-8',LastName = 'RaxTesty',CommunityNickname = 'test12345',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
        Database.insert(user1);
        System.runAs(user1){  
            Test.StartTest();      
            Account acc = AgreementDownloadController.getPartnerType();
            List<String> str2 = AgreementDownloadController.getAgreements(new List<String>{acc.Partner_Level__c});
            acc.Contract_Type__c = 'Global Strategic Partner Agreement (RGS Only)';
            Test.StopTest(); 
           // System.assertNotEquals(true, str2.size()>0);
        } 
    }
  
}