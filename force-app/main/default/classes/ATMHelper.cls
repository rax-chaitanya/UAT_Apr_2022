public class ATMHelper{
   
   public static void insertorUpdateATMOnProdAccount(List<AccountTeamMember> ATMListNew){
            Map<Id,AccountTeamMember> atmMap = new Map<Id,AccountTeamMember>();
            for(AccountTeamMember atm : ATMListNew){
                atmMap.put(atm.AccountId,atm);
            }
            System.debug('atmMap:' + atmMap);
            if(!atmMap.isEmpty()){
                List<AccountTeamMember> atms = new List<AccountTeamMember>();
                List<String> accrtIds = System.Label.AccountRecordTypes.split(',');
                
                    for(Account a :[SELECT Id,Company_Name__c,name from Account WHERE (Company_Name__c IN : atmMap.keySet() AND RecordTypeId IN : accrtIds)]){
                    if(a != null){                        
                        atms.add(new AccountTeamMember(AccountId=a.Id,
                                                       UserId = atmMap.get(a.Company_Name__c).UserId,
                                                       OpportunityAccessLevel=atmMap.get(a.Company_Name__c).OpportunityAccessLevel,
                                                       contactaccesslevel=atmMap.get(a.Company_Name__c).contactaccesslevel,
                                                       accountaccesslevel=atmMap.get(a.Company_Name__c).accountaccesslevel,
                                                       caseaccesslevel=atmMap.get(a.Company_Name__c).caseaccesslevel,
                                                       TeamMemberRole=atmMap.get(a.Company_Name__c).TeamMemberRole));
                    }
                
                }
                
                if(!atms.isEmpty()){
                    upsert atms;
                }    
            } 
   }
   
}