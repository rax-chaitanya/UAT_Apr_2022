/**
* File : LiveAgentAssignController
* Description : Controller Class for LiveAgentAssignPage. To assign the users for Live Agent Configuration.  
* Created Date : 21/Aug/2017 
* Author : RDC
*/


public class LiveAgentAssignController {

    public Boolean userRemoved{get;set;}
    public Boolean userAdded{get;set;}
    
    Public List<SelectOption> configList {get;set;}
    
    public List<String> selectedUserIds { get; set; }
    public List<String> removedUserIds { get; set; }
    public String whereClause { get; set; }
    private Map<Id, String> availableUsersMap;
    private Map<Id, String> selectedUsersMap;
   
    Public string config{set;get;}
    public string configId{set;get;}
    Public List<LiveChatUserConfig> configUserList{set;get;}
    public List<LiveChatUserConfig> configUsers{set;get;}
    
    Public LiveAgentAssignController(){
        initializeCollections();
        configList = new List<SelectOption>();
        configUserList=[SELECT Id,DeveloperName FROM LiveChatUserConfig order by DeveloperName asc];
                        configList.add(new SelectOption('None','None'));
        for(LiveChatUserConfig temp : configUserList){
            configId = temp.id;
            configList.add(new SelectOption(temp.Id, temp.DeveloperName));   
        }
        if(config  == null ){
            config = 'None';
            getUsers();
        }
    }
    public PageReference UpdateList() {
        initializeCollections();
        getUsers();
        return null;
    }
    
    
    public void filterAvailableUsers() {
        availableUsersMap = new Map<Id, String>();
        selectedUserIds = new List<String>();
        String likeClause = '%' + whereClause + '%';
        for (User u : [SELECT id, name FROM User WHERE name like :likeClause AND IsActive = true AND UserPermissionsLiveAgentUser = true order by Name Asc]) {
            if (!selectedUsersMap.containsKey(u.Id)) {
                availableUsersMap.put(u.Id, u.Name);
            }
        }
    }
    public void addUser() {
        if (!selectedUserIds.isEmpty()) {
            for (String userId : selectedUserIds) {
                selectedUsersMap.put(userId, availableUsersMap.get(userId));
                availableUsersMap.remove(userId);
                userAdded=true;
            }
        }
    }
    public void removeUser() {
        if (!removedUserIds.isEmpty()) {
            for (String userId : removedUserIds) {
                availableUsersMap.put(userId, selectedUsersMap.get(userId));
                selectedUsersMap.remove(userId);
                userRemoved=true;
            }
        }
    }
    public List<SelectOption> getAvailableUsers() {
        List<SelectOption> availableUsers = new List<SelectOption>();
        for (Id userId : availableUsersMap.keySet()) {
            availableUsers.add(new SelectOption(userId, availableUsersMap.get(userId)));
        }
        return availableUsers;
    }
    public List<SelectOption> getSelectedUsers() {
        List<SelectOption> selectedUsers = new List<SelectOption>();
        for (String userId : selectedUsersMap.keySet()) {
            selectedUsers.add(new SelectOption(userId, selectedUsersMap.get(userId)));
        }
        return selectedUsers;
    }
     
    private void getUsers() {
        if(config!='None'){
           set<id> userIds =new set<id>();
           LiveChatUserConfig sk = new LiveChatUserConfig();
           list<user> urs = new List<user>();
           list<user> urss = new List<user>();
           sk = [SELECT Id,DeveloperName FROM LiveChatUserConfig where Id=:config];
            list<LiveChatUserConfigUser> configUsers = [SELECT Id,USerId FROM LiveChatUserConfigUser WHERE LiveChatUserConfigId =:sk.Id];
            for(LiveChatUserConfigUser s:configUsers){
                userIds.add(s.userId);
            }
            urs = [SELECT id, Name FROM User where IsActive = true AND id NOT IN:userIds AND UserPermissionsLiveAgentUser = true order by Name Asc];
            for(user u : urs){
                 availableUsersMap.put(u.Id, u.Name);
            }
            urss = [SELECT id, Name FROM User where IsActive = true AND id IN:userIds AND UserPermissionsLiveAgentUser = true order by Name Asc];
            for(user ur : urss){
                 selectedUsersMap.put(ur.Id, ur.Name);
            }
        }
    }
   
     private void initializeCollections() {
        userRemoved=false;
        userAdded=false;
        selectedUserIds = new List<String>();
        removedUserIds = new List<String>();
        availableUsersMap = new Map<Id, String>();
        selectedUsersMap = new Map<Id, String>();
    }
    
