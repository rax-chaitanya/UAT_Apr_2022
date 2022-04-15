/**********************************************************************************

Author: Pradeep Guttha
Description: Trigger on AccountTrigger which will call the AccountTriggerHandler 
on the following events: before insert, before update.

**********************************************************************************/
/*trigger AccountTrigger on Accounts__c(before insert, before update) 
{
    if(Trigger.isBefore)
    {
    AccountTriggerHandler.UpdateContractingEntity();
    AccountTriggerHandler.populateTerritory();
    }    
}*/

/**********************************************************************************

Author: Pradeep Guttha
Description: Trigger on Accounts__c which will call the AccountHandler on all events.
Modification History : Modified by Jayant to implement trigger framework on 2/Dec/2016.

**********************************************************************************/
trigger AccountTrigger on Accounts__c(before insert, before update, before delete,
                              after insert, after update, after delete, after undelete) 
{
    TriggerRouter.handler(new AccountHandler());     
}