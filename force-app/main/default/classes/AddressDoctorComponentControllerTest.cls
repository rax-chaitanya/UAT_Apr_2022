@isTest
public class AddressDoctorComponentControllerTest {

    
    @isTest 
    static void serveInitAddressTest() {
        Address_Doctor_Fields_Config__mdt setObject = new Address_Doctor_Fields_Config__mdt();
        setObject.MasterLabel = 'Account Billing';
        setObject.DeveloperName = 'Account_Billing';
        setObject.Address_Type__c = 'Billing';
        setObject.City_Api_Name__c = 'BillingCity';
        setObject.Country_Api_Name__c = 'BillingCountry';
        setObject.Object_Name__c = 'Account';
        setObject.PostalCode_Api_Name__c = 'BillingPostalCode   ';
        setObject.State_Api_Name__c = 'BillingState';
        setObject.StateCode_Api_Name__c = 'BillingStateCode';
        setObject.Street_Api_Name__c = 'BillingStreet';
       //insert setObject;
        Account acc = new Account();
        acc.name = 'test';
        insert acc;
        AddressDoctorComponentController.serveInitAddress(acc.id, 'Account');
    }
    
     @isTest 
    static void fetchCountryListTest(){
        AddressDoctorComponentController.fetchCountryList();
    }
  @isTest(SeeAllData=true) 
    static void saveRecordTest(){
        Accounts__c AccId=[Select Id FROM Accounts__c LIMIT 1];
        Contact ContactRecord=[Select Id FROM Contact LIMIT 1];
        Account accountid=[Select Id FROM Account LIMIT 1];
        Account_Contact_Role__c accoutContactRole=[Select Id FROM Account_Contact_Role__c LIMIT 1];
        AddressDoctorComponentController.saveRecord(
            '{"building":" ","city":"CIUDAD DE MÉXICO","ContactAddressRecursiveHandler":true,"country":"Mexico","houseNo":"116","province":"CIUDAD DE MÉXICO","provinceISO":"CDMX, ","resultNumber":"2","street":"CALLE PATRICIO SANZ CALLE 116 SANZ Patrico","zip":"03100","ifVerified":true}',
            AccId.Id, new List<String>(), 'Accounts__c','Billing'
        );
         AddressDoctorComponentController.saveRecord(
            '{"building":" ","city":"CIUDAD DE MÉXIC","ContactAddressRecursiveHandler":true,"country":"Mexico","houseNo":"116","province":"CIUDAD DE MÉXICO","provinceISO":"CDMX, ","resultNumber":"2","street":"CALLE PATRICIO SANZ CALLE 116 SANZ Patrico","zip":"03100","ifVerified":true}',
            ContactRecord.Id, new List<String>(), 'Contact','Billing'
        );
         AddressDoctorComponentController.saveRecord(
            '{"building":" ","city":"CIUDAD DE MÉXIC","ContactAddressRecursiveHandler":true,"country":"Mexico","houseNo":"116","province":"CIUDAD DE MÉXICO","provinceISO":"CDMX, ","resultNumber":"2","street":"CALLE PATRICIO SANZ CALLE 116 SANZ Patrico","zip":"03100","ifVerified":true}',
            accountid.Id, new List<String>(), 'Account','Shipping'
        );
        
         AddressDoctorComponentController.saveRecord(
            '{"building":" ","city":"CIUDAD DE MÉXIC","ContactAddressRecursiveHandler":true,"country":"Mexico","houseNo":"116","province":"CIUDAD DE MÉXICO","provinceISO":"CDMX, ","resultNumber":"2","street":"CALLE PATRICIO SANZ CALLE 116 SANZ Patrico","zip":"03100","ifVerified":true}',
            accountid.Id, new List<String>(), 'Account_Contact_Role__c','Shipping'
        );
    }
   
     @isTest 
    static void serveBacthModeTest() {
        AddressDoctor__c cs = new AddressDoctor__c();
        cs.name= 'addrdoc';
        cs.ElementAbbreviation__c = false;
        cs.FlexibleRangeExpansion__c = false;
        cs.FormatMaxLines__c = 12;
        cs.FormatWithCountry__c = false;
        cs.GlobalCasing__c = 'test';
        cs.GlobalMaxLength__c = 12;
        cs.MatchingExtendedArchive__c = false;
        cs.MaxResultCount__c = 12;
        cs.StandardizeInvalidAddresses__c = false;
        cs.StreetWithNumber__c = false;
        cs.user_name__c = 'Test';
        cs.UseTransactionPool__c = 'test';
        cs.password__c='test';
        
        insert cs;
        CountryCodeMap__c ccm=new CountryCodeMap__c();
        ccm.Name='ThaiLand';
        ccm.Country_Code__c='ThaiLand';
        ccm.Active__c=true;
        insert ccm;
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Test.startTest() ;
        AddressDoctorComponentController.serveBatchMode('Test', 'Test', 'Test', 'ThaiLand', 'Test', 'Test');
        Test.stopTest();
        
            
          
            
 
    }
}