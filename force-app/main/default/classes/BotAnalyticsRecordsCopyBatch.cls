/**
* File : BotAnalyticsRecordsCopyBatch.cls
* Description : Used to update Bot_Analytics custom object records from BotAnalytics object.
* Ticket : SFDC-2463
* Created Date : Sept 2018
* @author : RDC (Rahul,Biswa)
*/
global class BotAnalyticsRecordsCopyBatch implements Database.Batchable <BotAnalytics> {
    global List<BotAnalytics> start(Database.BatchableContext BC) {
        String Query ='Select ';
        for(BotAnalytics__c BotsFields : BotAnalytics__c.getAll().values()){
            Query+= BotsFields.Name+',';    
        }
        Query=Query.removeEnd(',');
        Query+=' From BotAnalytics';
        List<BotAnalytics> listOfBotAnalyticsRecords = new List<BotAnalytics>();
        if(!test.isRunningTest()){
            listOfBotAnalyticsRecords = Database.query(Query);              
        }
        return listOfBotAnalyticsRecords; 
        
    }       
    global void execute(Database.BatchableContext BC, List<BotAnalytics> scope) {
        Map<string,Bot_Analytics__c> childBotRecords =  new map<string,Bot_Analytics__c>();
        for(Bot_Analytics__c botQuery:[select LiveChatTranscriptId__c,Id,Name,AbandonedDialogsCount__c,BotDuration__c,
                                       BotMessageCount__c,BotVersionNumber__c,ButtonClicksCount__c,ChatSessionId__c,
                                       DroppedDialogId__c,DroppedDialogName__c,DroppedElementId__c,EscalationType__c,
                                       FirstBotInteractionTime__c,IsRequestedEscalation__c,IsSuccessfulEscalation__c,
                                       IsUnsuccessfulEscalation__c,LastBotInteractionTime__c,MenuClicksCount__c,
                                       NlpMatchCount__c,NlpMessageCount__c,OptionsMenuSelectionsCount__c,SessionEndType__c,
                                       SessionStartTime__c,StartedDialogsCount__c,ToBotMessageCount__c,WasSessionDropped__c,
                                       AccessTimestamp__c from Bot_Analytics__c]){
                                           childBotRecords.put(botQuery.LiveChatTranscriptId__c,botQuery);                                                    
                                       }
        list<Bot_Analytics__c> botList = new list<Bot_Analytics__c>();
        Bot_Analytics__c bot;
        for(BotAnalytics data:scope){
            bot = new Bot_Analytics__c();
            if(!(childBotRecords.containsKey(data.LiveChatTranscriptId))){
                for(BotAnalytics__c BotsFields : BotAnalytics__c.getAll().values()){
                    bot.put(BotsFields.Target_Field__c,data.get(BotsFields.name));
                }
                botList.add(bot);
            }
        }
        insert botList;
    }
    global void finish(Database.BatchableContext BC) {
        BotAnalyticsRecordsCopyBatch schbatch = new BotAnalyticsRecordsCopyBatch();
        if(!test.isRunningTest()){
        System.scheduleBatch(schbatch, 'Copy BotAnalytics Records', 1,200);  
        }
    }
}