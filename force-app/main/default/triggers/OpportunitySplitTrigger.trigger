/**********************************************************************************

Author: Pradeep Guttha
Description: Trigger on OpportunitySplit which will call the OpportunitySplitHandler using the TriggerRouter 
on the following events: before insert, before update, before delete, after insert, after update,
 after delete, after undelete.

**********************************************************************************/
trigger OpportunitySplitTrigger on OpportunitySplit (before insert, before update, before delete,
                              after insert, after update, after delete, after undelete) 
{
    TriggerRouter.handler(new OpportunitySplitHandler());    
}