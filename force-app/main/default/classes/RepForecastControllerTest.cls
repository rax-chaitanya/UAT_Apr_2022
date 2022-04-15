@isTest
public class RepForecastControllerTest {
	
	@testSetup
    static void setup() {
		insertFieldMapings();
		insertCountryTerritoryMapping();

       // TestDataHelper.quickSetup();
       Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
        TestClassUtility.setTestSetupData();
        Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India', RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a;
         Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id);
       // insert c;
        Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,BillingCountry = 'India', RecordTypeId = Label.Account_Prospect_RecordType_ID);
       // insert ac; 
   RepForecastController.saveAccount(a);
    }
	
	 public static void insertCountryTerritoryMapping() {
        List<CountryTerritoryMapping__c> mappings = new List<CountryTerritoryMapping__c>();
        mappings.add(new CountryTerritoryMapping__c(Name = 'Canada', Territory_Name__c = 'US/CANADA'));
        mappings.add(new CountryTerritoryMapping__c(Name = 'Afghanistan', Territory_Name__c = 'EMEA'));
        mappings.add(new CountryTerritoryMapping__c(Name = 'Australia', Territory_Name__c = 'ANZ'));
        mappings.add(new CountryTerritoryMapping__c(Name = 'Anguilla', Territory_Name__c = 'LATAM'));
        mappings.add(new CountryTerritoryMapping__c(Name = 'India', Territory_Name__c = 'Asia'));
        mappings.add(new CountryTerritoryMapping__c(Name = 'Belgium', Territory_Name__c = 'Benelux'));
        mappings.add(new CountryTerritoryMapping__c(Name = 'Austria', Territory_Name__c = 'DACH'));
        insert mappings;
    }
		
    
    public static void insertFieldMapings() {
        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
        insert fieldMappings;
    }      
    
    @isTest 
    static void test_getOwnedAccounts() {
        String rec_id;
        
        RepForecastController.getOwnedAccounts(rec_id);
        Account acc = [Select Id from Account LIMIT 1];        
        RepForecastController.getOwnedAccounts(acc.id);

    }
    
    @isTest 
    static void test_getRevenueForecast() {
        //dummy id
        String theID;
        RepForecastController.getRevenueForecast(theID);
        
    }
    
  @isTest 
    static void test_getRevenueForecastsByAccountIdMap() {
        Account acc = [Select Id from Account LIMIT 1];
        RepForecastController.getRevenueForecastsByAccountIdMap(acc.Id);    
    }
    
    @isTest
    static void test_upsertRevenueForecasts() {
      
       Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
       Account acc1 = new Account();
       acc1.RecordtypeId = devRecordTypeId ;
       acc1.Name = 'test';
     //  Insert acc1;
       
       //acc1.RecordTypeId = devRecordTypeId ;
     //  Update acc1;
       
        
       Revenue_Forecast__c rev_forecast = new Revenue_Forecast__c();
       
        Date t = Date.today();
        t = t.addYears(1);
        rev_forecast.Month__c = '01';
        rev_forecast.Year__c = String.valueOf(t.year());
        rev_forecast.Account__c = acc1.Id;
        insert rev_forecast;
         Revenue_Forecast__c rev_forecast1 = new Revenue_Forecast__c();
         rev_forecast1.Account__c = acc1.id;
         rev_forecast1.Year__c = '2016';
         rev_forecast1.Month__c = '01';
         insert rev_forecast1;
         
         rev_forecast = [Select Id, Amount__c, Key__c, Year__c, Month__c, Account__c from Revenue_Forecast__c LIMIT 1];
        String ret = RepForecastController.upsertRevenueForecast(rev_forecast, rev_forecast.Id);
        String ret1 = RepForecastController.upsertRevenueForecast(rev_forecast1, rev_forecast.Id);
        System.debug(ret);
        

        
        RepForecastController.upsertRevenueForecast(rev_forecast, rev_forecast.Id);
        
        Revenue_Forecast__c[] lst = new list<revenue_Forecast__c>();
        lst.add(rev_forecast);

    RepForecastController.upsertRevenueForecasts(lst);       
        
        RepForecastController.findRevenueForecast(acc1.Id, rev_forecast.Year__c + '-01-01');
         
    }
    

    @isTest
    static void test_newRevenueForecast() {
        RepForecastController.newRevenueForecast();
        
    }
    
    @isTest
    static void test_getForecastedDates() {
        RepForecastController.getForecastedDates();
        
    } 
    @isTest
    static void coverException(){
        
        try{
            RepForecastController.upsertRevenueForecast(null,null);
        }Catch(Exception e){
            
        }
        try{
           RepForecastController.findRevenueForecast(null,null); 
        }catch(Exception e){
            
        }
        
    }

}