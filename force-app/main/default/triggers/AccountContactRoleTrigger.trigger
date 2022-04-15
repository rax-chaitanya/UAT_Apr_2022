/**********************************************************************************

Author: Pradeep Guttha
Description: Trigger on AccountContactRole which will call the AccountContactRole Handler using the TriggerRouter 
on the following events: before insert, before update, before delete, after insert, after update,
 after delete, after undelete.

**********************************************************************************/
trigger AccountContactRoleTrigger on Account_Contact_Role__c (before insert, before update, before delete,
                              after insert, after update, after delete, after undelete) 
{
    TriggerRouter.handler(new AccountContactRoleHandler());
}