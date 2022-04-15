/*********************************************************************************

Author: D Anjaneyulu
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the Lead trigger.

**********************************************************************************/

public class LeadHandler implements TriggerInterface{
     public static Boolean IS_TRIGGER_ENABLED = true;
    
    public Boolean isActive()
    {
        if(Trigger_Manager__c.getAll().containsKey('LeadTgr') && IS_TRIGGER_ENABLED ) {
            return Trigger_Manager__c.getInstance('LeadTgr').Is_Active__c && IS_TRIGGER_ENABLED ;
        }
        return false;
    }
    
    public void beforeInsert() {
        // List<Lead> leadList = (List<Lead>)Trigger.new;
        // Map<Id, Lead> lMap = (Map<id, Lead>)Trigger.oldMap; 
        //Commented By: Vinod Thupakula
        //SFDC-2966
        //UpdateTerritory.populateTerritory(leadList, lMap, 'Lead');
      
      LeadHelper.populateVPFromGroup((List<Lead>)Trigger.new, (Map<Id, Lead>)Trigger.oldMap);
      LeadAssignmentHelper.assignLeadsToQueueMembers((List<Lead>)Trigger.new,null);//Added By Thirupathi Aeneni For SFDC-2965
        // Added by Anjaneyulu for SFDC-2154 -- Starts
        LeadHelper.updateAutoConvertLeads();
        
        //Added by Anjaneyulu for SFDC-2154-- Ends      
        // Upldating the Lead Source for Partner Network -- Starts (SFDC-1118)
        LeadHelper.updateSourceForPartnerLeads(); 
        // Upldating the Lead Source for Partner Network -- Endss (SFDC-1118)
        // Added by sundarayya E for SFDC-5307
        List<Lead> newList = new List<Lead>();
        
        for(Lead le : (List<Lead>) Trigger.new){
            if(le.Btlk_Country__c != null && le.CountryCode == null){
                newList.add(le);
            }
        }
        if(newList.size() > 0)LeadHelper.updateBtlkAddFields((List<Lead>)Trigger.new);
        
    }
    
    public void beforeUpdate() {
        LeadAssignmentHelper.assignLeadsToQueueMembers((List<Lead>)Trigger.new, (Map<Id, Lead>)Trigger.oldMap);//Added By Thirupathi Aeneni For SFDC-3020       
        LeadHelper.processBeforeUpdate();
        // Added by Anjaneyulu for SFDC-2154 -- Starts
        LeadHelper.updateAutoConvertLeads();
        //Added by Anjaneyulu for SFDC-2154-- Ends  
        //if(LeadTriggerHelperController.UPDATE_TERRITORY){         commented SFDC-1760
        // LeadTriggerHelperController.UPDATE_TERRITORY = false;    commented SFDC-1760
        LeadHelper.populateVPFromGroup((List<Lead>)Trigger.new, (Map<Id, Lead>)Trigger.oldMap);
        LeadHelper.checkAccounttypeforleadconversion();//Added By Thirupathi Aeneni for SFDC-3024
        //}                                                         commented SFDC-1760
   
		 List<Lead> newList = new List<Lead>();
        Map<Id,Lead> LeadOldMap = (Map<Id,Lead>)Trigger.OldMap;
        for(Lead le : (List<Lead>) Trigger.new){
            if((le.Btlk_Country__c != null && LeadOldMap.get(le.Id).Btlk_Country__c != le.Btlk_Country__c) || (LeadOldMap.get(le.Id).Btlk_Country__c == le.Btlk_Country__c && LeadOldMap.get(le.Id).Btlk_Sate_Province__c != le.Btlk_Sate_Province__c)){
                newList.add(le);
            }
        }
        if(newList.size() > 0)LeadHelper.updateBtlkAddFields((List<Lead>)Trigger.new);    
    }
    
    public void beforeDelete() {}
    
