/**********************************************************************************

Author: Anitha Sajja
Description: Trigger on AccountContactRelationship which will call the AccountContactRelation Handler using the TriggerRouter 
on the following events: before insert, before update, before delete, after insert, after update,
 after delete, after undelete.

**********************************************************************************/
trigger AccountContactRelationTrigger on AccountContactRelation (before insert, before update, before delete,
                              after insert, after update, after delete, after undelete) 
{
    if(Trigger_Manager__c.getInstance('AccountContactRelation').Is_Active__c){
          TriggerRouter.handler(new AccountContactRelationHandler());
         }
       else{
           //system.debug('test----->'+Trigger_Manager__c.getInstance('AccountContactRelation').Is_Active__c);
       }
}