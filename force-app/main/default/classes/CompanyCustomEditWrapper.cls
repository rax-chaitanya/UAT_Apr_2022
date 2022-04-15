/************************************************************************************************************************************
 * Class Name : CompanyCustomEditWrapper
 * Author : Matthew Lamb
 * Creation Date : October 2015
 * Purpose : The Salesbroom team, who is responsible for aligning our Account data to Companies, needs to be able to edit a few
 *           elements on the Accounts, even though they have Chatter licenses. This wrapper class supports the CompanyCustomEdit
 *           Visualforce page by providing a flexible collection of data that is passed to the Web Service for update.
 ************************************************************************************************************************************/

global class CompanyCustomEditWrapper {

    global Id companyId {get; set;}
    global String companyName {get; set;}
    global String companyReviewStatus {get; set;}
    global String companyEscalationNotes {get; set;}
    global String companyPhone {get; set;}
    global String companyWebsite {get; set;}
    global String companyDUNS {get; set;}
    global Boolean companyDataDotComDoesNotUpdate {get; set;}

    global String companyBillingStreet {get; set;}
    global String companyBillingCity {get; set;}
    global String companyBillingState {get; set;}
    global String companyBillingZip {get; set;}
    global String companyBillingCountry  {get; set;}

    global String companyShippingStreet {get; set;}
    global String companyShippingCity {get; set;}
    global String companyShippingState {get; set;}
    global String companyShippingZip {get; set;}
    global String companyShippingCountry {get; set;}

    global CompanyCustomEditWrapper(Account company) {
        companyId = company.Id;
        companyName = company.Name;
        companyReviewStatus = company.Company_Review_Status__c;
        companyEscalationNotes = company.Escalation_Notes__c;
        companyPhone = company.Phone;
        companyWebsite = company.Website;
        companyDUNS = company.DunsNumber;
        companyDataDotComDoesNotUpdate = company.jsImpacts__Data_com_does_not_auto_update__c;

        companyBillingStreet = company.BillingStreet;
        companyBillingCity = company.BillingCity;
        companyBillingState = company.BillingState;
        companyBillingZip = company.BillingPostalCode;
        companyBillingCountry = company.BillingCountry;

        companyShippingStreet = company.ShippingStreet;
        companyShippingCity = company.ShippingCity;
        companyShippingState = company.ShippingState;
        companyShippingZip = company.ShippingPostalCode;
        companyShippingCountry = company.ShippingCountry;
    }
}