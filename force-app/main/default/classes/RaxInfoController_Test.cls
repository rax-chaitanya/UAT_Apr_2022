@isTest(seeAllData=true) 
public class RaxInfoController_Test {   
    private static testmethod void RaxInfoControllerTest(){ 
        Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId(); 
        Id conRID= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId(); 
        Account a1 = new Account(Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =system.today(),Partner_Level__c='Reseller',RecordTypeId= accRID,Name='Test Account1234',BillingCountry='India',ShippingCountry='India',Enforce_Pilot_Agreement__c =true,Enforced_Pilot_Agreement_Ids__c='1',Pilot_Agreement_Ids__c='1');
        insert a1;
        Contact c = new Contact(RecordTypeId= conRID,firstname='Test Contact',LastName='Test Last',AccountId=a1.id,Email = System.now().millisecond() + 'test@test.com');
        insert c;
        a1.Primary_Member__c = c.Id;
        update a1;
        Profile portalProfile = [select Id from Profile where UserType = 'PowerPartner' limit 1];
        User user1 = new User(Username = System.now().millisecond() + 'test1234566@test.com',
                              SSO_Username__c='testP1234',FederationIdentifier='test1234',
                              ContactId = c.Id,ProfileId = portalProfile.Id,Alias = 'test123',
                              Email = 'test1234555576@test.com',EmailEncodingKey = 'UTF-8',
            				  Title = 'title',Region__c = 'US',Group__c = 'US Other',
                              LastName = 'RaxTesty',CommunityNickname = System.now().millisecond() + 'test12345',
                              TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US');
        Database.insert(user1);
        System.runAs(user1){  
            Test.StartTest();      
            String str = RaxInfoController.raxinfo(); 
            Test.StopTest(); 
            //System.assertEquals(str,'NotSigned');           
        } 
    }
     
     private static testmethod void RaxInfoControllerTest1(){ 
        Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId(); 
        Id conRID= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId(); 
        Account a1 = new Account(Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =System.today(),Partner_Level__c='Referral',RecordTypeId= accRID,Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert a1;
        Contact c = new Contact(RecordTypeId= conRID,firstname='Test Contact',LastName='Test Last',AccountId=a1.id,Email = System.now().millisecond() + 'test@test.com');
        insert c;
        a1.Primary_Member__c = c.Id;
        update a1;
        Profile portalProfile = [select Id from Profile where UserType = 'PowerPartner' limit 1];
        User user1 = new User(Username = System.now().millisecond() + 'test12345fdf@test.com',SSO_Username__c='test12345434',FederationIdentifier='jghfh8858',ContactId = c.Id,ProfileId = portalProfile.Id,Alias = 'test123',Email = 'test12345rer543545@test.com',EmailEncodingKey = 'UTF-8',LastName = 'RaxTesty',CommunityNickname = System.now().millisecond() + 'test12345',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
        Database.insert(user1);
        System.runAs(user1){  
            Test.StartTest();      
            String str = RaxInfoController.raxinfo(); 
            Test.StopTest(); 
            //System.assertEquals(str,'NotSigned');           
        } 
    }
    private static testmethod void RaxInfoControllerTest2(){ 
        Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId(); 
        Id conRID= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId(); 
        Account a1 = new Account(Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =null,Partner_Level__c='Referral',RecordTypeId= accRID,Name='Test Account1234',BillingCountry='India',ShippingCountry='India',onboard_step__c='agreements',phone='1231231234');
        insert a1;
        Contact c = new Contact(RecordTypeId= conRID,firstname='Test Contact',LastName='Test Last',AccountId=a1.id,Email = System.now().millisecond() + 'test@test.com');
        insert c;
        a1.Primary_Member__c = c.Id;
        update a1;
        Profile portalProfile = [select Id from Profile where UserType = 'PowerPartner' limit 1];
        User user1 = new User(Username = System.now().millisecond() + 'test12345fdsf43@test.com',SSO_Username__c='test1234655',FederationIdentifier='test12346',ContactId = c.Id,ProfileId = portalProfile.Id,Alias = 'test123',Email = 'test12345fdsf6565@test.com',EmailEncodingKey = 'UTF-8',LastName = 'RaxTesty',CommunityNickname = System.now().millisecond() + 'test12345',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US',phone='1234567890');
        Database.insert(user1);
        System.runAs(user1){  
            Test.StartTest();      
            String str = RaxInfoController.raxinfo();
            Integer integ = RaxInfoController.getOnboarding(); 
            Test.StopTest(); 
            //System.assertEquals(str,'NotSigned');           
        } 
    }
}