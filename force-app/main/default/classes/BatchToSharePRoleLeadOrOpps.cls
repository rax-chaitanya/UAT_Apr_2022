global class BatchToSharePRoleLeadOrOpps implements Database.Batchable<sObject>,Schedulable{
    global Database.QueryLocator start(Database.BatchableContext ctx) {
        return Database.getQueryLocator('Select Id,Partner_Company__c,Status__c,Opportunity__c,Lead__c,Opportunity__r.Partner_Company__c,Lead__r.Partner_Company__c From Partner_Role__c Where (Status__c=\'Approved\' and Partner_Company__c != null) AND (Lead__c != null OR Opportunity__c != null)');
    }
    global void execute(Database.BatchableContext ctx, list<Partner_Role__c> lstsPROles) {
        
        Map<ID,List<ID>> PCompanyIdVsLeads=new Map<Id,List<ID>>();
        Map<ID,List<Id>> PCompanyIdVsOppIds=new Map<ID,List<ID>>();
        for(Partner_Role__c pRole:lstsPROles){
            if(String.isNotBlank(pRole.Lead__c)){
                if(!PCompanyIdVsLeads.containsKey(pRole.Partner_Company__c))
                    PCompanyIdVsLeads.put(pRole.Partner_Company__c,new List<Id>());
                List<Id> ids = PCompanyIdVsLeads.get(pRole.Partner_Company__c);
                ids.add(pRole.Lead__c);
                PCompanyIdVsLeads.put(pRole.Partner_Company__c,ids);
            }
            if(String.isNotBlank(pRole.Opportunity__c)){
                if(!PCompanyIdVsOppIds.containsKey(pRole.Partner_Company__c))
                    PCompanyIdVsOppIds.put(pRole.Partner_Company__c,new List<Id>());
                List<Id> ids = PCompanyIdVsOppIds.get(pRole.Partner_Company__c);
                ids.add(pRole.Opportunity__c);
                PCompanyIdVsOppIds.put(pRole.Partner_Company__c,ids); 
            }
        }
        if(PCompanyIdVsLeads.size()>0) 
            PartnerRoleTriggerHelper1.ShareApprovedPRoleLeadsOrOpps(PCompanyIdVsLeads,'Lead');
        if(PCompanyIdVsOppIds.size()>0)
            PartnerRoleTriggerHelper1.ShareApprovedPRoleLeadsOrOpps(PCompanyIdVsOppIds,'Opportunity');
    }
    global void finish(Database.BatchableContext ctx) {
        
    }
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new BatchToSharePRoleLeadOrOpps(), 150);
    }
    
}