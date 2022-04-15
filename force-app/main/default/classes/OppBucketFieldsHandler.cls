/**********************************************************************************

Author: Rajesh Sukamanchi
Description: This apex class is Populate/Update values of Bucket_source & Bucket_Influence fields on Opportunity

**********************************************************************************/
public class OppBucketFieldsHandler 
{   
     Public static void bucketTriggerCheck(List<Opportunity> OppsList, Map<ID,Opportunity> OppsOldMap)
    {
     Map<Id, Opportunity> OppMap = new Map<Id, Opportunity>();
        Map<Id, Opportunity> OppMap1 = new Map<Id, Opportunity>();
        
        for(Opportunity Opp: OppsList)
        {
            /*if(opp.Market_Source__c != OppsOldMap.get(Opp.id).Market_Source__c || 
               opp.Max_Lead_Role__c != OppsOldMap.get(Opp.id).Max_Lead_Role__c ||
               opp.CampaignID       != OppsOldMap.get(Opp.id).CampaignID       ||
               FeatureFlag__c.getInstance('BucketLogic_DM').Enabled__c)
            {
                OppMap.put(Opp.id,Opp);
            }*/
            
             if((opp.Bucket_Source__c != 'Marketing' && opp.Bucket_Source__c != 'Partner') &&   
               (opp.Market_Source__c != OppsOldMap.get(Opp.id).Market_Source__c || 
                opp.Max_Lead_Role__c != OppsOldMap.get(Opp.id).Max_Lead_Role__c ||
                opp.CampaignID       != OppsOldMap.get(Opp.id).CampaignID       ||
                opp.LeadSource       != OppsOldMap.get(Opp.Id).LeadSource       ||
                FeatureFlag__c.getInstance('BucketLogic_DM').Enabled__c))
                //system.debug('entered'+ opp.Bucket_Source__c);
                OppMap1.put(Opp.id,Opp);
        }
        
       // if(!OppMap.isEmpty())
         //  updateBucketFields(OppMap, null, false, true, false);
        if(!OppMap1.isEmpty())
            updateBucketSourceField(OppMap1, null, false, true);
    }
  
