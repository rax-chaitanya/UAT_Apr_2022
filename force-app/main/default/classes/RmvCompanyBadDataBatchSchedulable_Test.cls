/************************************************************************************************************************************
 * Class Name : RmvCompanyBadDataBatchSchedulable_Test
 * Author : Shantan Nagulapalli
 * Creation Date : Feb 2016
 * Purpose : Test class associated with the RmvCompanyBadDataBatchSchedulable class
 ************************************************************************************************************************************/

@isTest
private class RmvCompanyBadDataBatchSchedulable_Test {
	
    @TestSetUp static void setTestData(){
    TestClassUtility.setTestSetupData();    
    }
    
	@isTest 
	static void ScheduleableBatchTest() {
        
        insert new CBDStreetAddress__c(Name='US',Country__c='US');
        insert new CBDStreetAddress__c(Name='UK',Country__c='UK');
        insert new CBDCompanyName__c(Name='Set Duns Number - US',Type__c='Set Duns Number - US');
        insert new CBDCompanyName__c(Name='Set Duns Number - UK',Type__c='Set Duns Number - UK');
        insert new CBDCompanyName__c(Name='Remove From Company Name',Type__c='Remove From Company Name');
        insert new CBDCompanyName__c(Name='Personal Cloud Account',Type__c='Personal Cloud Account');
        
        insert new CBDWebsite__c(Name='clear out the Website',Type__c='clear out the Website');
        insert new CBDWebsite__c(Name='testsite',Type__c='SetWebsiteDomains');
         List<Account> accountList = new List<Account>();
        insert new Account(Name='Personal Cloud Account',BillingPostalCode = 'null',BillingState = 'Karnataka',BillingStreet='null',BillingCountry ='India',BillingCity = 'null',ShippingCountry='India',CleanStatus = 'Matched',website='www.testsite.com');
        insert new Account(Name='Set Duns Number - US',BillingPostalCode = 'null',BillingState = 'Karnataka',BillingStreet='US',BillingCountry ='India',BillingCity = 'null',ShippingCountry='India',CleanStatus = 'Matched',website='www.testsite.com',DunsNumber='829207120');
        insert new Account(Name='Set Duns Number - UK',BillingPostalCode = 'null',BillingState = 'Karnataka',BillingStreet='UK',BillingCountry ='India',BillingCity = 'null',ShippingCountry='India',CleanStatus = 'Matched',website='test',DunsNumber='239064194');
        for(Integer i=1;i<=100;i++)
           accountList.add(new Account(Name='Test Account1234'+i,BillingCountry='India',ShippingCountry='India',CleanStatus = 'Matched',website='www.testsite'+i+'.com')); 
        
		insert accountList;  
        
         DateTime d = System.now();
        String cronexp= '0 ' +(Integer.valueOf(d.minute())+1)+' '+d.hour()+' '+d.day()+' '+d.month()+' '+' ? '+d.year();
        System.debug('Exp '+cronexp);
        Test.startTest();
        Id jobID =System.schedule('DelRejectedLeads1', cronexp, new RemoveCompanyBadDataBatchSchedulable());
        Test.stopTest();
        
        CronTrigger ct = [SELECT TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobID];
       System.assert(ct != null ,false);
    	
    }
    
    @isTest 
	static void ScheduleableBatchTest1() {
        
        insert new CBDStreetAddress__c(Name='US',Country__c='US');
        insert new CBDStreetAddress__c(Name='UK',Country__c='UK');
        insert new CBDCompanyName__c(Name='Set Duns Number - US',Type__c='Set Duns Number - US');
        insert new CBDCompanyName__c(Name='Set Duns Number - UK',Type__c='Set Duns Number - UK');
        insert new CBDCompanyName__c(Name='Remove From Company Name',Type__c='Remove From Company Name');
        insert new CBDCompanyName__c(Name='Personal Cloud Account',Type__c='Personal Cloud Account');
        
        insert new CBDWebsite__c(Name='clear out the Website',Type__c='clear out the Website');
        insert new CBDWebsite__c(Name='testsite',Type__c='SetWebsiteDomains');
         List<Account> accountList = new List<Account>();
        insert new Account(Name='Personal Cloud Account',BillingPostalCode = 'null',BillingState = 'Karnataka',BillingStreet='null',BillingCountry ='India',BillingCity = 'null',ShippingCountry='India',CleanStatus = 'Matched',website='www.testsite.com');
        for(Integer i=1;i<=100;i++)
           accountList.add(new Account(Name='Test Account1234'+i,BillingCountry='India',ShippingCountry='India',BillingStreet='US',CleanStatus = 'Matched',website='www.testsite'+i+'.com')); 
        
		insert accountList;  
        
         DateTime d = System.now();
        String cronexp= '0 ' +(Integer.valueOf(d.minute())+1)+' '+d.hour()+' '+d.day()+' '+d.month()+' '+' ? '+d.year();
        System.debug('Exp '+cronexp);
        Test.startTest();
        Id jobID =System.schedule('DelRejectedLeads1', cronexp, new RemoveCompanyBadDataBatch());
        Test.stopTest();
        
        CronTrigger ct = [SELECT TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobID];
       System.assert(ct != null ,false);
    
        
    }
}