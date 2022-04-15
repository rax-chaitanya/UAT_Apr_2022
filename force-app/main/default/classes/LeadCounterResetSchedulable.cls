/**
* File : LeadCounterResetSchedulable.cls
* Description : LeadCounterResetSchedulable class implements the schedulable interface
* and resets the Lead Assignment Counters on custom Queue Members to 0 at the end of every month.
* Created Date : 04/May/2018
* @author : Jayant Yadav (RDC)
* 
* Notes : 
* To run the class from Developer Console after 2 minutes, use the below snippet 
* (you may need to delete/abort the job from Scheduled Jobs page) - 
* DateTime currentDateTime = DateTime.now();
* String min = String.valueOf(Math.mod((currentDateTime.minute()), 60) + 2);
* String schExp = '0 '+ min +' * * * ? ';
* System.schedule('Lead Counters Reset - ' + System.now().format(), schExp, new LeadCounterResetSchedulable());
*/
public without sharing class LeadCounterResetSchedulable implements Schedulable {
    //schedulable interface implementation of execute() method
    public void execute(SchedulableContext sc) {
        Time utcTime = Time.newInstance(0,0,0,0);   //00 AM UTC
        Time cstTime = utcTime.addHours(7);         //1 AM CST or 7 AM UTC
        List<Queue__c> queues = new List<Queue__c>(); 
        List<Queue_Member__c> members = new List<Queue_Member__c>();         
        String region = (System.Now().timeGmt() >= utcTime && System.Now().timeGmt() < cstTime) ? 'INTL':'US'; 
        queues = [SELECT Id,Monthly_Reset_Rank__c,Name,
                  (SELECT Id, Member__c, Counter__c, Adjustment__c, Total_Count__c, Weighted_Factor__c, isActive__c, Rank__c
                   FROM Queue_Members__r ORDER BY Rank__c ASC)
                  FROM Queue__c WHERE Classification__c = :region]; 
        
        Map<Id, Integer> firstRankers = new Map<Id, Integer>();
        List<Queue_Member__c> mathchedRankers = new List<Queue_Member__c>();
        for(Queue__c q : queues) {             
            if(q.Monthly_Reset_Rank__c){  
            Integer count = 1; 
            mathchedRankers.clear();            
            for(Queue_Member__c qm : q.Queue_Members__r) {
                boolean flag = true;
                qm.Adjustment__c = 0;
                qm.Adjustment_Reason__c = '';
                qm.Counter__c = 0;
                qm.Counter_Start_Date__c = System.Now();
                qm.Live_Transfer_Count__c = 0;
                qm.Rejected_Leads__c = 0;
                if(q.Queue_Members__r.size()>1){
                    if(qm.Rank__c==1 || firstRankers.containsKey(qm.Member__c)){ 
                        flag = false;
                        mathchedRankers.add(qm);   
                    }            
                    else{
                        qm.Rank__c = count;
                        if(count==1){firstRankers.put(qm.Member__c,count);}
                        count++;
                    }       
                }
                else{qm.Rank__c = 1;}
                if(flag)members.add(qm);
            }  
            
            if(mathchedRankers.size()>0){ 
            if(q.Queue_Members__r.size() == mathchedRankers.size()){
                Integer newCount = 1;
                for(Queue_Member__c qm1:mathchedRankers){
                    qm1.Rank__c = newCount;
                    members.add(qm1);
                    newCount++;
                }
            }
            else{
                for(Queue_Member__c qm1:mathchedRankers){
                    if(qm1.Rank__c==1){
                        qm1.Rank__c = q.Queue_Members__r.size();  
                        members.add(qm1);
                    }
                    else{
                        qm1.Rank__c = count;            
                        members.add(qm1);
                        count++;
                    }
                } 
            }
        }
          }else 
             {
                 for(Queue_Member__c qm2 : q.Queue_Members__r){
                     qm2.Adjustment__c = 0;
                     qm2.Adjustment_Reason__c = '';
                     qm2.Counter__c = 0;
                     qm2.Counter_Start_Date__c = System.Now();
                     qm2.Live_Transfer_Count__c = 0;
                     qm2.Rejected_Leads__c = 0;
                     members.add(qm2);
                 }
             }   
        }
        if(!members.isEmpty()) {
            update members;
        }
        
    }
    
    
}