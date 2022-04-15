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
        
        System.debug('Inside Contact handler');
        List<Contact> conList = (List<Contact>)Trigger.new;
        Map<Id, Contact> cMap = (Map<Id, Contact>)Trigger.oldMap;
        Map<string,string> CurrentEmptoManager= new Map<string,string>();//6105
        
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
        }
        if(newList.size() > 0){ContactHelper.updateBtlkAddFields((List<Contact>)Trigger.new);        
                              }
        
        //Added by sundarayya E for SFDC-5307--Ends
        //SFDC-6105
        if(!CurrentEmptoManager.isEmpty()){
            ContactHelper.updateEmployeeManagers(CurrentEmptoManager,(List<Contact>)Trigger.new);
        }//SFDC_6105
    } 
    
    public void beforeUpdate() 
    {
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
    }
    
    public void beforeDelete() {}
    
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
    }
    
    public void afterDelete() {
        List<Contact> conList = (List<Contact>)Trigger.old;
        DeleteUndeleteTriggerHandler.DeleteUndelete(conList, 'Contact');
    }
    
    public void afterUndelete() {}
    
}