/************************************************************************************************************************************
 * Class Name : DataDotComSearchController_Test
 * Author : Matthew Lamb
 * Creation Date : October 2015
 * Purpose : Test class associated with the DataDotComSearchController class, which provides the functionality for the DataDotComSearch
 *           Visualforce page. Since the Data.com APIs do not provide any mechanism to sufficiently test, or mock query results for,
 *           queries to the DataclouddAndBCompany object, this test case is light on actual asserts. This should be revisited upon
 *           further feature releases from Salesforce so this can be corrected and proper testing patterns written here.
 ************************************************************************************************************************************/

@isTest
private class DataDotComSearchController_Test {
    
    private static PageReference pageRef;
    private static DataDotComSearchController controller;

    private static String queryStringName;
    private static String queryStringId;

      @TestSetUp
    static void setTestData(){
       TestClassUtility.setTestSetupData();
    }
    //Positive test scenario in which the page is loaded successfully, and the user enters a query for a company name
    @isTest static void SuccessfulQuery_HQOnly_AllMatches() {
        insertTestData();
        initializePage();
        
        //Verify that the search results panel isn't yet visible, and the default query limit is in place
        system.assertEquals(controller.displaySearchResults, false);
        system.assertEquals(controller.queryLimitInput, '100');

        //Simulate a search by setting a search string to the companyNameInput and calling the search() method
        controller.companyNameInput = 'Test Company';
        controller.locationTypeInput = 'Headquarters Only';
        controller.search();

        //Assert that the search was successful, and that our 5 mock search results have been displayed to the user
        //Note that the locationTypeInput cannot be truly tested now given that we're mocking the search results
        system.assertEquals(controller.displaySearchResults, true);
        system.assertEquals(controller.searchResultsMap.size(), 5);
    }

    //Positive test scenario in which the page is loaded successfully, and the search is automatically run from the URL parameter
    @isTest static void SuccessfulQuery_FromQueryString() {
        insertTestData();
        initializePageWithQueryString();
        
        //Verify that the search results panel is already visible, and the companyNameInput is already provided, from the URL
        system.assertEquals(controller.displaySearchResults, true);
        system.assertEquals(controller.companyNameInput, 'Geico Corporation');

        //Assert that the search was successful, and that our 5 mock search results have been displayed to the user
        system.assertEquals(controller.displaySearchResults, true);
        system.assertEquals(controller.searchResultsMap.size(), 5);

        //Mock the selection of one of the search results
        controller.dunsToAssign = '128484669';
        controller.dunsToImport  = '128484669';    
        controller.selectCompany();

        //Verify that the record has been updated with the selected search result's details
        List<Account> companyList = [SELECT Id, DunsNumber FROM Account WHERE Id =: queryStringId];
        system.assertEquals(companyList.size(), 1);
        system.assertEquals(companyList[0].DunsNumber, '128484669');
    }

    //Positive test scenario that looks for both HQ & Single Locations that are in California
    @isTest static void SuccessfulQuery_HQandSingle_California() {
        insertTestData();
        initializePage();
        
        //Verify that the search results panel isn't yet visible, and the default query limit is in place
        system.assertEquals(controller.displaySearchResults, false);
        system.assertEquals(controller.queryLimitInput, '100');

        //Simulate a search by setting a search string to the companyNameInput and calling the search() method
        controller.companyNameInput = 'Test Company';
        controller.stateInput = 'California';
        controller.locationTypeInput = 'HQ + Single Locations';
        controller.search();
        

        //Assert that the search was successful, and that 2 matching mock search results have been displayed to the user
        system.assertEquals(controller.displaySearchResults, true);
        system.assertEquals(controller.searchResultsMap.size(), 2);
    }

    //Positive test scenario that looks for only Single Locations that are in the United States
    @isTest static void SuccessfulQuery_SingleOnly_UnitedStates() {
        insertTestData();
        initializePage();
        
        //Verify that the search results panel isn't yet visible, and the default query limit is in place
        system.assertEquals(controller.displaySearchResults, false);
        system.assertEquals(controller.queryLimitInput, '100');

        //Simulate a search by setting a search string to the companyNameInput and calling the search() method
        controller.companyNameInput = 'Test Company';
        controller.countryInput = 'United States';
        controller.locationTypeInput = 'Single Locations Only';
        controller.search();

        //Assert that the search was successful, and that 4 results from the United States are displayed. This is because the 
        //Location Type input can't truly be tested in our test scenario since the results are being mocked.
        system.assertEquals(controller.displaySearchResults, true);
        system.assertEquals(controller.searchResultsMap.size(), 4);
    }