   //Added By Sundarayya E -SFDC-4612 and modified with new requirement SFDC-5100 and SFDC-5308
    public Static void updateBucketSourceField(Map<ID,Opportunity> OppsMap, List<Opportunity> OppsList, Boolean isOppTriggerInsert, Boolean isOppTriggerUpdate)
    {
        Set<Id> ownerandLeadgenIds = new Set<Id>();
        Set<Id> leadgenId = new Set<Id>();
        List<String> leadnum = new List<String>();
        Id currentUserId = UserInfo.getUserId();
        if(isOppTriggerInsert){
            for(Opportunity opp :OppsList ){
                ownerandLeadgenIds.add(opp.OwnerId);
                ownerandLeadgenIds.add(currentUserId);
                if(opp.Lead_ID__c != null){
                    leadnum.add(opp.Lead_ID__c);
                }
                if(Opp.Lead_Generator__c != null){
                    ownerandLeadgenIds.add(Opp.Lead_Generator__c);
                }
                
            }
        }
        if(isOppTriggerUpdate){
            system.debug('update action fired');
            for(Opportunity opp :OppsMap.values()){
                if(opp.Bucket_Source__c != 'Marketing' && opp.Bucket_Source__c != 'Partner'){
                    ownerandLeadgenIds.add(opp.OwnerId);
                    ownerandLeadgenIds.add(currentUserId);
                    if(Opp.Lead_Generator__c != null){
                        ownerandLeadgenIds.add(Opp.Lead_Generator__c);
                        //system.debug('Lead gen Profile'+ Opp.Lead_Generator__c);
                    }
                }
            }
            
        }
        
        Map<Id, String> userIdToUserRole = new Map<Id, String>();
        Map<Id, String> leadgenUserIdToProName = new Map<Id, String>();
        Map<Id, Id> userIdtoProfileId = New Map<Id,Id>();
        //Id currentUserId = UserInfo.getUserId();
        List<User> UserandLeadGenData = [select Id, UserRole.name, ProfileId,Profile.Name from user where Id IN:ownerandLeadgenIds];
        
        /*if(leadgenId.size() > 0){
            for(user ur : [select id, ProfileId,Profile.name from user where Id =: leadgenId]){
                leadgenUserIdToProName.put(ur.Id , ur.Profile.Name);
            }
        }*/
        //system.debug('leadgenId'+leadgenId);
        //system.debug('leadgenUserIdToProName'+ leadgenUserIdToProName);
        for(User ur : UserandLeadGenData){
            if(String.isNotBlank(ur.UserRole.name )){
                userIdToUserRole.put(ur.Id, ur.userRole.name);
            }
            userIdtoProfileId.put(ur.Id,ur.ProfileId);
            leadgenUserIdToProName.put(ur.Id , ur.Profile.Name);
        }
        
        Boolean hasSourcePR;
        Boolean hasSdrRole;
        Boolean mktSourced;
        Boolean hasCloudRole;
        Boolean hasLeadSource;
        string oppOwnerRole;
        Boolean hasCSMRole;
        List<Opportunity> OppsToUpdateBucket;
        List<String> listSdrProfiles = new List<String>();
        List<String> listLeadSource = new List<String>();
        List<String> listBucktRoles = new List<String>();
        List<String> listBucktCSMRoles = new List<String>();
        Map<String, Roles_BucketSource__c> bucketRolesMap = Roles_BucketSource__c.getall();
        Map<String, LeadSource_for_Bucket__c> leadsourceMap = LeadSource_for_Bucket__c.getall();
        Map<String, SDR_Profiles_for_bktSrc__c> sdrProfilesMap = SDR_Profiles_for_bktSrc__c.getall();
         //Map<String, CSM_Role_for_Buckt_Src__c> csmUserRoleMap = CSM_Role_for_Buckt_Src__c.getall();
                
        for(String key : sdrProfilesMap.keySet()){
            listSdrProfiles.add(sdrProfilesMap.get(key).sdr_Profile__c);
        }
        /* for(String key : csmUserRoleMap.keySet()){
            listBucktCSMRoles.add(csmUserRoleMap.get(key).CSM_Role__c);
        }*/
        for(String key : leadsourceMap.keySet()){
            listLeadSource.add(leadsourceMap.get(key).lead_source__c);
        }
        for(String key : bucketRolesMap.keySet()){
            listBucktRoles.add(bucketRolesMap.get(key).User_Role__c);
        }
        
        if(isOppTriggerInsert)
            OppsToUpdateBucket = OppsList;
        else
            OppsToUpdateBucket = OppsMap.values();
        
               
        
        integer hoursDiff;
        List<opportunity> oppPRUpList = new List <Opportunity>();
       	List<Opportunity> updateOpps = new List<Opportunity>(); 
        Map<Id,Opportunity> newOppMap = new Map<Id, Opportunity>();
        Map<Id, Opportunity> prAfterTimeWindowList = new Map<Id, Opportunity>();
        Map<String, Partner_Role__c> LeadNumToPR = new Map<String, Partner_Role__c>();
        
        if(isOppTriggerInsert && leadnum.size() > 0){
            List<Partner_Role__c> PRlist = new List<Partner_Role__c>();
            for(Partner_Role__c leadPr : [Select Id, Lead__c,Lead__r.Lead_ID__c,CreatedDate from Partner_Role__c where Role__c = 'Source' and Lead__r.Lead_ID__c IN : leadnum]){
                system.debug('leadPr@@' + leadPr);
                LeadNumToPR.put(leadPr.Lead__r.Lead_ID__c, leadPr );
            }
            for(Opportunity oppPR :OppsList ){
               if(oppPR.Lead_ID__c != null && LeadNumToPR.containsKey(oppPR.Lead_ID__c) ){
                   //commented out for SFDC-6267 
                   //if the lead is having a partner role before converting we need to consider those partner roles as source no need to consider 24 hrs window
                    /* decimal Hours = decimal.valueof((system.now().getTime() - LeadNumToPR.get(oppPR.Lead_ID__c).CreatedDate.getTime())/(60*60));
                    hoursDiff = Integer.valueOf((Hours/1000));
                    if(hoursDiff < 0){
                        hoursDiff = hoursDiff * -1;
                    }        
                    if(hoursDiff < 24){*/
                        newOppMap.put(oppPR.Id, oppPR);
                   /* }else{
                        prAfterTimeWindowList.put(oppPR.Id, oppPR);
                    }*/
                }
            }
        }else if(!isOppTriggerInsert){
            oppPRUpList = [Select ID, Name,CreatedDate, (Select Id, Name, Role__c, Status__c, Opportunity__c,CreatedDate from Partner_Roles__r where Role__c = 'Source' limit 1) from Opportunity where ID IN :OppsMap.keySet()];
        }
        if(oppPRUpList.size() > 0){
            for(Opportunity opp: oppPRUpList)
            {
                //added for SFDC-6267
                //if the opp updated and opp createddate greater than partner role date consoder partner roles as source
                if(opp.Partner_Roles__r.size() > 0 ){
                    if(opp.CreatedDate >= opp.Partner_Roles__r[0].CreatedDate){
                        newOppMap.put(Opp.Id, Opp);
                        system.debug('pr created before');
                    }else if(opp.CreatedDate < opp.Partner_Roles__r[0].CreatedDate){
                    decimal Hours = decimal.valueof((opp.CreatedDate.getTime() - opp.Partner_Roles__r[0].CreatedDate.getTime())/(60*60));
                    system.debug((Hours/1000));
                    hoursDiff=Integer.valueOf((Hours/1000));
                    /*if(hoursDiff < 0){
                        hoursDiff = hoursDiff * -1;
                      }   */  
                    system.debug('hoursDiff'+hoursDiff);
                    if(hoursDiff < 24){
                        newOppMap.put(Opp.Id, Opp);
                    }else{
                        prAfterTimeWindowList.put(Opp.Id, Opp);
                    }
                }
                }
            }
        }
        
        for(Opportunity opp: OppsToUpdateBucket)
        {
           system.debug('opp.Bucket_Source__c'+opp.Bucket_Source__c);
            if(opp.Bucket_Source__c != 'Marketing' && opp.Bucket_Source__c != 'Partner'){
                system.debug('entered to logic');
                hasSourcePR = false;
                hasSdrRole = false;
                mktSourced = false;
                hasCloudRole = false;
                hasLeadSource = false;
                hasCSMRole = false;
                if(Opp.LeadSource != Null && listLeadSource.contains(opp.LeadSource)){
                    hasLeadSource = true;
                }
               
                if(userIdToUserRole.get(Opp.OwnerId) != Null && listBucktRoles.contains(userIdToUserRole.get(Opp.OwnerId)))
                {  
                  hasCloudRole = true;
                }
                
                if((System.Label.CSM_Profiles_for_Bckt_Scr.contains(UserInfo.getProfileId()) && !listBucktRoles.contains(userIdToUserRole.get(currentUserId)))	
                    || (System.Label.CSM_Profiles_for_Bckt_Scr.contains(userIdtoProfileId.get(opp.OwnerId)) && !listBucktRoles.contains(userIdToUserRole.get(opp.OwnerId))) )
                {  
                                       
                  hasCSMRole = true;
                    system.debug('hasCSMRole'+hasCSMRole);
                }
                
                if(Opp.Market_Source__c=='Yes')
                    mktSourced=true;
                
                
                if((isOppTriggerUpdate || isOppTriggerInsert && leadnum.size() > 0)  && newOppMap.containsKey(Opp.id)) 
                {
                    hasSourcePR=true;
                }
               
                if(leadgenUserIdToProName.containsKey(Opp.Lead_Generator__c) && listSdrProfiles.contains(leadgenUserIdToProName.get(Opp.Lead_Generator__c))){
                    hasSdrRole = true;
                   // system.debug('sdr profiles'+hasSdrRole);
                }
                
                if(hasSourcePR){
                    Opp.Bucket_Source__c = 'Partner';
                system.debug('entered to parner role');
                }
                //Created as part of SFDC-5101 by Manohar
                //else if(Opp.LeadSource == 'Content Syndication' || Opp.LeadSource == 'Organic Media' || Opp.LeadSource == 'Outbound' || Opp.LeadSource == 'E-Mail')
                  //  Opp.Bucket_Source__c = 'Marketing';
                //End of SFDC-5101   
                else if(hasSdrRole){
                    Opp.Bucket_Source__c = 'Marketing';
                system.debug('entered to Step2');
                }
                else if(Opp.LeadSource == 'Alliance'){
                    Opp.Bucket_Source__c = 'Partner';
                    system.debug('entered to Step3');
                //system.debug('entered alliance');
                }
                else if(hasLeadSource == true && opp.Created_from_Lead__c == true) {
                    Opp.Bucket_Source__c = 'Marketing';       
                system.debug('entered to Step4');
                }
                else if(Opp.LeadSource == 'Partner Network' &&  hasCloudRole == true){
                    Opp.Bucket_Source__c = 'Marketing';
                system.debug('entered to Step5');
                }
                else if((Opp.LeadSource == 'Partner Network' && hasCloudRole == false) || 
                        (Opp.LeadSource == 'Partner Portal' || Opp.LeadSource == 'Partner Campaign' )){
                    Opp.Bucket_Source__c = 'Partner';
                            system.debug('entered to Step6');
                //system.debug('entered lead source');
                        }
                else if(Opp.CampaignId != Null && opp.Created_from_Lead__c == true && !hasCSMRole){
                    Opp.Bucket_Source__c = 'Marketing';
                system.debug('entered to Step7');
                }
                else if(mktSourced){                  
                    Opp.Bucket_Source__c = 'Marketing';
                system.debug('entered to Step8');
                }
                else 
                {
                    Opp.Bucket_Source__c = 'Sales';      
                    system.debug('entered to Step9');
                }
                //added for SFDC-6267 if the bucket source is Sales and partner role added after 24hrs of creation then update to partner
                if(Opp.Bucket_Source__c == 'Sales' && prAfterTimeWindowList.containsKey(opp.Id)){
                    Opp.Bucket_Source__c = 'Partner';
                    system.debug('entered to Step10');
                }
                                                                  
            }
        }// Opp for loop
        
       // if(updateOpps.size()>0)
           // update updateOpps;
        
        
    }
   
   
    public static void updateBucketFields(Map<ID,Opportunity> OppsMap, List<Opportunity> OppsList, Boolean isOppTriggerInsert, Boolean isOppTriggerUpdate, Boolean isPtnrCall)
    {
        Boolean hasSourcePR;
        Boolean hasInfluencePR;
        Boolean mktSourced;
        Boolean qTeamRole;
        Boolean hasCampaign;
        List<Opportunity> OppsToUpdateBucket;
        List<Roles_MktSourced__c> MktSrcRoles = Roles_MktSourced__c.getall().values();
        
        
        //get Opps
        if(isOppTriggerInsert)
            OppsToUpdateBucket = OppsList;
        else
            OppsToUpdateBucket = OppsMap.values();
        
        List<Opportunity> updateOpps = new List<Opportunity>();        
        Map<Id,Opportunity> newOppMap = new Map<Id, Opportunity>();
        
        if(!isOppTriggerInsert)
            for(Opportunity opp: [Select ID, Name, (Select Id, Name, Role__c, Status__c, Opportunity__c from Partner_Roles__r where Status__c='Approved') from Opportunity where ID IN :OppsMap.keySet()])
        {
            newOppMap.put(Opp.id, Opp);
        }
        //Loop through Opps to match criteria for Bucket logic
        for(Opportunity opp: OppsToUpdateBucket)
        {
            hasSourcePR=false;
            hasInfluencePR=false;
            mktSourced=false;
            qTeamRole=false;
            hasCampaign=false;            
            
            if(String.isNotBlank(Opp.Max_Lead_Role__c))
            {
                for(Roles_MktSourced__c MktRl: MktSrcRoles) //Updated 8/29 - Raj - SFGETE 323
                {
                    if(Opp.Max_Lead_Role__c.contains(MktRl.Max_Lead_Role__c))
                    {
                        Opp.Market_Source__c = 'Yes';
                        qTeamRole=true;
                        break;
                    }
                }     
            }
            
            if(Opp.Market_Source__c=='Yes')
                mktSourced=true;
            
            if(Opp.CampaignID!=null)
                hasCampaign=true;
            
            if(isOppTriggerUpdate && newOppMap.get(Opp.id).Partner_Roles__r.size()>0) //if there are partner roles
            {
                for(Partner_role__c pr: newOppMap.get(Opp.id).Partner_Roles__r)
                {
                    if(pr.Role__c=='Source')
                    {
                        hasSourcePR=true;
                        break;
                    }
                    else if(pr.Role__c=='Influence')
                        hasInfluencePR=true;
                }                
                
                if(qTeamRole)
                {
                    Opp.Market_Source__c = 'Yes';
                    if(hasSourcePR)
                    {
                        if(hasCampaign)                                     // #4
                        {
                            //Opp.Bucket_Source__c = 'Partner';
                            Opp.Bucket_Influence__c = 'Marketing';
                        }
                        else                                                // #3
                        {
                            //Opp.Bucket_Source__c = 'Partner';
                            Opp.Bucket_Influence__c = '';
                        }
                    }
                    else if(hasInfluencePR)                                // #5a
                    {
                        //Opp.Bucket_Source__c = 'Marketing';
                        Opp.Bucket_Influence__c = 'Partner';
                    }
                }
                
                else //not qTeam
                {
                    if(mktSourced)                                        
                    {
                        //Opp.Bucket_Source__c = 'Marketing';            // #1c , 1d
                        Opp.Bucket_Influence__c = 'Partner';                   
                    }
                    else //not mktSourced
                    {
                        if(hasSourcePR)
                        {
                            if(hasCampaign)                            // #2a
                            {
                                // Opp.Bucket_Source__c = 'Partner';
                                Opp.Bucket_Influence__c = 'Marketing';
                            }
                            else                                        // #1a
                            {
                                // Opp.Bucket_Source__c = 'Partner';
                                Opp.Bucket_Influence__c = '';
                            }
                        }
                        else if(hasInfluencePR)
                        {
                            if(hasCampaign)                            // old#2b - Modified as new rule (#2c)
                            {
                                //Opp.Bucket_Source__c = 'Sales';
                                Opp.Bucket_Influence__c = 'Marketing & Partner';
                            }
                            else                                        // #1b
                            {
                                //Opp.Bucket_Source__c = 'Sales';
                                Opp.Bucket_Influence__c = 'Partner';
                            }
                        }
                    }
                }
            }   
            
            else //no Partner roles
            {
                Opp.Bucket_Influence__c = '';
                
                if(qTeamRole || hasCampaign)
                {
                    //Opp.Bucket_Source__c = 'Marketing';                    // #5b, #new rule(8a)                    
                    
                    if(hasCampaign && !mktSourced)                        //#new rule(8b)
                    {
                        //Opp.Bucket_Source__c = 'Sales';
                        Opp.Bucket_Influence__c = 'Marketing';
                    }   
                }
                else
                {
                    // if(mktSourced)
                    //Opp.Bucket_Source__c = 'Marketing';            //#9
                    // else
                    // Opp.Bucket_Source__c = 'Sales';                // #6, #10
                }                
            }
            
            if(isPtnrCall)
                updateOpps.add(Opp);                                               
            
        }// Opp for loop
        
        if(isPtnrCall && updateOpps.size()>0)
            update updateOpps;
        
    }
}