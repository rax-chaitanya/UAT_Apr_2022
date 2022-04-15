/**********************************************************************************
Author: Vinod Thupakula
Description: This test class is created for to cover the code of CompensationOwnerBatch class
Story: SFDC-2425  
**********************************************************************************/
@isTest
public class CompensationOwnerBatchTest{

@testSetup static void dataSetup(){

        
        UserRole Role = [Select Id From UserRole Where DeveloperName = 'Rackspace_Corporate' Limit 1];
        Profile sAdmin = [select Id from Profile where Name = 'System Administrator' limit 1];
        User admin = new User(UserRoleId =Role.Id, Username = System.now().millisecond() + 'test1234@test.com',SSO_Username__c='testP123',FederationIdentifier='test12334443',ProfileId = sAdmin.Id,Alias = 'test123',Email = 'test1234555576222@test.com',EmailEncodingKey = 'UTF-8',LastName = 'RaxTesty1',CommunityNickname = 'test123456',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
        Database.insert(admin);
        system.runAs(admin){
            TestClassUtility.setTestSetupData();
            Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId(); 
            Id conRID= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId();              
            Account a1 = new Account(OwnerId=userinfo.getuserid(),Partner_Account_Status__c='Approved',Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =system.today(),Partner_Level__c='Reseller',RecordTypeId= accRID,Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
            insert a1;
            a1.OwnerId = userinfo.getuserid();
            update a1;             
            Contact c = new Contact(OwnerId=userinfo.getuserid(),RecordTypeId= conRID,firstname='Test Contact',LastName='Test Last',AccountId=a1.id,Email = System.now().millisecond() + 'test@test.com');
            insert c;
            Profile portalProfile = [select Id from Profile where UserType = 'PowerPartner' limit 1];
            User user1 = new User(Username = System.now().millisecond() + 'test1234566@test.com',SSO_Username__c='testP1234',FederationIdentifier='test1234',ContactId = c.Id,ProfileId = portalProfile.Id,Alias = 'test123',Email = 'test1234555576@test.com',EmailEncodingKey = 'UTF-8',LastName = 'RaxTesty',CommunityNickname = 'test12345',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
            Database.insert(user1);            
        }
    }
    
    @isTest static void schedulejobtest(){
     user u = [Select Id From user Where Alias ='test123' limit 1];
     system.runAs(u){
         String CRON_EXP = '0 30 23 L * ? *'; 
         Test.StartTest();
         Id jobId = system.schedule('job 1', CRON_EXP, new CompensationOwnerBatch());
         Test.StopTest();
         CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId limit 1];
         System.assertEquals(CRON_EXP, ct.CronExpression);
     }
     
    }
    @isTest static void batchjobtest(){
     user u = [Select Id From user Where Alias ='test123' limit 1];
     system.runAs(u){
         Test.StartTest();
         database.executebatch(new CompensationOwnerBatch(),200);
         Test.StopTest();
         List<Compensation_Owner__c> c = [Select Id From Compensation_Owner__c];
         System.assertEquals(1, c.size());
     }
     
    }

}