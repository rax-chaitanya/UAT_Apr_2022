/**
* File : LiveTransferClass.cls
* Description : Methods used by Lead Assignment Lightning Component (SFDC-1880: Lead - Round Robin)
* Created Date : 23/APR/2018
* @author : RDC (Abhilash/Vivek/Thirupathi Aeneni)
*/
public without sharing class LiveTransferClass {
    
    private static integer Listsize=1;  
    
    @AuraEnabled
    public static List<EachUser> getUsers(String groupID, integer counter) {
        List<EachUser> usersList = new List<EachUser>();
        Set<Id> activeUsersIds = new Set<Id>();
        
        if(String.isNotBlank(groupID)) {
            Set<Id> grpMembs = new Set<Id>();
            Set<Id> presUsers = new Set<Id>(); 
            
            for(Queue_Member__c gp : [SELECT Id, Member__c, Queue__c FROM Queue_Member__c where Queue__c = :groupID AND  Active_Member__c = True]) {
                grpMembs.add(gp.Id);
                presUsers.add(gp.Member__c);
            }    
            
            
            if(!presUsers.isEmpty()) {
                for(Live_Transfer_Availability__c eachTransfer : [Select id, Live_Transfer_Member__c, Live_Transfer_Member__r.name, Live_Transfer_Member__r.Email, Live_Transfer_Member__r.Phone  from Live_Transfer_Availability__c where Live_Transfer_Member__c IN :presUsers and Available__c = True]){
                    activeUsersIds.add(eachTransfer.Live_Transfer_Member__c);
                }
            }
            if(!activeUsersIds.isEmpty()){
                for(Queue_Member__c usp : [SELECT Id, Total_Count__c, Member__c, Queue__c, Member__r.name, Member__r.Email, Member__r.Phone FROM Queue_Member__c where Queue__c = :groupID AND  Active_Member__c = True AND Member__c IN: activeUsersIds ORDER BY Total_Count__c, Member__r.Name ASC ] ) {
                    usersList.add(new EachUser(usp.Member__c, usp.Member__r.name, usp.Member__r.Email, usp.Member__r.Phone));
                }
            }
            
        }
        return usersList;
    }
    
    @AuraEnabled
    public static Boolean updateOwner(String LeadID, String UserID, String queueId) {
        
        Lead ld = new Lead(id=LeadID);
        ld.OwnerId = UserID;
        ld.Original_Queue__c=queueId;
        ld.Lead_Board__c=queueId;
        try {
            Database.SaveResult updateRes = Database.update(ld);
            if(updateRes.isSuccess()){
                Queue_Member__c  currentMem = [select id, Counter__c, Live_Transfer_Count__c from Queue_Member__c where Member__c=:UserID AND Queue__c=:queueId limit 1];
                if(currentMem != null){
                    currentMem.Counter__c = (currentMem.Counter__c!=null)?currentMem.Counter__c+1:1;
                    currentMem.Live_Transfer_Count__c = (currentMem.Live_Transfer_Count__c!=null)?currentMem.Live_Transfer_Count__c+1:1;
                    update currentMem;
                }          
            }    
        } catch(DMLexception e) {
            
            throw new AuraHandledException(e.getDmlMessage(0));
        }
        
        return true;
    }  
    @AuraEnabled
    public static Boolean updateUserStatus(String userId) {
        Live_Transfer_Availability__c lta = [SELECT Id, Available__c, Live_Transfer_Member__c FROM Live_Transfer_Availability__c WHERE Live_Transfer_Member__c=:userId LIMIT 1];
        Live_Transfer_Availability__c updateLTA = new Live_Transfer_Availability__c(
            Id = lta.Id,
            Available__c = false
        );
        try{
            update updateLTA;
        }catch(DMLexception e) {
            throw new AuraHandledException(e.getDmlMessage(0));
        }
        return true;
    }
    
    public class EachUser{
        @AuraEnabled  public Id userId;
        @AuraEnabled  Public String name;
        @AuraEnabled  Public String email;
        @AuraEnabled  Public String phone;
        public EachUser(Id userId, String name, String email, String phone){
            this.userId = userId;
            this.name = name;
            this.email = email;
            this.phone = phone;
        }
    }
}