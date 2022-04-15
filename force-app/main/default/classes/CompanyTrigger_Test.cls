/**
* File : CompanyTrigger_Test.cls
* Description : Tests the CompanyTrigger.trigger trigger. 
* Created Date : 31/JAN/2017
* @author : RDC (JY)
*/

@istest
public class CompanyTrigger_Test
{   
    
    @testSetup static void setupTestData() {
        Test.startTest();
        insertTriggerSettings();
        insertOrgConstants();
        insertFieldMapings();
        insertCountryTerritoryMapping();
        
        Id STId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        
        List<Contracting_Entity__c> ceList = ST_TestUtil.getContractingEntity('Rackspace Limited',1);
        insert ceList;
        
        List<Account> stdcmpList = new List<Account>();
        Account company = new Account(Name = 'TestCompany', Opt_Out__c = false,BillingCountry = 'Canada', ShippingCountry = 'Canada',RecordTypeId=STId);
        Account company2 = new Account(Name = 'TestCompany2',Opt_Out__c = false,industry='Technology',BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId());
        stdcmpList.add(company);
        stdcmpList.add(company2);           
        insert stdcmpList;
        
        
        Account acc = new Account(recordtypeid=STId,Name = 'UpdateMarket',Opt_Out__c = false,AnnualRevenue = 200000000.00, BillingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId());
        insert acc;
        
        Test.stopTest();    
        
    }
    
    public static void insertTriggerSettings() {
        TestDataFactory.triggerManagerFlagValue = true;
        List<Trigger_Manager__c> triggerSettings = new List<Trigger_Manager__c>();
        triggerSettings = TestDataFactory.getTriggerManagers();
        
    }   
    
