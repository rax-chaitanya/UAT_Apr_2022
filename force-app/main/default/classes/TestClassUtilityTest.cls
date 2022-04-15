@isTest
public class TestClassUtilityTest {
    
    @isTest static void testTestClass(){
        TestClassUtility.createPageManagers();
    }
    
    @isTest static void test_createRVMembers() {
        TestClassUtility.createRvMembers(1);        
        
        TestClassUtility.createRVAccounts(1, 100101);
        
        TestClassUtility.createRvCompensations(1);
        
        TestClassUtility.createCompensationDetails(1);
        
        TestClassUtility.createLeads(1);
        
        TestClassUtility.setTestSetupData();
        
        TestClassUtility.createChildQuerySettings();
        
    }
    
}