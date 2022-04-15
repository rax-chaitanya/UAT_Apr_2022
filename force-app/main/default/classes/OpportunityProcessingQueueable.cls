/*****************************************************************
Name: OpportunityProcessingQueueable
Author: Rackspace [Rishabh]
Purpose: To process company related records asynchronously
JIRA Reference : SFDC-6993 :  GART Tool Enhancements 
*****************************************************************/
/*==================================================================
History 
--------
Version   Author               Date              Detail
1.0       Rishabh            30/11/2021        Initial Version
********************************************************************/
public  class OpportunityProcessingQueueable implements Queueable{
    
    Map<Id,Id> companyOwnerMap = new Map<Id,Id>();
    
    public OpportunityProcessingQueueable(Map<Id,Id> companyOwnerMap){
        this.companyOwnerMap = companyOwnerMap;
    }
    
    public void execute(QueueableContext qc){
        processRelatedOpportunities(companyOwnerMap);
    }

    public static  void  processRelatedOpportunities(Map<Id,Id> companyOwnerMap){
        List<Opportunity> toUpdateOppList = new List<Opportunity>();
        for(Opportunity opp : [SELECT Account__c,Acc_Number__c,OwnerId,Company_Number__c,Id, StageName,AccountId FROM Opportunity 
                               WHERE AccountId IN:companyOwnerMap.KeySet()
                               AND StageName NOT IN('Closed Won','Closed Lost')
                               AND RecordType.Name != 'Read Only'])
        {
            if(companyOwnerMap.containsKey(opp.AccountId)){
                opp.OwnerId = companyOwnerMap.get(opp.AccountId);
                toUpdateOppList.add(opp);
            }
        }
        if(!toUpdateOppList.isEmpty()){
            update toUpdateOppList;
        }      
    }
}