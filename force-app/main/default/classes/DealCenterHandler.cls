/**********************************************************************************

Author: Pradeep Guttha
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the trigger.

**********************************************************************************/

public class DealCenterHandler implements TriggerInterface
{
  public static boolean firstTgrRun = true;
        
    public Boolean isActive()
    {
        return Trigger_Manager__c.getInstance('DealCenterTgr').Is_Active__c;
    }
 
    public void beforeInsert() {}
 
    public void beforeUpdate() {}
    
    public void beforeDelete() {}
 
    public void afterInsert()  {}
 
    public void afterUpdate() {}
 
    public void afterDelete() {
        List<Deal_Center_Request__c> DealCenterList = (List<Deal_Center_Request__c>)Trigger.old;
        DeleteUndeleteTriggerHandler.DeleteUndelete(DealCenterList, 'Deal_Center_Request__c');
    }
    
    public void afterUndelete() {}
    
}