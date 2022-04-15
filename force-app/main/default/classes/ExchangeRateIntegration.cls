public class ExchangeRateIntegration {
    
    /*
@Name:         getExchangeRate
@Description:  Returns currency exchange rate for a given currency code
Returns 0 on error.

*/
    
    public class ExchangeRateException extends Exception{}
    
    public static Decimal getExchangeRate(String currencyISOIn){
        if(currencyISOIn == '' || currencyISOIn == null){
            return 0;
        }
        if(currencyISOIn == 'USD'){
            return 1;
        }
        Decimal returnDecimal = 0;
        list<CurrencyType> c = [SELECT ISOCode, ConversionRate FROM CurrencyType WHERE IsActive=true and isocode =: currencyISOIn];
        if(c.size()>0)
        {
            system.debug('conversionrate::'+c[0].conversionRate);
            returndecimal =1/c[0].ConversionRate;
            
        }
        return returndecimal;
    }
}