    //Positive test scenario that runs a successful search, and imports one of the records into Salesforce
    @isTest static void SuccessfulQuery_ThenImport() {
        insertTestData();
        initializePage();
        
        //Verify that the search results panel isn't yet visible, and the default query limit is in place
        system.assertEquals(controller.displaySearchResults, false);
        system.assertEquals(controller.queryLimitInput, '100');

        //Simulate a search by setting a search string to the companyNameInput and calling the search() method
        controller.companyNameInput = 'Test Company';
        controller.search();

        //Assert that the search was successful, and that our 5 mock search results have been displayed to the user
        system.assertEquals(controller.displaySearchResults, true);
        system.assertEquals(controller.searchResultsMap.size(), 5);

        //Set the value of the dunsToImport parameter (which is normally set by clicking one of the Import buttons), then 
        //call the importNewCompany method to simulate clicking the import button
        controller.dunsToImport = '128484669';
        controller.importNewCompany();

        //Assert that Cast Iron Systems was inserted into Salesforce from the searchResultsMap
        List<Account> companyList = [SELECT Id, Name, DunsNumber FROM Account WHERE DunsNumber = '128484669'];
        system.assertEquals(companyList.size(), 1);
    }

    //Negative test scenario in which the page is loaded successfully, and the user clicks Search before entering a Company Name
    @isTest static void SearchWithNoCompanyName() {
        initializePage();

        //Verify that the search results panel isn't yet visible, and the default query limit is in place
        system.assertEquals(controller.displaySearchResults, false);
        system.assertEquals(controller.queryLimitInput, '100');

        //Simulate a search by setting a search string to the companyNameInput and then calling the search() method
        controller.companyNameInput = '';
        controller.search();

        //Assert that the page reacted correctly and the user has been shown an error message
        List<ApexPages.Message> pageMessages = ApexPages.getMessages();
        system.assertNotEquals(0, pageMessages.size());
    }

    //Positive test scenario in which the page is loaded successfully, a search is performed, and then the Insert function is used
    @isTest static void InsertCompanyAfterSearching() {
        initializePage();

        //Verify that the search results panel isn't yet visible, the default query limit is in place, and searchCompleted is initially false
        system.assertEquals(controller.displaySearchResults, false);
        system.assertEquals(controller.queryLimitInput, '100');
        system.assertEquals(controller.searchCompleted, false);

        //Simulate a search by setting a search string to the companyNameInput and then calling the search() method
        controller.companyNameInput = 'Hello World';
        controller.search();
        controller.stateInput='California';
        controller.countryInput='United States';
        //Assert that the search has been completed, which means the Add to Salesforce button is now shown to the user, then click that button
        system.assertEquals(controller.searchCompleted, true);
        controller.insertNewCompany();

        //Verify that the Company record was inserted correctly
        List<Account> companyList = [SELECT Id, Name, DunsNumber FROM Account WHERE Name = 'Hello World'];
        //system.assertEquals(companyList.size(), 1);
    }

    //Helper method to make all the calls necessary to initialize the page
    private static void initializePage() {
        //Set up the PageReference with our newly inserted Company, and instantiate the Controller, to simulate loading the page
        pageRef = new PageReference('/apex/DataDotComSearch');
        Test.setCurrentPage(pageRef);
        controller = new DataDotComSearchController();
        controller.getLocationTypeOptions();
        controller.getQueryLimitOptions();
    }

    //Helper method to make all the calls necessary to initialize the page
    private static void initializePageWithQueryString() {
        //Set up the PageReference with our newly inserted Company, and instantiate the Controller, to simulate loading the page
        pageRef = new PageReference('/apex/DataDotComSearch?companyname=' + queryStringName + '&companyid=' + queryStringId);
        Test.setCurrentPage(pageRef);
        controller = new DataDotComSearchController();
        controller.getLocationTypeOptions();
        controller.getQueryLimitOptions();
    }

    //Helper method to insert some Accounts that match our mock data set
    private static void insertTestData() {
         
        List<Account> newCompanies = new List<Account>();
        Account newCompany = TestDataHelper.createTestCompany();
        newCompany.Name = 'Geico Corporation';
        newCompany.DunsNumber = '096563747';
        newCompany.BillingState = 'California';
        newCompany.BillingCountry = 'United States';
        newCompanies.add(newCompany);

        newCompany = TestDataHelper.createTestCompany();
        newCompany.Name = 'Electronic Arts';
        newCompany.DunsNumber = '073199531';
        newCompany.BillingState = 'California';
        newCompany.BillingCountry = 'United States';
        newCompanies.add(newCompany);
        
        newCompany = TestDataHelper.createTestCompany();
        newCompany.Name = 'Electronic';
        newCompany.DunsNumber = '073199533';
        newCompany.BillingState = 'California';
        newCompany.BillingCountry = 'United States';
        newCompanies.add(newCompany);

        insert newCompanies;

        queryStringName = newCompanies[0].Name;
        queryStringId = newCompanies[0].Id;
    }
}