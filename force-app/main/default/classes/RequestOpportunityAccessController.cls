public without sharing class RequestOpportunityAccessController {
    
    @AuraEnabled
    public static List<Option> getTeamMemberRoles(String oppId){
        List<Option> options = new List<Option>();
        
        //Fetching information about already allocated roles
        Set<String> allocatedRoles = new Set<String>();
        for(OpportunityTeamMember teamMember : [SELECT Id, TeamMemberRole, OpportunityId, UserId FROM OpportunityTeamMember Where OpportunityId=: oppId]){
            allocatedRoles.add(teamMember.TeamMemberRole);
        }
        
        String requestedRole = getRequestedRole(oppId);
        if(requestedRole!= null){
            allocatedRoles.add(requestedRole);   
        }
        
        //Filtering roles
        for( Schema.PicklistEntry f : OpportunityTeamMember.TeamMemberRole.getDescribe().getPicklistValues()){
            if(!allocatedRoles.contains(f.getValue())){
                options.add(new Option(f.getLabel(), f.getValue()));
            }
        }
        return options;
    }
    
    private static String getRequestedRole(String oppId){
        //team member role which is under approval
        List<ProcessInstance> pislist = [SELECT ID, TargetObjectID, CreatedBy.Name from ProcessInstance WHERE Status = 'Pending' AND TargetObjectID = :oppId];
        if(pislist != null && pislist.size() > 0){
            Opportunity opp = [SELECT Id, Requester_Team_Role__c FROM Opportunity WHERE Id =: oppId Limit 1];
            return opp.Requester_Team_Role__c;
        }
        return null;
    }
    @AuraEnabled
    public static Map<String,Object> checkAccess(String recordId){
        Map<String,Object> result = new Map<String,Object>();
        result.put('Action', 'None');
        result.put('Message', '');
        try{ 
            Opportunity ops = [Select Id,IsClosed,Name,RecordType.Name,Opportunity_Access_Submitter__c,OwnerId from Opportunity where id =: recordId];          
            if(UserInfo.getUserId() == ops.OwnerId){
                result.put('Action', 'None');
                result.put('Message', System.label.OpportunityOwner);
                return result;
            } 
            else if(!UserInfo.getProfileId().contains(Label.System_Administrator_Profile_Id) && ops.RecordType.Name == 'Read only'){
                result.put('Action', 'None');
                result.put('Message', System.Label.ReadOnlyOppError);
                return result;
            }
            String role ='';
            if(UserInfo.getUserRoleId()!= null){    
                role = [Select Id,Name from UserRole where id =: UserInfo.getUserRoleId()].Name;
            }
            List<OpportunityTeamMember> teams = new List<OpportunityTeamMember>();
            teams=[Select OpportunityId,TeamMemberRole,UserID,OpportunityAccessLevel From OpportunityTeamMember Where UserID=:UserInfo.getUserId() AND OpportunityId=: recordId];
            if(teams.size() >0 ){
                result.put('Action', 'None');
                result.put('Message', System.label.OppTeamMember);
                return result;
            }
            if(String.isNotBlank(role)){
                String trole='';
                boolean isRequiredToSelectRole = false;
                for(Opp_Team_Member_Roles_Setup__c opts:Opp_Team_Member_Roles_Setup__c.getall().values()){
                    if(role == opts.Role__c){
                        if(!opts.Select_Role__c)
                            trole=opts.Team_Member_Role__c;
                        else
                            isRequiredToSelectRole = true;
                    }
                    
                }
                
                if(trole != ''){
                    //Verify if role has been already requested
                    String requestedRole = getRequestedRole(recordId);
                    if(requestedRole!= null && trole == requestedRole){
                        result.put('Action', 'Error');
                        result.put('Message', System.label.DuplicateRole);
                        return result;
                    }
                    insert new OpportunityTeamMember(
                        Skip_Validation__c = true,
                        OpportunityId = ops.Id,
                        OpportunityAccessLevel = ops.RecordType.Name =='Read only' ? 'Read' : 'Edit',
                        UserId = UserInfo.getUserId(),TeamMemberRole = trole
                    );
                    
                    result.put('Action', 'None');
                    result.put('Message', System.label.TeamMemberAccess+' '+trole);
                    return result; 
                }
                
                if(isRequiredToSelectRole){
                    result.put('Action', 'Select Role');
                    
                    return result;
                }
            }
            List<ProcessInstance> pislist = [SELECT ID, TargetObjectID, CreatedBy.Name from ProcessInstance WHERE Status = 'Pending' AND TargetObjectID = :recordId];
            if(pislist != null && pislist.size() > 0){
                result.put('Action', 'None');
                result.put('Message', pislist[0].CreatedBy.Name+' '+System.label.TeamMemberApproval);
                return result;
            }
            
            result.put('Action', 'Select Role');
           
            return result;
        }catch(Exception e){
            result.put('Action', 'Error');
            if(e.getMessage().contains('Team member already exists')){
                result.put('Message', System.label.DuplicateRole);
                return result;
            }
            result.put('Message', System.label.TeamMemberRequestError);
            return result;
        }   
    }
    
    @AuraEnabled
    public static Map<String,Object> submitForApproval(String recordId,String teamRole){
        Map<String,Object> result = new Map<String,Object>();
        result.put('Action', 'None');
        result.put('Message', '');
        try{
            Opportunity op = [Select Id,IsClosed,Skip_validation__c,Name,RecordType.Name,Opportunity_Access_Submitter__c from Opportunity where id =: recordId ];
            String role ='';
            if(UserInfo.getUserRoleId()!= null){
                role = [Select Id,Name from UserRole where id =: UserInfo.getUserRoleId()].Name;
            }
            if(String.isNotBlank(role)){
                String trole='';
                for(Opp_Team_Member_Roles_Setup__c opts:Opp_Team_Member_Roles_Setup__c.getall().values()){
                    if(role == opts.Role__c && opts.Select_Role__c){
                        trole = teamRole; 
                        break;
                    }
                } if(trole != ''){  
                    insert new OpportunityTeamMember(
                        Skip_Validation__c = true,
                        OpportunityId = op.Id,
                        OpportunityAccessLevel = op.RecordType.Name =='Read only' ? 'Read' : 'Edit',
                        UserId = UserInfo.getUserId(),TeamMemberRole = trole
                    );
                    result.put('Action', 'None');
                    result.put('Message', System.label.TeamMemberAccess+' '+trole);
                    return result;        
                    
                }
            }
            
            op.Opportunity_Access_Submitter__c = UserInfo.getUserId();
            op.Skip_validation__c= op.Skip_validation__c ? false : true;
            op.Requester_Team_Role__c = teamRole;
            
            update op;
            result.put('Action', 'None');
            result.put('Message', System.label.SubmitforApproval+' '+op.Name);
            
            return result;
            
        }
        catch(exception e){
            result.put('Action', 'Error');
            result.put('Message', System.label.TeamMemberRequestError);
            return result;
            
        }
    }
    
    
    
    public class Option{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        
        public Option(String label,String value){
            this.label = label;
            this.value = value;
        }
    }
    
    public static void createOpportunityTeamMember(){
        Id readOnlyRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Read Only').getRecordTypeId();
        List<OpportunityTeamMember> members = new List<OpportunityTeamMember>();
        for(Integer i=0;i<Trigger.size;i++){
            if(((Opportunity)Trigger.new[i]).Access_Request_Status__c != ((Opportunity)Trigger.old[i]).Access_Request_Status__c && ((Opportunity)Trigger.new[i]).Access_Request_Status__c == 'Approved'){
                members.add(new OpportunityTeamMember(
                    Skip_Validation__c=true,
                    OpportunityId=((Opportunity)Trigger.new[i]).Id,
                    OpportunityAccessLevel=((Opportunity)Trigger.new[i]).RecordTypeId == readOnlyRecordTypeId ? 'Read':'Edit',
                    UserId=((Opportunity)Trigger.new[i]).Opportunity_Access_Submitter__c,
                    TeamMemberRole=((Opportunity)Trigger.new[i]).Requester_Team_Role__c));
            }
        }
        
        if(members.size() > 0){
            insert members;
        }
    }
}