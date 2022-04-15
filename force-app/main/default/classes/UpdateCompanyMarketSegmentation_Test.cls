/**
 * File : CompanyTrigger_Test.cls
 * Description : Tests the CompanyTrigger.trigger trigger. 
 * Created Date : 31/JAN/2017
 * @author : RDC (JY)
 */

@istest
public class UpdateCompanyMarketSegmentation_Test
{   
    @testSetup static void setupTestData() {
       test.startTest(); 
        insertTriggerSettings();
        insertOrgConstants();
        insertFieldMapings();
        insertCountryTerritoryMapping();
        
        Account acc = new Account(Name = 'UpdateMarket',AnnualRevenue = 200000000.00, BillingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId());
    insert acc;
       test.stopTest(); 
  }
    
    public static void insertTriggerSettings() {
        List<Trigger_Manager__c> triggerSettings = new List<Trigger_Manager__c>();
        triggerSettings.add(new Trigger_Manager__c(Name = 'CompanyTrigger', Is_Active__c = true));
        triggerSettings.add(new Trigger_Manager__c(Name = 'cLogTgr', Is_Active__c = true));
        insert triggerSettings;
        
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
    
    private static testmethod void testBeforeDelete() {         
        Account comp = new Account(Name = 'test', BillingCountry = 'Canada', ShippingCountry = 'Canada');
        insert comp;
        
        List<RecordType> customerType = new List<RecordType>();
        customerType = [SELECT Id FROM RecordType WHERE Name = 'Customer Account' AND SObjectType = 'Account'];
        if(!customerType.isEmpty()) {
            Account acc = new Account(Name = 'test',ShippingCountry='India', Company_Name__c = comp.Id, RecordTypeId = customerType.get(0).Id);
            insert acc;
        
            Test.startTest();
            try {
                delete comp;
            }
            catch(exception ex){
                System.assert(ex.getMessage().contains(Label.Avoid_Company_Delete));
            }        
            Test.stopTest();
        }
    }
    
    private static testmethod void testAfterDelete() {         
        Account comp = new Account(Name = 'test', BillingCountry = 'Canada', ShippingCountry = 'Canada'/*, DunsNumber='060704780'*/);
        insert comp;
                  
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
    
    private static testmethod void testMerge() {        
        Account comp1 = new Account(Name = 'test1', BillingCountry = 'Canada', ShippingCountry = 'Canada');
        insert comp1;
        
        Account comp2 = new Account(Name = 'test2', BillingCountry = 'Canada', ShippingCountry = 'Canada', Old_Record_Id__c = comp1.Id);
        insert comp2;
                  
        Test.startTest();
        try{
            Merge comp1 comp2;
             //CompanyTriggerHelper.AddCompanyTeamMember();
        }catch(Exception e) {//WE HAVE LOGIC IN cLogHandler TO UPDATE ALL CHILD RECORDS AFTER MERGE. SO, THE RECORDS IN TRANSACTION DUE TO MERGE(FROM APEX) CANNOT BE UPDATED IN THE SAME TRANSACTION
          //do nothing
        }
        Test.stopTest();
    }

    private static testmethod void testBeforeUpdate() {         
        Account comp = new Account(Name = 'test', BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId());
        insert comp;
        
        List<RecordType> customerType = new List<RecordType>();
        customerType = [SELECT Id FROM RecordType WHERE Name = 'Customer Account' AND SObjectType = 'Account'];
        if(!customerType.isEmpty()) {
            Account acc = new Account(Name = 'test',ShippingCountry='India', Company_Name__c = comp.Id, RecordTypeId = customerType.get(0).Id);
            insert acc;
        
            Test.startTest();
            comp.Company_Access_Submitter__c = OrgConstants__c.getInstance('System Administrator ID').Prod_Value__c;
            update comp;                          
            Test.stopTest();
            
        }
    } 
    
    //test class for UpdateCompanyMarketSegmentation class
   private static testmethod void updateCmpMarketSegTest() {
        test.startTest();
      Account acc = [select Id,Name,AnnualRevenue, BillingCountry,Territory__c, Company_Access_Submitter__c from Account where Name = 'UpdateMarket' limit 1];      
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
      Account acc = [select Id,Name,AnnualRevenue, BillingCountry,Territory__c, Company_Access_Submitter__c from Account where Name = 'UpdateMarket' limit 1];      
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
        Account acc = [select Id,Name,AnnualRevenue, BillingCountry,Territory__c, Company_Access_Submitter__c from Account where Name = 'UpdateMarket' limit 1];                 
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
       // CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
        acc.AnnualRevenue = 2000000000.00;
        update acc;
       test.stopTest();
  }
    //test class for UpdateCompanyMarketSegmentation class
    private static testmethod void updateCmpMarketSegTest4() {
       test.startTest();
        //Account comp = new Account(Name = 'test',AnnualRevenue = 200000000.00, BillingCountry = 'Afghanistan', ShippingCountry = 'Afghanistan', Company_Access_Submitter__c = UserInfo.getUserId());
        //insert comp;
        Account acc = [select Id,Name,AnnualRevenue, BillingCountry,Territory__c, Company_Access_Submitter__c from Account where Name = 'UpdateMarket' limit 1];                 
        //system.debug('company territory'+comp.Territory__c);
        //CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
        acc.BillingCountry = 'Anguilla';
         acc.Territory__c = 'LATAM';
         acc.AnnualRevenue = 100;
        update acc;
        //CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
        acc.AnnualRevenue = 1000;
        update acc;
       // CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
        acc.AnnualRevenue = 50000000.00;
        update acc;        
        //system.debug('company territory'+ comp.Territory__c);
       // CompanyHandler.stopBUAUCMPRecursion = 'Before Update';
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
        Account acc = [select Id,Name,AnnualRevenue, BillingCountry,Territory__c, Company_Access_Submitter__c from Account where Name = 'UpdateMarket' limit 1];                 
       
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
        Account acc = [select Id,Name,AnnualRevenue, BillingCountry,Territory__c, Company_Access_Submitter__c from Account where Name = 'UpdateMarket' limit 1];                 
         acc.recordtypeId = devRecordTypeId;
        update acc;
        
       test.stopTest();
  }
    //test class for UpdateCompanyMarketSegmentation class
    private static testmethod void updateCmpMarketSegTest7() {
       test.startTest();
       Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Government Company').getRecordTypeId();
        Account acc = [select Id,Name,AnnualRevenue, BillingCountry,Territory__c, Company_Access_Submitter__c from Account where Name = 'UpdateMarket' limit 1];                 
         acc.recordtypeId = devRecordTypeId;
        update acc;
        acc.BillingCountry = 'Afghanistan';
         acc.Territory__c = 'EMEA';
        update acc;
        acc.BillingCountry = 'Australia';
         acc.Territory__c = 'ANZ';
        update acc;
        acc.BillingCountry = 'Anguilla';
         acc.Territory__c = 'LATAM';
        update acc;
        acc.BillingCountry = 'Austria';
         acc.Territory__c = 'DACH';
        update acc;
       test.stopTest();
  }
   // public static testmethod void coverageMethod(){
        //CompanyTriggerHelper.dummyCodeCoverage();
   // }
    
    public static testmethod void companyDataGovernance(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'DataG', Email='DataGover@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, Region__c = 'AMER',
            TimeZoneSidKey='America/Los_Angeles', UserName='DataGover@testorg.com');
        Insert u;
        
        system.runAs(u){
            Account acc = new Account(Name = 'companydatagovernance',BillingCountry = 'Canada');
    insert acc;
        }

    }
    
}