/*
###########################################################################
# File..................: UserHandler.cls
# Version...............: 1.0
# Created by............: Kartikeya Tewari (RDC)
# Created Date..........: 12-Apr-2017
# Description...........: This apex class is created for the Trigger Framework,
#                           it controls the flow of execution of the User trigger.
*/
public class UserHandler implements TriggerInterface
{
    public Boolean isActive() {
        if(Trigger_Manager__c.getAll().containsKey('UserTrigger')) {
            return Trigger_Manager__c.getInstance('UserTrigger').Is_Active__c;
        }
        return false;
    }
    
    public void beforeInsert() {
        try {
            UserTriggerHelper.populateSSOFromFederation((List<User>)Trigger.new);
        }
        catch(Exception e) {
            ExceptionHandler.postToAll(e);
            throw new CustomException(ExceptionHandler.getBody(e));
        }
    }
    
    public void beforeUpdate() {
        try {
            UserTriggerHelper.populateSSOFromFederation((List<User>)Trigger.new);
        }
        catch (Exception e) {
            ExceptionHandler.postToAll(e);
            throw new CustomException(ExceptionHandler.getBody(e));
        }
    }
    
    public void beforeDelete() {
        //do nothing
    }
    
    public void afterInsert() {
        List<User> partnerUser = new List<User>();
        for(User u : (List<User>)Trigger.new){
            if(System.Label.Partner_Profiles.contains(u.ProfileId) && String.isNotBlank(u.AccountId) && u.isActive){
                partnerUser.add(u);  
            } 
        }
        if(!partnerUser.isEmpty()){
            CommunitySharingHelper.shareRecordsOnUserCreation(partnerUser);
        }
        
    }
    
    public void afterDelete() {
        //do nothing
    }
    
    public void afterUndelete() {
        //do nothing
    }
    
    public void afterUpdate() {
        //Added by Saswati :SFDC-3576
        usertriggerhelper.removeUserFromPackage();
        //added by Sundarayya e for SFDC-6013
        UserTriggerHelper.updateContactRecordTypePSA();
    }
}