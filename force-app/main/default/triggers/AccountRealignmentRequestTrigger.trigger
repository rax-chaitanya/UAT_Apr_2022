trigger AccountRealignmentRequestTrigger on Account_Realignment_Request__c
(before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TriggerRouter.handler(new AccountRealignmentRequestHandler());    
}