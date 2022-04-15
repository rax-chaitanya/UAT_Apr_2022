@isTest(SeeAllData=true)
public class AddressDoctorBatch_Test{
    public static testMethod void serveBatchModeTest(){
    Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        AddressDoctor__c Ad= new AddressDoctor__c();
        AD.Name='addrdoc';
        AD.MaxResultCount__c=12;
        AD.StreetWithNumber__c=true;
        AD.FormatWithCountry__c=false;
        AD.ElementAbbreviation__c=true;
        AD.StandardizeInvalidAddresses__c=false;
        /*AD.MatchingExtendedArchive__c=;
        AD.FlexibleRangeExpansion__c=;
        AD.GlobalMaxLength__c=;
        AD.FlexibleRangeExpansion__c=;
        AD.GlobalMaxLength__c=;
        AD.FormatMaxLines__c;*/
        //insert AD;
        List<String> streetList= new List<String>();
        streetList.add('school street 1021');
        streetList.add('school street 1022');
        streetList.add('school street 1023');
        streetList.add('school street 1024');
        
        List<String> CityList= new List<String>();
        CityList.add('school street 1021');
        CityList.add('school street 1022');
        CityList.add('school street 1023');
        CityList.add('school street 1024');
        
         List<String> StateList= new List<String>();
        StateList.add('school street 1021');
        StateList.add('school street 1022');
        StateList.add('school street 1023');
        StateList.add('school street 1024');
        
        List<String> CountryList= new List<String>();
        CountryList.add('school street 1021');
        CountryList.add('school street 1022');
        CountryList.add('school street 1023');
        CountryList.add('school street 1024');
        
         List<String> ZipList= new List<String>();
        ZipList.add('school street 1021');
        ZipList.add('school street 1022');
        ZipList.add('school street 1023');
        ZipList.add('school street 1024');
        
        AddressDoctorBatch.serveBatchMode(streetList,CityList,StateList,CountryList, ZipList);
    
    
    }


}