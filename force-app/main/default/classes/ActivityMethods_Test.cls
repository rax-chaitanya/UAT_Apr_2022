@isTest
public class ActivityMethods_Test{
    @testSetup
    public static void testSetup(){
      //  UserRole SARole = [Select Id,Name from UserRole Where Name LIKE '%US Commercial SMB - ATX 1%' LIMIT 1];
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' limit 1];
     Profile Rackspace_SE_US_Profile = [SELECT Id FROM Profile WHERE Name = 'Rackspace - SE US' limit 1];
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
           // UserRoleId = SARole.Id,
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
           // UserRoleId = SARole.Id,
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
          //  UserRoleId = SARole.Id,
            ManagerId = adminUser.Id,
            Group__c = 'US Other',
            Region__c = 'US'
        );
        User rackspaceUser = new User(
            ProfileId = Rackspace_SE_US_Profile.Id,
            LastName = 'rackspaceUser',
            Email = 'puser000@amamama.com',
            Username = 'rackspaceUser@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            
            
            LocaleSidKey = 'en_US',
           // UserRoleId = SARole.Id,
            ManagerId = adminUser.Id,
            Group__c = 'US Other',
            Region__c = 'US'
        );
         
        Insert new List<User>{testOwner1, testOwner2,rackspaceUser};
        
        Account company;
        System.runAs(adminUser){
            TestDataFactory.getOrgConstants();
            
            TestDataFactory.triggerManagerFlagValue  = false;
            List<Trigger_Manager__c> triggerManagers = TestDataFactory.getTriggerManagers();
            
            company = TestDataFactory.createCompany('TestCompany111');
            Account account =new Account(Name='TestAccount111', Company_Name__c=company.Id, OwnerId =testOwner1.Id,Named_Account__c='Enterprise NAL ', RecordTypeId =Label.Account_Prospect_RecordType_ID);
            insert account;
            Contact con = new Contact(FirstName = 'Rackspace', LastName = 'Test Contact', AccountId = company.id);
            Insert con;  
           //ActivityMethods.UpdateIds();
            //CustomException  e = new CustomException ('Error', false);
           // e.addError('Activity Trigger Settings fields are not populated.', false);
      Id oppRecordTypeId =schema.sobjecttype.opportunity.getrecordtypeinfosbyname().get('INTL Cloud').getRecordTypeId();
         Opportunity opp = new Opportunity(Name = 'Test opp',Market_Source__c='Yes',Account__c=account.Id,AccountID=company.Id,recordtypeid=oppRecordTypeId, Type = 'Azure',Technical_Next_Steps__c='Test',
        closedate=date.today(),Focus_Area__c = 'Amazon', StageName = 'Stage 1 - Planning & Identification');
         Opportunity opp1 = new Opportunity(Name = 'Test opp1',Market_Source__c='Yes',Account__c=account.Id,AccountID=company.Id,recordtypeid=oppRecordTypeId, Type = 'Azure',Technical_Next_Steps__c='Test',
        closedate=date.today(),Focus_Area__c = 'Amazon', StageName = 'Stage 1 - Planning & Identification');
        Test.startTest();
            Insert opp;
            Insert opp1;
        Test.stopTest();
        
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
            AccountRealignmentUtility.process(requestItems);
            
            
            Task ts = new Task(Subject='Test Task', Status='New', Priority='Normal', CallType='Outbound', Whatid= account.id, Whoid= contact.id);
            Insert ts;        
            Update ts;        
            Delete ts;
            
            
            Task lts = new Task(Subject='Lead Task', Status='New', Priority='Normal', CallType='Outbound', Whoid= lead.id);
            Insert lts;
            
        }
    }
    
   @isTest
    public static void testMethod2(){
        User adminUser = [SELECT Id, Name FROM User WHERE LastName = 'testAdminUser123' AND IsActive = true limit 1];
        User testOwner1 = [SELECT Id, Name FROM User WHERE LastName = 'testOwner1' AND IsActive = true limit 1];
        User testOwner2 = [SELECT Id, Name FROM User WHERE LastName = 'testOwner2' AND IsActive = true limit 1];
        Account account = [SELECT Id, Name FROM Account WHERE Name = 'TestAccount111' LIMIT 1 ];
        Contact contact = [SELECT Id, Name FROM Contact WHERE LastName = 'Test Contact' LIMIT 1];
        Lead lead = [SELECT Id, Name FROM Lead WHERE LastName = 'TestLead123' LIMIT 1];
        String FMWFoundationUserId = System.Label.FMWFoundationUser;
        System.runAs(new User(Id = FMWFoundationUserId)){
                         
            Task ts = new Task(Subject='Test Task', Status='New', Priority='Normal', CallType='Outbound', Whatid= account.id, Whoid= contact.id);
            Insert ts; 
            Test.startTest();       
         //   Update ts;        
            Delete ts;
            
            Task lts = new Task(Subject='Lead Task', Status='New', Priority='Normal', CallType='Outbound', Whoid= lead.id);
            Insert lts;
             test.stoptest();
        }
    }
    
    @isTest
    public  static void testMethod3()
    {
  // list<Opportunity> opp=new list<opportunity>();
  User rackspaceUser = [SELECT Id, Name FROM User WHERE LastName = 'rackspaceUser' AND IsActive = true limit 1];
  Id TaskRecordTypeId =schema.sobjecttype.Task.getrecordtypeinfosbyname().get('TechSales Activity').getRecordTypeId();
   String rackspaceUserId = System.Label.Rackspace_SE_US_Profile;
       system.runas(rackspaceUser){
       Opportunity opp = [select id from Opportunity where Name = 'Test opp' ];
        Opportunity opp1 = [select id from Opportunity where Name = 'Test opp1'];
            Account company = [select id FROM Account WHERE Name='TestCompany111' limit 1];
        system.debug('*opp**'+opp);
        test.starttest();
     Task ts = new Task(Subject='Test Task', Status='New',Technical_Next_Steps__c='Test',  Priority='Normal', CallType='Outbound', Whatid= opp.id);
       Insert ts;        
            Update ts;        
            Delete ts;
   
      Task ts2 = new Task(Subject='Test Task', Status='New',Technical_Next_Steps__c='Test',  Priority='Normal', CallType='Outbound', Whatid= company.id);     
        
           Insert ts2;
           test.stoptest();
       }
        
    }
    
}