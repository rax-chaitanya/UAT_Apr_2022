/*
* Name: CohortRectificationBatch
* Created On: 1 Feb 2022
* Author: Mrinal Tripathi (mrinal.tripathi@rackspace.com)
* Description: Batch process to correctly update the cohort month on contacts
*/
global class CohortRectificationBatch implements Database.Batchable<sObject> {
    
    // Custom settting which drives the batch query and status of the logic
    Cohort_Calculation_Settings__c CS = Cohort_Calculation_Settings__c.getInstance(UserInfo.getOrganizationId());
    
    // Map to maintain email Id with min created date of contacts to be updated
    Map<String, datetime> emailWithMinCreatedDate = new Map<String, datetime>();
    Map<String, List<contact>> emailWithContacts = new Map<String, List<contact>>();
    Datetime dt = System.now().addDays( Integer.valueOf(cs.Number_of_days__c) );
    //Set<Id> failedRecordIds = new Set<Id>();
    //Boolean retrial = false;
    String queryString = '';

    global Database.QueryLocator start(Database.BatchableContext BC){
        
        
            queryString = CS.Batch_query__c  + ' ';
            // retry the batch for failed records only
        
            //System.debug('failed records::' +failedRecordIds);

            //query += failedRecordIds.size() > 0 ?  ' AND Id In :failedRecordIds ' : ' ';
            
            Set<Id> updatedContacts = getUpdatedContacts();
            queryString += ' OR ID IN :updatedContacts ';
        

        queryString += !String.isBlank(CS.Query_sort_order__c) ? CS.query_sort_order__c : '' ;
        System.debug('query String:::'+ queryString);
        System.debug('updatedContacts::'+updatedContacts);
        return Database.getqueryLocator(queryString);
    }
    
    global void execute(Database.BatchableContext BC, List<contact> scope){
        handleDuplicateConactCohort(scope);        
    }
    
    global void finish(Database.BatchableContext BC){

        
        System.debug('Finish!!');
        

        /*
           // Reinvoke batch for errored out records

        if(failedRecordIds.size() > 0 && !retrial){
            
            CohortRectificationBatch cb = new CohortRectificationBatch();
            cb.retrial = true;
            Database.executeBatch(cb);
        }

        */
        cs.last_run_time__c = System.now();
        update cs;
    }
    
    /* Call or append Erik's logic here for updating Cohort month correctly

    order created date

    * 
    */
    public void handleDuplicateConactCohort(List<contact> conList){
        
        System.debug('Con list size::' +conList.size());
        //System.debug('failed records::' +failedRecordIds);

        List<contact> contactsToUpdate = new List<Contact>();
        List<contact> conListForMap = new List<contact>();
        
        for(contact con: conList){
            
            if(!emailWithContacts.containsKey(con.email)){
                conListForMap = new List<contact>();
            }
            else {
                conListForMap = emailWithContacts.get(con.Email);
            }
            conListForMap.add(con);
            emailWithContacts.put(con.Email, conListForMap);
        }


        for(AggregateResult agr: [SELECT MIN(CreatedDate)cohortDate, email
        FROM Contact
        Where Email In: emailWithContacts.keySet()
        GROUP BY Email ]){
            if(!emailWithMinCreatedDate.containsKey((String)agr.get('email')) ){
                emailWithMinCreatedDate.put((String)agr.get('email'), (Datetime)agr.get('cohortDate'));
                contactsToUpdate.addAll(emailWithContacts.get((String)agr.get('email')));
            }
            
        }

        
        System.debug('emailWithMinCreatedDate::' +emailWithMinCreatedDate);
        System.debug('contactsToUpdate::' +contactsToUpdate);       
        if(contactsToUpdate.size() > 0){
            updateContactRecords(contactsToUpdate);
        }
        
    }
    private void updateContactRecords(List<contact> contactsToUpdate){
        
        
        String cohertFinal;

        // Initialize the custom label outside the loop to improve time       
       
        String eligibleDays  = System.Label.NPS_Eligible_Days;
        String eligibleMonths = System.Label.NPS_Cohort_Initial_Month;
    
        for(contact con : contactsToUpdate){
            
            if(emailWithMinCreatedDate.containsKey(con.email)){
                
                cohertFinal = String.valueOf(emailWithMinCreatedDate.get(con.email).addDays(Integer.valueOf(eligibleDays)).addMonths(Integer.valueOf(eligibleMonths)).month());
                //System.debug('con::' +con);
                //System.debug('cohertFinal::::'+cohertFinal);
                //System.debug('Cohert period:::' +Cohort_Period__mdt.getInstance('Month_' +cohertFinal));
                cohertFinal = Cohort_Period__mdt.getInstance('Month_' +cohertFinal).Cohort_months__c;
                con.CM_Existing_Data__c = cohertFinal;
                con.skip_obms__c = true;
                //System.debug('con.CM_Existing_Data__c:::' +con.CM_Existing_Data__c + ' ' +con.id);
            }
            
        }
        
       
        if(contactsToUpdate.size() > 0){
            
            
            
                //List<Database.SaveResult> updateResults = Database.update(contactsToUpdate, false);


            /*

            if(!retrial){

                for(Integer i = 0;i < updateResults.size();i++){

                    if (!updateResults.get(i).isSuccess()){                        
                        
                            failedRecordIds.add(contactsToUpdate.get(i).Id);
                        
                    }
                }
            }

            */
            try{
                Database.update(contactsToUpdate, false);
            }
            catch(Exception e){
                System.debug('Exception while running the batch::' +e);
            }
            preventOBMTrigger(contactsToUpdate);
           
        }
    }

    /*
        Function to fetch the contact Ids of all the records where email 
        field was updated so that the cohort can be calculated accordingly
    */
    private Set<Id> getUpdatedContacts(){
        
        Set<Id> contactIds = new Set<Id>();
       

        for(contacthistory conHistory: [Select contactId from contacthistory where createddate >= :dt and field = 'Email']){
            if(!contactIds.contains(conHistory.contactId)){
                contactIds.add(conHistory.contactId);
            }
        }
        return contactIds;
    }

    /* Function to update skip OBM flag on contact so that no OBM is fired when the batch is invoked
        -> The function updates the OBM flag to true and then to false
    */
    private void preventOBMTrigger(List<contact> contactsToUpdate){
    
        for(Contact con: contactsToUpdate){
            con.skip_obms__c = false;
            //con.cohort_calculation_failed__c = failedRecordIds.contains(con.Id) ? true : false;
        }
        try{
            update contactsToUpdate;
        }
        catch(Exception e){
            System.debug('Exception in OBM flag update:::' +e);
        }
        
    }
    
}