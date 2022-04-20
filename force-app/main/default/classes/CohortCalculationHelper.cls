/*
* Name: CohortCalculationHelper
* Created On: 19 Apr 2022
* Author: Mrinal Tripathi (mrinal.tripathi@rackspace.com)
* Description: Helper class to update duplicate contacts
*/
public class CohortCalculationHelper{
    static Map<String, datetime> emailWithMinCreatedDate = new Map<String, datetime>();
    static Map<String, datetime> emailWithLastSurveyDate = new Map<String, datetime>();
    static Map<String, List<contact>> emailWithContacts = new Map<String, List<contact>>();
    static Set<String> emailVisited = new Set<String>();
    static String eligibleDays  = System.Label.NPS_Eligible_Days;
    static String eligibleMonths = System.Label.NPS_Cohort_Initial_Month;
    static List<String> emailWithLastSurveyFound = new List<String>();
    
    public static void handleDuplicateConactCohort(List<contact> conList){
        
        if(!CheckRecursive.firstcall){
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
            
            String emailId;
            Datetime lastSurveyDate;
            
            
            for(AggregateResult agr: [SELECT MIN(CreatedDate)cohortDate, email, Last_date_of_survey__c
                                      FROM Contact
                                      Where Email In: emailWithContacts.keySet()
                                      GROUP BY Email, Last_date_of_survey__c Order by last_date_of_survey__c]){
                                          
                                          
                                          System.debug('agr result:::' +agr);
                                          emailId = (String)agr.get('email');
                                          if(agr.get('Last_date_of_survey__c') != null ){
                                              
                                              lastSurveyDate = (Datetime)agr.get('Last_date_of_survey__c');
                                              emailWithMinCreatedDate.put((String)agr.get('email'), lastSurveyDate.addDays(Integer.valueOf(eligibleDays) * -1).addMonths(Integer.valueOf(eligibleMonths ) * -1));
                                              emailWithLastSurveyFound.add(emailId);
                                          }
                                          else if(!emailWithLastSurveyFound.contains(emailId)){
                                              emailWithMinCreatedDate.put((String)agr.get('email'), (Datetime)agr.get('cohortDate'));
                                          }
                                          if(!emailVisited.contains(emailId)){
                                              
                                              emailVisited.add(emailId);
                                              contactsToUpdate.addAll(emailWithContacts.get((String)agr.get('email')));
                                          }
                                          
                                          
                                          
                                      }
            
            
            System.debug('emailWithMinCreatedDate::' +emailWithMinCreatedDate);
            System.debug('contactsToUpdate::' +contactsToUpdate);       
            if(contactsToUpdate.size() > 0){
                updateContactRecords(contactsToUpdate);
            }
            
            
        }
    }
    private static void updateContactRecords(List<contact> contactsToUpdate){
        
        
        String cohertFinal;
        
        // Initialize the custom label outside the loop to improve time       
        
        
        
        for(contact con : contactsToUpdate){
            
            if(emailWithMinCreatedDate.containsKey(con.email)){
                
                
                cohertFinal = String.valueOf(emailWithMinCreatedDate.get(con.email).addDays(Integer.valueOf(eligibleDays)).addMonths(Integer.valueOf(eligibleMonths)).month());
                //System.debug('con::' +con);
                //System.debug('cohertFinal::::'+cohertFinal);
                //System.debug('Cohert period:::' +Cohort_Period__mdt.getInstance('Month_' +cohertFinal));
                //System.debug('Cohort final month number:::'+cohertFinal);
                //System.Debug('Calculated date::'+emailWithMinCreatedDate.get(con.email).addDays(Integer.valueOf(eligibleDays)));
                
                cohertFinal = Cohort_Period__mdt.getInstance('Month_' +cohertFinal).Cohort_months__c;
                //System.debug('Cohort final value in metadata:::'+cohertFinal);
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
    
    /* Function to update skip OBM flag on contact so that no OBM is fired when the batch is invoked
-> The function updates the OBM flag to true and then to false
*/
    private static void preventOBMTrigger(List<contact> contactsToUpdate){
        
        for(Contact con: contactsToUpdate){
            con.skip_obms__c = false;
            //con.cohort_calculation_failed__c = failedRecordIds.contains(con.Id) ? true : false;
        }
        try{
            CheckRecursive.firstCall = true;
            update contactsToUpdate;
        }
        catch(Exception e){
            System.debug('Exception in OBM flag update:::' +e);
        }
    }
    @future
    public static void calculateCohortByEmails(List<String> emailIds){
        List<contact> contactList = new List<contact>();
        //Customize the query
        for(contact con: [Select id, email, CM_Existing_Data__c, skip_obms__c, cohort_month__c from contact where email IN :emailIds Limit 50000]){
            contactList.add(con);
        }
        if(contactList.size() > 0){
            handleDuplicateConactCohort(contactList);
        }
    }
}