/**********************************************************************************
Author: Atul Kumar
Description: Batch class which is invoke by contact trigger to update the NPS_Survey_Opt_Out__c,
Reasons_to_opt_out__c of the duplicate email contacts.
Created date:- 03-02-2022
**********************************************************************************/
global class ContactUpdateSurevyOPTBatchJob Implements Database.Batchable <sObject>,Database.stateful {
    List<Contact> conlist = new List<Contact>();
    contact updateQualtricsContact = new contact();
    Set<id> contactIds = new Set<id>();
    Map<String, Contact> updatedContactMapBatch=new Map<String, Contact>();
    List<String> emailID = new List<String>();
    Map<String, Contact> emailContactMap=new Map<String, Contact>();
    global ContactUpdateSurevyOPTBatchJob(Contact con , List<Contact> updatedContact){
        //Mapping the value coming from trigger 
        conlist=updatedContact;
        updateQualtricsContact = con;
    }
    
    global Database.queryLocator start(Database.BatchableContext bc) {
        // Checking batch is running when record is updated or insert number and the insert record is less then 60.
        if(updateQualtricsContact != null){
            //itreate over the Contact need to update
            for(Contact eachCon : conlist){
                if(!contactIds.contains(eachCon.id)){
                    contactIds.add(eachCon.id);
                }
                
            }
        }
        // Checking batch in running when record is insert and number of record is more then 60.
        else{
            for(Contact eachConRecord :conlist){
               if(!eachConRecord.Email.contains(checkRecursive.emailsToStopUpdate)){
                if(!emailID.contains(eachConRecord.email)){
                    emailID.add(eachConRecord.email);
                }
                emailContactMap.put(eachConRecord.Email,eachConRecord);
                   System.debug('each contact in nps out out:::'+eachConRecord);
                }
                
            }
            if(!emailID.isEmpty()){
                for(contact lstCon : [SELECT id,name,Email,NPS_Survey_Opt_Out__c,Reasons_to_opt_out__c,NPS_Eligible__c FROM Contact where Email IN:emailID AND id NOT IN : conlist AND Recordtype.DeveloperName != 'Employee' AND NPS_Survey_Opt_Out__c != true]){
                    contactIds.add(lstCon.id);
                }
            }
        }
        // Query all the non updated record of same email address 
        return Database.getQueryLocator([SELECT id,firstname,email,NPS_Survey_Opt_Out__c,Reasons_to_opt_out__c,NPS_Eligible__c  FROM Contact WHERE id in:contactIds AND Recordtype.DeveloperName != 'Employee' AND NPS_Survey_Opt_Out__c != true]);
    }
    global void execute(Database.BatchableContext bc, List<Contact> scope) {
        List<Contact> updateContact = new List<Contact>();
        // itreate over the all updated records
        for(Contact con : scope){
            // set the value from update record
            if(updateQualtricsContact != null){
                con.NPS_Survey_Opt_Out__c = updateQualtricsContact.NPS_Survey_Opt_Out__c;
                con.Reasons_to_opt_out__c = updateQualtricsContact.Reasons_to_opt_out__c;
                con.NPS_Eligible__c = updateQualtricsContact.NPS_Eligible__c;
                updateContact.add(con);
            }
            else {
                If(emailContactMap.containsKey(con.email)){
                    con.NPS_Survey_Opt_Out__c = emailContactMap.get(con.email).NPS_Survey_Opt_Out__c;
                    con.Reasons_to_opt_out__c = emailContactMap.get(con.email).Reasons_to_opt_out__c;
                    con.NPS_Eligible__c = emailContactMap.get(con.email).NPS_Eligible__c;
                    updateContact.add(con);
                }
            }
        }
        //Checking list is non-empty
        if(!updateContact.isEmpty()){
            /* We have to set a flag here to stop the loop*/
            CheckRecursive.firstcall = true;
            database.update(updateContact,false);
        }
    }
    global void finish(Database.BatchableContext bc) {
        CheckRecursive.firstcall = true;
    }
}