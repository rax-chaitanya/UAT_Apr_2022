@isTest(seeAllData = false)
public class updatebillingaddress_Test {
    @testSetup static void setupTestData(){
        TestDataFactory.getOrgConstants();
        TestDataFactory.getProdOrgIDSetting();
        TestDataFactory.createFeatureFlags();
        insertFieldMapings();
        insertOrgConstants();
        TestDataFactory.getTriggerManagers();
    }
    public static void insertFieldMapings() {
        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountryCode', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountryCode', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'CountryCode', TargetField__c = 'Territory__c'));
        insert fieldMappings;
    }
    
    public static void insertOrgConstants() {
        Organization o = [SELECT Id FROM Organization LIMIT 1];
        ProcessDefinition p = [SELECT Id FROM ProcessDefinition WHERE DeveloperName = 'Company_Access_Request' AND Type = 'Approval' AND
                               TableEnumOrId = 'Account' LIMIT 1];
        User u = [SELECT Id FROM User WHERE alias = 'sysadmin' AND UserType = 'Standard' AND isActive = TRUE LIMIT 1];
        List<OrgConstants__c> constants = new List<OrgConstants__c>();
        constants.add(new OrgConstants__c(Name = 'Prod Org ID', Non_Prod_Value__c = o.Id, Prod_Value__c = o.Id));
        constants.add(new OrgConstants__c(Name = 'System Administrator ID', Non_Prod_Value__c = u.Id, Prod_Value__c = u.Id));
        constants.add(new OrgConstants__c(Name = 'Company Approval Process ID', Non_Prod_Value__c = p.Id, Prod_Value__c = p.Id));
        constants.add(new OrgConstants__c(Name = '#salesforce-errors', Non_Prod_Value__c = 'https://www.google.com', Prod_Value__c = 'https://www.google.com'));
        insert constants;
    }
    @IsTest static void update1(){
        
        
        DNBoptimizer__DnBCompanyRecord__c db=new DNBoptimizer__DnBCompanyRecord__c(DNBoptimizer__BusinessName__c='Alveris');
        insert db;
                Id standardcomrectypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();   

        Account a = new Account(RecordTypeId =standardcomrectypeid,Name='Test Account1234',BillingCountry='India',ShippingCountry='India',DNBoptimizer__DnBCompanyRecord__c=db.id,
                               Shippingstate='Telangana',ShippingStreet='test',ShippingCity='test',ShippingPostalCode='333');
        insert a;
        a.BillingStreet = '';
        update a;
        UpdateBillingAddress ub=new UpdateBillingAddress();
        UpdateBillingAddress.saveCompany(a.id);
        //update a;
    }
    @IsTest static void update2(){
        User u = [Select id, name, email from User where id=: UserInfo.getUserId()];
        system.runas(u){
            Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('RBU Company').getRecordTypeId();
            Account a = new Account(RecordTypeId =devRecordTypeId,Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
            insert a;
            Test.StartTest();
            UpdateBillingAddress ub=new UpdateBillingAddress();
            UpdateBillingAddress.saveCompany(a.id);
            update a;
            Delete a;
            Test.StopTest();
        }
    }
    @IsTest static void update3(){
        // User u = [Select Id,Region__c from user where isActive=:true AND Region__c=:null Limit 1];
        User u = [Select id, name, email from User where id=: UserInfo.getUserId()];
        system.runas(u){
            //   Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Account').getRecordTypeId();
            Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',DNBoptimizer__DNB_D_U_N_S_Number__c='890900',LD_USE_DnB_Optimize__c=true,Check_Address__c=true);
            insert a;
            Test.StartTest();
            AccountUpdateBatchJob jb=new AccountUpdateBatchJob();
            Database.executeBatch(jb,1);
            SchedulableContext sc = null;
            AccountUpdateBatchJobscheduled ujb=new AccountUpdateBatchJobscheduled();
            ujb.execute(sc);
            
            Test.StopTest();
        }
    }
    @IsTest static void update4(){
        User u2 = [Select Id,Region__c from user where isActive=:true  Limit 1];
        User u = [Select id, name, email from User where id=: UserInfo.getUserId()];
        system.runas(u){
            // Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Account').getRecordTypeId();
            Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
            insert a;
            Test.StartTest();
            AccountUpdateBatchJob jb=new AccountUpdateBatchJob();
            Database.executeBatch(jb);
            SchedulableContext sc = null;
            AccountUpdateBatchJobscheduled ujb=new AccountUpdateBatchJobscheduled();
            ujb.execute(sc);
            a.ownerid=u2.id;
            update a;
            Test.StopTest();
        }
    }
    @IsTest static void updatepartnerprimarymemberchange(){
        Account a1 = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert a1;
        Account a2 = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert a2;
        
        Id recordType = [Select Id from RecordType where sobjectType='Account' and Name ='Partner Company' limit 1].Id;
        Id srecordType = [Select Id from RecordType where sobjectType='Account' and Name ='Standard Company' limit 1].Id;
        Account pacc = new Account(Name = 'Test Account', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=recordType,parentid=a1.id);
        insert pacc;
        Account childAccount = new Account();
        childAccount.Name ='Test Account';
        childAccount.ParentId = pacc.Id;
        // childAccount.OwnerId = u.id;    
        insert childAccount;
        Id crecordType = [Select Id from RecordType where sobjectType='Contact' and Name ='Partner' limit 1].Id;
        Contact pcon = new Contact(FirstName='Partner',LastName='User',Email='rax.partner@rackspace.com',Phone='1233123',AccountId = pacc.Id,RecordTypeId = crecordType);
        
        insert pcon;
        pacc.IsPartner = true;
        pacc.Primary_Member__c = pcon.Id;
        pacc.Partner_Level__c ='Master Agent';
        update pacc;
        
        pacc.Partner_Account_Status__c ='Approved';
        pacc.parentid=a2.id;
        //companyhandler.StopBUAUCMPRecursion = 'After Update';
        update pacc;
        
        Contact con = new Contact(LastName ='testCon',Email='raxtest.partner@rackspace.com',AccountId = pacc.Id,RecordTypeId = crecordType);
        insert con;  
        Test.StartTest();
        Lead lead = new Lead(
            FirstName='Test',
            LastName='Lead',
            Phone='9995551235',
            Company='AAAAAAAA',
            Status='Marketing Qualified',
            Country='United States',
            State='Alabama',
            LeadSource='Site Submission',
            Partner_Company__c=pacc.id
        );
        insert lead;
        Test.StopTest();
    }
    @IsTest static void update5(){
        Id recordType = [Select Id from RecordType where sobjectType='Account' and Name ='Customer Account' limit 1].Id;
        User u2 = [Select Id,Region__c from user where isActive=:true  Limit 1];
        User u = [Select id, name, email from User where id=: UserInfo.getUserId()];
        Account a0 = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert a0;
        Account a1 = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',parentid=a0.id);
        insert a1;
        Account a2 = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',parentid=a1.id);
        insert a2;
        system.runas(u){
            // Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Account').getRecordTypeId();
            Id ProcessDefinitionID = OrgConstants__c.getInstance('Company Approval Process ID').Non_Prod_Value__c;
            
            Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',Company_Access_Submitter__c=u.id,parentid=a2.id,Industry='Finance');
            insert a;
            Account ac=new Account();
            ac.Recordtypeid=recordType;
            ac.NAme='Test';
            ac.Company_Name__c=a.id;
            //    insert ac;
            AccountUpdateBatchJob jb=new AccountUpdateBatchJob();
            Database.executeBatch(jb);
            SchedulableContext sc = null;
            AccountUpdateBatchJobscheduled ujb=new AccountUpdateBatchJobscheduled();
            ujb.execute(sc);
            a.ownerid=u2.id;
            Id systemAdministratorId;
            String sys_process_id = 'System Administrator ID';
            systemAdministratorId = (Id) OrgConstants__c.getInstance(sys_process_id).get('Prod_value__c');
            
            a.Company_Access_Submitter__c=systemAdministratorId;
            AccountTeamMember ctm = new AccountTeamMember();
            ctm.UserId = u.id;
            ctm.AccountId = a.id;
            CTM.ACCOUNTACCESSLEVEL = 'Edit';
            CTM.OpportunityACCESSLEVEL = 'Edit';
            CTM.ContacTACCESSLEVEL = 'Edit';
            CTM.CaseACCESSLEVEL = 'Edit';
            insert ctm;
            update a;
            update a2;
            Test.StartTest();
            list<Account> acclist=new list<Account>();
            acclist.add(a);
            Map<Id,Account> accMap=new Map<Id,Account>();
            CompanyTriggerHelper ch=new CompanyTriggerHelper();
            
            CompanyTriggerHelper.createPartnerUser(acclist);
            CompanyTriggerHelper.seismicIndustryMapping(acclist);
            Test.StopTest();
            try{
                
                CompanyTriggerHelper.avoidDeleteCompanies(acclist,accMap);
                Delete a;
            }catch(Exception e){}
        }
    }
    @IsTest static void updatepartnerprimarymemberchange2(){
        Account a0 = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert a0;
        Account a1 = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',parentid=a0.id);
        insert a1;
        Account a2 = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',parentid=a0.id);
        insert a2;
        
        Id recordType = [Select Id from RecordType where sobjectType='Account' and Name ='Partner Company' limit 1].Id;
        Id srecordType = [Select Id from RecordType where sobjectType='Account' and Name ='Standard Company' limit 1].Id;
        Account pacc = new Account(Name = 'Test Account', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=recordType,parentid=a1.id);
        insert pacc;
        Account childAccount = new Account();
        childAccount.Name ='Test Account';
        childAccount.ParentId = pacc.Id;
        // childAccount.OwnerId = u.id;    
        insert childAccount;
        Id crecordType = [Select Id from RecordType where sobjectType='Contact' and Name ='Partner' limit 1].Id;
        Contact pcon = new Contact(FirstName='Partner',LastName='User',Email='rax.partner@rackspace.com',Phone='1233123',AccountId = pacc.Id,RecordTypeId = crecordType);
        Test.StartTest();
        insert pcon;
        pacc.IsPartner = true;
        pacc.Primary_Member__c = pcon.Id;
        pacc.Partner_Level__c ='Master Agent';
        update pacc;
        
        pacc.Partner_Account_Status__c ='Approved';
        pacc.parentid=a2.id;
        // companyhandler.StopBUAUCMPRecursion = 'After Update';
        update pacc;
        
        Contact con = new Contact(LastName ='testCon',Email='raxtest.partner@rackspace.com',AccountId = pacc.Id,RecordTypeId = crecordType);
        insert con;  
        Lead lead = new Lead(
            FirstName='Test',
            LastName='Lead',
            Phone='9995551235',
            Company='AAAAAAAA',
            Status='Marketing Qualified',
            Country='United States',
            State='Alabama',
            LeadSource='Site Submission',
            Partner_Company__c=pacc.id
        );
        insert lead;
        list<Account> acclist=new list<Account>();
        acclist.add(pacc);
        
        CompanyTriggerHelper.createPartnerUser(acclist);
        Test.StopTest();
        
    }
    @IsTest static void updatepartnerprimarymemberchange3(){
        User u = [Select id, name, email from User where id=: UserInfo.getUserId()];
        system.runas(u){
            Account a0 = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
            insert a0;
            Account a1 = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',parentid=a0.id);
            insert a1;
            Account a2 = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',parentid=a0.id);
            insert a2;
            
            Id recordType = [Select Id from RecordType where sobjectType='Account' and Name ='Partner Company' limit 1].Id;
            Id srecordType = [Select Id from RecordType where sobjectType='Account' and Name ='Standard Company' limit 1].Id;
            Account pacc = new Account(Name = 'Test Account', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=recordType,parentid=a1.id,Partner_License_Type__c='Partner Community Login');
            insert pacc;
            Id crecordType = [Select Id from RecordType where sobjectType='Contact' and Name ='Partner' limit 1].Id;
            Contact pcon = new Contact(FirstName='Partner',LastName='User',Email='rax.partner@rackspace.com',Phone='1233123',AccountId = pacc.Id,RecordTypeId = crecordType);
            Test.starttest();
            insert pcon;
            pacc.IsPartner = true;
            pacc.Primary_Member__c = pcon.Id;
            pacc.Partner_Level__c ='Master Agent';
            update pacc;
            
            pacc.Partner_Account_Status__c ='Approved';
            pacc.parentid=a2.id;
            //companyhandler.StopBUAUCMPRecursion = 'After Update';
            update pacc;
            
            //    Contact con = new Contact(LastName ='testCon',Email='raxtest.partner@rackspace.com',AccountId = pacc.Id,RecordTypeId = crecordType);
            //    insert con;  
            
            list<Account> acclist=new list<Account>();
            acclist.add(pacc);
            
            Lead lead = new Lead(
                FirstName='Test',
                LastName='Lead',
                Phone='9995551235',
                Company='AAAAAAAA',
                Status='Marketing Qualified',
                Country='United States',
                State='Alabama',
                LeadSource='Site Submission',
                Partner_Company__c=pacc.id);
            insert lead;
            
            CompanyTriggerHelper.createPartnerUser(acclist);
            CompanyTriggerHelper.seismicIndustryMapping(acclist);
            /*  Profile p = [Select id from Profile where name = 'Rackspace-Partners' limit 1];
User user = new User(alias = 'test123', email='test123@noemail.com',
emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
ContactId = con.Id,
timezonesidkey='America/Los_Angeles', username='raxteest.partner@rackspace.com');

insert user;
user us=[select id,AccountId from user where AccountId!='' Limit 1];
Lead lead = new Lead(
FirstName='Test',
LastName='Lead',
Phone='9995551235',
Company='AAAAAAAA',
Status='Marketing Qualified',
Country='United States',
State='Alabama',
LeadSource='Site Submission',
Partner_Company__c=pacc.id);*/
            
            
            Test.StopTest();
        }
    }
    @IsTest static void updatepartnerprimarymemberchange4(){
        
        User u = [Select id, name, email from User where id=: UserInfo.getUserId()];
        system.runas(u){
            Account a0 = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
            insert a0;
            Account a1 = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',parentid=a0.id);
            insert a1;
            Account a2 = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',parentid=a0.id);
            insert a2;
            
            // insert child Account
            Account childAccount = new Account();
            childAccount.Name ='Test Account';
            childAccount.ParentId = a2.Id;
            childAccount.OwnerId = u.id;    
            insert childAccount;
            
            // System.assertEquals(a2.OwnerId, childAccount.OwnerId);    
            
            Id recordType = [Select Id from RecordType where sobjectType='Account' and Name ='Partner Company' limit 1].Id;
            Id srecordType = [Select Id from RecordType where sobjectType='Account' and Name ='Standard Company' limit 1].Id;
            Account pacc = new Account(Name = 'Test Account', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=recordType,parentid=a1.id,Partner_License_Type__c='Partner Community Login');
            insert pacc;
            Id crecordType = [Select Id from RecordType where sobjectType='Contact' and Name ='Partner' limit 1].Id;
            Contact pcon = new Contact(FirstName='Partner',LastName='User',Email='rax.partner@rackspace.com',Phone='1233123',AccountId = pacc.Id,RecordTypeId = crecordType);
            Test.starttest();
            insert pcon;
            pacc.IsPartner = true;
            pacc.Primary_Member__c = pcon.Id;
            pacc.Partner_Level__c ='Master Agent';
            update pacc;
            
            pacc.Partner_Account_Status__c ='Approved';
            pacc.parentid=a2.id;
            update pacc;
            a2.parentid=a1.id;
            //companyhandler.StopBUAUCMPRecursion = 'After Update';
            update a2;
            //  Contact con = new Contact(LastName ='testCon',Email='raxtest.partner@rackspace.com',AccountId = pacc.Id,RecordTypeId = crecordType);
            //  insert con;  
            
            list<Account> acclist=new list<Account>();
            acclist.add(pacc);
            
            
            CompanyTriggerHelper.createPartnerUser(acclist);
            CompanyTriggerHelper.seismicIndustryMapping(acclist);
            Id rtIdLead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead').getRecordTypeId(); 
            Lead l = new Lead(Partner_Company__c=pacc.Id,firstname='Testfirst1',lastname='lastname1',company='Test company1',
                              email='test.test1@test.com',LeadSource='Chat',Lead_Type__c='AWS',AnnualRevenue = 100.00,
                              Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',
                              country='India',postalcode='560037',Type_Of_Deal__c ='Referral',RecordTypeId = rtIdLead); 
            insert l;
            // Profile portalProfile = [select Id from Profile where Name = 'Rackspace - Partners Login' limit 1];
            // User user1 = new User(Username = System.now().millisecond() + 'test1234566@test.com',SSO_Username__c='testP1234',FederationIdentifier='test1234',ContactId = con.Id,ProfileId = portalProfile.Id,Alias = 'test123',Email = 'test1234555576@test.com',EmailEncodingKey = 'UTF-8',LastName = 'RaxTesty',CommunityNickname = 'test12345',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
            // Database.insert(user1);
            List<LeadShare> lshares = [Select Id from LeadShare where leadId =: l.Id];
            
            Test.StopTest();
        }
    }
    @IsTest static void createpartnertest(){
        User u = [Select id, name, email from User where id=: UserInfo.getUserId()];
        system.runas(u){
            Id recordType = [Select Id from RecordType where sobjectType='Account' and Name ='Partner Company' limit 1].Id;
            Id srecordType = [Select Id from RecordType where sobjectType='Account' and Name ='Standard Company' limit 1].Id;
            Account a2 = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
            insert a2;
            Account pacc = new Account(ParentId=a2.id,Name = 'Test Account', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=recordType,Partner_License_Type__c='Partner Community Login');
            insert pacc;
            // insert child Account
            Account childAccount = new Account();
            childAccount.Name ='Test Account';
            childAccount.ParentId = pacc.Id;
            childAccount.OwnerId = u.id;    
            insert childAccount;
            
            //   System.assertEquals(pacc.OwnerId, childAccount.OwnerId);    
            Id crecordType = [Select Id from RecordType where sobjectType='Contact' and Name ='Partner' limit 1].Id;
            Contact pcon = new Contact(FirstName='Partner',LastName='User',Email='rax.partner@rackspace.com',Phone='1233123',AccountId = pacc.Id,RecordTypeId = crecordType);
            insert pcon;
            pacc.IsPartner = true;
            pacc.Primary_Member__c = pcon.Id;
            pacc.Partner_Level__c ='Master Agent';
            //companyhandler.StopBUAUCMPRecursion = 'After Update';
            update pacc;
            /*Profile p = [Select ID, Name from Profile Where Name = 'Partner Community Login User'];

User u1 = New User(
UserName = 'test_' + math.random() + '@test.com',
FirstName = 'Test-First',
LastName = 'Test-Last',
Alias = 'test',
email = 'test' + math.random() + '@test.com',
CommunityNickName = string.valueOf(math.random()).substring(0,6),
ProfileID = p.id,
TimeZoneSidKey = 'America/New_York', 
LocaleSidKey = 'en_US', 
EmailEncodingKey = 'UTF-8', 
LanguageLocaleKey = 'en_US',
ContactID = pcon.id

);

insert u1;*/
            
            
            list<Account> acclist=new list<Account>();
            acclist.add(pacc);
            
            Test.starttest();
            CompanyTriggerHelper.createPartnerUser(acclist);
            CompanyTriggerHelper.seismicIndustryMapping(acclist);
            Test.stoptest();
            
        }
    }
    @IsTest static void DelAccTest(){
        Profile p = [Select ID, Name from Profile Where Name = 'System Administrator'];
        
        User u1 = New User(
            UserName = 'test_' + math.random() + '@test.com',
            FirstName = 'Test-First',
            LastName = 'Test-Last',
            Alias = 'test',
            email = 'test' + math.random() + '@test.com',
            CommunityNickName = string.valueOf(math.random()).substring(0,6),
            ProfileID = p.id,
            TimeZoneSidKey = 'America/New_York', 
            LocaleSidKey = 'en_US', 
            EmailEncodingKey = 'UTF-8', 
            LanguageLocaleKey = 'en_US',
            Region__c='APAC'
        );
        
        insert u1;
        system.runas(u1){
            
            Id recordType = [Select Id from RecordType where sobjectType='Account' and Name ='Customer Account' limit 1].Id;
            
            
            
            Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',Industry='Finance');
            insert a;
            Account ac=new Account();
            ac.Recordtypeid=recordType;
            ac.NAme='Test';
            ac.Company_Name__c=a.id;
            insert ac; 
            try{
                Delete a;
            }catch(Exception e){} 
            Test.StartTest();
            Id partnerrecordType = [Select Id from RecordType where sobjectType='Account' and Name ='Partner Company' limit 1].Id;
            Account pacc = new Account(Name = 'Test Account', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=partnerrecordType,Partner_License_Type__c='Partner Community Login');
            insert pacc;
            Account childAccount = new Account();
            childAccount.Name ='Test Account';
            childAccount.ParentId = pacc.Id;
            // childAccount.OwnerId = u.id;
            childAccount.BillingCountry = 'India'; 
            childAccount.BillingState='Karnataka';   
            insert childAccount;
            Id crecordType = [Select Id from RecordType where sobjectType='Contact' and Name ='Partner' limit 1].Id;
            Contact pcon = new Contact(FirstName='Partner',LastName='User',Email='rax.partner@rackspace.com',Phone='1233123',AccountId = pacc.Id,RecordTypeId = crecordType);
            
            insert pcon;
            pacc.IsPartner = true;
            pacc.Primary_Member__c = pcon.Id;
            pacc.Partner_Level__c ='Master Agent';
            update pacc;
            
            pacc.Partner_Account_Status__c ='Approved';
            //companyhandler.StopBUAUCMPRecursion = 'After Update';
            update pacc;
            
            Test.StopTest();
            
        }
    }  
    private static testmethod void testBeforeAfterInsertUpdateDeleteUndelete() {         
        User FMW_User = [SELECT Id FROM User WHERE Id = :Id.valueOf(Label.FMW_API_User) LIMIT 1];
        FMW_User.Region__c = 'AMER';
        
        System.runAs(FMW_User) {
            List<RecordType> customerType = new List<RecordType>();
            customerType = [SELECT Id FROM RecordType WHERE Name = 'Customer Account' AND SObjectType = 'Account'];
            if(!customerType.isEmpty()) {
                Account comp = new Account(Name = 'test', BillingCountry = 'United States', ShippingCountry = 'United States');
                insert comp;
                
                Contact con = new Contact(FirstName = 'First', LastName = 'Last', AccountId = comp.Id);
                insert con;
                
                
                Account comp1 = new Account(Name = 'test', BillingCountry = 'Canada', ShippingCountry = 'Canada');
                insert comp1;  
                
                
                Test.startTest();
                List<Account> accList = new List<Account>();
                accList.add(new Account(Name = 'testComp', Company_Name__c = comp.Id,
                                        RecordTypeId = customerType.get(0).Id, Menu_Pricing_Approved__c = TRUE,DDI__c='1234'));
                accList.add(new Account(Name = 'testComp1', Company_Name__c = comp1.Id,
                                        RecordTypeId = customerType.get(0).Id, Menu_Pricing_Approved__c = TRUE));
                insert accList;
                
                //insert new Task(Type = 'Email',Description = 'Test desc',OwnerId = UserInfo.getUserId(),WhatId = accList.get(0).id);
                //insert new Event(Whatid=accList.get(0).id,Subject='Testing',DurationInMinutes=40,ActivityDateTime = System.now());
                Opportunity opty = new Opportunity(Was_a_Partner_Involved__c='Yes',Type = 'Rackspace Cloud',DDI__c='1234',Name='Test Opport',AccountId=comp.Id,
                                                   Account__c=accList.get(0).id,StageName='Stage 1 - Planning & Identification',CloseDate=System.today());
                insert opty;
                
                Opportunity opty1 = new Opportunity(Was_a_Partner_Involved__c='Yes',Type = 'Rackspace Cloud',Name='Test Opport1',AccountId=comp.Id,Account__c=accList.get(0).id,StageName='Stage 1 - Planning & Identification',CloseDate=System.today());
                insert opty1;
                
                
                
                //     accList.get(0).Shipping_Country__c = 'Canada';
                //   accList.get(1).Shipping_Country__c = 'United States';
                accList.get(1).ContractingEntityApproved__c = 'Approved';
                accList.get(1).Menu_Pricing_Approved__c = FALSE;
                update accList;
                Test.stopTest();
                
               // delete accList;
               // undelete accList;
                delete [SELECT Id FROM Trigger_Manager__c WHERE Name = 'AccountTrigger'];
                update accList;
                
                delete opty;
                undelete opty;
            }
        }
    }
    @IsTest static void checkdel(){
        Profile p = [Select id from Profile where name = 'Rax Standard-INTL' limit 1];
        User user = new User(alias = 'test123', email='test123@noemail.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
                             timezonesidkey='America/Los_Angeles', username='test1@rackspace.com');
        
        insert user;
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'LA_Cloud_Office_Support_Permission_Set'];
        
        insert new PermissionSetAssignment(AssigneeId = user.id, PermissionSetId = ps.Id);
        
        system.runas(user){
            
            
            
            CompanyTriggerHelper ch=new CompanyTriggerHelper();
            Map<Id,Account> accMap=new Map<Id,Account>();
            
            list<Account> acclist=new list<Account>();
            
            /* Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
insert a; */
            
            string companyRecordTypeId =  Schema.sObjectType.account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
            
            string productAccountRecordTypeId =  Schema.sObjectType.account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
            Account cmpAc = new Account(Name='Comp account',RecordTypeId =companyRecordTypeId,BillingCountry='India',ShippingCountry='India',territory__c = 'ANZ');
            insert cmpAc ;
            
            Account a = new Account(Name='Test Account1234',RecordTypeId =productAccountRecordTypeId,BillingCountry='India',ShippingCountry='India',company_name__C = cmpAc.id);
            insert a;
            acclist.add(a);
            
            CompanyTriggerHelper.avoidDeleteCompanies(new list<Account>(),new Map<Id,Account>());
            try{
                delete acclist;
            }   catch(exception ex){
                System.assert(ex.getMessage().contains(Label.Avoid_Company_Delete));
            }   
        }
    }    
    @IsTest static void checkdel1(){
        Profile p = [Select id from Profile where name = 'Rax Standard-INTL' limit 1];
        User user = new User(alias = 'test123', email='test123@noemail.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
                             timezonesidkey='America/Los_Angeles', username='test1@rackspace.com');
        
        insert user;
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'LA_Cloud_Office_Support_Permission_Set'];
        
        insert new PermissionSetAssignment(AssigneeId = user.id, PermissionSetId = ps.Id);
        
        system.runas(user){
            
            
            
            CompanyTriggerHelper ch=new CompanyTriggerHelper();
            Map<Id,Account> accMap=new Map<Id,Account>();
            
            list<Account> acclist=new list<Account>();
            
            /* Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
insert a; */
            
            string companyRecordTypeId =  Schema.sObjectType.account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
            
            string productAccountRecordTypeId =  Schema.sObjectType.account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
            Account cmpAc = new Account(Name='Comp account',RecordTypeId =companyRecordTypeId,BillingCountry='India',ShippingCountry='India',territory__c = 'ANZ');
            insert cmpAc ;
            
            Account a = new Account(Name='Test Account1234',RecordTypeId =productAccountRecordTypeId,BillingCountry='India',ShippingCountry='India',company_name__C = cmpAc.id);
            insert a;
            acclist.add(a);
            CompanyTriggerHelper.avoidDeleteCompanies(acclist,accMap);
            
            try{
                delete acclist;
            }   catch(exception ex){
                System.assert(ex.getMessage().contains(Label.Avoid_Company_Delete));
            }   
        }
    } 
    @isTest static void ACRUpdateRoleTest(){
        Trigger_Manager__c Tm = new Trigger_Manager__c (Name ='ContactTgr1',Is_Active__c = true);
        insert Tm;
        Id devRecordTypeId3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();   
        Id condevRecordTypeId3 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId();  
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account').getRecordTypeId();
        string productAccountRecordTypeId =  Schema.sObjectType.account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();

        Account a = new Account(RecordTypeId =devRecordTypeId3,Name='Test Account1234',BillingCountry='Australia',ShippingCountry='Australia',Partner_Account_Status__c='Approved');

        Account a1 = new Account(RecordTypeId =devRecordTypeId3,Name='Test Account12345',BillingCountry='Australia',ShippingCountry='Australia',Partner_Account_Status__c='Approved');
        insert a1;
        Contact c = new Contact(RecordTypeId =condevRecordTypeId3,firstname='Test Contact',LastName='Test Last',AccountId=a1.id,mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California');
        insert c;
        Contact c2 = new Contact(RecordTypeId =condevRecordTypeId3,firstname='Test Contact',LastName='Test Last',AccountId=a1.id,mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California');
        insert c2;
        Account ac = new Account(RecordTypeId =productAccountRecordTypeId,Name='Test C Account',Company_Name__c=a.Id,DDI__c='123456');
        //insert ac;
        AccountContactRelation acr1=new AccountContactRelation(Contactid=c.id,Accountid=ac.id,Roles='Primary Contact');
       //insert acr1;
        User u=[Select id from User where id=:Label.FMW_API_User];
        System.runAs(u){  
            AccountContactRelation acr2=new AccountContactRelation(Contactid=c2.id,Accountid=ac.id,Roles='Primary Contact');
          //  insert acr2;
        }
    }	
}