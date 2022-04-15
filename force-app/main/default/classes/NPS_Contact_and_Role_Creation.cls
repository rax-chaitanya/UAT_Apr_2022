/* 
* Epic: SFDC-5677, User Story: SFDC-5682 This dynamic class trigger 
for creating NPS Contact by validating eligibility requirements on Account, Contact and ACR and
make NPS Contact ineligible if requirements not match.   
*SFDC-6554 Timeout after Opportunity is Closed Won

* Last Modified By - Chaitanya 
* Changes - SFDC-6904 --> In checkAndCreate Updated If Condition to Exclude all Ernst & Young accounts from the NPS-R Survey by skipping Contacts with Email domain @ey.com - label :NPSallexclusionemails
* Test Class - NPS_ContactRole_Test

*/
public class NPS_Contact_and_Role_Creation{
    
    
    //Added by Rajasekhar to CheckNPSContactEligiblity Asynchronously without Exception, start    
    public static void checkNPSContactEligiblityAsync(List<Id> sobIds){
        //  System.debug('isAsync::' + IsAsyncProcess.checkIsAsyncProcess());
        if(IsAsyncProcess.checkIsAsyncProcess()){
            NPS_Contact_and_Role_Creation.checkAndCreateFuture(sobIds);
        }else{
            NPS_Contact_and_Role_Creation.checkAndCreate(sobIds);
        }    
    }           
    //Added by Rajasekhar to CheckNPSContactEligiblity Asynchronously without Exception, end
    
    @Future
    public static void checkAndCreateFuture(List<id> sobIds){
        if(sobIds!= null || sobIds.size() > 0){
            // System.debug('Inside future');
            NPS_Contact_and_Role_Creation.checkAndCreate(sobIds);  
        }      
    }
    
