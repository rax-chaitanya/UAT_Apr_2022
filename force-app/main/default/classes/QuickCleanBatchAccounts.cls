/************************************************************************************************************************************
 * Class Name : CompanyFortuneRankBatch
 * Author : Matthew Lamb
 * Creation Date : November 2015
 * Purpose : To append the Data.com Fortune Rank value to any Company record that is in the Fortune Rank.
 ************************************************************************************************************************************/

global class QuickCleanBatchAccounts implements Database.Batchable<sObject> {
    
    String query;
    
    global QuickCleanBatchAccounts() {
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Set<String> countries = new set<string>();
        countries.add('United States');
        //countries.add('United Kingdom');
        query = 'select BillingCountry, BillingState from Account where BillingState != null order by BillingState';
 
        system.debug('Here is the query : ' + query);

        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        list<Account> companies = new list<Account>();
        
        for (Account a : (List<Account>) scope) {
            a.BillingState = 'Texas';
            a.BillingCountry = 'United States';
            companies.add(a);
        }
        
        update companies;
        
        

    }
    
    global void finish(Database.BatchableContext BC) {
    
    }   
}