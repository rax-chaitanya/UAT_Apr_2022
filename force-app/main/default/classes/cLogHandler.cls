public class cLogHandler implements TriggerInterface
{
    public static boolean firstTgrRun = true;
        
    public Boolean isActive()
    {
        return Trigger_Manager__c.getInstance('cLogTgr').Is_Active__c;
    }
 
    public void beforeInsert() {}
 
    public void beforeUpdate() {}
    
    public void beforeDelete() {}
 
    public void afterInsert() 
    {
        Set<Id> companyMasterIds = new Set<Id>();
        Set<Id> contactMasterIds = new Set<Id>();
        String accounttype = System.Label.AccountRecordTypes;
        for(clog__c c : (List<clog__c>)trigger.new)
        {
           if(c.Master_Id__c != null && c.IsMerged__c == true && c.Name == 'Account')
           {
             companyMasterIds.add(c.Master_Id__c);
           }
           
            
        }
        if(companyMasterIds.size() > 0)
        {
            update [Select Id from Account where Company_Name__c in: companyMasterIds and RecordTypeId =: accounttype];
            update [Select Id from Contact where AccountId in: companyMasterIds];
            update [Select Id from Opportunity where AccountId in: companyMasterIds];    
        }
        
    }
 
    public void afterUpdate() {}
 
    public void afterDelete() {}
 
    public void afterUndelete() {}
    
}