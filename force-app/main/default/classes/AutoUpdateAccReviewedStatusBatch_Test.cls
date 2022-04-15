@isTest
public class AutoUpdateAccReviewedStatusBatch_Test {

    @testSetup static void testSetupData(){
        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
        insert fieldMappings;
    }
   
    @isTest static void testAutoUpdateBatch(){
        TestClassUtility.setTestSetupData(); 
        
        Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India', RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a;
        
        Account ac = new Account(Name='Test C Account',ShippingCountry='India',Company_Name__c=a.Id,Account_Review_Status__c='Escalated to Salesbroom',RecordTypeId = Label.Account_Prospect_RecordType_ID);
        insert ac;
        Account ac1 = new Account(Name='Test C Account1',ShippingCountry='India',Company_Name__c=a.Id,Account_Review_Status__c='Escalated to Salesbroom',RecordTypeId = Label.Account_Prospect_RecordType_ID);
        insert ac1;
       DateTime d = System.now();
        String cronexp= '0 ' +(Integer.valueOf(d.minute())+1)+' '+d.hour()+' '+d.day()+' '+d.month()+' '+' ? '+d.year();
        Test.startTest();
        Id jobID =System.schedule('AutoUpdateAccountReviewedStatusBatch', cronexp, new AutoUpdateAccountReviewedStatusBatch());
        Test.stopTest();
        
        CronTrigger ct = [SELECT TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobID];
       System.assert(ct != null ,false);
        
    }
    
    }