trigger TranscriptTrigger on LiveChatTranscript (before insert, after insert, after update, before Delete, after Delete, after Undelete) {
 TriggerRouter.handler(new TranscriptHandler());
}