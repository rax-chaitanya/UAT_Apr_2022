global class CascadeTeamMemberBatch implements Database.Stateful, Database.Batchable<sObject>{
    
    Map<Id,List<AccountTeamMember>> CompanyToTeamMembersLookup = new Map<Id,List<AccountTeamMember>>();
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        ID UserID = UserInfo.getUserId();
        String query = 'Select Id,(Select Id, AccountId, UserId, TeamMemberRole, AccountAccessLevel from AccountTeamMembers where LastModifiedDate = TODAY AND HOUR_IN_DAY(LastModifiedDate) > 1) from Account where ID in(Select AccountId from AccountTeamMember where LastModifiedDate = TODAY AND HOUR_IN_DAY(LastModifiedDate) > 1) AND CreatedByID != :userID';
        
        if (Test.isRunningTest()) {
        query += ' LIMIT 10';
        }
        System.debug('Query: ' + query);
        return Database.getqueryLocator(query);
    }
    
    
    public List<AccountTeamMember> continueFunc(Set<Id> parent_ids) {
        List<AccountTeamMember> toInsert = new List<AccountTeamMember>();
        Set<ID> root_ids = new Set<ID>();
        root_ids = parent_ids;
        
        while (root_ids.size() > 0) {
            Set<ID> temp = new Set<ID>();
            Map<Id, List<AccountTeamMember>> tempMap = new Map<ID, List<AccountTeamMember>>();

            for (Account a : CompanyHierarchy.getCompanyMap(root_ids).values()) {
                
                
                if(CompanyToTeamMembersLookup.get(a.ParentId) != null)
                {
                    toInsert.addAll(createCompanyToTeamMembers(a.id, CompanyToTeamMembersLookup.get(a.ParentId)));
                }
                else if(CompanyToTeamMembersLookup.get(a.Parent.ParentId) != null)
                {
                    toInsert.addAll(createCompanyToTeamMembers(a.id, CompanyToTeamMembersLookup.get(a.Parent.ParentId)));
                }      
                else if(CompanyToTeamMembersLookup.get(a.Parent.Parent.ParentId) != null) {
                    toInsert.addAll(createCompanyToTeamMembers(a.id, CompanyToTeamMembersLookup.get(a.Parent.Parent.ParentId)));
                }
                else if(CompanyToTeamMembersLookup.get(a.Parent.Parent.Parent.ParentId) != null) {
                    toInsert.addAll(createCompanyToTeamMembers(a.id, CompanyToTeamMembersLookup.get(a.Parent.Parent.Parent.ParentId)));
                }
                else if(CompanyToTeamMembersLookup.get(a.Parent.Parent.Parent.Parent.ParentId) != null) {
                    toInsert.addAll(createCompanyToTeamMembers(a.id, CompanyToTeamMembersLookup.get(a.Parent.Parent.Parent.Parent.ParentId)));
                }
                else if(CompanyToTeamMembersLookup.get(a.Parent.Parent.Parent.Parent.Parent.ParentId) != null)
                {
                    List<AccountTeamMember> members = (createCompanyToTeamMembers(a.id, CompanyToTeamMembersLookup.get(a.Parent.Parent.Parent.Parent.Parent.ParentId)));
                    tempMap.put(a.id, members);
                    toInsert.addAll(members);
                    temp.add(a.Id);
                }
            }
            root_ids = temp;
            CompanyToTeamMembersLookup = tempMap;
        }
        return toInsert;
    }
    
    public List<AccountTeamMember> createCompanyToTeamMembers(Id companyID, List<AccountTeamMember> companyTeamMembers) {
        System.debug('createCompanyToTeamMembers.company id: ' + companyID);
        System.debug('createCompanyToTeamMembers.company team members: ' + companyTeamMembers);
        
        List<AccountTeamMember> toAdd = new List<AccountTeamMember>();
        for (AccountTeamMember ctm : companyTeamMembers) {
            AccountTeamMember atm = new AccountTeamMember();

            atm = ctm.clone(false, true, false, false);
            atm.AccountId = companyId;
            atm.TeamMemberRole = ctm.TeamMemberRole;
            toAdd.add(atm);
        }
        return toAdd;
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        
        for(Account a:(List<Account>)scope)
        {
            //if the child records size is > 200 SFDC throws an exception. So, loop for all size
            CompanyToTeamMembersLookup.put(a.Id,a.AccountTeamMembers);
            
        }
        
        Map<Id,List<Id>> childAccounts = new Map<Id,List<Id>>();
        
        List<AccountTeammember> toInsert = new List<AccountTeammember>();
        
        //Get the child companies to which the new TMs must be added
        toInsert = continueFunc(CompanyToTeamMembersLookup.keySet());
        
        Boolean isSuccess;
        try {
            insert toInsert;
        } catch (Exception e) {
    
               FeedItem post = new FeedItem();
                post.ParentId =  (String) OrgConstants__c.getInstance('Salesforce Errors Group').Prod_Value__c;
                post.Body = ExceptionHandler.getBody(e);
                insert post;

        }
        
    }
    global void finish(Database.BatchableContext BC) {
    }
}