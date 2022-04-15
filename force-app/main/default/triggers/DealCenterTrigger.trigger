/**********************************************************************************

Author: Pradeep Guttha
Description: Trigger on Deal Center Request which will call the DealCenterHandler using the TriggerRouter 
on the following events: before insert, before update, before delete, after insert, after update,
 after delete, after undelete.

**********************************************************************************/
trigger DealCenterTrigger on Deal_Center_Request__c (before insert, before update, before delete,
                              after insert, after update, after delete, after undelete) 
{
    TriggerRouter.handler(new DealCenterHandler());    
}