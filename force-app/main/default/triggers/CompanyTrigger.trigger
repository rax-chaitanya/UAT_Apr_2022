trigger CompanyTrigger on Account(before delete, 
                                  before update, 
                                  before insert, 
                                  after delete, 
                                  after update, 
                                  after insert,
                                  after undelete) 
{
    TriggerRouter.handler(new CompanyHandler());
}