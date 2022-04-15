/**********************************************************************************

Author: Pradeep Guttha
Description: Trigger on Partner Role which will call the PartnerRoleHandler using the TriggerRouter 
on the following events: before insert, before update, before delete, after insert, after update,
 after delete, after undelete.

**********************************************************************************/
trigger PartnerRoleTrigger on Partner_Role__c (before insert, before update, before delete,
                              after insert, after update, after delete, after undelete) 
{
    TriggerRouter.handler(new PartnerRoleHandler());    
}