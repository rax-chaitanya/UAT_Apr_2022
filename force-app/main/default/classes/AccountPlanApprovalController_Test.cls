@istest
public class AccountPlanApprovalController_Test {
    
    public static final List<String> SellerProfiles = System.Label.AccountPlanApprovalProfiles.split(',');
    public static final String SOLUTION_ENGINEER= 'Solution Engineer';
    public static final Id US_RECORDTYPE_ID = Schema.SObjectType.Account_Plan__c.getRecordTypeInfosByName().get('US - Account Plan').getRecordTypeId();
    
    @testSetup
    public static void testDataSetup(){
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
        
        
        User testUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name IN: SellerProfiles limit 1].Id,
            LastName = 'testSAUser123',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
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
        
        Insert testUser;
        Account company;
        System.runAs(adminUser){
            TestDataFactory.getOrgConstants();
            
            TestDataFactory.triggerManagerFlagValue  = false;
            TestDataFactory.getTriggerManagers();
            
            company = TestDataFactory.createCompany('TestCompany111');
            
            AccountShare share = new AccountShare(
                UserOrGroupId = testUser.Id, 
                AccountId = company.Id, 
                RowCause = 'Manual', 
                AccountAccesslevel = 'Read',
                OpportunityAccesslevel = 'Read',
                CaseAccesslevel = 'Read',
                ContactAccesslevel = 'Read'
            );
            Insert share;
            
            TestDataFactory.createAccountPlan(company.Id, null);
        }
        
        System.runAs(testUser){
            TestDataFactory.createAccountPlan(company.Id, US_RECORDTYPE_ID);
        }
    }
    
    @isTest
    private static void ValidateActionTest(){
        User adminUser = [SELECT Id, Name FROM User WHERE LastName = 'testAdminUser123' AND IsActive = true limit 1];
        
        user testuser = [SELECT Id, Name FROM User WHERE LastName = 'testSAUser123' AND IsActive = true limit 1];
        
        Account_Plan__c NonUSaccountPlan = [SELECT Id, Name FROM Account_Plan__c WHERE RecordTypeId !=: US_RECORDTYPE_ID LIMIT 1];
        Account_Plan__c USaccountPlan = [SELECT Id, Name FROM Account_Plan__c WHERE RecordTypeId =: US_RECORDTYPE_ID LIMIT 1];
        
        System.runAs(adminUser){
            AccountPlanApprovalController.validateAction(USaccountPlan.Id);
        }
        
        System.runAs(testuser){
            AccountPlanApprovalController.validateAction(NonUSaccountPlan.Id);
            AccountPlanApprovalController.validateAction(USaccountPlan.Id);
            
            AccountPlanApprovalController.submitForApproval(USaccountPlan.Id, '');
            AccountPlanApprovalController.validateAction(USaccountPlan.Id);
        }
        
        System.runAs(adminUser){
            USaccountPlan.Status__c = 'Approved';
            update USaccountPlan;
        }
        
        System.runAs(testuser){
            AccountPlanApprovalController.validateAction(USaccountPlan.Id);
        }
    }
}