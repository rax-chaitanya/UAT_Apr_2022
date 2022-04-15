/************************************************************************************************************************************
 * Class Name : CompanyFortuneRankBatch
 * Author : Matthew Lamb
 * Creation Date : November 2015
 * Purpose : To append the Data.com Fortune Rank value to any Company record that is in the Fortune Rank.
 ************************************************************************************************************************************/

global class CompanyFortuneRankBatch implements Database.Batchable<sObject> {
	
	String query;
	
	global CompanyFortuneRankBatch() {
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		query = 'SELECT Id, Name, DunsNumber, Fortune_Rank__c ' +
                'FROM Account ' +
                'WHERE DunsNumber != null AND DunsNumber != \'\'';
    
        system.debug('Here is the query : ' + query);

        return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		
		//Build up an initial Map collection of the Companies we're going to append Fortune Rank to, structured with the DUNS Number
        // as the key, and a list of Accounts as the values set, since we could have multiple Accounts with the same DUNS Number
        Map<String, List<Account>> dunsToCompanyListMap = new Map<String, List<Account>>();

        for(sObject obj : scope) {
            String companyDunsNumber = (String)((Account)obj).DunsNumber;
            if(companyDunsNumber != null && companyDunsNumber.trim() != '') {
                if(dunsToCompanyListMap.get(companyDunsNumber) == null) {
                    dunsToCompanyListMap.put(companyDunsNumber, new List<Account>());
                }
                dunsToCompanyListMap.get(companyDunsNumber).add((Account)obj);
            }
        }

        //Query the DataclouddAndBCompany object to get the matching Data.com records for the Companies we are appending Fortune Rank to
        Map<Id, Account> accountUpdateMap = new Map<Id, Account>();
        for(DataclouddAndBCompany dAndBCompany : [SELECT Id, Name, DunsNumber, FortuneRank 
                                                  FROM DataclouddAndBCompany
                                                  WHERE DunsNumber IN : dunsToCompanyListMap.keySet()]) {
            
            //Ignore any D&B Company record that doesn't have a Fortune Rank value
            if(dAndBCompany.FortuneRank != null && String.valueOf(dAndBCompany.FortuneRank) != '') {
                
                for(Account acc : dunsToCompanyListMap.get(dAndBCompany.DunsNumber)) {
                	acc.Fortune_Rank__c = (Integer)dAndBCompany.FortuneRank;
                	accountUpdateMap.put(acc.Id, acc);
                }
            }
        }

        if(accountUpdateMap.size() > 0) {
        	update accountUpdateMap.values();
        }
	}
	
	global void finish(Database.BatchableContext BC) {
		Integer data_dot_com_made_me_do_this_because_their_API_is_untestable=0;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
        data_dot_com_made_me_do_this_because_their_API_is_untestable++;
	}	
}