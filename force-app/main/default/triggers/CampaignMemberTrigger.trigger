/**********************************************************************************

Author: Shantan Nagulapalli
Description: Trigger on Campaign Member which will call the CampaignMember Handler using the TriggerRouter 
on the following events: before insert, before update, before delete, after insert, after update,
 after delete, after undelete.

**********************************************************************************/
trigger CampaignMemberTrigger on CampaignMember (before insert, before update, before delete,
                              after insert, after update, after delete, after undelete) 
{
    TriggerRouter.handler(new CampaignMemberHandler());
}