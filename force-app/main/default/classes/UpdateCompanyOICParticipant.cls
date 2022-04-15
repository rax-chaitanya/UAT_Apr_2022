/*********************************************************************************
Jira : SFDC-3046,SFDCc-3657,SFDC-3542
Author: Biswa
Description: This apex class is created for updating Comapny OIC participant Field.
Used : This class is calling form "Update OIC Participant New Logic" 
       and "Update OIC Participant If Opportunity Closed won".

**********************************************************************************/
public class UpdateCompanyOICParticipant {
    
   @InvocableMethod
    public static void updateOiCParticipant(List<Id> ids){
        List<Account> comps = new List<Account>();
        Map<Id,Account> companyMap = new Map<Id,Account>([Select Id,Partner_Level__c,OIC_Participant__c,Contract_Type__c,Contract_Signed_Date__c,Partner_Account_Status__c, (Select Id from Opportunities__r where StageName =: 'Closed Won' limit 1), (Select Id from Partner_Roles__r where Commission_Role__c NOT IN ('Don\'t pay commissions','Service Delivery Non-Commissionable')) from Account where Id in : ids]);
        for(Account company : companyMap.values()){
            
            system.debug('Opp size' + company.Opportunities__r.size());
           
            if((company.Partner_Level__c!='Sub Agent' && company.Partner_Level__c!='Regional') && company.Opportunities__r.size()>0 && company.Partner_Roles__r.size()>0 && String.isNotBlank(company.Contract_Type__c) && company.Contract_Signed_Date__c != null && company.Partner_Account_Status__c == 'Approved' && company.OIC_Participant__c == false){
                company.OIC_Participant__c = true;
                comps.add(company); 
            }
                          
        }
        if(comps.size()!=0)
            update comps;  
    }
}