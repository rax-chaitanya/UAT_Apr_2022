/**********************************************************************************

Author: Mohan P K
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the trigger.

**********************************************************************************/
public class ContactHandler implements TriggerInterface
{
    public static boolean firstTgrRun = true; 
    public static Boolean IS_TRIGGER_ENABLED = true;
    public static string stopRecursion = 'Before Update';
    
    public Boolean isActive()
    {
        //StopRecursion.resetOnce('Contact');
        //System.debug('debug c isActive--'+Trigger_Manager__c.getInstance('ContactTgr').Is_Active__c);
        return IS_TRIGGER_ENABLED && Trigger_Manager__c.getInstance('ContactTgr').Is_Active__c;
    }
    
    
    public void beforeInsert() 
    {
        
        List<Contact> conList = (List<Contact>)Trigger.new;
        Map<Id, Contact> cMap = (Map<Id, Contact>)Trigger.oldMap;
        Map<string,string> CurrentEmptoManager= new Map<string,string>();//6105
        List<Contact> conListForNPS = new List<Contact>();//SFDC-7198
        
        // UpdateTerritory.populateTerritory(conList,cMap,'Contact');
        /****************SFDC-2155 starts added by Biswa******************
if(System.label.Partner_Profiles.contains(userInfo.getProfileId())){
ContactHelper.ValidateAndAutoPopulteCmp();
}
/*******************SFDC-2155 Ended By Biswa ********************/
        
        ContactHelper.updateCmp();
        //Added by sundarayya E for SFDC-5307
        List<Contact> newList = new List<Contact>();
        for(Contact con : (List<Contact>) Trigger.new){
            if(con.Btlk_Country__c != null && con.MailingCountry == null ){
                newList.add(con);
            }
            //SFDC-6105
            if(con.manager__c!=null && con.Employee_Number__c!=null && con.Manager_Employee_Number__c!=null){
                CurrentEmptoManager.put(con.Employee_Number__c,con.Manager_Employee_Number__c);
            }//SFDC-6105 
            //SFDC-7198
            if(!String.isBlank(con.email) && con.NPS_Eligible__c != true && con.NPS_Survey_Opt_Out__c == true ){
                conListForNPS.add(con);
        }
            //SFDC-7198 
        }
        if(newList.size() > 0){ContactHelper.updateBtlkAddFields((List<Contact>)Trigger.new);        
                              }
        
        //Added by sundarayya E for SFDC-5307--Ends
        //SFDC-6105
        if(!CurrentEmptoManager.isEmpty()){
            ContactHelper.updateEmployeeManagers(CurrentEmptoManager,(List<Contact>)Trigger.new);
        }//SFDC_6105
        //SFDC-7198
        if(conListForNPS.size() > 0){
            updatingDuplicateContact(conListForNPS ,null);
        }
        //SFDC-7198
    } 
    
    public void beforeUpdate() 
    {
         List<Contact> conListForNPS = new List<Contact>();
        if(!CompanyHandler.isLeadConverting || (CompanyHandler.isLeadConverting && stopRecursion == 'Before Update')){   
            stopRecursion = 'After Update';  
            List<Contact> conList = (List<Contact>)Trigger.new;
            Map<Id, Contact> cMap = (Map<Id, Contact>)Trigger.oldMap;
            Map<string,string> CurrentEmptoManager= new Map<string,string>();//6105
            
            UpdateTerritory.populateTerritory(conList,cMap,'Contact');
            
            
            
            /****************SFDC-2155 starts added by Biswa******************/
            if(System.label.Partner_Profiles.contains(userInfo.getProfileId())){
                ContactHelper.validateContactEdit();
            }
            /*******************SFDC-2155 Ended By Biswa ********************/
            
            /****** CDH-Delete START ******/
            
            List<Contact> cdhDelList = new List<Contact>();
            for(contact con : (List<Contact>)Trigger.new)
            {
                if(con.Acr_Count__c==0 && con.RPN__c!='' && ((Map<Id, Contact>)Trigger.oldMap).get(con.Id).Acr_Count__c!=0)
                {
                    cdhDelList.add(((Map<Id, Contact>)Trigger.oldMap).get(con.Id));
                    con.RPN__c='';
                }   
                if(!cdhDelList.isEmpty())
                    DeleteUndeleteTriggerHandler.DeleteUndelete(cdhDelList, 'Contact');
                //SFDC-7198
                if(!String.isBlank(con.email) && con.NPS_Eligible__c != true && con.NPS_Survey_Opt_Out__c == true){
                    conListForNPS.add(con);
                }
                //SFDC-7198
            }
            
            /****** CDH-Delete END ******/
            //Added by sundarayya E for SFDC-5307
            List<Contact> newList = new List<Contact>();
            Map<Id, Contact> conOldMap= (Map<Id, Contact>)Trigger.OldMap;
            for(Contact con : (List<Contact>) Trigger.new){
                if((con.Btlk_Country__c != null && conOldMap.get(con.Id).Btlk_Country__c != con.Btlk_Country__c) || (conOldMap.get(con.Id).Btlk_Country__c == con.Btlk_Country__c && conOldMap.get(con.Id).Btlk_Sate_Province__c != con.Btlk_Sate_Province__c)){
                    newList.add(con);
                }
                //Added for SFDC-6105
                if(con.manager__c!=null && con.Employee_Number__c!=null && con.Manager_Employee_Number__c!=null){
                    CurrentEmptoManager.put(con.Employee_Number__c,con.Manager_Employee_Number__c);
                }//SFDC-6105
            }
            if(newList.size() > 0){ContactHelper.updateBtlkAddFields((List<Contact>)Trigger.new);        
                                  }
            //Added by sundarayya E for SFDC-5307--Ends
            //SFDC-6105
            if(!CurrentEmptoManager.isEmpty()){
                ContactHelper.updateEmployeeManagers(CurrentEmptoManager,(List<Contact>)Trigger.new);
            }//SFDC-6105
        }  
        /****************SFDC-7198 starts added by Atul******************/
        if(conListForNPS.size() > 0){
            updatingDuplicateContact(conListForNPS ,(Map<Id, Contact>)Trigger.OldMap);
        }
    }
    // Added by Mrinal for Cohort calculation
    public void beforeDelete() {
        List<Contact> conList = (List<Contact>)Trigger.old;
        List<String> emailListForCohort = new List<String>();

        for(contact con: conList){
            emailListForCohort = addEmailForCohort(emailListForCohort, con.email);
        }
        if(emailListForCohort.size() > 0){
            CohortCalculationHelper.calculateCohortByEmails(emailListForCohort);
        }
    }
    
