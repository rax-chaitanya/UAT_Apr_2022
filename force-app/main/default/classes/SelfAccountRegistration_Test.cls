/**
* File : selfAccountRegistration.cls
* Description : Sign up form partner portal.
* Ticket : SFDC-2210(Parent story - )
* Created Date : March 2018
* @author : RDC (Thirupathi,Biswa)
*/
@isTest 
private class SelfAccountRegistration_Test{
    
    @testSetup static void setup() {
        // Create common test accounts
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
        
        Organization o = [SELECT Id FROM Organization LIMIT 1];
        ProcessDefinition p = [SELECT Id FROM ProcessDefinition WHERE DeveloperName = 'Company_Access_Request' AND Type = 'Approval' AND
                               TableEnumOrId = 'Account' LIMIT 1];
        User u = [SELECT Id FROM User WHERE alias = 'sysadmin' AND UserType = 'Standard' AND isActive = TRUE LIMIT 1];
        
        List<OrgConstants__c> constants = new List<OrgConstants__c>();
        constants.add(new OrgConstants__c(Name = 'Affiliate Registration', Non_Prod_Value__c = o.Id, Prod_Value__c = o.Id));
        constants.add(new OrgConstants__c(Name = 'Redirect To Rackspace Partner Site', Non_Prod_Value__c = o.Id, Prod_Value__c = o.Id));
        
        insert constants;   
        
        ProdOrgIDSetting__c prodOrg = new ProdOrgIDSetting__c(Name = 'Rackspace',ProdOrgID__c='00D61000000J4OKEA0');
        insert prodOrg;
        
    }
    
    static testMethod void accountRegistrationTestPositive() {                    
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        selfAccountRegistration selfAccRegCtrl = new selfAccountRegistration(sc);
        
        List<String> strList = new List<String>();
        strList.add('Test');
        strList.add('Test2');
        selfAccRegCtrl.con.LastName='test';    
        selfAccRegCtrl.acc.Name = 'Teast acc';
        selfAccRegCtrl.acc.Program_Of_Interest__c = 'Referral'; 
        selfAccRegCtrl.createAccountContact();  
        
        selfAccRegCtrl.acc.Program_Of_Interest__c = 'Reseller';
        try{selfAccRegCtrl.createAccountContact();}catch(exception e){}
        
        selfAccRegCtrl.acc.Program_Of_Interest__c = 'Referral/Reseller';
        try{selfAccRegCtrl.createAccountContact();}catch(exception e){}
        
        selfAccRegCtrl.acc.Program_Of_Interest__c = 'Affiliate';        
        selfAccRegCtrl.cancel();
        
    }
}