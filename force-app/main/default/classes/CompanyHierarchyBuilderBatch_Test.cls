@isTest
public class CompanyHierarchyBuilderBatch_Test {

    @TestSetUp static void setTestData(){
        TestClassUtility.setTestSetupData();
    }
   @isTest static void testCompayHierarchyBuild(){
        List<Account> accountList = new List<Account>();         
        for(Integer i=1;i<=100;i++) {
           accountList.add(new Account(Name='Test Account12341'+i,BillingCountry='India',ShippingCountry='India'));           
        }        
        insert accountList;        
        Test.startTest();
        Id jobId =  Database.executeBatch(new CompanyHierarchyBuilderBatch(), 200);
        Test.stopTest();
    }
    
    @isTest static void testCompayHierarchyBuildSchedule(){
        List<Account> accountList = new List<Account>();
        for(Integer i=1;i<=100;i++)
           accountList.add(new Account(Name='Test Account1234'+i,BillingCountry='India',ShippingCountry='India',CleanStatus = 'Matched')); 
        
        insert accountList;        
       DateTime d = System.now();
        String cronexp= '0 ' +(Integer.valueOf(d.minute())+1)+' '+d.hour()+' '+d.day()+' '+d.month()+' '+' ? '+d.year();
        System.debug('Exp '+cronexp);
        Test.startTest();
        Id jobID =System.schedule('CompanyHierarchyBuilderSchedule1', cronexp, new CompanyHierarchyBuilderSchedule());
        Test.stopTest();
        
        CronTrigger ct = [SELECT TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobID];
       System.assert(ct != null ,false);
    }
}