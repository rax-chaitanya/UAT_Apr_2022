@isTest
public class CohortCalculationSchedulerTest {
	@testSetup
    public static void setupTestData(){
        
       
        TestClassUtility.setTestSetupData();
        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
        insert fieldMappings;
        
        
    }
    @isTest
    private static void cohortCalculationTest(){
        CohortRectificationScheduler cs = new CohortRectificationScheduler();
        Cohort_Calculation_Settings__c cst = new Cohort_Calculation_Settings__c();
        cst.is_active__c = true;
        Id recordTypeIdacc2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        Account a2 = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId=recordTypeIdacc2);
        Test.startTest();
        insert a2; 
       
        Id crecordType = [Select Id from RecordType where sobjectType='Contact' and Name ='Standard' limit 1].Id;
        Contact pcon = new Contact(recordtypeid=crecordType,FirstName='Partner',LastName='User',Email='rax.partner@rackspace.com',Phone='1233123',AccountId = a2.Id);
        
        insert pcon;
        Test.stopTest();
        cst.Batch_query__c = 'Select id, cohort_month__c, CM_Existing_Data__c,createddate,email,skip_obms__c from contact where (createddate >= :dt AND CM_Existing_data__c = null)';
        cst.Number_of_days__c = -2;
        insert cst;
        Datetime dt = System.now().addDays( Integer.valueOf(cst.Number_of_days__c) );
        String sch = '0 0 23 * * ?'; 
        CohortRectificationBatch batch = new CohortRectificationBatch();
        database.executebatch(batch,100);
		System.schedule('Test Cohort schedule',sch,cs);
    }
}