/*
###########################################################################
# File..................: UserTrigger.trigger
# Version...............: 1.0
# Created by............: Kartikeya Tewari (RDC)
# Created Date..........: 12-Apr-2017
# Description...........: Trigger on User which will call the UserHandler using the TriggerRouter 
#							on the following events: before insert, before update.
*/
trigger UserTrigger on User (before insert, before update, before delete,
                             after insert, after update, after delete, after undelete) {
	TriggerRouter.handler(new UserHandler());
}