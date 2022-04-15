/**********************************************************************************

Author: Shantan Nagulapalli
Description: Trigger on Opportunity Focus Area which will call the Opportunity Focus Area Handler using the TriggerRouter 
on the following events: before insert, before update, before delete, after insert, after update,
 after delete, after undelete.

**********************************************************************************/

trigger OpportunityFocusArea on Opp_FocusArea__c (before insert, before update, before delete,
                              after insert, after update, after delete, after undelete) 
{
    TriggerRouter.handler(new OpportunityFocusAreaHandler());
}