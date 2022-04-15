@isTest
public class CMPorAccRecordType_Utility_Test {
    @isTest static void getRTBasedCMPorAccMapAndQuery_UtilityTest(){
        
        Id STId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
         Account company = new Account(Name = 'TestCompany', BillingCountry = 'Canada', ShippingCountry = 'Canada',RecordTypeId=STId);
         insert company;
         List<Account> companyList = new List<Account>();
         companyList.add(company);
         CMPorAccRecordType_Utility.getRTBasedCMPorAccMap(companyList);
         
         Id RTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account').getRecordTypeId();
         Account acc = new Account(Name = 'test',Type= 'Customer' , ShippingCountry='India',Company_Name__c = company.Id, RecordTypeId = RTypeId);
        insert acc;
         List<Account> accList = new List<Account>();
         accList.add(acc);
         CMPorAccRecordType_Utility.getRTBasedCMPorAccMap(accList);
         
         List<Id> CMPIds = CMPorACCRecordType_Utility.query_Utility(Label.CompanyRecordTypes);
              
    }

}