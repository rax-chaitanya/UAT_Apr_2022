/**********************************************************************************

Author: Shantan Nagulapalli
Description: Trigger on Opportunity Team Member which will call the OpportunityTeamMemHandler using the TriggerRouter 
on the following events: before insert, before update, before delete, after insert, after update,
 after delete, after undelete.

**********************************************************************************/

trigger OpportunityTeamMemberTgr on OpportunityTeamMember (before insert, before update, before delete,
                              after insert, after update, after delete, after undelete) 
{
    TriggerRouter.handler(new OpportunityTeamMemberHandler());
}