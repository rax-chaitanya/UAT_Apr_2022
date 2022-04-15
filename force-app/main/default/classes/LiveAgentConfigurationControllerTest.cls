@isTest
    public class LiveAgentConfigurationControllerTest 
    {
    @testSetup
    public static  void testSetup()
    {
        TestDataSetUp.insertTestRecords();
    }
    public static testMethod void testCancel()
    {
        LiveAgentConfigurationController cntlr = new LiveAgentConfigurationController();
        PageReference pg = Page.LiveAgentConfigurationPage;
        Test.setCurrentPage(pg);
        cntlr.cancel();
    }
      
    public static testMethod void ConfigurationTest_catch(){
        PageReference pg = Page.LiveAgentConfigurationPage;
        Test.setCurrentPage(pg);
        LiveAgentConfigurationController cntlr_catch = new LiveAgentConfigurationController();
        
       
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_xml());
        Test.stopTest();
        
        try{
            cntlr_catch.save();
        }catch(Exception e){}
    }
        
    public static testMethod void ConfigurationTest(){

        PageReference pg = Page.LiveAgentConfigurationPage;
        Test.setCurrentPage(pg);
        LiveAgentConfigurationController cntlr1 = new LiveAgentConfigurationController();
    
        LiveAgentConfigurationController cntlr2 = new LiveAgentConfigurationController();
        
        LiveAgentConfigurationController cntlr3 = new LiveAgentConfigurationController();

        LiveAgentConfigurationController cntlr4 = new LiveAgentConfigurationController();

        cntlr1.liveAgentConfigurationName = 'Testconfig';
        cntlr1.developerName = 'Test config Test';        
        cntlr1.sneakPeekEnabled = false;
        cntlr1.requestSoundEnabled = false;
        cntlr1.disconnectSoundEnabled = false;
        cntlr1.notificationsEnabled = false;
        cntlr1.customAgentName = 'Deepak';
        cntlr1.autoGreeting = 'Something';
        cntlr1.autoAwayOnDecline = false;
        cntlr1.autoAwayOnPushTimeOut = false;
        cntlr1.criticalWaitAlertTime = 30;
        cntlr1.agentFileTransferEnabled = false;
        cntlr1.visitorBlockingEnabled = false;
        cntlr1.assistanceFlagEnabled = false;
        cntlr1.chatMonitoringEnabled = False;
        cntlr1.chatMonitoring();
        cntlr1.whisperMessagesEnabled = False;
        cntlr1.agentSneakPeekEnabled = False;
        cntlr1.chatMonitoringEnabled = true;
        cntlr1.chatMonitoring();
        
        cntlr1.defaultButtonFilter='chatbutton';
        cntlr1.defaultSkillFilter='testSkill';
        
        List<SelectOption> options = new List<SelectOption>();
        options = cntlr1.getDefaultAgentStatusFilter();
        system.assertEquals(options.get(0).getValue(),'Online');
        
        cntlr1.chatConferencingEnabled = false;
        cntlr1.chatTransferToAgentsEnabled = true;
        cntlr1.chatTransferToSkillsEnabled = false;
        cntlr1.chatTransferToLiveChatButtonsEnabled = True;
        
        LiveChatButton chat= [select id from LiveChatButton limit 1];
        
        cntlr1.getAvailableChats();
        cntlr1.selectedChatIds.add(chat.Id);
        cntlr1.addChats();  
        cntlr1.getSelectedChats(); 
        cntlr1.removeChatIds.add(chat.Id);
        cntlr1.removeChat();
        cntlr1.getSelectedChats();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_xml());
        
        cntlr1.save();
        
        cntlr2.developername = ' TestconfigTest';
        cntlr2.save();
        
        cntlr3.developername = '';
        cntlr3.save();
        
        cntlr4.developername = 'TestconfigTest';
        cntlr4.save();
        Test.stopTest();

    }
 }