/**********************************************************************************

Author: Thirupathi Aeneni/Omkar Narkar
Description: Trigger on which will call the NetworkMemberHandler on all events.


**********************************************************************************/
trigger NetworkMemberTrigger on NetworkMember (before insert, before update, before delete,after insert, after update, after delete, after undelete) {
    TriggerRouter.handler(new NetworkMemberHandler()); 
}