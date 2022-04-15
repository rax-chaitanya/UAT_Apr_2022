trigger OPCAccountSurveyTrigger on OPC_Account_Survey__c (before insert, before update, before delete,
                                                          after insert, after update, after delete, after undelete) 
{
    TriggerRouter.handler(new OPCAccountSurveyHandler());     
}