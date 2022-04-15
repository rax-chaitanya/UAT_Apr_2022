@isTest
Public class SearchLookupClass_Test{

Static TestMethod void SearchLookup(){
Group testGroup = new Group();
TestClassUtility.setTestSetupData();
        testGroup.Name = 'testGroup';
        testGroup.DeveloperName = 'ABC';
      //  testGroup.Type='Query';
        INSERT testGroup;
        Account a1 = new Account(Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =system.today(),Partner_Level__c='Reseller',Name='TestAccount1234',BillingCountry='India',ShippingCountry='India');
        insert a1;
    test.StartTest();
    SearchLookupClass.fetchLookUpValues('testG','Queue__c');
    SearchLookupClass.fetchLookUpValues('testA','Account');

    test.StopTest();

}
}