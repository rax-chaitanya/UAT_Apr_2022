public class RVMemberHandler implements TriggerInterface{
    
  
    public Boolean isActive()
    {
        if(Trigger_Manager__c.getAll().containsKey('RVMemberTgr')) {
            return Trigger_Manager__c.getInstance('RVMemberTgr').Is_Active__c;
        }
        return false;
    }
    
    public void beforeInsert() {
        
   /* if((Sf2SfIntegrationHelper.isPartnerShared() || Test.isRunningTest()) && ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS){
                Sf2SfIntegrationHelper.populateLookupFields(Trigger.new,Trigger.new[0].getsObjectType().getDescribe().getName());
                ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = false;
            }*/
    }
    
    public void beforeUpdate() {
       
     /*       if((Sf2SfIntegrationHelper.isPartnerShared() || Test.isRunningTest()) && ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS){
                Sf2SfIntegrationHelper.populateLookupFields(Trigger.new,Trigger.new[0].getsObjectType().getDescribe().getName());
                ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = false;
            }*/
    }
    
    public void beforeDelete() {}
    
    public void afterInsert()  {
        /*if(Sf2SfIntegrationHelper.isPartnerShared() || Test.isRunningTest()){
          Sf2SfIntegrationHelper.updateRecordsToGetIds(Trigger.newmap.keySet(),Trigger.new[0].getsObjectType().getDescribe().getName());  
        }
        
        if(!Sf2SfIntegrationHelper.isPartnerShared() || Test.isRunningTest()){
            Sf2SfIntegrationHelper.publishRecords(Trigger.new); 
            
        }*/
    }
    
    public void afterUpdate() {
      
    }
    
    public void afterDelete() {
        
    }
    
    public void afterUndelete() {}

}