public class RealignmentRequestItemHandler implements TriggerInterface{
    
    
    public Boolean isActive()
    {
        if(Trigger_Manager__c.getInstance('RealignmentRequestItemTrigger')!=null){
            return Trigger_Manager__c.getInstance('RealignmentRequestItemTrigger').Is_Active__c;
        }
        return false;
    } 
    public void beforeInsert() {
    }
    
    public void beforeUpdate() {
        RealignmentRequestItemHelper.processAccounts();
    }
    
    public void beforeDelete() {}
 
    public void afterInsert()  {
    }
 
     public void afterUpdate() {
        //sfdc-6892 : Due to CPU time limit, if the submitted records are executed by batch class then sync method will execute
        //added by sundarayya e
        
        if(System.isBatch()){
            RealignmentRequestItemHelper.grantCompanyTeamMembership();
        }else{
            // if the records are submitted less than 100 size then this future method will execute to reduce the cpu time
            // since the Account team member creation is indipendent
            Set<Id> rrItemIdSet = new Set<Id>();
            Map<Id, Realignment_Request_Item__c> oldRecMap = (Map<Id, Realignment_Request_Item__c>)Trigger.oldMap;
            for(Realignment_Request_Item__c requestItem : (List<Realignment_Request_Item__c>)Trigger.new){
                if(requestItem.Processed__c && !oldRecMap.get(requestItem.Id).Processed__c){
                    rrItemIdSet.add(requestItem.Id);
                }
                
            }
            if(rrItemIdSet.size() > 0){
                RealignmentRequestItemHelper.grantCompTeamMemberFuture(rrItemIdSet);
                System.enqueueJob(new CompanyProcessingQueueable(rrItemIdSet));//SFDC-6993
            }
                                
        }
        //SFDC-6892 Ends
        RealignmentRequestItemHelper.processEmailNotifications();
    }
     
    public void afterDelete() {
    }
    
    public void afterUndelete() {}
}