/**********************************************************************************

Author: Pradeep Guttha
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the trigger.

**********************************************************************************/

public class PartnerRoleHandler implements TriggerInterface
{
    public static boolean firstTgrRun = true;
    public static boolean processApprovals = true;      
    public static string stopRecursion = 'Before Update';
    public static List<String> DcrCCtypes = System.Label.DCR_CC_Types.Split(',');// ADDED for SFDC-6007
    
    public Boolean isActive()
    {
        if(Trigger_Manager__c.getAll().containsKey('PartnerRoleTgr')) {
            return Trigger_Manager__c.getInstance('PartnerRoleTgr').Is_Active__c;
        }
        return false;
    }
    
    public void beforeInsert() {
        //added by sundarayya-e SFDC-4612 
        //Updates Opp Bucket source when partner role created on opp with source
        
        /*if((Sf2SfIntegrationHelper.isPartnerShared() || Test.isRunningTest()) && ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS) {
Sf2SfIntegrationHelper.populateLookupFields(Trigger.new,Trigger.new[0].getsObjectType().getDescribe().getName());
ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = false; 
} */
        /*
PartnerRoleTriggerHelper.setRoleStatus((List<Partner_Role__c>)trigger.new, (Map<Id, Partner_Role__c>)trigger.oldMap);
PartnerRoleTriggerHelper.ValidateInsertRoles(PartnerRoleTriggerHelper.mapApprovedRoles, (List<Partner_Role__c>)trigger.New);
*/
        Map<Id,Partner_Role__c> approvedPartnerRoles = new Map<Id,Partner_Role__c>();
        for(Partner_Role__c pr: (List<Partner_Role__c>)trigger.new){
            if(pr.Status__c =='Approved'){
                approvedPartnerRoles.put(pr.Id,pr);
            }
        }  
        if(approvedPartnerRoles != null && approvedPartnerRoles.size()>0)
            PartnerRoleTriggerHelper1.validateApprovals(approvedPartnerRoles);
    }
    
    public void beforeUpdate() {
        if(!CompanyHandler.isLeadConverting || (CompanyHandler.isLeadConverting && stopRecursion == 'Before Update')){
            stopRecursion = 'After Update';
            /* if((Sf2SfIntegrationHelper.isPartnerShared() || Test.isRunningTest()) && ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS) {
Sf2SfIntegrationHelper.populateLookupFields(Trigger.new,Trigger.new[0].getsObjectType().getDescribe().getName());
ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = false;
} */
            
            /*  PartnerRoleTriggerHelper.setRoleStatus((List<Partner_Role__c>)trigger.new, (Map<Id, Partner_Role__c>)trigger.oldMap);
PartnerRoleTriggerHelper.ValidateUpdateRoles(PartnerRoleTriggerHelper.mapApprovedRoles, (List<Partner_Role__c>)trigger.new, (Map<Id, Partner_Role__c>)trigger.oldMap);
*/
            Map<Id,Partner_Role__c> approvedPartnerRoles = new Map<Id,Partner_Role__c>();
            for(Partner_Role__c pr: (List<Partner_Role__c>)trigger.new){
                //updated this to check for only one  source role while updating partner role SFDC-4054
                //if(pr.Status__c =='Approved' && ((Map<Id,Partner_Role__c>)trigger.oldMap).get(pr.Id).Status__c != 'Approved'){
                if(pr.Status__c =='Approved'){
                    approvedPartnerRoles.put(pr.Id,pr);
                }
            }  
            if(approvedPartnerRoles != null && approvedPartnerRoles.size()>0)
                PartnerRoleTriggerHelper1.validateApprovals(approvedPartnerRoles);
            
        }      
    }
    
    public void beforeDelete() {}
    
