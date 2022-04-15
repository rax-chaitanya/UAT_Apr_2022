/**********************************************************************************

Author: Mohan P K
Description: This interface is created for the Trigger Framework. Methods below 
are the posssible events of a trigger in salesforce.com

**********************************************************************************/
public interface TriggerInterface
{
    void beforeInsert();
 
    void beforeUpdate();
 
    void beforeDelete();
 
    void afterInsert();
 
    void afterUpdate();
 
    void afterDelete();
 
    void afterUndelete();
    
    boolean isActive();         
}