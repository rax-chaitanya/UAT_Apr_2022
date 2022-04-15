/********************************************************************************************************
* @developer   :    Diego Castro
* @date        :    07/12/2017
* @class       :    AccountInvoiceDetail (Company)
* @description :    Apex class representation for GET /v1/companyinvoicedetails mappings
*					https://one.rackspace.com/pages/viewpage.action?title=Revenue+Forecasting+APIs&spaceKey=GET
*
* @notes	   :	Plan to move the variables encapsulated in a comment once Salesforce bug (W-3176751) is
*					is resolved. 
*					https://salesforce.stackexchange.com/questions/123744/calling-apex-from-lightning-returning-a-class-extending-an-abstract-class
*********************************************************************************************************/
public class AccountInvoiceDetail {
    // DELETE the following variables below this comment. Have this class
    // extend CompanyInvoiceInfo once getters from abstract/virtual class can be referenced in Lightning.    
    @AuraEnabled
    public string companyId {get; set;}
    @AuraEnabled
    public string companyStatus {get; set;}
    @AuraEnabled    
    public string dunsNumber {get; set;}
    @AuraEnabled
    public string invoiceMonth {get; set;}
    @AuraEnabled
    public decimal invoiceAmount {get; set;}
    @AuraEnabled    
    public decimal invoiceLocalAmount {get; set;}
    @AuraEnabled
    public string invoiceLocalCurrency {get; set;}
    @AuraEnabled
    public string dataAsOf {get; set;}
    // End of the variables to be deleted
    
    @AuraEnabled
    public decimal customerCreditAmount {get; set;}
    @AuraEnabled    
    public decimal discountAmount {get; set;}
    
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
    

}