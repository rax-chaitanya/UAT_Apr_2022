/*		DeveloperName 			US							 		Project 				Test Class  - Coverage 						Description 
 * 		Shravan Godha 	https://jira.rax.io/browse/SFDC-5826		ACE CRM			AssignLeadsUsingAssignmentRules_Test - 100 %		After lead inserted into salesforce it will assign it to Lead Assignment Rules
 * 
 */

@RestResource(urlMapping='/LeadAssignmentRule/*')
Global With sharing class AssignLeadsUsingAssignmentRules{
    @HTTPPOST
    global static string LeadAssign(List<String> LeadAPNIds)
    { 
        Database.DMLOptions dmo = new Database.DMLOptions(); 
        dmo.assignmentRuleHeader.useDefaultRule= true; 
        List<Lead> Leads=[select id,APN_CRM_Unique_Identifier__c from lead where lead.APN_CRM_Unique_Identifier__c in :LeadAPNIds];
        Database.update(Leads, dmo);
        return 'Lead Updated Sucessfully';
        
    }
}