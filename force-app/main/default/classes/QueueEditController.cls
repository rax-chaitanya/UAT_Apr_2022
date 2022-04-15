/**
* File :  QueueEditController.cls
* Description : Controller Class for QueueEditPage. To modify Queues. 
* Created Date : 20/Jun/2017 
* Author : RDC
*/
public class QueueEditController {

    

    //queue
    public String SearchQue1 { get; set; }
    public boolean QueTable {get;set;}
    public boolean editblk {get;set;}
    public List<Group> GroupNameList {get;set;}
    public List<String> selectedUserIds { get; set; }
    public List<String> removedUserIds { get; set; }
    public String whereClause { get; set; }
    public String EditQueName { get; set; }
    public String EditQueEmail { get; set; }
    public String EditQueEmailToMem { get; set; }
    public Group queueLookUp{get;set;}
    public List<string> selectedSObjects{set;get;}
    public List<string> removeSObjects{set;get;}
    public List<string> selectedUsr{set;get;}
    public List<string> removeUsers{set;get;}
    public Map<String,String> availableSupportedObjectsMap;
    public Map<String,String> selectedSupportedObjectsMap;
    public Map<id,String> availableUsersMap;
    public Map<id,String> selectedUsersMap;
    public string developerName{set;get;}
    public Id Queid {get;set;}
    public List<QueueSObject> selectSobj{get;set;}
    public set<String> removedSobjs {get;set;}
    public set<String> addedSobjs {get;set;}
    public list<QueueSobject>qobjtoadd {get;set;} 
    public List<GroupMember> selectUsr{get;set;}
    public set<String> removedUsrs {get;set;}
    public set<String> addedUsrs {get;set;}
    public list<GroupMember>usrtoadd {get;set;} 

    Public QueueEditController(){
        SupportedObjects();
        queueLookUp = new Group();
        availableUsersMap = new Map<id, String>();
        selectedUsersMap = new Map<id, String>();
    }
    
