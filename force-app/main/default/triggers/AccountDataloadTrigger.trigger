//Created new trigger for data load
trigger AccountDataloadTrigger on Account(before delete, 
                                  before update, 
                                  before insert, 
                                  after delete, 
                                  after update, 
                                  after insert,
                                  after undelete) 
{
    TriggerRouter.handler(new CompanyHandlerForDataLoad());
    
}