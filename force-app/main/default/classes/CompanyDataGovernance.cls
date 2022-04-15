/**********************************************************************************

Author: Sundarayya e
Description: This apex class is created for the Company Data Governance  
converted 'Company Data Governance'process builder to code
date: 25/08/2020

8 April 21: added "SkipUserIDs" to ensure Admin/Integration users bypass entry criteria

**********************************************************************************/
public class CompanyDataGovernance {
    //Method Used to Update the Data Steward Approval field based on condition in before Inserting Account

    public static void updateDataStewardApp(List<Account> records){
        Set<Id> OwnerIds = new Set<Id>();
        
        for(Account acc: records){
            OwnerIds.add(acc.OwnerId);            
        }
        Map<Id, User> AccIdToOwnerRecMap = new Map<Id, User>( [Select Id, Name , Region__c from user where Id IN: OwnerIds]);
        for(Account acc : records){
            if(AccIdToOwnerRecMap.containsKey(acc.OwnerId) && AccIdToOwnerRecMap.get(acc.OwnerId).Region__c == 'AMER' &&
               acc.Number_of_Cloud_Customer_Accounts__c == 0 && System.Label.StandardRecordType.contains(acc.RecordtypeId) && !System.Label.SkipUserIDs.contains(UserInfo.getUserId())){
                   acc.Data_Steward_Approval__c = 'Pending Review';
                   
               }
        }
    }
    
    //Method Used to Submit the record for Approval processbased on conditions on after inserting Account
  
    public static void SubmitRecForApproval(List<Account> records){
        Set<Id> OwnerIds = new Set<Id>();
        
        for(Account acc: records){
            OwnerIds.add(acc.OwnerId);            
        }
        Map<Id, User> AccIdToOwnerRecMap = new Map<Id, User>( [Select Id, Name , Region__c from user where Id IN: OwnerIds]);
        
        for(Account acc : records){
            if(AccIdToOwnerRecMap.containsKey(acc.OwnerId) && AccIdToOwnerRecMap.get(acc.OwnerId).Region__c == 'AMER' &&
               acc.Number_of_Cloud_Customer_Accounts__c == 0 && System.Label.StandardRecordType.contains(acc.RecordtypeId) && !System.Label.SkipUserIDs.contains(UserInfo.getUserId())){
                   Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                   req1.setComments('Submitting request for approval.');
                   req1.setObjectId(acc.id);
                   
                   // Submit on behalf of a specific submitter
                   req1.setSubmitterId(UserInfo.getUserId()); 
                   
                   // Submit the record to specific process and skip the criteria evaluation
                   req1.setProcessDefinitionNameOrId(System.Label.AMER_Company_Data_Governance);
                   req1.setSkipEntryCriteria(true);
                   
                   // Submit the approval request for the account
                   Approval.ProcessResult result = Approval.process(req1);
                   System.assert(result.isSuccess());
               }
        }
    }
}