@isTest
public class AccountsInvoiceSummary_Test {
    @isTest
    static void test() {
        AccountsInvoiceSummary aid1 = new AccountsInvoiceSummary();
        aid1.invoiceMonth = 'Feb-29-21';
    	aid1.accountNumber = '';
		aid1.accountType = '';
		aid1.accountSubType = '';
		aid1.accountStatus = '';
		aid1.businessUnit = '';
		aid1.bdom = 1;
		aid1.invoiceAmount = 10.01;
		aid1.invoiceLocalAmount = 10.01;
		aid1.invoiceLocalCurrency = '';
    	aid1.dataAsOf = '';
        aid1.monthOverMonthDeltaAmount = 10.01;
		aid1.Id = '';
        Boolean isCurrentMonth = aid1.getisCurrentMonth();
        System.assertEquals(false, isCurrentMonth);
    }    
    

}