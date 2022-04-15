//TermsandConditionsTrigger_Test

public class TermsandConditionsHandler implements TriggerInterface{
public static boolean IS_TRIGGER_ENABLED = true;
    public Boolean isActive()
    {
        if(Trigger_Manager__c.getAll().containsKey('Termsandconditionstgr') && IS_TRIGGER_ENABLED) {
            return Trigger_Manager__c.getInstance('Termsandconditionstgr').Is_Active__c;
        }
        return false;
        
    }
    public void beforeInsert() {}      
    
    public void beforeUpdate() {}
    
    public void beforeDelete() {}
    
    public void afterInsert()  {
        try 
        {   
            TermsandConditionsTriggerHelper.afterInsertOperations((List<Terms_and_Conditions__c>)Trigger.new);
        } catch (Exception e) { ExceptionHandler.postToAll(e);  throw new CustomException(ExceptionHandler.getBody(e)); }
    }
    
    public void afterUpdate() {}      
    
    public void afterDelete() {}
    
    public void afterUndelete() {}


}