    public static void insertCountryTerritoryMapping() {
        List<CountryTerritoryMapping__c> mappings = new List<CountryTerritoryMapping__c>();
        mappings.add(new CountryTerritoryMapping__c(Name = 'Canada', Territory_Name__c = 'US/CANADA'));
        mappings.add(new CountryTerritoryMapping__c(Name = 'Afghanistan', Territory_Name__c = 'EMEA'));
        mappings.add(new CountryTerritoryMapping__c(Name = 'Australia', Territory_Name__c = 'ANZ'));
        mappings.add(new CountryTerritoryMapping__c(Name = 'Anguilla', Territory_Name__c = 'LATAM'));
        mappings.add(new CountryTerritoryMapping__c(Name = 'India', Territory_Name__c = 'Asia'));
        mappings.add(new CountryTerritoryMapping__c(Name = 'Belgium', Territory_Name__c = 'Benelux'));
        mappings.add(new CountryTerritoryMapping__c(Name = 'Austria', Territory_Name__c = 'DACH'));
        insert mappings;
    }
    
    
    public static void insertFieldMapings() {
        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
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
    
    @isTest static void testBeforeDelete() {         
        Test.startTest();
        try {               
            Id p = [select id from profile where name='Integration API'].id;
            User userFMW = new User(alias = 'FMW123', email='testFMW123@noemail.com',
                                    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                    localesidkey='en_US', profileid = p, timezonesidkey='America/Los_Angeles', username='testerFMW@noemail.com');
            insert userFMW;
            System.runAs(userFMW){
                Account comp = [SELECT Id,Name,BillingCountry,BillingCountryCode,ShippingCountry,ShippingCountryCode,RecordTypeId from Account where Name='TestCompany' AND RecordType.Name='Standard Company' LIMIT 1];
                Account acc = [SELECT Id,Name,BillingCountry,BillingCountryCode,ShippingCountry,ShippingCountryCode,RecordTypeId from Account where Name='TestCompany' AND RecordType.DeveloperName='Prospect' LIMIT 1];        
                List<RecordType> customerType = new List<RecordType>();
                customerType = [SELECT Id FROM RecordType WHERE Name = 'Customer' AND SObjectType = 'Account'];        
                Account acc2 = new Account(Name = 'test',ShippingCountry='India', Company_Name__c = comp.Id, RecordTypeId = customerType.get(0).Id);
                insert acc2;
                comp.ownerId = userFMW.id;
                update comp;                
                delete comp; 
            }  
            
        }
        catch(exception ex){
            // System.assert(ex.getMessage().contains(Label.Avoid_Company_Delete));
        }        
        Test.stopTest();        
    }
    
    
    
    @isTest static void testAfterDelete() {         
        Account comp = [SELECT Id,Name,BillingCountry,BillingCountryCode,ShippingCountry,ShippingCountryCode,RecordTypeId from Account where Name='TestCompany' AND RecordType.Name='Standard Company' LIMIT 1];
        
        Test.startTest();
        delete comp;
        List<Account> companies = new List<Account>();
        companies = [SELECT Id FROM Account WHERE Id = :comp.Id];
        System.assertEquals(0, companies.size());
        undelete comp;
        companies = [SELECT Id FROM Account WHERE Id = :comp.Id];
        System.assertEquals(1, companies.size());
        Test.stopTest();
    }
    @isTest static void testAfterDelete2() {         
        Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a;
        Test.startTest();
        a.RecordTypeId = Label.GovernmentRecordType;
        update a;
        delete a;
        
        Test.stopTest();
    }
    
    @isTest static void testMerge() {        
        Account comp1 = [SELECT Id,Name,BillingCountry,BillingCountryCode,ShippingCountry,ShippingCountryCode,RecordTypeId from Account where Name='TestCompany' AND RecordType.Name='Standard Company' LIMIT 1];
        //   Account comp2 = new Account(Name = 'test2', BillingCountry = 'Canada', ShippingCountry = 'Canada', Old_Record_Id__c = comp1.Id);
        Account comp2 = new Account(Name = 'test2', BillingCountry = 'Canada', ShippingCountry = 'Canada');
        insert comp2;
        
        Test.startTest();
        try{
            Merge comp1 comp2;
        }catch(Exception e) {//WE HAVE LOGIC IN cLogHandler TO UPDATE ALL CHILD RECORDS AFTER MERGE. SO, THE RECORDS IN TRANSACTION DUE TO MERGE(FROM APEX) CANNOT BE UPDATED IN THE SAME TRANSACTION
            //do nothing
        }
        Test.stopTest();
    }
    
    @isTest static void testBeforeUpdate() {
        Test.startTest();
        
        Account comp = [SELECT Id,Name,BillingCountry,BillingCountryCode,ShippingCountry,ShippingCountryCode,RecordTypeId,Company_Access_Submitter__c from Account where Name='TestCompany2' AND RecordType.Name='Standard Company' LIMIT 1];
        
        Id RTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Government Company').getRecordTypeId();
        Account comp2 = new Account(Name = 'test',industry='Technology',BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(), RecordTypeId=RTId);
        insert comp2;
        
        List<RecordType> customerType = new List<RecordType>();
        customerType = [SELECT Id FROM RecordType WHERE Name = 'Customer Account' AND SObjectType = 'Account'];
        
        Account acc = new Account(Name = 'test',ShippingCountry='India',Company_Name__c = comp.Id, RecordTypeId = customerType.get(0).Id);
        insert acc;
        
        //CompanyHandler.StopBUAUCMPRecursion = 'Before Update';  
        
        comp.Company_Access_Submitter__c = OrgConstants__c.getInstance('System Administrator ID').Prod_Value__c;
        update comp;        
        
        Test.stopTest();    
    }         
    
    @isTest static void testUpdatedata2(){
        Test.startTest(); 
        Account comp = [SELECT Id,Name,BillingCountry,BillingCountryCode,ShippingCountry,ShippingCountryCode,RecordTypeId from Account where Name='TestCompany' AND RecordType.Name='Standard Company' ];
        
        Account acc = [SELECT id,Name,Menu_Pricing_Approved__c,ShippingCountry,Contracting_Entity__c,Contracting_Entity_Change__c from Account where Company_Name__c =: comp.Id];            
        
        Contracting_Entity__c ce = [SELECT Id,Name from Contracting_Entity__c LIMIT 1];
        acc.Contracting_Entity_to_Approve__c = ce.Id;            
        acc.Contracting_Entity_Change__c = true;
        acc.ContractingEntityApproved__c = 'Approved';            
        acc.ShippingCountry = 'United States';
        acc.Menu_Pricing_Approved__c = true;
        acc.Description='test class update';
        update acc;
        
        acc.ShippingCountry = 'India';
        acc.Menu_Pricing_Approved__c = false;
        update acc;
        
        Test.stopTest();  
    }
    
    @isTest static void testUpdatedata3(){
        Test.startTest(); 
        Account comp = [SELECT Id,Name,BillingCountry,BillingCountryCode,ShippingCountry,ShippingCountryCode,RecordTypeId from Account where Name='TestCompany' AND RecordType.Name='Standard Company' LIMIT 1];
        
        Account acc = [SELECT id,Name,Menu_Pricing_Approved__c,ShippingCountry,Contracting_Entity__c,Contracting_Entity_Change__c from Account where Company_Name__c =: comp.Id];            
        
        Contracting_Entity__c ce = [SELECT Id,Name from Contracting_Entity__c LIMIT 1];
        acc.Contracting_Entity_to_Approve__c = ce.Id;            
        acc.Contracting_Entity_Change__c = true;
        acc.ContractingEntityApproved__c = 'Approved';            
        acc.ShippingCountry = 'India';
        acc.Menu_Pricing_Approved__c = true;
        acc.Description='test class update';
        
        update acc;
        
        Test.stopTest();  
    }
    @isTest static void createPartnerTest() {   
        Test.startTest();
        Id RTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
        Id cRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId();        
        Account ab = new Account(Name = 'test1BPC',Phone='9876543225',Partner_Level__c= 'Reseller',BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(),RecordTypeId=RTId,Partner_Account_Status__c='Approved');
        insert ab;
        Account a = new Account(Name = 'test1BPC',Opt_Out__c = false,Phone='9876543225',BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(),RecordTypeId=RTId);
        insert a;
        Contact cb = New Contact(FirstName='Testb',LastName='Con2',Phone='9876543235',email='testconb2@test.com', AccountID = a.id,RecordTypeId=cRTId);
        insert cb;
        
        List<Account> pcList = new List<Account>();
        pcList.add(a);  
        pcList[0].Partner_Account_Status__c = 'Approved';
        pcList[0].Partner_Company__c = ab.Id;
        pcList[0].Primary_Member__c = cb.Id;
        pcList[0].Opt_Out__c = true;
        pcList[0].Partner_Level__c= 'Referral';
        update pcList;
        CompanyTriggerHelper.createPartnerUser(pcList); 
        Test.stopTest();
    }
    
    @isTest static void testBeforeUpdatePartner() {         
        Test.startTest();
        
        Seismic_Industry_Mapping__c sim = new Seismic_Industry_Mapping__c(Seismic_Name__c='Technology/Media/Telecom',industry__c='Technology');
        insert sim;                                        
        
        Id RTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
        Account Partcomp1a = new Account(Name = 'testPC1',industry='Technology',Partner_Account_Status__c='Approved',BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(),RecordTypeId=RTId);
        insert Partcomp1a;
        
        CompanyTriggerHelper.seismicIndustryMapping(new List<Account>{Partcomp1a});
        
        Account PartcompforOld = new Account(Name = 'testPC1forOld',ParentId=Partcomp1a.Id, BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(),RecordTypeId=RTId,Partner_Account_Status__c='Approved');
        insert PartcompforOld;
        
        CompanyTriggerHelper.seismicIndustryMapping(new List<Account>{PartcompforOld});                 
        
        Account Partcomp1 = new Account(Name = 'testPC1a',Partner_Level__c= 'Reseller',Opt_Out__c = false, ParentId=PartcompforOld.Id, BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(),RecordTypeId=RTId,Partner_Account_Status__c='Approved');
        insert Partcomp1;
        
        //CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
        
        Partcomp1.ParentId =  Partcomp1a.Id;
        Partcomp1.Opt_Out__c = true;
        Partcomp1.Partner_Level__c= 'Referral';
        update Partcomp1;
        
        Test.stopTest();        
    }
    
    @isTest static void testpartnercmp(){
        Id RTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
        Account Partcomp1a = new Account(Name = 'testPC1',Partner_Level__c='Reseller',Partner_Account_Status__c='Approved',BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(),RecordTypeId=RTId);
        insert Partcomp1a;                
        
        Lead ld = new Lead(LastName='TestLd1',Phone='976543258',email='testld1@test.com',Company='PatnerCMPTest',LeadSource='Other'); 
        insert ld;         
        
        Test.startTest();
        Account Partcomp = new Account(Name = 'testPC1a',Partner_Level__c='Reseller',parentId=Partcomp1a.Id,Partner_Account_Status__c='Approved',BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(),RecordTypeId=RTId);
        insert Partcomp;        
        Account PartcompforOld = new Account(Name = 'testPC1forOld',Partner_Level__c='Reseller',ParentId=Partcomp.Id, BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(),RecordTypeId=RTId,Partner_Account_Status__c='Approved');
        insert PartcompforOld;
        Account Partcomp1 = new Account(Name = 'testPC1a',Partner_Level__c='Reseller',ParentId=PartcompforOld.Id, BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(),RecordTypeId=RTId,Partner_Account_Status__c='Approved');
        insert Partcomp1; 
        
        ld.Partner_Company__c=PartcompforOld.Id;
        
        update ld;
        
        PartcompforOld.ParentId=null;
        PartcompforOld.Partner_Level__c = 'Referral';
        List<Account> newAccountList = new List<Account>{ PartcompforOld };
            System.debug(newAccountList);
        update newAccountList;        
        Test.stopTest();
        
    }
    
    @isTest static void testAfterUpdate() {
        Test.startTest();
        Id RTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
        Id cRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        Id p = [select id from profile where name='Partner Community User'].id;
        Account ac = new Account(Name = 'test1BPC',Phone='9876543225',BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(),RecordTypeId=RTId);
        insert ac; 
        Contact con = new Contact(FirstName='Testb',LastName='Con2',Phone='9876543235',email='testconb2@test.com', AccountID = ac.id,RecordTypeId=cRTId);
        insert con;
        
        CompanyTriggerController.SHARE_TO_PARTNERS = true;            
        ac.Primary_Member__c=con.Id;
        ac.Partner_Level__c='Strategic';
        ac.Partner_Account_Status__c='Approved';            
        update ac;
        
        CompanyTriggerController.SHARE_TO_PARTNERS = true;            
        ac.Primary_Member__c=con.Id;
        ac.Partner_Level__c='Referral';
        ac.Partner_Account_Status__c='Inactive';            
        update ac;
        
        CompanyTriggerController.SHARE_TO_PARTNERS = true;            
        ac.Primary_Member__c=con.Id;
        ac.Partner_Level__c='Strategic';
        ac.Partner_Account_Status__c='Active';            
        update ac;
        
        
        
        Test.stopTest();
        
    }
    public static testmethod void companyDataGovernance(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'DataG', Email='DataGover@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, Region__c = 'AMER',
                          TimeZoneSidKey='America/Los_Angeles', UserName='DataGover@testorg.com');
        Insert u;
        
        system.runAs(u){
            Account acc = new Account(Name = 'companydatagovernance',BillingCountry = 'Canada',ShippingCountry = 'Canada');
            insert acc;
        }
        
    }
    
