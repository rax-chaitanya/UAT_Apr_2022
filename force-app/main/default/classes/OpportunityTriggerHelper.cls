/*
//////////////////////////////////////////////////////////////////////////////////////////////////
// @class       :   OpportunityTriggerHelper.cls
// @version     :   1.1
// @createdby   :   RDC
// @createddate :   Dec-29-2016
// @description :   This is an Apex class to hold business logic for Opportunity triggers.
// @changelog   :   
//                  - Jul-07-2017: Jayant Yadav (RDC)   
//                  Modified the method signature and body of SFDC-443.
//                  
//                  - Oct-26-2017:  Diego Castro. 
//                  Moving forward, we will be using this class to add business logic for
//                  trigger events. For a given event that happens on an sObject
//                  (before I/U, after I/U, etc.), we will do a maximum of 2 iterations
//                  on the Trigger.new context variable: 
//                      1st iteration: collecting ids that satisfy certain criteria
//                      2nd iteration: for callouts, DML operations onrelevant records, etc.
//                  
//                  - Jan 10-2018: Diego Castro
//                  Added SFDC-535 to beforeInsert() and beforeUpdate().
//                  
//                  - Jan 12-2018: Diego Castro
//                  Added SFDC-1108.
//////////////////////////////////////////////////////////////////////////////////////////////////

//
* @author Chaitanya
* @date March 2022
* @Change description SFDC-7331 Make Gross Margin Min field mandatory for EMEA Sales rep
* @Test Class - OpportunityTriggerTest , OpportunityTrigger_Test
* 
//

*/
public with sharing class OpportunityTriggerHelper {
    public static Boolean executeSecond = false;
    public static Boolean UPDATE_ACCOUNT_DETAILS =true;
    Public static  Boolean firstcall = false;
    
    
    
    public static void beforeUpdate() {
        // BEGIN FIRST ITERATION REGION     [BEFORE UPDATE]
        // END FIRST ITERATION REGION       [BEFORE UPDATE]
        
        //BEGIN RECORD COLLECTION REGION    [BEFORE UPDATE]
        //END RECORD COLLECTION REGION      [BEFORE UPDATE]
        
        // BEGIN SECOND ITERATION REGION    [BEFORE UPDATE]
        set<string> ddi=new set<string>();
        set<string> ddiprospect=new set<string>();
        for (Opportunity opp : (List<Opportunity>) Trigger.new) 
        {
            opportunity oppstage =(opportunity)trigger.oldmap.get(opp.id);
            system.debug('opp.DDI__c-----------'+opp.DDI__c);
            system.debug('oppstage.DDI__c------------'+oppstage.DDI__c);
            if(opp.DDI__c!=null && oppstage.DDI__c!=null && opp.DDI__c!=oppstage.DDI__c && opp.Account__r.Type=='Prospect' &&opp.RecordType.Name == 'US Cloud'  && opp.Integration_Status__c=='Success' && !System.Label.SkipUserIDs.contains(UserInfo.getUserId())){
                ddi.add(opp.DDI__c);
            }
            
            /*if(opp.DDI__c!=null  && opp.Type=='AWS' && opp.QuotingSystem__c == 'Onica' && !System.Label.SkipUserIDs.contains(UserInfo.getUserId())){
system.debug('opp.account__r.Type------'+opp.DDI__c);
ddiprospect.add(opp.DDI__c);

}*/
            
            /* 
//SFDC-535 [before update]
if (isClosedINTLNonUSDOpp(opp)) {
opp.CurrencyIsoCode = 'USD';
}
System.debug(opp.CurrencyIsoCode);
//SFDC-535 [after update]       [BEFORE UPDATE]
//
*/
            
        }
        // END SECOND ITERATION REGION      [BEFORE UPDATE]
        // 
        if(ddi.size()>0 ){
            
            List<Account> accddi=[select id,name from Account where DDI__c in:ddi and DDI__c!=null and Type='Prospect'];
            /*  List<Account> accddiprospect=[select id,name from Account where DDI__c in:ddiprospect and DDI__c!=null and Type='Prospect'];
for (Opportunity opp : (List<Opportunity>) Trigger.new) 
{
system.debug('accddiprospect--------'+accddiprospect);
if(accddi.isempty()){
system.debug('accddiprospect--------'+accddiprospect);
opp.adderror('Please Enter Valid DDI.');
}else if(accddiprospect.isempty()){
system.debug('accddiprospect--------'+accddiprospect);
opp.adderror('Please Enter Valid DDI.');
}
}*/
            if(accddi.isempty()){
                for (Opportunity opp : (List<Opportunity>) Trigger.new) 
                {
                    //opp.adderror(System.Label.InvalidDDI);
                }
            }
            
            
            
        }  
        
        
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // @developer   :    Diego Castro
    // @date        :    01/10/2018
    // @method      :    beforeInsert()
    // @description :    
    // @changelog   :   
    //                  @story      : SFDC-535
    //                  @developer  : Diego Castro
    //                  @date       : 01/10/18
    //                  @change     : stamps CurrencyISOCode field with 'USD' when an INTL seller/manager close wons an opp.
    //                  
    //                  @story      : SFDC-1108 [defect]
    //                  @developer  : Diego Castro
    //                  @date       : 01/12/18
    //                  @change     : changed 
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
    public static void beforeInsert() {
        set<Id> companies_w_no_primary_contacts = new set<Id>();
        Map<id,Opportunity> AllaccMap = new Map<id,Opportunity>();
        set<Id> all_company_ids = new set<Id>();
        system.debug('vvcvcvcvcvc');
        //Samba,to populate company on oppty start
        Set<Id> companyaccs = new Set<Id>();
        list<account> comprodacclist = new list<account>();
        String companytype = System.Label.CheckCompanyonRecordType;
        String parentcompId;
        list<account> prospectact = new list<account>();
        Map<Id,Id> comprodaccmap = new Map<Id,Id>();
        set<id> podAccList = new set<id>();
        String ProdAccid;
        string AcrPrimaryContact=label.ACR_Role_Primary_Contact;
        //Samba,to populate company on oppty End
        // BEGIN FIRST ITERATION REGION
        for (Opportunity opp : (List<Opportunity>) Trigger.new) {
            if(!CompanyHandler.isLeadConverting){
                if(String.isNotBlank(opp.Account__c)){
                    podAccList.add(opp.Account__c);
                    AllaccMap.put(opp.Account__c,opp);
                }
                if(String.isNotBlank(opp.AccountId)){
                    all_company_ids.add(opp.AccountId);                 
                }
            }else{
                if (String.isNotBlank(opp.AccountId) && String.isNotBlank(opp.Account__c)){
                    ProdAccid= opp.Account__c;
                    podAccList.add(opp.Account__c);
                    system.debug('ProdAccid......'+ProdAccid);
                    //Added for GTMO-601
                    system.debug('podAccList......'+podAccList);
                    
                    all_company_ids.add(opp.AccountId);
                    //begin collection of ids for STGET-329 (Auto Populate Primary Contact on Company to the Opportunity being created)
                    if (String.isBlank(opp.Primary_Contact__c) ) {
                        companies_w_no_primary_contacts.add(opp.AccountId);
                    }
                    //end collection of ids for STGET-329
                } else if (String.isNotBlank(opp.AccountId)){
                    // begins collection of ids that satisfy criteria for SFDC-478 (Product Account View)
                    all_company_ids.add(opp.AccountId);
                    system.debug('all_company_ids......'+all_company_ids);
                    // end collection of ids for SFDC-478 (Product Account View)
                    
                    //begin collection of ids for STGET-329 (Auto Populate Primary Contact on Company to the Opportunity being created)
                    if (String.isBlank(opp.Primary_Contact__c) ) {
                        companies_w_no_primary_contacts.add(opp.AccountId);
                    }
                    //end collection of ids for STGET-329
                }
            }   
        }
        Map<Id,Account> prodacmap;
        Map<Id,Account> companymap;
        if(CompanyHandler.isLeadConverting){
            prodacmap = new Map<Id,Account>([Select id,Name,ownerid,Company_Name__c,RecordTypeId,NotifiedSystems__c,ParentId from Account where id =:ProdAccid]);
            system.debug('prodacmap......'+prodacmap);
            
            // END FIRST ITERATION REGION
            companymap = new Map<Id,Account>([Select id,Name,ownerid,Company_Name__c,RecordTypeId,NotifiedSystems__c,ParentId,Billingstreet,BillingCity,BillingState,billingcountry,
                                              billingpostalcode,Shippingstreet,ShippingCity,ShippingState,Shippingcountry,Shippingpostalcode from Account where id in:all_company_ids]);
            system.debug('companymap.values......'+companymap.values()); 
            //Samba,to populate company on oppty Start
            for(Account a : companymap.values()){
                
                if(System.Label.CompanyRecordTypes.contains(a.RecordTypeId) && a.RecordTypeId != null){
                    companyaccs.add(a.id);
                    parentcompId = a.id;
                } else
                {
                    podAccList.add(a.id);
                    
                }
            }
            system.debug('podAccList----'+podAccList); 
            system.debug('companyaccs......'+companyaccs);
            if(companyaccs.size()>0 && ProdAccid == null){
                comprodacclist = [Select id,Name,Company_Name__c,createddate from Account where Company_Name__c =: companyaccs and type = 'Prospect' and (Not RecordType.Name like :('%' + companytype + '%')) ORDER BY createddate DESC limit 1];
            }
            system.debug('comprodacclist......'+comprodacclist); 
            if(comprodacclist.size()>0 && companyaccs.size()>0){
                for(account a :comprodacclist){
                    comprodaccmap.put(a.Company_Name__c,a.id);
                    //Added for GTMO-601
                    podAccList.add(a.id);
                    system.debug('a.id......'+a.id); 
                }
                
            } else if (comprodacclist.size()==0 && ProdAccid == null && companyaccs.size()>0 ){
                account ac = new account();  
                ac.Company_Name__c = parentcompId;
                ac.ownerid= companymap.get(parentcompId).ownerid;
                ac.BillingStreet= companymap.get(parentcompId).BillingStreet;
                ac.BillingCity= companymap.get(parentcompId).BillingCity;
                ac.BillingCountry= companymap.get(parentcompId).BillingCountry;
                ac.BillingState= companymap.get(parentcompId).BillingState;
                ac.BillingPostalCode= companymap.get(parentcompId).BillingPostalCode;
                ac.name= companymap.get(parentcompId).Name;
                // ac.Status__c= 'New';
                // ac.Acc_Created_From_Lead__c=True;
                ac.Type='Prospect';
                
                system.debug('companymap.get(parentcompId).RecordTypeId......'+companymap.get(parentcompId).RecordTypeId); 
                ac.NotifiedSystems__c= companymap.get(parentcompId).NotifiedSystems__c;
                if(System.Label.GovernmentRecordTypes.contains(companymap.get(parentcompId).RecordTypeId ))
                    
                {
                    ac.RecordTypeId= System.Label.AccountGovernmentRecordTypeId;
                }
                else
                {
                    ac.RecordTypeId= System.Label.Account_Prospect_RecordType_ID;
                }
                ac.ShippingStreet= companymap.get(parentcompId).ShippingStreet;
                ac.ShippingCity= companymap.get(parentcompId).ShippingCity;
                ac.ShippingCountry= companymap.get(parentcompId).ShippingCountry;
                ac.ShippingState= companymap.get(parentcompId).ShippingState;
                ac.ShippingPostalCode= companymap.get(parentcompId).ShippingPostalCode;
                //ac.Is_ProductAccount__c=true;
                //
                //
                //
                prospectact.add(ac);
                
                
            }
            if(prospectact.size()> 0){
                insert prospectact;
            }
            system.debug('prospectact......'+prospectact); 
            
            
            if(prospectact.size()>0){
                for(account a :prospectact){
                    comprodaccmap.put(a.Company_Name__c,a.id);
                    podAccList.add(a.id);
                    system.debug('a.id......'+a.id);              
                }
                
            }
        }       
        //Samba,to populate company on oppty End
        //BEGIN RECORD COLLECTION REGION
        Map<Id, UserRecordAccess> uraMap = new Map<Id, UserRecordAccess>([Select RecordId, HasEditAccess from UserRecordAccess where UserId = :UserInfo.getUserId() AND RecordId in :all_company_ids]);
        
        for (Opportunity opp : (List<Opportunity>) Trigger.new)  {
            if (String.isNotBlank(opp.AccountId) && uraMap.containsKey(opp.AccountId) && !uraMap.get(opp.AccountId).HasEditAccess)  {
                opp.addError('You do not have edit access to the related company. Please navigate to the company and hit the "Request Access" button');
                system.debug('uraMap.get(opp.AccountId).........'+uraMap.get(opp.AccountId));
                system.debug('HasEditAccess.........'+uraMap.get(opp.AccountId).HasEditAccess);
            }
            
            if (CompanyHandler.isLeadConverting && String.isNotBlank(opp.AccountId) && String.isNotBlank(opp.Account__c)) {
                opp.Account__c= ProdAccid;
                opp.AccountId = prodacmap.get(opp.Account__c).Company_Name__c;
                AllaccMap.put(opp.Account__c,opp);
                system.debug('Else3 opp.Account__c......'+opp.Account__c);
                system.debug('Else3 opp.AccountId......'+opp.AccountId);
                
            }else {
                if(CompanyHandler.isLeadConverting && companymap.containskey(opp.AccountId) && System.Label.AccountRecordTypes.contains(companymap.get(opp.AccountId).RecordTypeId)){
                    opp.Account__c= opp.AccountId;
                    opp.AccountId = companymap.get(opp.AccountId).Company_Name__c;
                    AllaccMap.put(opp.Account__c,opp);
                    system.debug('if1 opp.Account__c......'+opp.Account__c); 
                    system.debug('if1 opp.AccountId......'+opp.AccountId);     
                }else if(CompanyHandler.isLeadConverting && companyaccs.contains(opp.AccountId) && comprodaccmap.containskey(opp.AccountId)){
                    //opp.AccountId = opp.AccountId;
                    opp.Account__c= comprodaccmap.get(opp.AccountId);
                    AllaccMap.put(opp.Account__c,opp);
                    system.debug('Else2 opp.Account__c......'+opp.Account__c);
                    system.debug('Else2 opp.AccountId......'+opp.AccountId);
                }                   
            }
            /*//SFDC-535 [before insert]
if (isClosedINTLNonUSDOpp(opp)) {
opp.CurrencyIsoCode = 'USD';
}
//SFDC-535 [before insert]
*/
        }
        
        Integer acrSize = 0;
        for (AccountContactRelation acr :  [Select AccountID,Account.Company_Name__c, ContactId from AccountContactRelation where Roles includes (:AcrPrimaryContact) and AccountId in :podAccList]) {
            system.debug('AcrPrimaryContact....'+acr);            
            if((acr.AccountId != null && acr.Account.Company_Name__c != null) && AllaccMap.containsKey(acr.AccountId)){
                AllaccMap.get(acr.AccountId).Primary_Contact__c = acr.ContactId;
                acrSize++;
            }           
        }
        if (acrSize > 0) {
            executeSecond = true;
        }
        
        // END SECOND ITERATION REGION
        
    } 
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // @developer   :    Diego Castro
    // @date        :    01/10/2018
    // @method      :    afterUpdate()
    // @description :    
    // @changelog   :   
    //                  @story      : SFDC-535
    //                  @developer  : Diego Castro
    //                  @date       : 01/10/18
    //                  @change     : stamps CurrencyISOCode field with 'USD' when an INTL seller/manager close wons an opp.
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public static void afterUpdate() {
        Boolean fmwOrFoundationUser = Reusable.amFMWAPIOrFoundationuser();
        
        set<Id> closedWonOpps = new set<Id>();
        
        //BEGIN FIRST ITERATION REGION
        for (Opportunity opp : (List<Opportunity>) Trigger.new) {
            
            //SFDC-125 (after update)
            if (!fmwOrFoundationuser && becameClosedWonEver(opp.Id)) {
                closedWonOpps.add(opp.Id);
            }
            //SFDC-125 (after update)
            
            
            
        }
        //END FIRST ITERATION REGION
        
        
        
        //BEGIN RECORD COLLECTION REGION
        map<Id, map<string,Id>> oppToPRMap = new map<Id, map<string,Id>>();
        //SFDC-125 (after update)
        if (closedWonOpps.size() > 0) {
            oppToPRMap = getPartnerRoleMap_filteredOnUser(closedWonOpps);
        }
        //SFDC-125 (after update)
        
        
        //END RECORD COLLECTION REGION
        
        
        //BEGIN SECOND ITERATION REGION
        Sobject[] toInsert = new list<SObject>();
        for (Opportunity opp : (List<Opportunity>) Trigger.new) {
            //SFDC-125 (after update)
            
            // if there is a partner role and the rv account owner is a user (and not a queue)
            if (oppToPrMap.containsKey(opp.Id) ) {
                if (opptoPrMap.get(opp.Id).containsKey('Source')) {
                    toInsert.add( createOpportunityTeamMember(opp.Id, oppToPrMap.get(opp.Id).get('Source')) );
                } else if (oppToPrMap.get(opp.Id).containsKey('Influence')) {
                    toInsert.add( createOpportunityTeamMember(opp.Id, oppToPrMap.get(opp.Id).get('Influence')) );
                }
            }
            //SFDC-125 (after update)
            
        }
        //END SECOND ITERATION REGION
        
        
        if (toInsert.size() > 0) {
            Database.insert (toinsert, false);
        }
        //EmailNotificationForCloudAccountCreation.sendEmail((List<Opportunity>) Trigger.new,(map<id,Opportunity>) Trigger.oldMap);
    }
    
    public static void afterInsert() {
        Boolean fmwOrFoundationUser = Reusable.amFMWAPIOrFoundationuser();
        
        set<Id> closedWonOpps = new set<Id>();
        
        //BEGIN FIRST ITERATION REGION
        for (Opportunity opp : (List<Opportunity>) Trigger.new) {
            
            //SFDC-125 (after INSERT)
            if (!fmwOrFoundationUser && opp.isClosed && opp.isWon) {
                closedWonOpps.add(opp.Id);
            }
            //SFDC-125 (after INSERT)
            
            
            
        }
        //END FIRST ITERATION REGION
        
        
        
        //BEGIN RECORD COLLECTION REGION
        map<Id, map<string,Id>> oppToPRMap = new map<Id, map<string,Id>>();
        //SFDC-125 (after INSERT)
        if (closedWonOpps.size() > 0) {
            oppToPRMap = getPartnerRoleMap_filteredOnUser(closedWonOpps);
        }
        //SFDC-125 (after INSERT)
        
        
        //END RECORD COLLECTION REGION
        
        
        //BEGIN SECOND ITERATION REGION
        Sobject[] toInsert = new list<SObject>();
        for (Opportunity opp : (List<Opportunity>) Trigger.new) {
            //SFDC-125 (after INSERT)
            // if there is a partner role and the rv account owner is a user (and not a queue)
            if (oppToPrMap.containsKey(opp.Id) ) {
                if (opptoPrMap.get(opp.Id).containsKey('Source')) {
                    toInsert.add( createOpportunityTeamMember(opp.Id, oppToPrMap.get(opp.Id).get('Source') ));
                } else if (oppToPrMap.get(opp.Id).containsKey('Influence')) {
                    toInsert.add( createOpportunityTeamMember(opp.Id, oppToPrMap.get(opp.Id).get('Influence') ));
                }
            }
            //SFDC-125 (after INSERT)
        }
        //END SECOND ITERATION REGION
        
        
        if (toInsert.size() > 0) {           
            Database.insert (toinsert, false);
        }        
        
    }
    
    
    
    
    // BEGIN UTILITY METHOD REGION
    public static boolean becameClosedWonEver(Id oppId) {
        return !Boolean.ValueOf(Trigger.oldMap.get(oppId).get('IsClosedWon_Ever__c')) && 
            Boolean.valueOf(Trigger.newMap.get(oppId).get('IsClosedWon_Ever__c')) ;
    }
    
    public static map<Id, map<String, Id>> getPartnerRoleMap_filteredOnUser(Set<Id> opportunityIds) {
        map<Id, map<String, Id>>  oppToPRMap = new map<Id, map<String, Id>> ();
        for (Partner_Role__c pr : [Select Id, Opportunity__c, RV_Account__r.OwnerId, Role__c from Partner_Role__C where 
                                   Opportunity__c in :opportunityIds AND RV_Account__c != '']) 
        {
            if (( (String) pr.RV_Account__r.OwnerId).startsWith('005')) {
                if (oppToPrMap.containsKey(pr.Opportunity__c)) {
                    oppToPrMap.get(pr.Opportunity__c).put( pr.Role__c, pr.RV_Account__r.OwnerId);
                } else {
                    oppToPrMap.put(pr.Opportunity__c, new map<string, Id>{pr.Role__c => pr.RV_Account__r.OwnerId});
                }
                
                
            }
            
        }
        return oppToPRMap;   
        
    }
    
    public static OpportunityTeamMember createOpportunityTeamMember(Id oppId, Id ownerId) {
        return new OpportunityTeamMember (UserId = ownerId, OpportunityId = oppId, OpportunityAccessLevel = 'Edit', TeamMemberRole = Label.OpportunityTeamMember_AdminOnlyCreatableRole);
    }
    
    
    
    public static Boolean isClosedINTLNonUSDOpp(Opportunity opp) {
        return ( opp.Type == 'AWS' && Label.Profiles_INTL_1.contains(UserInfo.getProfileId()) && opp.CurrencyIsoCode != 'USD' && opp.isClosed &&
                ( Trigger.isInsert  || (Trigger.isUpdate && !( (Opportunity) Trigger.oldMap.get(opp.Id) ).isClosed ) ));
        
        /*            

Trigger.isUpdate && !( (Opportunity) Trigger.oldMap.get(opp.Id) ).isClosed


opp.isClosed &&  opp.Type == 'AWS' && Label.Profiles_INTL_1.contains(UserInfo.getProfileId()) && opp.CurrencyIsoCode != 'USD'
if ( !( (Opportunity) Trigger.oldMap.get(opp.Id) ).isClosed  &&  opp.isClosed && opp.Type == 'AWS' && Label.Profiles_INTL_1.contains(UserInfo.getProfileId()) && opp.CurrencyIsoCode != 'USD') {

*/
        
    }
    
    // END UTILITY METHOD REGION
    
    
    
    
    
    //method to be called on insert and update of Opportunity records.
    //if an Opportunity is created by any of Oracle SOA users and the Company is empty,
    //will populate it with the Company from corresponding Account. 
    //arg1 - Trigger.New list
    //returns nothing
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // @developer   :    ?????
    // @date        :    ??????
    // @method      :    populateCompanyFromAccount(param1, param2)
    //      @params :    triggerNew => Opportunity[], triggerOldMap => map<id, Opportunity>
    // @description :    
    // @changelog   :   
    //                  @story      : SFDC-1108 [defect]
    //                  @developer  : Diego Castro
    //                  @date       : 01/12/18
    //                  @change     : changed (o.Lead_Id__c!=null || o.Lead_Id__c!='') to String.isNotBlank(o.Lead_Id__c)
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
    
    public static void populateCompanyFromAccount(List<Opportunity> triggerNew, Map<Id, Opportunity> triggerOldMap) {
        
        //set to hold the ids of Oracle SOA users. Ids are stored in labels - FMWFoundationUser and FMW_API_User
        set<String> oracleSoaUserIds = new set<String>{System.Label.FMW_API_User, System.Label.FMWFoundationUser};        
            
            
            //iterate over Opportunities' list and if Company is empty but Account is populated, populate Company with the Company of Account.
            for(Opportunity o : triggerNew) 
        {
            
            //SFDC-1108
            if (String.isNotBlank(o.Lead_Id__c)) {
                o.Created_from_Lead__c = true;
            }
            //SFDC-1108
            
            System.debug('##########:'+'Lookup Filter FOR Loop Entry:'+'_'+o.AccountId);   
            
            
            //modified for SFDC-443, JY, 7th July 2017 - begin
            /*
if(oracleSoaUserIds.contains(String.valueOf(UserInfo.getUserId()).left(15)) &&
String.isNotBlank(o.Account__c) &&
(String.isBlank(o.AccountId) || (trigger.isUpdate && o.Account__c != triggerOldMap.get(o.Id).Account__c))) {
System.debug('##########:'+'Lookup Filter If block Entry:'+o.Account__c+'_'+o.AccountId);   

o.AccountId = o.Accounts_Company__c;
System.debug('##########:'+'Lookup Filter If block Exit:'+o.Account__c+'_'+o.AccountId);   

}
//modified for SFDC-443, JY, 7th July 2017 - end


*/
            System.debug('o.Account__c'+o.Account__r.Company_Name__c);
            
            System.debug('o.AccountId '+o.AccountId );
            System.debug('o.Account__r.Account_Number__c'+o.Account__r.Company_Name__c);
            System.debug('o.Account__r.Company Name'+o.Account__r.Company_Name__c);
            if(String.isNotBlank(o.Account__c))
                
                o.AccountId = o.Accounts_Company__c; //Raj - 04/05/2018 - War Room change
            
            
            
        }
        
    }
    
    // Added by Anjaneyulu for SFSB-356
    /*public static void mapAccountFieldsOnOpportunities(List<Opportunity> opportunityList){
System.debug('Inside  mapAccountFieldsOnOpportunities');
Set<Id> companyIds = new Set<Id>();
Map<Id,Id> accountIdVsCustomAccountID = new Map<Id,Id>();
List<Account> customAccounts = new List<Account>();
List<Account> companiesToCreateAccounts = new List<Account>();
Set<Id> companyIdsWithNOAccount = new Set<Id>();
List<Id> AccIds = CMPorACCRecordType_Utility.query_Utility(Label.AccountRecordTypes);
if(companyIds.size() > 0){
System.debug('Inside  companyIds');
for(Account account : [Select id,Company_Name__c from Account where Type='Prospect' And RecordTypeId IN : AccIds  And Company_Name__c in : companyIds order by CreatedDate desc]){
if(!accountIdVsCustomAccountID.containsKey(account.Company_Name__c))
accountIdVsCustomAccountID.put(account.Company_Name__c, account.id);  
System.debug('account>>> '+account);
}

for(Id i :companyIds ){
System.debug(' i'+ i);
if(!accountIdVsCustomAccountID.containsKey(i))
companyIdsWithNOAccount.add(i) ; 
}

if(!companyIds.isEmpty()){                
//Added by Anjaneyulu for SFDC-2153 -- Starts
for(Account company: [select id,Name,BillingCountry,RecordType.Name,RecordType.DeveloperName,BillingState,BillingCity,BillingStreet,BillingPostalCode,ShippingCountry,ShippingState,ShippingCity,ShippingStreet,ShippingPostalCode,OwnerId from Account where Id in : companyIdsWithNOAccount]){

if(company.RecordType.DeveloperName == 'Government_Company')
customAccounts.add(new Account(Company_Name__c = company.Id,BillingCountry=company.BillingCountry,BillingState=company.BillingState,BillingCity=company.BillingCity,BillingStreet=company.BillingStreet,BillingPostalCode=company.BillingPostalCode,
Name=company.Name,RecordTypeID=Label.AccountGovernmentRecordTypeId,ShippingCountry=company.ShippingCountry,ShippingCity=company.ShippingCity,ShippingState = company.ShippingState,ShippingStreet=company.ShippingStreet,ShippingPostalCode=company.ShippingPostalCode,
Status__c='New',Type='Prospect',Acc_Created_From_Lead__c=TRUE,OwnerId=company.OwnerId));  
else
customAccounts.add(new Account(Company_Name__c = company.Id,BillingCountry=company.BillingCountry,BillingState=company.BillingState,BillingCity=company.BillingCity,BillingStreet=company.BillingStreet,BillingPostalCode=company.BillingPostalCode,
Name=company.Name,RecordTypeID=Label.Account_Prospect_RecordType_ID,ShippingCountry=company.ShippingCountry,ShippingCity=company.ShippingCity,ShippingState = company.ShippingState,ShippingStreet=company.ShippingStreet,ShippingPostalCode=company.ShippingPostalCode,
Status__c='New',Type='Prospect',Acc_Created_From_Lead__c=TRUE,OwnerId=company.OwnerId));  
}
//Added by Anjaneyulu for SFDC-2153 -- Ends
if(!customAccounts.isEmpty())
insert customAccounts;

for(Account a :customAccounts)
accountIdVsCustomAccountID.put(a.Company_Name__c, a.Id);

for(Opportunity opty : opportunityList){
if(String.isBlank(opty.Account__c) && String.isNotBlank(accountIdVsCustomAccountID.get(opty.AccountId))){
opty.Account__c= accountIdVsCustomAccountID.get(opty.Account__c);

}
}
}
}
}*/
    /* Author: Vinod Thupakula
Description: This method is used for to populate opportunity EAN value into Account EAN
JIRA:SFDC-1335
*/
    public static void updateAccountEAN(List<Opportunity> newOpportunities, Map<ID,Opportunity> oldOpportunities){
        List<Account> accounts = new List<Account>(); 
        List<Account> accounttypeupd=New List<Account>();
        List<ID> accounttypeid=New List<id>();
        Map<Id,String> accountIds = new Map<Id,String>();
        for(Opportunity newOpportunity : newOpportunities){   
            if(!accountIds.containsKey(newOpportunity.Account__c) && String.isNotBlank(newOpportunity.Account__c)
               && String.isNotBlank(newOpportunity.Email_Account_Num__c)  
               && newOpportunity.StageName == 'Closed Won' && (Trigger.IsInsert || (Trigger.isUpdate && oldOpportunities.get(newOpportunity.Id).StageName != 'Closed Won'))){
                   accountIds.put(newOpportunity.Account__c,newOpportunity.email_account_num__c);
               }   
            if(newOpportunity.Account__c!=Null && newopportunity.recordtypeid==system.label.opportuitygovernmentrecordtypeid && newopportunity.stagename=='Closed Won' &&(Trigger.isinsert||Trigger.isupdate))
            {
                accounttypeid.add(newOpportunity.Account__c);
                system.debug('Accountvalue'+accounttypeid);
            }
        }
        
        if(accountIds.size() > 0){
            for(Account accRecord : [Select Id, Email_Account_Num__c,Type,recordtypeid FROM Account WHERE Id IN:accountIds.keySet() and Email_Account_Num__c = '']){ 
                if(String.isBlank(accRecord.Email_Account_Num__c)){
                    accRecord.Email_Account_Num__c = accountIds.get(accRecord.Id);
                    accounts.add(accRecord); 
                }
                if(accRecord.recordtypeid==system.label.AccountGovernmentRecordTypeId){
                    accrecord.Type=system.label.Accounttypecustomer;
                    accounttypeupd.add(accRecord);
                    
                }
                
            }
            if(accounts != null && !accounts.isEmpty())
                OpportunityTriggerUpdates.opportunityAccountDML(accounts);
            //update accounts;
            
        }
        //Below code added by Raushan for SFDC-3018
        if(accounttypeid.size()>0){
            for(Account accupdate:[Select id,name,Type from Account where Id IN:accounttypeid]){
                system.debug('Account to be updated'+accupdate);
                accupdate.Type=system.label.Accounttypecustomer;  //Customer
                accounttypeupd.add(accupdate);
            }
            if((accounttypeupd.size()>0))
                OpportunityTriggerUpdates.opportunityAccountDML(accounttypeupd);
            //update accounttypeupd;
            system.debug('Updated Account'+accounttypeupd);
        }
        //SFDC-3018 ends here 
    }
    
    //Start : SFDC-1625
    /*
*
*/
    public static void populateSolutionEngineerOnOpportunity(Set<Id> closedOptyIds,Map<Id, Opportunity> oppNewMap) {
        
        List<Opportunity> oppList = [Select Id,Name,stageName,(Select Id,Name,TeamMemberRole,UserId From OpportunityTeamMembers Where TeamMemberRole = 'Solution Engineer' order by createddate desc) From Opportunity Where Id IN:closedOptyIds];
        
        for(Opportunity opp:oppList){
            if(opp.OpportunityTeamMembers.size() > 0){
                oppNewMap.get(opp.Id).SE_Approver__c = opp.OpportunityTeamMembers.get(0).UserId;
            }
            //Start : SFDC-2258 : Commented below code
            /*else{
oppNewMap.get(opp.Id).SE_Approver__c = Label.Second_Level_Approver;
}*/
            //End : SFDC-2258 : Commented above code            
        }    
    }     
    //End : SFDC-1625
    
    // Added by Anjaneyulu for SFDC-2821 -- Starts
    public static void updateOpportunitywithAccountDetails(){
        
        UPDATE_ACCOUNT_DETAILS = false;
        Map<Id,Id> oppIdVsaccountId = new Map<Id,Id>();
        string Prodaccid;
        for(Opportunity op : (List<Opportunity>)Trigger.new){
            Prodaccid= op.Account__c;
            if((String.isBlank(op.Account_Manager__c) || String.isBlank(op.Territory__c)) && String.isNotBlank(op.Account__c))
                oppIdVsaccountId.put(op.Id,op.Account__c);
            if(Trigger.isUpdate && op.Territory__c != ((Opportunity)Trigger.oldmap.get(op.Id)).Territory__c && String.isNotBlank(op.Account__c))
                oppIdVsaccountId.put(op.Id,op.Account__c);
            System.debug('op.Account__c....'+op.Account__c);
            System.debug('op.AccountId...'+op.AccountId);
            System.debug('oppIdVsaccountId....'+oppIdVsaccountId);
            // Added by Kartik for SFDC-3022 -- Starts
            /*    if(Trigger.isBefore && Trigger.isInsert){
if(op.Account__c!=null){
if(System.Label.GovernmentRecordTypes.contains(op.Recordtypeid)){
op.QuotingSystem__c = 'Datapipe'; 
}
}
}*/
            // Added by Kartik for SFDC-3022 -- Ends
            
        }
        list<account> Prodaccts = [Select Id,Territory__c,Account_Manager__c,Account_Manager__r.isActive from Account where Id =: Prodaccid];
        System.debug('Prodaccts.....'+Prodaccts);
        if(!oppIdVsaccountId.isEmpty()){
            Map<Id,Account> accounts = new Map<Id,Account>([Select Id,Territory__c,Account_Manager__c,Account_Manager__r.isActive from Account where Id in : oppIdVsaccountId.values()]);
            System.debug('accounts Account_Manager__c'+accounts.values());
            
            
            for(Opportunity op : (List<Opportunity>)Trigger.new){
                
                if(oppIdVsaccountId.containsKey(op.Id)&& Prodaccts.size()>0){
                    if(String.isNotBlank(accounts.get(oppIdVsaccountId.get(op.Id)).Territory__c))
                        op.Territory__c = accounts.get(oppIdVsaccountId.get(op.Id)).Territory__c;
                    
                    system.debug('op.Account_Manager__c'+op.Account_Manager__c);
                    System.debug('accounts.get(oppIdVsaccountId.get(op.Id)).Account_Manager__r.isActive'+accounts.get(oppIdVsaccountId.get(op.Id)).Account_Manager__r.isActive);
                    if(String.isBlank(op.Account_Manager__c) && accounts.get(oppIdVsaccountId.get(op.Id)).Account_Manager__r.isActive)
                    {
                        op.Account_Manager__c = accounts.get(oppIdVsaccountId.get(op.Id)).Account_Manager__c;
                        System.debug('op.Account_Manager__c'+op.Account_Manager__c);
                    }
                }
            }
        }
    }
    
    // Added by Anjaneyulu for SFDC-2821 -- Ends
    //Added By:Ashok for SFDC-2922
    public static void mappedForecastBucketField(List<Opportunity> opps){
        if(opps != null && opps.size() > 0){  
            Map<String,List<String>> picklistValues = ApexDependentPicklistUtility.getDependentOptions('Opportunity','Type','Forecast_Bucket__c');
            system.debug('picklistValues---->'+picklistValues);
            for(Opportunity opp : opps){
                system.debug('oppType'+opp.Type);
                system.debug('picklistValues.containsKey(opp.Type)'+picklistValues.containsKey(opp.Type));
                //system.debug('picklistValues.get(opp.Type).size()>0'+picklistValues.get(opp.Type).size());
                if(picklistValues.containsKey(opp.Type) && picklistValues.get(opp.Type).size()>0){
                    system.debug('PicklistValue'+picklistValues.get(opp.Type)[0]);
                    opp.Forecast_Bucket__c = picklistValues.get(opp.Type)[0]; 
                } 
                else{
                    system.debug('qwertyTest');
                    opp.Forecast_Bucket__c='';}
            } 
        }    
    }
    //added by Raushan for SFDC-2780
    Public static void updateMRRonAccount(){
        /* Set<ID> accid=new Set<ID>();
List<Account> acclisttoupdate=new List<Account>();
if(Trigger.isinsert|| Trigger.isUpdate){
for(Opportunity opp:(List<opportunity>) Trigger.new){
if(opp.Account__c!=Null&& opp.type==system.label.opportunitytype)
accid.add(opp.Account__c);
}
}
if(Trigger.isdelete){
for(Opportunity opp:(List<opportunity>) Trigger.old){
if(opp.Account__c!=Null&& opp.type==system.label.opportunitytype)
accid.add(opp.Account__c);
}
}
List<Account> acclist=new List<Account>([select id,name, Total_MRR__c,(select id,name,type,StageName,Approval_Amount__c, DP_AWS_Azure_Managed_Services_Fee__c, DP_AWS_Azure_Services__c ,DP_AWS_Azure_Gross_MRR__c, DP_Supplemental_MRR__c, DP_Opportunity_Amount__c from opportunities__r where type='Rackspace Cloud') from Account where Id In: accid]);
for(Account acc:acclist){
List<opportunity> opplist=acc.opportunities__r;
acc.Total_MRR__c=0;
system.debug('Opportunity List'+opplist);
for(opportunity opp:opplist){
if((opp.type=='Azure' && opp.StageName=='Closed Won')||(opp.type!='Azure')){
if((opp.Approval_Amount__c>0)){
if(opp.DP_Supplemental_MRR__c==null){
acc.Total_MRR__c=acc.Total_MRR__c+ opp.Approval_Amount__c + opp.DP_AWS_Azure_Gross_MRR__c;
}
else{
acc.Total_MRR__c=acc.Total_MRR__c+ opp.Approval_Amount__c + opp.DP_AWS_Azure_Gross_MRR__c+ opp.DP_Supplemental_MRR__c;

}
}
else {
if(opp.DP_Supplemental_MRR__c==null){
acc.Total_MRR__c=acc.Total_MRR__c + opp.DP_AWS_Azure_Gross_MRR__c;
}
else{
acc.Total_MRR__c=acc.Total_MRR__c + opp.DP_AWS_Azure_Gross_MRR__c+ opp.DP_Supplemental_MRR__c;
}
}
}
else{
if(opp.DP_Supplemental_MRR__c==NULL){
acc.Total_MRR__c=acc.Total_MRR__c + opp.DP_AWS_Azure_Gross_MRR__c;
}
else{
acc.Total_MRR__c=acc.Total_MRR__c + opp.DP_AWS_Azure_Gross_MRR__c+opp.DP_Supplemental_MRR__c ;
}
}

}
acclisttoupdate.add(acc);
system.debug('acclisttoupdate'+acclisttoupdate);
}try{
update acclisttoupdate;
}catch(exception e){}
*/
    }
    //Added by Raushan for SFDC-2780 --Ends
    //Added By Divya For SFDC-3283 -- Starts 
    public static void UpdateIsInstallBase(){
        Map<ID, Account> accountsMap = new Map<ID, Account>();
        Map<Id,Opportunity> oldOpps = (Map<Id,Opportunity>)Trigger.oldMap;
        Set<Id> accountIds = new set<Id>();
        for(Opportunity opp:(List<Opportunity>)Trigger.new) {
            if(String.isNotBlank(opp.Account__c) 
               && ((Trigger.isInsert && opp.Agreement_Activated__c)
                   || (trigger.isUpdate && oldOpps.get(opp.Id)!= null && oldOpps.get(opp.Id).Agreement_Activated__c !=opp.Agreement_Activated__c ) ))accountIds.add(opp.Account__c);  
        } 
        
        if(!accountIds.isEmpty()){
            List<Account> updateAccounts = new List<Account>();
            accountsMap =new Map<Id, Account>([Select Id, Is_Install_Base__c,(Select Id, Agreement_Activated__c from opportunities__r where Agreement_Activated__c=true limit 1) from Account where ID IN : accountIds]);       
            //acc ids
            for(Opportunity Opsli:(List<Opportunity>)Trigger.new){
                if(Opsli.Agreement_Activated__c){
                    if(!accountsMap.get(Opsli.Account__c).Is_Install_Base__c)
                        updateAccounts.add(new Account(Id = Opsli.Account__c,Is_Install_Base__c = True));
                }
                else{ 
                    if(accountsMap.get(Opsli.Account__c).Opportunities__r.size()>0){ 
                        updateAccounts.add(new Account(Id = Opsli.Account__c,Is_Install_Base__c = True));                             
                    }
                    else{
                        updateAccounts.add(new Account(Id = Opsli.Account__c,Is_Install_Base__c = False));
                    }
                }                                         
            } 
            if(!updateAccounts.isEmpty())
                Update updateAccounts;
        }
    }    
    //Added By Divya For SFDC-3283 -- Ends
    //Below method was created for US3569, Whenever someone trie to open a closed lost opportunity then below method will execute
    Public static void reOpenclosedlost(){
        for(opportunity opp:(list<opportunity>)trigger.new){
            opportunity oppstage =(opportunity)trigger.oldmap.get(opp.id);
            opportunity oppstagenew=(opportunity)trigger.Newmap.get(opp.id);
            if(oppstage.stagename.equals('Closed Lost')&&opp.ownerid!=userinfo.getuserid()&&oppstage.stagename!=oppstagenew.stagename&&(UserInfo.getProfileId()!=system.label.Sales_ops_Admin_Profile)&&(UserInfo.getProfileId()!=system.label.Admin_Profile)){
                opp.adderror('Only Opportunity Owners can Reopen a Closed Lost Opportunity');
            }
            else             
            {
                if(oppstage.stagename.equals('Closed Lost')&&(opp.ownerid==userinfo.getuserid()||UserInfo.getProfileId()!=system.label.Sales_ops_Admin_Profile || UserInfo.getProfileId()!=system.label.Admin_Profile)&&oppstage.stagename!=oppstagenew.stagename){
                    opp.stageName='Stage 3 - Proposal & Quote';
                    opp.OpportunityReopen__c =True;
                    opp.recordtypeid=oppstagenew.prior_record_type__c;
                    opp.prior_stage_name__c=oppstage.stagename;
                }
            }
        }
    }
    //added for SFDC-5595 Gross margin validation, samba
    ////Refactored Below Method for SFDC-7331
    //public static void grossMarginValidation(List<Opportunity> opplist,boolean isValidation){
    public static void grossMarginValidation(List<Opportunity> opplist,boolean isValidation,Set<Id> grossMarginOppOwners){
        //system.debug('In grossMarginValidation........'+isValidation);
        if(isValidation && isloggeduserNotAdmin()){
            
            //if((!System.Label.OptyReadOnlyRecordTypeId.contains(opp.RecordTypeId) && opp.type != 'Mail Contract Signup' &&  opp.type != 'Mail Online Signup' && opp.type != 'Revenue Ticket'  && opp.type != 'RBU' && opp.type != 'Renewal' && opp.Category__c != 'Renewal' && opp.Region__c=='APAC' && !System.Label.Sales_ops_Admin_Profile.contains(UserInfo.getProfileId()) && !System.Label.System_Admin_Integration_Profiles.contains(UserInfo.getProfileId()) && (opp.Amount > 0 || (opp.Approval_Amount__c > 0 && !System.Label.Opp_Professional_Service_Record_TypeId.contains(opp.RecordTypeId) && opp.QuotingSystem__c !='Datapipe' && opp.Acquisition__c !='Datapipe'))) && (opp.StageName== 'Stage 1 - Planning & Identification' || opp.StageName== 'Stage 2 - Opportunity Development' || opp.StageName== 'Stage 3 - Proposal & Quote' || opp.StageName== 'Stage 4 - Negotiation & Quote Mod' || opp.StageName== 'Stage 5 - Closing the Business' ) && (opp.Gross_Margin_Min__c == 0 || opp.Gross_Margin_Min__c == null || opp.Gross_Margin_Max__c  == 0 || opp.Gross_Margin_Max__c == null) ){
            
            //opp.adderror('Please populate both “Gross Margin Min and Max” with a percentage greater than zero..');
            
            //system.debug('opp.RecordTypeId........'+opp.RecordTypeId);
            
            string grossMarginErrorMessage;
            Map<Id,User> grossMarginOppOwnersMap;
            
            if (!grossMarginOppOwners.isEmpty()) {
                
                grossMarginOppOwnersMap = new Map<Id,User>([SELECT Id, Name,ProfileId,Region__C FROM User WHERE Id IN :grossMarginOppOwners]);
                
                for(Opportunity opp : opplist){
                    grossMarginErrorMessage=getGrossMarginError(opp,grossMarginOppOwnersMap);
                    if (string.isNotBlank(grossMarginErrorMessage) ) {
                        opp.adderror(grossMarginErrorMessage);
                        return ;
                    }
                }
                
                
                
            }
        }
    }
    
    
    //Added this method for SFDC-7331 to Error Messages based on Opp Conditions
    public static string getGrossMarginError(Opportunity opp,Map<Id,User> grossMarginOppOwnersMap) {
        string returnErrorMessage='';
        List<String> oppCategoryNotReqForGrossMargin = System.Label.OppCategoryNotReqForGrossMargin.Split(',');
        List<String> oppTypeNotReqForGrossMargin = System.Label.OppTypeNotReqForGrossMargin.Split(',');
        List<String> optyINTLRecordTypeIds = System.Label.OptyINTLRecordTypeIds.Split(',');
        /*If Opp is Not closed and Type not in 'Mail Contract Signup,Mail Online Signup,Revenue Ticket,RBU,Renewal' 
		and Category Not in 'Renewal' then proceed validation conditions for Error Message
		Else return blank string */
        if(grossMarginOppOwnersMap.get(opp.OwnerId)!=null
           && !oppTypeNotReqForGrossMargin.contains(opp.type)
           && !oppCategoryNotReqForGrossMargin.contains(opp.Category__c)
           && !opp.isclosed
           && opp.Amount!=null)
        {
            //  system.debug('-------amountInUSD(opp.CurrencyIsoCode,opp.Amount)----'+amountInUSD(opp.CurrencyIsoCode,opp.Amount));
            //  system.debug('-------amountInUSD(opp.CurrencyIsoCode,opp.Approval_Amount__c)----'+amountInUSD(opp.CurrencyIsoCode,opp.Approval_Amount__c));
            Boolean amouncanupdatebywf=false;
            
            System.debug('opp.owner.ProfileId  '+ grossMarginOppOwnersMap.get(opp.OwnerId).ProfileId);
            Decimal grossminValueholder=(opp.Gross_Margin_Min__c == null || opp.Gross_Margin_Min__c==0 ) ? 0 : opp.Gross_Margin_Min__c;//Storing value as Zero if Gross Margin Min is Zero or Null
            Decimal grossmaxValueholder=(opp.Gross_Margin_Max__c == null || opp.Gross_Margin_Max__c==0 ) ? 0 : opp.Gross_Margin_Max__c;//Storing value as Zero if Gross Margin Max is Zero or Null
            System.debug('not req cat--'+oppCategoryNotReqForGrossMargin+'--not req type--'+oppTypeNotReqForGrossMargin);
            
            /*when the above conditions match amount will be updated by workflow with Approval_Amount__c value,
			so we are checking if Approval amount is >0 and this condition matches we consider it as amount > 0 */
            /*  if(!System.Label.Opp_Professional_Service_Record_TypeId.contains(opp.RecordTypeId) && opp.QuotingSystem__c !='Datapipe' && opp.Acquisition__c !='Datapipe')
				{
					amouncanupdatebywf = true;  
				} */
            /*If Owner Region is APAC and Gross MIN or MAx value Zero and AMount >0 then Validation will occur for 
			*Gross Margin Min and Max
			*Else-If Owner Region is EMEA and Gross MIN value Zero and AMount >5000 and Opp Record type Includes 
			*INTL RECORD TYPE and Owner Profile is Rackspace Seller INTL then Validation
			*will occur for Gross MarginMin */
            // && ((opp.Amount > 0  && !amouncanupdatebywf ) || (opp.Approval_Amount__c > 0 && amouncanupdatebywf )))
            if (grossMarginOppOwnersMap.get(opp.OwnerId).region__c=='APAC' 
                && (grossminValueholder==0 || grossmaxValueholder==0)
                && ((opp.Amount > 0 )))
            {
                returnErrorMessage=System.label.Gross_Margin_Min_and_Max_are_Required;
            } 
            else if (grossMarginOppOwnersMap.get(opp.OwnerId).region__c=='EMEA' 
                     && System.Label.Rackspace_Seller_INTL_PID.contains(grossMarginOppOwnersMap.get(opp.OwnerId).ProfileId)
                     && optyINTLRecordTypeIds.contains(opp.RecordTypeId)
                     && grossminValueholder==0
                     && (amountInUSD(opp.CurrencyIsoCode,opp.Amount) > 5000  ) )           {
                         returnErrorMessage=System.label.Gross_Margin_Min_Required; 
                     }
        }
        return returnErrorMessage;
        
    }
    
    
    //Added this method for SFDC-7331 to check logged user is not Admin
    public static Boolean  isloggeduserNotAdmin() {
        return (!System.Label.Sales_ops_Admin_Profile.contains(UserInfo.getProfileId())
                && !System.Label.System_Admin_Integration_Profiles.contains(UserInfo.getProfileId())); 
        
        
    }
    
    //Added this method for SFDC-7331 to  convert the amount to USD
    public static decimal  amountInUSD(String CurrencyIsoCode,Decimal Amount) {
        return CurrencyUtility.getConvertedAmount(CurrencyIsoCode,Amount,2);
    }
    
    //Start SFDC-6302  
    @future (callout=true)  
    public static void PostDataWebhookRSVCOpportunities(Set<Id> oppIds)  {
        try{
            List<Opportunity> oppList = [Select Id,name,ddi__c,quote_id__c from opportunity where Id IN:oppIds];
            if(oppList.size() >0 )
                RsvcWebhookHandler.postDataToWebhook(oppList);
        }catch(Exception e){
            
            cLog__c clogRec = new cLog__c();
            clogRec.Name = 'RSVC Error' ;
            clogRec.Action_Name__c = 'RSVC Web hook';
            clogRec.Error_Description__c = e.getMessage();
            Insert clogRec;
        } 
    }
    
    //end SFDC-6302
    
    /********************************************************************
// Purpose              : Update Owner Region
// Author               : Rishabh
// Parameters           : 
//  Returns             : void
//JIRA Reference        : SFDC-7446 - Update Owner region field when an Opportunity owner is updated
********************************************************************/ 
    public static void updateOwnerRegion(Map<Id, SObject> newSObjMap, Map<Id, SObject> oldSObjMap){
        
        Map<Id, Opportunity> newMap = (Map<Id, Opportunity>) newSObjMap;
        Map<Id, Opportunity> oldMap = (Map<Id, Opportunity>) oldSObjMap;
        
        for(Opportunity opp: newMap.values()){
            if(oldMap.get(opp.Id).OwnerId != opp.OwnerId){
                opp.Region__c = opp.OppOwnerRegion__c;
            }
        }   
    }
}