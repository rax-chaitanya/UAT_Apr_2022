trigger IndividualEmailResultTrigger on et4ae5__IndividualEmailResult__c (before insert, before update, before delete,
                                        after insert, after update, after delete, after undelete) {

                                            TriggerRouter.handler(new IndividualEmailResultHandler());
}