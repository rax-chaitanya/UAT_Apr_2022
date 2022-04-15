/**********************************************************************************

Author:Thirupathi Aeneni
Description: This utility apex class is created for the Story : SFDC-2278.

**********************************************************************************/
public class CompanyMoveController {
    public static void recalculateActivityCount(){
        Set<Id> accIds = new Set<Id>();
        
        for(Account a : (List<Account>)Trigger.new)
            if(a.Company_Named_Account__c == 'ABM')
            accIds.add(a.Id);
        
        if(accIds.size()>0){
            Map<String,Integer> limitsForRole =  new Map<String,Integer>();
            for(Company_Activity_Limits__mdt  li:[SELECT Max_Activities__c,User_Role_Name__c FROM Company_Activity_Limits__mdt ])
                limitsForRole.put(li.User_Role_Name__c,Integer.valueOf(li.Max_Activities__c));
            Period quarter = [Select StartDate,EndDate From Period Where type = 'Quarter' and StartDate = THIS_FISCAL_QUARTER and enddate = THIS_FISCAL_QUARTER  ];
            Map<Id, Account> accountActivityDetails = new Map<Id,  Account>([SELECT Id,Company_Named_Account__c,Owner.UserRole.Name,Move_Account__c,CountofActivities__c,
                                                                             (SELECT Id,ActivityDate FROM Tasks WHERE ActivityDate >=: quarter.StartDate AND ActivityDate <=: quarter.EndDate),
                                                                             (SELECT Id,ActivityDate FROM Events WHERE ActivityDate >=: quarter.StartDate AND ActivityDate <=: quarter.EndDate ) 
                                                                             FROM Account WHERE Id IN:accIds ]);
            for(Account account : (List<Account>)Trigger.new){
                if(accountActivityDetails.containsKey(account.Id)){
                    Account acc = accountActivityDetails.get(account.Id);
                    for(String key:limitsForRole.keySet()){
                        if(acc.Owner.UserRole.Name != null && 
                           acc.Owner.UserRole.Name.containsIgnoreCase(key)){
                               account.CountofActivities__c = acc.Tasks.size()+acc.Events.size();
                               account.Move_Account__c = (limitsForRole.get(key) <= (acc.Tasks.size()+acc.Events.size())) ? 'Yes':'No' ;
                           }
                    }
                }
            }
        }   
    }
    
}