/*****************************************************************
Name: CompanyProcessingQueueable
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
public  class CompanyProcessingQueueable implements Queueable {
    
    Set<Id> requestItemId = new Set<Id>();
    
    public CompanyProcessingQueueable(Set<Id> requestItemId){
        this.requestItemId = requestItemId;
    }
    public void execute(QueueableContext qc){
        updateCompanyOwner(requestItemId);
    }
    
    public static void updateCompanyOwner(Set<Id> requestItemId){
        Map<Id,Id> companyOwnerMap = new Map<Id,Id>();
        Set<Id> oppUpdationId =  new Set<Id>();
        for(Realignment_Request_Item__c reqItem :[SELECT Account__c,Company_ID__c,New_Account_Owner__c,Opportunity_Updation_Flag__c 
                                                  FROM Realignment_Request_Item__c WHERE Id IN :requestItemId])
        {
            companyOwnerMap.put(reqItem.Account__c, reqItem.New_Account_Owner__c);
            if(reqItem.Opportunity_Updation_Flag__c){
                oppUpdationId.add(reqItem.Id);
            }
        }
        try{
            processRelatedAccounts(companyOwnerMap);
            contactCallout(companyOwnerMap,oppUpdationId);
        }catch(Exception ex){
            System.debug('Exception****'+ex);
        }
        
        
    }
    
    public static void  processRelatedAccounts(Map<Id,Id> companyOwnerMap){
        List<Account> toUpdateAccList = new List<Account>();
        for(Account acc: [SELECT Company_Name__c,Id,OwnerId FROM Account 
                          WHERE Company_Name__c IN:companyOwnerMap.keyset()])
        {
            if(companyOwnerMap.containsKey(acc.Company_Name__c)){
                acc.OwnerId = companyOwnerMap.get(acc.Company_Name__c);
                toUpdateAccList.add(acc);
            }
        }
        if(!toUpdateAccList.isEmpty()){
            update toUpdateAccList;
        } 
    }
    
    public static void contactCallout(Map<Id,Id> companyOwnerMap, Set<Id> oppUpdationId){
        If(!Test.isRunningTest()){
           System.enqueueJob(new ContactsProcessingQueueable(companyOwnerMap,oppUpdationId)); 
        }
        
    }
}