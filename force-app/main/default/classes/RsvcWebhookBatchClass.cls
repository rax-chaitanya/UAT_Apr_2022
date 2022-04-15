/*
Story : SFDC-6302
Description: To send failure records to webhook for every 5 mins
author: Sundarayya E
*/
global class RsvcWebhookBatchClass implements Database.Batchable<sObject>,Database.AllowsCallouts{
    
    global database.queryLocator start(Database.BatchableContext BC){
        return database.getQueryLocator([Select Id,Name,Integration_Type__c,ddi__c,quote_id__c,Type, Integration_Status__c,CVP_Verified__c,StageName from Opportunity where 
                                         Type = 'RSVC' and ((Integration_Type__c = 'RSVC' and Integration_Status__c ='Failure') or (Integration_Type__c != 'RSVC')) and CVP_Verified__c =true and StageName = 'Closed Won']);
    }
    global void execute(Database.BatchableContext BC, List<Opportunity> oppList) 
    {       
        if(oppList.size() > 0)
            RsvcWebhookHandler.postDataToWebhook(oppList);
           
        
        
    }
    global void finish(Database.BatchableContext BC) 
    {
        
        
    }
}