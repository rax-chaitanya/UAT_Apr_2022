public class ATMHandler implements TriggerInterface {
    public static boolean firstTgrRun = true;
    
    public Boolean isActive()
    {   
        
        if(Trigger_Manager__c.getAll().containsKey('ATMTrigger')) {
            return Trigger_Manager__c.getInstance('ATMTrigger').Is_Active__c;
        }
        return false;
        
    }        
    public void beforeInsert() {}
    
    public void beforeUpdate() {}
    
    public void beforeDelete() {}
    
    
    public void afterInsert() 
    {               
        if(CheckATMRecursion.runOnce() && (Trigger.IsAfter && Trigger.IsInsert)){        
        ATMHelper.insertorUpdateATMOnProdAccount((List<AccountTeamMember>)Trigger.new);                     
        }
    }

    public void afterUpdate() 
    {    
        if(CheckATMRecursion.runOnce() && (Trigger.IsAfter && Trigger.IsUpdate)){        
            ATMHelper.insertorUpdateATMOnProdAccount((List<AccountTeamMember>)Trigger.new);    
        }                                       
    }
    
    public void afterDelete() {}
      
    public void afterUndelete() {}
    
    
}