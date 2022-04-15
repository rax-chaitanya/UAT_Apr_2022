// Test Class - ContentDocumentLinkHelper_Test

trigger ContentDocumentTrigger on ContentDocument (before delete,after delete) {
		  TriggerRouter.handler(new ContentDocumentLinkHandler());
}