public without sharing class LiveAgentTranscriptController {
    @AuraEnabled
    public static LiveChatTranscript[] getMyChatsWithoutSurveys() {
        LiveChatTranscript[] transcripts = new list<LiveChatTranscript>();
        transcripts = [Select Id, Name, TimeSinceChat__c from LiveChatTranscript where  OwnerId = :UserInfo.getUserId() and Status in ('Completed','InProgress') and RepChatSurveys__c = 0 and RackUId__c != '' order by endtime desc];
        return transcripts;
    }
    


}