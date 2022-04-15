/**********************************************************************************

Author: Pradeep Guttha
Description: Trigger on Opportunity which will call the OpportunityHandler using the TriggerRouter 
on the following events: before insert, before update, before delete, after insert, after update,
 after delete, after undelete.

**********************************************************************************/
trigger OpportunityTrigger on Opportunity (before insert, before update, before delete,
                              after insert, after update, after delete, after undelete) 
{
    TriggerRouter.handler(new OpportunityHandler());
}