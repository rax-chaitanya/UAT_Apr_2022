@isTest
public class RequestCompanyAccessControllerTest {
    @testSetup
    static void testSetup() {
        TestDataHelper.quickSetup();
        insert TestDataHelper.createTestCompany();
    }
  @isTest
    static void test_getCompany() {
        Id companyId = [Select Id from Account LIMIT 1].Id;
        RequestCompanyAccessController.getCompany(companyId);
        RequestCompanyAccessController.goBack(companyId);
        RequestCompanyAccessController.getCompany(null);     
    }
    @isTest 
    static void test_getUserRecordAccess() {
        Id companyId = [Select Id from Account LIMIT 1].Id;
        RequestCompanyAccessController.getUserRecordAccess(companyId);
        RequestCompanyAccessController.getUserRecordAccess(null);
    }
 
    @isTest 
    static void test_findProcessInstance() {
        Id companyId = [Select Id from Account LIMIT 1].Id;
        RequestCompanyAccessController.findProcessInstance(companyId);
        RequestCompanyAccessController.findProcessInstance(null);
    }       
    @isTest
    static void test_requestAccess() {
        Id companyId = [Select Id from Account LIMIT 1].Id;
        RequestCompanyAccessController.requestAccess(companyId);
        RequestCompanyAccessController.requestAccess(null);
        RequestCompanyAccessController.AutoApproveAccess(companyId);
    }
     @isTest
    static void test_getWorkItemId() {
        Id companyId = [Select Id from Account LIMIT 1].Id;    
        RequestCompanyAccessController.getWorkItemId(companyId);
        RequestCompanyAccessController.getWorkItemId(null);
    }
 @isTest
    static void test_AutoApproveAccess() {
        Id companyId = [Select Id from Account LIMIT 1].Id;  
        RequestCompanyAccessController.requestAccess(companyId);
        RequestCompanyAccessController.AutoApproveAccess(companyId);
        RequestCompanyAccessController.AutoApproveAccess(null);
    }
    
}