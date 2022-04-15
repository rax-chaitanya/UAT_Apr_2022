/**********************************************************************************

Author: D Anjaneyulu
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the RVAccount trigger.

**********************************************************************************/

public class RVAccountHandler implements TriggerInterface{

    public Boolean isActive()
    {
        if(Trigger_Manager__c.getAll().containsKey('RVAccountTgr')) {
            return Trigger_Manager__c.getInstance('RVAccountTgr').Is_Active__c;
        }
        return false;
    }
    
    public void beforeInsert() {
        
    /*if((Sf2SfIntegrationHelper.isPartnerShared() || Test.isRunningTest()) && ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS){
                Sf2SfIntegrationHelper.populateLookupFields(Trigger.new,Trigger.new[0].getsObjectType().getDescribe().getName());
                ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = false;
            }*/
    }
    
    public void beforeUpdate() {
       
         /*   if((Sf2SfIntegrationHelper.isPartnerShared() || Test.isRunningTest()) && ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS){
                Sf2SfIntegrationHelper.populateLookupFields(Trigger.new,Trigger.new[0].getsObjectType().getDescribe().getName());
                ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = false;
            }*/
    }
    
    public void beforeDelete() {}
    
    public void afterInsert()  {
        
    }
    
    public void afterUpdate() {
       
    }
    
    public void afterDelete() {
        
    }
    
    public void afterUndelete() {}

}