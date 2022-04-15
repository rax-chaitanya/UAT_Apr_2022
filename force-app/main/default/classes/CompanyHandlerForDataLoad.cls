public class CompanyHandlerForDataLoad implements TriggerInterface{
public static boolean firstTgrRun = true;

public Boolean isActive(){   
    if(Trigger_Manager__c.getAll().containsKey('AccountDataloadTgr')) {
        return Trigger_Manager__c.getInstance('AccountDataloadTgr').Is_Active__c;
    }
    return false;
}

public static void AddCompanyTeamMember(List<Account> CMPACCList){
    List<AccountTeamMember> teamList = new List<AccountTeamMember>();   
    Map<Id,List<Id>> CMPAccids = new Map<Id,List<Id>>();
    //system.debug('CMPACCList..........'+CMPACCList);

     if(trigger.isInsert){
             for(Account ac : CMPACCList){
           
            if(!CMPAccids.containsKey(ac.Company_Name__c)){
                CMPAccids.put(ac.Company_Name__c,new List<Id>{});
            }if(CMPAccids.containsKey(ac.Company_Name__c)){
                CMPAccids.get(ac.Company_Name__c).add(ac.Id);
            }
            
         }
      

    //Added to copy company tem members to the product account team  list start
    if(CMPAccids != null && CMPAccids.size() > 0){        
        for(AccountTeamMember ATM: [SELECT id,AccountId,UserId,AccountAccessLevel,TeamMemberRole,CaseAccessLevel,ContactAccessLevel,OpportunityAccessLevel from AccountTeamMember WHERE AccountId IN : CMPAccids.keySet() AND User.isActive = true]){            
            if(ATM != null && CMPAccids.containsKey(ATM.AccountId)){
               // System.debug('ATMownerIDIN::' + ATM.userid);          
                for(Id acId : CMPAccids.get(ATM.AccountId)){
                    teamList.add(new AccountTeamMember(AccountId = acId,UserId=ATM.UserId,
                                                       AccountAccessLevel=ATM.AccountAccessLevel,TeamMemberRole=ATM.TeamMemberRole,
                                                       CaseAccessLevel=ATM.CaseAccessLevel,
                                                       ContactAccessLevel=ATM.ContactAccessLevel,
                                                       OpportunityAccessLevel=ATM.OpportunityAccessLevel));                
                }                                    
            }   
        }
    }
     }

               //Added to copy company tem members to the product account team  list End
    if(trigger.isUpdate){
            For(Account ac : CMPACCList){
        if(ac.custom_account_sfdc_id__c != null && System.Label.AccountRecordTypes.contains(ac.RecordTypeId)){
            //Below logic will run for Owner and Record type fields update to actual values
                    //System.debug('ATMteamListAfterinsert::.....2'+ac.id );
                    teamList.add(new AccountTeamMember(AccountId = ac.Id,
                                                       UserId=ac.ownerID,AccountAccessLevel='Edit',
                                                       TeamMemberRole='Account Executive',CaseAccessLevel='Edit',
                                                       ContactAccessLevel='Edit',
                                                       OpportunityAccessLevel='Edit'));
                    
                    //to add Product account as Teammember                                 
                    //System.debug('ATMteamListAfterinsert::.....3'+ac.id ); 
                    teamList.add(new AccountTeamMember(AccountId = ac.Company_Name__c,
                                                       UserId=ac.ownerID,
                                                       AccountAccessLevel='Edit',TeamMemberRole='Account Executive',
                                                       CaseAccessLevel='Edit',
                                                       ContactAccessLevel='Edit',
                                                       OpportunityAccessLevel='Edit'));                               
        }        
    } 
    }
   
    if(teamList.size()>0){
        //Insert teamList;
        Database.Insert(teamList, false);
       // System.debug('ATMteamListAfterinsert::' + teamList.size());    
    }

}   
public void beforeInsert(){
    
}
public void beforeUpdate(){
    
}
public void beforeDelete(){
    
}
public void afterInsert(){
    AddCompanyTeamMember((list<account>)Trigger.New);       
}
public void afterUpdate(){
    AddCompanyTeamMember((list<account>)Trigger.New);
}  
public void afterDelete() {
    
}
public void afterUnDelete(){
    
}
}