/*
###########################################################################
# File..................: PSA_VendorInvoiceHandler.cls
# Version...............: 1.0
# Created by............: Anwesh kumar (RDC)
# Created Date..........: 2-Aug-2018
# Description...........: This apex class is created for the Trigger Framework,
#                           it controls the flow of execution of the Vendor_Invoice trigger.
*/
public class PSA_VendorInvoiceHandler implements TriggerInterface
{
    public Boolean isActive() {
        if(Trigger_Manager__c.getAll().containsKey('PSA_VendorInvoiceHandler')) {
            return Trigger_Manager__c.getInstance('PSA_VendorInvoiceHandler').Is_Active__c;
        }
        return false;
    }
    
    public void beforeInsert() {
        
        
    }
    
    public void beforeUpdate() {
        // Do nothing
    }
    
    public void beforeDelete() {
        //do nothing
    }
    
    public void afterInsert() {
        
        try {
            //PSA_VendorInvoiceTrigerHelper.CountInvoices();
            RollUpSummaryUtility.calcFieldAPIs.add('Amount__c');
            RollUpSummaryUtility.populateRollupSummary(RollUpSummaryUtility.Method.COUNT, 'pse__Proj__c', 'Vendor_Invoices__r', 'Number_of_Invoices__c', 'Project__c', null);
            List<pse__Proj__c> parentRecords = (List<pse__Proj__c>)RollUpSummaryUtility.populateRollupSummary(RollUpSummaryUtility.Method.SUM, 'pse__Proj__c', 'Vendor_Invoices__r', 'Total_Customer_Fees_Invoiced__c', 'Project__c','Amount__c');
            if(!parentRecords.isEmpty()){
                Update parentRecords;
            }
        }
        catch(Exception e) {    ExceptionHandler.postToAll(e);    throw new CustomException(ExceptionHandler.getBody(e));    }
    }
    
    public void afterUpdate() {
        try {
            //PSA_VendorInvoiceTrigerHelper.CountInvoices();
            RollUpSummaryUtility.calcFieldAPIs.add('Amount__c');
            RollUpSummaryUtility.populateRollupSummary(RollUpSummaryUtility.Method.COUNT, 'pse__Proj__c', 'Vendor_Invoices__r', 'Number_of_Invoices__c', 'Project__c', null);
            List<pse__Proj__c> parentRecords = (List<pse__Proj__c>)RollUpSummaryUtility.populateRollupSummary(RollUpSummaryUtility.Method.SUM, 'pse__Proj__c', 'Vendor_Invoices__r', 'Total_Customer_Fees_Invoiced__c', 'Project__c','Amount__c');
            if(!parentRecords.isEmpty()){
                Update parentRecords;
            }
        }
        catch(Exception e) {    ExceptionHandler.postToAll(e);    throw new CustomException(ExceptionHandler.getBody(e));    }
    }
    
    public void afterDelete() {
        
        try {
            //PSA_VendorInvoiceTrigerHelper.CountInvoices();
            RollUpSummaryUtility.calcFieldAPIs.add('Amount__c');
            RollUpSummaryUtility.populateRollupSummary(RollUpSummaryUtility.Method.COUNT, 'pse__Proj__c', 'Vendor_Invoices__r', 'Number_of_Invoices__c', 'Project__c', null);
            List<pse__Proj__c> parentRecords = (List<pse__Proj__c>)RollUpSummaryUtility.populateRollupSummary(RollUpSummaryUtility.Method.SUM, 'pse__Proj__c', 'Vendor_Invoices__r', 'Total_Customer_Fees_Invoiced__c', 'Project__c','Amount__c');
            if(!parentRecords.isEmpty()){
                Update parentRecords;
            }
        }
        catch(Exception e) {    ExceptionHandler.postToAll(e);    throw new CustomException(ExceptionHandler.getBody(e));    }
        
    }
    
    public void afterUndelete() {
        try {
            //PSA_VendorInvoiceTrigerHelper.CountInvoices();
            RollUpSummaryUtility.calcFieldAPIs.add('Amount__c');
            RollUpSummaryUtility.populateRollupSummary(RollUpSummaryUtility.Method.COUNT, 'pse__Proj__c', 'Vendor_Invoices__r', 'Number_of_Invoices__c', 'Project__c', null);
            List<pse__Proj__c> parentRecords = (List<pse__Proj__c>)RollUpSummaryUtility.populateRollupSummary(RollUpSummaryUtility.Method.SUM, 'pse__Proj__c', 'Vendor_Invoices__r', 'Total_Customer_Fees_Invoiced__c', 'Project__c','Amount__c');
            if(!parentRecords.isEmpty()){
                Update parentRecords;
            }
        }
        catch(Exception e) {    ExceptionHandler.postToAll(e);    throw new CustomException(ExceptionHandler.getBody(e));    }
    }
}