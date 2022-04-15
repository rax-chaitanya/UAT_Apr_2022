@isTest
public class HttpServiceCalloutTest {
    @testSetup
    public static  void testSetup(){
        TestDataSetUp.insertTestRecords();
    }
    public static testMethod void testMethod1()
    {
       PageReference myPage1=Page.LiveAgentConfigEditPage;
        Test.setCurrentPage(myPage1);
        LiveAgentConfigEditController myEdit1=new LiveAgentConfigEditController();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_xml());

        myEdit1.Save();      
    }
   
    @isTest
    public static void testMethod3(){
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_xml());
         HttpServiceCallout.HttpRequestDelete('null');
        Test.stopTest();
    }

}