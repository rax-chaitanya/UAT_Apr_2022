/**********************************************************************************
Author: Chaitanya
Description: This utility apex class is created to Return amount to USD with currency exchange rate for a given currency code
* Last modified : APRIL 2022,Dev- Chaitanya
* Test Class -CurrencyUtilityTest
**********************************************************************************/

public class CurrencyUtility {
    
    
    
    public static Decimal getConvertedAmount(String CurrencyIsoCode,Decimal Amount,integer DecimalPoint){
        if(Amount!=null && DecimalPoint!=null && CurrencyIsoCode!=null){
            
            Decimal oppExchangeValue=ExchangeRateIntegration.getExchangeRate(CurrencyIsoCode);
            system.debug(oppExchangeValue);
            system.debug('----- beforeconverted value--------'+Amount);
            Decimal convertedAmount=    Amount * oppExchangeValue;
            system.debug('converted value--------'+convertedAmount);   
            
            return  convertedAmount.setScale(DecimalPoint);
        }
        else return Amount;
        
    }
    
    
    
    
}