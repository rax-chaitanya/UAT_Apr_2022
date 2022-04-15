trigger AttachmentTrigger on Attachment (before insert, before update, before delete,
                                        after insert, after update, after delete, after undelete) {
    TriggerRouter.handler(new AttachmentHandler());
}