@isTest(seeAllData=true)
public class PaymentController_Test {
    public static TestMethod void testAgreementsMethod(){ 
    	PartnerAgreementsController.getAgreements();
        PaymentController.getUrls();
    }
}