@isTest
public class CurrencyUtilityTest {
    
    testMethod static void testInit() {
        CurrencyUtility.getConvertedAmount(null,null,null);
        CurrencyUtility.getConvertedAmount(null,1,0);
        CurrencyUtility.getConvertedAmount('USD',1.55,2);
        CurrencyUtility.getConvertedAmount('GBP',1.55,null);
        
        
    }
    
}