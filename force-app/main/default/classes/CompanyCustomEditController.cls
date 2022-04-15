/************************************************************************************************************************************
 * Class Name : CompanyCustomEditController
 * Author : Matthew Lamb
 * Creation Date : October 2015
 * Purpose : The Salesbroom team, who is responsible for aligning our Account data to Companies, needs to be able to edit a few
 * 			 elements on the Accounts, even though they have Chatter licenses. This controller supports the CompanyCustomEdit
 * 			 Visualforce page and provides the necessary functionality for the Salesbroom team.
 ************************************************************************************************************************************/

 public without sharing class CompanyCustomEditController {
	
	public CompanyCustomEditWrapper companyWrap {get; set;}
	private Id companyId {get; set;}
	public Boolean showThePage {get; set;}

	public static final String genericErrorMessage = 'Something went wrong. Please go back to the Company and try again.';
	public static final String idParamName = 'Id';

	//Constructor for the page to, on load, fetch the Id parameter, get the specified record, and initiatlize the page
	public CompanyCustomEditController() {
		try{
			companyId = ApexPages.CurrentPage().getParameters().get(idParamName);

			List<Account> companyList = [SELECT Id, Name, Company_Review_Status__c, Escalation_Notes__c, Phone, Website, 
												DunsNumber, jsImpacts__Data_com_does_not_auto_update__c,
												BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,
												ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry
										 FROM Account
										 WHERE Id =: companyId];
			if(companyList.size() == 1) {
				companyWrap = new CompanyCustomEditWrapper(companyList[0]);
				showThePage = true;
			}
			else {
				showThePage = false;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, genericErrorMessage));
			}
		}
		catch(Exception exc) {
			showThePage = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, genericErrorMessage));
		}
	}

	//Method to support the Cancel button on the VF page. Simply redirect to the standard Account page for 
	//the value that was passed in through the URL's Id parameter
	public PageReference cancel() {
		PageReference pageRef = new PageReference('/' + companyId);
		pageRef.setRedirect(true);
		return pageRef;
	}

	//Method to support the Save button on the VF page. Execute the save by calling over to the CompanyCustomEditWebservice (which 
	//is required since the Salesbroom user's profiles don't have CRUD access to the Account object, then redirecting to the Account
	//page for the value that was passed in through the URL's Id parameter
	public PageReference save() {
		String result = CompanyCustomEditWebservice.saveCompany(companyWrap);

		//Provided that the web service didn't return an error message, go back to the Account
		if(result == '') {
			PageReference pageRef = new PageReference('/' + companyId);
			pageRef.setRedirect(true);
			return pageRef;
		}
		
		return null;
	}

	//Picklist values for the Company Review Status picklist
	public List<SelectOption> getCompanyReviewStatusOptions() {
		List<SelectOption> companyReviewStatusOptions = new List<SelectOption>();
		
		companyReviewStatusOptions.add(new SelectOption('None','--None--'));
		Schema.DescribeFieldResult fieldResult = Account.Company_Review_Status__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	    
	    for(Schema.PicklistEntry p : ple) {
	        companyReviewStatusOptions.add(new SelectOption(p.getValue(), p.getValue()));
	    }

	    return companyReviewStatusOptions;
	}
}