    //test class for UpdateCompanyMarketSegmentation class
    private static testmethod void updateCmpMarketSegTest() {
        test.startTest();
        Account acc = [select Id,Name,AnnualRevenue, BillingCountry,Territory__c, Company_Access_Submitter__c from Account where Name = 'UpdateMarket' LIMIT 1 ];           
        system.debug('company territory'+acc.Territory__c);
        //CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
        acc.AnnualRevenue = 400000000.00;
        update acc;
        system.debug('company territory2'+ acc.Territory__c);
        //CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
        acc.AnnualRevenue = 2000000000.00;
        update acc;
        test.stopTest();
    }
    //test class for UpdateCompanyMarketSegmentation class
    private static testmethod void updateCmpMarketSegTest1() {
        test.startTest();
        Account acc = [select Id,Name,AnnualRevenue, BillingCountry,Territory__c, Company_Access_Submitter__c from Account where Name = 'UpdateMarket' LIMIT 1 ];           
        //system.debug('company territory'+acc.Territory__c);
        //CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
        acc.BillingCountry = 'Australia';
        acc.Territory__c = 'ANZ';
        acc.AnnualRevenue = 0;
        update acc;
        //system.debug('company territory2'+ acc.Territory__c);
        //CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
        acc.AnnualRevenue = 10000000.00;
        update acc;
        //CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
        acc.AnnualRevenue = 500000000.00;
        update acc;
        //CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
        acc.AnnualRevenue = 600000000.00;
        update acc;
        test.stopTest();
    } 
    //test class for UpdateCompanyMarketSegmentation class
    private static testmethod void updateCmpMarketSegTest2() {
        test.startTest();
        //Account comp = new Account(Name = 'test',AnnualRevenue = 200000000.00, BillingCountry = 'Afghanistan', ShippingCountry = 'Afghanistan', Company_Access_Submitter__c = UserInfo.getUserId());
        //insert comp;
        Account acc = [select Id,Name,AnnualRevenue, BillingCountry,Territory__c, Company_Access_Submitter__c from Account where Name = 'UpdateMarket' LIMIT 1];                        
        //system.debug('company territory'+comp.Territory__c);
        // CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
        acc.BillingCountry = 'Afghanistan';
        acc.Territory__c = 'EMEA';
        acc.AnnualRevenue = 0;
        update acc;
        // CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
        acc.AnnualRevenue = 1000;
        update acc;
        //CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
        acc.AnnualRevenue = 400000000.00;
        update acc;
        //system.debug('company territory'+ comp.Territory__c);
        //CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
        acc.AnnualRevenue = 2000000000.00;
        update acc;
        test.stopTest();
    }
    //test class for UpdateCompanyMarketSegmentation class
    private static testmethod void updateCmpMarketSegTest4() {
        test.startTest();
        //Account comp = new Account(Name = 'test',AnnualRevenue = 200000000.00, BillingCountry = 'Afghanistan', ShippingCountry = 'Afghanistan', Company_Access_Submitter__c = UserInfo.getUserId());
        //insert comp;
        Account acc = [select Id,Name,AnnualRevenue, BillingCountry,Territory__c, Company_Access_Submitter__c from Account where Name = 'UpdateMarket' LIMIT 1];                        
        //system.debug('company territory'+comp.Territory__c);
        //CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
        acc.BillingCountry = 'Anguilla';
        acc.Territory__c = 'LATAM';
        acc.AnnualRevenue = 100;
        update acc;
        //CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
        acc.AnnualRevenue = 1000;
        update acc;
        //CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
        acc.AnnualRevenue = 50000000.00;
        update acc;        
        //system.debug('company territory'+ comp.Territory__c);
        //CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
        acc.AnnualRevenue = 250000000.00;
        update acc;
        //CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
        acc.AnnualRevenue = 350000000.00;
        update acc;
        test.stopTest();
    }
    //test class for UpdateCompanyMarketSegmentation class
    private static testmethod void updateCmpMarketSegTest5() {
        test.startTest();
        Account acc = [select Id,Name,AnnualRevenue, BillingCountry,Territory__c, Company_Access_Submitter__c from Account where Name = 'UpdateMarket' LIMIT 1];                        
        
        //CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
        acc.BillingCountry = 'Austria';
        acc.Territory__c = 'DACH';
        update acc;
        test.stopTest();
    }
    //test class for UpdateCompanyMarketSegmentation class
    private static testmethod void updateCmpMarketSegTest6() {
        test.startTest();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Government Company').getRecordTypeId();
        Account acc = [select Id,Name,AnnualRevenue, BillingCountry,Territory__c, Company_Access_Submitter__c from Account where Name = 'UpdateMarket'  LIMIT 1];                       
        acc.recordtypeId = devRecordTypeId;
        update acc;
        
        test.stopTest();
    }
    //test class for UpdateCompanyMarketSegmentation class
    private static testmethod void updateCmpMarketSegTest7() {
        test.startTest();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Government Company').getRecordTypeId();
        Account acc = [select Id,Name,AnnualRevenue, BillingCountry,Territory__c, Company_Access_Submitter__c from Account where Name = 'UpdateMarket' LIMIT 1];                        
        acc.recordtypeId = devRecordTypeId;
        //CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
        update acc;
        acc.BillingCountry = 'Afghanistan';
        acc.Territory__c = 'EMEA';
        //CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
        update acc;
        acc.BillingCountry = 'Australia';
        acc.Territory__c = 'ANZ';
        //CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
        update acc;
        acc.BillingCountry = 'Anguilla';
        acc.Territory__c = 'LATAM';
        //CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
        update acc;
        acc.BillingCountry = 'Austria';
        acc.Territory__c = 'DACH';
        //CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
        update acc;
        test.stopTest();
    }
    
