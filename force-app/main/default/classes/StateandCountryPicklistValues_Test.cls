/*		Designer Name & Reviewer 		DeveloperName 			US							 		Project 				Test Class  - Coverage 						Description 
* 		Seshagiri Bandila 				Shravan Godha 	https://jira.rax.io/browse/SFDC-5826		ACE CRM			StateandCountryPicklistValues_Test -  %		Mulesoft will call this Apex Method to validate the state picklist in Salesforce From AWS  
*/
@isTest
public class StateandCountryPicklistValues_Test {
    static testMethod void testPost() {
        List<Lead> leads = new List<Lead>();
        Lead l1     = new Lead(phone='12345',title='CEO',lastname='TestLN1',company='TestComp1',APN_CRM_Unique_Identifier__c='L80000');
        Lead l2     = new Lead(phone='123456',title='CEO',lastname='TestLN2',company='TestComp1',APN_CRM_Unique_Identifier__c='L90000');
        leads.add(l1);
        leads.add(l2);
        insert leads;
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/StateCountryValues/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
        list<string> CountryStateLabel = new list<string>();
        String t = 'United States||CALIFORNIA';
        String t1 = 'United States||FL';
        String t2 = 'United States||Test';
        String t3 = 'India||FL';
        String t4 = 'Test||Test';
        String t5 = 'US||FL';
        CountryStateLabel.add(t);
        CountryStateLabel.add(t1);
        CountryStateLabel.add(t2);
        CountryStateLabel.add(t3);
        CountryStateLabel.add(t4);
        CountryStateLabel.add(t5);
        test.startTest();
        StateandCountryPicklistValues.CountryStateValues(CountryStateLabel);
        test.stopTest();
    }
    
    
}