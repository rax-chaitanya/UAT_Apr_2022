trigger IndividualLinkTrigger on et4ae5__IndividualLink__c (before insert, before update, before delete,
                                        after insert, after update, after delete, after undelete) {

                                            TriggerRouter.handler(new IndividualLinkHandler());
}