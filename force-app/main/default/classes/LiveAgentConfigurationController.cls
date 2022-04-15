/**
* File :  LiveAgentConfigurationController.cls
* Description : Controller Class for LiveAgentConfigurationPage. For the Live Agent Configuration. 
* Created Date : 20/Jun/2017 
* Author : RDC
*/

public class LiveAgentConfigurationController {
    
    /*for Supervisor Settings*/
    /*for Chat Buttons*/
    public List<string> selectedChatIds{set;get;}
    public List<string> removeChatIds{set;get;}
    private Map<Id,String> avaliableChatMap;
    private Map<Id,String> selectedChatMap;
    /*Basic Information declaration*/
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
    public Boolean assistanceFlagEnabled{set;get;}
    public Boolean monitor{get;set;}
    /* For supervisor settings declaration*/
    public Boolean chatMonitoringEnabled{set;get;}
    public Boolean whisperMessagesEnabled{set;get;}
    public Boolean agentSneakPeekEnabled{set;get;}
    public String defaultAgentStatusFilters{set;get;}
    public String defaultSkillFilter{set;get;}
    public String defaultButtonFilter{set;get;}
    /*For Chat conference settings*/
    public Boolean chatConferencingEnabled{set;get;}
    /*For chat transfer settings*/
    public Boolean chatTransferToAgentsEnabled{set;get;}
    public Boolean chatTransferToSkillsEnabled{set;get;}
    public Boolean chatTransferToLiveChatButtonsEnabled{set;get;}
    
