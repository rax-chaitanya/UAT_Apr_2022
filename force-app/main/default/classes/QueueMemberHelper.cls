/**********************************************************************************

Author: Vinod Thupakula
Description: This apex class is created for the Trigger Framework. This class will
run the business logic as per trigger events. 
**********************************************************************************/
public class QueueMemberHelper{
    
    public static void assignRanks(){
        Set<Id> QueueId= new Set<Id>();
        Map<Id,Integer> queueSize = new Map<id,Integer>();
        for(Queue_Member__c qmember : (List<Queue_Member__c>)trigger.new){
            QueueId.add(qmember.Queue__c);
        }  
        for(Queue__c que: [SELECT Id,(SELECT Id FROM Queue_Members__r) FROM Queue__c WHERE Id IN: QueueId]){
            queueSize.put(que.Id,que.Queue_Members__r.size());
        }
        for(Queue_Member__c qm : (List<Queue_Member__c>)trigger.new){
            qm.Rank__c = queueSize.get(qm.Queue__c)+1;
        }  
    }
    
    public static void ReassignRanks(){  
        Set<Id> queuIds  = new Set<Id>();
        for(Queue_Member__c qm:(List<Queue_Member__c>)Trigger.old){
            if(qm.Queue__c != null){queuIds.add(qm.Queue__c);}          
        }       
        if(!queuIds.isEmpty()){    
            List<Queue_Member__c> qmember = new List<Queue_Member__c>();    
            Map<Id,Queue__c> queues = new Map<Id,Queue__c>();
            for(Queue__c q:[Select Id,(Select Id,Rank__c from Queue_Members__r where isDeleted= false order by Rank__c ASC) from Queue__c where Id IN: queuIds]){
                Decimal rank = 1;
                for(Queue_Member__c qm : q.Queue_Members__r){
                    if(rank != qm.rank__c){
                        qm.Rank__c = rank;
                        qmember.add(qm);
                    }
                    rank++;
                }            
            } 
            if(!qmember.isEmpty())update qmember;
        }                      
    }
}