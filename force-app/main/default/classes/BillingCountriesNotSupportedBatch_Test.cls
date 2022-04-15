@isTest
public class BillingCountriesNotSupportedBatch_Test {

    @TestSetUp static void setTestData(){
        TestClassUtility.setTestSetupData();
    }
    @isTest static void testBillingCountryBatch(){
       // insert new CBDBillingCountry__c(Name='Australia');
          insert new Account(Name='Test Account12341',BillingCountry='India',ShippingCountry='India',CleanStatus = 'Matched');
          insert new Account(Name='Test Account12342',BillingCountry='China',ShippingCountry='China',CleanStatus = 'Matched');
          insert new Account(Name='Test Account12343',BillingCountry='India',ShippingCountry='India',CleanStatus = 'Matched');
          insert new Account(Name='Test Account12344',BillingCountry='India',ShippingCountry='India',CleanStatus = 'Matched');
       
         DateTime d = System.now();
        String cronexp= '0 ' +(Integer.valueOf(d.minute())+1)+' '+d.hour()+' '+d.day()+' '+d.month()+' '+' ? '+d.year();
        Test.startTest();
        Id jobID =System.schedule('BillingCountriesNotSupportedBatch1', cronexp, new BillingCountriesNotSupportedBatch());
        Test.stopTest();
        
        CronTrigger ct = [SELECT TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobID];
       System.assert(ct != null ,false);
    }
}