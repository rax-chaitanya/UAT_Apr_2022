/*
###########################################################################
# File..................: OpportunityTeamMemberHelper.cls
# Version...............: 1.0
# Created by............: Jayant Yadav (RDC)
# Created Date..........: 24-Apr-2017
# Description...........: This is an Apex class to hold business logic for Opportunity Team Member triggers.
# Change History........: 24/APR/2017 JY Created original version for user story - SFDC-93
*/
public with sharing class OpportunityTeamMemberHelper {
    //method to be called on insert and update of OTM records.
    //will prevent duplicates (multiple members per role) from entering the database based on certain rules. 
    //Rule 1 : System Administrators can add duplicates.
    //Rule 2 : Solution Architects with specified roles can add themselves with the role of Solution Architect Specialist.
    //Assumption : There are no existing dupes in the System. 
    //@params : trigger.new and trigger.oldMap context variables
    //@returns : void
    public static void preventDupes(List<OpportunityTeamMember> triggerNew, Map<Id, OpportunityTeamMember> triggerOldMap) {
        if(!System.Label.Administrative_Profiles.contains(UserInfo.getProfileId())) {
            Map<Id, Set<String>> oppIdVsRolesCurrent = new Map<Id, Set<String>>();
            Map<Id, Set<String>> oppIdVsRolesExisting = new Map<Id, Set<String>>();
            Map<Id, list<String>> oppIdVsAccExeRole = new Map<Id, list<String>>();
            Map<Id, list<String>> oppIdVsAccExecurrRole = new Map<Id, list<String>>();
            Map<Id, list<String>> oppIdVsAWSSPRRole = new Map<Id, list<String>>();
            Map<Id, list<String>> oppIdVsAWSSPRCurrRole = new Map<Id, list<String>>();
            Integer AccExecCount=0;
            Integer AWSStrategicPursuitDirectorCount=0;
            Set<Id> opportunities = new Set<Id>();
            String AccExeRole = System.Label.Account_Executive_Role;
            String AWSStrategicPursuitDirector = System.Label.AWS_Strategic_Pursuit_Director_Role;
            system.debug('AccExeRole @@'+AccExeRole);
            //Boolean IsAccExecRole;
            for(OpportunityTeamMember otm : triggerNew) {
                
                if(oppIdVsRolesCurrent.containsKey(otm.OpportunityId)) {
                    // Added by Anjaneyulu to share the opportunity to Partners
                    if(oppIdVsRolesCurrent.get(otm.OpportunityId).contains(otm.TeamMemberRole) ) {
                        //SFDC-5518 updated with '&& otm.TeamMemberRole != AccExeRole' for skipping duplicate validtion when role is Account executive
                        if(otm.TeamMemberRole != System.Label.Solution_Architect_Member_Role && !System.Label.Skip_Team_Roles.contains(otm.TeamMemberRole)
                           && otm.TeamMemberRole != AccExeRole && otm.TeamMemberRole != AWSStrategicPursuitDirector) {
                               otm.addError(System.Label.OptyMemberErrorMessage);
                               system.debug('Line 41'+System.Label.OptyMemberErrorMessage);
                           }
                        //SFDC-5518 updated with '&& otm.TeamMemberRole != AccExeRole' for skipping duplicate validtion when role is Account executive
                        else if(!System.Label.Solution_Architect_Roles.contains(UserInfo.getUserRoleId()) && !System.Label.Skip_Team_Roles.contains(otm.TeamMemberRole)
                                && otm.TeamMemberRole != AccExeRole && otm.TeamMemberRole != AWSStrategicPursuitDirector) {
                                    otm.addError(System.Label.OptyMemberErrorMessage);
                                    system.debug('Line 47'+System.Label.OptyMemberErrorMessage);
                                }
                    }
                    else {
                        oppIdVsRolesCurrent.get(otm.OpportunityId).add(otm.TeamMemberRole); 
                    }               
                }
                else {
                    oppIdVsRolesCurrent.put(otm.OpportunityId, new Set<String> {otm.TeamMemberRole});
                    
                }
                
                if(Trigger.isInsert || Trigger.isUpdate && (otm.TeamMemberRole != triggerOldMap.get(otm.Id).TeamMemberRole)) {
                    opportunities.add(otm.OpportunityId);
                    //SFDC-5518 added to check if more than two Account Executive roles being added when multiple Team members added once
                    
                    if(otm.TeamMemberRole==AccExeRole && oppIdVsAccExecurrRole.containsKey(otm.OpportunityId)){
                        oppIdVsAccExecurrRole.get(otm.OpportunityId).add(otm.TeamMemberRole); 
                        
                    }else if(otm.TeamMemberRole==AccExeRole){
                        oppIdVsAccExecurrRole.put(otm.OpportunityId, new List<String> {otm.TeamMemberRole});
                    }
                    else if(otm.TeamMemberRole != AccExeRole && !oppIdVsAccExecurrRole.containsKey(otm.OpportunityId))
                    {
                        oppIdVsAccExecurrRole.put(otm.OpportunityId, new List<String>());
                    }
                    
                    //SFDC-5592 added to check if more than two AWSStrategicPursuitDirector roles being added when multiple Team members added once
                    
                    if(otm.TeamMemberRole==AWSStrategicPursuitDirector && oppIdVsAWSSPRCurrRole.containsKey(otm.OpportunityId)){
                        oppIdVsAWSSPRCurrRole.get(otm.OpportunityId).add(otm.TeamMemberRole); 
                        
                    }else if(otm.TeamMemberRole==AWSStrategicPursuitDirector){
                        oppIdVsAWSSPRCurrRole.put(otm.OpportunityId, new List<String> {otm.TeamMemberRole});
                    }
                    else if(otm.TeamMemberRole != AWSStrategicPursuitDirector && !oppIdVsAWSSPRCurrRole.containsKey(otm.OpportunityId))
                    {
                        oppIdVsAWSSPRCurrRole.put(otm.OpportunityId, new List<String>());
                    }
                    
                    
                    
                }
            }
            
            if(!Opportunities.isEmpty()) {
                for(OpportunityTeamMember otm : [SELECT Id, OpportunityId,userId, TeamMemberRole FROM OpportunityTeamMember
                                                 WHERE OpportunityId IN :opportunities ORDER BY OpportunityId]) {
                                                     if(oppIdVsRolesExisting.containsKey(otm.OpportunityId) && otm.TeamMemberRole != AccExeRole) {
                                                         oppIdVsRolesExisting.get(otm.OpportunityId).add(otm.TeamMemberRole);
                                                         
                                                     }
                                                     else if(otm.TeamMemberRole != AccExeRole){
                                                         oppIdVsRolesExisting.put(otm.OpportunityId, new Set<String> {otm.TeamMemberRole});
                                                         
                                                     }
                                                     if(oppIdVsAccExeRole.containsKey(otm.OpportunityId) && otm.TeamMemberRole == AccExeRole){
                                                         oppIdVsAccExeRole.get(otm.OpportunityId).add(otm.TeamMemberRole);
                                                     }else if(otm.TeamMemberRole == AccExeRole){
                                                         oppIdVsAccExeRole.put(otm.OpportunityId, new List<String> {otm.TeamMemberRole});
                                                     }
                                                     else if(otm.TeamMemberRole != AccExeRole && !oppIdVsAccExeRole.containsKey(otm.OpportunityId))
                                                     {
                                                         oppIdVsAccExeRole.put(otm.OpportunityId, new List<String>());
                                                     }
                                                     
                    //SFDC-5592 added to check if more than two AWSStrategicPursuitDirector roles being added when multiple Team members added once
                                                      else if(oppIdVsRolesExisting.containsKey(otm.OpportunityId) && otm.TeamMemberRole != AWSStrategicPursuitDirector) {
                                                         oppIdVsRolesExisting.get(otm.OpportunityId).add(otm.TeamMemberRole);
                                                         
                                                     }
                                                     else if(otm.TeamMemberRole != AWSStrategicPursuitDirector){
                                                         oppIdVsRolesExisting.put(otm.OpportunityId, new Set<String> {otm.TeamMemberRole});
                                                         
                                                     }
                                                     if(oppIdVsAWSSPRRole.containsKey(otm.OpportunityId) && otm.TeamMemberRole == AWSStrategicPursuitDirector){
                                                         oppIdVsAWSSPRRole.get(otm.OpportunityId).add(otm.TeamMemberRole);
                                                     }else if(otm.TeamMemberRole == AWSStrategicPursuitDirector){
                                                         oppIdVsAWSSPRRole.put(otm.OpportunityId, new List<String> {otm.TeamMemberRole});
                                                     }
                                                     else if(otm.TeamMemberRole != AWSStrategicPursuitDirector && !oppIdVsAWSSPRRole.containsKey(otm.OpportunityId))
                                                     {
                                                         oppIdVsAWSSPRRole.put(otm.OpportunityId, new List<String>());
                                                     }
                                                 }
                //system.debug('oppIdVsAccExeRole @@'+oppIdVsAccExeRole.values());
                //system.debug('oppIdVsRolesExisting @@'+oppIdVsRolesExisting);
                //system.debug('oppIdVsAccExeRole @@'+oppIdVsAccExeRole);
            }
            
            
            for(OpportunityTeamMember otm : triggerNew) {
                /* if (!Opportunities.isEmpty()){
system.debug('oppIdVsAccExeRole size@@'+oppIdVsAccExeRole.get(otm.OpportunityId).size());
system.debug('oppIdVsAccExeRole size@@'+oppIdVsAccExeRole.values().size());
system.debug('key size'+oppIdVsAccExecurrRole.values().size() +'value size'+oppIdVsAccExecurrRole.get(otm.OpportunityId).size());
} */
                if (!Opportunities.isEmpty()){
                    AccExecCount= oppIdVsAccExeRole.get(otm.OpportunityId).size()>0 ? oppIdVsAccExeRole.get(otm.OpportunityId).size()+oppIdVsAccExecurrRole.get(otm.OpportunityId).size() :oppIdVsAccExecurrRole.get(otm.OpportunityId).size();
                    AWSStrategicPursuitDirectorCount= oppIdVsAWSSPRRole.get(otm.OpportunityId).size()>0 ? oppIdVsAWSSPRRole.get(otm.OpportunityId).size()+oppIdVsAWSSPRCurrRole.get(otm.OpportunityId).size() :oppIdVsAWSSPRCurrRole.get(otm.OpportunityId).size();
					}
                system.debug('size'+AccExecCount);
                //system.debug('after size'+AccExecCount);
                if(oppIdVsAccExeRole.containsKey(otm.OpportunityId) && otm.TeamMemberRole == AccExeRole && AccExecCount>2){
                    otm.addError(System.Label.OptyAccExecErrorMessage);
                    system.debug('Line 153'+System.Label.OptyAccExecErrorMessage);
                    
                }
                    //SFDC-5592 added to check if more than two AWSStrategicPursuitDirector roles being added when multiple Team members added once
                  if(oppIdVsAWSSPRRole.containsKey(otm.OpportunityId) && otm.TeamMemberRole == AWSStrategicPursuitDirector && AWSStrategicPursuitDirectorCount>2){
                    otm.addError(System.Label.OptyAccExecErrorMessage);
                                      system.debug('Line 159'+System.Label.OptyAccExecErrorMessage);
    
                    
                }
                if(oppIdVsRolesExisting.containsKey(otm.OpportunityId) && otm.TeamMemberRole != AccExeRole && otm.TeamMemberRole != AWSStrategicPursuitDirector
                   && oppIdVsRolesExisting.get(otm.OpportunityId).contains(otm.TeamMemberRole)) {
                       
                       // Added by Anjaneyulu to share the opportunity to Partners
                       if(otm.TeamMemberRole != System.Label.Solution_Architect_Member_Role && !System.Label.Skip_Team_Roles.contains(otm.TeamMemberRole)) {
                           otm.addError(System.Label.OptyMemberErrorMessage);
                       }
                       else if(!System.Label.Solution_Architect_Roles.contains(UserInfo.getUserRoleId()) && !System.Label.Skip_Team_Roles.contains(otm.TeamMemberRole)) {
                           otm.addError(System.Label.OptyMemberErrorMessage);
                       }
                   }
            }
        }
    }
}