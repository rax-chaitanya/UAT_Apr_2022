/**********************************************************************************

Author: Shantan Nagulapalli
Description: Trigger on Quote which will call the Quote Handler using the TriggerRouter 
on the following events: before insert, before update, before delete, after insert, after update,
 after delete, after undelete.

**********************************************************************************/
trigger QuoteTrigger on Quote__c (before insert, before update, before delete,
                              after insert, after update, after delete, after undelete) 
{
    TriggerRouter.handler(new QuoteHandler());
}