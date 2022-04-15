@isTest
public class QuickCleanBatchAccounts_Test {

      
    @isTest
    static void testCleanBatch(){
        Id StandardCmpRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
                Id ProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account').getRecordTypeId();

        TestClassUtility.setTestSetupData(); 
         Account a = new Account(Name='Test Account1234',RecordTypeId=StandardCmpRecordTypeId,phone ='1212121212', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka');
        insert a;
       List<Account> accs = new List<Account>();
        for(Integer i=1;i<=50;i++){
            accs.add(new Account(Name='Test C Account'+i,Company_Name__c=a.Id,RecordTypeId=ProspectRecordTypeId,phone ='1212121212',BillingCountry='United States',BillingState  = 'Texas'));
        }
        insert accs;
        
        Test.startTest();
        Database.executeBatch(new QuickCleanBatchAccounts(), 60);
        Test.stopTest();
    }
}