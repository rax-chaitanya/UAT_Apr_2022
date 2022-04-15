global class PartnerLeadSharingRecalculation implements Database.Batchable<sobject>{

    global Database.QueryLocator start(Database.BatchableContext bc){
        
        return Database.getQueryLocator('Select Id,Partner_Company__c from Lead where Partner_Company__c != null and isConverted = false');
    }
    
    global void execute(Database.BatchableContext BC, List<Lead> partnerLeads){

        List<sObject> shares = new List<sObject>();
        Set<Id> accountIds = new Set<Id>();
        Set<Id> companyIds = new Set<Id>();
        for(Lead obj : partnerLeads){
          accountIds.add(obj.Partner_Company__c);
          }
        Map<Id,Account> companiesToShare = new Map<Id,Account>([Select Id,ParentId,Parent.ParentId,Partner_Company__c from Account where id in :accountIds]);
       
            for(Account a : [Select Id,ParentId,Parent.ParentId,Partner_Company__c from Account where id in : accountIds and Partner_Account_Status__c = 'Approved']){
                if(String.isNotBlank(a.ParentId))
                accountIds.add(a.ParentId);
                if(String.isNotBlank(a.Parent.ParentId))
                accountIds.add(a.Parent.ParentId);
            
        }
        Map<Id,Account> companies = new Map<Id,Account>([Select Id,ParentId,Parent.ParentId,Parent.Parent.Partner_Level__c,Parent.Partner_Level__c,Partner_Level__c from Account where id in : accountIds and Partner_Account_Status__c = 'Approved']);
        
        Map<Id,Set<Id>> accVsUserIds = new Map<Id,Set<Id>>();
        
        for(User u : [Select id,AccountId from User where accountId in : companies.keySet() and isActive = true and contact.Inactive__c = false]){
            
            if(!accVsUserIds.containsKey(u.AccountId))
                accVsUserIds.put(u.AccountId, new Set<Id>());
            Set<Id> users = accVsUserIds.get(u.AccountId);
            users.add(u.Id);
            accVsUserIds.put(u.AccountId, users);
            
        }
        
        for(Lead obj : partnerLeads){
          
            
                Id companyId = obj.Partner_Company__c;
                
                Account company = companies.get(companyId);
                if(company != null){
               if(companyId != null && accVsUserIds.containsKey(companyId) && accVsUserIds.containsKey(companyId)){
                for(Id userId : accVsUserIds.get(companyId)){
                    shares.add(new LeadShare(leadId = obj.id,userOrGroupId = userId,leadAccessLevel='Read'));
                }}
               
                if(company.ParentId != null && companies.containsKey(company.ParentId) && accVsUserIds.containsKey(company.ParentId)){
                    for(Id userId : accVsUserIds.get(company.ParentId))
                        shares.add(new LeadShare(leadId = obj.id,userOrGroupId = userId,leadAccessLevel='Read'));
                }
                // Grand Parent sharing
                if(company.Parent.ParentId != null && companies.containsKey(company.Parent.ParentId) && accVsUserIds.containsKey(company.Parent.ParentId)){
                    for(Id userId : accVsUserIds.get(company.Parent.ParentId))
                        shares.add(new LeadShare(leadId = obj.id,userOrGroupId = userId,leadAccessLevel='Read'));
                }
                }
            
        }            
         
        if(!shares.isEmpty())
            insert shares;
    } 
    global void finish(Database.BatchableContext BC) {
    }
}