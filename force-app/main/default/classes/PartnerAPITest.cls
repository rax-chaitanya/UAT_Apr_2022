@isTest
public class PartnerAPITest{
 public static testMethod void testCancel()
    {
    test.starttest();
     Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_xml());
    test.stoptest();
    PartnerAPI.logincall();
}
}