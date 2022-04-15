@isTest
public class LiveAgentPostChatTest {
    public static testMethod void  TestLiveAgentPostChat()
    {
        LiveAgentPostChat chat = new LiveAgentPostChat();
        PageReference pageRef = Page.PostChatSurveyPage;
         Test.setCurrentPage(pageRef); 
        chat.Feedback='1';
        NPS_Survey__c nps = new NPS_Survey__c();
        nps.Chat_Experience__c = decimal.valueOf(chat.Feedback);
        nps.ChatKey__c ='Test';
        nps.PostChatComment__c = 'Test abc';      
        insert nps;
        chat.chatKey = nps.ChatKey__c;
        chat.getItems();
       // chat.save();
        chat.chatFeedback='';
         chat.save();
        //Bulkify test data
        List<NPS_Survey__c> listsurvey=new List<NPS_Survey__c>();
        for(integer i=0;i<=99;i++){
        NPS_Survey__c np = new NPS_Survey__c();
        np.ChatKey__c = 'test'+i;
            listsurvey.add(np);}
        insert listsurvey;
        system.assert(listsurvey.size()>0);
        chat.Feedback=null;
        chat.chatFeedback='';
          chat.save();
        }
         public static testMethod void  testToIfElse()
         {
            LiveAgentPostChat chat = new LiveAgentPostChat();
            PageReference pageRef = Page.PostChatSurveyPage;
            Test.setCurrentPage(pageRef); 
                chat.Feedback=null;
            //     chat.chatKey = 'Test';
                chat.save();   
         }
   
}