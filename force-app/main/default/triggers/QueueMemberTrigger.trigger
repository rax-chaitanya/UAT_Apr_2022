/**********************************************************************************

Author: Vinod Thupakula
Description: Trigger on Queue_Member__c which will call the QueueMemberHandler using the TriggerRouter 
on the following events: before insert, before update, before delete, after insert, after update,
after delete, after undelete.

**********************************************************************************/
trigger QueueMemberTrigger on Queue_Member__c (before insert, before update, before delete,
                                               after insert, after update, after delete, after undelete) 
{
    TriggerRouter.handler(new QueueMemberHandler());
}