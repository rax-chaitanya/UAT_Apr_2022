@isTest(seeAllData = false)
public class CompanyFortuneRankScheduleTest {

     @TestSetUp static void setTestData(){
        TestClassUtility.setTestSetupData();
    }
    @isTest static void TestCompanyFortuneRankSchedule(){
        Test.startTest();
      // insert new Account(Name='Set Duns Number - UK',BillingState = 'Karnataka',BillingCountry ='India',ShippingCountry='India',DunsNumber='2390641');
       DateTime d = System.now();
        String cronexp= '0 ' +(Integer.valueOf(d.minute())+1)+' '+d.hour()+' '+d.day()+' '+d.month()+' '+' ? '+d.year();
        System.debug('Exp '+cronexp);
        
        Id jobID =System.schedule('CompanyFortuneRankSchedule', cronexp, new CompanyFortuneRankSchedule());
        Test.stopTest();
         CronTrigger ct = [SELECT TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobID];
       System.assert(ct != null ,false);
    }
    
    @isTest static void TestCompanyFortuneRankSchedule1(){
      //  insert new Account(Name='Set Duns Number - UK',BillingPostalCode = 'null',BillingState = 'Karnataka',BillingStreet='UK',BillingCountry ='India',BillingCity = 'null',ShippingCountry='India',CleanStatus = 'Matched',website='test',DunsNumber='239064194');
       DateTime d = System.now();
        String cronexp= '0 ' +(Integer.valueOf(d.minute())+1)+' '+d.hour()+' '+d.day()+' '+d.month()+' '+' ? '+d.year();
        System.debug('Exp '+cronexp);
        Test.startTest();
        Id jobID =System.schedule('CompanyFortuneRankSchedule', cronexp, new CompanyFortuneRankSchedule());
        Test.stopTest();
         CronTrigger ct = [SELECT TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobID];
       System.assert(ct != null ,false);
    }
}