    public void afterInsert()  {
        //Added By Thirupathi Aeneni to share Approved Partner Role-Leads/Opps-starts
        Map<ID,List<ID>> PCompanyIdVsLeads=new Map<Id,List<ID>>();
        Map<ID,List<Id>> PCompanyIdVsOppIds=new Map<ID,List<ID>>();
        Map<Id,Partner_Role__c> approvedPartnerRoles = new Map<Id,Partner_Role__c>();
        for(Partner_Role__c pRole: (List<Partner_Role__c>)trigger.new){
            if((pRole.Status__c=='Approved' && !pRole.Is_created_from_Lead__c) && (String.isNotBlank(pRole.Lead__c)||String.isNotBlank(pRole.Opportunity__c)) && String.isNotBlank(pRole.Partner_Company__c))
            {
                approvedPartnerRoles.put(pRole.Id,pRole);
                if(String.isNotBlank(pRole.Lead__c)){
                    if(!PCompanyIdVsLeads.containsKey(pRole.Partner_Company__c))
                        PCompanyIdVsLeads.put(pRole.Partner_Company__c,new List<Id>());
                    List<Id> ids = PCompanyIdVsLeads.get(pRole.Partner_Company__c);
                    ids.add(pRole.Lead__c);
                    PCompanyIdVsLeads.put(pRole.Partner_Company__c,ids);
                }
                
                if(String.isNotBlank(pRole.Opportunity__c)){
                    if(!PCompanyIdVsOppIds.containsKey(pRole.Partner_Company__c))
                        PCompanyIdVsOppIds.put(pRole.Partner_Company__c,new List<Id>());
                    List<Id> ids = PCompanyIdVsOppIds.get(pRole.Partner_Company__c);
                    ids.add(pRole.Opportunity__c);
                    PCompanyIdVsOppIds.put(pRole.Partner_Company__c,ids); 
                }
                // PCompanyIdVsOppIds.put(pRole.Partner_Company__c,pRole.Opportunity__c);
                
            } 
        }
        if(PCompanyIdVsLeads.size()>0) 
            PartnerRoleTriggerHelper1.ShareApprovedPRoleLeadsOrOpps(PCompanyIdVsLeads,'Lead');
        
        
        if( PCompanyIdVsOppIds.size()>0)
            PartnerRoleTriggerHelper1.ShareApprovedPRoleLeadsOrOpps(PCompanyIdVsOppIds,'Opportunity');
        //Added By Thirupathi Aeneni to share Approved Partner Role-Leads/Opps-Ends
        
        // PartnerRoleBucketHandler.updateBucketFieldsonOpp((List<Partner_Role__c>)Trigger.new, True);       
        
        if(approvedPartnerRoles != null && approvedPartnerRoles.size()>0)
            PartnerRoleTriggerHelper1.updateAfterApprovals(approvedPartnerRoles);
        //Added by sundarayya e for 5100 to update bucket source field on opp    
        List<Partner_Role__c> SPartnerRoles = new List<Partner_Role__c>();
        List<Id> oppIds = New List<Id>();
        for(Partner_Role__c ptr : (List<Partner_Role__c>)trigger.new){
            if(ptr.Role__c == 'Source' && String.isNotBlank(ptr.Opportunity__c)){
                SPartnerRoles.add(ptr);
                oppIds.add(ptr.Opportunity__c);
            }
        }
        if(SPartnerRoles.size() > 0){
            PartnerRoleBucketHandler.updateOppSource(SPartnerRoles,oppIds);
        }
        
        //Start of SFDC-5631
        List<Partner_Role__c> ProleToTeammem = new List<Partner_Role__c>();
        //SFDC-6007 Updated the Query to exclude Cloud contract types of DCR
        for(Partner_role__c ptr1: [select id,Opportunity__c,Partner_Company__c,Opportunity__r.isclosed,Partner_Company__r.ownerid,role__c,Opportunity__r.Cloud_Contract_Type__c,
                                   //start sfdc-6315
                                   Opportunity__r.Category__c,Opportunity__r.Type,Opportunity__r.Owner_Role__c 
                                   //end sfdc -6315
                                   from Partner_role__c where Id IN: trigger.new AND (Opportunity__r.Cloud_Contract_Type__c NOT IN: DcrCCtypes)]){
                                       //5631 to insert opp team mem
                                       if(String.isNotBlank(ptr1.Opportunity__c) && String.isNotBlank(ptr1.Partner_Company__c))
                                       {
                                           ProleToTeammem.add(ptr1);
                                       }
                                       
                                   }
        
        if(ProleToTeammem.size()>0){
            PartnerRoleTriggerHelper1.updateOppTeamMember(ProleToTeammem);
            
        }
        //end of 5631
    }
    
