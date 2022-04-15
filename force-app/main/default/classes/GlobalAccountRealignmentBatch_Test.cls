@isTest
public class GlobalAccountRealignmentBatch_Test {
    @testSetup
    public static void testSetup(){
        //UserRole SARole = [Select Id,Name from UserRole Where Name LIKE '%US Commercial SMB - ATX 1%' LIMIT 1];
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
            //UserRoleId = SARole.Id,
            Region__c = 'AMER',
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
            //UserRoleId = SARole.Id,
            ManagerId = adminUser.Id,
            Group__c = 'US Other',
            Region__c = 'AMER'
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
            //UserRoleId = SARole.Id,
            ManagerId = adminUser.Id,
            Group__c = 'US Other',
            Region__c = 'AMER'
        );
        Insert new List<User>{testOwner1, testOwner2};
            
            Account company;
        System.runAs(adminUser){
            TestDataFactory.getOrgConstants();
            
            TestDataFactory.triggerManagerFlagValue  = false;
            List<Trigger_Manager__c> triggerManagers = TestDataFactory.getTriggerManagers();
            
            company = TestDataFactory.createCompany('TestCompany111');
           Account account = TestDataFactory.createAccount('TestAccount111', company.Id, testOwner1.Id);
            
            Delete triggerManagers;
            TestDataFactory.triggerManagerFlagValue  = true;
            TestDataFactory.getTriggerManagers();
        }
    }
    
    @isTest
    public static void testMethod1(){
        User adminUser = [SELECT Id, Name FROM User WHERE LastName = 'testAdminUser123' AND IsActive = true limit 1];
        User testOwner1 = [SELECT Id, Name FROM User WHERE LastName = 'testOwner1' AND IsActive = true limit 1];
        User testOwner2 = [SELECT Id, Name FROM User WHERE LastName = 'testOwner2' AND IsActive = true limit 1];
        Account account = [SELECT Id, Name FROM Account WHERE Name = 'TestAccount111' LIMIT 1];
        System.runAs(adminUser){
            
            Account_Realignment_Request__c request = new Account_Realignment_Request__c(
                Approver__c = Userinfo.getUserId() ,
                Status__c = 'Approved',
                Submitted_date__c =Date.Today(),
                Approver_Type__c = 'Business Manager'
            );
            insert request;
            List<Realignment_Request_Item__c> requestItems = new List<Realignment_Request_Item__c>();
            requestItems.add(new Realignment_Request_Item__c(
                Account_Realignment_Request__c = request.id,
                Account__c = account.Id,
                Move_Date__c = System.today(),
                New_Account_Owner__c = testOwner2.Id,
                Previous_Account_Owner__c = testOwner1.Id,
                Request_Status__c  = 'Approved',
                Reason_for_Move__c = 'New Rep'
            ));
            insert requestItems;
            Test.startTest();
                String CRON_EXP = '0 0 0 3 9 ? 2022';
                String jobId = System.schedule('GlobalAccountRealignmentBatchTest', CRON_EXP, new GlobalAccountRealignmentBatch());
                CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId]; 
                System.assertEquals(0, ct.TimesTriggered); 
                System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime)); 
            Test.stopTest();
            
        }
    }
}