    public void afterInsert()  {
        // Running assignment rules SFDC-20 -- Starts
        if(RunAssignmentRules.RUN_ASSIGNMENT_RULES){
            RunAssignmentRules.RUN_ASSIGNMENT_RULES = false;
            LeadHelper.runAssignmentRules();
            
        }
        /* if(System.Label.Partner_Profiles.contains(UserInfo.getProfileId())){
CommunitySharingHelper.shareRecordsOnCreation((List<Lead>)Trigger.new, 'Lead');
LeadHelper.ConvertCommentToNote();
}*/
        
        //Added by Anjaneyulu for SFDC-2116 -- Starts
        List<Lead> partnerLeads = new List<Lead>();
        for(Lead l : (List<Lead>) Trigger.new){
            if(String.isNotBlank(l.Partner_Company__c))
                partnerLeads.add(l);
            
        }
        if(partnerLeads.size() >0){        
            CommunitySharingHelper.shareRecordsOnCreation((List<Lead>)Trigger.new, 'Lead');
            LeadHelper.ConvertCommentToNote();
        }
        //Added by Anjaneyulu for SFDC-2116 -- Ends
        
        // Running assignment rules SFDC-20 -- Ends 
        
        //Added by Divya for SFDC-2705 -- Starts  
        LeadHelper.AddLeadTocampaign(); 
        //Added by Divya for SFDC-2705 -- Ends 
         NetworkMemberHelper.addReputationPointsToPartner();//Added by Thirupathi Aeneni for SFDC - 3222
         //swetha
        // LeadAssignmentHelper.assignLeadsToQueueMembers((List<Lead>)Trigger.new,null);//Added By Thirupathi Aeneni For SFDC-2965
    }
    
    public void afterUpdate() {
        
        Map<Id,Lead> convertedIds = new Map<Id,Lead>();
        Map<Id,Lead> oldMap = (Map<Id,Lead>)Trigger.OldMap;
        List<Lead> partnerLeads = new List<Lead>();
        Set<String> setOfEmailIds = new Set<String>();
        for(sObject l1:Trigger.new)
        {
            Lead l = (Lead)l1; 
            if(l.isConverted){
                convertedIds.put(l.id,l);
                
            }// SFDC-2116
            else if((String.isNotBlank(l.Partner_Company__c) && l.OwnerId != oldMap.get(l.Id).OwnerId) || (l.Partner_Company__c != oldMap.get(l.Id).Partner_Company__c && String.isNotBlank(l.Partner_Company__c)))
                partnerLeads.add(l); 
            /********SFDC-3273 Added by RDC*****/
            if((((Map<Id,Lead>)Trigger.oldMap).get(l.Id).HasOptedOutOfEmail != l.HasOptedOutOfEmail) && (l.HasOptedOutOfEmail == true)){
                setOfEmailIds.add(l.email);
            }
            if(setOfEmailIds.size()>0 && (!System.isFuture()))
                UpdateEmailOptOut.updateEmailOptOutField(setOfEmailIds,'Lead');   
            /********SFDC-3273 Ended by RDC*****/ 
        }
        if(!convertedIds.isEmpty() && LeadHelperController.MAP_LEAD_FIELDS)
        {
            LeadHelperController.MAP_LEAD_FIELDS = false;
           LeadHelper.mapLeadFiledsforAccountAndOpportunity(convertedIds); 
            
            
        } 
        
        if(LeadHelperController.SHARE_LEADS_TO_PARTNERS){ 
            if(!partnerLeads.isEmpty())
                CommunitySharingHelper.shareRecordsOnCreation(partnerLeads,'Lead');
            LeadHelperController.SHARE_LEADS_TO_PARTNERS = false;
        }
        
        if(LeadAssignmentHelper.LeadAssignmentHelper_adjustCounters) {
            
            LeadAssignmentHelper.adjustCounters((List<Lead>)Trigger.new, (Map<Id, Lead>)Trigger.oldMap);
        }
        
        //Added by Divya for SFDC-2705 -- Starts
        LeadHelper.UpdateAddLeadTocampaign();
        //Added by Divya for SFDC-2705 -- Ends  
        
    }
    
    public void afterDelete() {
        
    }
    
    public void afterUndelete() {}
}