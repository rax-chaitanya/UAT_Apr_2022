/********************************************************************************************************
* @developer   :    Diego Castro
* @date        :    07/12/2017
* @class       :    AccountInvoiceSummary
* @description :    Apex class representation for GET /v1/accountinvoicesummary mappings
*                   https://one.rackspace.com/pages/viewpage.action?title=Revenue+Forecasting+APIs&spaceKey=GET
*
* @notes       :    Plan to move the variables encapsulated in a comment once Salesforce bug (W-3176751) is
*                   is resolved. 
*                   https://salesforce.stackexchange.com/questions/123744/calling-apex-from-lightning-returning-a-class-extending-an-abstract-class
*********************************************************************************************************/
public class AccountsInvoiceSummary  {
    // DELETE the following variables below this comment. Have this class
    // extend AccountInvoiceInfo once getters from abstract/virtual class can be referenced in Lightning.    
    @AuraEnabled
    public String accountNumber {get; set;}
    @AuraEnabled
    public String accountType {get; set;}
    @AuraEnabled
    public String accountSubType {get; set;}
    @AuraEnabled
    public String accountStatus {get; set;}
    @AuraEnabled
    public String businessUnit {get; set;}
    @AuraEnabled    
    public String invoiceMonth {get; set;}
    @AuraEnabled    
    public Integer bdom {get; set;} 
    @AuraEnabled    
    public Decimal invoiceAmount {get; set;}
    @AuraEnabled    
    public Decimal invoiceLocalAmount {get; set;}
    @AuraEnabled    
    public String invoiceLocalCurrency {get; set;}
    @AuraEnabled    
    public String dataAsOf {get; set;}        
    // End of the variables to be deleted
    
    @AuraEnabled    
    public Decimal monthOverMonthDeltaAmount {get; set;}
    
    @AuraEnabled 
    public Revenue_Forecast__c revenueForecast {get; set;}
    
    @AuraEnabled
    public string Id {get; set;}
    
    @AuraEnabled
    public Date getInvoiceDate() {
        Date ret;
        map<string, integer> dateMap = new map<string, integer>{'JAN' => 1,
            'FEB' => 2, 'MAR' => 3, 'APR' => 4, 'MAY' => 5, 'JUN' => 6, 'JUL' => 7, 'AUG' => 8, 'SEP' => 9, 'OCT' => 10, 'NOV' => 11, 'DEC' => 12};
                
                try {
                    
                    String[] dateParams = invoiceMonth.split('-'); 
                    String yearString = dateParams[1];
                    
                    if (yearString.length() == 2) {
                        yearString = String.valueOf( Date.today().year() ).substring(0,2) + yearString;
                    }
                    
                    //Date.newInstance(year, month, day)
                    ret = Date.newInstance(Integer.valueOf (yearString) ,  dateMap.get(dateParams[0].toUpperCase())  , 2);
                } catch (Exception e) {
                    
                }
        return ret;
    }
    
    
    @AuraEnabled
    public Boolean getisCurrentMonth() {
        Date invoiceDate = getInvoiceDate();
        Date todaysDate = Date.today();
        
        return (todaysDate.month() == invoiceDate.month() && todaysDate.year() == invoiceDate.year());
    }
    
    

}