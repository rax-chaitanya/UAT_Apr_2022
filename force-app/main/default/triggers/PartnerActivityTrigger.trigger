trigger PartnerActivityTrigger on Partner_Activity__c (before insert, before update,before delete, after insert, after update, after delete) {
    TriggerRouter.handler(new PartnerActivityHandler());
}