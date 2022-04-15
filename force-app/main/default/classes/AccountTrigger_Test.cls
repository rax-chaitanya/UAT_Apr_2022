/**
* File : AccountTrigger_Test.cls
* Description : Tests the AccountTrigger.trigger trigger. 
* Created Date : 01/FEB/2017
* @author : RDC (JY)
*/

@istest(seeAllData = true)
public class AccountTrigger_Test
{   /*
@testSetup static void setupTestData() {
insertTriggerSettings();
insertOrgConstants();
insertFieldMapings();
insertCountryTerritoryMapping();
insertContractingEntities();
}*/
    
    public static void insertContractingEntities() {
        List<Contracting_Entity__c> entities = new List<Contracting_Entity__c>();
        entities.add(new Contracting_Entity__c(Name = 'Rackspace US, Inc', Territory__c = 'US/CANADA', Country__c = 'United States'));
        entities.add(new Contracting_Entity__c(Name = 'Rackspace International GmbH', Territory__c = 'International', Country__c = 'International'));
        insert entities;
    }
    
    public static void insertTriggerSettings() {
        List<Trigger_Manager__c> triggerSettings = new List<Trigger_Manager__c>();
        triggerSettings.add(new Trigger_Manager__c(Name = 'CompanyTrigger', Is_Active__c = true));
        triggerSettings.add(new Trigger_Manager__c(Name = 'AccountTrigger', Is_Active__c = true));
        triggerSettings.add(new Trigger_Manager__c(Name = 'AcrTgr', Is_Active__c = true));
        triggerSettings.add(new Trigger_Manager__c(Name = 'ContactTgr', Is_Active__c = true));
        triggerSettings.add(new Trigger_Manager__c(Name = 'cLogTgr', Is_Active__c = true));
        triggerSettings.add(new Trigger_Manager__c(Name = 'OpportunityTgr', Is_Active__c = true));
        insert triggerSettings;
    }
    
    public static void insertCountryTerritoryMapping() {
        List<CountryTerritoryMapping__c> mappings = new List<CountryTerritoryMapping__c>();
        mappings.add(new CountryTerritoryMapping__c(Name = 'United States', Territory_Name__c = 'US/CANADA'));
        mappings.add(new CountryTerritoryMapping__c(Name = 'Canada', Territory_Name__c = 'US/CANADA'));
        insert mappings;
    }
    
