/**
* File : BotAnalyticsRecordsCopyBatch.cls
* Description : Used to update Bot_Analytics custom object records from BotAnalytics object.
* Ticket : SFDC-2463
* Created Date : Sept 2018
* @author : RDC (Rahul,Biswa)
*/
@isTest
public class BotAnalyticsRecordsCopyBatchTest 
{
    static testMethod void BotsMethod() 
    {   
        
        Test.startTest();
        
        Bot_Analytics__c botcustom = new Bot_Analytics__c();
        botcustom.AbandonedDialogsCount__c = 1;
        insert botcustom;
        BotAnalytics__c botcustset = new BotAnalytics__c();
        botcustset.Name = 'Name Bot Custom setting';
        botcustset.Target_Field__c = 'Target Bot Custom setting';
        insert botcustset;
        List<BotAnalytics> scp = new List<BotAnalytics>();
        BotAnalyticsRecordsCopyBatch obj = new BotAnalyticsRecordsCopyBatch();
        Database.BatchableContext bc;
        
        obj.start(bc);
        obj.execute(bc,scp);
        obj.finish(bc);
        
        Test.stopTest();
    }
}