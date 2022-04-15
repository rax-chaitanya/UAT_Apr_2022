/*****************************************************************
Name: ContactsProcessingQueueable
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
public class ContactsProcessingQueueable implements Queueable{
    
    Map<Id,Id> companyOwnerMap = new Map<Id,Id>();
    Set<Id> oppUpdationId = new Set<Id>();
    
    public ContactsProcessingQueueable(Map<Id,Id> companyOwnerMap, Set<Id>oppUpdationId){
        this.companyOwnerMap = companyOwnerMap;
        this.oppUpdationId = oppUpdationId;
    }
    
    public void execute(QueueableContext qc){
        processRelatedContacts(companyOwnerMap,oppUpdationId);
    }
    
    public static void  processRelatedContacts(Map<Id,Id> companyOwnerMap, Set<Id> oppUpdationId){
        List<Contact> toUpdateConList = new List<Contact>();
        for(Contact con: [SELECT AccountId,Id,Name,OwnerId FROM Contact WHERE AccountId IN :companyOwnerMap.keyset()])
        {
            if(companyOwnerMap.containsKey(con.AccountId)){
                con.OwnerId = companyOwnerMap.get(con.AccountId);
                toUpdateConList.add(con);
            }
        }
        if(!toUpdateConList.isEmpty()){
            update toUpdateConList;
        } 
        
        if(!oppUpdationId.isEmpty()){
            If(!Test.isRunningTest()){
                System.enqueueJob(new OpportunityProcessingQueueable(companyOwnerMap));
            }
        } 
    }
}