public class PartnerFundRequestHandler implements TriggerInterface{
    
    public static boolean IS_TRIGGER_ENABLED = true;
    
    
    
     public Boolean isActive()
    {
        if(Trigger_Manager__c.getAll().containsKey('PartnerRequestFundtgr') && IS_TRIGGER_ENABLED) {
            return Trigger_Manager__c.getInstance('PartnerRequestFundtgr').Is_Active__c;
        }
        return false;
        
    }
    public void beforeInsert() 
    {
        try 
        {   
            PartnerFundRequestTriggerHelper.beforeInsertOperations((List<PartnerFundRequest>)Trigger.new);
        } catch (Exception e) { ExceptionHandler.postToAll(e);  throw new CustomException(ExceptionHandler.getBody(e)); }
    }
    
    public void beforeUpdate() {
        try 
        {   
            PartnerFundRequestTriggerHelper.beforeInsertOperations((List<PartnerFundRequest>)Trigger.new);
            //PartnerFundRequestTriggerHelper.beforeUpdateValidations((List<PartnerFundRequest>)Trigger.new, (Map<Id,PartnerFundRequest >)Trigger.oldMap);
        } catch (Exception e) { ExceptionHandler.postToAll(e);  throw new CustomException(ExceptionHandler.getBody(e)); }
    }
    
    public void beforeDelete() {}
    
    public void afterInsert()  {}
    
    public void afterUpdate() {}
    
    public void afterDelete() {}
    
    public void afterUndelete() {}

}