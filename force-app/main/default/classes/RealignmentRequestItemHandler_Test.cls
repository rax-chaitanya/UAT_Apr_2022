@isTest
public class RealignmentRequestItemHandler_Test{
    
    @testSetup
    public static void testSetup(){
        
        List<Trigger_Manager__c> tmList = new List<Trigger_Manager__c>();
        Trigger_Manager__c accTm = new Trigger_Manager__c (Name ='AccountContactRelation',Is_Active__c = true);
        tmList.add(accTm);     
        insert tmList;
        
        //UserRole SARole = [Select Id,Name from UserRole Where Name LIKE '%US Sub-Segment - Comm MM SAT%' LIMIT 1];
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
            // UserRoleId = SARole.Id,
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
            
            List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
            fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
            fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
            fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
            insert fieldMappings;
            
            List<BrightTALK__BrightTalk_State_Codes__c> btlkstatecode = new List<BrightTALK__BrightTalk_State_Codes__c>();
            btlkstatecode.add(new BrightTALK__BrightTalk_State_Codes__c(Name = 'Florida', BrightTALK__State_Alpha_2__c = 'FL'));
            insert btlkstatecode;
            
            List<CountryTerritoryMapping__c> mappings = new List<CountryTerritoryMapping__c>();
            mappings.add(new CountryTerritoryMapping__c(Name = 'United States', Territory_Name__c = 'US/CANADA'));
            mappings.add(new CountryTerritoryMapping__c(Name = 'Canada', Territory_Name__c = 'US/CANADA'));
            insert mappings;
            
            //TestClassUtility.setTestSetupData();
            
            Id accRID1= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
            Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
            Id conRID= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
            
            List<Account> accList = new List<Account>();
            Account resellerAcc = new Account(Name='Test Account12',BillingCountry='United States',BillingState='Florida',Program_Of_Interest__c ='Reseller - Rackspace Services Only (Excludes Email Services)',Contract_Type__c='US Referral/Reseller Agreement',ShippingCountry='United States',RecordTypeId=accRID1);
            accList.add(resellerAcc);
            
            Account referalOrReselleracc = new Account(Name='Test Account123',Company_Name__c = resellerAcc.Id,BillingCountry='United States',BillingState='Florida',Program_Of_Interest__c ='Referral/Reseller - Rackspace Services Only (Excludes the resell of Email Services',Contract_Type__c='US Referral/Reseller Agreement',ShippingCountry='United States',RecordTypeId=accRID);
            accList.add(referalOrReselleracc);        
            insert accList;
            
            List<Contact> conList = new List<Contact>();
            Contact resellerCon = new Contact(firstname='Test Contact12',RecordTypeId= conRID,LastName='Test Last',AccountId=resellerAcc.id,HasOptedOutOfEmail=false,Btlk_Country__c='United States',Btlk_Sate_Province__c='Florida');
            conList.add(resellerCon);
            insert conList;
            
            resellerAcc.Primary_Member__c = resellerCon.Id;        
            update resellerCon;
            
            Opportunity opty = new Opportunity(Quotingsystem__C='Datapipe',AccountId=resellerAcc.Id,Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport',DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15), Lead_Id__C = 'L-GARBAGE');
            insert opty; 
            
            List<FeatureFlag__c> ff = new List<FeatureFlag__c>();
            ff.add( new FeatureFlag__c (Name='BucketLogic_DM', Enabled__c=True));
            insert ff;
            
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
        Account account = [SELECT Id, Name, OwnerId FROM Account WHERE Name = 'Test Account12' LIMIT 1];
		
        Map<Id,Id> companyOwnerMap = new Map<Id,Id>();  
        companyOwnerMap.put(account.Id, account.OwnerId);
        
        System.runAs(adminUser){
            
            List<Realignment_Request_Item__c> requestItems = new List<Realignment_Request_Item__c>();
            requestItems.add(new Realignment_Request_Item__c(
                Account__c = account.Id,
                Move_Date__c = System.today(),
                New_Account_Owner__c = testOwner2.Id,
                Previous_Account_Owner__c = testOwner1.Id,
                Request_Status__c = 'New',
                Reason_for_Move__c = 'New Rep',
                Opportunity_Updation_Flag__c = true
            ));
            AccountRealignmentUtility.process(requestItems);
            System.enqueueJob(new OpportunityProcessingQueueable(companyOwnerMap));
        }
    }
    
    @isTest
    public static void updateTestMethod(){
        User adminUser = [SELECT Id, Name FROM User WHERE LastName = 'testAdminUser123' AND IsActive = true limit 1];
        User testOwner1 = [SELECT Id, Name FROM User WHERE LastName = 'testOwner1' AND IsActive = true limit 1];
        User testOwner2 = [SELECT Id, Name FROM User WHERE LastName = 'testOwner2' AND IsActive = true limit 1];
        Account account = [SELECT Id, Name, OwnerId FROM Account WHERE Name = 'Test Account12' LIMIT 1];
        Opportunity opp = [SELECT Id, Name FROM Opportunity WHERE Name = 'Test Opport' LIMIT 1];
        
        Map<Id,Id> companyOwnerMap = new Map<Id,Id>();
        Set<Id> oppUpdationId =  new Set<Id>();
        companyOwnerMap.put(account.Id, account.OwnerId);
        oppUpdationId.add(opp.Id);
        
        System.runAs(adminUser){
            List<Realignment_Request_Item__c> requestItems = new List<Realignment_Request_Item__c>();
            
            Account_Realignment_Request__c accountAlignment = new Account_Realignment_Request__c();
            accountAlignment.Approver__c = Userinfo.getUserId();
            accountAlignment.Status__c = 'New';
            accountAlignment.Submitted_date__c =Date.Today();
            accountAlignment.Approver_Type__c = 'Business Manager';
            accountAlignment.Region__c = 'AMER';
            insert accountAlignment; 
            
            Realignment_Request_Item__c requestItem = new Realignment_Request_Item__c();
            requestItem.Account__c = account.Id;
            requestItem.Move_Date__c = System.today();
            requestItem.New_Account_Owner__c = testOwner2.Id;
            requestItem.Previous_Account_Owner__c = testOwner1.Id;
            requestItem.Request_Status__c = 'New';
            requestItem.Processed__c= false;
            requestItem.Opportunity_Updation_Flag__c = true;
            requestItem.Reason_for_Move__c = 'New Rep';
            
            requestItems.add(requestItem);
            AccountRealignmentUtility.process(requestItems);
            
            Account_Realignment_Request__c request = [SELECT Id,Status__c FROM Account_Realignment_Request__c LIMIT 1];
            request.Status__c = 'Approved';
            Update request;
            
            Realignment_Request_Item__c item = [SELECT Id,Processed__c FROM Realignment_Request_Item__c LIMIT 1];
            item.Processed__c = true;
            update item;
            Test.startTest();
            System.enqueueJob(new ContactsProcessingQueueable(companyOwnerMap,oppUpdationId));			
			Test.stopTest();            
        }
    }
    
}