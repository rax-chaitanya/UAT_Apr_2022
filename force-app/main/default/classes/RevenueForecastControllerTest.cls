@isTest
public class RevenueForecastControllerTest {
  @testSetup
    static void testSetup() {
        Test.startTest(); 
            TestDataFactory.getOrgConstants();
            TestDataFactory.getProdOrgIDSetting();  
            //TestDataFactory.createCompany('Test RS 1');
        Test.stopTest(); 
        Account company = new Account(Name = 'Test RS 1',BillingCountry = 'Canada', ShippingCountry = 'Canada', RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert company; 
        Account acccmp = new Account(Name = 'Test RS 1a',BillingCountry = 'Canada', ShippingCountry = 'Canada', RecordTypeId = Label.Account_Prospect_RecordType_ID);
        insert acccmp;                
    }
    static void test_getSObject(String RosettingName,Account acc,String accsummary) {
        Test.startTest();
        try{ 
            Test.setMock(HttpCalloutMock.class, new RevSummaryHTTPMockCalloutTest());
            RevenueForecastController.getObjectsFromResult(acc.Id, JSON.serialize(acc),accsummary, RosettingName);                 
        }catch(Exception e){}
        try{
         RevenueForecastController.getsObject(acc.Id);                               
        }catch(Exception e){}
        try{
         RevenueForecastController.getForecastsByKey(acc.Id);            
        }catch(Exception e){}
         try{
         String[] ids = new String[]{acc.Id};
         RevenueForecastController.getAccountsByNumber('Id', ids);   
        }catch(Exception e){} 
        try{
         RevenueForecastController.serialize(acc.Id);   
        }catch(Exception e){}                
       Test.stopTest(); 
    }
    @isTest
    static void test_getSObjectMain1() {
        Account company = [Select id,Name,BillingCountry,Company_Name__c,ShippingCountry,RecordTypeId from Account where Name='Test RS 1' and RecordType.Name = 'Standard Company'];
        test_getSObject('RO-Summary-Account',company,'AccountInvoiceSummary');        
    }
    @isTest
    static void test_getSObjectMain2() {
        Account acc = [Select id,Name,Company_Name__c,BillingCountry,ShippingCountry,RecordTypeId from Account where Name='Test RS 1a' and RecordType.DeveloperName = 'Prospect'];        
        test_getSObject('RO-Summary-Accounts',acc,'AccountsInvoiceSummary');        
    }        
}