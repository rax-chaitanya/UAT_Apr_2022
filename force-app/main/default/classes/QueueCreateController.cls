/**
* File :  QueueCreateController.cls
* Description : Controller Class for QueueCreatePage. To create a new Queue. 
* Created Date : 22/Jun/2017 
* Author : RDC
*/
public without sharing class QueueCreateController {
    
    /*Queue*/
    public List<Group> GroupNameList {get;set;}
    public List<string> selectedSObjects{set;get;}
    public List<string> removeSObjects{set;get;}
    public list<QueueSobject>qobjtoadd {get;set;} 
    public string QueName{set;get;}
    public string developerName{set;get;}
    public String QueEmail{set;get;}
    public Boolean sendEmailToMembers{set;get;}
        public List<String> selectedUserIds { get; set; }
    public List<String> removedUserIds { get; set; }
    public String whereClause { get; set; }

    public Map<String,String> avaliableSupportedObjectsMap;
    public Map<String,String> selectedSupportedObjectsMap;
    public Group queueLookUp{get;set;}
    public List<string> selectedUsr{set;get;}
    public List<string> removeUsers{set;get;}
    public Map<id,String> availableUsersMap;
    public Map<id,String> selectedUsersMap;
    public List<GroupMember> selectUsr{get;set;}
    public set<String> removedUsrs {get;set;}
    public set<String> addedUsrs {get;set;}
    public list<GroupMember>usrtoadd {get;set;} 

    public QueueCreateController(){
        queueLookUp = new Group();
        selectedSObjects= New List<string>();
        removeSObjects= New List<string>();
        selectedUsr = new List<String>();
        removeUsers = new List<String>();
        availableUsersMap = new Map<id, String>();
        selectedUsersMap = new Map<id, String>();
        initializeCollections();
        getUsers();
    }   

    public void SupportedObjects(){       
        avaliableSupportedObjectsMap = new Map<String, String>();
        selectedSupportedObjectsMap = new Map<String, String>();
     /*   avaliableSupportedObjectsMap.put('CloudingoAgent__AccountContact__c', 'AccountContact');
        avaliableSupportedObjectsMap.put('cwbtool__AnalysisSummary__c', 'Analysis Summary');
        avaliableSupportedObjectsMap.put('ddcAssess__Assessment_Summary__c', 'Assessment Summary');
        avaliableSupportedObjectsMap.put('WorkBadgeDefinition', 'Badge');
        avaliableSupportedObjectsMap.put('mkto_si__BestBetsCache__c', 'BestBetsCache');
        avaliableSupportedObjectsMap.put('mkto_si__Best_Bets_View__c', 'Best Bets View');
        avaliableSupportedObjectsMap.put('Case', 'Case');
        avaliableSupportedObjectsMap.put('cLog__c', 'cLog');
        avaliableSupportedObjectsMap.put('CloudingoAgent__CldIn__c', 'CldIn');
        avaliableSupportedObjectsMap.put('CloudingoAgent__CldExtCfg__c', 'CldExtCfg');
        avaliableSupportedObjectsMap.put('WorkCoaching', 'Coaching');
        avaliableSupportedObjectsMap.put('Component_Manager__c', 'Component Manager');
        avaliableSupportedObjectsMap.put('rkpi2__Continent__c', 'Continent');
        avaliableSupportedObjectsMap.put('Contracting_Entity__c', 'Contracting Entity');
        avaliableSupportedObjectsMap.put('cwbtool__Connection__c', 'Connection');
        avaliableSupportedObjectsMap.put('rkpi2__Country__c', 'Country');
        avaliableSupportedObjectsMap.put('rkpi2__County__c', 'County');
        avaliableSupportedObjectsMap.put('mkto_si__EmailActivityCache__c', 'EmailActivityCache');
        avaliableSupportedObjectsMap.put('cwbtool__ErrorLog__c', 'Error Log');
        avaliableSupportedObjectsMap.put('WorkFeedback', 'Feedback');
        avaliableSupportedObjectsMap.put('WorkFeedbackQuestion', 'Feedback Question');
        avaliableSupportedObjectsMap.put('WorkFeedbackQuestionSet', 'Feedback Question Set');
        avaliableSupportedObjectsMap.put('WorkFeedbackTemplate', 'Feedback Template');
        avaliableSupportedObjectsMap.put('cwbtool__FieldTrack__c', 'Field Track');
        avaliableSupportedObjectsMap.put('Field_Trip__Object_Analysis__c', 'Field Trip');
        avaliableSupportedObjectsMap.put('WorkFeedbackRequest', 'Feedback Request');
        avaliableSupportedObjectsMap.put('mkto_si__Get_Method_Argus__c', 'GetMethodArgu');
        avaliableSupportedObjectsMap.put('Goal', 'Goal');
        avaliableSupportedObjectsMap.put('mkto_si__GroupedWebActivityCache__c', 'GroupedWebActivityCache');
        avaliableSupportedObjectsMap.put('mkto_si__InterestingMomentsCache__c', 'InterestingMomentsCache'); */
        //avaliableSupportedObjectsMap.put('KnowledgeArticleVersion', 'Knowledge Article Version');
        avaliableSupportedObjectsMap.put('Lead', 'Lead');
      /*  avaliableSupportedObjectsMap.put('LiveAgentSession', 'Live Agent Session');
        avaliableSupportedObjectsMap.put('Live_Agent_Skill__c', 'Live Agent Skill');*/
        avaliableSupportedObjectsMap.put('LiveChatTranscript', 'Live Chat Transcript');
     /*   avaliableSupportedObjectsMap.put('CloudingoAgent__Log__c', 'Log');
        avaliableSupportedObjectsMap.put('Macro', 'Macro');
        avaliableSupportedObjectsMap.put('mkto_si__Marketo_Sales_Insight_Config__c', 'Marketo Sales Insight Config');
        avaliableSupportedObjectsMap.put('rkpi2__Metro__c', 'Metro');
        avaliableSupportedObjectsMap.put('Metric', 'Metric');
        avaliableSupportedObjectsMap.put('Order', 'Order');
        avaliableSupportedObjectsMap.put('Page_Manager__c', 'Page Manager');
        avaliableSupportedObjectsMap.put('Partner_Role__c', 'Partner Role');
        avaliableSupportedObjectsMap.put('WorkPerformanceCycle', 'Performance Cycle');
        avaliableSupportedObjectsMap.put('PostChatSurvey__c', 'PostChatSurvey');
        avaliableSupportedObjectsMap.put('CloudingoAgent__PO__c', 'PO');
        avaliableSupportedObjectsMap.put('CloudingoAgent__POSync__c', 'POSync');
        avaliableSupportedObjectsMap.put('Project__c', 'Project');
        avaliableSupportedObjectsMap.put('Project_Pricing__c', 'Project Pricing');
        avaliableSupportedObjectsMap.put('Project_Role_Resources__c', 'Project Role Resources');
        avaliableSupportedObjectsMap.put('Query_Manager__c', 'Query Manager');
        avaliableSupportedObjectsMap.put('QuickText', 'Quick Text');
        avaliableSupportedObjectsMap.put('rkpi2__Region__c', 'Region');
        avaliableSupportedObjectsMap.put('WorkReward', 'Reward');
        avaliableSupportedObjectsMap.put('WorkRewardFund', 'Reward Fund');
        avaliableSupportedObjectsMap.put('WorkRewardFundType', 'Reward Fund Type');
        avaliableSupportedObjectsMap.put('rkpi2__RKAPI__c', 'RKAPI');
        avaliableSupportedObjectsMap.put('rvpe__RVAccount__c', 'RV Account');
        avaliableSupportedObjectsMap.put('rvpe__RVMember__c', 'RV Member');
        avaliableSupportedObjectsMap.put('rvpe__RVProgram__c', 'RV Program');
        avaliableSupportedObjectsMap.put('rkpi2__SavedSearch__c', 'Saved Search');
        avaliableSupportedObjectsMap.put('CloudingoAgent__SearchFilter__c', 'SearchFilter');
        avaliableSupportedObjectsMap.put('Section_Manager__c', 'Section Manager');
        avaliableSupportedObjectsMap.put('mkto_si__ScoringCache__c', 'ScoringCache');
        avaliableSupportedObjectsMap.put('SocialPost', 'Social Post');
        avaliableSupportedObjectsMap.put('Specialist__c', 'Specialist');
        avaliableSupportedObjectsMap.put('rkpi2__State__c', 'State');
        avaliableSupportedObjectsMap.put('WorkThanks', 'Thanks');
        avaliableSupportedObjectsMap.put('UserServicePresence', 'User Presence');
        avaliableSupportedObjectsMap.put('mkto_si__Value__c', 'Value');
        avaliableSupportedObjectsMap.put('mkto_si__WebActivityCache__c', 'WebActivityCache');    */     
    }
    
    public void addSupportedObjects() {
        if (!selectedSObjects.isEmpty()) {
            for (String sobj : selectedSObjects){
                selectedSupportedObjectsMap.put(sobj, avaliableSupportedObjectsMap.get(sobj));
                avaliableSupportedObjectsMap.remove(sobj);
            }
        }
    }

    public void removeSupportedObjects() {
        if (!removeSObjects.isEmpty()) {
            for (String sobj : removeSObjects){
                avaliableSupportedObjectsMap.put(sobj, selectedSupportedObjectsMap.get(sobj));
                selectedSupportedObjectsMap.remove(sobj);
            }
        }
    }
    
    public List<SelectOption> getAvailableSupportedObjects() {
        List<SelectOption> availableSObjects = new List<SelectOption>();
        for (String sobj : avaliableSupportedObjectsMap.keySet()){
            availableSObjects.add(new SelectOption(sobj, avaliableSupportedObjectsMap.get(sobj)));
        }
        return availableSObjects;
    }
    
    public List<SelectOption> getSelectedSupportedObjects() {
        List<SelectOption> selectedSObject = new List<SelectOption>();
        for (String sobj : selectedSupportedObjectsMap.keySet()){ 
            selectedSObject.add(new SelectOption(sobj, selectedSupportedObjectsMap.get(sobj)));
        }
        return selectedSObject;
    }
     public pageReference filterAvailableOptions() {
        availableUsersMap = new Map<Id, String>();
        selectedUserIds = new List<String>();
        String temp = Label.ProfileIdQueueMangement;
        List<String> profileIds = temp.split(',');
        String likeClause = '%' + whereClause + '%';
        for (User u : [SELECT id, name FROM User WHERE name like :likeClause AND Name!='Chatter Expert' AND IsActive = true AND ProfileId IN:profileIds order by Name Asc]) {
            if (!selectedUsersMap.containsKey(u.Id)) {
                availableUsersMap.put(u.Id, u.Name);
            }
        }
        return null;
    }
    public void addUsers() {
        if (!selectedUsr.isEmpty()) {
            for (String usr: selectedUsr){
                selectedUsersMap.put(usr, availableUsersMap.get(usr));
                availableUsersMap.remove(usr);
                if(removedusrs.contains(usr)){
                    removedusrs.remove(usr);
                }
            }
        }
    }

    public void removeUsers() {
        if (!removeUsers.isEmpty()) {
            for (String usr : removeUsers){
                availableUsersMap.put(usr, selectedUsersMap.get(usr));
                selectedUsersMap.remove(usr);
                removedusrs.add(usr);
                //addedsobjs.remove(sobj);
            }
        }
    }
    
    public List<SelectOption> getAvailableUsers() {
        List<SelectOption> availableUsers = new List<SelectOption>();
        for (String usr : availableUsersMap.keySet()){
            availableUsers.add(new SelectOption(usr, availableUsersMap.get(usr)));
        }
        return availableUsers;
    }
   
    public List<SelectOption> getSelectedUsersList() {
        List<SelectOption> selectedUser = new List<SelectOption>();
        for (String usr : selectedUsersMap.keySet()){ 
            selectedUser.add(new SelectOption(usr, selectedUsersMap.get(usr)));
        }
        return selectedUser;
    }
    
    public void getUsers(){
        removedusrs = new set<string>();
        addedusrs = new set<string>();
        String temp = Label.ProfileIdQueueMangement;
        List<String> profileIds = temp.split(',');
        list<user> urs = [SELECT id, Name FROM User where IsActive = true AND ProfileId IN:profileIds order by Name Asc];
            for(user u : urs){
                availableUsersMap.put(u.Id, u.Name);
            }
    }
    
    private void initializeCollections() {
    }    
    public PageReference save(){
            if(string.isEmpty(QueName)){
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Error, 'Queue name is required') );
            }
            else{
            GroupNameList = new List<Group>();
            GroupNameList = [select Id, Name from Group where Type = 'Queue' and Name=:QueName];
            if(GroupNameList.size()>0){
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Error, 'Queue already exists') );
            }
            else{
                try{
                    Group g = new Group(Type='Queue', Name=QueName,Email=QueEmail,DoesSendEmailToMembers=sendEmailToMembers);
                    if(selectedSupportedObjectsMap.keyset().contains('Lead'))
                        g.QueueRoutingConfigId = [select id from QueueRoutingConfig where developername =: 'Lead_Routing'].id;
                    else if(selectedSupportedObjectsMap.keyset().contains('LiveChatTranscript'))
                        g.QueueRoutingConfigId = [select id from QueueRoutingConfig where developername =: 'Chat_Routing'].id;
            
                    insert g;
                    if(!selectedSupportedObjectsMap.keyset().isEmpty()){
                        qobjtoadd = new list<queueSobject>();
                        for(String type : selectedSupportedObjectsMap.keyset()){
                            QueueSObject q = new QueueSObject(SobjectType=type, QueueId=g.Id);
                            qobjtoadd.add(q);
                        }
                        insert qobjtoadd;
                    }
                    if(!selectedUsersMap.keyset().isEmpty()){
                    for(String type : selectedUsersMap.keyset()){
                        insert new GroupMember(GroupId=g.Id,UserOrGroupId=type);
                        }
                     }  
                    ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.CONFIRM, 'Queue created successfully') );
                }
                catch (DMLException e){
                    ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.Error, e.getMessage()) );
                }
            }
            
        }
        return null;
    }
           
    public PageReference cancel(){
        queueLookUp = new Group();
        selectedSObjects= New List<string>();
        removeSObjects= New List<string>();
        selectedUsr = new List<String>();
        removeUsers = new List<String>();
        availableUsersMap = new Map<id, String>();
        selectedUsersMap = new Map<id, String>();
        QueName = '';
        QueEmail = '';
        sendEmailToMembers = false;
        initializeCollections();
        getUsers();
        SupportedObjects();
        return null;
    }      
   
}