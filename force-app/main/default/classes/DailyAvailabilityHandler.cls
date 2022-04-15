/*
* Author : RDC, Vinod Thupakula
* Description : Populating count and Time duration of availability/Unavailability of a user from Live Transfer(SFDC-3287)
* Created Date : 6/June/2019 
* 
*/
public class DailyAvailabilityHandler implements TriggerInterface{   
    
    public static Boolean IS_TRIGGER_ENABLED = true;
    public Boolean isActive()
    {
        if(Trigger_Manager__c.getAll().containsKey('DailyAvailabilityTgr')) {
            return Trigger_Manager__c.getInstance('DailyAvailabilityTgr').Is_Active__c;
        }
        return false;
    }  
    public void beforeInsert() {}
    public void beforeUpdate() {}
    public void beforeDelete() {}
    public void afterInsert()  {}
    public void afterUpdate() {
        if(IS_TRIGGER_ENABLED)
        DailyAvailabiltyHelper.afterUpdate(Trigger.newMap.keySet());
    }
    public void afterDelete() {}   
    public void afterUndelete() {}  
}