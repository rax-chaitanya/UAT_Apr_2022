/*
* SFDC -5219 and SFDC 5253  Created By Shravan Godha
* Description Company name and Address details will be update in PartnerFund Claim 
*Test Class - PartnerFundClaimTrigger_Test 
*/
public class PartnerFundClaimHandler implements TriggerInterface{
    public static boolean IS_TRIGGER_ENABLED = true;
    public Boolean isActive()
    {
        if(Trigger_Manager__c.getAll().containsKey('PartnerClaimFundtgr') && IS_TRIGGER_ENABLED) {
            return Trigger_Manager__c.getInstance('PartnerClaimFundtgr').Is_Active__c;
        }
        return false; 
        
    }
   public void beforeInsert() {
        try 
        {   
            PartnerFundClaimTriggerHelper.beforeInsertOperations((List<PartnerFundClaim>)Trigger.new);
        } catch (Exception e) { ExceptionHandler.postToAll(e);  throw new CustomException(ExceptionHandler.getBody(e)); }

   }      
    
    public void beforeUpdate() {}
    
    public void beforeDelete() {}
    
    public void afterInsert()  {    
    }
    
    public void afterUpdate() {
        try 
        {   
            PartnerFundClaimTriggerHelper.sendInvoicesAfterApproved((List<PartnerFundClaim>)Trigger.new,(Map<Id,PartnerFundClaim>)Trigger.oldMap);
        } catch (Exception e) { ExceptionHandler.postToAll(e);  throw new CustomException(ExceptionHandler.getBody(e)); }
        
    }
    
    public void afterDelete() {}
    
    public void afterUndelete() {}
    
    
}