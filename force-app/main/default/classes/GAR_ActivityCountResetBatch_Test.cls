@isTest
public class GAR_ActivityCountResetBatch_Test {
    @testSetup
    public static void testSetup(){
     //   UserRole SARole = [Select Id,Name from UserRole Where Name LIKE '%US Commercial SMB - ATX 1%' LIMIT 1];
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' limit 1];
        user adminUser = new User(
            ProfileId = adminProfile.Id,
            LastName = 'testAdminUser123',
            Email = 'puser000@amamama.com',
            Username = 'adminuser@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
       //     UserRoleId = SARole.Id,
            Region__c = 'US',
            Group__c = 'US Other'
        );
        Insert adminUser;
        
        User testOwner1 = new User(
            ProfileId = adminProfile.Id,
            LastName = 'testOwner1',
            Email = 'puser000@amamama.com',
            Username = 'testowner1@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
       //     UserRoleId = SARole.Id,
            ManagerId = adminUser.Id,
            Group__c = 'US Other',
            Region__c = 'US'
        );
        User testOwner2 = new User(
            ProfileId = adminProfile.Id,
            LastName = 'testOwner2',
            Email = 'puser000@amamama.com',
            Username = 'testowner2@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
        //    UserRoleId = SARole.Id,
            ManagerId = adminUser.Id,
            Group__c = 'US Other',
            Region__c = 'US'
        );
        Insert new List<User>{testOwner1, testOwner2};
            
            Account company;
        System.runAs(adminUser){
            TestDataFactory.getOrgConstants();
            
            TestDataFactory.triggerManagerFlagValue  = false;
            List<Trigger_Manager__c> triggerManagers = TestDataFactory.getTriggerManagers();
            
            company = TestDataFactory.createCompany('TestCompany111');
            Account account =new Account(Name='TestAccount111',Named_Account__C='ABM',Company_Name__c=company.Id, OwnerId=testOwner1.Id,RecordTypeId = Label.Account_Prospect_RecordType_ID);
            insert account;
            Delete triggerManagers;
            TestDataFactory.triggerManagerFlagValue  = true;
            TestDataFactory.getTriggerManagers();
        }
    }
    
    @isTest
    public static void testMethod1(){
        User adminUser = [SELECT Id, Name FROM User WHERE LastName = 'testAdminUser123' AND IsActive = true limit 1];
        Account account = [SELECT Id, Name FROM Account WHERE Name = 'TestAccount111' LIMIT 1];
        System.runAs(adminUser){
            
            Test.startTest();          
                String CRON_EXP = '0 0 0 3 9 ? 2022';
                String jobId = System.schedule('GAR_ActivityCountResetBatchTest', CRON_EXP, new GAR_ActivityCountResetBatch());
                CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];  
                System.assertEquals(0, ct.TimesTriggered); 
                System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime)); 
            Test.stopTest();   
        } 
    }
}