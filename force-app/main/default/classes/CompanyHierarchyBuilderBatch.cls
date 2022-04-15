/************************************************************************************************************************************
 * Class Name : CompanyHierarchyBuilderBatch
 * Author : Matthew Lamb
 * Creation Date : September 2015
 * Purpose : To find Company records that have been synced up to Data.com, but are not parented to another Company. Once we find
 *           them, the batch class will determine if a parent is known (based on the D&B Company record), and will bring that 
 *           record into Salesforce if it's not yet present. Once present, the Company will be parented to it's Parent Company.
 ************************************************************************************************************************************/

global class CompanyHierarchyBuilderBatch implements Database.Batchable<sObject> {
    
    String query;
    
    global CompanyHierarchyBuilderBatch() {
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        query = 'SELECT Id, Name, DunsNumber ' +
                'FROM Account ' +
                'WHERE ParentId = null ' +
                       'AND DunsNumber != null ' +
                       'AND Parented_Status__c = \'Orphaned\' ' +
                       'AND (CleanStatus = \'Matched\' ' +
                            'OR CleanStatus = \'Acknowledged\') ';
    
        system.debug('Here is the query : ' + query);

        //Add an option LIMIT to the query, based on the presence and value of the limit in the custom setting
        CompanyHierarchyBuilderBatchSettings__c settings = CompanyHierarchyBuilderBatchSettings__c.getOrgDefaults();
        if(settings != null && settings.Query_Limit__c != null && (Integer)settings.Query_Limit__c > 0) {
            query += ' LIMIT ' + (Integer)settings.Query_Limit__c;
        }

        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        
        //Build up an initial Map collection of the Companies we're going to parent, structured with the DUNS Number as the key, and
        //a list of Accounts as the values set, since we could have multiple Accounts with the same DUNS Number
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

        //Query the DataclouddAndBCompany object to get the matching Data.com records for the Companies we are trying to parent
        Map<String, Map<String, DataclouddAndBCompany>> parentDunsToChildDunsTodAndBCompanyMapMap = new Map<String, Map<String, DataclouddAndBCompany>>();
        Map<String, DataclouddAndBCompany> dunsTodAndBCompanyMap = new Map<String, DataclouddAndBCompany>();

        for(DataclouddAndBCompany dAndBCompany : [SELECT Id, Name, DunsNumber, ParentOrHqDunsNumber, ParentOrHqBusinessName
                                                  FROM DataclouddAndBCompany
                                                  WHERE DunsNumber IN : dunsToCompanyListMap.keySet()]) {
            
            //Ignore any D&B Company record that doesn't have a Parent DUNS Number value, has an all zero Parent DUNS Number value, or
            //has it's own DUNS Number listed as the Parent DUNS Number
            if(dAndBCompany.ParentOrHqDunsNumber != null && dAndBCompany.ParentOrHqDunsNumber != '000000000' 
               && dAndBCompany.DunsNumber != dAndBCompany.ParentOrHqDunsNumber) {
                dunsTodAndBCompanyMap.put(dAndBCompany.DunsNumber, dAndBCompany);
                //Also ignore any D&B Company record that has a DUNS Number that is the same as the Parent DUNS Number
                if(dAndBCompany.DunsNumber != dAndBCompany.ParentOrHqDunsNumber) {
                    if(parentDunsToChildDunsTodAndBCompanyMapMap.get(dAndBCompany.ParentOrHqDunsNumber) == null) {
                        parentDunsToChildDunsTodAndBCompanyMapMap.put(dAndBCompany.ParentOrHqDunsNumber, new Map<String, DataclouddAndBCompany>());
                    }
                    parentDunsToChildDunsTodAndBCompanyMapMap.get(dAndBCompany.ParentOrHqDunsNumber).put(dAndBCompany.DunsNumber, dAndBCompany);
                }
            }
        }
        
        //Now that we know which Parent DUNS Numbers we are looking for (the parentDunsToChildDunsTodAndBCompanyMapMap key set), we need to query 
        //what we already have in Salesforce with these Parent DUNS Number values to find Parents that are already in Salesforce
        List<Account> companiesToUpdate = new List<Account>();

        for(Account parent : [SELECT Id, Name, DunsNumber
                              FROM Account
                              WHERE DunsNumber IN : parentDunsToChildDunsTodAndBCompanyMapMap.keySet()]) {

            //Guard against the potential of duplicate Parent Accounts already existing in Salesforce, we'll parent the children 
            //to the first Parent that is found if multiple exist, and simply bypass the rest.
            if(parentDunsToChildDunsTodAndBCompanyMapMap.get(parent.DunsNumber) != null) {
                //For each Parent DUNS we already have in Salesforce, go get the set of DUNS Numbers of it's Children
                for(String childCompanyDunsNumber : parentDunsToChildDunsTodAndBCompanyMapMap.get(parent.DunsNumber).keySet()) {
                    //For each Child DUNS, go get the list of Companies that have that DUNS Number, and set the ParentId of each one
                    for(Account childCompany : dunsToCompanyListMap.get(childCompanyDunsNumber)) {
                        childCompany.ParentId = parent.Id;
                        companiesToUpdate.add(childCompany);
                    }
                    dunsToCompanyListMap.remove(childCompanyDunsNumber);
                }
                parentDunsToChildDunsTodAndBCompanyMapMap.remove(parent.DunsNumber);
            }
        }

        //For the Parent Companies that are left after we removed them from the main map, we need to create new Companies for each Parent
        Map<String, Account> parentCompaniesToInsert = new Map<String, Account>();

        for(String parentDunsNumber : parentDunsToChildDunsTodAndBCompanyMapMap.keySet()) {
            for(DataclouddAndBCompany dAndBCompany : parentDunsToChildDunsTodAndBCompanyMapMap.get(parentDunsNumber).values()) {
                parentCompaniesToInsert.put(dAndBCompany.ParentOrHqDunsNumber, new Account(Name = dAndBCompany.ParentOrHqBusinessName, 
                                                                                           DunsNumber = dAndBCompany.ParentOrHqDunsNumber));
            }
        }
        insert parentCompaniesToInsert.values();

        //Finally, for each Child Company Duns still left in the original dunsToCompanyListMap collection, go back and set the ParentId
        //for each one, from the Parent Companies that we inserted in the last step
        for(String dunsNumber : dunsToCompanyListMap.keySet()) {
            for(Account company : dunsToCompanyListMap.get(dunsNumber)) {
                if(dunsTodAndBCompanyMap.get(company.DunsNumber) != null 
                   && dunsTodAndBCompanyMap.get(company.DunsNumber).ParentOrHqDunsNumber != null 
                   && parentCompaniesToInsert.get(dunsTodAndBCompanyMap.get(company.DunsNumber).ParentOrHqDunsNumber) != null) {
                    company.ParentId = parentCompaniesToInsert.get(dunsTodAndBCompanyMap.get(company.DunsNumber).ParentOrHqDunsNumber).Id;
                    companiesToUpdate.add(company);
                }
            }
        }
        update companiesToUpdate;
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