@isTest(seeAllData=false)
public class UpdateCommunityShare_Test {
    @testSetup static void setupTestData() {
        
        //UserRole SARole = [Select Id,Name from UserRole LIMIT 1];
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
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
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
        System.runAs(adminUser){
            insertTriggerSettings();
        
        
            Account acc = new Account(Name = 'One Account', BillingCountry = 'Canada', ShippingCountry = 'Canada');
            Insert acc;
        }
        
    }
    public static void insertTriggerSettings() {
        List<Trigger_Manager__c> triggerSettings = new List<Trigger_Manager__c>();
        triggerSettings.add(new Trigger_Manager__c(Name = 'CompanyTrigger', Is_Active__c = false));
        
        insert triggerSettings;
        
    }
    
    static testmethod void moreThan10000Insert() {
        
            Account acc = new Account(Name = 'One Account',BillingCountry = 'Canada', ShippingCountry = 'Canada');
            Insert acc;
            List<AccountShare> listAccountShares = new List<AccountShare>();
            Id userId = UserInfo.getUserId();
            for(Integer i=0;i<=10001;i++){
                listAccountShares.add(new AccountShare(AccountId=acc.Id,userOrGroupId = userId ,AccountAccessLevel='Read'));
            }
            Test.startTest();
            System.enqueueJob(new UpdateCommunityShare(listAccountShares,'Insert'));
            //Insert listAccounts;
            Test.stopTest();
        
    }
    
    static testmethod void lessThan10000Insert() {
        
            Account acc = [SELECT Id FROM Account WHERE Name = 'One Account' AND BillingCountry = 'Canada' AND ShippingCountry = 'Canada' LIMIT 1];
            List<AccountShare> listAccountShares = new List<AccountShare>();
            Id userId = UserInfo.getUserId();
            for(Integer i=0;i<=11;i++){
                listAccountShares.add(new AccountShare(AccountId=acc.Id,userOrGroupId = userId ,AccountAccessLevel='Read'));
            }
            Test.startTest();
            System.enqueueJob(new UpdateCommunityShare(listAccountShares,'Insert'));
            //Insert listAccounts;
            Test.stopTest();
        
    }
    
    static testmethod void moreThan10000Delete() {
            User adminUser = [SELECT Id, Name FROM User WHERE LastName = 'testAdminUser123' AND IsActive = true limit 1];
            User testOwner1 = [SELECT Id, Name FROM User WHERE LastName = 'testOwner1' AND IsActive = true limit 1];
            Account acc = [SELECT Id FROM Account WHERE Name = 'One Account' AND BillingCountry = 'Canada' AND ShippingCountry = 'Canada' LIMIT 1];
            
            System.runAs(adminUser){
                List<AccountShare> listAccountShares = new List<AccountShare>();
                Id userId = UserInfo.getUserId();
                AccountShare accShare = new AccountShare(AccountId=acc.Id,userOrGroupId = testOwner1.Id ,AccountAccessLevel='Read', OpportunityAccessLevel='Read', ContactAccessLevel='Read');
                
                Insert accShare;
                listAccountShares.add(accShare);
                for(Integer i=0;i<10000;i++){
                    listAccountShares.add(new AccountShare());
                }
                Test.startTest();
                Try{
                    System.enqueueJob(new UpdateCommunityShare(listAccountShares,'Delete'));
                }
                catch(Exception e){}
                //Insert listAccounts;
                Test.stopTest();
            
            }
        
    }
    
    static testmethod void lessThan10000Delete() {
        
            User adminUser = [SELECT Id, Name FROM User WHERE LastName = 'testAdminUser123' AND IsActive = true limit 1];
            User testOwner1 = [SELECT Id, Name FROM User WHERE LastName = 'testOwner1' AND IsActive = true limit 1];
            Account acc = [SELECT Id FROM Account WHERE Name = 'One Account' AND BillingCountry = 'Canada' AND ShippingCountry = 'Canada' LIMIT 1];
            
            System.runAs(adminUser){    
                List<AccountShare> listAccountShares = new List<AccountShare>();
                Id userId = UserInfo.getUserId();
                listAccountShares.add(new AccountShare(AccountId=acc.Id,userOrGroupId = testOwner1.Id ,AccountAccessLevel='Read', OpportunityAccessLevel='Read', ContactAccessLevel='Read'));
                Insert listAccountShares;
                Test.startTest();
                System.enqueueJob(new UpdateCommunityShare(listAccountShares,'Delete'));
                //Insert listAccounts;
                Test.stopTest();
            }
        
    }
}