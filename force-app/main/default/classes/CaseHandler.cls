/*********************************************************************************

Author: D Anjaneyulu
Date: 09/19/2017
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the Case trigger.

**********************************************************************************/
public class CaseHandler implements TriggerInterface {
    
    public Boolean isActive()
    {
        if(Trigger_Manager__c.getAll().containsKey('CaseTgr')) {
            return Trigger_Manager__c.getInstance('CaseTgr').Is_Active__c;
        }
        return false;
    }
    
    public void beforeInsert() {
        
    }
    
    public void beforeUpdate() {
        
    }
    
    public void beforeDelete() {}
    
    public void afterInsert()  {
        CaseHelper.updateLocationForPartnerCases();
        //SFDC-6596 - Starts  
        List<Case> partnerCases = new List<Case>();
        Set<Id> caseIds = new Set<Id>();
        for(Case cs : (List<Case>)Trigger.new){
            if(String.isnotblank(cs.AccountId )){
                partnerCases.add(cs);   
            }
        }
        if(!partnerCases.isEmpty()){
            CommunitySharingHelper.shareRecordsOnCreation(partnerCases,'Case');
        }
        //SFDC-6596 - Ends  
    }
    
    public void afterUpdate() {
        
        
    }
    
    public void afterDelete() {
        
    }
    
    public void afterUndelete() {}
}