    public void afterUpdate() {
        if(!CompanyHandler.isLeadConverting || (CompanyHandler.isLeadConverting && stopRecursion == 'After Update')){ 
            stopRecursion = 'Stop Recursion';
            //Helper class method for send roles to approval process
            // PartnerRoleTriggerHelper.ApprovalMethod(PartnerRoleTriggerHelper.mapRoles, (List<Partner_Role__c>)trigger.new);
            //Helper class method for update lead/opportunity fileds
            //PartnerRoleTriggerHelper.AssignmentMethod(PartnerRoleTriggerHelper.mapRoles, (List<Partner_Role__c>)trigger.new, (Map<Id, Partner_Role__c>)trigger.oldMap);
            
            // PartnerRoleBucketHandler.updateBucketFieldsonOpp((List<Partner_Role__c>)Trigger.new, True); 
            // PartnerRoleTriggerHelper.AutoApproval((List<Partner_Role__c>)trigger.new);     
            Map<Id,Partner_Role__c> approvedPartnerRoles = new Map<Id,Partner_Role__c>();   
            
            
            //Added By Thirupathi Aeneni to share Approved Partner Role-Leads/Opps-starts
            Map<ID,List<ID>> PCompanyIdVsLeads=new Map<Id,List<ID>>();
            Map<ID,List<Id>> PCompanyIdVsOppIds=new Map<ID,List<ID>>();
            List<Partner_Role__c> newList = (List<Partner_Role__c>)trigger.new;
            List<Partner_Role__c> oldList = (List<Partner_Role__c>)trigger.old;
            for(Integer i=0;i<Trigger.size;i++){
                
                // Added by Anajneyulu for SFDC-2116
                //Skipped checking below If condition on Approval status to update Opp rec from Partner company in partner role for SFDC-4054
                
                if((newList[i].Opportunity__c != oldList[i].Opportunity__c) || (newList[i].Lead__c != oldList[i].Lead__c) || (newList[i].Status__c == 'Approved'))
                    
                    /*for(Partner_Role__c pRole: (List<Partner_Role__c>)trigger.new){

if((pRole.Status__c=='Approved' && pRole.Status__c!=((Map<Id, Partner_Role__c>)Trigger.oldMap).get(pRole.Id).Status__c) && (String.isNotBlank(pRole.Lead__c)||String.isNotBlank(pRole.Opportunity__c)) && String.isNotBlank(pRole.Partner_Company__c))*/
                {
                    approvedPartnerRoles.put(newList[i].Id,newList[i]);
                    if(String.isNotBlank(newList[i].Lead__c)){
                        if(!PCompanyIdVsLeads.containsKey(newList[i].Partner_Company__c))
                            PCompanyIdVsLeads.put(newList[i].Partner_Company__c,new List<Id>());
                        List<Id> ids = PCompanyIdVsLeads.get(newList[i].Partner_Company__c);
                        ids.add(newList[i].Lead__c);
                        PCompanyIdVsLeads.put(newList[i].Partner_Company__c,ids);
                    }
                    
                    if(String.isNotBlank(newList[i].Opportunity__c)){
                        if(!PCompanyIdVsOppIds.containsKey(newList[i].Partner_Company__c))
                            PCompanyIdVsOppIds.put(newList[i].Partner_Company__c,new List<Id>());
                        List<Id> ids = PCompanyIdVsOppIds.get(newList[i].Partner_Company__c);
                        ids.add(newList[i].Opportunity__c);
                        PCompanyIdVsOppIds.put(newList[i].Partner_Company__c,ids); 
                    }
                    // PCompanyIdVsOppIds.put(pRole.Partner_Company__c,pRole.Opportunity__c);
                    
                } 
            }
            if(PCompanyIdVsLeads.size()>0) 
                PartnerRoleTriggerHelper1.ShareApprovedPRoleLeadsOrOpps(PCompanyIdVsLeads,'Lead');
            
            
            if( PCompanyIdVsOppIds.size()>0)
                PartnerRoleTriggerHelper1.ShareApprovedPRoleLeadsOrOpps(PCompanyIdVsOppIds,'Opportunity');
            //Added By Thirupathi Aeneni to share Approved Partner Role-Leads/Opps-Ends
            if(approvedPartnerRoles != null && approvedPartnerRoles.size()>0)
                PartnerRoleTriggerHelper1.updateAfterApprovals(approvedPartnerRoles);
            
        }   
        //Added by sundarayya e for 5100 to update bucket source field on opp    
        List<Partner_Role__c> SPartnerRoles = new List<Partner_Role__c>();
        List<Id> oppIds = New List<Id>();
        for(Partner_Role__c ptr : (List<Partner_Role__c>)trigger.new){
            if(ptr.Role__c == 'Source' && String.isNotBlank(ptr.Opportunity__c)){
                SPartnerRoles.add(ptr);
                oppIds.add(ptr.Opportunity__c);
            }
        }
        if(SPartnerRoles.size() > 0){
            PartnerRoleBucketHandler.updateOppSource(SPartnerRoles,oppIds);
        }
        //Start of SFDC-5631
        List<Partner_Role__c> roletoteam = new List<Partner_Role__c>();
        //Map<Id, Partner_Role__c>   prMapOld = (Map<Id, Partner_Role__c>)Trigger.oldMap;
        //SFDC-6007 Updated the Query to exclude Cloud contract types of DCR
        for(Partner_role__c ptr1: [select id,Opportunity__c,Partner_Company__c,Opportunity__r.isclosed,Partner_Company__r.ownerid,
                                   //start sfdc-6315
                                   Opportunity__r.Owner_Role__c,Opportunity__r.Category__c,Opportunity__r.Type,
                                   //end sfdc-6315
          						  role__c,Opportunity__r.Cloud_Contract_Type__c from Partner_role__c where Id IN: trigger.new  AND (Opportunity__r.Cloud_Contract_Type__c NOT IN: DcrCCtypes)]){
                                       
                                       if(String.isNotBlank(ptr1.Opportunity__c) && String.isNotBlank(ptr1.Partner_Company__c) )
                                       {
                                           roletoteam.add(ptr1);
                                       }
                                   }
        if(roletoteam.size() > 0){
            
            PartnerRoleTriggerHelper1.updateOppTeamMember(roletoteam);
            
            PartnerRoleTriggerHelper1.deleteOldOwnerOppTeamMembers(roletoteam,(Map<Id, Partner_Role__c>) Trigger.oldMap);
        }
        //End of SFDC-5631
    }
    
