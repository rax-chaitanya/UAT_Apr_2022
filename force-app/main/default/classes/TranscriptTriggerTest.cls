@isTest
public class TranscriptTriggerTest{

    @isTest 
    static void transcriptTriggerTest(){
        TranscriptHandler th = new TranscriptHandler();
        th.isActive();
        
        Trigger_Manager__c TranscriptSetting = new Trigger_Manager__c();
        TranscriptSetting.Name = 'TranscriptTgr';
        TranscriptSetting.Is_Active__c = true;
        insert TranscriptSetting;
     
        LiveChatVisitor lcv = new LiveChatVisitor();
        insert lcv;
        
        LiveChatTranscript lct = new LiveChatTranscript();
        lct.Livechatvisitorid = lcv.id;
        insert lct;

        Lead ld = new Lead();
        ld.firstname = 'test';
        ld.lastname = 'test123';
        ld.company = 'test';
        ld.focus_area__c = 'Amazon';
        
        insert ld;
        
        lct.Leadid = ld.id;
        update lct; 
        
        lct.RackUid__c = '4444';
        update lct;
	    delete lct;
        undelete lct;
     th.beforeUpdate();
    }
    
}