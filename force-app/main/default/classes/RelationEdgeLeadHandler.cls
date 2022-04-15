/**********************************************************************************

Author: Raj
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the trigger.

**********************************************************************************/

public class RelationEdgeLeadHandler implements TriggerInterface
{
    public static boolean firstTgrRun = true;
        
    public Boolean isActive()
    {
        if(Trigger_Manager__c.getAll().containsKey('RelationEdgeLeadTrigger')) {
            return Trigger_Manager__c.getInstance('RelationEdgeLeadTrigger').Is_Active__c;
        }
        return false;
    }
 
    public void beforeInsert() {
        
    }
 
    public void beforeUpdate() {      
    }
    
    public void beforeDelete() {

    }
 
    public void afterInsert()  
    {
        RelationEdgeHelper.createRELead((Set<Id>)trigger.NewMap.KeySet());
    }
 
    public void afterUpdate() {
    }
 
    public void afterDelete() {

    }
    
    public void afterUndelete() {

    }    
}