    //queue 
    public void SupportedObjects(){       
        availableSupportedObjectsMap = new Map<String, String>();
        selectedSupportedObjectsMap = new Map<String, String>();
      /*  availableSupportedObjectsMap.put('CloudingoAgent__AccountContact__c', 'AccountContact');
        availableSupportedObjectsMap.put('cwbtool__AnalysisSummary__c', 'Analysis Summary');
        availableSupportedObjectsMap.put('ddcAssess__Assessment_Summary__c', 'Assessment Summary');
        availableSupportedObjectsMap.put('WorkBadgeDefinition', 'Badge');
        availableSupportedObjectsMap.put('mkto_si__BestBetsCache__c', 'BestBetsCache');
        availableSupportedObjectsMap.put('mkto_si__Best_Bets_View__c', 'Best Bets View');
        availableSupportedObjectsMap.put('Case', 'Case');
        availableSupportedObjectsMap.put('cLog__c', 'cLog');
        availableSupportedObjectsMap.put('CloudingoAgent__CldIn__c', 'CldIn');
        availableSupportedObjectsMap.put('CloudingoAgent__CldExtCfg__c', 'CldExtCfg');
        availableSupportedObjectsMap.put('WorkCoaching', 'Coaching');
        availableSupportedObjectsMap.put('Component_Manager__c', 'Component Manager');
        availableSupportedObjectsMap.put('rkpi2__Continent__c', 'Continent');
        availableSupportedObjectsMap.put('Contracting_Entity__c', 'Contracting Entity');
        availableSupportedObjectsMap.put('cwbtool__Connection__c', 'Connection');
        availableSupportedObjectsMap.put('rkpi2__Country__c', 'Country');
        availableSupportedObjectsMap.put('rkpi2__County__c', 'County');
        availableSupportedObjectsMap.put('mkto_si__EmailActivityCache__c', 'EmailActivityCache');
        availableSupportedObjectsMap.put('cwbtool__ErrorLog__c', 'Error Log');
        availableSupportedObjectsMap.put('WorkFeedback', 'Feedback');
        availableSupportedObjectsMap.put('WorkFeedbackQuestion', 'Feedback Question');
        availableSupportedObjectsMap.put('WorkFeedbackQuestionSet', 'Feedback Question Set');
        availableSupportedObjectsMap.put('WorkFeedbackTemplate', 'Feedback Template');
        availableSupportedObjectsMap.put('cwbtool__FieldTrack__c', 'Field Track');
        availableSupportedObjectsMap.put('Field_Trip__Object_Analysis__c', 'Field Trip');
        availableSupportedObjectsMap.put('WorkFeedbackRequest', 'Feedback Request');
        availableSupportedObjectsMap.put('mkto_si__Get_Method_Argus__c', 'GetMethodArgu');
        availableSupportedObjectsMap.put('Goal', 'Goal');
        availableSupportedObjectsMap.put('mkto_si__GroupedWebActivityCache__c', 'GroupedWebActivityCache');
        availableSupportedObjectsMap.put('mkto_si__InterestingMomentsCache__c', 'InterestingMomentsCache'); */
        //availableSupportedObjectsMap.put('KnowledgeArticleVersion', 'Knowledge Article Version');
        availableSupportedObjectsMap.put('Lead', 'Lead');
     /*   availableSupportedObjectsMap.put('LiveAgentSession', 'Live Agent Session');
        availableSupportedObjectsMap.put('Live_Agent_Skill__c', 'Live Agent Skill'); */
        availableSupportedObjectsMap.put('LiveChatTranscript', 'Live Chat Transcript');
     /*   availableSupportedObjectsMap.put('CloudingoAgent__Log__c', 'Log');
        availableSupportedObjectsMap.put('Macro', 'Macro');
        availableSupportedObjectsMap.put('mkto_si__Marketo_Sales_Insight_Config__c', 'Marketo Sales Insight Config');
        availableSupportedObjectsMap.put('rkpi2__Metro__c', 'Metro');
        availableSupportedObjectsMap.put('Metric', 'Metric');
        availableSupportedObjectsMap.put('Order', 'Order');
        availableSupportedObjectsMap.put('Page_Manager__c', 'Page Manager');
        availableSupportedObjectsMap.put('Partner_Role__c', 'Partner Role');
        availableSupportedObjectsMap.put('WorkPerformanceCycle', 'Performance Cycle');
        availableSupportedObjectsMap.put('PostChatSurvey__c', 'PostChatSurvey');
        availableSupportedObjectsMap.put('CloudingoAgent__PO__c', 'PO');
        availableSupportedObjectsMap.put('CloudingoAgent__POSync__c', 'POSync');
        availableSupportedObjectsMap.put('Project__c', 'Project');
        availableSupportedObjectsMap.put('Project_Pricing__c', 'Project Pricing');
        availableSupportedObjectsMap.put('Project_Role_Resources__c', 'Project Role Resources');
        availableSupportedObjectsMap.put('Query_Manager__c', 'Query Manager');
        availableSupportedObjectsMap.put('QuickText', 'Quick Text');
        availableSupportedObjectsMap.put('rkpi2__Region__c', 'Region');
        availableSupportedObjectsMap.put('WorkReward', 'Reward');
        availableSupportedObjectsMap.put('WorkRewardFund', 'Reward Fund');
        availableSupportedObjectsMap.put('WorkRewardFundType', 'Reward Fund Type');
        availableSupportedObjectsMap.put('rkpi2__RKAPI__c', 'RKAPI');
        availableSupportedObjectsMap.put('rvpe__RVAccount__c', 'RV Account');
        availableSupportedObjectsMap.put('rvpe__RVMember__c', 'RV Member');
        availableSupportedObjectsMap.put('rvpe__RVProgram__c', 'RV Program');
        availableSupportedObjectsMap.put('rkpi2__SavedSearch__c', 'Saved Search');
        availableSupportedObjectsMap.put('CloudingoAgent__SearchFilter__c', 'SearchFilter');
        availableSupportedObjectsMap.put('Section_Manager__c', 'Section Manager');
        availableSupportedObjectsMap.put('mkto_si__ScoringCache__c', 'ScoringCache');
        availableSupportedObjectsMap.put('SocialPost', 'Social Post');
        availableSupportedObjectsMap.put('Specialist__c', 'Specialist');
        availableSupportedObjectsMap.put('rkpi2__State__c', 'State');
        availableSupportedObjectsMap.put('WorkThanks', 'Thanks');
        availableSupportedObjectsMap.put('UserServicePresence', 'User Presence');
        availableSupportedObjectsMap.put('mkto_si__Value__c', 'Value');
        availableSupportedObjectsMap.put('mkto_si__WebActivityCache__c', 'WebActivityCache'); */ 
    }
    
