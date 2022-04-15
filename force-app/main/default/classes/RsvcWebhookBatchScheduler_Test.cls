/*
Story : SFDC-6464
Description: Test class for RsvcWebhookBatchScheduler
author: Sundarayya E
*/
@isTest
private class RsvcWebhookBatchScheduler_Test {

    static testMethod void myTestMethod() {        
         test.starttest();
         RsvcWebhookBatchScheduler scheduler = new RsvcWebhookBatchScheduler();   
         String chron = '0 0 23 * * ?';        
         system.schedule('Test Sched', chron, scheduler);
         test.stopTest();
    }
}