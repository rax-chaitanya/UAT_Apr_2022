global class PartnerCompaniesShare Implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('Select Id,AccountId,Partner_Company__c from Opportunity where Partner_Company__c != null Order by Partner_Company__c');
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> optys){
        
        Map<Id,Set<Id>> pcomIdvsCompids = new Map<Id,Set<Id>>();
         List<AccountTeamMember> accTeams = new List<AccountTeamMember>();
        
        for(Opportunity op : optys){
            if(!pcomIdvsCompids.containsKey(op.Partner_Company__c))
                pcomIdvsCompids.put(op.Partner_Company__c, new Set<Id>());
            Set<Id> comIds = pcomIdvsCompids.get(op.Partner_Company__c);
            comIds.add(op.AccountId);
            pcomIdvsCompids.put(op.Partner_Company__c,comIds);
        }    
            Map<Id,Set<Id>> partnerCompVsUserIds = new Map<Id,Set<Id>>();
            for(User u : [Select Id,AccountId from User where isActive = true and AccountId in : pcomIdvsCompids.keySet()]){
               if(!partnerCompVsUserIds.containsKey(u.AccountId))
                   partnerCompVsUserIds.put(u.AccountId, new Set<Id>());
            Set<Id> userIds = partnerCompVsUserIds.get(u.AccountId);
            userIds.add(u.Id);
            partnerCompVsUserIds.put(u.AccountId,userIds);
          }
           
        for(Id pcomId : pcomIdvsCompids.keySet()){
            if(partnerCompVsUserIds != null && partnerCompVsUserIds.ContainsKey(pcomId)){
                for(Id userId : partnerCompVsUserIds.get(pcomId)){
             for(Id compid : pcomIdvsCompids.get(pcomId)){
                accTeams.add(new AccountTeamMember(AccountId = compid,AccountAccessLevel='Read',ContactAccessLevel='Read',OpportunityAccessLevel='None', TeamMemberRole = 'Partner User', UserId= userId));
            }
       
                }
            }
            
            if(accTeams != null && accTeams.size() > 0 && !Test.isRunningTest())
                upsert accTeams;
                    }
        
        
    }
    global void finish(Database.BatchableContext bc){
        
    }
}