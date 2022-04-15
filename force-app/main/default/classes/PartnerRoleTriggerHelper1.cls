public class PartnerRoleTriggerHelper1 {
    
    public static void validateApprovals(Map<Id,Partner_Role__c> approvedPRoles){
        Set<Id> leadIds = new Set<Id>();
        Set<Id> oppIds = new Set<Id>();
        set<Id> partcompIds = new Set<Id>(); 
        for(Partner_Role__c pr : approvedProles.values()){
            //added by sundarayya e for 4456
            if(pr.partner_company__c!= null && pr.Partner_Contact__c==null ){
                partcompIds.add(pr.Partner_Company__c);
            }
            if(String.isNotBlank(pr.Lead__c))
                leadIds.add(pr.Lead__c);  
            if(String.isNotBlank(pr.Opportunity__c))
                oppIds.add(pr.Opportunity__c); 
        }
        //added by sundarayya e for 4456 to populate partner contact on partner role if partner company has primary contact
        Map<Id, Account> partComIdtoRecMap = new Map<Id,Account>([select Id,Primary_Member__c from Account where Primary_Member__c != null and Id IN:partcompIds]);
        for(Partner_Role__c pr : approvedProles.values()){
            if(partComIdtoRecMap.containskey(pr.Partner_Company__c) && partComIdtoRecMap.get(pr.Partner_Company__c).Primary_Member__c != null 
               && pr.Partner_Contact__c == null){
                   pr.Partner_Contact__c = partComIdtoRecMap.get(pr.Partner_Company__c).Primary_Member__c;
               }
        }
        if(leadIds.size() >0 ){
            List<Lead> leadsToUpdate = new List<Lead>();
            
            Map<Id,Lead> leadswithPrs = new Map<Id,Lead>([Select Id,Skip_Validation__c,(Select Id,Role__c,Status__c from Partner_Roles__r where Status__c =: Label.Approved and Id not in : approvedProles.keyset()) from Lead where Id in :leadIds]);
            Map<Id,Set<Id>> leadVsprwithSource = new Map<Id,Set<Id>>();
            for(Lead l : leadswithPrs.Values()){
                for(Partner_Role__c pr : l.Partner_Roles__r){
                    if(pr.Role__c == Label.Source){
                        if(!leadVsprwithSource.containsKey(l.Id)){
                            leadVsprwithSource.put(l.Id,new Set<Id>());
                        }                     
                        leadVsprwithSource.get(l.Id).add(pr.Id);
                    }
                    
                }
            }
            for(Partner_Role__c pr : approvedProles.values()){
                if(String.isNotBlank(pr.Lead__c)){
                    /*  if(leadswithPrs.get(pr.Lead__c).Partner_Roles__r.Size() ==2)
pr.addError(Label.Error_Message_on_Approved_Partner_Roles); */ //commented by V Sreeram for SFDC-3279
                    if(pr.Role__c == Label.Source && leadVsprwithSource.containsKey(pr.Lead__c) && leadVsprwithSource.get(pr.Lead__c).size() >= 1)
                        pr.addError(Label.Error_Message_on_one_approved_Source_role);  
                }
                
            }
            
        }
        
        if(oppIds.size() >0 ){
            List<Opportunity> oppsToUpdate = new List<Opportunity>();
            Map<Id,Opportunity> oppswithPrs = new Map<Id,Opportunity>([Select Id,(Select Id,Role__c,Status__c from Partner_Roles__r where Status__c =: Label.Approved and Id not in : approvedProles.keyset()) from Opportunity where Id in :oppIds]);
            
            Map<Id,Set<Id>> oppVsprwithSource = new Map<Id,Set<Id>>();
            for(Opportunity op : oppswithPrs.Values()){
                for(Partner_Role__c pr : op.Partner_Roles__r){
                    if(pr.Role__c == Label.Source){
                        if(!oppVsprwithSource.containsKey(op.Id)){
                            oppVsprwithSource.put(op.Id,new Set<Id>());
                        }                     
                        oppVsprwithSource.get(op.Id).add(pr.Id);
                    }
                }
            }
            for(Partner_Role__c pr : approvedProles.values()){
                if(String.isNotBlank(pr.Opportunity__c)){
                    /*  if(oppswithPrs.get(pr.Opportunity__c).Partner_Roles__r.Size() ==2)
pr.addError(Label.Error_Message_on_Approved_Partner_Roles); */ //commented by V Sreeram for SFDC-3279
                    if(pr.Role__c == Label.Source && oppVsprwithSource.containsKey(pr.Opportunity__c) && oppVsprwithSource.get(pr.Opportunity__c).size() >= 1)
                        pr.addError(Label.Error_Message_on_one_approved_Source_role);  
                    
                    
                }
                
            }
            
        }
    }
    
    public static void updateAfterApprovals(Map<Id,Partner_Role__c> approvedProles){
        
        Set<Id> leadIds = new Set<Id>();
        Set<Id> oppIds = new Set<Id>();
        
        for(Partner_Role__c pr : approvedProles.values()){
            if(String.isNotBlank(pr.Lead__c))
                leadIds.add(pr.Lead__c);  
            if(String.isNotBlank(pr.Opportunity__c))
                oppIds.add(pr.Opportunity__c); 
        }
        
        if(leadIds.size() >0 ){
            List<Lead> leadsToUpdate = new List<Lead>();
            
            Map<Id,Lead> leadswithPrs = new Map<Id,Lead>([Select Id,Skip_Validation__c,(Select Id,Role__c,Status__c from Partner_Roles__r where Status__c =: Label.Approved and Id not in : approvedProles.keyset()) from Lead where Id in :leadIds]);
            Set<Id> leadVsprwithSource = new Set<Id>();
            for(Lead l : leadswithPrs.Values()){
                for(Partner_Role__c pr : l.Partner_Roles__r){
                    if(!leadVsprwithSource.contains(l.Id) && pr.Role__c == Label.Source)
                        leadVsprwithSource.add(l.Id);
                }
            }
            for(Partner_Role__c pr : approvedProles.values()){
                
                if(String.isNotBlank(pr.Lead__c) && leadswithPrs.containsKey(pr.Lead__c)){
                    
                    if(pr.Role__c == Label.Source)
                        leadsToUpdate.add(new Lead(Id=pr.Lead__c,Skip_Validation__c=leadswithPrs.get(pr.Lead__c).Skip_Validation__c ? false : true,Partner_Company__c = pr.Partner_Company__c,Partner_Contact__c = pr.Partner_Contact__c,Commissions_Role__c = pr.Commission_Role__c));
                    // Commented Below lines for SFDC-3963
                    //  else if(!leadVsprwithSource.contains(pr.Lead__c))
                    //     leadsToUpdate.add(new Lead(Id=pr.Lead__c,Skip_Validation__c=leadswithPrs.get(pr.Lead__c).Skip_Validation__c ? false : true,Partner_Company__c = pr.Partner_Company__c));
                }
            }
            if(leadsToUpdate.size() > 0)
                update leadsToUpdate;
        }
        
        
        
        if(oppIds.size() >0 ){
            Map<Id,Opportunity> oppsToUpdate = new Map<Id,Opportunity>();
            Map<Id,Opportunity> oppswithPrs = new Map<Id,Opportunity>([Select Id,Skip_Validation__c,(Select Id,Role__c,Status__c from Partner_Roles__r where Status__c =: Label.Approved and Id not in : approvedProles.keyset()) from Opportunity where Id in :oppIds]);
            
            Set<Id> oppVsprwithSource = new Set<Id>();
            for(Opportunity op : oppswithPrs.Values()){
                for(Partner_Role__c pr : op.Partner_Roles__r){
                    if(!oppVsprwithSource.contains(op.Id) && pr.Role__c == Label.Source)
                        oppVsprwithSource.add(op.Id);
                }
            }
            //Added By:Vinod Thupakula
            //SFDC-2043 >>>>start>>>>
            Set<Id> partnerCompanyIds= new Set<Id>();
            for(Partner_Role__c pRoles : approvedProles.values()){
                if(String.isNotBlank(pRoles.Partner_Company__c)) 
                    partnerCompanyIds.add(pRoles.Partner_Company__c);
            }              
            Map<Id,Account> companies;           
            if(partnerCompanyIds.size()>0){
                companies = new Map<Id,Account>([SELECT Id,OwnerId,Contract_Type__c FROM Account WHERE Id IN:partnerCompanyIds]);
            }            
            for(Partner_Role__c pr : approvedProles.values()){               
                String ownerId = null;
                String PartnerContractType = null;
                if(String.isNotBlank(pr.Opportunity__c) && oppswithPrs.containsKey(pr.Opportunity__c)){                    
                    if(companies != null && companies.get(pr.Partner_Company__c) != null){
                        ownerId = companies.get(pr.Partner_Company__c).OwnerId;
                        //Added for SFDC-4054
                        PartnerContractType = companies.get(pr.Partner_Company__c).Contract_Type__c;
                        
                        
                    }                  
                    //partner company and partner contract type added to opp for SFDC-4054
                    if(pr.Role__c == Label.Source)                            
                        oppsToUpdate.put(pr.Opportunity__c,new Opportunity(Id=pr.Opportunity__c,Partner_Company_Owner__c=ownerId,Skip_Validation__c=oppswithPrs.get(pr.Opportunity__c).Skip_Validation__c ? false : true,Partner_Company__c = pr.Partner_Company__c,Partner_Contact__c = pr.Partner_Contact__c,Partner_Contract_Type__c = PartnerContractType,Commission_Role__c = pr.Commission_Role__c));
                    // Commented Below line for SFDC-3963  
                    //   else if(!oppVsprwithSource.contains(pr.Opportunity__c))
                    //      oppsToUpdate.put(pr.Opportunity__c,new Opportunity(Id=pr.Opportunity__c,Skip_Validation__c=oppswithPrs.get(pr.Opportunity__c).Skip_Validation__c ? false : true,Partner_Company__c = pr.Partner_Company__c));
                    
                }
                
            }
            //SFDC-2043 >>>>End>>>>
            
            if(oppsToUpdate.size() > 0)
                OpportunityHandler.Is_Source =false;
            update oppsToUpdate.values();
            OpportunityHandler.Is_Source =true; 
        }
    }
    //Added by Thirupathi Aeneni to share Approved Partner Role-Leads/Opps-starts
    Public static void ShareApprovedPRoleLeadsOrOpps(Map<ID,List<ID>> PComIdsVsLeadOrOppIds,String type) {
        List<LeadShare> leadshares = new List<LeadShare>();
        List<OpportunityTeamMember> oppTeams = new List<OpportunityTeamMember>();
        List<AccountTeamMember> accTeams = new List<AccountTeamMember>();
        Map<Id,Account> partnerCompanies = new Map<Id,Account>();
        Set<Id> accountIds = new Set<Id>();
        Set<Id> opptyIds = new Set<Id>();
        
        Map<Id,Account> companies = new Map<Id,Account>([Select Id,ParentId,Parent.ParentId,Parent.Parent.Partner_Level__c,Parent.Partner_Level__c,Partner_Level__c from Account where id in : PComIdsVsLeadOrOppIds.keySet() ]);
        for(Account a : companies.values()){
            accountIds.add(a.Id);
            if(String.isNotBlank(a.ParentId))
                accountIds.add(a.ParentId);  
            if(String.isNotBlank(a.parent.ParentId))
                accountIds.add(a.parent.ParentId);
        }
        partnerCompanies = new Map<Id,Account>([Select Id,ParentId,Parent.ParentId,Parent.Parent.Partner_Level__c,Parent.Partner_Level__c,Partner_Level__c from Account where id in : accountIds ]);
        
        
        Map<Id,Set<Id>> accVsUserIds = new Map<Id,Set<Id>>();
        
        for(User u : [Select id,AccountId from User where accountId in : accountIds and isActive = true]){
            
            if(!accVsUserIds.containsKey(u.AccountId))
                accVsUserIds.put(u.AccountId, new Set<Id>());
            Set<Id> users = accVsUserIds.get(u.AccountId);
            users.add(u.Id);
            accVsUserIds.put(u.AccountId, users);
            
        }
        if(type == Label.Lead){
            for(Id pcompId : PComIdsVsLeadOrOppIds.keySet()){
                if(partnerCompanies.get(pcompId) != null){
                    Account company = partnerCompanies.get(pcompId);
                    Id companyId = company.Id;
                    for(Id leadId1 : PComIdsVsLeadOrOppIds.get(pcompId)){
                        if(companyId != null && accVsUserIds.containsKey(companyId)){
                            for(Id userId : accVsUserIds.get(companyId)){
                                leadshares.add(new LeadShare(leadId = leadId1,userOrGroupId = userId,leadAccessLevel= Label.Read));
                            }}
                        if(company.ParentId != null && partnerCompanies.containsKey(company.ParentId) && accVsUserIds.containsKey(company.ParentId)){
                            for(Id userId : accVsUserIds.get(company.ParentId))
                                leadshares.add(new LeadShare(leadId = leadId1,userOrGroupId = userId,leadAccessLevel= Label.Read));
                        }
                        
                        if(company.Parent.ParentId != null && partnerCompanies.containsKey(company.Parent.ParentId) && accVsUserIds.containsKey(company.Parent.ParentId)){
                            for(Id userId : accVsUserIds.get(company.Parent.ParentId))
                                leadshares.add(new LeadShare(leadId = leadId1,userOrGroupId = userId,leadAccessLevel= Label.Read));
                        }
                    }
                }
            }
        }
        
        if(type == Label.Opportunity){
            
            // Added by Anjaneyulu for SFDC-2116 -- Starts
            for(Id i : PComIdsVsLeadOrOppIds.keySet())
                opptyIds.addAll(PComIdsVsLeadOrOppIds.get(i));
            List<Account> companiesToShare = new List<Account>();
            Map<Id,Opportunity> opptys = new Map<Id,Opportunity>([Select AccountId,Partner_Company__c from Opportunity where Id in : opptyIds]);
            
            // Added by Anjaneyulu for SFDC-2116 -- Ends
            for(Id pcompId : PComIdsVsLeadOrOppIds.keySet()){
                Account company = partnerCompanies.get(pcompId);
                Id companyId = company.Id;
                for(Id oppId : PComIdsVsLeadOrOppIds.get(pcompId)){
                    if(companyId != null && accVsUserIds.containsKey(companyId)){
                        for(Id userId : accVsUserIds.get(companyId)){
                            oppTeams.add(new OpportunityTeamMember(OpportunityId = oppId,UserId = userId,OpportunityAccessLevel= Label.Edit,TeamMemberRole = Label.Partner_User));
                            accTeams.add(new AccountTeamMember(AccountId = opptys.get(oppId).AccountId,AccountAccessLevel='Edit',ContactAccessLevel='Edit',OpportunityAccessLevel='None', TeamMemberRole = Label.Partner_User_Role, UserId= userId));
                            
                        }}
                    if(company.ParentId != null && partnerCompanies.containsKey(company.ParentId) && accVsUserIds.containsKey(company.ParentId)){
                        for(Id userId : accVsUserIds.get(company.ParentId)){
                            oppTeams.add(new OpportunityTeamMember(OpportunityId = oppId,UserId = userId,OpportunityAccessLevel= Label.Edit,TeamMemberRole = Label.Master_Agent));
                            accTeams.add(new AccountTeamMember(AccountId = opptys.get(oppId).AccountId,AccountAccessLevel='Edit',ContactAccessLevel='Edit',OpportunityAccessLevel='None', TeamMemberRole = Label.Partner_Master_Agent_Role, UserId= userId));
                        }
                        
                    }
                    
                    if(company.Parent.ParentId != null && partnerCompanies.containsKey(company.Parent.ParentId) && accVsUserIds.containsKey(company.Parent.ParentId)){
                        for(Id userId : accVsUserIds.get(company.Parent.ParentId)){
                            oppTeams.add(new OpportunityTeamMember(OpportunityId = oppId,UserId = userId,OpportunityAccessLevel= Label.Edit,TeamMemberRole = Label.Master_Agent));
                            accTeams.add(new AccountTeamMember(AccountId = opptys.get(oppId).AccountId,AccountAccessLevel='Edit',ContactAccessLevel='Edit',OpportunityAccessLevel='None', TeamMemberRole = Label.Partner_Master_Agent_Role, UserId= userId));
                        }
                    }
                }
            }
            
            
        }
        
        if(oppTeams.size() > 0)
            // insert oppTeams;
            Database.insert(oppTeams, false);
        if(leadshares.size() > 0)
            // insert leadshares;
            Database.insert(leadshares, false);
        if(accTeams.size() > 0)
            Database.insert(accTeams, false);
    } //Added by Thirupathi Aeneni to share Approved Partner Role-Leads/Opps-Ends
    
    
    //start--> story -5631
    //on changing role of Partner ROle, change the same in Opp Team Member
    ////SFDC-6007 updated OppTeamMemberRole to Read-Only
    public static void updateOppTeamMember(List<Partner_Role__c> prList){
        List<OpportunityTeamMember> oppTeams = new List<OpportunityTeamMember>();
        Map<String, String> roleMp = new Map<String, String>();
        //Map<id,Opportunity> oppwithstage=new Map<id,Opportunity>();
        //Set<id> oppslst=new set<id>();
        Map<Id, Partner_Role__c> roleMpopp = new Map<Id, Partner_Role__c>();
        Map<Id, Partner_Role__c> prMapOld ;
        if(trigger.isupdate){
            prMapOld = (Map<Id, Partner_Role__c>)Trigger.oldMap;
        }
        // Set<Id> partnerCompanyIds= new Set<Id>();
        // Map<Id,Account> pcompanies =new Map<Id,Account>(); 
        
        for(Partner_Role__c pr : prList){
            
            if(trigger.isinsert){
                // system.debug('oppstage'+oppwithstage.get(pr.Opportunity__c).isclosed+oppwithstage.get(pr.Opportunity__c).stagename);
                if((pr.Role__c == 'Source' || pr.Role__c == 'National PAM') && String.isNotBlank(pr.Partner_Company__c) && 
                   String.isNotBlank(pr.Opportunity__c) && !pr.Opportunity__r.isclosed && pr.Partner_Company__r.OwnerId!=null 
                   //Start SFDC-6315
                   && !(pr.Opportunity__r.Owner_Role__c.contains('Service Delivery'))  && pr.Opportunity__r.Category__c != 'Renewal' && pr.Opportunity__r.Type != 'Renewal'){
                    
                    //   System.debug('service delivery');
                       oppTeams.add(new OpportunityTeamMember(OpportunityId = pr.Opportunity__c,UserId = pr.Partner_Company__r.OwnerId,
                                                              OpportunityAccessLevel= 'Read',TeamMemberRole = pr.Role__c));
                       
                   }
            }
            if(trigger.isupdate){
                Partner_Role__c prOld = prMapOld.get(pr.Id);
                //  if(pr.Role__c != prOld.Role__c && (prOld.Role__c == 'Source' || prOld.Role__c == 'National PAM') &&
                //  (pr.Role__c == 'Source' || pr.Role__c == 'National PAM')){
                if((pr.Role__c != prOld.Role__c) && (prOld.Role__c == 'Source' || prOld.Role__c == 'National PAM') && (pr.Role__c == 'Source' || pr.Role__c == 'National PAM') 
                   && String.isNotBlank(pr.Partner_Company__c) && String.isNotBlank(pr.Opportunity__c) && !pr.Opportunity__r.isclosed
                  //Start SFDC-6315
                 && !(pr.Opportunity__r.Owner_Role__c.contains('Service Delivery'))  && pr.Opportunity__r.Category__c != 'Renewal' && pr.Opportunity__r.Type != 'Renewal' ){
                      // system.debug('insidee'+pr.Opportunity__r.Owner_Role__c);
                       //end SFDC-6315
                       roleMp.put(pr.Opportunity__c+'~'+pr.Partner_Company__r.OwnerId, pr.Role__c);
                       roleMpopp.put(pr.Opportunity__c, pr); 
                       
                   }
                if((pr.Partner_Company__c != prOld.Partner_Company__c || pr.Opportunity__c != prOld.Opportunity__c) && (prOld.Role__c == 'Source' || prOld.Role__c == 'National PAM') && 
                   (pr.Role__c == 'Source' || pr.Role__c == 'National PAM') 
                   && String.isNotBlank(pr.Partner_Company__c) && String.isNotBlank(pr.Opportunity__c) && !pr.Opportunity__r.isclosed 
                   //Start SFDC-6315
                   && !(pr.Opportunity__r.Owner_Role__c.contains('Service Delivery'))  && pr.Opportunity__r.Category__c != 'Renewal' && pr.Opportunity__r.Type != 'Renewal' ){
                      // system.debug('insidee'+pr.Opportunity__r.owner.UserRole.Name);
                       //end SFDC-6315
                       oppTeams.add(new OpportunityTeamMember(OpportunityId = pr.Opportunity__c,UserId = pr.Partner_Company__r.OwnerId,
                                                              OpportunityAccessLevel= 'Read',TeamMemberRole = pr.Role__c));
                   }
            }
            
        }
        if(roleMp.size() > 0){
            List<OpportunityTeamMember> oppTMLSt = [SELECT Id, TeamMemberRole,OpportunityId,UserId from OpportunityTeamMember
                                                    where OpportunityId IN : roleMpopp.keySet() and TeamMemberRole IN : new List<String>{'Source', 'National PAM'}];
            for(OpportunityTeamMember otm :oppTMLSt ){
                if(roleMp.containskey(otm.OpportunityId+'~'+otm.UserId))
                    otm.TeamMemberRole = roleMp.get(otm.OpportunityId+'~'+otm.UserId);
            }
            update oppTMLSt;
        }
        if(oppTeams.size()>0){
            insert oppTeams;
        }
    }
    // when partner role deleted automatically coresponding Team member also deleted  
    public static void deleteOppTeamMembers(List<Partner_Role__c> prList){
        Set<Id> partnerCompanyIds= new Set<Id>();
        Map<Id,Account> pcompanies; 
        for(Partner_Role__c pRoles : prList){
            if(String.isNotBlank(pRoles.Partner_Company__c)) 
                partnerCompanyIds.add(pRoles.Partner_Company__c);
        } 
        if(partnerCompanyIds.size()>0){
            pcompanies = new Map<Id,Account>([SELECT Id,OwnerId,Contract_Type__c FROM Account WHERE Id IN:partnerCompanyIds]);
        } 
        
        Set<Id> oppIdSet = new Set<Id>();
        Set<String> ownerIdSet = new Set<String>();
        //Set<String> roleset = new Set<String>();
        for(Partner_Role__c pr : prList){
            system.debug('partner company owner'+pr.partner_company__r.ownerid);
            if(pr.Role__c == 'Source' || pr.Role__c == 'National PAM'){
                oppIdSet.add(pr.Opportunity__c);
                ownerIdSet.add(pcompanies.get(pr.Partner_Company__c).OwnerId);
                //roleset.add(pr.Role__c);
            }
        }
        /*       Map<Id,opportunity> oppwithstage;
if(!oppIdSet.isEmpty()){
oppwithstage=new Map<Id,opportunity>([select id,isclosed,stagename from opportunity where id IN:oppIdSet]);
}*/
        List<OpportunityTeamMember> oppTMLSt = new List<OpportunityTeamMember>();
        //[SELECT Id, TeamMemberRole,OpportunityId from OpportunityTeamMember
        //                                      where OpportunityId IN : oppIdSet AND UserId IN : ownerIdSet];
        /* for(OpportunityTeamMember optm : [SELECT Id, TeamMemberRole,OpportunityId from OpportunityTeamMember
where OpportunityId IN : oppIdSet AND UserId IN : ownerIdSet]){
if(!oppwithstage.get(optm.OpportunityId).isclosed){ */
        //SFDC-6007 Updated the Query to exclude Cloud contract types of DCR
        List<String> DcrCCtypes = System.Label.DCR_CC_Types.Split(',');
        for(OpportunityTeamMember optm : [SELECT Id, TeamMemberRole,OpportunityId,Opportunity.isclosed,Opportunity.Cloud_Contract_Type__c from OpportunityTeamMember
                                          where OpportunityId IN : oppIdSet AND UserId IN : ownerIdSet  AND (Opportunity.Cloud_Contract_Type__c NOT IN: DcrCCtypes)]){
                                              if(!optm.Opportunity.isclosed){
                                                  oppTMLSt.add(optm);
                                              }
                                          }
        //system.debug('team delte++'+oppTMLSt);
        //system.debug('oppty id '+oppIdSet);
        //system.debug('owner ids '+ownerIdSet);
        delete oppTMLSt; 
    }
    //when new partner company  owner added automatically coresponding  old Team member deleted
    public static void deleteOldOwnerOppTeamMembers(List<Partner_Role__c> prList, Map<Id, Partner_Role__c> prMapOld){
        List<Partner_Role__c> deleteList = new List<Partner_Role__c>();
        for(Partner_Role__c pr : prList){
            //system.debug('old owner'+prMapOld.get(pr.Id).Partner_Company__r.ownerid);
            if(pr.Partner_Company__c != prMapOld.get(pr.Id).Partner_Company__c){
                deleteList.add(prMapOld.get(pr.Id));
            }
        }
        deleteOppTeamMembers(deleteList);  
    }
    //end story --->5631
    
}