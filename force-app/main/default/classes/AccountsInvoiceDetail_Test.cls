@isTest
public class AccountsInvoiceDetail_Test {
    
    @isTest
    static void test() {
        AccountsInvoiceSummary ais1 = new AccountsInvoiceSummary();
        ais1.invoiceMonth = 'FEB-17';
        Date isCurrentMonth1 = ais1.getInvoiceDate();
    }
    

}