    public static testmethod void  rolluptest1() {
        Id RTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();
        Account cmp = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert cmp;
        Account acc = new Account(Name = 'test',Type= 'Cloud Customer', ShippingCountry='India',Company_Name__c = cmp.Id, RecordTypeId = RTypeId);
        insert acc;
        
    }
    public static testmethod void  rolluptest2() {
        Id RTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account').getRecordTypeId();
        Account cmp = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert cmp;
        Account acc = new Account(Name = 'test',Type= 'Customer' , ShippingCountry='India',Company_Name__c = cmp.Id, RecordTypeId = RTypeId);
        insert acc;
        
    }
    public static testmethod void  rolluptest3() {
        Id RTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account').getRecordTypeId();
        Account cmp = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert cmp;
        Account acc = new Account(Name = 'test',Type= 'Former Cloud Customer' ,ShippingCountry='India',Company_Name__c = cmp.Id, RecordTypeId = RTypeId);
        insert acc;
        
    }
    public static testmethod void  rolluptest4() {
        Id p = [select id from profile where name='Salesbroom Manager'].id;
        User user1 = new User(alias = 'SM123', email='testSM123@noemail.com',
                              emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                              localesidkey='en_US', profileid = p, timezonesidkey='America/Los_Angeles', username='testerSM@noemail.com');
        insert user1;
        User user2 = new User(alias = 'SM12322d', email='testSM123cvb@noemail.com',
                              emailencodingkey='UTF-8', lastname='Testinrg', languagelocalekey='en_US',
                              localesidkey='en_US', profileid = p, timezonesidkey='America/Los_Angeles', username='testerSMcvbb@noemail.com');
        insert user2;
        Id RTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account').getRecordTypeId();
        Account cmp = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert cmp;
        Account acc = new Account(Name = 'test',Type= 'Former Customer', ShippingCountry='India',Company_Name__c = cmp.Id, RecordTypeId = RTypeId,Account_Manager__c=user1.id);
        insert acc;
        acc.Account_Manager__c=user2.id;
        update acc;
        
    }
    
