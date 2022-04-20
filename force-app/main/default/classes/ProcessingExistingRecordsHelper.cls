/********************************************************************
// Purpose              : SFDC-7281 -- Partner Company Historical records are shared Upto 3 level Parent Partner Company
// Author               : Rackspace [Rishabh]
// Parameters           : List<Account>
//  Returns             : null
//JIRA Reference        :SFDC-7281 -- Partner Company Historical records are shared Upto 3 level Parent Partner Company
//********************************************************************/
@SuppressWarnings('PMD.ApexCRUDViolation')
public without sharing class ProcessingExistingRecordsHelper {
    
    public void updateRecords(List<Account> accList){
        
        Map<Id,Set<Id>> partnerCompanyUserMap =  new Map<Id,Set<Id>> (); 
        Map<Id,Account> partnerCompanyMap = new Map<Id,Account>(accList);
        
        Set<Id> accountIds = getAccountIds(accList);
        
        for(User usr: [Select Id,AccountId from User WHERE AccountId IN : accountIds AND isActive = true]){
            if(String.isNotBlank(usr.AccountId)){
                if(partnerCompanyUserMap.containsKey(usr.AccountId)){
                    partnerCompanyUserMap.get(usr.AccountId).add(usr.Id);                        
                }
                else{
                    Set<Id> usrSet = new Set<Id> ();
                    usrSet.add(usr.Id);
                    partnerCompanyUserMap.put(usr.AccountId,usrSet);
                }
            }
        }
        
        //Sharing Accounts through AccountTeam Members
        List<AccountTeamMember> accTeams = processAccountTeams(partnerCompanyUserMap,partnerCompanyMap);
        //Sharing Leads through leadShare
        List<sObject> leadShares = processLeadShare(partnerCompanyUserMap,partnerCompanyMap);
        //Sharing Opportunities through OpportunityTeam Members
        List<OpportunityTeamMember> oppTeams = processOpportunityTeams(partnerCompanyUserMap,partnerCompanyMap);
        // Sharing Cases through caseShare
        processCaseShare(partnerCompanyUserMap,partnerCompanyMap);

        try{
            System.debug('lead share size'+leadShares.size());
            System.enqueueJob(new CommunityShareQueue(leadShares,accTeams,null,true));
        }catch(Exception ex){
            System.debug('exception message***'+ex.getMessage());
            System.debug('exception received***'+ex);
        }
        
    }
    
    @TestVisible
    private static Set<Id> getAccountIds(List<Account> accList){
        Set<Id> accountIds = new Set<Id>();
        for(Account acc:accList){
            if(String.isNotBlank(acc.ParentId)){
                accountIds.add(acc.ParentId);
            }                   
            if(String.isNotBlank(acc.Parent.ParentId)){
                accountIds.add(acc.Parent.ParentId);  
            }               
            if(String.isNotBlank(acc.Parent.Parent.ParentId)){
                accountIds.add(acc.Parent.Parent.ParentId);
            }   
        }
        return accountIds;
    }
    
    @TestVisible
    private static List<AccountTeamMember> processAccountTeams(Map<Id,Set<Id>> partnerCompanyUserMap, Map<Id,Account> partnerCompanyMap){
        List<AccountTeamMember> accTeams = new List<AccountTeamMember>();
        for(Account acc:partnerCompanyMap.values()){
            if(acc.ParentId != null && partnerCompanyUserMap.containsKey(acc.ParentId)){
                for(Id parentUsr: partnerCompanyUserMap.get(acc.ParentId)){
                    accTeams.add(new AccountTeamMember(AccountId = acc.Id,AccountAccessLevel='Edit',ContactAccessLevel='Edit',OpportunityAccessLevel='None', TeamMemberRole = Label.Partner_Master_Agent_Role, UserId= parentUsr));
                }
                if(acc.Parent.ParentId != null && partnerCompanyUserMap.containsKey(acc.Parent.ParentId)){
                    for(Id grandParentUsr: partnerCompanyUserMap.get(acc.Parent.ParentId)){
                        accTeams.add(new AccountTeamMember(AccountId = acc.Id,AccountAccessLevel='Edit',ContactAccessLevel='Edit',OpportunityAccessLevel='None', TeamMemberRole = Label.Partner_Master_Agent_Role, UserId= grandParentUsr));
                    }
                }
                if(acc.Parent.Parent.ParentId != null && partnerCompanyUserMap.containsKey(acc.Parent.Parent.ParentId)){
                    for(Id greatGrandParentusr: partnerCompanyUserMap.get(acc.Parent.Parent.ParentId)){
                        accTeams.add(new AccountTeamMember(AccountId = acc.Id,AccountAccessLevel='Edit',ContactAccessLevel='Edit',OpportunityAccessLevel='None', TeamMemberRole = Label.Partner_Master_Agent_Role, UserId= greatGrandParentusr));
                    }
                }
            }
        }
        return accTeams;
    }
    
    @TestVisible
    private static List<OpportunityTeamMember> processOpportunityTeams(Map<Id,Set<Id>> partnerCompanyUserMap, Map<Id,Account> partnerCompanyMap){
        List<OpportunityTeamMember> oppTeams = new List<OpportunityTeamMember>();

        for(Opportunity opp: [SELECT Id,Partner_Company__c, Partner_Company__r.ParentId, Partner_Company__r.Parent.ParentId, 
                              Partner_Company__r.Parent.Parent.ParentId FROM Opportunity WHERE Partner_Company__c IN :partnerCompanyMap.keySet()])
        {
            if(opp.Partner_Company__r.ParentId != null && partnerCompanyUserMap.containsKey(opp.Partner_Company__r.ParentId)){
                for(Id parentUsr: partnerCompanyUserMap.get(opp.Partner_Company__r.ParentId)){
                    oppTeams.add(new OpportunityTeamMember(OpportunityId = opp.Id,UserId = parentUsr,OpportunityAccessLevel='Edit',TeamMemberRole =Label.Partner_User_Role));
                }
                if(opp.Partner_Company__r.Parent.ParentId != null &&  partnerCompanyUserMap.containsKey(opp.Partner_Company__r.Parent.ParentId)){
                    for(Id grandParentUsr: partnerCompanyUserMap.get(opp.Partner_Company__r.Parent.ParentId)){
                        oppTeams.add(new OpportunityTeamMember(OpportunityId = opp.Id,UserId = grandParentUsr,OpportunityAccessLevel='Edit',TeamMemberRole =Label.Partner_User_Role));
                    }
                }
                if(opp.Partner_Company__r.Parent.Parent.ParentId != null && partnerCompanyUserMap.containsKey(opp.Partner_Company__r.Parent.Parent.ParentId)){
                    for(Id greatGrandParentusr: partnerCompanyUserMap.get(opp.Partner_Company__r.Parent.Parent.ParentId)){
                        oppTeams.add(new OpportunityTeamMember(OpportunityId = opp.Id,UserId = greatGrandParentusr,OpportunityAccessLevel='Edit',TeamMemberRole =Label.Partner_User_Role));
                    }
                }
            }
        }

        return oppTeams;
    }
    
    @TestVisible
    private static List<sObject> processLeadShare(Map<Id,Set<Id>> partnerCompanyUserMap, Map<Id,Account> partnerCompanyMap){
        List<sObject> leadShares = new List<sObject>();        
        for(Lead led: [SELECT Id,Partner_Company__c, Partner_Company__r.ParentId, Partner_Company__r.Parent.ParentId, 
                       Partner_Company__r.Parent.Parent.ParentId FROM Lead WHERE Partner_Company__c IN :partnerCompanyMap.keySet()])
        {
            if(led.Partner_Company__r.ParentId != null &&  partnerCompanyUserMap.containsKey(led.Partner_Company__r.ParentId)){
                for(Id parentUsr: partnerCompanyUserMap.get(led.Partner_Company__r.ParentId)){
                    leadShares.add(new LeadShare(leadId = led.id,userOrGroupId = parentUsr,leadAccessLevel='Read'));
                }
                if(led.Partner_Company__r.Parent.ParentId != null && partnerCompanyUserMap.containsKey(led.Partner_Company__r.Parent.ParentId)){
                    for(Id grandParentUsr: partnerCompanyUserMap.get(led.Partner_Company__r.Parent.ParentId)){
                        leadShares.add(new LeadShare(leadId = led.Id,userOrGroupId = grandParentUsr,leadAccessLevel='Read'));
                    }
                }
                if(led.Partner_Company__r.Parent.Parent.ParentId != null && partnerCompanyUserMap.containsKey(led.Partner_Company__r.Parent.Parent.ParentId)){
                    for(id greatGrandParentusr: partnerCompanyUserMap.get(led.Partner_Company__r.Parent.Parent.ParentId)){
                        leadShares.add(new LeadShare(leadId = led.Id,userOrGroupId = greatGrandParentusr,leadAccessLevel='Read'));
                    }
                }
            }
        }   
        return leadShares;
    }
    
    @TestVisible
    private static void processCaseShare(Map<Id,Set<Id>> partnerCompanyUserMap, Map<Id,Account> partnerCompanyMap){
        List<sObject> caseShares = new List<sObject>();
        for(Case cs: [SELECT Id,AccountId, Account.ParentId, Account.Parent.ParentId, 
                      Account.Parent.Parent.ParentId FROM Case WHERE AccountId IN :partnerCompanyMap.keySet()])
        {
            if(cs.Account.ParentId != null && partnerCompanyUserMap.containsKey(cs.Account.ParentId)){
                for(Id parentUsr: partnerCompanyUserMap.get(cs.Account.ParentId)){
                    caseShares.add(new CaseShare(CaseId = cs.Id,UserOrGroupId = parentUsr,CaseAccessLevel='Read'));
                }
                if(cs.Account.Parent.ParentId != null && partnerCompanyUserMap.containsKey(cs.Account.Parent.ParentId)){
                    for(Id grandParentUsr: partnerCompanyUserMap.get(cs.Account.Parent.ParentId)){
                        caseShares.add(new CaseShare(CaseId = cs.Id,UserOrGroupId = grandParentUsr,CaseAccessLevel='Read'));
                    }
                }
                if(cs.Account.Parent.Parent.ParentId != null && partnerCompanyUserMap.containsKey(cs.Account.Parent.Parent.ParentId)){
                    for(Id greatGrandParentusr: partnerCompanyUserMap.get(cs.Account.Parent.Parent.ParentId)){
                        caseShares.add(new CaseShare(CaseId = cs.Id,UserOrGroupId = greatGrandParentusr,CaseAccessLevel='Read'));
                    }
                }
            }
        }
        try{
            if(!caseShares.isEmpty()){
                Database.insert(caseShares,false);
            }
        }catch(exception ex){
            System.debug('Exception while updating cases'+ex.getMessage());
        }
    } 
}