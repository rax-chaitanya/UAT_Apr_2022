trigger cLogTrigger on cLog__c (before insert,before update,before delete,
                                        after insert,after update,after delete,after undelete)  {

    TriggerRouter.handler(new cLogHandler());
}