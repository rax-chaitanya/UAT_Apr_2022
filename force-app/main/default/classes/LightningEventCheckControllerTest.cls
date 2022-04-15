@isTest
public class LightningEventCheckControllerTest {
	@isTest
    static void isAddressVerifiedTest(){
         Account acc = new Account();
        acc.name = 'test';
        insert acc;
        lightningEventcheckController.isAddressVerified(acc.id,'Account');
    }
}