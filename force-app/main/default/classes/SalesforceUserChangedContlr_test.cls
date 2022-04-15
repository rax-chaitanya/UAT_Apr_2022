@isTest
public class SalesforceUserChangedContlr_test {
    static final Id psa_resource_recordType_Id= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('PSA Resource').getRecordTypeId();
  @isTest
    static void updateContactSalesforceUser(){
            TestDataFactory.getOrgConstants();
            TestDataFactory.triggerManagerFlagValue  = true;
            TestDataFactory.getTriggerManagers();
            List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
            fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
            fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
            fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
            insert fieldMappings;
        
            Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
            insert a;
           
            pse__Region__c region = PSA_TestDataFactory.createRegion();
            
            pse__Grp__c grp = new  pse__Grp__c(Name = 'Global',pse__Hierarchy_Depth__c = 0);
            Insert grp;
            
            pse__Practice__c prc = new  pse__Practice__c(Name = 'Global Practice',pse__Hierarchy_Depth__c = 0);
            Insert prc;
            List<pse__Rate_Card__c> rates = new List<pse__Rate_Card__c>();             
            rates.add(new pse__Rate_Card__c(pse__Role__c='Consultant',pse__Region__c=region.Id,pse__Suggested_Bill_Rate__c=500,pse__Average_Cost_Rate__c=200));
            rates.add(new pse__Rate_Card__c(pse__Role__c='Consultant',pse__Group__c=grp.Id,pse__Suggested_Bill_Rate__c=500,pse__Average_Cost_Rate__c=200));
            rates.add(new pse__Rate_Card__c(pse__Role__c='Consultant',pse__Practice__c=prc.id,pse__Suggested_Bill_Rate__c=500,pse__Average_Cost_Rate__c=200));
            
            insert rates ;
            contact cons = new Contact(pse__Resource_Role__c='Consultant',RecordTypeId=psa_resource_recordType_Id,LastName='PSAResource',pse__Region__c=region.id,pse__Practice__c=prc.id,pse__Group__c=grp.Id);
            
            insert cons;
			 
        Test.startTest();
        SalesforceUserChangedContlr.revertContact(cons.Id, null);
        Test.stopTest();        
        
        }
    
}