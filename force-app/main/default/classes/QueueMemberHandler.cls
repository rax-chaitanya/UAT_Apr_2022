/**********************************************************************************

Author: Vinod Thupakula
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the trigger.

**********************************************************************************/
public class QueueMemberHandler implements TriggerInterface{
    public Boolean isActive()
    {
        if(Trigger_Manager__c.getAll().containsKey('QueueMemberTgr')) {
            return Trigger_Manager__c.getInstance('QueueMemberTgr').Is_Active__c;
        }
        return false;
    }
    
    public void beforeInsert() 
    {
        QueueMemberHelper.assignRanks();
    }
    
    public void beforeUpdate(){}
    
    public void beforeDelete(){}
    
    public void afterInsert(){}
    
    public void afterUpdate(){}
    
    public void afterDelete()
    {
      QueueMemberHelper.ReassignRanks(); 
    }
    
    public void afterUndelete(){}
}