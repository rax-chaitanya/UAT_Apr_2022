public class CompanyHandler implements TriggerInterface
{
    
    public static boolean firstTgrRun = true;    
    public static boolean isLeadConverting = false;
    public static string StopBUAUCMPRecursion = 'Before Update';
    public static string StopBUAUACCRecursion = 'Before Update';
    Set<Id> RollupCMPIds = new Set<Id>();
    //SFDC-5877 by Anitha
   public Boolean isActive()
    {   
        
      if(Trigger_Manager__c.getAll().containsKey('CompanyTrigger')) {
          //  StopRecursion.resetOnce('Account');
            return Trigger_Manager__c.getInstance('CompanyTrigger').Is_Active__c;
        }
        return false;
        
    }
    
    //Added by Rajasekhar to PopulateRollupSummeryfields Asynchronously without Exception, start    
        public static void PopulateRollupSummeryAsync(set<id> cmpids){
           // System.debug('isAsync::' + IsAsyncProcess.checkIsAsyncProcess());
            if(IsAsyncProcess.checkIsAsyncProcess()){
                CompanyTriggerHelper.PopulateRollupSummeryviaFuture(cmpids);
            }else{
                CompanyTriggerHelper.PopulateRollupSummeryfields(cmpids);
            }    
        }           
    //Added by Rajasekhar to PopulateRollupSummeryfields Asynchronously without Exception, end
    
    //Added by Rajasekhar for GTMO-151 - Starts
     public Map<String,List<Account>> PopulateMatchingRecordtype(List<Account> cmpList,Map<Id, Account> aMap,String eventName){
        
        Map<String,List<Account>> CMPACCMap = new Map<String,List<Account>>();
              
        if(cmpList != null && cmpList.size()>0){            
            integer cmpAccSize = cmpList.size();               
            for(integer i=0; i<cmpAccSize; ++i){
                String recordTypeIs;
                if(System.Label.CompanyRecordTypes.contains(cmpList[i].RecordTypeId)){
                    recordTypeIs = 'Company';                       
                }else if(System.Label.AccountRecordTypes.contains(cmpList[i].RecordTypeId)){
                    recordTypeIs = 'Account';
                    RollupCMPIds.add(cmpList[i].Company_Name__c);
                }                       
                if(String.isNotBlank(recordTypeIs)){                                        
                    if(String.isNotBlank(eventName)){
                          System.debug('CheckLC:::' + cmpList[i].Is_Lead_Converting__c);
                          //System.debug('CheckLC2:::' + cmpList[i].Is_Created_From_Lead__c);
                          //System.debug('CheckLC3:::' + cmpList[i].Partner_Company__c);
                        if(cmpList[i].RecordTypeId != System.Label.Standard_Company_RecordTypeId && cmpList[i].LD_USE_DnB_Optimize__c)
                            cmpList[i].LD_USE_DnB_Optimize__c = false;
                        if(cmpList[i].Is_Lead_Converting__c != null){
                          isLeadConverting = true;
                          cmpList[i].Is_Lead_Converting__c = null;                          
                        }                       
                        if(recordTypeIs == 'Company'){
                            cmpList[i].Is_Company_Record__c = 'True';   
                            if(String.isNotBlank(cmpList[i].Industry) && (aMap == null || (aMap != null && aMap.get(cmpList[i].Id).Industry != cmpList[i].Industry)))
                                CMPACCMap.put('CMPIndustry',null);      
                        }
                        if(recordTypeIs == 'Account'){
                            cmpList[i].Is_Company_Record__c = 'False'; 
                            if(Trigger.isInsert && (cmpList[i].NotifiedSystems__c == 'Datapipe' && cmpList[i].RecordTypeId != System.Label.AccountGovernmentRecordTypeId))
                             cmpList[i].Contracting_Entity__c = System.Label.ContractingEntitiesToSkip;
                        }       
                        String dynamicReview = recordTypeIs + '_Review_Status__c';
                        if(String.isNotBlank((String)cmpList[i].get(dynamicReview))){
                            if(aMap == null || (aMap != null && aMap.get(cmpList[i].Id).get(dynamicReview) != cmpList[i].get(dynamicReview))){
                                cmpList[i].Last_Reviewed_By__c = UserInfo.getName();
                                cmpList[i].Last_Reviewed_On__c = System.Today();
                            }
                          /*  if((aMap == null && cmpList[i].get(dynamicReview) == 'Escalated to Rackspace') || 
                                ((aMap != null && cmpList[i].get(dynamicReview) == 'Escalated to Rackspace') && aMap.get(cmpList[i].Id).get(dynamicReview) != cmpList[i].get(dynamicReview))){
                                cmpList[i].Ever_Escalated_to_Rackspace__c = true;
                            } */
                        }
                    }
                    if(!CMPACCMap.containsKey(recordTypeIs))
                        CMPACCMap.put(recordTypeIs, new List<Account>());                  
                    if(CMPACCMap.containsKey(recordTypeIs))                                                
                        CMPACCMap.get(recordTypeIs).add(cmpList[i]);                       
                }                                           
            }
        }           
        return CMPACCMap;
    }
    //Added by Rajasekhar for GTMO-151 - Ends
    
    public void beforeInsert() 
    {                
        /*Added by Samba GTMO-295 Starts 
            CompanyTriggerHelper.PopulateMatchingRecordtype();
        Added by Samba GTMO-295 Ends*/
        List<Account> cmpList= (List<Account>)Trigger.new;


        Map<String,List<Account>> cmpMap = new Map<String,List<Account>>();
        Map<Id, Account> aMap = (Map<Id, Account>)Trigger.oldMap;
        cmpMap = PopulateMatchingRecordtype((List<Account>)Trigger.new,aMap,'BI');
        if(cmpMap.containsKey('Company') && cmpMap.get('Company').size()>0){            
            //UpdateTerritory.populateTerritory(cmpMap.get('Company'), aMap, 'Account');
            //UpdateCompanyMarketSegmentation.updateMrketSegment(cmpList);
            if(cmpMap.containsKey('CMPIndustry')){CompanyTriggerHelper.seismicIndustryMapping(cmpMap.get('Company'));}    
            CompanyTriggerHelper.validatePartnerRelationshipUpdate(cmpMap.get('Company'),null,null);
            CompanyTriggerHelper.populatePrimaryAddress(cmpMap.get('Company'));
            
            /*List<Account> acc = new List<Account>();
            for(Account ac : cmpMap.get('Company')){
                if(String.isNotBlank(ac.Industry)){
                    acc.add(ac);
                }
            }*/
            
            //added by sundarayya e : Converted 'Company Data Govermance' process builder to Code for CPU time Isuue
           CompanyDataGovernance.updateDataStewardApp((List<Account>)Trigger.new);
              //Added by sundarayya e: SFDC-4456 pupulate master agent info in child companies
       CompanyTriggerHelper.populateMasterAgentInfo((List<Account>)Trigger.new);
              
        }
        if(cmpMap.containsKey('Account') && cmpMap.get('Account').size()>0){            
           CompanyTriggerHelper.copyContactAddressToAcrs();                           
           CompanyTriggerHelper.populatePrimaryAddress(cmpMap.get('Account'));
           CompanyTriggerHelper.UpdateContractingEntity();
           /*if(System.Label.System_Admin_Profile.contains(UserInfo.getProfileId()) || System.Label.Datacleanuser.contains(UserInfo.getUsername()) || System.Label.DataStewardsProfileId.contains(UserInfo.getProfileId())){
          System.debug('Before Delete inside If Condition');
        return; }  else{
               UpdateTerritory.populateTerritory(cmpMap.get('Account'), null, 'Account');          
        }*/   
          
            //UpdateTerritory.populateTerritory(cmpMap.get('Account'), null, 'Account');
            
            //Added to update ParentId on Account: for SFDC-5585
            for(Account acc: cmpMap.get('Account')){
                if((acc.Company_Name__c != null)||(userinfo.getuserid().contains(Label.FMW_API_User))){
                   // system.debug('@@Company Name@@'+acc.Company_Name__c);
                    //system.debug('@@Company ID@@'+acc.Company_Name__r.Id);
                    acc.ParentId = acc.Company_Name__c;
                }
            }
            //SFDC-5585--ends
           
        }        
       
   
    }
    
    public void beforeUpdate() {           
        /*Added by Samba GTMO-295 Starts            
            CompanyTriggerHelper.PopulateMatchingRecordtype();
        Added by Samba GTMO-295 Ends*/
    
        //Added by Rajasekhar for GTMO-151 - Starts                 
        Map<String,List<Account>> cmpMap = new Map<String,List<Account>>();
        Map<Id, Account> aMap = (Map<Id, Account>)Trigger.oldMap;       
        cmpMap = PopulateMatchingRecordtype((List<Account>)Trigger.new,aMap,'BU');
        // GTMO-143 By samba start
          CompanyMoveController.recalculateActivityCount();
          // GTMO-143 By samba end          
        if(cmpMap.containsKey('Company') && cmpMap.get('Company').size()>0){
         if(!isLeadConverting || (isLeadConverting && StopBUAUCMPRecursion == 'Before Update')){
            StopBUAUCMPRecursion = 'After Update'; 
            List<Account> cmpList= cmpMap.get('Company');
            Integer cmpListSize =  cmpMap.get('Company').size();
            
            CompanyTriggerHelper.createCompanyTeamMembersFromApprovalProcess();
            UpdateTerritory.populateTerritory(cmpMap.get('Company'), aMap, 'Account');
             // Added by sundarayya E --Moved Update company market segmentation process builder to code
            UpdateCompanyMarketSegmentation.updateMrketSegment(cmpList);
            
            if(cmpMap.containsKey('CMPIndustry')){CompanyTriggerHelper.seismicIndustryMapping(cmpMap.get('Company'));}    
            Set<Id> accountIds = new Set<Id>();
            for(Integer i=0;i<cmpListSize;++i){
                if(cmpList[i].RecordTypeId == Label.Company_Partner_RecordTypeID && cmpList[i].Partner_Level__c != aMap.get(cmpList[i].Id).Partner_Level__c && !System.Label.SkipUserIDs.contains(UserInfo.getUserId()) && !System.Label.System_Administrator_Profile_Id.contains(UserInfo.getProfileId())){
                    
                    if(String.isNotBlank(cmpList[i].ParentId) && cmpList[i].Partner_Level__c == Label.PartnerLevel_MasterAgent)
                        cmpList[i].addError(System.Label.Master_Agent_Update_Error_Message);
                    else
                        accountIds.add(cmpList[i].id);
                }
            }
                //Added by Rajasekhar for GTMO-151 - Ends
            if(accountIds.size()>0)
                CompanyTriggerHelper.validatePartnerRelationshipUpdate(null,accountIds,(Map<Id, Account>)Trigger.newMap);               
                // Added by Thirupathi Aeneni For SFDC_1631-Ends
            //Added by Rajasekhar for GTMO-151 - Starts   
                  //Added by sundarayya E -- SFDC-4456 to Popukate Maser agent info field
       CompanyTriggerHelper.popMasterAgentInfoBU((List<Account>)Trigger.new, (Map<Id,Account>)Trigger.oldMap);          
          }  
          //verify merge
         
          //CompanyTriggerHelper.VerifyMerge((List<Account>)Trigger.new);       
        
        }
         //Account Trigger Handler Classes
        if(cmpMap.containsKey('Account') && cmpMap.get('Account').size()>0){
          if(!isLeadConverting || (isLeadConverting && StopBUAUACCRecursion == 'Before Update')){
             StopBUAUACCRecursion = 'After Update'; 
            //SFDC-2286
              CompanyTriggerHelper.UpdateContractingEntity();
            //Added by Anitha GTMO-150 End
            //if(!cmpMap.containsKey('CCNOChange')){
                UpdateTerritory.populateTerritory(cmpMap.get('Account'), aMap, 'Account');
            //}
          } 
            
            //Added to update ParentId on Account on Company change: for SFDC-5585
           for(Account acc: cmpMap.get('Account')){
                if(acc.Company_Name__c != null && aMap.get(acc.Id).Company_Name__c != acc.Company_Name__c){
                   // system.debug('@@Company Name@@'+acc.Company_Name__c);
                    //system.debug('@@Company ID@@'+acc.Company_Name__r.Id);
                    acc.ParentId = acc.Company_Name__c;
                }
            } 
            //SFDC-5585 --ends
        }               
        //Added by Rajasekhar for GTMO-151 - Ends       
        
        //Added by Anitha GTMO-150 Starts   
                            
    }
    
    public void beforeDelete() {
      if(System.Label.System_Admin_Profile.contains(UserInfo.getProfileId()) || System.Label.Datacleanuser.contains(UserInfo.getUsername()) || System.Label.DataStewardsProfileId.contains(UserInfo.getProfileId())){
          System.debug('Before Delete inside If Condition');
        return; }  else{
                CompanyTriggerHelper.avoidDeleteCompanies((List<Account>)Trigger.old,(Map<Id,Account>)Trigger.oldMap);            
        }             
         //CompanyTriggerHelper.avoidDeleteCompanies((List<Account>)Trigger.old,(Map<Id,Account>)Trigger.oldMap);
         
    }
    
    public void afterInsert() {
        Map<String,List<Account>> cmpMap = new Map<String,List<Account>>();
        Map<Id, Account> aMap = (Map<Id, Account>)Trigger.oldMap;          
        cmpMap = PopulateMatchingRecordtype((List<Account>)Trigger.new,aMap,null); 
        if(cmpMap.containsKey('Company') && cmpMap.get('Company').size()>0){
            NetworkMemberHelper.addReputationPointsToPrimaryMember();//Added by Thirupathi Aeneni for SFDC - 3006
            List<Account> cmpListNew= (List<Account>)Trigger.new;   
            List<Account> partnerCompanies = new List<Account>();
            Id recordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
            //System.debug('cmpMap.getAccount......' + cmpMap.get('Account'));
            for(Account a : cmpListNew){ 
            if((a.RecordTypeId == recordTypeId && a.Partner_Account_Status__c == 'Approved') || String.isNotBlank(a.Partner_Company__c))    
                    partnerCompanies.add(a);    
            }   
            if(!partnerCompanies.isEmpty()) 
                CommunitySharingHelper.shareRecordsOnCreation(partnerCompanies, 'Account'); 
            // Added by Anjaneyulu for SFDC-2116 - Ends 
            // Added By Anwesh for SFDC-3627 -Starts    
          CompanyTriggerHelper.AddCompanyTeamMember(cmpMap.get('Company')); 
            // Added By Anwesh for SFDC-3627 - Ends 
            
          // Added by sundarayya E --Moved Update company market segmentation process builder to code
         CompanyDataGovernance.SubmitRecForApproval((List<Account>)Trigger.new);                                                      
        }
      if(cmpMap.containsKey('Account') && cmpMap.get('Account').size()>0){
             //Added by Rajasekhar
             CompanyTriggerHelper.AddCompanyTeamMember(cmpMap.get('Account'));              
            //Added by Anitha For GTMO-325
            CompanyTriggerHelper.insertAccountRole(); 
          //GTMO-466, Populate rollup Fields on Company, Samba, Start          
           PopulateRollupSummeryAsync(RollupCMPIds);                          
        //GTMO-466, Populate rollup Fields on Company, Samba, end  
         //Added for defect :SFDC-5556  
        
      //   CompanyTriggerHelper.createOrUpdateAccountTeamMembers();    
          
          //Added for SFDC-5613
         //  CompanyTriggerHelper.addTransitionManagerRoleOnCompanyTeam();
            //  Added for  SFDC-6380 merged Account Manager and Transition Manager 
             CompanyTriggerHelper.UpdateTeamMembersBasedOnManager('Transition Manager');
             CompanyTriggerHelper.UpdateTeamMembersBasedOnManager('Account Manager');

       }
                
    }
    
    public void afterUpdate() {
         
        //Added by Rajasekhar for GTMO-151 - Starts     
        Map<String,List<Account>> cmpMap = new Map<String,List<Account>>();
        Map<Id, Account> aMap = (Map<Id, Account>)Trigger.oldMap;
        cmpMap = PopulateMatchingRecordtype((List<Account>)Trigger.new,aMap,null);
        if(cmpMap.containsKey('Company') && cmpMap.get('Company').size()>0){
          if(!isLeadConverting || (isLeadConverting && StopBUAUCMPRecursion == 'After Update')){
            StopBUAUCMPRecursion = 'Stop Recursion';
            System.debug('cmpmap after:' + cmpMap.get('Company'));
            //Added by Rajasekhar for GTMO-151 - Ends 
            If(NetworkMemberHelper.After_Update){
                NetworkMemberHelper.addReputationPointsToPrimaryMember ();//Added by Thirupathi Aeneni for SFDC - 3006
            }
            /*if(!System.isFuture() && !System.isBatch() && !Test.isRunningTest()) {
                UpdateFortuneRank.rankUpdate(cmpMap.get('Company'), aMap);
            }*/
            // Added by Anjaneyulu for SFDC-2116 - Starts
            if(CompanyTriggerController.SHARE_TO_PARTNERS){
                CompanyTriggerController.SHARE_TO_PARTNERS = false;
                List<Account> partnerCompanies = new List<Account>();
                Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
                Set<Id> activateUsers = new Set<Id>();
                Set<Id> deactivateUsers = new Set<Id>();
                for(Account a : cmpMap.get('Company')){       
                    System.debug('Partner_Account_Status__c:' + a.Partner_Account_Status__c);         
                    System.debug('RecordTypeId:' + a.RecordTypeId);         
                    System.debug('OldPartner_Account_Status__c:' + aMap.get(a.Id).Partner_Account_Status__c);  
                    system.debug('Parcompany ReId'+ a.Partner_Company__c);
                    system.debug('Par oldcompany ReId'+ aMap.get(a.Id).Partner_Company__c);
                    if((a.RecordTypeId == recordTypeId && (a.Partner_Account_Status__c == 'Approved' && aMap.get(a.Id).Partner_Account_Status__c != 'Approved')) || 
                       (String.isNotBlank(a.Partner_Company__c) && String.isBlank(aMap.get(a.Id).Partner_Company__c))){
                           // activateUsers.add(a.Id);
                           partnerCompanies.add(a);
                       }
                    // Added by Anjaneyulu for SFDC-2116 - Ends 
                    
                    if(a.RecordTypeId == recordTypeId && a.Partner_Account_Status__c == 'Inactive' && aMap.get(a.Id).Partner_Account_Status__c != 'Inactive')
                        deactivateUsers.add(a.Id);
                    
                    if(a.RecordTypeId == recordTypeId && ((a.Partner_Account_Status__c == 'Active' && aMap.get(a.Id).Partner_Account_Status__c != 'Active')))
                        activateUsers.add(a.Id);
                }
                
                if(!partnerCompanies.isEmpty()){
                    CommunitySharingHelper.shareRecordsOnCreation(partnerCompanies, 'Account');
                    CompanyTriggerHelper.createPartnerUser(partnerCompanies);
                }        
                // Added by Anjaneyulu for partner community sharing - Ends
                if(!deactivateUsers.isEmpty())
                    CommunitySharingHelper.activeInactiveUsers(deactivateUsers, false);
                if(!activateUsers.isEmpty())
                    CommunitySharingHelper.activeInactiveUsers(activateUsers, true);
                
            }  
            //Added by Thirupathi Aeneni for SFDC - 1631 - Starts
                CompanyTriggerHelper.removeOrUpdateCommunitySharing();
            //Added by Thirupathi Aeneni for SFDC - 1631 - Ends
            /***************************Added By Biswa for SFDC-2155 - Start**********************/
                CompanyTriggerHelper.AddRemoveAccTM();
            
            /***************************Added By Biswa for SFDC-2155 - End**********************/
              // Added By Anwesh for SFDC-3627 -Starts
                CompanyTriggerHelper.AddCompanyTeamMember(cmpMap.get('Company'));
            // Added By Anwesh for SFDC-3627 - Ends 
             //SFDC-5631 by surendra
        CompanyTriggerHelper.createOppTeaMember();
        //5631 end
          }  
          //verify merge
         
          //CompanyTriggerHelper.VerifyMerge((List<Account>)Trigger.new);            
                  // addes by sundarayya E--SFDC-5701 to update related contacts 
        // Converting process builder : GTMO_AutoUpdateRegionAndPartnerlevelOnContact
        Map<Id, Account> accMap =(Map<Id, Account>)Trigger.oldMap;
        Set<Id> newAccIds = new Set<Id>();
        Set<Id> optOutAccIds = new Set<Id>();
        //Map<Id, Account> accNewMap = new Map<Id, Account>();
        Id recordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
        for(Account acc: (List<Account>)Trigger.New){
            //system.debug('partner level'+acc.Partner_Level__c);
           // system.debug('partner level old '+accMap.get(acc.Id).Partner_Level__c);
           // system.debug('opt out '+acc.Opt_Out__c);
           // system.debug('opt out old'+accMap.get(acc.Id).Opt_Out__c);
            if((acc.RecordTypeId == recordTypeId && 
               (acc.Partner_Level__c != accMap.get(acc.Id).Partner_Level__c || acc.Territory__c != accMap.get(acc.Id).Territory__c)) || 
                acc.Opt_Out__c != accMap.get(acc.Id).Opt_Out__c){
                   //accNewMap.put(acc.Id, acc);
                   newAccIds.add(acc.Id);
               }
            /*if(acc.Opt_Out__c != accMap.get(acc.Id).Opt_Out__c && acc.Opt_Out__c == true){
                optOutAccIds.add(acc.Id);
            }else if(acc.Opt_Out__c != accMap.get(acc.Id).Opt_Out__c && acc.Opt_Out__c == false){
                optOutAccIds.add(acc.Id);
            }*/
        }
        if(newAccIds.size() > 0){
            system.debug('newAccIds.size()'+newAccIds.size());
                CompanyTriggerHelper.updateRegionAndPartLevelOnContact(newAccIds);}
           // system.debug('optOutAccIds......'+optOutAccIds);
        //if(optOutAccIds.size() > 0){CompanyTriggerHelper.updateRegionAndPartLevelOnContact(optOutAccIds, false, true);}
        //ended sfdc-5701 added by sundarayya  

       
        }

        //Account Trigger Handler Classes
        if(cmpMap.containsKey('Account') && cmpMap.get('Account').size()>0){
        //System.debug('Inside....');
          if(!isLeadConverting || (isLeadConverting && StopBUAUACCRecursion == 'After Update')){
            StopBUAUACCRecursion = 'Stop Recursion';
            //System.debug('accountsData:' + cmpMap.get('Account').size());
            //Added by Rajasekhar for GTMO-151 - Starts         
                CompanyTriggerHelper.unlockRecord(cmpMap.get('Account'),aMap);
            //Added by Rajasekhar for GTMO-151 - Ends
             //GTMO-466, Populate rollup Fields on Company, Samba, Start              
            PopulateRollupSummeryAsync(RollupCMPIds);                        
            //GTMO-466, Populate rollup Fields on Company, Samba, end
            // Added By Anwesh for SFDC-3627 -Starts
            CompanyTriggerHelper.AddCompanyTeamMember(cmpMap.get('Account'));   
            // Added By Anwesh for SFDC-3627 - Ends 
             //Added for defect :SFDC-5556  
       //  CompanyTriggerHelper.createOrUpdateAccountTeamMembers(); 
              //Added for SFDC-5613
        //   CompanyTriggerHelper.addTransitionManagerRoleOnCompanyTeam();
              // Added for  SFDC-6380 merged Account Manager and Transition Manager 
              CompanyTriggerHelper.UpdateTeamMembersBasedOnManager('Transition Manager');
             CompanyTriggerHelper.UpdateTeamMembersBasedOnManager('Account Manager');
             //SFDC-5682 : To check and update NPS Contact Role and NPS Contact created Date - Start    
                  //SFDC-5682 : To check and update NPS Contact Role and NPS Contact created Date - Start
                Set<Id> accSetIds = new Set<Id>();
                List<Id> accIds = new List<Id>();
                accSetIds.addAll((Set<Id>)Trigger.newMap.keySet());
                accIds.addAll(accSetIds); 
           // System.debug('checkdata....'+accIds);
                 NPS_Contact_and_Role_Creation.checkNPSContactEligiblityAsync(accIds);
             //SFDC-5682 : To check and update NPS Contact Role and NPS Contact created Date - End    
               
          }   
        }                           
    }
 public void afterDelete(){
      Map<String,List<Account>> cmpMap = new Map<String,List<Account>>();
           Map<Id, Account> aMap = (Map<Id, Account>)Trigger.oldMap;
              cmpMap = PopulateMatchingRecordtype((List<Account>)Trigger.old,aMap,null);
            if(cmpMap.containsKey('Company') && cmpMap.get('Company').size()>0){
                 DeleteUndeleteTriggerHandler.DeleteUndelete(cmpMap.get('Company'), 'Account');
            }
            if(cmpMap.containsKey('Account') && cmpMap.get('Account').size()>0){
                 DeleteUndeleteTriggerHandler.DeleteUndelete(cmpMap.get('Account'), 'Account');
                //GTMO-466, Populate rollup Fields on Company, Samba, Start                     
                PopulateRollupSummeryAsync(RollupCMPIds);                
                //GTMO-466, Populate rollup Fields on Company, Samba, end 
            } 
          //  if(System.Label.System_Admin_Profile.contains(UserInfo.getProfileId())){
           DeleteUndeleteTriggerHandler.MergeAccounts((List<Account>)Trigger.old);
     // }
    }
    
    public void afterUndelete() {}
    
}