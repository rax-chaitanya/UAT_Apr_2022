/**********************************************************************************

Author: D Anjaneyulu
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the RVCompensation trigger.

**********************************************************************************/

public class RVCompensationHandler implements TriggerInterface{
    
  
    public Boolean isActive()
    {
        if(Trigger_Manager__c.getAll().containsKey('RVCompensationTgr')) {
            return Trigger_Manager__c.getInstance('RVCompensationTgr').Is_Active__c;
        }
        return false;
    }
    
    public void beforeInsert() {
    }
    
    public void beforeUpdate() {
       
    }
    
    public void beforeDelete() {}
    
    public void afterInsert()  {
      /*  List<RV_Compensation__c> shareableRVCompensations = new List<RV_Compensation__c>();
        for(sObject rc1 : Trigger.new){
            RV_Compensation__c rc = (RV_Compensation__c)rc1;
            if(rc.is_Parent_Shared__c)
                shareableRVCompensations.add(rc);
        }
         Sf2SfIntegrationHelper.publishChildRecordsWithParent(shareableRVCompensations,Trigger.new[0].getsObjectType().getDescribe().getName());*/
        }
 
    
    public void afterUpdate() {
      
    }
    
    public void afterDelete() {
        
    }
    
    public void afterUndelete() {}
}