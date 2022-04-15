@isTest
public class LiveConfigEditControllerTest {
    @testSetup
    public static  void testSetup(){
        TestDataSetUp.insertTestRecords();
    }
  
  
    public static testMethod void myEditTest()
    {
        
    PageReference myPage=Page.LiveAgentConfigEditPage;
        Test.setCurrentPage(myPage);
        LiveAgentConfigEditController myEdit=new LiveAgentConfigEditController();               
        LiveChatUserConfig lc1=[select Id,DeveloperName from LiveChatUserConfig LIMIT 1];
        //myEdit.config='0C60j0000004CAuCAM';
        myEdit.config=lc1.Id;
        string myvskill=myEdit.config;
        system.debug('mySkill'+myvskill);
                myEdit.UpdateList();

        myEdit.liveAgentConfigurationName='testAgent';
        myEdit.developerName='testAgents';
        //myEdit.config = 'testAgents';
        myEdit.sneakPeekEnabled=True;
        myEdit.requestSoundEnabled=True;
        myEdit.disconnectSoundEnabled=True;
        myEdit.notificationsEnabled=True;
        myEdit.customAgentName='testRahul';
        myEdit.criticalWaitAlertTime=35;
        myEdit.visitorBlockingEnabled=True;
        myEdit.agentFileTransferEnabled=True;
        myEdit.assistanceFlagEnabled=True;
        myEdit.agentSneakPeekEnabled=True;
        myEdit.autoAwayOnDecline=True;
        myEdit.autoAwayOnPushTimeOut=True;
        myEdit.autoGreeting='Hello how are you';
        myEdit.chatConferencingEnabled=True;
        myEdit.chatMonitoringEnabled=True;
        myEdit.chatTransferToAgentsEnabled=True;
        myEdit.chatTransferToLiveChatButtonsEnabled=True;
        myEdit.chatTransferToSkillsEnabled=True;
        myEdit.whisperMessagesEnabled=True;
        myEdit.defaultAgentStatusFilters='ONLINE';
        myEdit.getDefaultAgentStatusFilter();

        LiveChatButton chat= [select id from LiveChatButton limit 1];
        
        myEdit.getAvailableChats();
        myEdit.selectedChatIds.add(chat.Id);
        myEdit.addChats();
        myEdit.removeChatIds.add(chat.Id);
        myEdit.removeChat();
        myEdit.getSelectedChats();
        myEdit.chatMonitoringEnabled=False;
        myEdit.whisperMessagesEnabled=False;
        myEdit.agentSneakPeekEnabled=False;
        myEdit.monitor=True;
        myEdit.chatMonitoringEnabled=False;
        myEdit.whisperMessagesEnabled=True;
        myEdit.agentSneakPeekEnabled=True;
        myEdit.monitor=False;
        myEdit.chatMonitoring();
         myEdit.chatMonitoringEnabled=True;
        myEdit.whisperMessagesEnabled=True;
        myEdit.agentSneakPeekEnabled=True;
        myEdit.monitor=False;
        myEdit.chatMonitoringEnabled=True;
        myEdit.whisperMessagesEnabled=False;
        myEdit.agentSneakPeekEnabled=False;
        myEdit.monitor=True;
         myEdit.chatMonitoring();         
         Test.startTest();

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_xml());
        myEdit.save();
        Test.stopTest();
    }
        
        public static testMethod void testSoapSave()
        {
            PageReference myPage1=Page.LiveAgentConfigEditPage;
            Test.setCurrentPage(myPage1);
            LiveAgentConfigEditController myEdit1=new LiveAgentConfigEditController();
            Test.startTest();

            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_xml());
            //Skill superSkill=[select Id,DeveloperName from SKill LIMIT 1];
            LiveChatUserConfig lc1=[select Id,DeveloperName from LiveChatUserConfig LIMIT 1];
            myEdit1.Save();
            Test.stopTest();
        }

        public static testMethod void testSoapSaveMethod(){
              
            PageReference myPage1=Page.LiveAgentConfigEditPage;
            Test.setCurrentPage(myPage1);
            LiveAgentConfigEditController myEdit1=new LiveAgentConfigEditController();
                
                
            Test.startTest();

            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_xml());

            myEdit1.Save();
            Test.stopTest();           
        }
        public static testMethod void cancelTest(){
            LiveAgentConfigEditController myEdit=new LiveAgentConfigEditController();
            myEdit.cancel();
            try{
                myEdit.save();
            }catch(Exception e){
            }
        }  
    public static testMethod void mySoapTest()
    {
        PageReference myPage=Page.LiveAgentConfigEditPage;
        Test.setCurrentPage(myPage);
        LiveAgentConfigEditController myEdit=new LiveAgentConfigEditController();
        LiveAgentConfigEditController myEdit2=new LiveAgentConfigEditController();
        LiveChatUserConfig lc1=[select Id,DeveloperName from LiveChatUserConfig LIMIT 1];
        
        //SkillController mySkill1 = new SkillController();    
       // Skill skills=[select id,developerName from Skill LIMIT 1];
        //update agentConfig; 
        
        myEdit.config=lc1.Id;
        string myvskill=myEdit.config;
        system.debug('mySkill'+myvskill);
       
        myEdit.liveAgentConfigurationName='testAgent';
        myEdit.developerName='testAgents';
        myEdit.sneakPeekEnabled=True;
        myEdit.requestSoundEnabled=True;
        myEdit.disconnectSoundEnabled=True;
        myEdit.notificationsEnabled=True;
        myEdit.customAgentName='testRahul';
        myEdit.criticalWaitAlertTime=35;
        myEdit.visitorBlockingEnabled=True;
        myEdit.agentFileTransferEnabled=True;
        myEdit.assistanceFlagEnabled=True;
        myEdit.agentSneakPeekEnabled=True;
        myEdit.autoAwayOnDecline=True;
        myEdit.autoAwayOnPushTimeOut=True;
        myEdit.autoGreeting='Hello how are you';
        myEdit.chatConferencingEnabled=True;
        myEdit.chatMonitoringEnabled=True;
        myEdit.chatTransferToAgentsEnabled=True;
        myEdit.chatTransferToLiveChatButtonsEnabled=True;
        myEdit.chatTransferToSkillsEnabled=True;
        myEdit.whisperMessagesEnabled=True;
        myEdit.defaultAgentStatusFilters='ONLINE';
        myEdit.getDefaultAgentStatusFilter();
         
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_xml());
        myEdit.save();
        myEdit.save();

       // Skill skill2=[select id,developerName,MasterLabel,Description from Skill LIMIT 1];
       

        LiveChatUserConfig lc12=[select Id,DeveloperName from LiveChatUserConfig LIMIT 1];
     // Skill superSkill=[select Id,DeveloperName from SKill LIMIT 1];
        myEdit.save();
        myEdit.save();
        
        Test.stopTest();     
        
    }
        
      
  }