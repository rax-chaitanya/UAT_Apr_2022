/**********************************************************************************

Author: Thirupathi Aeneni/Omkar Narkar
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the trigger.

**********************************************************************************/
public class NetworkMemberHandler implements TriggerInterface{
    public static Boolean IS_TRIGGER_ENABLED = true;
    public Boolean isActive()
    {
        if(Trigger_Manager__c.getAll().containsKey('NetworkMemberTrigger') && IS_TRIGGER_ENABLED) {
            return Trigger_Manager__c.getInstance('NetworkMemberTrigger').Is_Active__c;
        }
        return false;
    }
    
    public void beforeInsert() {
        
    }
    
    public void beforeUpdate() {
        
    }
    
    public void beforeDelete() {
        
    }
    
    public void afterInsert()  {
    }
    
    public void afterUpdate() {
        NetworkMemberHelper.syncNetworkMember();
    }
    
    public void afterDelete() {
        
    }
    
    public void afterUndelete() {
    }   
}