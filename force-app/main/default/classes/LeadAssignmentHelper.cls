/**
* File : LeadAssignmentHelper.cls
* Description : Methods used by Lead Assignment Lightning Component (SFDC-1880: Lead - Round Robin)
* Created Date : 23/APR/2018
* @author : RDC (JY)
* Last Modified By : Thirupathi Aeneni For SFDC-2965(15/FEB/2019)
*/
public class LeadAssignmentHelper {
    
    public static boolean LeadAssignmentHelper_adjustCounters = TRUE;
    public static boolean LeadAssignmentHelper_Update = TRUE;
    public static boolean explicitelyApplyRoundRobin = False;
    
    //property to hold a list of all Queue Ids Vs. all queue members
    static Map<Id, List<Queue_Member__c>> customQueues {
        get {
            if (customQueues == null) {
                customQueues = getCustomQueues();
            }                
            return customQueues;  
        }    
        set;  
    }
    
    //map to hold initial counters populated while populating custom queues property
    static Map<Id, Decimal> memberCounts; 
    
    //populate customQueues property 
    static Map<Id, List<Queue_Member__c>> getCustomQueues() {
        List<Queue__c> queues = new List<Queue__c>();
        Map<Id, List<Queue_Member__c>> retVal = new Map<Id, List<Queue_Member__c>>();
        memberCounts = new Map<Id, Decimal>();
        queues = [SELECT Id,
                  (SELECT Id, Member__c, Counter__c, Adjustment__c, Total_Count__c, Weighted_Factor__c, isActive__c
                   FROM Queue_Members__r WHERE isActive__c = TRUE ORDER BY Total_Count__c, Rank__c, Member__r.Name ASC)
                  FROM Queue__c WHERE isActive__c = TRUE];
        for(Queue__c q: queues) {
            retVal.put(q.Id, new List<Queue_Member__c>(q.Queue_Members__r));
            for(Queue_Member__c qm : q.Queue_Members__r) {
                memberCounts.put(qm.Id, qm.Counter__c);
            }
        }
        return retVal;
    }
    
    //to be used with before triggers, if required, not yet in use
    //segregate the Lead batch into sub-batches specific to queues
    static Map<Id, List<Lead>> segregateLeadsBasedOnQueues(List<Lead> triggerNew, Map<Id, Lead> triggerOldMap) {
        Map<Id, List<Lead>> retVal = new Map<Id, List<Lead>>();
        Map<Id, List<Queue_Member__c>> QueuesWithAutoassignment = new Map<Id, List<Queue_Member__c>>();
        Set<Id> customQueueIds = customQueues.keySet();
        String queueQuery = 'Select Id,Auto_Assign_Leads__c From Queue__c Where Id In : customQueueIds ';
        if(!explicitelyApplyRoundRobin){
            queueQuery += ' AND Auto_Assign_Leads__c=true';
        }
        for(Queue__c q : (List<Queue__c>)Database.query(queueQuery))
            QueuesWithAutoassignment.put(q.Id,customQueues.get(q.Id));
        
        for(Lead l : triggerNew) {
            if(QueuesWithAutoassignment.containsKey(l.Original_Queue__c) //needs custom routing
               && ((l.Original_Queue__c != null && triggerOldMap == null) //is insert
                   || ( l.Original_Queue__c != null && triggerOldMap.get(l.Id).Original_Queue__c == null) || explicitelyApplyRoundRobin)
               //l.Original_Queue__c != triggerOldMap.get(l.Id).Original_Queue__c)) //is update
              ) {
                  if(retVal.containsKey(l.Original_Queue__c)) {
                      retVal.get(l.Original_Queue__c).add(l);
                  }
                  else {
                      retVal.put(l.Original_Queue__c, new List<Lead>{l});
                  }
                  LeadAssignmentHelper_adjustCounters = TRUE;
              }
        }
        return retVal;
    }
    
    
    //assign leads to queue members based on their current workload and return the affected queue members with modified counts
    static List<Queue_Member__c> performAssignment(Id queueId, List<Lead> leads) {
        List<Queue_Member__c> members = customQueues.get(queueId);
        //List<Queue_Member__c> modifiedMembers = new List<Queue_Member__c>();
        Map<Id,Queue_Member__c> modifiedMembersMap = new Map<Id,Queue_Member__c>();
        Integer queueSize = members.size();
        Integer leadSize = leads.size();
        
        if(queueSize == 0) {
            //do nothing
        }
        else if (queueSize == 1) {
            for(Lead l : leads) {
                l.OwnerId = members.get(0).Member__c;
                l.Original_Queue__c = queueId;
                l.Lead_Board__c = queueId; // added by Sreeram for SFDC-3147 //
                members.get(0).Counter__c = members.get(0).Counter__c + members.get(0).Weighted_Factor__c;
            }
            modifiedMembersMap.put(members.get(0).Id,members.get(0));
            //modifiedMembers.add(members.get(0));
        }
        else if (queueSize > 1) {
            Integer count = 0;
            Integer current = 0;
            Integer next = 1;
            while(
                ((members.get(current).Counter__c + members.get(current).Adjustment__c) 
                 <= (members.get(next).Counter__c + members.get(next).Adjustment__c))
                && count < leadSize) {
                    leads.get(count).OwnerId = members.get(current).Member__c;
                    leads.get(count).Original_Queue__c = queueId;
                    leads.get(count).Lead_Board__c = queueId; // added by Sreeram for SFDC-3147 //
                    members.get(current).Counter__c = members.get(current).Counter__c + members.get(current).Weighted_Factor__c;
                    ++count;
                    
                    if((members.get(current).Counter__c + members.get(current).Adjustment__c) 
                       >= (members.get(next).Counter__c + members.get(next).Adjustment__c)) {
                           modifiedMembersMap.put(members.get(current).Id,members.get(current));
                           //modifiedMembers.add(members.get(current));
                           ++current;
                           ++next;
                           if(next == queueSize) {
                               next = 0;
                           }
                           if(current == queueSize) {
                               current = 0;
                           }
                       }
                }
            modifiedMembersMap.put(members.get(current).Id,members.get(current));
            //modifiedMembers.add(members.get(current));
            
        }
        if(!Trigger.isExecuting) {
            try{
                
                update leads;
            }
            catch(Exception e) {
                ExceptionHandler.postToAll(e);
                throw new CustomException(e.getMessage());
            }
        }           
        return modifiedMembersMap.values();
    }
    
    
    //assign leads to respective queue members based on workload, to be used with before triggers, if required, not yet in use
    public static void assignLeadsToQueueMembers(List<Lead> triggerNew, Map<Id, Lead> triggerOldMap) {
        LeadAssignmentHelper_Update = FALSE;
        Map<Id, List<Lead>> leads = segregateLeadsBasedOnQueues(triggerNew, triggerOldMap);
        List<Queue_Member__c> modifiedMembers = new List<Queue_Member__c>();
        for(Id i : leads.keySet()) {
            modifiedMembers.addAll(performAssignment(i, leads.get(i)));
        }
        if(!modifiedMembers.isEmpty()) {
            update modifiedMembers;
        }
    }
    
    
    //assign lead to be used with quick action
    public static void assignLeadsQuickAction(String queueId, String leadId) {
        explicitelyApplyRoundRobin = true;
        handleReassignment(queueId, leadId);
        Lead l = new Lead(Id = leadId,Original_Queue__c=queueId);
        update l;
        /*List<Queue_Member__c> modifiedMembers = new List<Queue_Member__c>();
modifiedMembers.addAll(performAssignment((Id)queueId, new List<Lead>{new Lead(Id = leadId)}));
if(!modifiedMembers.isEmpty()) {
Map<Id, Queue_Member__c> modifiedMembersFromDatabase = new Map<Id, Queue_Member__c>([SELECT Id, Counter__c FROM Queue_Member__c WHERE Id IN :modifiedMembers]);
for(Queue_Member__c qm : modifiedMembers) {
if(modifiedMembersFromDatabase.get(qm.Id).Counter__c != memberCounts.get(qm.Id)) {
qm.Counter__c = qm.Counter__c + (modifiedMembersFromDatabase.get(qm.Id).Counter__c - memberCounts.get(qm.Id));
}
}
update modifiedMembers;
}*/
    }
    
