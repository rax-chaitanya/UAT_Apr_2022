@isTest
public class AccountRealignmentUtility_Test{
    @testSetup
    public static void testSetup(){
        UserRole SARole = [Select Id,Name from UserRole Where Name LIKE '%US Commercial MM - ATX E1%' LIMIT 1];
        UserRole emeaRole = [Select Id,Name from UserRole Where Name LIKE '%UK Mid Market IB 3%' LIMIT 1];
        UserRole emeaMgrRole = [Select Id,Name from UserRole Where Name LIKE '%UK Mid Market IB 3 Leader%' LIMIT 1];
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
            Region__c = 'AMER',
            Group__c = 'US Other'
        );
        user emeaAdminUser2 = new User(
            ProfileId = adminProfile.Id,
            LastName = 'EmeaTestAdminUser123',
            Email = 'puser0002@amamama.com',
            Username = 'adminuser2@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'Europe/London',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = EmeaMgrRole.Id,
            Region__c = 'EMEA',
            Sub_Region__c = 'UK',
            Group__c = 'UK'
        );
        Insert new List<User>{adminUser,emeaAdminUser2};
        
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
            UserRoleId = SARole.Id,
            ManagerId = adminUser.Id,
            Group__c = 'US Other',
            Region__c = 'AMER'
        );
        //SFDC-7172, to test EMEA owners with subregion
        User testOwner3 = new User(
            ProfileId = adminProfile.Id,
            LastName = 'testOwner3',
            Email = 'testowner3@mail.com',
            Username = 'testowner3@mail.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'Europe/London',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = emeaRole.Id,
            ManagerId = emeaAdminUser2.Id,
            Group__c = 'UK',
            Region__c = 'EMEA',
            Sub_Region__c = 'UK'
        );
        User testOwner4 = new User(
            ProfileId = adminProfile.Id,
            LastName = 'testOwner4',
            Email = 'testowner4@mail.com',
            Username = 'testowner4@mail.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'Europe/London',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = emeaRole.Id,
            ManagerId = emeaAdminUser2.Id,
            Group__c = 'UK',
            Region__c = 'EMEA',
            Sub_Region__c = 'UK'
        );
        Insert new List<User>{testOwner1, testOwner2,testOwner3,testOwner4};
        
        Account company;
        Account emeaCompany;
        System.runAs(adminUser){
            TestDataFactory.getOrgConstants();
            
            TestDataFactory.triggerManagerFlagValue  = false;
            TestDataFactory.getTriggerManagers();
            
            company = TestDataFactory.createCompany('TestCompany111');
           Account account = TestDataFactory.createAccount('TestAccount111', company.Id, testOwner1.Id);
           emeaCompany = TestDataFactory.createCompany('TestEmeaCompany111');
           Account emeaAccount = TestDataFactory.createAccount('TestEmeaAccount111', emeaCompany.Id, testOwner3.Id);

        }
    }
    
    @isTest
   public static void testMethod1(){
        User adminUser = [SELECT Id, Name FROM User WHERE LastName = 'testAdminUser123' AND IsActive = true limit 1];
        User testOwner1 = [SELECT Id, Name FROM User WHERE LastName = 'testOwner1' AND IsActive = true limit 1];
        User testOwner2 = [SELECT Id, Name FROM User WHERE LastName = 'testOwner2' AND IsActive = true limit 1];
        Account account = [SELECT Id, Name FROM Account WHERE Name = 'TestAccount111' LIMIT 1];
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
            AccountRealignmentUtility.process(requestItems);
        }        
    }
    //SDFC-7172, test scenario where region = emea and sub region is populated
    @isTest
    public static void testMethodEmeaRegion(){
        User emeaAdminUser2 = [SELECT Id, Name FROM User WHERE LastName = 'EmeaTestAdminUser123' AND IsActive = true limit 1];
        User testOwner3 = [SELECT Id, Name FROM User WHERE LastName = 'testOwner3' AND IsActive = true limit 1];
        User testOwner4 = [SELECT Id, Name FROM User WHERE LastName = 'testOwner4' AND IsActive = true limit 1];
        Account account2 = [SELECT Id, Name FROM Account WHERE Name = 'TestEmeaAccount111' LIMIT 1];
        System.runAs(emeaAdminUser2){
            List<Realignment_Request_Item__c> requestItems = new List<Realignment_Request_Item__c>();
            requestItems.add(new Realignment_Request_Item__c(
                Account__c = account2.Id,
                Move_Date__c = System.today(),
                New_Account_Owner__c = testOwner4.Id,
                Previous_Account_Owner__c = testOwner3.Id,
                Request_Status__c = 'New',
                Reason_for_Move__c = 'New Rep'
            ));
            AccountRealignmentUtility.process(requestItems);
        }
    }
}