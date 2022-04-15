@isTest(seeAllData=true)
public class AgreementController_Test {
 
static testMethod Void agreementTest (){
    UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
    Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
    User pAOwner1 = new User( UserRoleId = portalRole.Id,ProfileId = profile1.Id,Username = System.now().millisecond() + 'test2@test.com',Alias = 'rax',Email='rax.space@company.com',EmailEncodingKey='UTF-8',Firstname='rax',Lastname='space',phone='1234567890',LanguageLocaleKey='en_US',LocaleSidKey='en_US',TimeZoneSidKey='America/Chicago');
    Database.insert(pAOwner1);
    Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId(); 
    Id conRID= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId(); 
    System.runAs(pAOwner1){  
       
        
        Account a1 = new Account(Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =system.today(),Partner_Level__c='Reseller',RecordTypeId= accRID,OwnerId = pAOwner1.Id,Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
         System.debug('@@@account values are'+a1.Name);
        insert a1;
       
        Contact c = new Contact(RecordTypeId= conRID,firstname='Test Contact',LastName='Test Last',AccountId=a1.id,Email = System.now().millisecond() + 'test@test.com');
        insert c;
        a1.Primary_Member__c = c.Id;
        update a1;
        Profile portalProfile = [select Id from Profile where UserType = 'PowerPartner' limit 1];
        User user1 = new User(Username = System.now().millisecond() + 'test12345@test.com',ContactId = c.Id,ProfileId = portalProfile.Id,Alias = 'test123',Email = 'test12345@test.com',EmailEncodingKey = 'UTF-8',LastName = 'RaxTesty',CommunityNickname = 'test12345',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
        Database.insert(user1);
    }
    
    User u = [Select Id From User Where Email = 'test12345@test.com' Limit 1];        
    System.runAs(u){  
        Test.StartTest();
        try{
            AgreementController agreement = new AgreementController();
            agreement.gotoPortal();
        }catch(Exception ex){}
    }
    Test.StopTest();
}
static testMethod Void agreementTest1 (){
UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
    Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
    User pAOwner1 = new User( UserRoleId = portalRole.Id,ProfileId = profile1.Id,Username = System.now().millisecond() + 'test2@test.com',Alias = 'rax',Email='rax.space@company.com',EmailEncodingKey='UTF-8',Firstname='rax',Lastname='space',phone='1234567890',LanguageLocaleKey='en_US',LocaleSidKey='en_US',TimeZoneSidKey='America/Chicago');
    Database.insert(pAOwner1);
    Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId(); 
    Id conRID= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId(); 
    System.runAs(pAOwner1){  
           
        Account a1 = new Account(Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =system.today(),Partner_Level__c='Referral',RecordTypeId= accRID,OwnerId = pAOwner1.Id,Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert a1;
        Contact c = new Contact(RecordTypeId= conRID,firstname='Test Contact',LastName='Test Last',AccountId=a1.id,Email = System.now().millisecond() + 'test@test.com');
        insert c;
        a1.Primary_Member__c = c.Id;
        update a1;
        Profile portalProfile = [select Id from Profile where UserType = 'PowerPartner' limit 1];
        User user1 = new User(Username = System.now().millisecond() + 'hhdgjfj@test.com',ContactId = c.Id,ProfileId = portalProfile.Id,Alias = 'test123',Email = 'test12345@test.com',EmailEncodingKey = 'UTF-8',LastName = 'RaxTesty',CommunityNickname = 'test12345',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
        Database.insert(user1);
    }
    
        User u = [Select Id From User Where Email = 'test12345@test.com' Limit 1];        
            System.runAs(u){  
                Test.StartTest();
                try{
                    AgreementController agreement = new AgreementController();
                    agreement.gotoPortal();
                }catch(Exception ex){}
            }
            Test.StopTest();
}
Static testMethod Void agreementTest3 (){
UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
    Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
    User pAOwner1 = new User( UserRoleId = portalRole.Id,ProfileId = profile1.Id,Username = System.now().millisecond() + 'test2@test.com',Alias = 'rax',Email='rax.space@company.com',EmailEncodingKey='UTF-8',Firstname='rax',Lastname='space',phone='1234567890',LanguageLocaleKey='en_US',LocaleSidKey='en_US',TimeZoneSidKey='America/Chicago');
    Database.insert(pAOwner1);
    Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId(); 
    Id conRID= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId(); 
    System.runAs(pAOwner1){  
            
        Account a1 = new Account(Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =system.today(),Partner_Level__c='Referral/Reseller',RecordTypeId= accRID,OwnerId = pAOwner1.Id,Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert a1;
        Contact c = new Contact(RecordTypeId= conRID,firstname='Test Contact',LastName='Test Last',AccountId=a1.id,Email = System.now().millisecond() + 'test@test.com');
        insert c;
        a1.Primary_Member__c = c.Id;
        update a1;
        Profile portalProfile = [select Id from Profile where UserType = 'PowerPartner' limit 1];
        User user1 = new User(Username = System.now().millisecond() + 'test12345@test.com',ContactId = c.Id,ProfileId = portalProfile.Id,Alias = 'test123',Email = 'test12345@test.com',EmailEncodingKey = 'UTF-8',LastName = 'RaxTesty',CommunityNickname = 'test12345',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
        Database.insert(user1);
    }
    
    User u = [Select Id From User Where Email = 'test12345@test.com' Limit 1];        
    System.runAs(u){  
        Test.StartTest();
        try{
            AgreementController agreement = new AgreementController();
            agreement.gotoPortal();
        }catch(Exception ex){}
    }
    Test.StopTest();
}

}