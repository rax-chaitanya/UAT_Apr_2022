/**********************************************************************************

Author: Mohan P K
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the trigger.

**********************************************************************************/
public class ComponentManagerHandler implements TriggerInterface
{

    public static boolean firstTgrRun = true;
        
    public Boolean isActive()
    {
        return Trigger_Manager__c.getInstance('ComponentManagerTrigger').Is_Active__c;
    }
 
    public void beforeInsert() 
    {
    }
 
    public void beforeUpdate() {
    }
    
    public void beforeDelete() {
        throw new CustomException('Component records cannot be deleted. Please mark the IsActive__c field as false.');
    }
 
    public void afterInsert() {}
 
    public void afterUpdate() {}
 
    public void afterDelete() 
    {
    }
 
    public void afterUndelete() {}
    
}