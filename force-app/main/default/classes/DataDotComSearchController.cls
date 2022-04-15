/************************************************************************************************************************************
* Class Name : DataDotComSearchController
* Author : Matthew Lamb
* Creation Date : October 2015
* Purpose : The Salesbroom team, who is responsible for aligning our Account data to Companies, needs to be able to search Data.com
*        when they are cleaning and verifying Company data. This UI allows them to perform basic searches against Data.com, via
*        the DataclouddAndBCompany object, despite not having Data.com feature licenses (since they are Chatter Only users).
************************************************************************************************************************************/

public with sharing class DataDotComSearchController {
    
    public Map<String, DataDotComWrapper> searchResultsMap {get; set;}
    public Boolean displaySearchResults {get; set;}
    public Boolean searchCompleted {get; set;}
    
    public String companyNameInput {get; set;}
    public String companyIdInput {get; set;}
    public String locationTypeInput {get; set;}
    public String queryLimitInput {get; set;}
    public String stateInput {get; set;}
    public String countryInput {get; set;}
    public String dunsToImport {get; set;}
    public String dunsToAssign {get; set;}
    
    public Account existingCompany;
    
    public static final String companyBlankError = 'You cannot leave Company Name blank, please enter a value and try your search again.';
    
    //Constructor to set the search results panel not to display initially, as well as initialize all the search parameter fields
    public DataDotComSearchController() {
        displaySearchResults = false;
        locationTypeInput = 'HQ + Single Locations';
        stateInput = '';
        countryInput = '';
        queryLimitInput = '100';
        searchCompleted = false;
        
        //See if the URL contains the Name and Id parameters, which means we came to the page from a Company record directly, which means
        //that the page will perfom slightly differently (e.g. the search will auto-run and the Select buttons will be available)
        if(ApexPages.currentPage().getParameters().get('companyid') != null && ApexPages.currentPage().getParameters().get('companyid') != '' 
           &&ApexPages.currentPage().getParameters().get('companyname') != null && ApexPages.currentPage().getParameters().get('companyname') != '') {
               companyNameInput = ApexPages.currentPage().getParameters().get('companyname');
               companyIdInput = ApexPages.currentPage().getParameters().get('companyid');
               
               List<Account> existingCompanylist = [SELECT Id, CleanStatus FROM Account WHERE Id =: companyIdInput];
               if(existingCompanylist != null && existingCompanylist.size() == 1) {
                   existingCompany = existingCompanylist[0];
               }
               
               search();
           }
    }
    
    //Method to support the Search operation on the DataDotComSearch page. Responsible for the query to the Data.com API, 
    //and assembling the result set for display to the user
    public void search() {
        if(companyNameInput == null || companyNameInput.trim().length() == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, companyBlankError));
        }
        else {
            boolean okToAdd;
            searchResultsMap = new Map<String, DataDotComWrapper>();
            searchCompleted = true;
            
            String query = 'SELECT Id, Name, TradeStyle1, DunsNumber, LocationStatus, URL, Phone, Street, City, State, Country, ' +
                'ParentOrHqDunsNumber, ParentOrHqBusinessName, OutOfBusiness, Revenue ' + 
                'FROM DataclouddAndBCompany ' + 
                'WHERE Name LIKE \'' + String.escapeSingleQuotes(companyNameInput) + '\' ';
            
            //Conditionally add in filters for Location Status
            if(locationTypeInput == 'Headquarters Only') { 
                query += ' AND (LocationStatus = \'1\') ';
            }
            else if(locationTypeInput == 'Single Locations Only') {
                query += ' AND (LocationStatus = \'0\') ';
            }
            else if(locationTypeInput == 'HQ + Single Locations') {
                query += ' AND (LocationStatus = \'0\' OR LocationStatus = \'1\') ';
            }
            
            //Append the LIMIT Clause
            query += 'LIMIT ' + queryLimitInput;
            
            //Loop through our query results and filter out anything we couldn't filter directly in the query, and 
            //load the remaining items into the searchResultsMap so we can display them to the user
            for(DataclouddAndBCompany dAndBCompany : database.query(query)) {
                searchResultsMap.put(dAndBCompany.DunsNumber, new DataDotComWrapper(dAndBCompany.Name, dAndBCompany.TradeStyle1, dAndBCompany.DunsNumber, 
                                                                                    dAndBCompany.LocationStatus, dAndBCompany.URL, dAndBCompany.Phone,
                                                                                    dAndBCompany.Street, dAndBCompany.City, dAndBCompany.State, 
                                                                                    dAndBCompany.Country, dAndBCompany.OutOfBusiness, dAndBCompany.Revenue));
            }
            
            //If we're running a test, then the query to DataclouddAndBCompany isn't going to return any results, so we need to
            //mock query results when tests are running so we can test the rest of the functionality
            if(Test.isRunningTest()) {
                searchResultsMap.put('096563747', new DataDotComWrapper('Geico Corporation', '', '096563747', '1', 'www.geico.com', '111-222-3333', '1 Geico Plaza', 'Washington', 'DC', 'United States', 'N',2001 ));
                searchResultsMap.put('073199531', new DataDotComWrapper('Electronic Arts', '', '073199531', '1', 'www.ea.com', '555-555-5555', '123 Anywhere', 'Redwood City', 'California', 'United States', 'N',2002));
                searchResultsMap.put('051500098', new DataDotComWrapper('Brooks Sports, Inc.', '', '051500098', '1', 'www.brooks.com', '777-777-7777', '412 Runner Way', 'Seattle', 'Washington', 'United States', 'N',2003));
                searchResultsMap.put('128484669', new DataDotComWrapper('Cast Iron Systems Inc', '', '128484669', '0', 'www.castiron.com', '321-321-3211', '921 Frontline Drive', 'Menlo Park', 'California', 'United States', 'Y',2004));
                searchResultsMap.put('206939030', new DataDotComWrapper('Salesforce.Com Canada Corporation', '', '206939030', '1', 'www.salesforce.com', '111-111-1111', '10 Bay Street', 'Toronto', 'Ontario', 'Canada', 'Other',2005));
            }
            
            //Go back through our query results and remove / filter out the ones that don't match the other user inputs,
            //since the Data.com API doesn't allow us to filter on some fields directly in the query
            for(DataDotComWrapper ddcWrap : searchResultsMap.values()) {
                okToAdd = true;
                
                //If a Country filter was applied, filter out anything that doesn't match the Country input
                if(okToAdd && countryInput != '' && countryInput.trim().length() > 0 && ddcWrap.dAndBCompanyCountry == null
                   || (ddcWrap.dAndBCompanyCountry != null && !ddcWrap.dAndBCompanyCountry.containsIgnoreCase(countryInput))) {
                       okToAdd = false;
                   }
                //If a State filter was applied, filter out anything that doesn't match the State input
                if(okToAdd && stateInput != '' && stateInput.trim().length() > 0 && ddcWrap.dAndBCompanyState == null 
                   || (ddcWrap.dAndBCompanyState != null && !ddcWrap.dAndBCompanyState.containsIgnoreCase(stateInput))) {
                       okToAdd = false;  
                   }
                
                //Provided we didn't fail any of the checks above, load the search result into the Map
                if(!okToAdd) {
                    searchResultsMap.remove(ddcWrap.dAndBCompanyDunsNumber);
                }
            }
            
            //Look for any of our Search Results that are already in Salesforce, based on their Duns Number
            Map<String, Account> dunsToCompanyMap = new Map<String, Account>();
            for(Account company : [SELECT Id, DunsNumber, CleanStatus
                                   FROM Account
                                   WHERE DunsNumber IN : searchResultsMap.keySet()]) {
                                       dunsToCompanyMap.put(company.DunsNumber, company);
                                   }
            
            //Supplement the searchResultsMap items with an indicator of which one are in Salesforce or not, so
            //we can display the Action column with the correct action
            for(DataDotComWrapper ddcWrap : searchResultsMap.values()) {
                if(dunsToCompanyMap.containsKey(ddcWrap.dAndBCompanyDunsNumber)) {
                    ddcWrap.alreadyInSalesforce = true;
                    ddcWrap.existingAccountId = dunsToCompanyMap.get(ddcWrap.dAndBCompanyDunsNumber).Id;
                }
            }
            
            //Report our status back to the page and return
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Successful query for \'' + companyNameInput + '\', ' + searchResultsMap.size() + ' results were found.'));
            displaySearchResults = true;
        }
    }
    
    //Method to support the Import function, allowing users to bring individual Account records into Salesforce from
    //Data.com by creating a new Account with the Name, DunsNumber, State, and Country information. This will ensure
    //that when the Data.com Clean job runs, it will sync these newly created records with Data.com
    public void importNewCompany() {
        Account newCompany = new Account();
        newCompany.Name = searchResultsMap.get(dunsToImport).dAndBCompanyName;
        newCompany.DunsNumber = searchResultsMap.get(dunsToImport).dAndBCompanyDunsNumber;
        newCompany.Website = searchResultsMap.get(dunsToImport).dAndBCompanyWebsite;
        newCompany.Phone = searchResultsMap.get(dunsToImport).dAndBCompanyPhone;
        newCompany.BillingStreet = searchResultsMap.get(dunsToImport).dAndBCompanyStreet;
        newCompany.BillingCity = searchResultsMap.get(dunsToImport).dAndBCompanyCity;
        newCompany.BillingState = searchResultsMap.get(dunsToImport).dAndBCompanyState;
        newCompany.BillingCountry = searchResultsMap.get(dunsToImport).dAndBCompanyCountry;
        newCompany.AnnualRevenue = searchResultsMap.get(dunsToImport).dAndBCompanyRevenue;
        insert newCompany;
        
        searchResultsMap.get(dunsToImport).alreadyInSalesforce = true;
        searchResultsMap.get(dunsToImport).existingAccountId = newCompany.Id;
    }
    
    //Method to support the Insert function, allowing users to insert a new Company record with basic information in the event
    //they cannot find a matching Company in Data.com.
    public void insertNewCompany() {
        Account newCompany = new Account();
        newCompany.Name = companyNameInput;
        if(stateInput.trim() != null && stateInput.trim() != '') {
            newCompany.BillingState = stateInput;
        }
        if(countryInput.trim() != null && countryInput.trim() != '') {
            newCompany.BillingCountry = countryInput;
        }
        
        try {
            insert newCompany;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Successfully inserted a new Company: <a target="_blank" href="/' + newCompany.Id + '">' + newCompany.Name + '</a>'));
        }
        catch(Exception exc) {
            
        }
    }
    
    //Method to support the Select function, allowing users to assign the choosen Company's Duns Number to the Company record that they
    //launched the Data.com Search UI from. This will ensure a duplicate Company isn't imported. The user is returned to view their newly
    //updated Company record after the select the match.
    public PageReference selectCompany() {
        existingCompany.DunsNumber = dunsToAssign;
        existingCompany.Name = searchResultsMap.get(dunsToAssign).dAndBCompanyName;
        existingCompany.Website = searchResultsMap.get(dunsToAssign).dAndBCompanyWebsite;
        existingCompany.Phone = searchResultsMap.get(dunsToAssign).dAndBCompanyPhone;
        existingCompany.BillingStreet = searchResultsMap.get(dunsToAssign).dAndBCompanyStreet;
        existingCompany.BillingCity = searchResultsMap.get(dunsToAssign).dAndBCompanyCity;
        existingCompany.BillingState = searchResultsMap.get(dunsToAssign).dAndBCompanyState;
        existingCompany.BillingCountry = searchResultsMap.get(dunsToAssign).dAndBCompanyCountry;
        existingCompany.AnnualRevenue = searchResultsMap.get(dunsToImport).dAndBCompanyRevenue;
        update existingCompany;
        
        PageReference pageRef = new PageReference('/' + companyIdInput);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    //Picklist values for the Location Type picklist
    public List<SelectOption> getLocationTypeOptions() {
        List<SelectOption> locationTypeOptions = new List<SelectOption>();
        locationTypeOptions.add(new SelectOption('Headquarters Only', 'Headquarters Only'));
        locationTypeOptions.add(new SelectOption('Single Locations Only', 'Single Locations Only'));
        locationTypeOptions.add(new SelectOption('HQ + Single Locations', 'HQ + Single Locations'));
        return locationTypeOptions;
    }
    
    //Picklist values for the Query Limit picklist
    public List<SelectOption> getQueryLimitOptions() {
        List<SelectOption> queryLimitOptions = new List<SelectOption>();
        queryLimitOptions.add(new SelectOption('50', '50'));
        queryLimitOptions.add(new SelectOption('100', '100'));
        queryLimitOptions.add(new SelectOption('250', '250'));
        queryLimitOptions.add(new SelectOption('500', '500'));
        return queryLimitOptions;
    }
    
    //Wrapper class to support displaying the search results to the users, along with a custom Action column based
    //on whether or not the Datacloud record is already in our Salesforce org (based on a match of DunsNumber)
    public class DataDotComWrapper {
        public String dAndBCompanyName {get; set;}
        public String dAndBCompanyTradestyle {get; set;}
        public String dAndBCompanyDunsNumber {get; set;}
        public String dAndBCompanyLocationType {get; set;}
        public String dAndBCompanyWebsite {get; set;}
        public String dAndBCompanyPhone {get; set;}
        public String dAndBCompanyStreet {get; set;}
        public String dAndBCompanyCity {get; set;}
        public String dAndBCompanyState {get; set;}
        public String dAndBCompanyCountry {get; set;}
        public String dAndBCompanyOutOfBusiness {get; set;}
        public decimal dAndBCompanyRevenue{get;set;}
        public Id existingAccountId {get; set;}
        public Boolean alreadyInSalesforce {get; set;}
        
        public DataDotComWrapper(String name, String tradestyle, String dunsNumber, String locationType, String website, 
                                 String phone, String street, String city, String state, String country, String outOfBusiness,decimal revenue) {
                                     
                                     dAndBCompanyName = name;
                                     dAndBCompanyDunsNumber = dunsNumber;
                                     dAndBCompanyTradestyle = tradestyle; 
                                     dAndBCompanyRevenue = revenue;
                                     if(locationType == '0') {
                                         dAndBCompanyLocationType = 'Single Location';
                                     }
                                     else if(locationType == '1') {
                                         dAndBCompanyLocationType = 'Headquarters/Parent';
                                     }
                                     else if(locationType == '2') {
                                         dAndBCompanyLocationType = 'Branch';
                                     }
                                     dAndBCompanyWebsite = website;
                                     dAndBCompanyPhone = phone;
                                     dAndBCompanyStreet = street;
                                     dAndBCompanyCity = city;
                                     dAndBCompanyState = state;
                                     dAndBCompanyCountry = country;
                                     
                                     if(outOfBusiness == 'Y') {
                                         dAndBCompanyOutOfBusiness = 'Yes';
                                     }
                                     else if(outOfBusiness == 'N') {
                                         dAndBCompanyOutOfBusiness = 'No';
                                     }
                                     else {
                                         dAndBCompanyOutOfBusiness = outOfBusiness;
                                     }
                                     
                                     alreadyInSalesforce = false;
                                 }
    }
}