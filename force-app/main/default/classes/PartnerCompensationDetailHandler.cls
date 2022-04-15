public class PartnerCompensationDetailHandler implements TriggerInterface{
    
  
    public Boolean isActive()
    {
        if(Trigger_Manager__c.getAll().containsKey('RVCompensationDetailTgr')) {
            return Trigger_Manager__c.getInstance('RVCompensationDetailTgr').Is_Active__c;
        }
        return false;
    }
    
    public void beforeInsert() {
  /*      
    if((Sf2SfIntegrationHelper.isPartnerShared() || Test.isRunningTest()) && ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS){
                Sf2SfIntegrationHelper.populateLookupFields(Trigger.new,Trigger.new[0].getsObjectType().getDescribe().getName());
                ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = false;
            }*/
    }
    
    public void beforeUpdate() {
/*       
            if((Sf2SfIntegrationHelper.isPartnerShared() || Test.isRunningTest()) && ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS){
                Sf2SfIntegrationHelper.populateLookupFields(Trigger.new,Trigger.new[0].getsObjectType().getDescribe().getName());
                ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = false;
            }*/
    }
    
    public void beforeDelete() {
        
    }
    
    public void afterInsert()  {
     /*   if(Sf2SfIntegrationHelper.isPartnerShared() || Test.isRunningTest()){
          Sf2SfIntegrationHelper.updateRecordsToGetIds(Trigger.newmap.keySet(),Trigger.new[0].getsObjectType().getDescribe().getName());  
        }
        
        if(!Sf2SfIntegrationHelper.isPartnerShared() || Test.isRunningTest()){
            if(Trigger.isInsert && Trigger.isAfter){
            List<RV_Compensation_Detail__c> shareableRVCompensationsDetails = new List<RV_Compensation_Detail__c>();
           for(sObject rcd1 : Trigger.new){
               RV_Compensation_Detail__c rcd = (RV_Compensation_Detail__c)rcd1;
                if(rcd.Is_RV_Account_Shared__c)
                    shareableRVCompensationsDetails.add(rcd);
            }
            Sf2SfIntegrationHelper.publishChildRecordsWithParent(shareableRVCompensationsDetails,Trigger.new[0].getsObjectType().getDescribe().getName());   
        }      
            
        }*/
    }
    
    public void afterUpdate() {
      
    }
    
    public void afterDelete() {
        
    }
    
    public void afterUndelete() {}
}