    //handle a reassignment, decrement the counter of initial owner, not bulkified
    public static void handleReassignment(String queueId, String leadId) {
        List<Lead> leads = new List<Lead>();
        leads = [SELECT Id, Original_Queue__c, OwnerId FROM Lead WHERE Id = :leadId AND Original_Queue__c != null AND Original_Queue__c != ''];
        if(!leads.isEmpty()) {
            String unique = leads.get(0).OwnerId + '_' + leads.get(0).Original_Queue__c;
            List<Queue_Member__c> members = new List<Queue_Member__c>();
            members = [SELECT Id, Counter__c FROM Queue_Member__c WHERE Unique_Key__c = :unique];
            if(!members.isEmpty()) {
                members.get(0).Counter__c = members.get(0).Counter__c - 1;
                update members;
                customQueues = null;
            }       
        }
    }
    
    //added by Jayant on 16th April 2018 for SFDC-1880 (Lead - Round Robin), decrement the counter on lead rejection approval
    public static void adjustCounters(List<Lead> triggerNew, Map<Id, Lead> triggerOldMap) {
        LeadAssignmentHelper_adjustCounters = FALSE;
        Map<String, Integer> rejectedLeads = new Map<String, Integer>();
        Integer temp = 0;
        for(Lead l : triggerNew) {
            if(l.Approval_Status__c == System.Label.LeadRejectionApprovalStatus 
               && l.Approval_Status__c != triggerOldMap.get(l.Id).Approval_Status__c 
               && String.isNotBlank(l.Original_Queue__c) // l.Previous_Status__c == System.Label.LeadStatusUnQualifiedToMarketing) is added to the below line by Anjaneyulu for SFDC-2029
               && (l.Previous_Status__c == System.Label.LeadStatusUnQualifiedToLeadGen || l.Previous_Status__c == System.Label.LeadStatusRejected || l.Previous_Status__c == System.Label.LeadStatusUnQualifiedToMarketing)) {
                   if(rejectedLeads.containsKey(l.OwnerId + '_' + l.Original_Queue__c)) {
                       temp = rejectedLeads.get(l.OwnerId + '_' + l.Original_Queue__c);
                       rejectedLeads.put(l.OwnerId + '_' + l.Original_Queue__c, temp + 1);
                   }
                   else {
                       rejectedLeads.put(l.OwnerId + '_' + l.Original_Queue__c, 1);
                   }
               }
        }
        if(!rejectedLeads.isEmpty()) {
            List<Queue_Member__c> members = new List<Queue_Member__c>();
            members = [SELECT Counter__c, Member__c, Rejected_Leads__c, Weighted_Factor__c, Unique_Key__c
                       FROM Queue_Member__c
                       WHERE Unique_Key__c IN :rejectedLeads.keySet()];
            for(Queue_Member__c qm : members) {
                qm.Rejected_Leads__c = qm.Rejected_Leads__c + rejectedLeads.get(qm.Unique_Key__c);
                qm.Counter__c = qm.Counter__c - (qm.Weighted_Factor__c * rejectedLeads.get(qm.Unique_Key__c));
            }
            update members;
        }
    }
}