    public pageReference SearchQueList1(){
        if(String.isEmpty(SearchQue1)){
            QueTable=false;
            editblk=false;
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Error, 'Please enter search text') );
        }
        else{
            QueTable=true;
            editblk=false;
            initializeCollections();
            QueGroupList('%' + SearchQue1 + '%');
            if(GroupNameList.size()<=0){
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Info, 'No queue found') );
                QueTable=false;
                editblk=false;
            }
        }
        return null;
    }
    private void QueGroupList(String SearchTxt)
    {
        GroupNameList = new List<Group>();
        GroupNameList = [select Id, Name,Email,DoesSendEmailToMembers,QueueRoutingConfigId  from Group where Type = 'Queue' and Name like:SearchTxt 
                         and id in (select queueid from QueueSObject where SobjectType  IN ('Lead','LiveChatTranscript'))
                         Order by Name Asc];
        
    }
    
    public pageReference EditQue()
    {
        selectedSObjects = new List<String>();
        removeSObjects = new List<String>();
        selectedUsr = new List<String>();
        removeUsers = new List<String>();
        availableUsersMap = new Map<id, String>();
        selectedUsersMap = new Map<id, String>();
        QueTable=false;
        editblk=true;
        Queid= ApexPages.currentPage().getParameters().get('EditId');
        EditQueName=ApexPages.currentPage().getParameters().get('EditName'); 
        EditQueEmail=ApexPages.currentPage().getParameters().get('EditEmail');
        EditQueEmailToMem=ApexPages.currentPage().getParameters().get('EditMemTo');
        for(Group g: GroupNameList){
            if(g.id == Queid){
                queueLookUp.QueueRoutingConfigId = g.QueueRoutingConfigId;
            }
        }
        SupportedObjects();
        getSObjs();
        getUsers();
        return null;
    }
    
  
    public void addSupportedObjects() {
        if (!selectedSObjects.isEmpty()) {
            for (String sobj : selectedSObjects){
                selectedSupportedObjectsMap.put(sobj, availableSupportedObjectsMap.get(sobj));
                availableSupportedObjectsMap.remove(sobj);
                if(removedSobjs.contains(sobj)){
                    removedSobjs.remove(sobj);
                }
            }
        }
    }

    public void removeSupportedObjects() {
        if (!removeSObjects.isEmpty()) {
            for (String sobj : removeSObjects){
                availableSupportedObjectsMap.put(sobj, selectedSupportedObjectsMap.get(sobj));
                selectedSupportedObjectsMap.remove(sobj);
                removedSobjs.add(sobj);
            }
        }
    }  
    
    public List<SelectOption> getAvailableSupportedObjects() {
        List<SelectOption> availableSObjects = new List<SelectOption>();
        for (String sobj : availableSupportedObjectsMap.keySet()){
            availableSObjects.add(new SelectOption(sobj, availableSupportedObjectsMap.get(sobj)));
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
            }
        }
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
    
    public void initializeCollections() {
        selectedUsr= New List<string>();
        removeUsers= New List<string>();
        
    }
    
    public PageReference UpdateList() {
        return null;
    }
   
    
    public void getSObjs(){
        if(Queid!=null){
             selectSobj = new List<QueueSObject>(); 
        removedSobjs = new set<string>();
        addedSobjs = new set<string>();
            selectSobj = [Select SobjectType ,id from QueueSObject where queueid =: Queid];
        
        if(!selectSobj.isEmpty()){
            for(QueueSobject qso : selectSobj){
                selectedSObjects.add(qso.SobjectType);
            }  
            addSupportedObjects();
        }
    }
    }
    
    public void getUsers(){
        String temp = Label.ProfileIdQueueMangement;
        List<String> profileIds = temp.split(',');
        if(Queid!=null){
         selectusr = new List<GroupMember>(); 
        removedusrs = new set<string>();
        addedusrs = new set<string>();
            selectusr = [Select UserOrGroupId From GroupMember where GroupId =:Queid] ;
            set<id> gids =new set<id>();
        
        if(!selectusr.isEmpty()){
            
            for(GroupMember g: selectusr){
                gids.add(g.UserOrGroupId);
            }
            list<user> urs = [SELECT id, Name FROM User where IsActive = true AND id NOT IN:gids AND ProfileId IN:profileIds order by Name Asc];
            system.debug(urs);
            for(user u : urs){
                availableUsersMap.put(u.Id, u.Name);
            }
            list<user> urss = [SELECT id, Name FROM User where IsActive = true AND id IN:gids AND ProfileId IN:profileIds order by Name Asc];
            system.debug(urss);
            for(user ur : urss){
                selectedUsersMap.put(ur.Id, ur.Name);
            } 
            //selectedSObjects.add('Lead');  
            addUsers();
        } 
        else{
        list<user> urs = [SELECT id, Name FROM User where IsActive = true AND ProfileId IN:profileIds order by Name Asc];
            system.debug(urs);
            for(user u : urs){
                availableUsersMap.put(u.Id, u.Name);
            }}   
        }
    }
    
     public pageReference DeleteQue(){
        
        QueTable=true;
        editblk=false;
        Queid= ApexPages.currentPage().getParameters().get('DelId');
        
        List<Lead> LeadswithQue=[Select id from Lead where ownerid=:Queid ];
        if(LeadswithQue.size()>0){
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Error,System.Label.QueueDeleteError) );
        }
        else{
            List<GroupMember> ActiveMems = [SELECT UserOrGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND GroupId =:Queid ];
            if(ActiveMems.size()>0){
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Error,System.Label.QueueMemberDeleteError) );
            }
            else{
                Group g = [SELECT Id, Name FROM Group Where id =: Queid];
                try{
                    delete g;
                    ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Queue deleted successfully') );
                    initializeCollections();
                    QueGroupList('%' + SearchQue1 + '%');
                    
                    if(GroupNameList.size()>0){
                        QueTable=true;
                        editblk=false;
                    }
                    else{
                        QueTable=false;
                        editblk=false;
                    }
                }
                catch (DMLException e){
                    ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.Error, e.getMessage()) );
                }
            }
        }
        return null;    
    }
    
    public PageReference save(){
    
        if(string.isEmpty(EditQueName)){
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Error,'Queue name is required') );
        }
        else{
            Group g = [SELECT Id, Name FROM Group Where id =: Queid];
            g.Name=EditQueName;
            g.Email=EditQueEmail;
            g.DoesSendEmailToMembers=Boolean.valueOf(EditQueEmailToMem);
            if(selectedSupportedObjectsMap.keyset().contains('Lead'))
            g.QueueRoutingConfigId = [select id from QueueRoutingConfig where developername =: 'Lead_Routing'].id;
            else if(selectedSupportedObjectsMap.keyset().contains('LiveChatTranscript'))
            g.QueueRoutingConfigId = [select id from QueueRoutingConfig where developername =: 'Chat_Routing'].id;
            try{
                Update g;
                QueTable=true;
                editblk=false;
                initializeCollections();
                if(!removedSobjs.isEmpty()){
                    delete [select id from QueueSobject where Queueid =: queid and Sobjecttype in: removedSobjs ];
                }
                if(!selectedSupportedObjectsMap.keyset().isEmpty()){
                    qobjtoadd = new list<queueSobject>();
                    for(String type : selectedSupportedObjectsMap.keyset()){
                            QueueSObject q = new QueueSObject(SobjectType=type, QueueId=queId);
                            qobjtoadd.add(q);
                        }
                        insert qobjtoadd;
                }
                if(!removedusrs.isEmpty()){
                    delete [select id from GroupMember where Groupid =: queid and UserOrGroupId in: removedusrs];
                }
                if(!selectedUsersMap.keyset().isEmpty()){
                    usrtoadd = new list<GroupMember>();
                    for(String type : selectedUsersMap.keyset()){
                            GroupMember gm = new GroupMember(UserOrGroupId=type, GroupId=queId);
                            usrtoadd.add(gm);
                        }
                        insert usrtoadd;
                }   
                QueGroupList('%' + SearchQue1 + '%');
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.CONFIRM,'Queue updated successfully') );
            }
            catch (DMLException e){
                ApexPages.addMessage( new ApexPages.Message(ApexPages.severity.Error, e.getMessage()) );
            }
        }
                 
        return null;
    }
    
    public PageReference cancel(){
        initializeCollections();
        Updatelist();
        QueTable=true;
        editblk=false;        
        return null;
    }
}