    public static void insertFieldMapings() {
        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Account', CompName__c = 'Accounts__c', SourceField__c = 'Billing_Country__c', TargetField__c = 'Territory__c'));
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
    
    private static testmethod void testBeforeAfterInsertUpdateDeleteUndelete() {         
        User FMW_User = [SELECT Id FROM User WHERE Id = :Id.valueOf(Label.FMW_API_User) LIMIT 1];
        FMW_User.Region__c = 'AMER';
        
        System.runAs(FMW_User) {
            List<RecordType> customerType = new List<RecordType>();
            customerType = [SELECT Id FROM RecordType WHERE Name = 'Customer' AND SObjectType = 'Accounts__c'];
            if(!customerType.isEmpty()) {
                Account comp = new Account(Name = 'test', BillingCountry = 'United States', ShippingCountry = 'United States');
                insert comp;
                
                Contact con = new Contact(FirstName = 'First', LastName = 'Last', AccountId = comp.Id);
                insert con;
                
                
                Account comp1 = new Account(Name = 'test', BillingCountry = 'Canada', ShippingCountry = 'Canada');
                insert comp1;  
                Test.startTest();
                List<Accounts__c> accList = new List<Accounts__c>();
                accList.add(new Accounts__c(Name = 'testComp', Company_Name__c = comp.Id, Shipping_Country__c = 'United States', 
                                            RecordTypeId = customerType.get(0).Id, Menu_Pricing_Approved__c = TRUE,DDI__c='1234'));
                accList.add(new Accounts__c(Name = 'testComp1', Company_Name__c = comp1.Id, Shipping_Country__c = 'Canada',
                                            RecordTypeId = customerType.get(0).Id, Menu_Pricing_Approved__c = TRUE));
                insert accList;
                
                //insert new Task(Type = 'Email',Description = 'Test desc',OwnerId = UserInfo.getUserId(),WhatId = accList.get(0).id);
                //insert new Event(Whatid=accList.get(0).id,Subject='Testing',DurationInMinutes=40,ActivityDateTime = System.now());
                Opportunity opty = new Opportunity(Was_a_Partner_Involved__c='Yes',Type = 'Rackspace Cloud',DDI__c='1234',Name='Test Opport',AccountId=comp.Id,
                                                   Account_RDuplicate__c=accList.get(0).id,StageName='Stage 1 - Planning & Identification',CloseDate=System.today());
                insert opty;
                
                Opportunity opty1 = new Opportunity(Was_a_Partner_Involved__c='Yes',Type = 'Rackspace Cloud',Name='Test Opport1',AccountId=comp.Id,Account_RDuplicate__c=accList.get(0).id,StageName='Stage 1 - Planning & Identification',CloseDate=System.today());
                insert opty1;
                
                
                
                accList.get(0).Shipping_Country__c = 'Canada';
                accList.get(1).Shipping_Country__c = 'United States';
                accList.get(1).ContractingEntityApproved__c = 'Approved';
                accList.get(1).Menu_Pricing_Approved__c = FALSE;
                update accList;
                Test.stopTest();
                
                delete accList;
                undelete accList;
                delete [SELECT Id FROM Trigger_Manager__c WHERE Name = 'AccountTrigger'];
                update accList;
                
                delete opty;
                undelete opty;
            }
        }
    }
    
    private static testmethod void testBeforeAfterInsertUpdateDeleteUndelete1() {         
        User FMW_User = [SELECT Id FROM User WHERE Id = :Id.valueOf(Label.FMW_API_User) LIMIT 1];
        FMW_User.Region__c = 'AMER';
        
        System.runAs(FMW_User) {
            List<RecordType> customerType = new List<RecordType>();
            customerType = [SELECT Id FROM RecordType WHERE Name = 'Customer' AND SObjectType = 'Accounts__c'];
            if(!customerType.isEmpty()) {
                Account comp = new Account(Name = 'test', BillingCountry = 'United States', ShippingCountry = 'United States');
                insert comp;
                
                Account comp1 = new Account(Name = 'test', BillingCountry = 'Canada', ShippingCountry = 'Canada');
                insert comp1;           
                
                Test.startTest();
                List<Accounts__c> accList = new List<Accounts__c>();
                accList.add(new Accounts__c(Name = 'testComp', Company_Name__c = comp.Id, Shipping_Country__c = 'United States', 
                                            RecordTypeId = customerType.get(0).Id, Menu_Pricing_Approved__c = TRUE,DDI__c='1234'));
                accList.add(new Accounts__c(Name = 'testComp1', Company_Name__c = comp1.Id, Shipping_Country__c = 'Canada',
                                            RecordTypeId = customerType.get(0).Id, Menu_Pricing_Approved__c = TRUE,DDI__c='1234'));
                insert accList;
                
                //insert new Task(Type = 'Email',Description = 'Test desc',OwnerId = UserInfo.getUserId(),WhatId = accList.get(0).id);
                //insert new Event(Whatid=accList.get(0).id,Subject='Testing',DurationInMinutes=40,ActivityDateTime = System.now());
                Opportunity opty = new Opportunity(Was_a_Partner_Involved__c='Yes',Type = 'Rackspace Cloud',DDI__c='1234',Name='Test Opport',AccountId=comp.Id,
                                                   Account_RDuplicate__c=accList.get(0).id,StageName='Stage 1 - Planning & Identification',CloseDate=System.today());
                insert opty;
                
                Opportunity opty1 = new Opportunity(Was_a_Partner_Involved__c='Yes',Type = 'Rackspace Cloud',DDI__c='1234',Name='Test Opport1',AccountId=comp.Id,Account_RDuplicate__c=accList.get(0).id,StageName='Stage 1 - Planning & Identification',CloseDate=System.today());
                insert opty1;
                
                Contact con = new Contact(FirstName = 'First', LastName = 'Last', AccountId = comp.Id);
                insert con;
                
                accList.get(0).Shipping_Country__c = 'Canada';
                accList.get(1).Shipping_Country__c = 'United States';
                accList.get(1).ContractingEntityApproved__c = 'Approved';
                accList.get(1).Menu_Pricing_Approved__c = FALSE;
                update accList;
                Test.stopTest();
                
                delete accList;
                undelete accList;
                delete [SELECT Id FROM Trigger_Manager__c WHERE Name = 'AccountTrigger'];
                update accList;
                
                delete opty;
                undelete opty;
            }
        }
    }
    Public static testmethod void testcreateorupdateaccountteammember(){
        User FMW_User = [SELECT Id FROM User WHERE Id = :Id.valueOf(Label.FMW_API_User) LIMIT 1];
        User u = [SELECT Id FROM User WHERE alias = 'sysadmin' AND UserType = 'Standard' AND isActive = TRUE LIMIT 1];
        Account comp = new Account(Name = 'test', BillingCountry = 'United States', ShippingCountry = 'United States');
        insert comp;
        Accounts__c acc=new Accounts__c();
        acc.Name='Test Act';
        acc.company_name__c=comp.id;
        acc.account_manager__c=FMW_User.id;
        insert acc;
        acc.account_manager__c=u.id;
        update acc;
        
    }
}