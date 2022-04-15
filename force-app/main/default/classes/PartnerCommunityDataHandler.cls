/**********************************************************************************
Author:Ashok Cherapalli
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the trigger.
**********************************************************************************/
public class PartnerCommunityDataHandler implements TriggerInterface {
    public Boolean isActive()
    {
        if(Trigger_Manager__c.getAll().containsKey('PartnerCommunityDataTgr')) {
            return Trigger_Manager__c.getInstance('PartnerCommunityDataTgr').Is_Active__c;
        }
        return false;
    }
    
    public void beforeInsert() {
        PartnerCommunityDataHelper.PartnerCommunityDataValidation();
    }
    
    public void beforeUpdate() {
        PartnerCommunityDataHelper.PartnerCommunityDataValidation();
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