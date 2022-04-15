@isTest
public class TestDataHelper_Test {

    @testSetup static void testsetupData() {
        Test.startTest();
            TestClassUtility.setTestSetupData();              
        Test.stopTest();  
    }

    @isTest static void testTestData(){
   //   insert new Trigger_Manager__c(name='OpportunityTgr',Is_Active__c=true);
        Test.startTest();
        
        TestDataHelper.createCompanyHierarchy(1);
        TestDataHelper.createCompanyHierarchy(2, 'Call In');
        TestDataHelper.createSpineTree(1,'Chat');
       TestDataHelper.createTestCompanies(1);
        TestDataHelper.createTestCompany();
        TestDataHelper.createTestContact();
        TestDataHelper.createTestContacts(1);
        TestDataHelper.createTestLeads(1);
        TestDataHelper.createTestLeads(1);
        
      Test.stopTest();     
        
    }
    
    @isTest static void testTestData2(){   
       Test.startTest();       
        
        TestDataHelper.createUsers(5);
        TestDataHelper.generateUSDedicatedAllCombos();
        TestDataHelper.generateAccountInvoiceSummaries(4);
        TestDataHelper.generateAccountInvoiceDetails(44);
        TestDataHelper.generateAccountsCInvoiceSummary(500);
        TestDataHelper.generateAccountsCInvoiceDetails(4500);
        
      Test.stopTest();     
        
    }
    
    @isTest static void testTestData3(){   
        
       Test.startTest();       
        
         TestDataHelper.oppOptions(); 
         TestDataHelper.generateCompany();
         TestDataHelper.generateAccounts();       
        
      Test.stopTest();     
        
    } 
    
    @isTest
    public static void testData1(){
           TestDataHelper.quickSetup();
    }
}