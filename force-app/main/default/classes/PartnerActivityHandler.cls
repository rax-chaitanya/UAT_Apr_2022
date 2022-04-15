/**********************************************************************************

Author: Thirupathi Aeneni/Omkar Narkar
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the trigger.

**********************************************************************************/
public class PartnerActivityHandler implements TriggerInterface {
    public Boolean isActive()
    {
        if(Trigger_Manager__c.getAll().containsKey('PartnerActivityTgr')) {
            return Trigger_Manager__c.getInstance('PartnerActivityTgr').Is_Active__c;
        }
        return false;
    }
    
    public void beforeInsert() {
        PartnerActivityHelper.mapCommunityContent();
        PartnerActivityHelper.awardGamificationPoints();
    }
    
    public void beforeUpdate() {
    }
    
    public void beforeDelete() {
    }
    
    public void afterInsert()  {
        
    }
    
    public void afterUpdate() {
                
    }
    
    public void afterDelete() {
        
    }
    
    public void afterUndelete() {
    } 
    
}