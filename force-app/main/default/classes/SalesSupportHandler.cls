/**********************************************************************************

Author: Pradeep Guttha
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the trigger.

**********************************************************************************/

public class SalesSupportHandler implements TriggerInterface
{
  public static boolean firstTgrRun = true;
        
    public Boolean isActive()
    {
        return Trigger_Manager__c.getInstance('SalesSupportTgr').Is_Active__c;
    }
 
    public void beforeInsert() 
    {
    }
 
    public void beforeUpdate() {}
    
    public void beforeDelete() {}
 
    public void afterInsert()  {}
 
    public void afterUpdate() {}
 
    public void afterDelete() {
        List<Sales_Support_Portfolio__c> SalesSupportList = (List<Sales_Support_Portfolio__c>)Trigger.old;
        DeleteUndeleteTriggerHandler.DeleteUndelete(SalesSupportList, 'Sales_Support_Portfolio__c');
    }
    
    public void afterUndelete() {}
    
}