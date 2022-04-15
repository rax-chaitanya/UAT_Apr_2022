/**********************************************************************************

Author: Shantan Nagulapalli
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the trigger.

*********************************************************************************
////////////////////////////////////////changelog//////////////////////////////////////////////////////////
// @developer   :   Diego Castro
// @date        :   10/27/2017
// @story       :   SFDC-125
// @description :   add static boolean flag to bypass custom validations for certain transactions
//////////////////////////////////////////////////////////////////////////////////////////////////
*/

public class OpportunityTeamMemberHandler implements TriggerInterface
{
    public static boolean firstTgrRun = true;
    public static string stopRecursion = 'Before Update';
    public Boolean isActive()
    {
        return Trigger_Manager__c.getInstance('OpportunityTeamMemberTgr').Is_Active__c;
    }
    
    public void beforeInsert() 
    {
        
        OpportunityTeamMemberHelper.preventDupes((List<OpportunityTeamMember>)trigger.new, null);
   
        
    }
    
    public void beforeUpdate() {
        if(stopRecursion == 'Before Update'){
            stopRecursion = 'After Update'; 
        OpportunityTeamMemberHelper.preventDupes((List<OpportunityTeamMember>)trigger.new, (Map<Id, OpportunityTeamMember>)trigger.OldMap);
    }
    }
    
    public void beforeDelete() {
        
    }
    
    // Added By Shravan - SFDC-5072 Start
    public void afterInsert(){}
        
/*
{
List<OpportunityTeamMember> OppTeamMemList = (List<OpportunityTeamMember>)trigger.new;
List<OpportunityTeamMember> memberList = new List<OpportunityTeamMember>();
List<Opportunity> oppToUpdateList = new List<Opportunity>();

for(OpportunityTeamMember member : OppTeamMemList) {

if(member.TeamMemberRole == 'CSA') 
{
memberList.add(member);
}
}
for(OpportunityTeamMember member : memberList) {

Opportunity oppToUpdate = new Opportunity(Id = member.OpportunityId);
oppToUpdate.Technical_Owner__c =  member.UserId;
oppToUpdateList.add(oppToUpdate);
}
update oppToUpdateList;
}
*/
    
    public void afterUpdate(){} 
    
/*
{

if(stopRecursion == 'After Update'){
stopRecursion = 'Stop Recursion';
List<OpportunityTeamMember> OppTeamMemList = (List<OpportunityTeamMember>)trigger.new;
List<OpportunityTeamMember> memberList = new List<OpportunityTeamMember>();
List<Opportunity> oppToUpdateList = new List<Opportunity>();

for(OpportunityTeamMember member : OppTeamMemList) {

if(member.TeamMemberRole == 'CSA') 
{
memberList.add(member);
}
}
for(OpportunityTeamMember member : memberList) {

Opportunity oppToUpdate = new Opportunity(Id = member.OpportunityId);
oppToUpdate.Technical_Owner__c =  member.UserId;
oppToUpdateList.add(oppToUpdate);
}
update oppToUpdateList;
}
}
*/
    // Added By Shravan - SFDC-5072 End
    public void afterDelete() {
        List<OpportunityTeamMember> OppTeamMemList = (List<OpportunityTeamMember>)trigger.old;
        DeleteUndeleteTriggerHandler.DeleteUndelete(OppTeamMemList, 'OpportunityTeamMember');
      	// Added By Shravan - SFDC-5072 start
        //List<OpportunityTeamMember> OppTeamMemList = (List<OpportunityTeamMember>)trigger.new;
        /*List<OpportunityTeamMember> memberList = new List<OpportunityTeamMember>();
        List<Opportunity> oppToUpdateList = new List<Opportunity>();
        
        for(OpportunityTeamMember member : OppTeamMemList) {
            
            if(member.TeamMemberRole == 'CSA') 
            {
                memberList.add(member);
            }
        }
        for(OpportunityTeamMember member : memberList) {
            
            Opportunity oppToUpdate = new Opportunity(Id = member.OpportunityId);
            oppToUpdate.Technical_Owner__c =  null;
            oppToUpdateList.add(oppToUpdate);
        }
        update oppToUpdateList;
*/
        // Added By Shravan - SFDC-5072 end         
        
    }
    
    public void afterUndelete() {}    
}