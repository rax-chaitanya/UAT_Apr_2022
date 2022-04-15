@isTest
public class ExchangeRateIntegration_Test {
    
    testMethod static void testInit() {
        ExchangeRateIntegration.getExchangeRate(null);
        ExchangeRateIntegration.getExchangeRate('USD');
        ExchangeRateIntegration.getExchangeRate('GBP');
        
            
        }
    
}