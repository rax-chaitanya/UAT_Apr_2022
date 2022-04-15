@isTest
public class AccountInvoiceDetail_Test {
    
    
    @isTest
    private static void testGetInvoiceDate(){
        
        AccountInvoiceDetail aid = new AccountInvoiceDetail();
        aid.invoiceMonth = 'SEP-17';
        aid.companyId = 'testid';
        aid.companyStatus ='status';
        aid.dunsNumber ='dunsno';
        aid.invoiceAmount =9999;
        aid.invoiceLocalAmount =9999;
        aid.invoiceLocalCurrency = '99';
        aid.dataAsOf = 'test';
        aid.customerCreditAmount = 100; 
        aid.discountAmount = 10;
        aid.getInvoiceDate();
    }

    @isTest
    private static void testCatch(){
        AccountInvoiceDetail aid2 = new AccountInvoiceDetail();
        aid2.invoiceMonth = null;
        aid2.getInvoiceDate();
    }
     @isTest
    private static void testInvoiceDatenegative(){
        
        AccountsInvoiceSummary ais = new AccountsInvoiceSummary();
        ais.invoiceMonth = 'SEP-17';
        Boolean d = ais.getisCurrentMonth();
        
        System.assertEquals(false, d);
    }
}