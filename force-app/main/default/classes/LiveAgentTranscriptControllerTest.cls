@isTest
public class LiveAgentTranscriptControllerTest{
    @isTest
     static void testMethod1(){
            LiveChatVisitor liveChatVisitor = new LiveChatVisitor();
            insert liveChatVisitor;
            LiveChatTranscript liveChatTran = new LiveChatTranscript();
            liveChatTran.LiveChatVisitorId = liveChatVisitor.id;
            insert liveChatTran;
            LiveChatTranscript[] transcripts =     LiveAgentTranscriptController.getMyChatsWithoutSurveys();
}
}