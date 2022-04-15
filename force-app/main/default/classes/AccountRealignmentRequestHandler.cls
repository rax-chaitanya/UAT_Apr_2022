public class AccountRealignmentRequestHandler implements TriggerInterface{
    
    
    public Boolean isActive()
    {
        if(Trigger_Manager__c.getInstance('AccountRealignmentRequestTrigger')!=null){
            return Trigger_Manager__c.getInstance('AccountRealignmentRequestTrigger').Is_Active__c;
        }
        return false;
    } 
    public void beforeInsert() {
    }
    
    public void beforeUpdate() {
        AccountRealignmentRequestHelper.handleStatusChange();
    }
    
    public void beforeDelete() {}
 
    public void afterInsert()  {
    }
 
    public void afterUpdate() {
    }
 
    public void afterDelete() {
    }
    
    public void afterUndelete() {}
}