/*
Story : SFDC-6464
Description: To send failure records to webhook for every 5 mins
author: Sundarayya E
*/
global class RsvcWebhookBatchScheduler implements Schedulable{
    global void execute(SchedulableContext SC) {
        RsvcWebhookBatchClass bJob = new RsvcWebhookBatchClass();
        database.executeBatch(bJob);
        /* 
        System.schedule('SampleScheduler 1',  '0 00 * * * ?', new RsvcWebhookBatchScheduler ());
        System.schedule('SampleScheduler 2',  '0 05 * * * ?', new RsvcWebhookBatchScheduler ());
        System.schedule('SampleScheduler 3',  '0 10 * * * ?', new RsvcWebhookBatchScheduler ());
        System.schedule('SampleScheduler 4',  '0 15 * * * ?', new RsvcWebhookBatchScheduler ());
        System.schedule('SampleScheduler 5',  '0 20 * * * ?', new RsvcWebhookBatchScheduler ());
        System.schedule('SampleScheduler 6',  '0 25 * * * ?', new RsvcWebhookBatchScheduler ());
        System.schedule('SampleScheduler 7',  '0 30 * * * ?', new RsvcWebhookBatchScheduler ());
        System.schedule('SampleScheduler 8',  '0 35 * * * ?', new RsvcWebhookBatchScheduler ());
        System.schedule('SampleScheduler 9',  '0 40 * * * ?', new RsvcWebhookBatchScheduler ());
        System.schedule('SampleScheduler 10', '0 45 * * * ?', new RsvcWebhookBatchScheduler ());
        System.schedule('SampleScheduler 11', '0 50 * * * ?', new RsvcWebhookBatchScheduler ());
        System.schedule('SampleScheduler 12', '0 55 * * * ?', new RsvcWebhookBatchScheduler ());
        */
    }
}