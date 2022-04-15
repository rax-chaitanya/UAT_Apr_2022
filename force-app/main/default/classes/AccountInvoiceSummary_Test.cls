@isTest
public class AccountInvoiceSummary_Test {
    
    
    @isTest
    private static void testInvoiceDatePostive(){
        
        AccountInvoiceSummary ais = new AccountInvoiceSummary();
        ais.invoiceMonth = 'SEP-2017';
        Boolean isCurrentMonth = ais.getisCurrentMonth();
        ais.companyId = '';
        ais.companyStatus ='';
        ais.dunsNumber = 'XYS8098';
        ais.invoiceAmount =123213;
        ais.invoiceLocalAmount =123.33;
        ais.invoiceLocalCurrency='';
        ais.dataAsOf = '';
        ais.monthOverMonthDeltaAmount =12.44;
        ais.revenueForecast =null;
        
        AccountInvoiceSummary ais1 = new AccountInvoiceSummary();
        ais1.invoiceMonth = 'FEB-17';
        Boolean isCurrentMonth1 = ais1.getisCurrentMonth();
        System.assertEquals(false, isCurrentMonth1);
        
    }
    
    @isTest
    private static void testInvoiceDatenegative(){
        
        AccountInvoiceSummary ais = new AccountInvoiceSummary();
        ais.invoiceMonth = '';
        Date d = ais.getInvoiceDate();
        
        System.assertEquals(null, d);
    }
}