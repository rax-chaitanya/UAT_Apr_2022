public class TranscriptHandler implements TriggerInterface{
    
    
    public Boolean isActive()
    {
        if(Trigger_Manager__c.getAll().containsKey('TranscriptTgr')) {
            return Trigger_Manager__c.getInstance('TranscriptTgr').Is_Active__c;
        }
        return false;
    }
    public void beforeInsert(){}
    public void afterInsert(){}
    public void beforeUpdate(){}
    public void afterUpdate(){
        TranscriptHelper.populateLPID(trigger.new,trigger.oldMap);
    }
    public void beforeDelete(){}
    public void afterDelete(){}
    public void afterUndelete(){}
    
}