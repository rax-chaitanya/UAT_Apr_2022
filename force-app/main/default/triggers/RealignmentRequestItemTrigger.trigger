trigger RealignmentRequestItemTrigger on Realignment_Request_Item__c 
(before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TriggerRouter.handler(new RealignmentRequestItemHandler());    
}