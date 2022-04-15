/**********************************************************************************

Author: Venkat
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the trigger.

**********************************************************************************/

public class SpecialistHandler implements TriggerInterface
{
  public static boolean firstTgrRun = true;
        
    public Boolean isActive()
    {
      if(Trigger_Manager__c.getAll().containsKey('SpecialistTgr')) {
          return Trigger_Manager__c.getInstance('SpecialistTgr').Is_Active__c;
      }
      return false;
    }
 
    public void beforeInsert() {
     // if((Sf2SfIntegrationHelper.isPartnerShared() || Test.isRunningTest()) && ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS) {
      //  Sf2SfIntegrationHelper.populateLookupFields(Trigger.new,Trigger.new[0].getsObjectType().getDescribe().getName());
        //    ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = false;
      //}
     
    }
 
    public void beforeUpdate() {
      //if((Sf2SfIntegrationHelper.isPartnerShared() || Test.isRunningTest()) && ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS) {
        // Sf2SfIntegrationHelper.populateLookupFields(Trigger.new,Trigger.new[0].getsObjectType().getDescribe().getName());
          //  ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = false;
      //}
   
    }
    
    public void beforeDelete() {}
 
    public void afterInsert()  {
     // if(Sf2SfIntegrationHelper.isPartnerShared() || Test.isRunningTest()) {
      // Sf2SfIntegrationHelper.updateRecordsToGetIds(Trigger.newmap.keySet(),Trigger.new[0].getsObjectType().getDescribe().getName()); 
      //}
      //if(!Sf2SfIntegrationHelper.isPartnerShared()){
        //Sf2SfIntegrationHelper.publishRecords(Trigger.new); 
      //}
     
    }
 
    public void afterUpdate() {
      
    }
 
    public void afterDelete() {
		
        List<Specialist__c> SpecialistList = (List<Specialist__c>)Trigger.old;
        DeleteUndeleteTriggerHandler.DeleteUndelete(SpecialistList, 'Specialist__c');
        
         
    }
    
    public void afterUndelete() {}
    
}