    public PageReference save(){
        try{
            String sessionId =  PartnerAPI.logincall();
            String soapbody1;
            String soapbody2;
            Set<Id> setOfAvailableUserIds = new Set<Id>();
            Set<Id> setOfSelectedUserIds = new Set<Id>();
            List<LiveChatUserConfigUser> liveChatUsers= new List<LiveChatUserConfigUser>();
            List<LiveChatUserConfigUser> liveOfSelectedChatUsers= new List<LiveChatUserConfigUser>();
            List<LiveChatUserConfigUser> selectedUsersWithExistingConfig = new List<LiveChatUserConfigUser>();
            String soapHeader1='<?xml version="1.0" encoding="utf-8"?>' +
                              '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:sobject.partner.soap.sforce.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns2="urn:partner.soap.sforce.com">'+
                              '<SOAP-ENV:Header>'+
                              '<ns2:SessionHeader>'+
                              '<ns2:sessionId>' + sessionId  + 
                              '</ns2:sessionId>'+
                              '</ns2:SessionHeader>'+
                              '</SOAP-ENV:Header>'+
                               '<SOAP-ENV:Body>'+
                              '<ns2:create>';
            String soapFooter1 ='</ns2:create>' +
                        '</SOAP-ENV:Body>'+
                        '</SOAP-ENV:Envelope>';  
            
            setOfAvailableUserIds  = availableUsersMap.keySet();   
            setOfSelectedUserIds = selectedUsersMap.keyset();
            liveChatUsers = [select Id,userId from LiveChatUserConfigUser where LiveChatUserConfigId =: config and UserId IN: setOfAvailableUserIds]; 
            liveOfSelectedChatUsers = [select Id,userId from LiveChatUserConfigUser where LiveChatUserConfigId =: config and UserId IN: setOfSelectedUserIds ]; 
            selectedUsersWithExistingConfig  = [select Id,userId from LiveChatUserConfigUser where LiveChatUserConfigId !=: config and UserId IN: setOfSelectedUserIds ]; 
            if(userRemoved){
                if( !liveChatUsers.isEmpty() ){
                    for(LiveChatUserConfigUser liveUsers: liveChatUsers){
                        String soapBody = '<?xml version="1.0" encoding="UTF-8"?>';
                               soapBody += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:urn="urn:partner.soap.sforce.com">';
                               soapBody += '<soapenv:Header>';
                               soapBody += '<ns1:SessionHeader soapenv:mustUnderstand="0" xmlns:ns1="http://partner.soap.sforce.com">';
                               soapBody += '<ns1:sessionId>' + sessionId  + '</ns1:sessionId>';
                               soapBody += '</ns1:SessionHeader>';
                               soapBody += '</soapenv:Header>';
                               soapBody += '<soapenv:Body>';
                               soapBody += '<urn:delete>';
                               soapBody += '<urn:ids>'+liveUsers.id+'</urn:ids>';
                               soapBody += '</urn:delete>';
                               soapBody += '</soapenv:Body>';
                               soapBody += '</soapenv:Envelope>';  
                        HttpServiceCallout.HttpRequestDelete(soapBody);
                    }   
                }
            }
            if( !selectedUsersWithExistingConfig.isEmpty() ){
                for(LiveChatUserConfigUser selectedUserExisting: selectedUsersWithExistingConfig){
                    String soapBody = '<?xml version="1.0" encoding="UTF-8"?>';
                           soapBody += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:urn="urn:partner.soap.sforce.com">';
                           soapBody += '<soapenv:Header>';
                           soapBody += '<ns1:SessionHeader soapenv:mustUnderstand="0" xmlns:ns1="http://partner.soap.sforce.com">';
                           soapBody += '<ns1:sessionId>' + sessionId  + '</ns1:sessionId>';
                           soapBody += '</ns1:SessionHeader>';
                           soapBody += '</soapenv:Header>';
                           soapBody += '<soapenv:Body>';
                           soapBody += '<urn:delete>';
                           soapBody += '<urn:ids>'+selectedUserExisting.id+'</urn:ids>';
                           soapBody += '</urn:delete>';
                           soapBody += '</soapenv:Body>';
                           soapBody += '</soapenv:Envelope>';  
                    HttpServiceCallout.HttpRequestDelete(soapBody);
                }
            }
            if(selectedUsersMap.size() == 0){
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Error, 'Please select a user.') );
            }
            else{
                if(userAdded){
                    if(selectedUsersMap.size() > 0){
                        for(LiveChatUserConfigUser configUser: liveChatUsers){
                            setOfSelectedUserIds.remove(configUser.userId);
                        } 
                        for(LiveChatUserConfigUser configurationUser: liveOfSelectedChatUsers){
                            setOfSelectedUserIds.remove(configurationUser.userId);
                        }                       
                        for(id ids: setOfSelectedUserIds){
                            if(soapbody1 == null){
                                soapbody1 ='<ns2:sObjects>'+
                                           '<ns1:type>LiveChatUserConfigUser</ns1:type>'+
                                           '<ns1:Id xsi:nil="true"/>'+
                                           '<LiveChatUserConfigId >' + config +'</LiveChatUserConfigId >'+
                                           '<UserId>'+ + ids +'</UserId>'+                                                          
                                           '</ns2:sObjects>';   
                            }
                            else{
                                soapbody1 +='<ns2:sObjects>'+
                                            '<ns1:type>LiveChatUserConfigUser</ns1:type>'+
                                            '<ns1:Id xsi:nil="true"/>'+
                                            '<LiveChatUserConfigId >' + config +'</LiveChatUserConfigId >'+
                                            '<UserId>' + + ids  +'</UserId>'+                                                          
                                            '</ns2:sObjects>'; 
                            }
                        }
                        HttpServiceCallout.HttpRequestForSkillsAssignment(SoapConstant.partnerSoapEndPoint, 'POST', '"', 'text/xml', soapHeader1 + soapbody1 + soapFooter1);
                        ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.CONFIRM, 'User is assigned to the Live Agent Configuration.') );
                    }              
                }
            }
            getUsers();
        }
        catch (Exception e) {
            ExceptionHandler.postToAll(e, true);
        }
        return null;
    }
    
    public PageReference cancel(){
       initializeCollections();
       config ='None';
       configList = new List<SelectOption>();
       configUserList=[SELECT Id,DeveloperName FROM LiveChatUserConfig order by DeveloperName asc];
                      configList.add(new SelectOption('None','None'));
       for(LiveChatUserConfig temp : configUserList){
           configId = temp.id;
           configList.add(new SelectOption(temp.Id, temp.DeveloperName));   
       }
       if(config  == null ){ config = 'None'; getUsers();
       }
       return null;
    }
}