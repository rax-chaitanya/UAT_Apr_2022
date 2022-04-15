trigger TaskTrigger on Task(before delete, 
                            before update, 
                            before insert, 
                            after delete, 
                            after update, 
                            after insert,
                            after undelete) 
{
    TriggerRouter.handler(new TaskHandler());
}