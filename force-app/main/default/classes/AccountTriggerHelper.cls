/**********************************************************************************

Author: Pradeep Guttha / Venkat / Anjaneyulu
Description: This apex class is created for the Trigger Framework. This class 
has all the working methods to be called by the handler.

**********************************************************************************/
public class AccountTriggerHelper
{  
//@author : Pradeep
/**********Update Contracting Entity************/
public static void UpdateContractingEntity()
{
    Map<String,Id> mapConEntities = new Map<String,Id>();
    String territory;
    List<Accounts__c> UpdatedAccs = new List<Accounts__c>();
    
    for (Accounts__c acc: (List<Accounts__c>)Trigger.New)
    {
        //SFDC-2260 - Added condition to check if contracting entity in old record is null
        try{
        if((String.isNotBlank(acc.Shipping_Country__c) && trigger.isInsert && acc.recordtypeid!=(system.Label.AccountGovernmentRecordTypeId)) || 
           (String.isNotBlank(acc.Shipping_Country__c) && trigger.isUpdate && 
            (((Map<Id, Accounts__c>)Trigger.oldMap).get(acc.Id).Shipping_Country__c != acc.Shipping_Country__c || ((Map<Id, Accounts__c>)Trigger.oldMap).get(acc.Id).Company_Name__c != acc.Company_Name__c) && ((Map<Id, Accounts__c>)Trigger.oldMap).get(acc.Id).Contracting_Entity__c == null))
        {
            UpdatedAccs.add(acc);
        }
        // below code has been added as Part of SFDC-3018 by Raushan Kumar
      else if(trigger.isInsert && acc.recordtypeid==(system.Label.AccountGovernmentRecordTypeId)){
       
        acc.NotifiedSystems__c=system.label.AccountNotifiedSystems;
        acc.Contracting_Entity__c=system.label.ContractingEntity;
        acc.Type__c=system.label.Account_Type;
        }
        }catch (Exception e) {
        ExceptionHandler.postToAll(e);
        throw new CustomException(e.getMessage());
    }
    }
    
    for (Contracting_Entity__c con : [select Id, Name, territory__c, Country__c from Contracting_Entity__c])
    {
        mapConEntities.put(con.territory__c, con.Id);           
    }
    
    if(UpdatedAccs.size() > 0)
    {
        for(Accounts__c a : UpdatedAccs)
        {  
            if((a.Shipping_Country__c == 'United States') && (a.CompanyOwnerRegion__c == 'AMER'))
            {
                territory = 'US/CANADA';
            }
            else
            {
                territory = 'International';
            }                                   
            /**** Logic for Approval process ****
a.NewContractingEntity__c = mapConEntities.get(territory);                
if(Trigger.isInsert) 
*/
            //added if statement for SFDC-1566
            if(!(a.Contracting_Entity__c != NULL && Label.ContractingEntitiesToSkip.contains(a.Contracting_Entity__c))) {
                System.debug('Map CE is : ' + mapConEntities);
                a.Contracting_Entity__c = mapConEntities.get(territory);
            }
        }   
    }                             
    
    /***Approval Process not required for now -- Change from business ***
//********** Update Contracting Entity upon Contracting Entity Approved **********/
    if(trigger.isUpdate)
    { 
        for (Accounts__c acc: (List<Accounts__c>)Trigger.New)
        {   
            if(acc.recordtypeid==(system.Label.AccountGovernmentRecordTypeId) && acc.NotifiedSystems__c!=system.label.AccountNotifiedSystems && acc.Type__c!='Customer' && !system.label.System_Admin_Integration_Profiles.contains(UserInfo.getProfileID())){
            acc.adderror('Notified System Value cannot be changed for Government Records.');
            }
            if(acc.DP_CustomerId__c==Null&&acc.recordtypeid==(system.Label.AccountGovernmentRecordTypeId)&& ((Map<Id,Accounts__c>)Trigger.oldMap).get(acc.Id).DP_CustomerId__c!=acc.DP_CustomerId__c ){               
            acc.adderror('A DP Customer ID is required for Government accounts.  Please contact your Salesforce Support Team');
            }
           
            if(acc.Change_Contracting_Entity__c==False &&acc.Contracting_Entity__c!=system.label.ContractingEntity  && acc.recordtypeid==(system.Label.AccountGovernmentRecordTypeId) && acc.Type__c!='Customer' && !system.label.System_Admin_Integration_Profiles.contains(UserInfo.getProfileID())){
            
            acc.adderror('If you want to change Contracting Entity Value.Please check the "Change Contracting Entity?" Field');
            }
            if(String.isNotBlank(acc.Contracting_Entity_to_Approve__c))
            { 
                if(acc.ContractingEntityApproved__c == 'Approved')
                {
                    //acc.Contracting_Entity__c = acc.NewContractingEntity__c;
                    acc.Contracting_Entity__c = acc.Contracting_Entity_to_Approve__c;
                    acc.ContractingEntityApproved__c = '';
                }   
            }
        }
    }    
}



public static void unlockRecord()
{
    List<Accounts__c> ListUnlockRecords =  new List<Accounts__c>();
    Map<Id,String> mapApprovals = New Map<Id,String>();
    for(Accounts__c acc: (List<Accounts__c>)Trigger.new)
    {
        if(acc.Menu_Pricing_Approved__c == false && ((Map<Id,Accounts__c>)Trigger.oldMap).get(acc.Id).Menu_Pricing_Approved__c == true)
        {
            mapApprovals.put(acc.Id, 'Reject');
            //ListUnlockRecords.add(acc);
        }
        if(acc.Menu_Pricing_Approved__c == true && ((Map<Id,Accounts__c>)Trigger.oldMap).get(acc.Id).Menu_Pricing_Approved__c == false)
        {
            mapApprovals.put(acc.Id, 'Approve');
            //ListUnlockRecords.add(acc);
        }
        
    }
    
    // for(Accounts__c acc: ListUnlockRecords)
    //{
    //    mapApprovals.put(acc.Id, 'Reject');
    // }
    
    
    if(mapApprovals.size()>0)
    {
        ApprovalHelper.ApproveRecords(mapApprovals, 'Comments');
    }
}

//@author : Pradeep
/**********Update Territory************     
public static void populateTerritory ()
{
Set<String> setCountries = new Set<String>();
Map<String,String> mapCountryTerritory = new Map<String,String>();
List<Accounts__c> UpdatedAccs = new List<Accounts__c>();

for (Accounts__c acc : (List<Accounts__c>)Trigger.New)
{
if((String.isNotBlank(acc.Billing_Country__c) && trigger.isInsert) || ((String.isNotBlank(acc.Billing_Country__c) && trigger.isUpdate && ((Map<Id, Accounts__c>)Trigger.oldMap).get(acc.Id).Billing_Country__c != acc.Billing_Country__c)))
{
UpdatedAccs.add(acc);
setCountries.add(acc.Billing_Country__c);
}    

}

if(setCountries.size() > 0)
{
for (Country__c country : [select id,name,Territory__c from Country__c where Name IN : setCountries])
{
mapCountryTerritory.put(country.Name,Country.Territory__c);
}
}

if(UpdatedAccs.size() > 0)
{
for (Accounts__c acc: UpdatedAccs)
{
if (mapCountryTerritory.containsKey(acc.Billing_Country__c))
{
acc.Territory__c = mapCountryTerritory.get(acc.Billing_Country__c);
}
}    
}
}*/

//@author : Venkat
/**********Insert AccountRole************/    
public static void insertAccountRole() {
    list<Account_Contact_Role__c> listInsertRoles = new list<Account_Contact_Role__c>();
    set<Id> companyIds = new set<Id>();
    map<Id, AccountContactRole> contMap = new Map<Id, AccountContactRole>();
    for(Accounts__c a : (List<Accounts__c>)trigger.new)  {
        companyIds.add(a.Company_Name__c);    
    }
    
    //get the primary contact role under company
    for(AccountContactRole c : [SELECT Id, accountId, contactId, Contact.Phone, Contact.MailingStreet,
                                Contact.MailingCity, Contact.MailingPostalcode,Contact.MailingState,
                                Contact.MailingCountry FROM AccountContactRole 
                                WHERE accountId IN :companyIds and isPrimary = true]){
                                    contMap.put(c.accountId, c);
                                }
    // Added by Anjaneyulu for SFSB-446 Starts
    Set<String> existingRole = new Set<String>();
    for(Account_Contact_Role__c acr :[Select id,Account__c,Contact__c,Role__c from Account_Contact_Role__c where Role__c='Primary Contact' and  Account__c in : Trigger.newmap.keyset()]){
        existingRole.add(acr.Account__c+'_'+acr.Role__c);
    }
    // Added by Anjaneyulu for SFSB-446 Ends
    for(Accounts__c a : (List<Accounts__c>)trigger.new) {
        AccountContactRole c = contMap.get(a.Company_Name__c);
        // && !existingRole.contains(a+'_'+c.contactId+'_Primary Contact') Added to the below by Anjaneyulu for SFSB-446
        if(c != null && !existingRole.contains(a.Id+'_Primary Contact')) {
            Account_Contact_Role__c acr = new Account_Contact_Role__c(Account__c = a.Id, Contact__c = c.contactId,
                                                                      IsPrimary__c = true, Phone__c = c.Contact.Phone, Mailing_City__c = c.Contact.MailingCity,
                                                                      Mailing_Country__c = c.Contact.MailingCountry, Mailing_State__c = c.Contact.MailingState,
                                                                      Mailing_Postal_Code__c = c.Contact.MailingPostalCode,
                                                                      Mailing_Street__c = c.Contact.MailingStreet,
                                                                      Role__c = 'Primary Contact');
            
            listInsertRoles.add(acr);
        }
    }
    
    //insert all primary contact role records in Account_Contact_Role__c
    if(!listInsertRoles.isEmpty()) {
        //  try {
        insert listInsertRoles;
        /*  }
catch (Exception e) {
ExceptionHandler.postToAll(e);
throw new CustomException(e.getMessage());
}*/
    }
}

//@author : Venkat
/**********auto-close opportunity************/
//Commented By:Vinod Thupakula
//SFDC-2787
/* public static void autoCloseOpportunity(List<Accounts__c> accounts) {
    list<String> ddi = new list<String>(); //list to store all DDI of New records
    set<Id> oldAccId = new set<Id>(); //set to store Old Accounts__c IDs
    map<Id, Id> oldNewAccIds = new map<Id, Id>(); //Map to store Old and New Accounts__c IDs
    list<Opportunity> updateOpp = new list<Opportunity>(); //List to update Opportunities
    list<Task> RSTaskList = new list<Task>(); //List to transfer Tasks to new Accounts__c 
    list<Event> RSEventList = new list<Event>(); //List to transfer Events to new Accounts__c 
    list<Account_Contact_Role__c> accContList = new list<Account_Contact_Role__c>(); //List to transfer to new Accounts__c 
    list<Opportunity> listOpp = new list<Opportunity>();
    
    for(Accounts__c a : accounts) {
        if(a.DDI__c != null || a.DDI__c != '') {
            ddi.add(a.DDI__c);
        }
    }
    
    if(!ddi.isEmpty()){
        //get all the Opportunities with the same DDI
        list<Opportunity> lstOpp = [SELECT Id, DDI__c, Account__c FROM Opportunity
                                    WHERE Type = 'Rackspace Cloud' AND CloseDate = THIS_MONTH AND DDI__c IN :ddi
                                    AND StageName NOT IN ('Closed Won', 'Closed Lost', 'Stage 5 - Closing the Business')];
        
        //DDI and list of opportunities with that DDI
        map<String, List<Opportunity>> mapDDIMatchOpp = new map<String, List<Opportunity>>();
        for(Opportunity opp : lstOpp ) {
            if(mapDDIMatchOpp.containsKey(opp.DDI__c)) {
                list<Opportunity> lstNew = mapDDIMatchOpp.get(opp.DDI__c);
                lstNew.add(opp);
            }
            else {
                list<Opportunity> lstNew = new list<Opportunity>();
                lstNew.add(opp);
                mapDDIMatchOpp.put(opp.DDI__c, lstNew);
            }      
        }
        
        for(Accounts__c a : accounts) {         
            if(mapDDIMatchOpp != null && !mapDDIMatchOpp.isEmpty()) {
                list<Opportunity> lstDDIOpp = mapDDIMatchOpp.get(a.DDI__c);
                if(lstDDIOpp != null && lstDDIOpp.size() == 1) {
                    Opportunity opp  = lstDDIOpp[0];
                    if(String.isNotBlank(opp.Account__c))
                        oldAccId.add(opp.Account__c);
                    oldNewAccIds.put(opp.Account__c, a.Id);
                    opp.StageName = 'Closed Won';
                    opp.Account__c = a.id;
                    updateOpp.add(opp);
                }
            }
        }
        
        if(updateOpp.size() > 0) {
            try {
                update updateOpp;
            }
            catch (Exception e) {
                ExceptionHandler.postToAll(e);
                throw new CustomException(e.getMessage());
            }
        }
        
        //merge data
        if(!oldAccId.isEmpty()){
            for(Opportunity opp : [SELECT Id, accountId, Account__c FROM Opportunity WHERE Account__c IN :oldAccId]) {
                Opp.Account__c = oldNewAccIds.get(opp.Account__c);
                listOpp.add(opp);
            }
            
            for(Task t : [SELECT Id, whatId FROM Task WHERE whatId IN :oldAccId]) {
                t.whatId = oldNewAccIds.get(t.whatId);
                RSTaskList.add(t);
            }
            
            
            
            for(Event e : [SELECT Id, whatId FROM Event WHERE whatId IN :oldAccId]) {
                e.whatId = oldNewAccIds.get(e.whatId);
                RSEventList.add(e);
            }
            
            
            
            for(Account_Contact_Role__c accCont : [SELECT Id, Account__c FROM Account_Contact_Role__c WHERE Account__c IN :oldAccId]) {
                accCont.Account__c = oldNewAccIds.get(accCont.Account__c);
                accContList.add(accCont);
            }
        }
        
        try {        
            if(listOpp != null && listOpp.size() > 0) {
                update listOpp;        
            }
            
            if(RSTaskList != null && RSTaskList.size() > 0) {
                update RSTaskList;        
            }
            
            if(RSEventList != null && RSEventList.size() > 0) {
                update RSEventList;        
            }
            
            if(accContList != null && accContList.size() > 0) {
                update accContList;      
            }
        }
        catch (Exception e) {
            ExceptionHandler.postToAll(e);
            throw new CustomException(e.getMessage());
        }
    } 
}
*/
// Added by Anjaneyulu for SFSB-610
public static void copyContactAddressToAcrs(){
    
    try{
        Set<String> companyIds = new Set<String>();
        
        for(Accounts__c acc: (List<Accounts__c>) Trigger.new)
            companyIds.add(acc.Company_Name__c); 
        Map<Id,Account> companies = new Map<Id,Account>([Select id,BillingCountry,BillingPostalCode,BillingStreet,BillingState,BillingCity,ShippingStreet,ShippingCity,ShippingState,ShippingCountry,ShippingPostalCode,OwnerId from Account where id in : companyIds]);
        
        for(Accounts__c a : (List<Accounts__c>) Trigger.new){
            Account company = companies.get(a.Company_Name__c);
            if(a.shipping_country__c==NULL && a.Shipping_State_Province__c==NULL )
            { // added by Abhi SFDC-270
                a.shipping_street__c = company.ShippingStreet;
                a.shipping_city__c = company.ShippingCity;
                a.Shipping_State_Province__c = company.ShippingState;
                a.Shipping_Country__c = company.ShippingCountry;
                a.Shipping_Zip_Postal_Code__c = company.ShippingPostalCode; 
            }
            if(a.Billing_State_Province__c==NULL && a.Billing_Country__c==NULL)
            {
                a.Billing_Street__c = company.BillingStreet;
                a.Billing_City__c = company.BillingCity;
                a.Billing_State_Province__c = company.BillingState;
                a.Billing_Country__c = company.BillingCountry;
                a.Billing_Zip_Postal_Code__c = company.BillingPostalCode;
            }
            if(a.Acc_Owner__c==NULL)
                a.Acc_Owner__c=company.OwnerId;
        }   
    }catch (Exception e) {
        ExceptionHandler.postToAll(e);
        throw new CustomException(e.getMessage());
    }
}

// Added by Raj for sfdc-983
//Commented By:Vinod Thupakula
//Unused method
/*
public static void copyBillingAddressToPrimary()
{            
    try{
        for (Accounts__c a: (List<Accounts__c>) Trigger.new)  
        {
            if (a.Billing_Country__c!=null && a.Shipping_Country__c==null) a.Shipping_Country__c=a.Billing_Country__c;
            if (a.Billing_State_Province__c!=null && a.Shipping_State_Province__c==null) a.Shipping_State_Province__c=a.Billing_State_Province__c;
            if (a.Billing_City__c!=null && a.Shipping_City__c==null) a.Shipping_City__c=a.Billing_City__c;
            if (a.Billing_street__c!=null && a.Shipping_street__c==null) a.Shipping_street__c=a.Billing_street__c;
            if (a.Billing_Zip_Postal_Code__c!=null && a.Shipping_Zip_Postal_Code__c==null) a.Shipping_Zip_Postal_Code__c=a.Billing_Zip_Postal_Code__c;
        }
    }catch (Exception e) {
        ExceptionHandler.postToAll(e);
        throw new CustomException(e.getMessage());
    }
}*/
// Added by Thirupathi Aeneni and Omkar Narkar for SFDC-2286
public static void recalculateActivityCount(){
    Set<Id> accIds = new Set<Id>();
    for(Accounts__c a : (List<Accounts__c>)Trigger.new)
        if(a.Named_Account__c == 'ABM')
        accIds.add(a.Id);
    
    Map<String,Integer> limitsForRole = new Map<String,Integer>();
    
    for(Activities_Limits_for_Role__mdt li:[SELECT Max_Activities__c,User_Role_Name__c FROM Activities_Limits_for_Role__mdt])
        limitsForRole.put(li.User_Role_Name__c,Integer.valueOf(li.Max_Activities__c));
    
    if(accIds.size()>0){
        
        Period quarter = [Select StartDate,EndDate From Period Where type = 'Quarter' and StartDate = THIS_FISCAL_QUARTER and enddate = THIS_FISCAL_QUARTER  ];
        Map<Id, Accounts__c> accountActivityDetails = new Map<Id,  Accounts__c>([SELECT Id,Named_Account__c,Acc_Owner__r.UserRole.Name,Move_Account__c,Count_of_Activities__c,
                                                                                 (SELECT Id,ActivityDate FROM Tasks WHERE ActivityDate >=: quarter.StartDate AND ActivityDate <=: quarter.EndDate),
                                                                                 (SELECT Id,ActivityDate FROM Events WHERE ActivityDate >=: quarter.StartDate AND ActivityDate <=: quarter.EndDate ) 
                                                                                 FROM Accounts__C WHERE Id IN:accIds ]);
        for(Accounts__c account : (List<Accounts__c>)Trigger.new){
            if(accountActivityDetails.containsKey(account.Id)){
                Accounts__c acc = accountActivityDetails.get(account.Id);
                for(String key:limitsForRole.keySet()){
                    if(acc.Acc_Owner__r.UserRole.Name != null && 
                       acc.Acc_Owner__r.UserRole.Name.containsIgnoreCase(key)){
                           account.Count_of_Activities__c = acc.Tasks.size()+acc.Events.size();
                           account.Move_Account__c = (limitsForRole.get(key) <= (acc.Tasks.size()+acc.Events.size())) ? 'Yes':'No' ;
                       }
                }
            }
        }
    }   
}

//Below Class created for SFDC-2909 by Raushan
//It will Insert Account Team Member whenever a Custom Account with manager will be created or updated. 
public static void createOrUpdateAccountTeamMembers(){
    List<AccountTeamMember> atms = new List<AccountTeamMember>();
    if(Trigger.isInsert){
     Set<Id> accid=New set<Id>();
        for(Accounts__c a:(List<Accounts__c>)Trigger.new){
        if(String.isNotBlank(a.Account_Manager__c)){
        accid.add(a.id);
        }
        }
       
        for(Accounts__c a :[Select id,Company_Name__c,name,Account_Manager__c,Account_manager__r.isactive from Accounts__c where id =: accid] ){
            if(String.isNotBlank(a.Account_Manager__c)&&(a.Account_manager__r.isactive))
                atms.add(new AccountTeamMember(AccountId=a.Company_Name__c,
                                               UserId = a.Account_Manager__c,
                                               OpportunityAccessLevel='Edit',
                                               contactaccesslevel='Edit',
                                               accountaccesslevel='Edit',
                                               caseaccesslevel='None',
                                               TeamMemberRole='Account Manager'));
        }
        
    }
    
    if(Trigger.isUpdate){
        
        Map<id,Accounts__c> accmap=New Map<id,Accounts__c>();
        Map<Id,String> oldaccIdVsManagerId = new Map<Id,String>();
        Set<Id> updateaccid=New set<Id>();
        for(Accounts__c a:(List<Accounts__c>)Trigger.new){
        if(String.isNotBlank(a.Account_Manager__c)){
        updateaccid.add(a.id);
        }
        }
        if(updateaccid.size()>0){
        for(Accounts__c acc:[select id,name,Company_Name__c,account_manager__c,Account_Manager__r.isactive from Accounts__c where id =:updateaccid]){
        accmap.put(acc.id,acc);
        }
        }
        for(Integer i=0;i<Trigger.size;i++){
            Accounts__c newAcc = (Accounts__c)Trigger.new[i];
            Accounts__c oldAcc = (Accounts__c)Trigger.old[i];
            if(newAcc.Account_Manager__c != oldAcc.Account_Manager__c){
                if(String.isNotBlank(newAcc.Account_Manager__c)&&(accmap.get(newAcc.id).Account_manager__r.isactive))
                    atms.add(new AccountTeamMember(AccountId=newAcc.Company_Name__c,UserId = newAcc.Account_Manager__c,OpportunityAccessLevel='Edit',contactaccesslevel='Edit',accountaccesslevel='Edit',caseaccesslevel='None',TeamMemberRole='Account Manager'));
                
                if(String.isNotBlank(oldAcc.Account_Manager__c))
                    oldaccIdVsManagerId.put(oldAcc.company_name__c,oldAcc.company_name__c+'_'+oldAcc.Account_Manager__c);
                
            }
        }
        if(!oldaccIdVsManagerId.isEmpty()){
            List<AccountTeamMember> delatms = new List<AccountTeamMember>();
            Set<String> managerIDAccId = new Set<String>();
            for(Accounts__c acc : [Select Id,Company_Name__c,Account_Manager__c from Accounts__c where Company_Name__c in :oldaccIdVsManagerId.keySet() and Id not in : Trigger.newmap.keySet() ]){
                managerIDAccId.add(acc.Company_Name__c+'_'+acc.Account_Manager__c);
            }
            for(AccountTeamMember atm : [Select Id,UserId,AccountId from AccountTeamMember where AccountId in : oldaccIdVsManagerId.keySet()]){
                if(oldaccIdVsManagerId.values().contains(atm.AccountId+'_'+atm.UserId) && !managerIDAccId.contains(atm.AccountId+'_'+atm.UserId))
                    delatms.add(atm);
            }
            if(delatms.size() >0)
            Delete delatms;
        }
        
        
        
    }
    if(!atms.isEmpty())
        Insert atms;
}   

}