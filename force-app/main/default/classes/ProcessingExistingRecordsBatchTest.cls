/********************************************************************
// Purpose              : SFDC-7281 -- Partner Company Historical records are shared Upto 3 level Parent Partner Company
// Author               : Rackspace [Rishabh]
// Parameters           : null
//  Returns             : null
//JIRA Reference        : SFDC-7281 -- Partner Company Historical records are shared Upto 3 level Parent Partner Company
//********************************************************************/
@IsTest
public class ProcessingExistingRecordsBatchTest {
    
    @isTest 
    static void accountSharingTest(){
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
            
            Trigger_Manager__c accTm = new Trigger_Manager__c (Name ='AccountContactRelation',Is_Active__c = true);
            insert accTm;
            
            TestClassUtility.setTestSetupData();            
            Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId(); 
            Id conRID= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId(); 
            Id rtIdLead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead').getRecordTypeId();   
            Id oppRId= Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('INTL Cloud').getRecordTypeId();  
            
            Account oppAcc = new Account(Name='Test Account12345',Partner_Account_Status__c='Approved',BillingCountry='India',ShippingCountry='India',RecordTypeId = accRID);
            insert oppAcc;
            
            //Id accRID1= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
            Account acc = new Account(Partner_Account_Status__c='Approved',ParentId=oppAcc.Id,Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =System.today(),Partner_Level__c='Referral',RecordTypeId= accRID,Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
            insert acc;
            
            Account childAcc = new Account(Partner_Company__c=acc.Id ,Name='childAcc 11Account',Partner_Account_Status__c='Approved',ParentId=acc.Id,Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =System.today(),Partner_Level__c='Referral',Company_Name__c=oppAcc.Id, RecordTypeId =accRID);
            Insert childAcc;
            
            Account ac = new Account(Name='Test C 11Account',Partner_Account_Status__c='Approved',ParentId=childAcc.Id,Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =System.today(),Partner_Level__c='Referral',Company_Name__c=oppAcc.Id, RecordTypeId =accRID);
            insert ac;
            
            Account ac2 = new Account(Partner_Company__c=oppAcc.Id, Name='Test C2 11Account',Partner_Account_Status__c='Approved',ParentId=ac.Id,Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =System.today(),Partner_Level__c='Referral',Company_Name__c=acc.Id, RecordTypeId =accRID);
            insert ac2;
            
            List<Opportunity> oppList = new List<Opportunity>();
            Opportunity opty = new Opportunity(Quotingsystem__C='Datapipe',Partner_Company__c=oppAcc.Id,Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opp',DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15), Lead_Id__C = 'L-GARBAGE');
            oppList.add(opty);
            
            Opportunity opt = new Opportunity(Quotingsystem__C='Datapipe',Partner_Company__c=acc.Id,Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Oppt',DDI__c='1234567',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15), Lead_Id__C = 'L-GARBAGE');
            oppList.add(opt);
            
            Opportunity optty = new Opportunity(Quotingsystem__C='Datapipe',Partner_Company__c=childAcc.Id,Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test optty',DDI__c='123456',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15), Lead_Id__C = 'L-GARBAGE');
            oppList.add(optty);
            
            Opportunity opttty = new Opportunity(Quotingsystem__C='Datapipe',Partner_Company__c=ac.Id,Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test opttty',DDI__c='12345',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15), Lead_Id__C = 'L-GARBAGE');
            oppList.add(opttty);
            
            Opportunity optttty = new Opportunity(Quotingsystem__C='Datapipe',Partner_Company__c=ac2.Id,Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test optttty',DDI__c='1234',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15), Lead_Id__C = 'L-GARBAGE');
            oppList.add(optttty);
            Insert oppList;
            
            List<Contact> conList = new List<Contact>();
            Contact con = new Contact(firstname='Test Contact',RecordTypeId= conRID,LastName='Test Last',AccountId=oppAcc.id,HasOptedOutOfEmail=false,Btlk_Country__c='India',Btlk_Sate_Province__c='Karnataka');
            conList.add(con);
            
            Contact cont = new Contact(firstname='Test Contact',RecordTypeId= conRID,LastName='Test cont',AccountId=acc.id,HasOptedOutOfEmail=false,Btlk_Country__c='India',Btlk_Sate_Province__c='Karnataka');
            conList.add(cont);
            
            Contact conty = new Contact(firstname='Test Contact',RecordTypeId= conRID,LastName='Test conty',AccountId=childAcc.id,HasOptedOutOfEmail=false,Btlk_Country__c='India',Btlk_Sate_Province__c='Karnataka');
            conList.add(conty);
            
            Contact contty = new Contact(firstname='Test Contact',RecordTypeId= conRID,LastName='Test contty',AccountId=ac.id,HasOptedOutOfEmail=false,Btlk_Country__c='India',Btlk_Sate_Province__c='Karnataka');
            conList.add(contty);
            
            Contact conttty = new Contact(firstname='Test Contact',RecordTypeId= conRID,LastName='Test conttty',AccountId=ac2.id,HasOptedOutOfEmail=false,Btlk_Country__c='India',Btlk_Sate_Province__c='Karnataka');
            conList.add(conttty);
            
            Insert conList;
            
            oppAcc.Primary_Member__c = con.Id;
            update oppAcc;
            
            List<Lead> leadList = new List<Lead>();
            Lead l = new Lead(Partner_Company__c=oppAcc.Id,firstname='Testfirst1',lastname='lastname1',company='Test company1',
                              email='test.test1@test.com',LeadSource='Chat',Lead_Type__c='AWS',AnnualRevenue = 100.00,
                              Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',
                              country='India',postalcode='560037',Type_Of_Deal__c ='Referral',RecordTypeId = rtIdLead); 
            leadList.add(l);  
            
            Lead dl = new Lead(Partner_Company__c=acc.Id,firstname='Testfirst',lastname='lastname',company='Test acc',
                               email='test.dl@test.com',LeadSource='Chat',Lead_Type__c='AWS',AnnualRevenue = 100.00,
                               Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',
                               country='India',postalcode='560037',Type_Of_Deal__c ='Referral',RecordTypeId = rtIdLead); 
            leadList.add(dl); 
            
            Lead cl = new Lead(Partner_Company__c=childAcc.Id,firstname='TestfirstchildAcc',lastname='lastnamechildAcc',company='Test childAcc',
                               email='test.cl@test.com',LeadSource='Chat',Lead_Type__c='AWS',AnnualRevenue = 100.00,
                               Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',
                               country='India',postalcode='560037',Type_Of_Deal__c ='Referral',RecordTypeId = rtIdLead); 
            leadList.add(cl); 
            
            Lead ml = new Lead(Partner_Company__c=ac.Id,firstname='Testfirstml',lastname='lastnameml',company='Test ml',
                               email='test.ml@test.com',LeadSource='Chat',Lead_Type__c='AWS',AnnualRevenue = 100.00,
                               Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',
                               country='India',postalcode='560037',Type_Of_Deal__c ='Referral',RecordTypeId = rtIdLead); 
            leadList.add(ml); 
            
            Lead nl = new Lead(Partner_Company__c=ac2.Id,firstname='Testfirstnl',lastname='lastnamenl',company='Test ac2',
                               email='test.nl@test.com',LeadSource='Chat',Lead_Type__c='AWS',AnnualRevenue = 100.00,
                               Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',
                               country='India',postalcode='560037',Type_Of_Deal__c ='Referral',RecordTypeId = rtIdLead); 
            leadList.add(nl); 
            
            Insert leadList;
            
            Profile portalProfile = [select Id from Profile where UserType = 'PowerPartner' limit 1];
            List<User> usrList = new List<User>();
            User user1 = new User(Username = System.now().millisecond() + 'test1234566@test.com',SSO_Username__c='testP12',FederationIdentifier='test12',ContactId = con.Id,ProfileId = portalProfile.Id,Alias = 'test123',Email = 'test1234555576@test.com',EmailEncodingKey = 'UTF-8',LastName = 'RaxTesty',CommunityNickname = System.now().millisecond() + 'test12345',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
            usrList.add(user1); 
            
            User user2 = new User(Username = System.now().millisecond() + 'test125@test.com',SSO_Username__c='testP15',FederationIdentifier='test15',ContactId = cont.Id,ProfileId = portalProfile.Id,Alias = 'test15',Email = 'test12345556@test.com',EmailEncodingKey = 'UTF-8',LastName = 'RaxTy',CommunityNickname = System.now().millisecond() + 'test123',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
            usrList.add(user2);
            
            User user3 = new User(Username = System.now().millisecond() + 'test1234@test.com',SSO_Username__c='testP123',FederationIdentifier='test1111',ContactId = conty.Id,ProfileId = portalProfile.Id,Alias = 'test1234',Email = 'test1234576@test.com',EmailEncodingKey = 'UTF-8',LastName = 'Rax',CommunityNickname = System.now().millisecond() + 'test125',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
            usrList.add(user3);
            
            User user4 = new User(Username = System.now().millisecond() + 'test12345@test.com',SSO_Username__c='testP124',FederationIdentifier='test124',ContactId = contty.Id,ProfileId = portalProfile.Id,Alias = 'test12',Email = 'test12@test.com',EmailEncodingKey = 'UTF-8',LastName = 'RaxTyyyyyy',CommunityNickname = System.now().millisecond() + 'test12',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
            usrList.add(user4);
            
            User user5 = new User(Username = System.now().millisecond() + 'test12341@test.com',SSO_Username__c='testP121',FederationIdentifier='test121',ContactId = conttty.Id,ProfileId = portalProfile.Id,Alias = 'tt141',Email = 'test121@test.com',EmailEncodingKey = 'UTF-8',LastName = 'Raxt',CommunityNickname = System.now().millisecond() + 'test121',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
            usrList.add(user5);
            Insert usrList;   
        }
        Test.StartTest();
        ProcessingExistingRecordsBatch obj = new ProcessingExistingRecordsBatch();
        Database.executeBatch(obj);
        Test.StopTest(); 
    }
    
    
    @isTest 
    static void caseSharingTest(){
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
            
            Trigger_Manager__c accTm = new Trigger_Manager__c (Name ='AccountContactRelation',Is_Active__c = true);
            insert accTm;
            
            TestClassUtility.setTestSetupData();            
            Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId(); 
            Id conRID= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId();  
            
            Account acc = new Account(Partner_Account_Status__c='Approved',Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =System.today(),Partner_Level__c='Referral',RecordTypeId= accRID,Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
            insert acc;
            
            Account childAcc = new Account(Name='childAcc 11Account',ParentId=acc.Id,Partner_Account_Status__c='Approved',Partner_Level__c='Referral',RecordTypeId =accRID);
            insert childAcc;
            
            Account ac = new Account(Name='Test C 11Account',Partner_Account_Status__c='Approved',ParentId=childAcc.Id,Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =System.today(),Partner_Level__c='Referral',RecordTypeId = accRID);
            insert ac;
            
            Account ac2 = new Account(Name='Test C2 11Account',Partner_Account_Status__c='Approved',ParentId=ac.Id,Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =System.today(),Partner_Level__c='Referral',RecordTypeId = accRID);
            insert ac2;
            
            List<Contact> conList = new List<Contact>();  
            
            Contact cont = new Contact(firstname='Test Contact',RecordTypeId= conRID,LastName='Test cont',AccountId=acc.id,HasOptedOutOfEmail=false,Btlk_Country__c='India',Btlk_Sate_Province__c='Karnataka');
            conList.add(cont);
            
            Contact conty = new Contact(firstname='Test Contact',RecordTypeId= conRID,LastName='Test conty',AccountId=childAcc.id,HasOptedOutOfEmail=false,Btlk_Country__c='India',Btlk_Sate_Province__c='Karnataka');
            conList.add(conty);
            
            Contact contty = new Contact(firstname='Test Contact',RecordTypeId= conRID,LastName='Test contty',AccountId=ac.id,HasOptedOutOfEmail=false,Btlk_Country__c='India',Btlk_Sate_Province__c='Karnataka');
            conList.add(contty);
            
            Contact conttty = new Contact(firstname='Test Contact',RecordTypeId= conRID,LastName='Test conttty',AccountId=ac2.id,HasOptedOutOfEmail=false,Btlk_Country__c='India',Btlk_Sate_Province__c='Karnataka');
            conList.add(conttty);
            
            Insert conList;
            
            List<Case> csList = new List<Case>();
            Id caseRID= Schema.SObjectType.Case.getRecordTypeInfosByName().get('Partner Portal').getRecordTypeId();
            Case cas = new Case(AccountId= acc.Id,RecordTypeId=caseRID,Origin = 'Email',Status ='1-New',Type='Problem');
            csList.add(cas);
            
            Case castting = new Case(AccountId= childAcc.Id,RecordTypeId=caseRID,Origin = 'Email',Status ='1-New',Type='Problem');
            csList.add(castting);
            
            Case caseting = new Case(AccountId= ac.Id,RecordTypeId=caseRID,Origin = 'Email',Status ='1-New',Type='Problem');
            csList.add(caseting);
            
            Case casetkig = new Case(AccountId= ac2.Id,RecordTypeId=caseRID,Origin = 'Email',Status ='1-New',Type='Problem');
            csList.add(casetkig);
            
            Insert csList;
            
            Profile portalProfile = [select Id from Profile where UserType = 'PowerPartner' limit 1];
            List<User> usrList = new List<User>();  
            User user2 = new User(Username = System.now().millisecond() + 'test125@test.com',SSO_Username__c='testP15',FederationIdentifier='test15',ContactId = cont.Id,ProfileId = portalProfile.Id,Alias = 'test15',Email = 'test12345556@test.com',EmailEncodingKey = 'UTF-8',LastName = 'RaxTy',CommunityNickname = System.now().millisecond() + 'test123',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
            usrList.add(user2);
            
            User user3 = new User(Username = System.now().millisecond() + 'test1234@test.com',SSO_Username__c='testP123',FederationIdentifier='test1111',ContactId = conty.Id,ProfileId = portalProfile.Id,Alias = 'test1234',Email = 'test1234576@test.com',EmailEncodingKey = 'UTF-8',LastName = 'Rax',CommunityNickname = System.now().millisecond() + 'test125',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
            usrList.add(user3);
            
            User user4 = new User(Username = System.now().millisecond() + 'test12345@test.com',SSO_Username__c='testP124',FederationIdentifier='test124',ContactId = contty.Id,ProfileId = portalProfile.Id,Alias = 'test12',Email = 'test12@test.com',EmailEncodingKey = 'UTF-8',LastName = 'RaxTyyyyyy',CommunityNickname = System.now().millisecond() + 'test12',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
            usrList.add(user4);
            
            User user5 = new User(Username = System.now().millisecond() + 'test12341@test.com',SSO_Username__c='testP121',FederationIdentifier='test121',ContactId = conttty.Id,ProfileId = portalProfile.Id,Alias = 'tt141',Email = 'test121@test.com',EmailEncodingKey = 'UTF-8',LastName = 'Raxt',CommunityNickname = System.now().millisecond() + 'test121',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
            usrList.add(user5);
            Insert usrList;   
        }
        Test.StartTest();
        ProcessingExistingRecordsBatch obj = new ProcessingExistingRecordsBatch();
        Database.executeBatch(obj);
        Test.StopTest(); 
    }
    
}