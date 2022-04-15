@isTest
public class GlobalAccountSearchController_Test {
    
    @testSetup
    public static void testSetup(){
        
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
                Trigger_Manager__c Tm = new Trigger_Manager__c (Name ='AccountContactRelation',Is_Active__c = true);
   				 insert Tm;
            //TestClassUtility.setTestSetupData();
            
            Id accRID1= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
            Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
            Id conRID= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
            
            List<Account> accList = new List<Account>();
            Account resellerAcc = new Account(Name='Test Account12',Type='Amazon Public Cloud',BillingCountry='United States',BillingState='Florida',Program_Of_Interest__c ='Reseller - Rackspace Services Only (Excludes Email Services)',Contract_Type__c='US Referral/Reseller Agreement',ShippingCountry='United States',RecordTypeId=accRID1);
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
        Account account = [SELECT Id, Name, Account_Number__c FROM Account WHERE Name = 'Test Account12' LIMIT 1];
        System.runAs(adminUser){
            
            GlobalAccountSearchController.getInitData();

            GlobalAccountSearchController.getSearchResults('Test Account12', null, null, null,null,null, false,0);            
            GlobalAccountSearchController.getSearchResults(null, new List<String>{'12345'}, null, null,null,null, true,0);            
            
            List<GlobalAccountSearchController.UploadedRecord> fileData = new List<GlobalAccountSearchController.UploadedRecord>();
            GlobalAccountSearchController.UploadedRecord record = new GlobalAccountSearchController.UploadedRecord();
            record.Account_Number = account.Account_Number__c;
            record.New_Owner_Id = UserInfo.getUserId();
            record.Request_Reason = 'New Rep';
            fileData.add(record);
            String dataString = JSON.serialize(fileData);
            GlobalAccountSearchController.getUploadedFileDetails(dataString);
        }
    }
}