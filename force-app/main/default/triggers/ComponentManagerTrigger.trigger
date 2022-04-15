trigger ComponentManagerTrigger on Component_Manager__c(before delete, 
                                  before update, 
                                  before insert, 
                                  after delete, 
                                  after update, 
                                  after insert,
                                  after undelete) 
{
    TriggerRouter.handler(new ComponentManagerHandler());
}