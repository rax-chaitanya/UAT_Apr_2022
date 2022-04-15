/**********************************************************************************

#Author: Padmaja Gadepalli
#Description: This apex class is created to update contracting entity based on quoting system on Opp.
# Change Log:  moved the method from OpportunityTriggerHelper.updateAccountContractingentity() to OpportunityTriggercontractentityupdate to implement without sharing class 

**********************************************************************************/
public without sharing class OpportunityTriggercontractentityupdate {
    public static Boolean executeSecond = false;
    
  
    public static void updateAccountContractingentity(List<Opportunity> newOpportunities, Map<ID,Opportunity> oldOpportunities){
        List<Account> accounts = new List<Account>(); 
        Map<String,Id> mapConEntities = new Map<String,Id>();
        String territory;
        Map<Id,String> accountIds = new Map<Id,String>();
        for(Opportunity newOpportunity : newOpportunities){           
            if(!accountIds.containsKey(newOpportunity.Account__c) && String.isNotBlank(newOpportunity.Account__c) 
               && String.isNotBlank(newOpportunity.QuotingSystem__c) &&(Trigger.isinsert || 
                                                                        (Trigger.isUpdate && (newOpportunity.QuotingSystem__c != oldOpportunities.get(newOpportunity.Id).QuotingSystem__c || newOpportunity.Account__c!= oldOpportunities.get(newOpportunity.Id).Account__c))))
            {
                accountIds.put(newOpportunity.Account__c,newOpportunity.QuotingSystem__c);
                 system.debug('accountids:.....'+accountids);
            }                    
        }
        
        if(accountIds.size() > 0){
            for (Contracting_Entity__c con : [select Id, Name, territory__c, Country__c from Contracting_Entity__c])
            {
                if(String.isNotBlank(con.territory__c)) {
                    mapConEntities.put(con.territory__c, con.Id);
                     System.debug('mapConEntities'+mapConEntities);
                }          
            }
        }
        
        
        if(accountIds.size() > 0){
            for(Account accRecord : [Select Id, Notifiedsystems__C,territory__c, Contracting_Entity__c FROM Account WHERE Id IN:accountIds.keySet() ]){ 
                
              /*  if(accountIds.get(accRecord.Id) != null && (accrecord.contracting_entity__C!=label.TriCore_CE || accrecord.contracting_entity__C == null)) */
             //SFDC-2260 - Added condition to check if contracting entity in record is null
                System.debug('accrecord.contracting_entity__C == null'+accrecord.contracting_entity__C);
             
                if(accountIds.get(accRecord.Id) != null && accrecord.contracting_entity__C == null)

                {
                        System.debug('Label.DPAccountNotifiedSystem'+Label.DPAccountNotifiedSystem);
                    //  territory =accrecord.territory__C;
                    if(accountIds.get(accRecord.Id).contains(Label.DPAccountNotifiedSystem )){
                        System.debug('Label.DPAccountNotifiedSystem'+Label.DPAccountNotifiedSystem);
                        accRecord.Notifiedsystems__C = accountIds.get(accRecord.Id); 
                        accrecord.Contracting_Entity__c= Label.ContractingEntitiesToSkip;
                        accounts.add(accRecord); 
                    }
                    System.debug('Label.DPAccountNotifiedSystem'+Label.DPAccountNotifiedSystem);
                    if(!(accountIds.get(accRecord.Id).contains(Label.DPAccountNotifiedSystem))){
                         System.debug('Label.DPAccountNotifiedSystem'+Label.DPAccountNotifiedSystem);
                        territory = accrecord.territory__C;
                        accRecord.Notifiedsystems__C = accountIds.get(accRecord.Id);
                        // accrecord.Contracting_Entity__c= mapConEntities.get(territory);
                        if(mapConEntities.containsKey(territory)) accrecord.Contracting_Entity__c= mapConEntities.get(territory);
                        else
                            accrecord.Contracting_Entity__c= mapConEntities.get('International');
                        accounts.add(accRecord); 
                    }
                    system.debug('accounts:'+accounts);
                }
                
                /* if(accountIds.get(accRecord.Id) != null && !(accountIds.get(accRecord.Id).contains(Label.DPAccountNotifiedSystem)) && (accrecord.contracting_entity__C!=label.TriCore_CE || accrecord.contracting_entity__C == null))
{
territory = accrecord.territory__C;
accRecord.Notifiedsystems__C = accountIds.get(accRecord.Id);
// accrecord.Contracting_Entity__c= mapConEntities.get(territory);
if(mapConEntities.containsKey(territory)) accrecord.Contracting_Entity__c= mapConEntities.get(territory);
else
accrecord.Contracting_Entity__c= mapConEntities.get('International');
accounts.add(accRecord); 
//   system.debug('accounts:'+accounts);
}*/
                
            }
            if(!accounts.isEmpty())
            update accounts;
            
        }
    }
    //sfdc--padmaja  
    
    
}