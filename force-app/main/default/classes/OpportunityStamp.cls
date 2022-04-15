public class OpportunityStamp {
    //STGET-329 (Auto Populate Primary Contact on Company to the Opportunity being created)
    public static void stampPrimaryContact() {
        Set<Id> companyIDs = new Set<ID>();
        for (Opportunity opp : (List<Opportunity>) Trigger.new) {
            if (String.isNotBlank(opp.AccountId) && String.isBlank(opp.Primary_Contact__c) ) {
                companyIDs.add(opp.AccountId);
            }
        }
        
        if (companyIds.size() > 0) { 
            Map<Id, AccountContactRole> acrMap = new Map<Id, AccountContactRole>();
            for (AccountContactRole acr : [Select AccountID, ContactId from AccountContactRole where IsPrimary = true and AccountId in :companyIds ]) {
                                               acrMap.put(acr.AccountId, acr);
                                           }
            if (acrMap.size() > 0) {
                for (Opportunity opp : (List<Opportunity>) Trigger.new) {
                    System.debug('opp.accountId: ' + opp.accountId);
                    if (String.isNotBlank(opp.AccountId) && acrMap.containsKey(opp.AccountId)) {
                        opp.Primary_Contact__c = acrMap.get(opp.AccountId).ContactId;
                    }
                }
            }
        }
    }
}