/**********************************************************************************

Author: Pradeep Guttha
Description: Trigger on Opportunity Competitor which will call the OppCompHandler using the TriggerRouter 
on the following events: before insert, before update, before delete, after insert, after update,
 after delete, after undelete.

**********************************************************************************/
trigger OppCompTrigger on Opportunity_Competitor__c (before insert, before update, before delete,
                              after insert, after update, after delete, after undelete) 
{
    TriggerRouter.handler(new OppCompHandler());    
}