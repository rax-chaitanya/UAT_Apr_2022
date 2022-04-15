/**********************************************************************************

Author: Sundarayya e
Description: This Batch class is  to run new logic to update bucket source on opp's created from Jan 1st 2020.
date : 10/30/2020

**********************************************************************************/
global class BucketSourceBatchClass implements Database.Batchable<sObject>{
    
    global database.queryLocator start(Database.BatchableContext BC) 
    {
        return database.getQueryLocator([SELECT Id, Max_Lead_Role__c,Bucket_Source__c, LeadSource,CampaignId, Created_from_Lead__c, Market_Source__c, 
                                         owner.UserRole.name, Owner.Profile.Name, Owner.ProfileId, CreatedDate, CloseDate, StageName, Lead_Generator__r.Profile.Name,OwnerId,
                                         (Select Id, Name, Role__c, Status__c, CreatedDate, Opportunity__c from Partner_Roles__r where Role__c = 'Source' limit 1)
                                         FROM Opportunity where  
                                         //Id = '0064N00000YbjNvQAJ']);
                                         CreatedDate  >= 2019-01-01T00:00:00.000Z OR CloseDate >= 2019-01-01]);
    } 
    
    global void execute(Database.BatchableContext BC, List<Opportunity> OppsList) 
    { 
        Boolean hasLeadSource;
        Boolean hasCloudRole;
        Boolean hasSourcePR;
        Boolean mktSourced;
        Boolean hasSdrRole;	
        Boolean hasCSMRole;
        
        List<ErrorLog__c> errorslist=new  List<ErrorLog__c>();
        Map<Id, Opportunity> OppsMap = new Map<Id, Opportunity>();
        List<Opportunity> updateOpps = new List<Opportunity>(); 
        
        List<String> listSdrProfiles = new List<String>();
        List<String> listLeadSource = new List<String>();
        List<String> listBucktRoles = new List<String>();
        Map<String, Roles_BucketSource__c> bucketRolesMap = Roles_BucketSource__c.getall();
        Map<String, LeadSource_for_Bucket__c> leadsourceMap = LeadSource_for_Bucket__c.getall();
        Map<String, SDR_Profiles_for_bktSrc__c> sdrProfilesMap = SDR_Profiles_for_bktSrc__c.getall();
        
        for(String key : sdrProfilesMap.keySet()){
            listSdrProfiles.add(sdrProfilesMap.get(key).sdr_Profile__c);
        }
        for(String key : leadsourceMap.keySet()){
            listLeadSource.add(leadsourceMap.get(key).lead_source__c);
        }
        for(String key : bucketRolesMap.keySet()){
            listBucktRoles.add(bucketRolesMap.get(key).User_Role__c);
        }
               
        Map<Id, String> oppIdToUserRole = new map<Id, String>();   
        Map<Id, String> userIdToProfile = new Map<Id, String>();
        Map<Id, String> userIdtoProfileId = new Map<Id, String>();
        Map<Id, Opportunity> newOppMap = new Map<Id, Opportunity>();
        Map<Id, Partner_Role__c> oppIdToPRolesMap = new Map<Id, Partner_Role__c>();
        //List<Opportunity> ownerRoles = [select Id, Owner.UserRole.Name,Lead_Generator__r.Profile.Name,Owner.Profile.Name,(Select Id, Name, Role__c, Status__c, Opportunity__c from Partner_Roles__r where Role__c = 'Source' limit 1) from Opportunity where Id =: OppsMap.Keyset()];
                
        for(Opportunity Opp : OppsList){
            if(Opp.Lead_Generator__r.Profile.Name != null)
                userIdToProfile.put(Opp.Id, Opp.Lead_Generator__r.Profile.Name);
                if(opp.Owner.userRole.Name != null)
                oppIdToUserRole.put(opp.Id, opp.Owner.userRole.Name);
                userIdtoProfileId.put(opp.Id, Opp.Owner.ProfileId);
                if(opp.Partner_Roles__r.size() > 0){
                    //newOppMap.put(Opp.Id, Opp);
                    decimal Hours = decimal.valueof((opp.CreatedDate.getTime() - opp.Partner_Roles__r[0].CreatedDate.getTime())/(60*60));
                    Integer hoursDiff=Integer.valueOf((Hours/1000));
                    if(hoursDiff < 0){
                        hoursDiff = hoursDiff * -1;
                      }        
                    if(hoursDiff < 24)
                        newOppMap.put(Opp.Id, Opp);
                }
        }
        for(Opportunity Opp : OppsList){
            hasLeadSource = false;
            hasCloudRole = false;
            hasSourcePR = false;
            mktSourced = false;
            hasSdrRole = false;
            hasCSMRole = false;
            
            
            if(Opp.LeadSource != Null && listLeadSource.contains(opp.LeadSource)){
                hasLeadSource = true;
            }
            
            if(oppIdToUserRole.containsKey(Opp.Id) && listBucktRoles.contains(oppIdToUserRole.get(Opp.Id)))
            {  
                hasCloudRole = true;
                
            }
            
            if(Opp.Market_Source__c=='Yes' && !Test.isRunningTest())
                mktSourced=true;
            
            
            if(newOppMap.containsKey(Opp.id)) //if there are partner roles
            {
                hasSourcePR=true;
            }
            
            if(String.isNotBlank(Opp.Max_Lead_Role__c) && listSdrProfiles.contains(userIdToProfile.get(Opp.Id))){
                hasSdrRole = true;
            }
            
            if((System.Label.CSM_Profiles_for_Bckt_Scr.contains(userIdtoProfileId.get(opp.Id)) && !listBucktRoles.contains(oppIdToUserRole.get(opp.Id))) )
                {  
                                       
                  hasCSMRole = true;
                    system.debug('hasCSMRole'+hasCSMRole);
                }
            
            if(hasSourcePR)
                Opp.Bucket_Source__c = 'Partner';
            else if(hasSdrRole)
                Opp.Bucket_Source__c = 'Marketing';
            else if(Opp.LeadSource == 'Alliance')
                Opp.Bucket_Source__c = 'Partner';
            else if(hasLeadSource == true && opp.Created_from_Lead__c == true) 
                Opp.Bucket_Source__c = 'Marketing';                
            else if(Opp.LeadSource == 'Partner Network' &&  hasCloudRole == true)
                Opp.Bucket_Source__c = 'Marketing';
            else if((Opp.LeadSource == 'Partner Network' && hasCloudRole == false) || 
                    (Opp.LeadSource == 'Partner Portal' || Opp.LeadSource == 'Partner Campaign' ))
                Opp.Bucket_Source__c = 'Partner';
            else if(Opp.CampaignId != Null && opp.Created_from_Lead__c == true && !hasCSMRole)
                Opp.Bucket_Source__c = 'Marketing';
            else if(mktSourced)                       
                Opp.Bucket_Source__c = 'Marketing';
            
            else 
            {
                Opp.Bucket_Source__c = 'Sales';                
            }
            
            updateOpps.add(Opp);
            
        }
        
        if(updateOpps.size() > 0){
            Database.SaveResult [] updateResult = Database.update(updateOpps, false);
            
            for(Integer i=0;i<updateResult.size();i++){
                if( !Test.isRunningTest()){
                if (!updateResult.get(i).isSuccess()){
                    
                    Database.Error error = updateResult.get(i).getErrors().get(0);
                    //system.debug('Failed ID: '+contoupdate.get(i).Id + 'Error msg: '+ error.getMessage());
                    ErrorLog__c errordetails = new Errorlog__c();
                    errordetails.RecordID__c = (String)updateOpps.get(i).Id;
                    errordetails.Message__c = error.getMessage();
                    errordetails.Object_name__c = 'Opportunity';
                    errorslist.add(errordetails);
                }
                }
                
            }
            
        }
        if(errorslist.size()> 0)
        {
            Database.insert(errorslist,false);
        }
        
        
    } 
    global void finish(Database.BatchableContext BC) {
        
    }
}