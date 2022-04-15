trigger PSA_VendorInvoiceTrigger on pse__Vendor_Invoice__c(before insert, before update, before delete, 
                                                           after insert, after update, after delete, after undelete) {
    TriggerRouter.handler(new PSA_VendorInvoiceHandler());
}