@isTest
public class NPSSurveyToTranscriptTest {
    @isTest
    public static void  myNpsTest(){
        LiveChatVisitor lcv=new LiveChatVisitor();
        insert lcv;
        LiveChatTranscript lct = new LiveChatTranscript();
        	lct.chatKey = 'z9999999-zz99-9zzz-99z9-9z999999zz991';
        	lct.LiveChatVisitorid = lcv.id;
        insert lct;
        NPS_Survey__c nps = new NPS_Survey__c();
        	nps.Live_Chat_Transcript__c=lct.id;
        	nps.chatKey__c = 'z9999999-zz99-9zzz-99z9-9z999999zz991';
        insert nps;  
    }

}