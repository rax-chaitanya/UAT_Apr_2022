/**********************************************************************************

Author: Anitha Sajja
Date:[30/03/2020]
Description: To resolve eSig Issue - Update AccountId on Contact in NA34 if it is blank
Test Class : AccountContactRelationHandler_Test
* Last modified : MAR 2022,Dev- Chaitanya,Jira - SFDC-7308
**********************************************************************************/
public class AccountContactRelationHelper {
    
    public static boolean boolIsExecuted = false;
    
    public static void updateContactwithCompany(List<AccountContactRelation> acrs){
        System.debug('update inside contact Ahndler');
         
        Map<Id, Contact> updateContacts = new Map<Id, Contact>();
        for(AccountContactRelation acr : acrs){
        System.debug('acr.ConCompId__c...Role'+acr.ConCompId__c); 
            System.debug('acr.AccCompId__c...Role'+acr.AccCompId__c); 
            if(String.isBlank(acr.ConCompId__c) && String.isNotBlank(acr.AccCompId__c))
                updateContacts.put(acr.ContactId, new Contact(Id=acr.ContactId,AccountId = acr.AccCompId__c)) ;
        }
        if(!updateContacts.isEmpty())
            update updateContacts.values();
    }
    
    
    
   
    //GTMO-324 ,Samba Start
     /*       public static void checkPrimaryACROnUpdate(List<AccountContactRelation> acrList, boolean isBeforeInsert) {
            Map<Id, AccountContactRelation> acrMapprimary = new Map<Id, AccountContactRelation>();
            List<AccountContactRelation> PrimaryAcrs = new List<AccountContactRelation>(); 
        List<Id> accID = new List<Id>();
        Map<id, boolean> boolMap = new map<id,boolean>();
       // list<string> rolestr = new list<string>();
       
        list<string> roles = new list<string>();
        string AcrPrimaryRole=label.ACR_Role_Primary_Contact;
        string rolestr;
        Boolean IsPrimaryRole= false;
        Boolean NotIsPrimaryRole= true;
        
        for(AccountContactRelation ar : acrList){
            rolestr=String.valueOf(ar.Roles);
            if(ar.accountId != null){
                accID.add(ar.accountId);
            }
        }
        System.debug('rolestr.........'+rolestr);
        
        if(String.isNotBlank(rolestr)){

            for(string s :rolestr.split(';')){
                roles.add(s);
            }
            }
       
        for(string str : roles){
            if(str==AcrPrimaryRole){
                IsPrimaryRole = true;
            } else {
                NotIsPrimaryRole = true;
            }
        }
        System.debug('IsPrimaryRole.........'+IsPrimaryRole);
       List<account> aclist = [select id,name, (select id,IsPrimary__c,AccountId,Roles,ContactId from
                                                 AccountContactRelations where Roles includes (:AcrPrimaryRole)) from Account WHERE Id In: accID];
        for(account a : aclist){
            boolMap.put(a.id, a.AccountContactRelations.size()>0 ? true : false);
           PrimaryAcrs.addall(a.AccountContactRelations);
           System.debug('a.AccountContactRelations.........'+a.AccountContactRelations.size());
        }
                 System.debug('PrimaryAcrs.........'+PrimaryAcrs);

         for(AccountContactRelation a : PrimaryAcrs){ 
             acrMapprimary.put(a.id,a);
        }
        
        for(AccountContactRelation ar : acrList){ 
         if(isBeforeInsert){
             if(boolMap.get(ar.AccountId) == true && IsPrimaryRole){
                ar.addError('You can not create more than one Primary Account Contact Relationship');
            }
         } else {
            if(boolMap.get(ar.AccountId) == true && IsPrimaryRole && !acrMapprimary.containskey(ar.id)){
                ar.addError('You can not create more than one Primary Account Contact Relationship');
            }
         }
        }
    } */
    //GTMO-324 ,Samba End
    //
   //SFDC-7308 Refactored the below to bulkify the code
public static void checkPrimaryACROnUpdate(List<AccountContactRelation> acrList) {

    set<id> exacrids=new set<id>();
    string AcrPrimaryRole=label.ACR_Role_Primary_Contact;
    Map<Id, AccountContactRelation> acctoprimaryacrs = new Map<Id, AccountContactRelation>();

for (AccountContactRelation acracc : acrList) {
   // if(acracc.roles!=null){
if (acracc.roles.contains(AcrPrimaryRole)) {
    acctoprimaryacrs.put(acracc.accountid,acracc);
//}
}
}


if(acctoprimaryacrs.size()>0  ){

    Map<ID, Account> exacctoprimaryAcr = new Map<ID, Account>([select id,name,
     (select id,IsPrimary__c,AccountId,Roles,ContactId from AccountContactRelations 
     where Roles includes (:AcrPrimaryRole)) from Account
      WHERE Id In: acctoprimaryacrs.keySet()]);

      if(exacctoprimaryAcr.values().size()>0){
    for (Account exac : exacctoprimaryAcr.values()) { 
        for (AccountContactRelation exacr : exac.AccountContactRelations) {
            exacrids.add(exacr.id);
        }
            
        }
        
    }


for (AccountContactRelation acr : acctoprimaryacrs.values()) 
 {
if(Trigger.isInsert )
{
    if(exacctoprimaryAcr.get(acr.accountid).AccountContactRelations.size()>0){
        acr.addError('You can not create more than one Primary Account Contact Relationship');
    }
}
else if (Trigger.isUpdate )
    {
    System.debug('acr.accountid.........'+acr.accountid);
    if(!exacrids.contains(acr.id)
    && exacctoprimaryAcr.get(acr.accountid).AccountContactRelations.size()>0){
        acr.addError('You can not create more than one Primary Account Contact Relationship');
    }
    }
 }
}


}


}