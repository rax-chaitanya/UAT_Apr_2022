/**
 * File : LeadAssignmentApexController.cls
 * Description : Apex Controller for Lead Assignment Lightning Component (SFDC-1880: Lead - Round Robin)
 * Created Date : 23/APR/2018
 * @author : RDC (JY)
 */
public class LeadAssignmentApexController {
	
	@AuraEnabled
    public static List<Queue__c> getQueues() {
		List<Queue__c> retVal = new List<Queue__c>();
		List<Queue__c> queues = new List<Queue__c>();
		queues = [SELECT Id, Name, (SELECT Id FROM Queue_Members__r WHERE isActive__c = TRUE) FROM Queue__c WHERE isActive__c = TRUE ORDER BY Name ASC];
        for(Queue__c q : queues) {
        	if(q.Queue_Members__r != null && !q.Queue_Members__r.isEmpty()) {
        		retVal.add(q);
        	}
        }
        return retVal;
    }
    
    @AuraEnabled
    public static void assignLeads(String queueId, String leadId) {
       LeadAssignmentHelper.assignLeadsQuickAction(queueId, leadId);
    }
    
    @AuraEnabled
    public static Boolean isAuthorised() {
       return System.Label.LeadAssignmentProfiles.contains(UserInfo.getProfileId());
    }
    
}