@isTest
public class RevenueRetentionPlayBatchSchedule_Test {
    
    public static testmethod void test1(){
        Test.startTest();
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        String jobId = System.schedule('RevenueRetentionPlayBatchSchedule_Test', CRON_EXP, new RevenueRetentionPlayBatchSchedule());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId]; 
        Test.stopTest();        
    }
}