    public LiveAgentConfigurationController(){
        chatTransferToAgentsEnabled = true;
        chatTransferToSkillsEnabled = false;
        chatTransferToLiveChatButtonsEnabled = true;
        initializeCollections();
        Chats();
        chatMonitoring();
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

    
    public void Chats(){
          List<LiveChatButton> ch = [SELECT Id,DeveloperName FROM LiveChatButton];
          for(LiveChatButton chs:ch){
              avaliableChatMap.put(chs.Id, chs.DeveloperName);
          }
    }
    public void addChats() {
        if (!selectedChatIds.isEmpty()) {
            for (String chatId : selectedChatIds){
                selectedChatMap.put(chatId, avaliableChatMap.get(chatId));
                avaliableChatMap.remove(chatId);
            }
        }
    }
    public void removeChat() {
        if (!removeChatIds.isEmpty()) {
            for (String chatId : removeChatIds){
                avaliableChatMap.put(chatId , selectedChatMap.get(chatId));
                selectedChatMap.remove(chatId);    
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
    private void initializeCollections() {
        selectedChatIds= New List<string>();
        removeChatIds= New List<string>();
        avaliableChatMap= New Map<Id,String>();
        selectedChatMap= New Map<Id,String>();
        chatMonitoringEnabled=false;
    }
    public PageReference save(){
       String retVal = '';
       Pattern nonAlphaNumeric = Pattern.compile('[^a-zA-Z0-9]');
       Matcher clean = nonAlphaNumeric.matcher(developerName);
       retVal = clean.replaceAll('_');
        try{
            String session =  PartnerAPI.logincall();
            List<LiveChatUserConfig> existingAgent = new List<LiveChatUserConfig>();
            String soapbody;  
            String soapHeader='<?xml version="1.0" encoding="utf-8"?>' +
                              '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:sobject.partner.soap.sforce.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns2="urn:partner.soap.sforce.com">'+
                              '<SOAP-ENV:Header>'+
                              '<ns2:SessionHeader>'+
                              '<ns2:sessionId>' + session + 
                              '</ns2:sessionId>'+
                              '</ns2:SessionHeader>'+
                              '</SOAP-ENV:Header>'+
                               '<SOAP-ENV:Body>'+
                              '<ns2:create>';
            String soapFooter ='</ns2:create>' +
                               '</SOAP-ENV:Body>'+
                               '</SOAP-ENV:Envelope>';   
            existingAgent = [Select Id from LiveChatUserConfig where MasterLabel =:developerName];
            if(developerName ==''){
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Error, 'Live Configuration Agent Name is required.') );
            }
            else if(existingAgent != null && existingAgent.size()>0){
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Error, 'Live Configuration Agent already exists.') );
            }
            else{
               //   insert skill
                soapbody ='<ns2:sObjects>'+
                          '<ns1:type>LiveChatUserConfig</ns1:type>'+
                          '<ns1:Id xsi:nil="true"/>';
                if(developerName !=null){
                 if((developerName.startsWith('')|| developerName.endsWith('')) && (retVal.startsWith('_')|| retVal.endsWith('_'))){
                        developerName = developerName.trim();
                        existingAgent = [Select Id from LiveChatUserConfig where MasterLabel =:developerName];
                        if(existingAgent != null && existingAgent.size()>0){
                            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Error, 'Live Configuration Agent already exists.') );
                        }
                        retVal = retVal.removeEnd('_');
                        retVal = retVal.removeStart('_');   
                    soapbody +='<DeveloperName>' + developerName +'</DeveloperName>'+
                               '<MasterLabel>' + developerName+'</MasterLabel>';
                }else {
                        soapbody +='<DeveloperName>' + retVal +'</DeveloperName>';
                        soapbody +='<MasterLabel>' + developerName+'</MasterLabel>';
                    }
                }
                soapbody +='<HasSneakPeek>' + sneakPeekEnabled+'</HasSneakPeek>';
                soapbody +='<HasRequestSound>' + requestSoundEnabled+'</HasRequestSound>';
                soapbody +='<HasLogoutSound>' + disconnectSoundEnabled +'</HasLogoutSound>';
                soapbody +='<HasNotifications>' + notificationsEnabled+'</HasNotifications>';
                if(customAgentName !=null){   
                    soapbody +='<CustomAgentName>' + customAgentName +'</CustomAgentName>';
                }
                if(autoGreeting != null && autoGreeting != ''){
                    soapbody +='<AutoGreeting>' + autoGreeting+'</AutoGreeting>';
                }
                soapbody +='<IsAutoAwayOnDecline>' + autoAwayOnDecline +'</IsAutoAwayOnDecline>';
                soapbody +='<OptionsIsAutoAwayOnPushTimeout>' + autoAwayOnPushTimeOut +'</OptionsIsAutoAwayOnPushTimeout>';
                if(criticalWaitAlertTime!=null && criticalWaitAlertTime!=0){
                    soapbody +='<CriticalWaitTime>' + criticalWaitAlertTime+'</CriticalWaitTime >';
                }
                soapbody +='<OptionsHasAgentFileTransfer>' + agentFileTransferEnabled+'</OptionsHasAgentFileTransfer>';
                soapbody +='<OptionsHasVisitorBlocking>' + visitorBlockingEnabled+'</OptionsHasVisitorBlocking>';
                soapbody +='<OptionsHasAssistanceFlag>' + assistanceFlagEnabled +'</OptionsHasAssistanceFlag>';
                soapbody +='<OptionsHasChatMonitoring>' + chatMonitoringEnabled+'</OptionsHasChatMonitoring>';
                soapbody +='<OptionsHasWhisperMessage>' + whisperMessagesEnabled+'</OptionsHasWhisperMessage>';
                soapbody +='<OptionsHasAgentSneakPeek>' + agentSneakPeekEnabled+'</OptionsHasAgentSneakPeek>';
                soapbody +='<OptionsHasChatConferencing>' + chatConferencingEnabled +'</OptionsHasChatConferencing>';
                
                soapbody +='<OptionsHasChatTransferToAgent>' + chatTransferToAgentsEnabled+'</OptionsHasChatTransferToAgent>'+
                           '<OptionsHasChatTransferToSkill>' + chatTransferToSkillsEnabled+'</OptionsHasChatTransferToSkill>'+
                           '<OptionsHasChatTransferToButton>' + chatTransferToLiveChatButtonsEnabled+'</OptionsHasChatTransferToButton>';

                soapbody += '</ns2:sObjects>';
                HttpServiceCallout.HttpRequest(SoapConstant.partnerSoapEndPoint, 'POST', 'create', 'text/xml', soapHeader + soapbody + soapFooter);
            }        

