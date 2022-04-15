/**********************************************************************************

Author: Pradeep Guttha
Description: Trigger on SalesSupportPortfolio which will call the SalesSupportHandler using the TriggerRouter 
on the following events: before insert, before update, before delete, after insert, after update,
 after delete, after undelete.

**********************************************************************************/
trigger SalesSupportTrigger on Sales_Support_Portfolio__c (before insert, before update, before delete,
                              after insert, after update, after delete, after undelete) 
{
    TriggerRouter.handler(new SalesSupportHandler());    
}