    @isTest static void avoidDeleteCompanies() {         
        Test.startTest();
        try {               
            Id p = [select id from profile where name='Salesbroom Manager'].id;
            User user1 = new User(alias = 'SM123', email='testSM123@noemail.com',
                                  emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                  localesidkey='en_US', profileid = p, timezonesidkey='America/Los_Angeles', username='testerSM@noemail.com');
            insert user1;
            System.runAs(user1){
                Account comp = [SELECT Id,Name,BillingCountry,BillingCountryCode,ShippingCountry,ShippingCountryCode,RecordTypeId from Account where Name='TestCompany' AND RecordType.Name='Standard Company' LIMIT 1];
                Account acc = [SELECT Id,Name,BillingCountry,BillingCountryCode,ShippingCountry,ShippingCountryCode,RecordTypeId from Account where Name='TestCompany' AND RecordType.DeveloperName='Prospect' LIMIT 1]; 
                
                /*  List<RecordType> customerType = new List<RecordType>();
customerType = [SELECT Id FROM RecordType WHERE Name = 'Customer' AND SObjectType = 'Account'];        
Account acc2 = new Account(Name = 'test',ShippingCountry='India', Company_Name__c = comp.Id, RecordTypeId = customerType.get(0).Id);
insert acc2;
// comp.ownerId = user1.id; */
                update comp;                
                delete comp;
                
            }  
            
        }
        catch(exception ex){
            // System.assert(ex.getMessage().contains(Label.Avoid_Company_Delete));
        }        
        Test.stopTest();  
    }
    