    public void afterInsert(){
        
        // Added by Anjaneyulu for STCM-127, STCM-130 and SFSB-470 -- Starts
        //Updated For Redesign GTMO-32
        Map<Id,Contact> companyIdVsContact = new Map<Id,Contact>();
        
        
        Map<Id,AccountContactRelation> accountcontactRelatons = new Map<Id,AccountContactRelation>();
        Set<Id> compAcrIds = new Set<Id>();
        string AccountRecordtype=label.AccountRecordtypes;
        string CompanyRecordType=Label.CompanyRecordTypes;
        
        for(Contact c : (List<Contact>)Trigger.new){
            if(!String.isBlank(c.AccountId))
                companyIdVsContact.put(c.AccountId, c);
        }
        
        
        if(!companyIdVsContact.keySet().isEmpty() ){ 
                    //SFDC-5682 : To check and update NPS Contact Role and NPS Contact created Date - Start     
            List<String> Skip_Colle_Status           = System.Label.NPS_Skip_Collection_Status.split(',');
            String accStatus                         = System.Label.NPS_Account_Status;
            //String unQuali                           = System.Label.NPS_Skip_Unqualified;
            /*String SFDomain                          = System.Label.NPS_Skip_Email_Domain1;
            String rackDomain                        = System.Label.NPS_Skip_Email_Domain2;*/
            list<string> skipemaildomains=System.Label.NPSallexclusionemails.split(',');
            List<String> Skip_OnicaCEIds             = System.Label.NPS_Skip_OnicaCntrType.split(',');
        
            
            for(Account ac : [Select id,name,Company_Name__c,Contracting_Entity__c,NPS_Collection_Status__c,status__c,Recordtypeid,(Select id,Roles from accountcontactRelations where Roles includes ('Primary Contact')) from Account where Type='Prospect' and Company_Name__c in : companyIdVsContact.keySet() ]){
                //SFDC-5682 : To check and update NPS Contact Role and NPS Contact created Date - End
                // System.debug('ac.Recordtypeid'+ac.Recordtypeid);
                //System.debug('ac.AccountContactRelations.size()<=0'+ac.AccountContactRelations.isEmpty());
                if(AccountRecordtype.contains(ac.Recordtypeid)&& ac.AccountContactRelations.isEmpty()){
                    //  System.debug('AccountContactRelation size is  <0');
                    if(!AccountcontactRelatons.containsKey(ac.Id)){
                        Contact c = companyIdVsContact.get(ac.Company_Name__c);
                        if(c.recordtypeId != Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Employee').getRecordTypeId()){
                            
                              //SFDC-5682 : To check and update NPS Contact Role and NPS Contact created Date - Start 
                               Boolean isEmail = false;
                               
                               if(!String.isBlank(c.email)){
                                   isEmail = Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}', String.valueOf(c.email).trim());
                               }
                               // commented this condition from below to use  -- && !skipemaildomains.contains(c.Email.toLowerCase().split('@').get(1)) 
                               // && (!c.Email.toLowerCase().contains(SFDomain) && !c.Email.toLowerCase().contains(rackDomain))
 
                               if((ac.Contracting_Entity__c == null || !Skip_OnicaCEIds.contains(ac.Contracting_Entity__c)) && (!String.isBlank(ac.NPS_Collection_Status__c) && !Skip_Colle_Status.contains(ac.NPS_Collection_Status__c)) && (ac.status__c == accStatus) && (isEmail && c.NPS_Survey_Opt_Out__c == false)
                                 && !skipemaildomains.contains(c.Email.toLowerCase().split('@').get(1))
                                 ){
                                    accountcontactRelatons.put(ac.Id, new AccountContactRelation(AccountId=ac.Id,ContactId=c.id,Roles= System.Label.NPS_Contact_Role + ';' + 'Primary Contact'));
                               }else{
                                    accountcontactRelatons.put(ac.Id, new AccountContactRelation(AccountId=ac.Id,ContactId=c.id,Roles='Primary Contact'));
                                    // System.debug('AccountContactRelation'+ac.AccountContactRelations);
                               }                            
                               //SFDC-5682 : To check and update NPS Contact Role and NPS Contact created Date - End 
                           
                            
                        }
                    }  
                }
            }
            
            
            if(!accountcontactRelatons.isEmpty() && String.isNotBlank(UserInfo.getUserId()) &&  !Label.DataMigrationUsers.contains(UserInfo.getUserId()))
                
                insert accountcontactRelatons.values();
            
            
            
            
            
        }
        
        
        