    public void afterDelete() {
        List<Partner_Role__c> PartnerRoleList = (List<Partner_Role__c>)Trigger.old;
        //SFDC-3963 starts
        list<opportunity> opps = new list<opportunity>();
        list<Lead> lds = new list<Lead>();
        for(Partner_Role__c prold:PartnerRoleList)
        { 
            if(prold.Role__c == 'Source'){
                if(prold.Opportunity__c != null){
                    Opportunity op = new Opportunity();                  
                    op.id=prold.Opportunity__c;                  
                    op.Partner_Company__c = null;
                    op.Partner_Contract_Type__c = null; //Added for SFDC-4054
                    op.Commission_Role__c = null; // ADDED for SFDC-4518
                    opps.add(op);                    
                }else if(prold.Lead__c != null){
                    Lead ld = new Lead();
                    ld.id=prold.Lead__c;
                    ld.Partner_Company__c = null;  
                    lds.add(ld);                    
                }                                        
            }
            
        }  
        if(opps.size()>0)
        {
            update opps;
        }else if(lds.size()>0)
        {
            update lds;
        }
        //SFDC-3963 ends
        DeleteUndeleteTriggerHandler.DeleteUndelete(PartnerRoleList, 'Partner_Role__c');
        //SFDC-5631
        PartnerRoleTriggerHelper1.deleteOppTeamMembers((List<Partner_Role__c>)Trigger.old);
    }
    
    public void afterUndelete() {}
    
}