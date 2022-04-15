/**
* File :  LiveAgentConfigEditController.cls
* Description : Controller Class for LiveAgentConfigEditPage. For the user configuration settings. 
* Created Date : 20/Jun/2017 
* Author : RDC
*/

public with sharing class LiveAgentConfigEditController {

    //for conditional SOAP call
    public Boolean chatAdded{get;set;}
    public Boolean chatRemoved{get;set;}

    /*for Chat Transfer Settings*/
    
    /*for Chat Buttons*/
    public List<string> selectedChatIds{set;get;}
    public List<string> removeChatIds{set;get;}
    private Map<Id,String> avaliableChatMap;
    private Map<Id,String> selectedChatMap;


    public String defaultAgentStatusFilters{get;set;} 
    Public List<SelectOption> configList {get;set;}
    Public string config{set;get;}
    public string configId{set;get;}
    Public List<LiveChatUserConfig> configUserList{set;get;}
    public string liveAgentConfigurationName{set;get;}
    public string developerName{set;get;}
    public Boolean sneakPeekEnabled{set;get;}
    public Boolean requestSoundEnabled{set;get;}
    public Boolean disconnectSoundEnabled{set;get;}
    public Boolean notificationsEnabled{set;get;}
    public String customAgentName{set;get;}
    public String autoGreeting{set;get;}
    public Boolean autoAwayOnDecline{set;get;}
    public Boolean autoAwayOnPushTimeOut{set;get;}
    public Integer criticalWaitAlertTime{set;get;}
    public Boolean agentFileTransferEnabled{set;get;}
    public Boolean visitorBlockingEnabled{set;get;}
    public Boolean chatMonitoringEnabled{set;get;}
    public Boolean assistanceFlagEnabled{set;get;}
    public Boolean whisperMessagesEnabled{set;get;}
    public Boolean agentSneakPeekEnabled{set;get;}
    /*For Chat conference settings*/
    public Boolean chatConferencingEnabled{set;get;}
    public Boolean monitor{get;set;}
    /*For chat transfer settings*/
    public Boolean chatTransferToAgentsEnabled{set;get;}
    public Boolean chatTransferToSkillsEnabled{set;get;}
    public Boolean chatTransferToLiveChatButtonsEnabled{set;get;}

    Public LiveAgentConfigEditController(){
        configList = new List<SelectOption>();
        configUserList=[SELECT Id,DeveloperName FROM LiveChatUserConfig];
        configList.add(new SelectOption('None','None'));
        for(LiveChatUserConfig temp : configUserList){
          configId = temp.id;
          configList.add(new SelectOption(temp.Id, temp.DeveloperName));   
        }
        if(config  == null ){
            config = 'None';
            initializeCollections();
            UpdateList();
        }
    }
    
    public void chatMonitoring(){
        if(!chatMonitoringEnabled){
            monitor= true;
            whisperMessagesEnabled= false;
            agentSneakPeekEnabled= false;
        }
        else{
            monitor= false;
        }         
    }
    public List<SelectOption> getDefaultAgentStatusFilter() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = LiveChatUserConfig.SupervisorDefaultAgentStatus.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    }
    
    public void addChats() {
        if (!selectedChatIds.isEmpty()) {
            for (String chatId : selectedChatIds) 
            {
                   selectedChatMap.put(chatId, avaliableChatMap.get(chatId));
                   avaliableChatMap.remove(chatId);
                                   chatAdded = true;                

            }
        }
    }

    public void removeChat() {
        if (!removeChatIds.isEmpty()) {
            for (String chatId : removeChatIds){
                avaliableChatMap.put(chatId , selectedChatMap.get(chatId));
                selectedChatMap.remove(chatId);   
                chatRemoved = true;                
            }
        }
    }

    public List<SelectOption> getAvailableChats() {
        List<SelectOption> availableChats = new List<SelectOption>();
        for (Id chatId : avaliableChatMap.keySet()){
            availableChats.add(new SelectOption(chatId, avaliableChatMap.get(chatId)));
        }
        return availableChats;
    }

    public List<SelectOption> getSelectedChats() {
        List<SelectOption> selectedchats = new List<SelectOption>();
        for (String chatId : selectedChatMap.keySet()){ 
            selectedchats.add(new SelectOption(chatId, selectedChatMap.get(chatId)));
        }
        return selectedchats;
    }
    
    public void initializeCollections() {
        chatAdded= false;
        chatRemoved= false;
        selectedChatIds= New List<string>();
        removeChatIds= New List<string>();
        avaliableChatMap= New Map<Id,String>();
        selectedChatMap= New Map<Id,String>();
        chatMonitoringEnabled= false;
    }
    
    public PageReference UpdateList() {
        getprops();
        getChats();
        chatMonitoring();
        return null;
    }
   
    public void getProps() {
        if(config!='None'){
            LiveChatUserConfig cg = [SELECT Id,DeveloperName,HasLogoutSound,HasNotifications,HasRequestSound,HasSneakPeek,IsAutoAwayOnDecline,CriticalWaitTime,  
                                  OptionsHasAgentFileTransfer,OptionsHasAgentSneakPeek,OptionsHasAssistanceFlag,AutoGreeting,CustomAgentName, 
                                  OptionsHasChatConferencing,OptionsHasChatTransferToSkill,OptionsHasChatMonitoring,
                                  OptionsHasVisitorBlocking,OptionsHasWhisperMessage,OptionsIsAutoAwayOnPushTimeout,
                                  OptionsHasChatTransferToAgent,
                                  OptionsHasChatTransferToButton,
                                  SupervisorDefaultAgentStatus
                                  FROM LiveChatUserConfig 
                                  where Id=:config];
                                  
            sneakPeekEnabled = cg.HasSneakPeek;  
            configid= cg.id;
            liveAgentConfigurationName = cg.DeveloperName;
            requestSoundEnabled = cg.HasRequestSound;
            disconnectSoundEnabled = cg.HasLogoutSound;
            notificationsEnabled = cg.HasNotifications;
            autoAwayOnDecline = cg.IsAutoAwayOnDecline ;
            criticalWaitAlertTime = cg.CriticalWaitTime; 
            agentFileTransferEnabled = cg.OptionsHasAgentFileTransfer;
            visitorBlockingEnabled = cg.OptionsHasVisitorBlocking;
            assistanceFlagEnabled = cg.OptionsHasAssistanceFlag;
            autoAwayOnPushTimeOut = cg.OptionsIsAutoAwayOnPushTimeout;
            customAgentName = cg.CustomAgentName;
            autoGreeting = cg.AutoGreeting;
            chatMonitoringEnabled = cg.OptionsHasChatMonitoring;
            whisperMessagesEnabled = cg.OptionsHasWhisperMessage;
            agentSneakPeekEnabled = cg.OptionsHasAgentSneakPeek;
            defaultAgentStatusFilters = cg.SupervisorDefaultAgentStatus;
            chatConferencingEnabled = cg.OptionsHasChatConferencing;
            chatTransferToAgentsEnabled = cg.OptionsHasChatTransferToAgent;
            chatTransferToSkillsEnabled = cg.OptionsHasChatTransferToSkill;
            chatTransferToLiveChatButtonsEnabled = cg.OptionsHasChatTransferToButton;
        }
    }
    
    
    public void getChats(){
        if(config!='None'){
            set<id> buttonids=new set<id>();
            list<UserConfigTransferButton> configbuttons = new list<UserConfigTransferButton>();
           list<LiveChatButton > skls = new list<LiveChatButton >();
            list<LiveChatButton > sklss = new list<LiveChatButton >();
            configbuttons= [SELECT Id,LiveChatButtonId FROM UserConfigTransferButton WHERE LiveChatUserConfigId =:configId];
            for(UserConfigTransferButton s : configbuttons){
                buttonids.add(s.LiveChatButtonId);
            }
            skls = [SELECT id, DeveloperName FROM LiveChatButton where id NOT IN:buttonIds order by DeveloperName Asc];
            for(LiveChatButton s : skls){
                 avaliableChatMap.put(s.Id, s.DeveloperName);
            }
            sklss = [SELECT id, DeveloperName FROM LiveChatButton where id IN:buttonIds order by DeveloperName Asc];
            for(LiveChatButton ss : sklss){
                 selectedChatMap.put(ss.Id, ss.DeveloperName);
            }
        }
    }
    
    public PageReference save(){
        try{    
            String sessionId =  PartnerAPI.logincall();
            set<id> transferButtonIds = new set<id>();
            List<UserConfigTransferButton> buttonTransfer =new List<UserConfigTransferButton>();
            String soapbody4;       
            String body;
            
            //ADD/REMOVE Supervisor Agent Config Skill
            String soapHeader1='<?xml version="1.0" encoding="utf-8"?>' +
                          '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:sobject.partner.soap.sforce.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns2="urn:partner.soap.sforce.com">'+
                          '<SOAP-ENV:Header>'+
                          '<ns2:SessionHeader>'+
                          '<ns2:sessionId>' + sessionId + 
                          '</ns2:sessionId>'+
                          '</ns2:SessionHeader>'+
                          '</SOAP-ENV:Header>'+
                           '<SOAP-ENV:Body>'+
                           '<ns2:create>';
            String soapFooter1 ='</ns2:create>'+
                                '</SOAP-ENV:Body>'+
                                '</SOAP-ENV:Envelope>';    
            //ADD/REMOVE User Config Transfer Button
            transferButtonIds = avaliableChatMap.keyset();
            buttonTransfer = [SELECT Id,LiveChatButtonId FROM UserConfigTransferButton WHERE LiveChatUserConfigId =: configid AND LiveChatButtonId IN: transferButtonIds];  
            if(chatRemoved){
                if( !buttonTransfer .isEmpty() ){
                    for(UserConfigTransferButton su: buttonTransfer ){
                        String soapBody = '<?xml version="1.0" encoding="UTF-8"?>';
                               soapBody += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:urn="urn:partner.soap.sforce.com">';
                               soapBody += '<soapenv:Header>';
                               soapBody += '<ns1:SessionHeader soapenv:mustUnderstand="0" xmlns:ns1="http://partner.soap.sforce.com">';
                               soapBody += '<ns1:sessionId>' + sessionId + '</ns1:sessionId>';
                               soapBody += '</ns1:SessionHeader>';
                               soapBody += '</soapenv:Header>';
                               soapBody += '<soapenv:Body>';
                               soapBody += '<urn:delete>';
                               soapBody += '<urn:ids>'+su.id+'</urn:ids>';
                               soapBody += '</urn:delete>';
                               soapBody += '</soapenv:Body>';
                               soapBody += '</soapenv:Envelope>';  
                        HttpServiceCallout.HttpRequestDelete(soapBody);
                    }   
                }
            }
            if(chatAdded){   
                if(selectedChatMap.size() == 0){
                    ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Error, 'Please .') );
                }
                else{
                    Set<Id> skillIds = new Set<Id>(); 
                    List<UserConfigTransferButton> existButtonTransfer = new List<UserConfigTransferButton>();
                    skillIds = selectedChatMap.keyset(); 
                    existButtonTransfer = [SELECT Id,LiveChatButtonId FROM UserConfigTransferButton WHERE LiveChatUserConfigId =: configid AND LiveChatButtonId IN: skillIds ];  
                    for(UserConfigTransferButton ski: buttonTransfer ){
                        skillIds.remove(ski.LiveChatButtonId);
                    }  
                    for(UserConfigTransferButton ski: existButtonTransfer ){
                       skillIds.remove(ski.LiveChatButtonId);
                    }                  
                    if(configid !=null){
                        if(skillIds !=null){   
                          for(Id ids: skillIds){
                              body += '<ns2:sObjects>'+
                                 '<ns1:type>UserConfigTransferButton</ns1:type>'+
                                 '<ns1:Id xsi:nil="true"/>'+
                                 '<ns1:LiveChatButtonId>' + ids +'</ns1:LiveChatButtonId>'+
                                 '<ns1:LiveChatUserConfigId>' +configId +'</ns1:LiveChatUserConfigId>'+
                                 '</ns2:sObjects>' ;
                          }
                          HttpServiceCallout.HttpRequestForSkillsAssignment(SoapConstant.partnerSoapEndPoint, 'POST', 'create', 'text/xml', soapheader1+ body + soapfooter1);
                        }
                    }
                }  
            }   
            //UPDATE Live Agent User Config
            String soapHeader4='<?xml version="1.0" encoding="utf-8"?>' +
                               '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:sobject.partner.soap.sforce.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns2="urn:partner.soap.sforce.com">'+
                               '<SOAP-ENV:Header>'+
                               '<ns2:SessionHeader>'+
                               '<ns2:sessionId>' + sessionId + 
                               '</ns2:sessionId>'+
                               '</ns2:SessionHeader>'+
                               '</SOAP-ENV:Header>'+
                               '<SOAP-ENV:Body>';
            String soapFooter4 ='</ns2:update>' +
                                '</SOAP-ENV:Body>'+
                                '</SOAP-ENV:Envelope>';    
            if(liveAgentConfigurationName==''){
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Error, 'Please Select a Live Configuration') );
            }
            else{
                soapbody4 ='<ns2:update>'+
                           '<ns2:sObjects>'+
                           '<ns1:type>LiveChatUserConfig</ns1:type>'+
                           '<ns1:id>' + configid+'</ns1:id>'+
                           '<ns1:DeveloperName>' + liveAgentConfigurationName +'</ns1:DeveloperName>'+
                           '<ns1:MasterLabel>' + liveAgentConfigurationName +'</ns1:MasterLabel>'+
                           '<ns1:HasSneakPeek>' + sneakPeekEnabled+'</ns1:HasSneakPeek>'+
                           '<ns1:HasRequestSound>' + requestSoundEnabled+'</ns1:HasRequestSound>'+
                           '<ns1:HasLogoutSound>' + disconnectSoundEnabled+'</ns1:HasLogoutSound>'+
                           '<ns1:HasNotifications>' + notificationsEnabled+'</ns1:HasNotifications>'+
                           '<ns1:CustomAgentName >' + customAgentName+'</ns1:CustomAgentName>'+
                           '<ns1:AutoGreeting>' + autoGreeting+'</ns1:AutoGreeting >'; 
                           if(criticalWaitAlertTime!=null && criticalWaitAlertTime!=0){
                               soapbody4 +='<CriticalWaitTime>' + criticalWaitAlertTime+'</CriticalWaitTime >';
                           }
                           else{
                                 soapbody4 +=  '<ns1:fieldsToNull>' + 'CriticalWaitTime' +'</ns1:fieldsToNull>';
                           }  
                           soapbody4 +='<ns1:OptionsIsAutoAwayOnPushTimeout>' + autoAwayOnPushTimeOut+'</ns1:OptionsIsAutoAwayOnPushTimeout>'+                           '<ns1:IsAutoAwayOnDecline>' + autoAwayOnDecline+'</ns1:IsAutoAwayOnDecline>'+
                           '<ns1:OptionsHasAgentFileTransfer>' + agentFileTransferEnabled+'</ns1:OptionsHasAgentFileTransfer>'+
                           '<ns1:OptionsHasVisitorBlocking>' + visitorBlockingEnabled+'</ns1:OptionsHasVisitorBlocking>'+
                           '<ns1:OptionsHasAssistanceFlag>' + assistanceFlagEnabled+'</ns1:OptionsHasAssistanceFlag>'+
                           '<ns1:OptionsHasChatMonitoring>' + chatMonitoringEnabled+'</ns1:OptionsHasChatMonitoring>'+
                           '<ns1:OptionsHasWhisperMessage>' + whisperMessagesEnabled +'</ns1:OptionsHasWhisperMessage>'+
                           '<ns1:OptionsHasAgentSneakPeek>' + agentSneakPeekEnabled +'</ns1:OptionsHasAgentSneakPeek>'+
                           '<ns1:SupervisorDefaultAgentStatus>' + defaultAgentStatusFilters +'</ns1:SupervisorDefaultAgentStatus>'+
                           '<ns1:OptionsHasChatConferencing>' + chatConferencingEnabled+'</ns1:OptionsHasChatConferencing>'+
                           '<ns1:OptionsHasChatTransferToAgent>' + chatTransferToAgentsEnabled+'</ns1:OptionsHasChatTransferToAgent>'+
                           '<ns1:OptionsHasChatTransferToSkill>' + chatTransferToSkillsEnabled+'</ns1:OptionsHasChatTransferToSkill>'+
                           '<ns1:OptionsHasChatTransferToButton>' + chatTransferToLiveChatButtonsEnabled+'</ns1:OptionsHasChatTransferToButton>';
               
                soapbody4 += '</ns2:sObjects>';
            }     
            HttpServiceCallout.HttpRequestForSkillsAssignment(SoapConstant.partnerSoapEndPoint, 'POST', '"', 'text/xml', soapHeader4 + soapbody4 + soapFooter4);
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.confirm, 'Live Configuration Is Successfully Updated' ));
        }
        catch (Exception e){
             ExceptionHandler.postToAll(e, true);
        }            
        return null;

    }
    
    public PageReference cancel(){
        initializeCollections();
        Updatelist();
        return null;
    }
}