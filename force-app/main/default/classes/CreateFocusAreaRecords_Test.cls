@isTest
public class CreateFocusAreaRecords_Test {
    
    public static testMethod void testcreateFocusArea(){
        
        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
        insert fieldMappings;  
        
        TestDataFactory.getTriggerManagers();
        TestDataFactory.getOrgConstants();
        TestDataFactory.createFeatureFlags();
        
        Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert a;
        
        Id CustomerRTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();
        Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,ShippingCountry='India',RecordTypeId=CustomerRTypeId);
        insert ac;
        
        Opportunity opty = new Opportunity(Name='Test Opport',Type='Azure',AccountId=a.Id,Account__c=ac.id,DDI__c='12345655',Focus_Area__c = 'Amazon;Cloud Office;Google', StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15));
        insert opty;
    }
}