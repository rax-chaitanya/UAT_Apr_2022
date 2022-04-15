@isTest
public class EventHandler_Test {
    @testSetup
    public static void testSetup(){
        UserRole usr = new UserRole (Name = 'US Commercial SMB - ATX 1');
        insert usr;
        UserRole SARole = [Select Id,Name from UserRole Where Name =: 'US Commercial SMB - ATX 1' AND Name LIKE '%US Commercial SMB - ATX 1%' LIMIT 1];
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
            UserRoleId = SARole.Id,
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
            UserRoleId = SARole.Id,
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
            UserRoleId = SARole.Id,
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
         Account account =new Account(Name='TestAccount111', Company_Name__c=company.Id, OwnerId=testOwner1.Id,Named_Account__c='ABM');
            insert account;
            Contact con = new Contact(FirstName = 'Rackspace', LastName = 'Test Contact', AccountId = company.id);
            Insert con;
            
            Lead lead = TestDataFactory.createLead('TestLead123');
            Delete triggerManagers;
            TestDataFactory.triggerManagerFlagValue  = true;
            TestDataFactory.getTriggerManagers();
            TestDataFactory.createActivityTriggerSettings();
        }
    }
    
    @isTest
    public static void testMethod1(){
        User adminUser = [SELECT Id, Name FROM User WHERE LastName = 'testAdminUser123' AND IsActive = true limit 1];
        User testOwner1 = [SELECT Id, Name FROM User WHERE LastName = 'testOwner1' AND IsActive = true limit 1];
        User testOwner2 = [SELECT Id, Name FROM User WHERE LastName = 'testOwner2' AND IsActive = true limit 1];
        Account account = [SELECT Id, Name FROM Account WHERE Name = 'TestAccount111' LIMIT 1];
        Contact contact = [SELECT Id, Name FROM Contact WHERE LastName = 'Test Contact' LIMIT 1];
        Lead lead = [SELECT Id, Name FROM Lead WHERE LastName = 'TestLead123' LIMIT 1];
        System.runAs(adminUser){
            
            List<Realignment_Request_Item__c> requestItems = new List<Realignment_Request_Item__c>();
            requestItems.add(new Realignment_Request_Item__c(
         
                
               Account__c = account.Id,
                Move_Date__c = System.today(),
                New_Account_Owner__c = testOwner2.Id,
                Previous_Account_Owner__c = testOwner1.Id,
                Request_Status__c = 'New',
                Reason_for_Move__c = 'New Rep'
            ));
           // AccountRealignmentUtility.process(requestItems);
            
            Test.startTest();
            Event ts = new Event(Subject='Test Task',  Whoid= contact.id,StartDateTime=datetime.now(),EndDateTime=datetime.now());
           Insert ts;        
            Update ts;        

            
            
            Event lts = new Event(Subject='Lead Task',  Whoid= lead.id,StartDateTime=datetime.now(),EndDateTime=datetime.now());
            Insert lts;
            Test.stopTest();
        }
    }
    
    @isTest
    public static void testMethod2(){
        User adminUser = [SELECT Id, Name FROM User WHERE LastName = 'testAdminUser123' AND IsActive = true limit 1];
        User testOwner1 = [SELECT Id, Name FROM User WHERE LastName = 'testOwner1' AND IsActive = true limit 1];
        User testOwner2 = [SELECT Id, Name FROM User WHERE LastName = 'testOwner2' AND IsActive = true limit 1];
       Account account = [SELECT Id, Name FROM Account WHERE Name = 'TestAccount111' LIMIT 1];
        Contact contact = [SELECT Id, Name FROM Contact WHERE LastName = 'Test Contact' LIMIT 1];
        Lead lead = [SELECT Id, Name FROM Lead WHERE LastName = 'TestLead123' LIMIT 1];
        String FMWFoundationUserId = System.Label.FMWFoundationUser;
        System.runAs(new User(Id = FMWFoundationUserId)){
            Test.startTest();
           Event ts = new Event(Subject='Test Task',  Whoid= contact.id,StartDateTime=datetime.now(),EndDateTime=datetime.now());
            Insert ts;        
           Update ts;        
            Delete ts;
            
            Event lts = new Event(Subject='Lead Task',  Whoid= lead.id,StartDateTime=datetime.now(),EndDateTime=datetime.now());
            Insert lts;
            Test.stopTest();
        }
    }
    
}