        // Added by Anjaneyulu for STCM-127,STCM-130 and SFSB-470 -- Ends
        
        /****************SFDC-2155 starts added by Biswa******************/
        if(System.label.Partner_Profiles.contains(userInfo.getProfileId())){
            ContactHelper.createPartnerUser((List<Contact>)Trigger.new);
            
        }
    }
    
    public void afterUpdate() {
        contact oldContact = new Contact();
        List<String> emailListForCohort = new List<String>();

        if(!CompanyHandler.isLeadConverting || (CompanyHandler.isLeadConverting && stopRecursion == 'After Update')){
            stopRecursion = 'Stop Recursion'; 
            if(System.label.Partner_Profiles.contains(userInfo.getProfileId())){
                set<id> contactIds = new set<id>();
                for(contact con : (List<Contact>)Trigger.new){
                    if(con.inactive__c != ((Map<Id, Contact>)Trigger.oldMap).get(con.Id).inactive__c){
                        contactIds.add(con.Id);
                    }
                }
                if(!contactIds.isEmpty())
                    ContactHelper.activeInactiveUsers(contactIds);
            } 
            
            /********************SFDC-2155 End *********************/
            /********SFDC-3273 Added by RDC*****/
            Set<String> setOfEmailIds = new Set<String>();
            for(Contact contactRecord: (List<Contact>) Trigger.new){
                if((((Map<Id,Contact>)Trigger.oldMap).get(contactRecord.Id).HasOptedOutOfEmail != contactRecord.HasOptedOutOfEmail) && (contactRecord.HasOptedOutOfEmail == true)){
                    setOfEmailIds.add(contactRecord.email);
                }
            }
            if(setOfEmailIds.size()>0 && (!System.isFuture()))
                UpdateEmailOptOut.updateEmailOptOutField(setOfEmailIds,'Contact');
            /********SFDC-3273 Ended by RDC*****/    
            //SFDC-5682 : To check and update NPS Contact Role and NPS Contact created Date - Start
            Set<Id> conSetIds = new Set<Id>();
            List<Id> conIds = new List<Id>();
            conSetIds.addAll((Set<Id>)Trigger.newMap.keySet());
            conIds.addAll(conSetIds); 
        
             NPS_Contact_and_Role_Creation.checkNPSContactEligiblityAsync(conIds);
         //SFDC-5682 : To check and update NPS Contact Role and NPS Contact created Date - End           
        }  
        // ------- Mrinal changes start for cohort updation -------
        for(contact contactRecord: (List<Contact>) Trigger.new){

            oldContact = ((Map<Id,Contact>)Trigger.oldMap).get(contactRecord.Id);

            if(oldContact.Last_date_of_survey__c != contactRecord.Last_date_of_survey__c){
            emailListForCohort = addEmailForCohort(emailListForCohort, contactRecord.email);
            }
            
            if(oldContact.email != contactRecord.email){
            emailListForCohort = addEmailForCohort(emailListForCohort, contactRecord.email);
            emailListForCohort = addEmailForCohort(emailListForCohort, oldContact.email);
            }

        }
        if(emailListForCohort.size() > 0){
            CohortCalculationHelper.calculateCohortByEmails(emailListForCohort);
        }
        // ------- Mrinal changes end ---------
    }
    
    public void afterDelete() {
        List<Contact> conList = (List<Contact>)Trigger.old;
        DeleteUndeleteTriggerHandler.DeleteUndelete(conList, 'Contact');
    }

    
    
    public void afterUndelete() {}

    // Added by Mrinal for Cohort calculation
    public List<String> addEmailForCohort(List<String> emailListForCohort, String email){
        if(!emailListForCohort.contains(email)){
            emailListForCohort.add(email);
        }
        return emailListForCohort;
    } 
    /****************SFDC-7198 starts added by Atul******************/
    /****************SFDC-7198 To Update the duplicate Contact OPT out and OPt out reason******************/
    public static void updatingDuplicateContact(List<Contact> conRecords ,Map<Id,Contact> OldCon){
        List<String> emailRestrictToInsert = new List<String>{'fraud'};
            List<String> emailID = new List<String>();
        Map<String,Map<Contact,List<Contact>>> conMap = new  Map<String,Map<Contact,List<Contact>>>();
        Map<Contact,List<Contact>> lstMap = new Map<Contact,List<Contact>>();
        Map<Contact,List<Contact>> lstMapToCheckSize= new Map<Contact,List<Contact>>();
        List<Contact> conListToUpdate = new List<Contact>();
        List<Contact> conList = new List<Contact>();
        Contact oldContact;
        
        //Checking the flag
        if(!CheckRecursive.firstcall){
            // Calling the batch class if the record is inserted more then 60 
            if(trigger.isInsert && conRecords.size() > 60){
                database.executeBatch(new ContactUpdateSurevyOPTBatchJob(null,conRecords));
            }
            else{
                // Iterate over the contact which are updated/insert 
                for(Contact eachCon : conRecords){
                    //IF the record is update the storing the old value of record
                    if(trigger.isUpdate){
                        oldContact = OldCon.get(eachCon.ID);
                    }
                    //Checking the condition according to the contact in inserted or updated
                    
                   
                    	
                        if(!eachCon.Email.contains(checkRecursive.emailsToStopUpdate) && ((trigger.isInsert ) || (trigger.isUpdate && eachCon.NPS_Survey_Opt_Out__c != oldContact.NPS_Survey_Opt_Out__c 
                                                                                                              && eachCon.NPS_Survey_Opt_Out__c != NULL ))){
                                                                                                                  //Adding the mails in list
                                                                                                                  if(!emailID.contains(eachCon.email)){
                                                                                                                      emailID.add(eachCon.email);
                                                                                                                  }
                                                                                                                  // Creating the map<Contact,List<Contact>> And Map<String,Map<Contact,List<Contact>>>
                                                                                                                  lstMap = new Map<Contact,List<Contact>>();
                                                                                                                  lstMap.put(eachCon,new List<Contact>());
                                                                                                                  conMap.put(eachCon.email,lstMap);
                                                                                                              }
                    
                    
                    
                }
                
                //Checking the Email List is not empty
                if(!emailID.isEmpty()){
                    // Fetching all the duplicate record with same email which contact record is update/insert and Iterate over that
                    for(contact lstCon : [SELECT id,name,Email,NPS_Survey_Opt_Out__c,Reasons_to_opt_out__c,NPS_Eligible__c FROM Contact where Email IN:emailID AND id NOT IN : trigger.new AND Recordtype.DeveloperName != 'Employee' AND NPS_Survey_Opt_Out__c != true]){
                        lstMap = conMap.get(lstCon.Email);
                        //Iterate over the contact which are updated/insert and creating a map<Contact,List<Contact>> And Map<String,Map<Contact,List<Contact>>>
                        for(Contact con: lstMap.keySet()){
                            conList = lstMap.get(con);
                            conList.add(lstCon);
                            lstMapToCheckSize.put(con, conList);
                        }
                        conMap.put(lstCon.email, lstMap);
                    }
                    //Iterate over the contact which are updated/insert
                    for(Contact con:conRecords){
                        if(lstMapToCheckSize.get(con) != null){
                            conList = lstMapToCheckSize.get(con);
                            //Checking the size of duplicate contact
                            
                            if(conList.size() > 60){
                                database.executeBatch(new ContactUpdateSurevyOPTBatchJob(con,conList));
                            }
                            else{
                                for(Contact innerCon:conList){
                                    innerCon.NPS_Survey_Opt_Out__c =con.NPS_Survey_Opt_Out__c;
                                    innerCon.Reasons_to_opt_out__c = con.Reasons_to_opt_out__c;
                                    innerCon.NPS_Eligible__c = con.NPS_Eligible__c;
                                    conListToUpdate.add(innerCon);
                                }
                            }
                        }
                    }
                    CheckRecursive.firstcall = true;
                    if(!conListToUpdate.isEmpty()){
                        update conListToUpdate;
                    }
                }
            }
        }
        
    }
    
}