@isTest
public class RepPostChatSurveyControllerTest {
   static testMethod void testDefaultMockValues(){
            LiveChatVisitor liveChatVisitor = new LiveChatVisitor();
            insert liveChatVisitor;
            LiveChatTranscript liveChatTran = new LiveChatTranscript();
            liveChatTran.LiveChatVisitorId = liveChatVisitor.id;
            insert liveChatTran;
            Rep_Chat_Survey__c r = new Rep_Chat_Survey__c();
            r.Live_Chat_Transcript__c = liveChatTran.id;
            Integer num  =  RepPostChatSurveyController.getSurveyCount(liveChatTran.id);
            String s = RepPostChatSurveyController.saveSurvey(r);
            }
}