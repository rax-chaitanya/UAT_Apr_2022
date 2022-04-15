public class GenericConsoleMethodController {
    /* @AuraEnabled
public static Boolean accessQuikrPage(String getvalues){
Set<Id> permissionSetIds = new Set<Id>();
for (SetupEntityAccess access : [  
SELECT ParentId 
FROM SetupEntityAccess 
WHERE SetupEntityId IN (
SELECT Id 
FROM CustomPermission 
WHERE Id = '0CP61000000LF3O'
)
]) 
permissionSetIds.add(access.ParentId);

System.debug('Permission Sets'+permissionSetIds);
User usr = [SELECT Username FROM User WHERE  Id IN (
SELECT AssigneeId FROM PermissionSetAssignment
WHERE PermissionSetId IN :permissionSetIds)
and  Id = :UserInfo.getUserId()];
System.debug('u.username'+usr);
if(usr != null){
return true;
}
return false;
}


@AuraEnabled
public static Boolean accessRepChatSurveyPage(String getvalues){
Set<Id> permissionSetIds = new Set<Id>();
for (SetupEntityAccess access : [  
SELECT ParentId 
FROM SetupEntityAccess 
WHERE SetupEntityId IN (
SELECT Id 
FROM CustomPermission 
WHERE Id = '0CP61000000LF3P'
)
]) 
permissionSetIds.add(access.ParentId);

System.debug('Permission Sets'+permissionSetIds);
User usr = [SELECT Username FROM User WHERE  Id IN (
SELECT AssigneeId FROM PermissionSetAssignment
WHERE PermissionSetId IN :permissionSetIds)
and  Id = :UserInfo.getUserId()];
System.debug('u.username'+usr);  
if(usr != null){
return true;
}
return false;
}*/
    
    @AuraEnabled
    public static Boolean isRepChatPageAccessible() {
        try {
            String[] accessSurveyPerms = Label.Access_Rep_Chat_Survey.split(',');        
            //('0PS61000000A1FyGAK', '0PS61000000A1GDGA0', '0PS61000000S684GAC', '0PS61000000S685GAC', '0PS61000000S686GAC', '0PS61000000S687GAC', '0PS61000000Y1DTGA0')       
            return [Select COUNT() from PermissionSetAssignment Where AssigneeId = :UserInfo.getUserId() AND PermissionSetId in (Select ParentId from SetupEntityAccess Where SetupEntityId in :accessSurveyPerms)] > 0;
        } catch (Exception e) {
            ExceptionHandler.postToAll(e, false);
            return true;
        }
    }    
    
    @AuraEnabled
    public static Boolean checkChatEnd(String WorkItemID) {
        /*  For(LiveChatTranscript lct: [SELECT ChatKey,Id,Status FROM LiveChatTranscript WHERE Id = :WorkItemID limit 1]){
if(lct.Status == 'Completed'){
return true;
}   
}    
return false;*/
        List<AgentWork> aWork = new List<AgentWork>([SELECT Id, Status FROM AgentWork WHERE WorkItemId = :WorkItemID ORDER BY createdDate DESC LIMIT 1]);
        for(AgentWork w : aWork){
            if(w.status == 'Closed'){
                return true;
            }
        }
        return false;
    }
    
    @AuraEnabled
    public static String parseTabInfowrapper(String tabInfoResult, String WorkItemID) {
        system.debug('**Tab String'+tabInfoResult);
        system.debug('**Work item ID '+WorkItemID);
        List<tabInfoWrapperClass> twcList = (List<tabInfoWrapperClass>)JSON.deserialize(tabInfoResult, List<tabInfoWrapperClass>.class);
        system.debug('**Tab List'+twcList);
        for(tabInfoWrapperClass twc : twcList){
            if(twc.isSubtab == false && String.valueOf(twc.recordId).substring(0, 15) == WorkItemID){
                system.debug('**Work Item ID inside JSON '+twc.recordId);
                system.debug('**Tab ID'+twc.tabId);
                return twc.tabId;
            }
        }
        return null;
    }
    /***END CHAT CODE MERGE***/
    @AuraEnabled  
    public static String getWorkId(string workItemId){   
        String workId;
        try{
        AgentWork agentwork = [Select Id from AgentWork where workItemId = :workItemId];
        workId = String.valueOf(agentwork.Id).substring(0, 15);
        }catch (Exception e) {
            ExceptionHandler.postToAll(e, false);
        }
        return workId;          
    }
    /*** Finished of END CHAT CODE MERGE***/
    
    public class tabInfoWrapperClass{
        public String tabId;
        public String url;
        public Boolean pinned;
        public Boolean closeable;
        public String title;
        public String icon;
        public String iconAlt;
        public Boolean highlighted;
        public String recordId;
        public Boolean isSubtab;
        public String parentTabId;
        public Boolean focused;
        //public subtabs subtabs;
    }
    /*public class subtabs{
public String tabId;
public String url;
public Boolean pinned;
public Boolean closeable;
public String title;
public String icon;
public String iconAlt;
public Boolean highlighted;
public Boolean isSubtab;
public String parentTabId;
public Boolean focused;                
}*/    
}