    public static void checkAndCreate(List<Id> sobIds){
        //System.debug('Not insidefutrure');
        if(sobIds != null || sobIds.size() > 0){
            String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
            List<string> acRTIds               = System.Label.AccountRecordtypes.split(',');
            List<String> Skip_Colle_Status     = System.Label.NPS_Skip_Collection_Status.split(',');
            List<String> Skip_OnicaCEIds       = System.Label.NPS_Skip_OnicaCntrType.split(',');
            String accStatus                   = System.Label.NPS_Account_Status;
            //String unQuali                     = System.Label.NPS_Skip_Unqualified;
            //
                  /*   String SFDomain                          = System.Label.NPS_Skip_Email_Domain1;
        String rackDomain                        = System.Label.NPS_Skip_Email_Domain2;
        String EyDomain                        = System.Label.NPS_Skip_Email_Domain_Ey_com;*/
           String SoqlSFDomain                    = '%' + System.Label.NPS_Skip_Email_Domain1;
            String SoqlrackDomain                  = '%' + System.Label.NPS_Skip_Email_Domain2;
            String SoqlEyDomain                        = '%' +System.Label.NPS_Skip_Email_Domain_Ey_com;
            String SoqlBrEyDomain                        = '%' +System.Label.NPS_Skip_Email_Domain_br_ey_com;
            String SoqlRacspaceUk                        = '%' +System.Label.NPS_Skip_Email_Domain_rackspaceuk;
            list<string> skipemaildomains=System.Label.NPSallexclusionemails.split(',');

            String npsCon                      = System.Label.NPS_Contact_Role;
            set<String> inelgemails = new set<String>();
            
            String sobName = sobIds[0].getSObjectType().getDescribe().getName();
            Map<Id,AccountContactRelation> acrs = new Map<Id,AccountContactRelation>();
            Map<Id,Contact> cons = new Map<Id,Contact>();
            
            String Query = System.Label.NPSACRQueryFieldsString;                
            String conEligibleACR_Str = ' ContactId IN: sobIds AND account.RecordTypeId IN :acRTIds';            
            String accEligibleACR_Str = ' AccountId IN: sobIds AND account.RecordTypeId IN :acRTIds';
            String finalQuery = '';
            String finalcheckQuery='';
            if(sobName == 'Contact' || sobName == 'AccountContactRelation'){
                // System.debug('Inside ACR/Contact'+sobName );
                finalQuery = Query + ConEligibleACR_Str +' AND '+ System.Label.NPSACREligibleQuery;
                //finalQuery = Query + ConEligibleACR_Str;
                //    System.debug('finalQuery '+finalQuery );
                //    System.debug('Query '+Query);
                //     System.debug('conEligibleACR_Str'+conEligibleACR_Str);               
                for(AccountContactRelation acr : Database.query(finalQuery)){
                    
                    if(acr != null && (!String.isBlank(acr.Contact.Email) && acr.Contact.NPS_Survey_Opt_Out__c == false) 
                       && !skipemaildomains.contains(acr.contact.Email.toLowerCase().split('@').get(1))
                       && (acr.Account.Status__c == accStatus) && (!String.isBlank(acr.Account.NPS_Collection_Status__c) 
                                                                   && !Skip_Colle_Status.contains(acr.Account.NPS_Collection_Status__c))
                       && (acr.Account.Contracting_Entity__c == null || !Skip_OnicaCEIds.contains(acr.Account.Contracting_Entity__c))){
                            System.debug('acr.Contact.Email...'+acr.Contact.Email);
                            System.debug('NPS Role...>>'+npsCon);
                           
                            System.debug('acr.Roles.contains(npsCon)...'+acr.Roles.contains(npsCon));
                           if(!acr.Roles.contains(npsCon)){
                               
                               AccountContactRelation roleACR = new AccountContactRelation();
                               roleACR.Id = acr.Id;
                               if(!String.isBlank(acr.Roles)){
                                   roleACR.Roles = acr.Roles + ';' + npsCon;
                               }else{
                                   roleACR.Roles = npsCon;  
                               }   
                               acrs.put(roleACR.Id,roleACR);
                           }   
                           if(!acr.Contact.NPS_Eligible__c){
                               //System.debug('acr.Contact.NPS_Eligible__c'+acr.Contact.NPS_Eligible__c );
                               Contact con = new Contact();
                               con.Id = acr.ContactId;
                               con.Account_Number_QLT__c = acr.Account.Account_Number__c;
                               con.Account_Team_Name__c = acr.Account.Support_Team__c;
                               if(acr.Contact.NPS_CCDate__c == null){  
                                   con.NPS_CCDate__c = acr.Contact.CreatedDate.date();
                               }
                               con.NPS_Eligible__c = true;
                               cons.put(con.Id,con);    
                               
                           }
                       }
                    
                    
                    else{
                        if(acr.Contact.NPS_Eligible__c){
                            //     System.debug('acr.Contact.NPS_Eligible__c....'+acr.Contact.NPS_Eligible__c);
                            inelgemails.add(acr.contact.email);
                            Contact con = new Contact();
                            con.Id = acr.ContactId;
                            con.Account_Number_QLT__c = acr.Account.Account_Number__c;
                            con.Account_Team_Name__c = acr.Account.Support_Team__c;
                            if(acr.Contact.NPS_CCDate__c == null){  
                                con.NPS_CCDate__c = acr.Contact.CreatedDate.date();
                            }
                            con.NPS_Eligible__c = false;
                            cons.put(con.Id,con);   
                        }
                    }                   
                }   
                
                
                
                
            }else if(sobName == 'Account'){
                //System.debug('Inside Account'+sobName );
                finalQuery = Query + accEligibleACR_Str;
                //  System.debug('finalQuery '+finalQuery );
                for(AccountContactRelation acr : Database.query(finalQuery)){
                    if(acr != null && (!String.isBlank(acr.Contact.Email) && acr.Contact.NPS_Survey_Opt_Out__c == false) && (!acr.Contact.Email.toLowerCase().contains(Label.NPS_Skip_Email_Domain1))&& (!acr.Contact.Email.toLowerCase().contains(Label.NPS_Skip_Email_Domain2)) && (acr.Account.Status__c == accStatus) && (!String.isBlank(acr.Account.NPS_Collection_Status__c) && !Skip_Colle_Status.contains(acr.Account.NPS_Collection_Status__c)) && (acr.Account.Contracting_Entity__c == null || !Skip_OnicaCEIds.contains(acr.Account.Contracting_Entity__c))){
                        
                        // System.debug('acr.Account.Contracting_Entity__c '+acr.Account.Contracting_Entity__c);
                        if(!acr.Roles.contains(npsCon)){
                            System.debug('acr.Roles '+acr.Roles);
                            AccountContactRelation roleACR = new AccountContactRelation();
                            roleACR.Id = acr.Id;
                            if(!String.isBlank(acr.Roles)){
                                roleACR.Roles = acr.Roles + ';' + npsCon;
                            }else{
                                roleACR.Roles = npsCon;  
                            }   
                            //   System.debug('role acrs'+roleACR.Roles);
                            acrs.put(roleACR.Id,roleACR);
                        }                       
                        if(!acr.Contact.NPS_Eligible__c){
                            //    System.debug('eligible.....'+acr.Contact.NPS_Eligible__c);
                            Contact con = new Contact();
                            con.Id = acr.ContactId;
                            con.Account_Number_QLT__c = acr.Account.Account_Number__c;
                            con.Account_Team_Name__c = acr.Account.Support_Team__c;
                            if(acr.Contact.NPS_CCDate__c == null){  
                                con.NPS_CCDate__c = acr.Contact.CreatedDate.date();
                            }
                            con.NPS_Eligible__c = true;
                            cons.put(con.Id,con);   
                        }
                    }else{
                        if(acr.Contact.NPS_Eligible__c){
                            //      System.debug('in eligible.....'+acr.Contact.NPS_Eligible__c);
                            inelgemails.add(acr.contact.email);
                            System.debug('is eligible.....');
                            Contact con = new Contact();
                            con.Id = acr.ContactId;
                            con.Account_Number_QLT__c = acr.Account.Account_Number__c;
                            con.Account_Team_Name__c = acr.Account.Support_Team__c;
                            if(acr.Contact.NPS_CCDate__c == null){  
                                con.NPS_CCDate__c = acr.Contact.CreatedDate.date();
                            }
                            con.NPS_Eligible__c = false;
                            cons.put(con.Id,con);   
                        }
                    }               
                }           
            } 
            
            finalcheckQuery = Query +  ' contact.email IN: inelgemails AND account.RecordTypeId IN :acRTIds ORDER BY Createddate ASC';  
            for(AccountContactRelation acr : Database.query(finalcheckQuery)){
                //     System.debug('finalcheckQuery'+finalcheckQuery);
                if(acr != null && (!String.isBlank(acr.Contact.Email) && acr.Contact.NPS_Survey_Opt_Out__c == false) 
                    && !skipemaildomains.contains(acr.contact.Email.toLowerCase().split('@').get(1))
                   && (acr.Account.Status__c == accStatus) && (!String.isBlank(acr.Account.NPS_Collection_Status__c) && !Skip_Colle_Status.contains(acr.Account.NPS_Collection_Status__c)) && (acr.Account.Contracting_Entity__c == null || !Skip_OnicaCEIds.contains(acr.Account.Contracting_Entity__c))){
                       //  System.debug('finalcheckQuery'+finalcheckQuery);
                       if(cons.containskey(acr.ContactId))
                       {
                           // System.debug('cons.containskey(acr.ContactId)'+cons.containskey(acr.ContactId));
                           cons.remove(acr.ContactId);
                           
                           
                       }
                       
                       
                   }                   
            }
            if(!acrs.values().isEmpty()){            
                // System.debug('acrs.values()'+acrs.values());
                update acrs.values();
            }
            
            if(!cons.values().isEmpty()){
                //  System.debug('cons.values().values()'+cons.values());
                update cons.values();
            }           
        }
        
    }
}