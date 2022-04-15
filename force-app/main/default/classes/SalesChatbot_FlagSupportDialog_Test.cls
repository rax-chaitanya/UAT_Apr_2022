@isTest
public class SalesChatbot_FlagSupportDialog_Test {
    
     @isTest
    private static void testReturn(){
        List<boolean> result = SalesChatbot_FlagSupportDialog.flagSupportDialog();
        System.assertEquals(true, result[0]);
    }
}