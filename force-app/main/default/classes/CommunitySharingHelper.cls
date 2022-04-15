/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-03-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public without sharing class CommunitySharingHelper {
    
    
    public static void shareRecordsOnUserCreation(List<User> users){
        
        Set<Id> companyIds = new Set<Id>();
        Map<Id,Account> companies = new Map<Id,Account>();
        Map<Id,Set<Id>> sharecompanies = new Map<Id,Set<Id>>();
        List<AccountTeamMember> accTeams = new List<AccountTeamMember>();
        Map<Id,Set<Id>> partnerVsChildIds = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> childVsGrandChilds = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> partnerVsLeadIds = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> partnerVsOptyIds = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> partnerVsCaseIds = new Map<Id,Set<Id>>();
        List<LeadShare> leadShares = new List<LeadShare>();
        List<OpportunityTeamMember> oppTeams = new List<OpportunityTeamMember>();
        Map<Id,Set<Id>> partnerVsChildren = new Map<Id,Set<Id>>();
        
        for(User u : users){
            if(String.isNotBlank(u.AccountId)){
                companyIds.add(u.AccountId); 
            }                
        }
        
        Set<Id> childCompIds = new Set<Id>();
        // Added by Anjaneyulu for SFDC-2297 -- Starts        
        Map<Id,Account> partnersWithChildren = new Map<Id,Account>([Select Id,Partner_Level__c,(Select Id from ChildAccounts where Partner_Account_Status__c = 'Approved') from Account where Partner_Account_Status__c = 'Approved' and id in : companyIds]);
        
        for(Account a : partnersWithChildren.values()){ 
            // Added by Anjaneyulu for SFDC-2297 -- Ends
            companies.put(a.Id, a);
            partnerVsChildren.put(a.Id, new Set<Id>());           
            
            Set<Id> childids = new Set<Id>();
            if(a.ChildAccounts.size() > 0){
                for(Account ac : a.ChildAccounts){
                    companyIds.add(ac.Id);
                    childids.add(ac.Id);
                    childCompIds.add(ac.Id);
                }
                partnerVsChildren.put(a.Id, childIds);
                partnerVsChildIds.put(a.Id, childIds);     
            }
        }
        if(!partnerVsChildIds.isEmpty() && !childCompIds.isEmpty()){
            // Added by Anjaneyulu for SFDC-2297 -- Starts
            Map<Id,Account> childrenWithGrandChildren = new Map<Id,Account>([Select Id,Parent.ParentId,ParentId,(Select Id from ChildAccounts where Partner_Account_Status__c = 'Approved') from Account where id in : childCompIds]);
            
            for(Account childAcc : childrenWithGrandChildren.values()){
                // Added by Anjaneyulu for SFDC-2297 -- Ends
                if(childAcc.ChildAccounts.Size() > 0){
                    set<Id> grandChilds = new Set<Id>();
                    for(Account gchi : childAcc.ChildAccounts){
                        grandChilds.add(gchi.Id);
                        companyIds.add(gchi.Id);
                    }
                    childVsGrandChilds.put(childAcc.Id, grandChilds);
                    
                    if(partnerVsChildren.containsKey(childAcc.Parent.ParentId)){
                        Set<Id> childs =  partnerVsChildren.get(childAcc.Parent.ParentId);
                        childs.addAll(grandChilds);
                        partnerVsChildren.put(childAcc.Parent.ParentId, childs);
                    }else{
                        partnerVsChildren.put(childAcc.Parent.ParentId, grandChilds);
                    }
                }
                
            }
            
        }
        
        for(Lead l : [Select Id,Partner_Company__c from Lead where Partner_Company__c in : companyIds]){
            if(!partnerVsLeadIds.containsKey(l.Partner_Company__c))
                partnerVsLeadIds.put(l.Partner_Company__c, new Set<Id>());
            Set<Id> lids = partnerVsLeadIds.get(l.Partner_Company__c);
            lids.add(l.Id);
            partnerVsLeadIds.put(l.Partner_Company__c, lids);
        }
        for(Account a :[Select Id,Partner_Company__c from Account where Partner_Company__c in : companyIds]){
            if(! sharecompanies.containsKey(a.Partner_Company__c))
                sharecompanies.put(a.Partner_Company__c, new Set<Id>());
            Set<Id> accids = sharecompanies.get(a.Partner_Company__c);
            accids.add(a.Id);
            sharecompanies.put(a.Partner_Company__c, accids);
        }
        
        for(Opportunity o : [Select Id,Partner_Company__c from Opportunity where Partner_Company__c in : companyIds]){
            if(!partnerVsOptyIds.containsKey(o.Partner_Company__c))
                partnerVsOptyIds.put(o.Partner_Company__c, new Set<Id>());
            Set<Id> lids = partnerVsOptyIds.get(o.Partner_Company__c);
            lids.add(o.Id);
            partnerVsOptyIds.put(o.Partner_Company__c, lids);
        }
        
        for(Case cs:[SELECT Id, Account__c,AccountId FROM Case WHERE Account__c IN:companyIds 
                     AND Account.RecordType.DeveloperName = 'Partner_Company']){
                         if(!partnerVsCaseIds.containsKey(cs.AccountId)){
                             partnerVsCaseIds.put(cs.Account.Id, new Set<Id>());
                         } 
                         Set<Id> lids = partnerVsCaseIds.get(cs.AccountId);
                         lids.add(cs.Id);
                         partnerVsCaseIds.put(cs.AccountId,lids);
                     }
        
        
        for(User u : users){
            
            Account partnerComp = companies.get(u.AccountId);
            if(partnerComp != null && sharecompanies.containsKey(partnerComp.Id)){
                for(Id accid : sharecompanies.get(partnerComp.Id))
                    accTeams.add(new AccountTeamMember(AccountId = accId,AccountAccessLevel='Read',ContactAccessLevel='Read',OpportunityAccessLevel='None', TeamMemberRole = Label.Partner_User_Role, UserId= u.Id));   
            }
            
            if(partnerVsChildren.containsKey(u.AccountId)){
                for(Id gchildId : partnerVsChildren.get(u.AccountId)){
                    if(sharecompanies.containsKey(gchildId)){
                        for(Id accId : sharecompanies.get(gchildId)){
                            accTeams.add(new AccountTeamMember(AccountId = accId,AccountAccessLevel='Read',ContactAccessLevel='Read',OpportunityAccessLevel='None', TeamMemberRole = Label.Partner_Master_Agent_Role, UserId= u.Id));   
                            
                        }}}
            }
            
            
            // Lead sharing
            
            if(partnerVsLeadIds.containsKey(u.AccountId)){
                for(Id leadId : partnerVsLeadIds.get(u.AccountId)){
                    leadShares.add(new LeadShare(leadId = leadId,userOrGroupId = u.Id,leadAccessLevel='Read'));
                }
                
            }
            
            if(partnerVsChildren.containsKey(u.AccountId)){
                for(Id gchildId : partnerVsChildren.get(u.AccountId)){
                    if(partnerVsLeadIds.containsKey(gchildId)){
                        for(Id leadId : partnerVsLeadIds.get(gchildId)){
                            leadShares.add(new LeadShare(leadId = leadId,userOrGroupId = u.Id,leadAccessLevel='Read'));
                        }}}
            }
            
            //Opportunity Sharing            
            if(partnerVsOptyIds.containsKey(u.AccountId)){
                for(Id oppId : partnerVsOptyIds.get(u.AccountId)){
                    oppTeams.add(new OpportunityTeamMember(OpportunityId = oppId,UserId = u.Id,OpportunityAccessLevel='Edit',TeamMemberRole =Label.Partner_Master_Agent_Role));
                }
            }
            
            if(partnerVsChildren.containsKey(u.AccountId)){
                for(Id gchildId : partnerVsChildren.get(u.AccountId)){
                    if(partnerVsOptyIds.containsKey(gchildId)){
                        for(Id oppId : partnerVsOptyIds.get(gchildId)){
                            oppTeams.add(new OpportunityTeamMember(OpportunityId = oppId,UserId = u.Id,OpportunityAccessLevel='Edit',TeamMemberRole =Label.Partner_Master_Agent_Role));
                        }}}
            }
        }
        
        if(!oppTeams.isEmpty() || !accTeams.isEmpty() || !leadShares.isEmpty())
            System.enqueueJob(new CommunityShareQueue(leadShares,accTeams,oppTeams,true));
        
    }
    
    public static void shareRecordsOnCreation(List<sObject> records,String type){
        
        List<AccountTeamMember> accTeams = new List<AccountTeamMember>();
        List<sObject> shares = new List<sObject>();
        Set<Id> accountIds = new Set<Id>();
        List<OpportunityTeamMember> oppTeams = new List<OpportunityTeamMember>();
        Set<Id> companyIds = new Set<Id>();
        // Added by Anjaneyulu for SFDC-2116 -- Starts
        Set<Id> leadOrOppIds = new Set<Id>();
        Set<Id> caseIds = new Set<Id>();
        List<Lead> leadswithPrs = new List<Lead>();
        List<Opportunity> oppswithPrs = new List<Opportunity>();
        // Added by Anjaneyulu for SFDC-2116 -- Starts
        for(sobject obj : records){
            if(type =='Lead' || type == 'Opportunity'){
                accountIds.add((Id)obj.get('Partner_Company__c'));  
                leadOrOppIds.add((Id)obj.get('Id')); // SFDC-2116
            }
            
            if(type == 'Account'){
                Account a = (Account)obj;
                if(String.isNotBlank(a.Partner_Company__c))
                    accountIds.add(a.Partner_Company__c);
                else{
                    accountIds.add(a.Id); 
                    
                }
            }
            if(type == 'Case'){
                accountIds.add((Id)obj.get('AccountId'));  
                caseIds.add((Id)obj.get('Id'));
            }             
        }
        // Added by Anjaneyulu for SFDC-2116 -- Starts
        if(Type == 'Lead'){
            leadswithPrs = [Select Id,(Select Partner_Company__c from Partner_Roles__r) from Lead where Id in :leadOrOppIds];
            for(Lead l : leadswithPrs){
                if(l.Partner_Roles__r.size() > 0){
                    for(Partner_Role__c pr : l.Partner_Roles__r)
                        if(String.isNotBlank(pr.Partner_Company__c))
                        accountIds.add(pr.Partner_Company__c);   
                }
            }
        }
        
        if(Type == 'Opportunity'){
            oppswithPrs = [Select Id,(Select Partner_Company__c,Role__c from Partner_Roles__r) from Opportunity where Id in :leadOrOppIds];
            for(Opportunity op : oppswithPrs){
                if(op.Partner_Roles__r.size() > 0){
                    for(Partner_Role__c pr : op.Partner_Roles__r)
                        if(String.isNotBlank(pr.Partner_Company__c) && pr.Role__c=='Source' )
                        accountIds.add(pr.Partner_Company__c);   
                }
            }
        }
        // Added by Anjaneyulu for SFDC-2116 -- Ends
        Map<Id,Account> companiesToShare = new Map<Id,Account>([Select Id,ParentId,Parent.ParentId,Partner_Company__c from Account where id in :accountIds]);
        if(type == 'Account'){
            
            for(Account a : companiesToShare.values()){
                if(a.ParentId != null)
                    accountIds.add(a.ParentId);
                if(a.Parent.ParentId != null)
                    accountIds.add(a.Parent.ParentId);
                if(String.isNotBlank(a.Partner_Company__c))
                    accountIds.add(a.Partner_Company__c);                    
                accountIds.add(a.Id);
            }
        }
        
        
        if(type == 'Opportunity' || type == 'Lead' ||  type == 'Case'){
            for(Account a : [Select Id,ParentId,Parent.ParentId,Parent.Parent.ParentId,Partner_Company__c from Account where id in : accountIds and Partner_Account_Status__c = 'Approved']){
                
                if(String.isNotBlank(a.ParentId))
                    accountIds.add(a.ParentId);            
                if(String.isNotBlank(a.Parent.ParentId))
                    accountIds.add(a.Parent.ParentId);                
                if(String.isNotBlank(a.Parent.Parent.ParentId))
                    accountIds.add(a.Parent.Parent.ParentId);
            }
        }
        
        Map<Id,Account> companies = new Map<Id,Account>([Select Id,ParentId,Parent.ParentId,Parent.Parent.ParentId,Parent.Parent.Parent.Partner_Level__c,Parent.Parent.Partner_Level__c,Parent.Partner_Level__c,Partner_Level__c from Account where id in : accountIds and Partner_Account_Status__c = 'Approved']);
        
        Map<Id,Set<Id>> accVsUserIds = new Map<Id,Set<Id>>();
        
        for(User u : [Select id,AccountId from User where accountId in : companies.keySet() 
                      AND isActive = true]){
                          
                          if(!accVsUserIds.containsKey(u.AccountId))
                              accVsUserIds.put(u.AccountId, new Set<Id>());
                          Set<Id> users = accVsUserIds.get(u.AccountId);
                          users.add(u.Id);
                          accVsUserIds.put(u.AccountId, users);
                          
                      }
        
        for(sObject obj : records){
            
            if(type == 'Account'){
                Account a = (Account)obj;
                Id companyId = null;
                Id parentCompanyId = null;
                Id grandParentId = null;
                if(String.isNotBlank(a.Partner_Company__c)){
                    Account partnerComp = companies.get(a.Partner_Company__c);
                    companyId = partnerComp.Id;
                    parentCompanyId = partnerComp.ParentId;
                    grandParentId = partnerComp.Parent.ParentId;
                }else{
                    Account comp = companies.get((Id)obj.get('Id'));
                    if(comp != null){
                        companyId = comp.Id;      
                    } 
                }
                
                if(accVsUserIds.containsKey(companyId)){
                    for(Id userId : accVsUserIds.get(companyId)){
                        accTeams.add(new AccountTeamMember(AccountId = (Id)obj.get('Id'),AccountAccessLevel='Edit',ContactAccessLevel='Edit',OpportunityAccessLevel='None', TeamMemberRole = Label.Partner_User_Role, UserId= userId));  
                    }
                }
                
                if(parentCompanyId != null && companies.containsKey(parentCompanyId)){
                    Account parentComp = companies.get(parentCompanyId);
                    if(parentComp != null && accVsUserIds.containsKey(parentComp.Id)){
                        for(Id userId : accVsUserIds.get(parentComp.Id)){
                            accTeams.add(new AccountTeamMember(AccountId = (Id)obj.get('Id'),AccountAccessLevel='Edit',ContactAccessLevel='Edit',OpportunityAccessLevel='None', TeamMemberRole = Label.Partner_Master_Agent_Role, UserId= userId));  
                        }
                    }
                    
                    // Grand Parent Sharing
                    if(grandParentId != null && companies.containsKey(grandParentId)){
                        Account grandParentComp = companies.get(grandParentId);
                        if(grandParentComp != null && accVsUserIds.containsKey(grandParentComp.Id)){
                            for(Id userId : accVsUserIds.get(grandParentComp.Id)){
                                accTeams.add(new AccountTeamMember(AccountId = (Id)obj.get('Id'),AccountAccessLevel='Edit',ContactAccessLevel='Edit',OpportunityAccessLevel='None', TeamMemberRole = Label.Partner_Master_Agent_Role, UserId= userId));  
                            }
                        }
                    }
                }
            }
            
            // Lead Record Sharing
            if(type == 'Lead' && (Id)obj.get('Partner_Company__c') != null){
                Id companyId = (Id)obj.get('Partner_Company__c');                
                shareLeadToPartnerCompany(obj, companyId, companies, accVsUserIds, shares);
            }
            
            // Opp record sharing            
            if(type == 'Opportunity' && (Id)obj.get('Partner_Company__c') != null){
                Id companyId = (Id)obj.get('Partner_Company__c');
                shareOpportunityToPartnerCompany(obj,companyId, companies,accVsUserIds,oppTeams,accTeams);
            }
            
            //SFDC-6596 - Starts
            if(type == 'Case' && (Id)obj.get('AccountId') != null && (!companies.isempty())){
                Id companyId = (Id)obj.get('AccountId'); 
                shareCasesToPartnerCompany(obj, companyId, companies, accVsUserIds, shares);
            }
            //SFDC-6596 - Ends
        }
        
        // Added by Anjaneyulu for SFDC-2116 -- Starts  
        if(Type == 'Lead'){
            for(Lead l : leadswithPrs){
                if(l.Partner_Roles__r.size() > 0){
                    for(Partner_Role__c pr : l.Partner_Roles__r)
                        if(String.isNotBlank(pr.Partner_Company__c))
                        shareLeadToPartnerCompany(l,pr.Partner_Company__c,companies,accVsUserIds,shares);  
                }
            }
        } 
        
        if(Type == 'Opportunity'){
            oppswithPrs = [Select Id,AccountId,Partner_Company__c,(Select Partner_Company__c,Role__c from Partner_Roles__r) from Opportunity where Id in :leadOrOppIds];
            for(Opportunity op : oppswithPrs){
                if(op.Partner_Roles__r.size() > 0){
                    for(Partner_Role__c pr : op.Partner_Roles__r)
                        if(String.isNotBlank(pr.Partner_Company__c) && pr.Role__c=='Source' )
                        shareOpportunityToPartnerCompany(op,pr.Partner_Company__c, companies,accVsUserIds,oppTeams,accTeams);  
                }
            }
        }
        
        // Added by Anjaneyulu for SFDC-2116 -- Ends 
        if(accTeams.size() > 0)
            Database.insert(accTeams,false);
        if(oppTeams.size() > 0)
            Database.insert(oppTeams,false);
        if(!shares.isEmpty())
            System.enqueueJob(new CommunityShareQueue(shares,null,null,true));
        
    }
    
    // Added by Anjaneyulu for SFDC-2116 -- Starts 
    private static void shareLeadToPartnerCompany(sobject obj,Id companyId,Map<Id,Account> companies,Map<Id,Set<Id>> accVsUserIds,List<sObject> shares){
        
        Account company = companies.get(companyId);
        if(company != null){
            if(companyId != null && accVsUserIds.containsKey(companyId) && accVsUserIds.containsKey(companyId)){
                for(Id userId : accVsUserIds.get(companyId)){
                    shares.add(new LeadShare(leadId = (Id)obj.get('Id'),userOrGroupId = userId,leadAccessLevel='Read'));
                }}
            
            if(company.ParentId != null && companies.containsKey(company.ParentId) && accVsUserIds.containsKey(company.ParentId)){
                for(Id userId : accVsUserIds.get(company.ParentId))
                    shares.add(new LeadShare(leadId = (Id)obj.get('Id'),userOrGroupId = userId,leadAccessLevel='Read'));
            }
            // Grand Parent sharing
            if(company.Parent.ParentId != null && companies.containsKey(company.Parent.ParentId) && accVsUserIds.containsKey(company.Parent.ParentId)){
                for(Id userId : accVsUserIds.get(company.Parent.ParentId))
                    shares.add(new LeadShare(leadId = (Id)obj.get('Id'),userOrGroupId = userId,leadAccessLevel='Read'));
            }
            // SFDC-6596 - Master Agent Access of all Child Partner companies - Starts
            if(company.Parent.Parent.ParentId != null && companies.containsKey(company.Parent.Parent.ParentId) && accVsUserIds.containsKey(company.Parent.Parent.ParentId)){
                for(Id userId : accVsUserIds.get(company.Parent.Parent.ParentId))
                    shares.add(new LeadShare(leadId = (Id)obj.get('Id'),userOrGroupId = userId,leadAccessLevel='Read'));
            }
            // SFDC-6596 - Master Agent Access of all Child Partner companies - Ends
        }
    }
    
    private static void shareOpportunityToPartnerCompany(sobject obj,Id companyId,Map<Id,Account> companies,Map<Id,Set<Id>> accVsUserIds,List<OpportunityTeamMember> oppTeams,List<AccountTeamMember> accTeams){
        
        Account company = companies.get(companyId);
        if(accVsUserIds.containsKey(companyId)){
            for(Id userId : accVsUserIds.get(companyId)){
                oppTeams.add(new OpportunityTeamMember(OpportunityId = (Id)obj.get('Id'),UserId = userId,OpportunityAccessLevel='Edit',TeamMemberRole =Label.Partner_User_Role));
                accTeams.add(new AccountTeamMember(AccountId =  (Id)obj.get('AccountId'),AccountAccessLevel='Edit',ContactAccessLevel='Edit',OpportunityAccessLevel='None', TeamMemberRole = Label.Partner_User_Role, UserId= userId));
            }
        }
        
        if(company.ParentId != null && companies.containsKey(company.ParentId) && accVsUserIds.containsKey(company.ParentId)){
            for(Id userId : accVsUserIds.get(company.ParentId)){
                oppTeams.add(new OpportunityTeamMember(OpportunityId = (Id)obj.get('Id'),UserId = userId,OpportunityAccessLevel='Edit',TeamMemberRole =Label.Partner_Master_Agent_Role));
                accTeams.add(new AccountTeamMember(AccountId =  (Id)obj.get('AccountId'),AccountAccessLevel='Edit',ContactAccessLevel='Edit',OpportunityAccessLevel='None', TeamMemberRole = Label.Partner_Master_Agent_Role, UserId= userId));
            }
        }
        // Grand Parent Sharing
        if(company.Parent.ParentId != null && companies.containsKey(company.Parent.ParentId) && accVsUserIds.containsKey(company.Parent.ParentId)){
            for(Id userId : accVsUserIds.get(company.Parent.ParentId)){
                oppTeams.add(new OpportunityTeamMember(OpportunityId = (Id)obj.get('Id'),UserId = userId,OpportunityAccessLevel='Edit',TeamMemberRole =Label.Partner_Master_Agent_Role));
                accTeams.add(new AccountTeamMember(AccountId = (Id)obj.get('AccountId'),AccountAccessLevel='Edit',ContactAccessLevel='Edit',OpportunityAccessLevel='None', TeamMemberRole = Label.Partner_Master_Agent_Role, UserId= userId));
            }
        }
        
        // SFDC-6596 - Master Agent Access of all Child Partner companies - starts
        if(company.Parent.Parent.ParentId != null && companies.containsKey(company.Parent.Parent.ParentId) && accVsUserIds.containsKey(company.Parent.Parent.ParentId)){
            for(Id userId : accVsUserIds.get(company.Parent.Parent.ParentId)){
                oppTeams.add(new OpportunityTeamMember(OpportunityId = (Id)obj.get('Id'),UserId = userId,OpportunityAccessLevel='Edit',TeamMemberRole =Label.Partner_Master_Agent_Role));
                accTeams.add(new AccountTeamMember(AccountId = (Id)obj.get('AccountId'),AccountAccessLevel='Edit',ContactAccessLevel='Edit',OpportunityAccessLevel='None', TeamMemberRole = Label.Partner_Master_Agent_Role, UserId= userId));
            }
        }
        // SFDC-6596 - Master Agent Access of all Child Partner companies - Ends
        
    }
    // Added by Anjaneyulu for SFDC-2116 -- Ends 
    
    public static void shareCompaniesOnLeadConvert(List<Lead> convertedLeads){}
    
    public static void activeInactiveUsers(Set<Id> companyIds,Boolean isActivate){
        
        List<User> users = [Select Id,isActive from User where AccountId in : companyIds];
        
        if(users != null &&  !users.isEmpty()){
            for(User u : users){
                
                if(isActivate)
                    u.IsActive = true;
                else
                    u.IsActive = false;
            }            
            System.enqueueJob(new CommunityShareQueue(users));
        }        
    }
    
    @InvocableMethod
    public static void shareLeads(List<Id> leadIds){
        
        List<sObject> shares = new List<sObject>();
        Set<Id> accountIds = new Set<Id>();
        Set<Id> companyIds = new Set<Id>();
        List<Lead> leadsToShare = [Select Id,OwnerId,Partner_Company__c from Lead where id in : leadIds];
        for(Lead obj : leadsToShare){
            accountIds.add(obj.Partner_Company__c);
        }
        
        for(Account a : [Select Id,ParentId,Parent.ParentId,Parent.Parent.ParentId,Partner_Company__c from Account where id in : accountIds and Partner_Account_Status__c = 'Approved']){
            if(String.isNotBlank(a.ParentId)){
                accountIds.add(a.ParentId);
            }                
            if(String.isNotBlank(a.Parent.ParentId)){
                accountIds.add(a.Parent.ParentId);
            }
            if(String.isNotBlank(a.Parent.Parent.ParentId)){
                accountIds.add(a.Parent.Parent.ParentId);
            }
        }
        
        Map<Id,Account> companies = new Map<Id,Account>([Select Id,ParentId,Parent.ParentId,Parent.Parent.ParentId,Parent.Parent.Partner_Level__c,Parent.Partner_Level__c,Partner_Level__c from Account where id in : accountIds and Partner_Account_Status__c = 'Approved']);
        
        Map<Id,Set<Id>> accVsUserIds = new Map<Id,Set<Id>>();
        
        for(User u : [SELECT Id,AccountId FROM User WHERE accountId in : companies.keySet() 
                      AND isActive = true AND Contact.Inactive__c = false])
        {
            if(!accVsUserIds.containsKey(u.AccountId))
                accVsUserIds.put(u.AccountId, new Set<Id>());
            Set<Id> users = accVsUserIds.get(u.AccountId);
            users.add(u.Id);
            accVsUserIds.put(u.AccountId, users);
        }
        
        for(Lead obj : leadsToShare){            
            
            Id companyId = obj.Partner_Company__c;
            
            Account company = companies.get(companyId);
            if(companyId != null && accVsUserIds.containsKey(companyId)){
                for(Id userId : accVsUserIds.get(companyId)){
                    shares.add(new LeadShare(leadId = obj.id,userOrGroupId = userInfo.getUserId(),leadAccessLevel='Read'));
                }}
            
            if(company.ParentId != null && companies.containsKey(company.ParentId) && accVsUserIds.containsKey(company.ParentId)){
                for(Id userId : accVsUserIds.get(company.ParentId))
                    shares.add(new LeadShare(leadId = obj.id,userOrGroupId = userInfo.getUserId(),leadAccessLevel='Read'));
            }
            // Grand Parent sharing
            if(company.Parent.ParentId != null && companies.containsKey(company.Parent.ParentId) && accVsUserIds.containsKey(company.Parent.ParentId)){
                for(Id userId : accVsUserIds.get(company.Parent.ParentId))
                    shares.add(new LeadShare(leadId = obj.id,userOrGroupId = userInfo.getUserId(),leadAccessLevel='Read'));
            }
            // SFDC-6596 - Master Agent Access of all Child Partner companies - starts
            if(company.Parent.Parent.ParentId != null && companies.containsKey(company.Parent.Parent.ParentId) && accVsUserIds.containsKey(company.Parent.Parent.ParentId)){
                for(Id userId : accVsUserIds.get(company.Parent.Parent.ParentId))
                    shares.add(new LeadShare(leadId = obj.id,userOrGroupId = userInfo.getUserId(),leadAccessLevel='Read'));
            }
            // SFDC-6596 -Master Agent Access of all Child Partner companies - Ends
        }            
        
        if(!shares.isEmpty())
            Database.insert(shares, false);        
    }
    
    /**
* @description     : method to share cases with partner company
* @jira            :  SFDC-6596 
**/
    @TestVisible
    private static void shareCasesToPartnerCompany(sobject obj,Id companyId,Map<Id,Account> companies,Map<Id,Set<Id>> accVsUserIds,List<sObject> shares){
        
        Account company = companies.get(companyId);
        if(companyId != null && accVsUserIds.containsKey(companyId) && accVsUserIds.containsKey(companyId)){
            for(Id userId : accVsUserIds.get(companyId)){
                shares.add(new CaseShare(CaseId = (Id)obj.get('Id'),UserOrGroupId = userId,CaseAccessLevel='Read'));
            }}
        
        if(company.ParentId != null && companies.containsKey(company.ParentId) && accVsUserIds.containsKey(company.ParentId)){
            for(Id userId : accVsUserIds.get(company.ParentId))
                shares.add(new CaseShare(CaseId = (Id)obj.get('Id'),UserOrGroupId = userId,CaseAccessLevel='Read'));
        }
        
        if(company.Parent.ParentId != null && companies.containsKey(company.Parent.ParentId) && accVsUserIds.containsKey(company.Parent.ParentId)){
            for(Id userId : accVsUserIds.get(company.Parent.ParentId))
                shares.add(new CaseShare(CaseId = (Id)obj.get('Id'),UserOrGroupId = userId,CaseAccessLevel='Read'));
        }
        if(company.Parent.Parent.ParentId != null && companies.containsKey(company.Parent.Parent.ParentId) && accVsUserIds.containsKey(company.Parent.Parent.ParentId)){
            for(Id userId : accVsUserIds.get(company.Parent.Parent.ParentId))
                shares.add(new CaseShare(CaseId = (Id)obj.get('Id'),UserOrGroupId = userId,CaseAccessLevel='Read'));
        }
    } 
}