public class DPQuoteHandler implements TriggerInterface
{
  public static boolean firstTgrRun = true;
  
  public Boolean isActive()
    {
        return Trigger_Manager__c.getInstance('DPQuoteTgr').Is_Active__c;
    } 
  
     public void beforeInsert() {
    }
    
    public void beforeUpdate() {}
    
    public void beforeDelete() {}
    public void afterInsert()  {
    DPQuotesetupfee.DPQuoteSetupfee();
    DPQuoteLineItemHelper.QuotelinedeleteUndelete();
   
    }
    public void afterUpdate() {
   DPQuotesetupfee.DPQuoteSetupfee();
    DPQuoteLineItemHelper.QuotelinedeleteUndelete();
   
    }
    
    public void afterDelete() {}
    
    public void afterUndelete() {}
        
    }