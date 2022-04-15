public class CompanyCampaignHandler implements TriggerInterface {
     public Boolean isActive()
     {
       if(Trigger_Manager__c.getAll().containsKey('ComCampTgr')) {
            return Trigger_Manager__c.getInstance('ComCampTgr').Is_Active__c;
        }
        return false;   
     }
    public void beforeInsert()
     {
        for(sObject companycampaign:Trigger.new){
                companycampaign.put('Company_Campaign__c',companycampaign.get('Company__c')+'_'+companycampaign.get('Campaign__c'));
                 
            }
    }
    public void afterInsert()
    {
        
    }
    public void beforeUpdate()
    {
      for(sObject companycampaign:Trigger.new){
                companycampaign.put('Company_Campaign__c',companycampaign.get('Company__c')+'_'+companycampaign.get('Campaign__c'));
                 
            }   
    }
    public void afterUpdate()
    {
        
    }
    public void beforeDelete()
    {
        
    }
    public void afterDelete()
    {
        
    }
    public void afterUndelete()
    {
        
    }

}