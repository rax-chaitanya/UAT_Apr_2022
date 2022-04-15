@isTest
public class PartnerLeadSharingRecalculation_Test {

     @isTest
    static void createPartnerUser(){
        
        TestClassUtility.setTestSetupData();            
        Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId(); 
        Id conRID= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId(); 
        Id rtIdLead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead').getRecordTypeId(); 
        Account a = new Account(Partner_Account_Status__c='Approved',Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =System.today(),Partner_Level__c='Referral',RecordTypeId= accRID,Name='Test Account12345',BillingCountry='India',ShippingCountry='India');
        insert a;  
        Account a1 = new Account(ParentId=a.Id,Partner_Account_Status__c='Approved',Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =system.today(),Partner_Level__c='Reseller',RecordTypeId= accRID,Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert a1;
        Contact c = new Contact(RecordTypeId= conRID,firstname='Test Contact',LastName='Test Last',AccountId=a1.id,Email = System.now().millisecond() + 'test@test.com');
        insert c;
        a1.Primary_Member__c = c.Id;
        update a1;
        Lead l = new Lead(Partner_Company__c=a1.Id,firstname='Testfirst1',lastname='lastname1',company='Test company1',
                          email='test.test1@test.com',LeadSource='Chat',Lead_Type__c='AWS',AnnualRevenue = 100.00,
                         Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',
                          country='India',postalcode='560037',Type_Of_Deal__c ='Referral',RecordTypeId = rtIdLead); 
         insert l;
        Profile portalProfile = [select Id from Profile where UserType = 'PowerPartner' limit 1];
        User user1 = new User(Username = System.now().millisecond() + 'test1234566@test.com',SSO_Username__c='testP1234',FederationIdentifier='test1234',ContactId = c.Id,ProfileId = portalProfile.Id,Alias = 'test123',Email = 'test1234555576@test.com',EmailEncodingKey = 'UTF-8',LastName = 'RaxTesty',CommunityNickname = 'test12345',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
        Database.insert(user1);
        Test.startTest();
        DataBase.executeBatch(new PartnerLeadSharingRecalculation());
        
        List<LeadShare> lshares = [Select Id from LeadShare where leadId =: l.Id];
        System.assert(lshares.size() > 0);
        Test.stopTest();
    }
}