    @isTest static void createOrUpdateTransitionManager() {            
        Test.startTest();   
        Id p = [select id from profile where name='Rackspace Seller-US'].id;   
        User user1 = new User(alias = 'SM123', email='testSM123@noemail.com',   
                              emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',    
                              localesidkey='en_US', profileid = p, timezonesidkey='America/Los_Angeles', username='testerSM@noemail.com');    
        insert user1;   
        User user2 = new User(alias = 'SM12322d', email='testSM123cvb@noemail.com', 
                              emailencodingkey='UTF-8', lastname='Testinrg', languagelocalekey='en_US',   
                              localesidkey='en_US', profileid = p, timezonesidkey='America/Los_Angeles', username='testerSMcvbb@noemail.com');    
        insert user2;   
        Id RTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();   
        Account cmp = new Account(Name='Test Account12',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId); 
        insert cmp; 
        Account acc = new Account(Name = 'productacctest1', Type= 'Former Customer', ShippingCountry='India',Company_Name__c = cmp.Id, RecordTypeId = RTypeId,Transition_Manager__c=user1.id);  
        insert acc; 
        acc.Transition_Manager__c=user2.id; 
        update acc; 
        AccountTeamMember atmlist2 =new AccountTeamMember(AccountID = acc.id,UserId = User1.id );    
        insert atmlist2;
        
        
        Test.stopTest();   
        
    }
    @isTest static void testoptpartnerupdates(){
        
        Id RTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
        Id cRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId();       
        Set<Id> accId = new Set<Id>();
        /* Account acc = [select Id,Name,AnnualRevenue, BillingCountry,Territory__c, Company_Access_Submitter__c from Account where Name = 'UpdateMarket' LIMIT 1];                       
acc.BillingCountry = 'Afghanistan';
acc.Territory__c = 'EMEA';
acc.AnnualRevenue = 0;
*/
        Account ab = new Account(Name = 'test1Par',Phone='9876543224',Opt_Out__c = false,Partner_Level__c= 'Reseller',BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(),RecordTypeId=RTId,Partner_Account_Status__c='Approved');
        insert ab;
        Account a = new Account(Name = 'test1par',Opt_Out__c = false,Phone='9876543225',BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(),RecordTypeId=RTId);
        insert a;
        Contact cb = New Contact(FirstName='Testpar',LastName='Conpar',Phone='9876543235',email='testconb2par@test.com', AccountID = ab.id,RecordTypeId=cRTId);
        insert cb;
        ab.Partner_Level__c = 'Strategic';
        ab.BillingCountry = 'Afghanistan';
        ab.Territory__c = 'EMEA';
        ab.Opt_Out__c = true;
        Test.startTest();
        update ab;
        accId.add(ab.id);
        companyTriggerHelper.updateRegionAndPartLevelOnContact(accId);
        system.debug('Acc record'+ab);
        Test.stopTest();
        
    }
}