/**********************************************************************************

Author: Pradeep Guttha
Description: Trigger on Contact which will call the ContactHandler using the TriggerRouter 
on the following events: before insert, before update, before delete, after insert, after update,
 after delete, after undelete.

**********************************************************************************/
trigger ContactTrigger on Contact (before insert, before update, before delete,
                              after insert, after update, after delete, after undelete) 
{
    TriggerRouter.handler(new ContactHandler());
}