/************************************************************************************************************************************
 * Class Name : CompanyFortuneRankBatch
 * Author : Matthew Lamb
 * Creation Date : November 2015
 * Purpose : To append the Data.com Fortune Rank value to any Company record that is in the Fortune Rank.
 ************************************************************************************************************************************/

global class QuickCleanBatch implements Database.Batchable<sObject> {
	
	String query;
	
	global QuickCleanBatch() {
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
        Set<String> countries = new set<string>();
        countries.add('United States');
        //countries.add('United Kingdom');
		//query = 'select id, billingstate, shippingstate from account where billingstate != \'Texas\' and billingstate != null order by billingstate';
    	query = 'select id, state, mailingstate, mailingcountry from dandbcompany where state != null or mailingstate != null';
        system.debug('Here is the query : ' + query);

        return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
        list<DandBCompany> companies = new list<DandBCompany>();
        
        for (DandBCompany db : (List<DandBCompany>) scope) {
            db.MailingState = 'Texas';
            db.State = 'Texas';
            companies.add(db);
        }
        
        /*
        for (Account a : (List<Account>) scope) {
            a.BillingState = 'Texas';
            a.ShippingState = 'Texas';
            a.BillingCountry = 'United States';
            a.ShippingCountry = 'United States';
            companies.add(a);
        }
        */
        update companies;
        
        

	}
	
	global void finish(Database.BatchableContext BC) {
	
	}	
}