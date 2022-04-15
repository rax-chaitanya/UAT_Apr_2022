/************************************************************************************************************************************
 * Class Name : CompanyCustomEditWebservice
 * Author : Matthew Lamb
 * Creation Date : October 2015
 * Purpose : The Salesbroom team, who is responsible for aligning our Account data to Companies, needs to be able to edit a few
 * 			 elements on the Accounts, even though they have Chatter licenses. This web service supports the CompanyCustomEdit
 * 			 Visualforce page and performs the actual DML operations in order to save the Account records. A blank string is
 *			 returned if the save succeeds, otherwise the error message is returned so it can be displayed to the user.
 ************************************************************************************************************************************/

 global class CompanyCustomEditWebservice {

	webservice static String saveCompany(CompanyCustomEditWrapper companyWrap){
		String response = '';

		Account companyToUpdate = new Account();
		companyToUpdate.Id = companyWrap.companyId;
		companyToUpdate.Name = companyWrap.companyName;
		companyToUpdate.Company_Review_Status__c = companyWrap.companyReviewStatus;
		companyToUpdate.Escalation_Notes__c = companyWrap.companyEscalationNotes;
		companyToUpdate.Phone = companyWrap.companyPhone;
		companyToUpdate.Website = companyWrap.companyWebsite;
		companyToUpdate.DunsNumber = companyWrap.companyDUNS;
		companyToUpdate.jsImpacts__Data_com_does_not_auto_update__c = companyWrap.companyDataDotComDoesNotUpdate;

		companyToUpdate.BillingStreet = companyWrap.companyBillingStreet;
		companyToUpdate.BillingCity = companyWrap.companyBillingCity;
		companyToUpdate.BillingState = companyWrap.companyBillingState;
		companyToUpdate.BillingPostalCode = companyWrap.companyBillingZip;
		companyToUpdate.BillingCountry = companyWrap.companyBillingCountry;

		companyToUpdate.ShippingStreet = companyWrap.companyShippingStreet;
		companyToUpdate.ShippingCity = companyWrap.companyShippingCity;
		companyToUpdate.ShippingState = companyWrap.companyShippingState;
		companyToUpdate.ShippingPostalCode = companyWrap.companyShippingZip;
		companyToUpdate.ShippingCountry = companyWrap.companyShippingCountry;

		try {
			update companyToUpdate;
		}
		catch(Exception exc) {
			response = exc.getMessage();
		}

		return response;
	}
}