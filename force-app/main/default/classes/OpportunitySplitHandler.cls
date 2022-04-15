/**********************************************************************************

Author: Pradeep Guttha
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the trigger.

**********************************************************************************/

public class OpportunitySplitHandler implements TriggerInterface
{
    public static Boolean IS_TRIGGER_ENABLED = true;
    public static boolean firstTgrRun = true;
    public static string stopRecursion = 'Before Update';
    
    public Boolean isActive()
    {
        return IS_TRIGGER_ENABLED && Trigger_Manager__c.getInstance('OpportunitySplitTgr').Is_Active__c;
    }
    
    public void beforeInsert() {
        
        List<OpportunitySplit> osList = new List<OpportunitySplit>();
        Set<Id> opptyIds = new Set<Id>();
        for(OpportunitySplit os: (List<OpportunitySplit>) Trigger.new){
            
            System.debug('Oppty split inserted::' + os.SplitOwnerId);
            if(!os.oppty_owner_changed__c){
                osList.add(os);
            }
            else if(!opptyIds.contains(os.OpportunityId)){
                opptyIds.add(os.OpportunityId);
            }
           
        }
        if(osList.size() > 0){
        	validateSplitPercentage(osList);    
        }
        if(opptyIds.size() > 0){
            updateOpptyOwnerChangedFlag(opptyIds);
        }
        
        
    }
    
    public void beforeUpdate() {
        if(stopRecursion == 'Before Update'){
            stopRecursion = 'After Update'; 
            OpportunitySplit oldSplit = new OpportunitySplit();
            List<OpportunitySplit> osList = new List<OpportunitySplit>();
            
            for(OpportunitySplit os : (List<OpportunitySplit>)Trigger.new)
            {
                oldSplit = (OpportunitySplit) Trigger.oldMap.get(os.id);
                
                system.debug('*******************::'+os.Old_Opportunity_Id__c);
                //if(os.SplitOwnerId <> os.Opportunity.OwnerId)
                //{ 
                system.debug('Opp Old Id ***Before********::'+os.Old_Opportunity_Id__c);
                //os.Old_Opportunity_Id__c = 'testing'; 
                system.debug('Opp Old Id *****After*******::'+os.Old_Opportunity_Id__c);
                // }
                
                //Added by Mrinal SFDC-7462
                if(os.SplitPercentage != oldSplit.SplitPercentage){
                    osList.add(os);
                }
            }
            if(osList.size() > 0){
                validateSplitPercentage(osList);
            }
        }
    }
    
    public void beforeDelete() {
        for(OpportunitySplit os: (List<OpportunitySplit>) Trigger.old){
            System.debug('Before deletion of split::'+os.SplitOwnerId);
        }	
	        
    }
    
    public void afterInsert()  {
        
    }
    
    public void afterUpdate() {}
    
    
    
    public void afterDelete() {
        List<OpportunitySplit> OppSplitList = (List<OpportunitySplit>)Trigger.old;
        DeleteUndeleteTriggerHandler.DeleteUndelete(OppSplitList, 'OpportunitySplit');
    }
    
    public void afterUndelete() {}
    
    /*
Added by Mrinal
Function calculates split percentage and returns an error if the total is greater than 100%
*/
    private  void validateSplitPercentage(List <OpportunitySplit> osList){
        
        Map<String, Decimal> opptyWithSplitMap = new Map<String, Decimal>();
        Set<Id> opptyIds = new Set<Id>();
        Decimal splitPercentage; 
        // Initialize oppty ids
        for(OpportunitySplit os: osList){
            if(!opptyIds.contains(os.opportunityId)){
                opptyIds.add(os.opportunityId);
            }
            if(opptyWithSplitMap.containsKey(os.OpportunityId + '~' + os.splitTypeId)){
                splitPercentage = opptyWithSplitMap.get(os.OpportunityId + '~' + os.splitTypeId);
                os.SplitPercentage = os.SplitPercentage == null ? 0 : os.SplitPercentage; 
                splitPercentage += os.SplitPercentage;
                opptyWithSplitMap.put(os.OpportunityId + '~' + os.splitTypeId, splitPercentage);
                
                
            }
            else{
                opptyWithSplitMap.put(os.OpportunityId + '~' + os.splitTypeId, os.SplitPercentage);
            }
        }
        //Get existing split percentage in the org and update map
        for(OpportunitySplit os: [Select id, splitPercentage, splitTypeId, opportunityId from opportunitySplit where opportunityId In: opptyIds And Id not In: osList]){
            System.debug('Quering existing records::' + os.id + ' ' + os.SplitPercentage + ' '+ os.SplitTypeId);
            if(opptyWithSplitMap.containsKey(os.OpportunityId + '~' + os.splitTypeId)){
                splitPercentage = opptyWithSplitMap.get(os.OpportunityId + '~' + os.splitTypeId);
                os.SplitPercentage = os.SplitPercentage == null ? 0 : os.SplitPercentage; 
                splitPercentage += os.SplitPercentage;
                opptyWithSplitMap.put(os.OpportunityId + '~' + os.splitTypeId, splitPercentage);
                
                
            }
            else{
                opptyWithSplitMap.put(os.OpportunityId + '~' + os.splitTypeId, os.SplitPercentage);
            }
        }
        System.debug('Oppty with Split map after init:::' +opptyWithSplitMap);
        //Discard the records
        for(OpportunitySplit os: osList){
            if(opptyWithSplitMap.get(os.opportunityId + '~' + os.splitTypeId) > 100){
                os.addError('The split percentage totals over 100%');
            }
        }
        
    }
    
    private void updateOpptyOwnerChangedFlag(Set<Id> opptyIds){
        List<Opportunity> opptyList = new List<Opportunity>();
        for(Opportunity oppty: [Select id, owner_changed__c from opportunity where Id In: opptyIds]){
            oppty.owner_changed__c = false;
            opptyList.add(oppty);
        }
        if(opptyList.size() > 0){
            update opptyList;
        }
    }
    
    
}