            List<LiveChatUserConfig> ConfigRecord = new List<LiveChatUserConfig>();
            ConfigRecord = [Select Id from LiveChatUserConfig where MasterLabel =:developerName LIMIT 1];
            if((ConfigRecord.size() > 0) && (existingAgent.size()== 0)){
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Live Configuration Agent is created.') );
                LiveChatUserConfig con = new LiveChatUserConfig();
                con = [Select Id from LiveChatUserConfig where MasterLabel =:developerName];
                if(con !=null){
                    String body;
                    String header ='<?xml version="1.0" encoding="utf-8"?>' +
                                   '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:sobject.partner.soap.sforce.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns2="urn:partner.soap.sforce.com">'+
                                   '<SOAP-ENV:Header>'+
                                   '<ns2:SessionHeader>'+
                                   '<ns2:sessionId>' + session + 
                                   '</ns2:sessionId>'+
                                   '</ns2:SessionHeader>'+
                                   '</SOAP-ENV:Header>'+
                                   '<SOAP-ENV:Body>'+
                                   '<ns2:create>';
                    String footer ='</ns2:create>' +
                                   '</SOAP-ENV:Body>'+
                                   '</SOAP-ENV:Envelope>';    
                    
                    Set<Id> chatIds = selectedChatMap.keySet();
                    String sbody;
                    String sheader ='<?xml version="1.0" encoding="utf-8"?>' +
                                    '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:sobject.partner.soap.sforce.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns2="urn:partner.soap.sforce.com">'+
                                    '<SOAP-ENV:Header>'+
                                    '<ns2:SessionHeader>'+
                                    '<ns2:sessionId>' + session + 
                                    '</ns2:sessionId>'+
                                    '</ns2:SessionHeader>'+
                                    '</SOAP-ENV:Header>'+
                                    '<SOAP-ENV:Body>'+
                                    '<ns2:create>';
                    String sfooter ='</ns2:create>' +
                                    '</SOAP-ENV:Body>'+
                                    '</SOAP-ENV:Envelope>'; 
                    if(chatIds != null){   
                        for(Id cids: chatIds ){
                            sbody +='<ns2:sObjects>'+
                                    '<ns1:type>UserConfigTransferButton</ns1:type>'+
                                    '<ns1:Id xsi:nil="true"/>'+
                                    '<LiveChatButtonId>' + cids +'</LiveChatButtonId>'+
                                    '<LiveChatUserConfigId>' +con.Id +'</LiveChatUserConfigId>'+
                                    '</ns2:sObjects>';
                        }
                        HttpServiceCallout.HttpRequestForSkillsAssignment(SoapConstant.partnerSoapEndPoint, 'POST', 'create', 'text/xml', sheader+ sbody + sfooter);                     
                    }                    
                }
            }
        }
        catch (Exception e) {
            ExceptionHandler.postToAll(e, true);
        }
        return null;
    }
    public PageReference cancel(){
        developerName='';
        sneakPeekEnabled=false;
        requestSoundEnabled=false;
        disconnectSoundEnabled=false;
        notificationsEnabled=false;
        customAgentName='';
        autoGreeting='';
        autoAwayOnDecline=false;
        autoAwayOnPushTimeOut=false; 
        agentFileTransferEnabled=false;
        visitorBlockingEnabled=false;
        assistanceFlagEnabled=false; 
        chatMonitoringEnabled=false;
        whisperMessagesEnabled=false;
        agentSneakPeekEnabled=false;
        chatConferencingEnabled=false; 
        defaultAgentStatusFilters='Offline';
        criticalWaitAlertTime = 0;
        avaliableChatMap.putAll(selectedChatMap);
        selectedChatMap.clear();
        getAvailableChats();
        return null;
    }      
}