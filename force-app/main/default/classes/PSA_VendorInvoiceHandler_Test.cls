@isTest
public class PSA_VendorInvoiceHandler_Test {
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
        user PSAUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' limit 1].Id,
            LastName = 'testPSAUser123',
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
            ManagerId = adminUser.Id
        );
        Insert PSAUser;
        
        system.runAs(adminUser){
            TestDataFactory.getOrgConstants();
            TestDataFactory.triggerManagerFlagValue  = false;
            List<Trigger_Manager__c> triggerManagers = TestDataFactory.getTriggerManagers();
           Account a= new Account(Name = 'Test Account 1',BillingCountry = 'Canada', ShippingCountry = 'Canada', RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a;
        Account ac = new Account(Name = 'Test Account 1a', Company_Name__c = a.Id, BillingCountry = 'Canada', ShippingCountry = 'Canada', RecordTypeId = Label.Account_Prospect_RecordType_ID);
        insert ac;
            
           
          Opportunity opty = new Opportunity(Name='Test Opportunity',Skip_validation__c=True,Type='Azure',Opportunity_Access_Submitter__c=adminUser.id,Why_Did_We_Lose__c = 'Price',Lost_Reason__c='Price',AccountId=a.Id,Account__c=ac.id,DDI__c='12345655',StageName='Closed Won',CloseDate=System.today().addDays(-15),OwnerId=UserInfo.getUserId()); 
         insert opty; 
          
            pse__Region__c region = PSA_TestDataFactory.createRegion();
            Contact resource = PSA_TestDataFactory.createResource(PSAUser.Id, region.Id);
            
            pse__Proj__c project = PSA_TestDataFactory.createProject(opty.Id, region.Id);
            delete triggerManagers;
            TestDataFactory.triggerManagerFlagValue  = true;
            TestDataFactory.createFeatureFlags();
            TestDataFactory.getTriggerManagers();
        }
    }
     @isTest
    private static void countInvoices(){
        Test.startTest();
        User PSAUser = [SELECT Id, Name FROM User WHERE LastName = 'testPSAUser123' AND IsActive = true limit 1];
        PSA_VendorInvoiceHandler proj=new PSA_VendorInvoiceHandler();
        proj.beforeInsert();
        proj.beforeUpdate();
        proj.beforeDelete();
        proj.afterInsert();
        proj.afterUpdate();
        proj.afterDelete();
        proj.afterUndelete();
        System.runAs(PSAUser){
         Account a= [SELECT Id, Name FROM Account WHERE Name = 'Test Account 1' LIMIT 1];
            Opportunity opty = [SELECT Id, Name FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];
            pse__Region__c region = [SELECT Id FROM pse__Region__c LIMIT 1];
            Contact  resource = [Select Id From Contact Where  LastName = 'PSAResource'];
            
            pse__Proj__c project = [SELECT Id, Name FROM pse__Proj__c WHERE Name = 'Test PSA Project' LIMIT 1];
            Account a1 = new Account(name='TestAccount',BillingCountry='India',ShippingCountry='India');
        insert a1;
            pse__Vendor_Invoice__c invoice=new pse__Vendor_Invoice__c(Project__c=project.Id,pse__Account__c=a.id,pse__Date__c=System.today().addDays(-15));
            insert invoice;
            Update invoice;
            Delete invoice;
            Undelete invoice;
            
        }
        Test.stopTest();
    }
    
}