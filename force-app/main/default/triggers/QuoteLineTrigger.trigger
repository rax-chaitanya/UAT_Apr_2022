/**********************************************************************************

Author: Pradeep Guttha
Description: Trigger on QuoteLine which will call the QuoteLineHandler using the TriggerRouter 
on the following events: before insert, before update, before delete, after insert, after update,
 after delete, after undelete.

**********************************************************************************/
trigger QuoteLineTrigger on Quote_Line__c (before insert, before update, before delete,
                              after insert, after update, after delete, after undelete) 
{
    TriggerRouter.handler(new QuoteLineHandler());    
}