@isTest
public class QuoteLineBatch_Test {

    
    @testSetup
    public static void createTestData(){
        UserRole SARole = [Select Id,Name from UserRole Where Name LIKE '%US SA%' LIMIT 1];
        
        user adminUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' limit 1].Id,
            LastName = 'testAdminUser123',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = SARole.Id
        );
        Insert adminUser;
        system.runAs(adminUser){
            TestDataFactory.getOrgConstants();
            TestDataFactory.triggerManagerFlagValue  = false;
            List<Trigger_Manager__c> triggerManagers = TestDataFactory.getTriggerManagers();
            Id devRecordTypeId3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
            Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId = devRecordTypeId3);
            insert a;
            Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
 
            Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,ShippingCountry='India',RecordTypeId =devRecordTypeId);
            insert ac;
            Opportunity opty = new Opportunity(Name='Test Opportunity',Skip_validation__c=True,Type='Azure',Opportunity_Access_Submitter__c=adminUser.id,Why_Did_We_Lose__c = 'Price',Lost_Reason__c='Price',AccountId=a.Id,Account__c=ac.id,DDI__c='12345655',StageName='Closed Won',CloseDate=System.today().addDays(-15),OwnerId=UserInfo.getUserId(),Access_Request_Status__c ='Approved'); 
            insert opty; 
            
            delete triggerManagers;
            TestDataFactory.triggerManagerFlagValue  = true;
            TestDataFactory.getTriggerManagers();
            TestDataFactory.createFocusAreaMapping();
            TestDataFactory.createFeatureFlags();
        }
    }
    
    @isTest
    private static void insertQuoteLines(){
        Test.startTest();
        
        User adminUser = [SELECT Id, Name FROM User WHERE LastName = 'testAdminUser123' AND IsActive = true limit 1];
        System.runAs(adminUser){
        Opportunity op = [SELECT Id, Name FROM Opportunity WHERE Skip_validation__c=True LIMIT 1];
        
        List<Opp_FocusArea__c> FAList = new List<Opp_FocusArea__c>();
        
        Opp_FocusArea__c amazonFA = new Opp_FocusArea__c(Name = 'Amazon', Opportunity__c = op.Id);
        FAList.add(amazonFA);
        Opp_FocusArea__c dataStoresFA = new Opp_FocusArea__c(Name = 'Data Stores', Opportunity__c = op.Id);
        FAList.add(dataStoresFA);
        Opp_FocusArea__c cloudOfficeFA = new Opp_FocusArea__c(Name = 'Cloud Office', Opportunity__c = op.Id);
        FAList.add(cloudOfficeFA);
        Insert FAList;
        
        List<Quote_Line__c> q = new List<Quote_Line__c>();
        
        q.add(new Quote_Line__c(
            Opportunity_Quote__c = op.Id,
            Focus_Area__c = 'Amazon',
            FocusArea__c = amazonFA.Id,
            New_MRR__c = 100
        ));
        
        q.add(new Quote_Line__c(
            Opportunity_Quote__c = op.Id,
            Focus_Area__c = 'Data Stores',
            FocusArea__c = dataStoresFA.Id,
            New_MRR__c = 200
        ));
        
        q.add(new Quote_Line__c(
            Opportunity_Quote__c = op.Id,
            Focus_Area__c = 'Cloud Office',
            FocusArea__c = dataStoresFA.Id,
            New_MRR__c = 100
        ));
        
        Insert q;
            Database.executeBatch(new QuoteLineBatch());
       Test.stopTest();
    }
    }
}