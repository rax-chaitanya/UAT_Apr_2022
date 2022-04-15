/**********************************************************************************

Author: Pradeep Guttha
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the trigger.

**********************************************************************************/

public class OppCompHandler implements TriggerInterface
{
  public static boolean firstTgrRun = true;
        
    public Boolean isActive()
    {
        return Trigger_Manager__c.getInstance('OppCompTgr').Is_Active__c;
    }
 
    public void beforeInsert() {}
 
    public void beforeUpdate() {}
    
    public void beforeDelete() {}
 
    public void afterInsert()  {}
 
    public void afterUpdate() {}
 
    public void afterDelete() {
        List<Opportunity_Competitor__c> OppCompList = (List<Opportunity_Competitor__c>)Trigger.old;
        DeleteUndeleteTriggerHandler.DeleteUndelete(OppCompList, 'Opportunity_Competitor__c');
    }
    
    public void afterUndelete() {}
    
}