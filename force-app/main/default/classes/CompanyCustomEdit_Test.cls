/************************************************************************************************************************************
 * Class Name : CompanyCustomEdit_Test
 * Author : Matthew Lamb
 * Creation Date : October 2015
 * Purpose : Test class associated with the CompanyCustomEditController class, as well as the CompanyCustomEditWrapper and 
 * 			 CompanyCustomEditWebservice, all of which support the CompanyCustomEdit Visualforce page. 5 test classes are included 
 * 			 and properly test and assert all possible interactions within the custom Edit page.
 ************************************************************************************************************************************/

 @isTest
private class CompanyCustomEdit_Test {
	
    @TestSetUp
    static void setTestData(){
       TestClassUtility.setTestSetupData();
    }
	public static Account newCompany {get; set;}

	//Positive test scenario in which the page is provided a usable Id parameter, loads correctly, and is able to process
	//an edit to the record successfully and finally return to the standard Account page of that record
	@isTest static void SuccessfulEdit() {
		initializeData();

		//Set up the PageReference with our newly inserted Company, and instantiate the Controller, to simulate loading the page
		PageReference pageRef = new PageReference('/apex/CompanyCustomEdit?Id=' + newCompany.Id);
		Test.setCurrentPage(pageRef);
		CompanyCustomEditController controller = new CompanyCustomEditController();

        List<SelectOption> options = controller.getCompanyReviewStatusOptions();
		//Assert that the page loaded correctly (i.e. that the number of pageMessages is = 0)
		List<ApexPages.Message> pageMessages = ApexPages.getMessages();
		system.assertEquals(0, pageMessages.size());

		//Assert that the Account record that was inserted does not have a Duns Number equal to the number we will use in our test
		List<Account> accountList = [SELECT Id, Name, DunsNumber
									 FROM Account
									 WHERE Id =: newCompany.Id];
		system.assertNotEquals(accountList[0].DunsNumber, '096563747');

		//Edit some fields about the record
		controller.companyWrap.companyDUNS = '096563747';

		//Simulate clicking the Cancel button after the page has loaded
		PageReference result = controller.save();
		Test.setCurrentPage(result);

		//Assert that we returned to the standard Account page for the record we started with
		String currentURL = ApexPages.currentPage().getURL().substring(1);
		system.assertEquals(currentURL, newCompany.Id);

		//Verify that the update to the record was saved correctly and the new Duns Number is present
		accountList = [SELECT Id, Name, DunsNumber
					   FROM Account
					   WHERE Id =: newCompany.Id];
		system.assertEquals(accountList[0].DunsNumber, '096563747');
	}
	
	//Positive test scenario in which the page is provided a usable Id parameter, loads correctly, and then immediately
	//is cancelled by clicking the Cancel button, thus redirecting the user to the Account page
	@isTest static void SuccessfulLoadThenCancel() {
		initializeData();

		//Set up the PageReference with our newly inserted Company, and instantiate the Controller, to simulate loading the page
		PageReference pageRef = new PageReference('/apex/CompanyCustomEdit?Id=' + newCompany.Id);
		Test.setCurrentPage(pageRef);
		CompanyCustomEditController controller = new CompanyCustomEditController();

		//Assert that the page loaded correctly (i.e. that the number of pageMessages is = 0)
		List<ApexPages.Message> pageMessages = ApexPages.getMessages();
		system.assertEquals(0, pageMessages.size());

		//Simulate clicking the Cancel button after the page has loaded
		PageReference result = controller.cancel();
		Test.setCurrentPage(result);

		//Assert that we returned to the standard Account page for the record we started with
		String currentURL = ApexPages.currentPage().getURL().substring(1);
		system.assertEquals(currentURL, newCompany.Id);
	}

	//Negative test scenario in which the page is provided a usable Id parameter, loads correctly, but is then provided with a Duns
	//Number that is too long and will cause the Save operation to fail. Verify that the error message is presented to the user
	@isTest static void SuccessfulLoadBadUpdate() {
		initializeData();

		//Set up the PageReference with our newly inserted Company, and instantiate the Controller, to simulate loading the page
		PageReference pageRef = new PageReference('/apex/CompanyCustomEdit?Id=' + newCompany.Id);
		Test.setCurrentPage(pageRef);
		CompanyCustomEditController controller = new CompanyCustomEditController();

		//Assert that the page loaded correctly (i.e. that the number of pageMessages is = 0)
		List<ApexPages.Message> pageMessages = ApexPages.getMessages();
		system.assertEquals(0, pageMessages.size());

		//Edit some fields about the record, and violate a known limitation (i.e. the DunsNumber field is only 9 characters in length)
		controller.companyWrap.companyDUNS = '0965637479913050';

		//Simulate clicking the Cancel button after the page has loaded
		PageReference result = controller.save();
		
		//Assert that the save function returned a null, that an error message has been presented, and that we didn't return to the Company
		system.assertEquals(result, null);
		pageMessages = ApexPages.getMessages();
		system.assertNotEquals(0, pageMessages.size());
		String currentURL = ApexPages.currentPage().getURL().substring(1);
		system.assertNotEquals(currentURL, newCompany.Id);
	}

	//Negative test scenario in which the page is provided a correctly named Id paramter, but no value for that parameter. Verify that the
	//page responds by displaying an error message to the user
	@isTest static void AccessPageWithNoId() {
		initializeData();

		//Set up the PageReference with our newly inserted Company, and instantiate the Controller, to simulate loading the page
		PageReference pageRef = new PageReference('/apex/CompanyCustomEdit?Id=');
		Test.setCurrentPage(pageRef);
		CompanyCustomEditController controller = new CompanyCustomEditController();

		//Assert that the page didn't load correctly (i.e. that the number of pageMessages is > 0) since we didn't actually pass in an Id value
		List<ApexPages.Message> pageMessages = ApexPages.getMessages();
		system.assertNotEquals(0, pageMessages.size());
	}

	//Negative test scenario in which the page is provided a badly named Id paramter, but one that has a correct Id value. Verify that the
	//page responds by displaying an error message to the user
	@isTest static void AccessPageWithBadParameter() {
		initializeData();

		//Set up the PageReference with our newly inserted Company, and instantiate the Controller, to simulate loading the page
		PageReference pageRef = new PageReference('/apex/CompanyCustomEdit?EyeDee=');
		Test.setCurrentPage(pageRef);
		CompanyCustomEditController controller = new CompanyCustomEditController();

		//Assert that the page didn't load correctly (i.e. that the number of pageMessages is > 0) since we didn't actually pass in an Id value
		List<ApexPages.Message> pageMessages = ApexPages.getMessages();
		system.assertNotEquals(0, pageMessages.size());
	}

	//Helper method to set up a single test Account record
	private static void initializeData() {
        //Initialize a test Account
        newCompany = TestDataHelper.createTestCompany();
        newCompany.Name = 'Geico Corporation';
        //newCompany.DunsNumber = '';
        newCompany.BillingCountry = 'United States';
        insert newCompany;
    }
}