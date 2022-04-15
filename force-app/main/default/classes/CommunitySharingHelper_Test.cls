@isTest
public class CommunitySharingHelper_Test {
    
    @testSetup
    static void dataSetup(){
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
        
        TestClassUtility.setTestSetupData();            
        Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId(); 
        Id conRID= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId(); 
        Id rtIdLead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead').getRecordTypeId();   
        Id oppRId= Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('INTL Cloud').getRecordTypeId();  
		
       	Account oppAcc = new Account(Name='Test Account12345',Partner_Account_Status__c='Approved',BillingCountry='India',ShippingCountry='India',RecordTypeId = accRID);
        insert oppAcc;
        
        Id accRID1= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        Account acc = new Account(Partner_Account_Status__c='Approved',ParentId=oppAcc.Id,Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =System.today(),Partner_Level__c='Referral',RecordTypeId= accRID,Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert acc; 
        
        Account childAcc = new Account(Partner_Company__c=acc.Id ,Name='childAcc 11Account',Partner_Account_Status__c='Approved',ParentId=acc.Id,Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =System.today(),Partner_Level__c='Referral',Company_Name__c=oppAcc.Id, RecordTypeId = Label.Account_Prospect_RecordType_ID);
        insert childAcc;
        
        Account ac = new Account(Name='Test C 11Account',Partner_Account_Status__c='Approved',ParentId=childAcc.Id,Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =System.today(),Partner_Level__c='Referral',Company_Name__c=oppAcc.Id, RecordTypeId = Label.Account_Prospect_RecordType_ID);
        insert ac;
            
        Account ac2 = new Account(Partner_Company__c=oppAcc.Id, Name='Test C2 11Account',Partner_Account_Status__c='Approved',ParentId=acc.Id,Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =System.today(),Partner_Level__c='Referral',Company_Name__c=acc.Id, RecordTypeId = Label.Account_Prospect_RecordType_ID);
        insert ac2;


        Contact con = new Contact(firstname='Test Contact',RecordTypeId= conRID,LastName='Test Last',AccountId=oppAcc.id,HasOptedOutOfEmail=false,Btlk_Country__c='India',Btlk_Sate_Province__c='Karnataka');
        insert con;
        oppAcc.Primary_Member__c = con.Id;
        update oppAcc;
        Lead l = new Lead(Partner_Company__c=oppAcc.Id,firstname='Testfirst1',lastname='lastname1',company='Test company1',
                          email='test.test1@test.com',LeadSource='Chat',Lead_Type__c='AWS',AnnualRevenue = 100.00,
                          Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',
                          country='India',postalcode='560037',Type_Of_Deal__c ='Referral',RecordTypeId = rtIdLead); 
        insert l;     
        Partner_Role__c pRolewithLead=new Partner_Role__c(Has_Attachment__c =true,Lead__c=l.Id,Partner_Company__c=oppAcc.Id,Role__c='Influence',Status__c='Approved',Justification__c='Testing',Commission_Role__c='Credit to this Opp-Acct');
        insert pRolewithLead; 
        Id caseRID= Schema.SObjectType.Case.getRecordTypeInfosByName().get('Partner Portal').getRecordTypeId(); 
        Case cas = new Case(Account__c= ac.Id,RecordTypeId=caseRID,Origin = 'Email',Status ='1-New',Type='Problem');
        insert cas;
            
        Profile portalProfile = [select Id from Profile where UserType = 'PowerPartner' limit 1];
        User user1 = new User(Username = System.now().millisecond() + 'test1234566@test.com',SSO_Username__c='testP1234',FederationIdentifier='test1234',ContactId = con.Id,ProfileId = portalProfile.Id,Alias = 'test123',Email = 'test1234555576@test.com',EmailEncodingKey = 'UTF-8',LastName = 'RaxTesty',CommunityNickname = System.now().millisecond() + 'test12345',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
        Database.insert(user1); 
        }
        
    }
    @isTest static void AccountShaingTest(){
        Test.StartTest();
        List<Account> acc = [Select Id,Partner_Company__c  From Account where Name='childAcc 11Account' limit 1 ];
        CommunitySharingHelper.shareRecordsOnCreation(acc,'Account');   
        Set<Id> companyId = new Set<Id>();
        companyId.add(acc[0].Id);
        CommunitySharingHelper.activeInactiveUsers(companyId,false);
        Test.StopTest();     
    } 
    @isTest static void LeadShaingTest(){
        Test.StartTest();
        List<Lead> l = [Select Id,Partner_Company__c  From Lead where Lead_Type__c='AWS' limit 1 ];
        CommunitySharingHelper.shareRecordsOnCreation(l,'Lead');
        CommunitySharingHelper.shareLeads(new List<Id>{l.get(0).Id});
        CommunitySharingHelper.shareCompaniesOnLeadConvert(l);
        Test.StopTest();  
    } 
    @isTest static void OppShaingTest(){
        Test.StartTest();
        
        Id accRID1= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        Account acc = new Account(Partner_Account_Status__c='Approved',Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =System.today(),Partner_Level__c='Referral',RecordTypeId= accRID1,Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert acc; 
        
        Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId(); 
        Account oppAcc = new Account(Name='TestAccount',Partner_Account_Status__c='Approved',ParentId=acc.Id,BillingCountry='India',ShippingCountry='India',RecordTypeId = accRID);
        insert oppAcc;

        Opportunity opty = new Opportunity(Quotingsystem__C='Datapipe',Partner_Company__c=oppAcc.Id,Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport',DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15), Lead_Id__C = 'L-GARBAGE');
        insert opty;

        Partner_Role__c pRolewithLead=new Partner_Role__c(Has_Attachment__c =true,Opportunity__c=opty.Id,Partner_Company__c=oppAcc.Id,Role__c='Influence',Status__c='Approved',Justification__c='Testing',Commission_Role__c='Credit to this Opp-Acct');
        insert pRolewithLead; 
        
        List<Opportunity> oppList = new List<Opportunity>();
        oppList.add(opty);
        
        OpportunityTriggerHelper.createOpportunityTeamMember(opty.Id, UserInfo.getUserId());
        OpportunityTriggerHelper.getPartnerRoleMap_filteredOnUser(new set<id>{opty.Id});       
        CommunitySharingHelper.shareRecordsOnCreation(oppList,'Opportunity');
        Test.StopTest();  
    }
    @isTest static void UserShaingTest(){
        Test.StartTest();
        Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
        Id caseRID= Schema.SObjectType.Case.getRecordTypeInfosByName().get('Partner Portal').getRecordTypeId();
        Account oppAcc =[Select Id from Account Where RecordTypeId =: accRID AND Name='Test Account12345' LIMIT 1];
		Opportunity opty = new Opportunity(Quotingsystem__C='Datapipe',Partner_Company__c=oppAcc.Id,Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport',DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15), Lead_Id__C = 'L-GARBAGE');
        insert opty;
        Partner_Role__c pRolewithOpp = new Partner_Role__c(Has_Attachment__c =true,Opportunity__c=opty.Id,Partner_Company__c=oppAcc.Id,Role__c='Influence',Status__c='Approved',Justification__c='Testing',Commission_Role__c='Credit to this Opp-Acct');
        insert pRolewithOpp; 
        List<User> users= [Select Id,AccountId  From User where Email='test1234555576@test.com' limit 1 ];
        CommunitySharingHelper.shareRecordsOnUserCreation(users);
        Test.StopTest();  
    }
    
    @isTest static void caseShaingTest(){
        Test.StartTest();
        List<Case> cases= [Select Id,Account__c,AccountId,Account__r.ParentId,Account__r.Parent.ParentId,Account__r.Parent.Parent.ParentId From Case where Origin = 'Email' limit 1 ];
        List<Account> accList = [SELECT Id,Name FROM Account WHERE Name ='Test C 11Account' LIMIT 1];
        cases[0].AccountId = accList[0].Id;
        update cases[0];   
        CommunitySharingHelper.shareRecordsOnCreation(cases,'Case');
        Test.StopTest();  
    }
}