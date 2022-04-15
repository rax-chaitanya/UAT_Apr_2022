trigger ATMTrigger on AccountTeamMember ( before update, 
                                  		  before insert, 
                                          after delete, 
                                          after update, 
                                          after insert,
                                  		  after undelete) 
{
    TriggerRouter.handler(new ATMHandler());
}