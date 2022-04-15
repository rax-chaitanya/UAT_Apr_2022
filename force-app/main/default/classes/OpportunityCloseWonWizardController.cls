/////////////Updated with Custom Setting and isCACEnable Flag/////////////////
//@story: SFDC-7067, @Dev: Caleb Garcia, @description: fixing defect on 6974, Only an account contact role of 'primary contact' will trigger error message. Re-ordered Billing contact validation before RPN validation. @date: 1/5/2021
//@story: SFDC-6974, @Dev: Caleb Garcia , @description: when Account Type is Prospect where Account Primary Contact has RPN populated an error message will be triggered, @date: 11/29/2021
//@story: SFDC-7060, @Dev: Rishabh Anand, @description: Customer Account currency switched back to USD 
//@story: SFDC-7064, @Dev: Someshwar Ponugoti, @description: Opportunity not able to close if a case is attached to Standard company 
//@story: SFDC-7069, @Dev: Rishabh Anand, @description: Govt Cloud accounts are setting up as Customer accounts once a cloud Opp gets closed won
//@story: SFDC-7006, @Dev: Atheer Bdaiwi, @description: Auto DDI creation functionality for RBU record type, @date: 03 Feb 22.
public without sharing class OpportunityCloseWonWizardController extends Framework {
    
    
    public Integer pageNumber {get; set;}    
    public Opportunity opportunity {get; set;}  // opportunity the end user is doing operations on
    public Account company {get; set;}          // company related to the opportunity
    public Account account {get; set;}      // account related to the opportunity   
    public Account accDDI {get; set;}       // an account whose DDI matches the opportunity DDI   
    public String redirectURL {get; set;}   
    public Set<Id> contactListDDICreation = new Set<Id>();
    public boolean setrscloud=false;
    public string oldOptyDDI {get; set;} //Samba, SFDC-6218, created to store old DDI of Opty before user enter DDI on step 2
    
    /* account contact roles underneath the account
issued as its own query because it needs to be queried again to display updated, deleted results */
    public List<Accountcontactrelation> AccContList {get; set;}       
    public List<Opportunity> RSOppList {get; set;}
    public LIst<Task> RSTaskList {get; set;}
    public LIst<Event> RSEventList {get; set;}    
    //pg1
    public Boolean showInfo {get; set;}    //pg 2
    public BOolean StrAccContsec {get; set;}
    public Boolean StrNewCont {get; set;}    
    public AccountContactRelation AccContRole  {get; set;}
    public Boolean StrNewContRole {get; set;}
    public Contact contact {get; set;}
    public Boolean StrEditContRole {get; set;}    
    public Accountcontactrelation EditAccContRole  {get; set;}
    public String recordID {get; set;}
    //pg2
    public String RpnPrimCon;  //@story: SFDC-7067: string variable created to be assigned account contact role ID. Replaces extra SOQL.
    //pg 3
    public List <Quote__c> QuoteList {get; set;}
    public Quote__c primaryQuote {get; set;}
    public String quoteID {get; set;}
    
    //pg5
    public Accountcontactrelation primaryCont {get; set;}
    //Variables to set CAC custom setting data, Start
    public Boolean isCACEnable {get; set;}
    public string CACAccountType;
    
    public string  USCloudRecordType;
    public list<string>  USCloudTypes = new list<string>();
    public set<string> USCloudTypesSet = new set<string>();
    
    public string INTLCloudRecordType;
    public list<string>  INTLCloudTypes = new list<string>();
    public set<string> INTLCloudTypesSet = new set<string>();
    
    public string GovernmentRecordType;
    public list<string>  GovernmentTypes = new list<string>();
    public set<string> GovernmentTypesSet = new set<string>();
    
    public string        RBURecordType;                       //SFDC-7006 - used to create Opp with RBU Record Type
    public list<string>  RBUTypes       = new list<string>(); //SFDC-7006 - Add all Opps in the list 
    public set<string>   RBUTypesSet    = new set<string>();  //SFDC-7006 - Set will contain RBU Type
    
    //Variables to set CAC custom setting data, End
    
    //SFDC-2565
    public Accountcontactrelation billingCont {get; set;}
    public OpportunityCloseWonWizardController() {
        super('OppCloseWonWizardUS1');
        AccContRole = new AccountContactRelation();
        contact = new Contact();        
        company = new Account();
        redirectURL = '';
        
        setVariables(apexpages.currentpage().getparameters().get('id'), ApexPages.CurrentPage().getParameters().get('aid') );
        setPageNumber();        //set page number which may override initial page number given at the beginning in the super() method
        
        //CAC custom setting data setup, samba, Start
        //Getting US CLoud record type custom setting data
        if(CAC_Custom_Setting__c.getAll().containsKey('CACSettingUSCloud')){
            CACAccountType = CAC_Custom_Setting__c.getInstance('CACSettingUSCloud').AccountType__c;
            USCloudRecordType = CAC_Custom_Setting__c.getInstance('CACSettingUSCloud').OpportunityRecordType__c;
            USCloudTypes = CAC_Custom_Setting__c.getInstance('CACSettingUSCloud').OpportunityTypes__c.split(',');
            
            if(USCloudTypes.size()>0){
                USCloudTypesSet.addall(USCloudTypes);
            }
        }
        //Getting INTL CLoud record type custom setting data
        if(CAC_Custom_Setting__c.getAll().containsKey('CACSettingINTLCloud')){
            CACAccountType = CAC_Custom_Setting__c.getInstance('CACSettingINTLCloud').AccountType__c;
            INTLCloudRecordType = CAC_Custom_Setting__c.getInstance('CACSettingINTLCloud').OpportunityRecordType__c;
            INTLCloudTypes = CAC_Custom_Setting__c.getInstance('CACSettingINTLCloud').OpportunityTypes__c.split(',');
            
            if(INTLCloudTypes.size()>0){
                INTLCloudTypesSet.addall(INTLCloudTypes);
            }
        }
        //Getting INTL CLoud record type custom setting data
        if(CAC_Custom_Setting__c.getAll().containsKey('CACSettingGovernment')){
            CACAccountType = CAC_Custom_Setting__c.getInstance('CACSettingGovernment').AccountType__c;
            GovernmentRecordType = CAC_Custom_Setting__c.getInstance('CACSettingGovernment').OpportunityRecordType__c;
            GovernmentTypes = CAC_Custom_Setting__c.getInstance('CACSettingGovernment').OpportunityTypes__c.split(',');
            
            if(GovernmentTypes.size()>0){
                GovernmentTypesSet.addall(GovernmentTypes);
            }
        }
        
        if(CAC_Custom_Setting__c.getAll().containsKey('CACSettingRBU')){
            
            CACAccountType = CAC_Custom_Setting__c.getInstance('CACSettingRBU').AccountType__c;
            RBURecordType  = CAC_Custom_Setting__c.getInstance('CACSettingRBU').OpportunityRecordType__c;
            RBUTypes       = CAC_Custom_Setting__c.getInstance('CACSettingRBU').OpportunityTypes__c.split(',');
            
            if(RBUTypes.size()>0){
                RBUTypesSet.addall(RBUTypes);
            }
        }
        
        if((opportunity.RecordType.Name == RBURecordType && RBUTypesSet.contains(opportunity.Type)) ||
           (opportunity.RecordType.Name == USCloudRecordType && USCloudTypesSet.contains(opportunity.Type)) ||
           (opportunity.RecordType.Name == INTLCloudRecordType && INTLCloudTypesSet.contains(opportunity.Type)) ||
           (opportunity.RecordType.Name == GovernmentRecordType && GovernmentTypesSet.contains(opportunity.Type))){
               isCACEnable = true;
           } else {
               isCACEnable = false;
           }
        
        //CAC custom setting data setup, samba, End
        goToPage();
        setAccDDI();
        copyAccountDDitoOpty();
        oldOptyDDI = opportunity.DDI__c;
        resetCACFields(); //@story: SFDC-6666, @desc: Added here to reset once closed won wizard loads so this will initially reset fields values. Page 3 will have a fresh request to start autoDDI.   
    }
    
    //Added Samba for 6218, Start
    public void copyAccountDDitoOpty() {
        if (String.isBlank(opportunity.DDI__c) && String.isNotBlank(account.DDI__c) && Account.Type=='Cloud Customer'){
            try {
                opportunity.DDI__c = account.DDI__c;
            } catch (Exception e) {
                system.debug('Exception throwing in copyAccountDDitoOpty ');
            }        
        }
    }
    
    //Added Samba for 6218, End
    public Boolean getIsPartnerInvolved() {
        return (opportunity.Was_a_Partner_Involved__c == 'Yes') ? true : false;
    }
    
    public void setAccDDI() {
        if (String.isNotBlank(opportunity.DDI__c)) {
            try {
                String oppDDI = opportunity.DDI__c;
                accDDI = Database.query(queryBuilder.getQueryString(VF_Query_Manager__c.getInstance('OWC-2').Query_Id__c));
            } catch (Exception e) {
                accDDI = null;
            }        
        }
    } 
    
    //@story: SFDC-6666, @dev: Caleb Garcia, @desc: method to reset mulesoft integration fields
    public void resetCACFields(){
        if(isCACEnable && account.Type == 'Prospect'  && string.isBlank(opportunity.DDI__c)){
            opportunity.Integration_Status__c = null;
            opportunity.Integration_Status_Code__c = '';
            opportunity.MuleSoft_Acknowledge__c = false;
        }
    }
    
    //SFDC-2565
    public void LoadAccRoles(){
        String accountId = account.id;
        AccContList = Database.query(queryBuilder.getQueryString(VF_Query_Manager__c.getInstance('OWC-5').Query_Id__c));
        set<id> accid=new set<id>();
        for(Accountcontactrelation ac:AccContList){
            accid.add(ac.id);
        }
        primaryCont = new Accountcontactrelation();
        billingCont  = new Accountcontactrelation();
        boolean flag =true;
        boolean flag1 =true;
        string primaryacr;
        List<string> accrole=new list<string>();
        list<string> accs=new list<string>();
        for (Accountcontactrelation acr : AccContList) {
            
            if(acr.roles!=null){
                primaryacr=acr.roles;            
                accrole=primaryacr.split(';');          
            }          
            for(string ac:accrole){
                accs.add(ac);
                if(ac=='Primary Contact'){
                    primaryCont = acr;
                    flag = false;
                }
            }
            
            if(flag1 && acr.Roles == 'Billing'){
                //conbillingCont=acr.contactid;
                billingCont = acr;
                flag1 = false;
            }
        }
    }    
    
    
    public void setVariables(String opportunityId, String accountId) {
        account = new Account();
        opportunity = new Opportunity();
        AccContList = new List<Accountcontactrelation>();
        if (String.isNotBlank(accountId)) {
            account = Database.query(queryBuilder.getQueryString(VF_Query_Manager__c.getInstance('OWC-9').Query_Id__c));
            if(account.Opportunities__r[0]!=null){
                opportunity = account.Opportunities__r[0]; 
            }
            loadAccRoles();
        } else {
            if(String.isNotBlank(opportunityID)){
                opportunity = Database.query(queryBuilder.getQueryString(VF_Query_Manager__c.getInstance('OWC-1').Query_Id__c));
            }
            if (String.isBlank( opportunity.Account__c) ) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No account was found on this opportunity.'));
            } else {
                accountId = opportunity.Account__c;
                account = Database.query(queryBuilder.getQueryString(VF_Query_Manager__c.getInstance('OWC-9').Query_Id__c));
                loadAccRoles();
            }
        }   
    }
    
    
    public PageReference cancel() {
        return new PageReference('/'+ opportunity.id);
    }
    
    
    public PageReference NewContRole() {
        StrNewCont=true;
        StrNewContRole = StrEditContRole = StrAccContSec = false;
        return null;
    }
    
    public PageReference NewContWithRole() {
        StrNewContRole = true;
        StrNewCont = StrEditContRole = StrAccContSec = false;
        return null;
    }
    
    public void editAccCont() {
        StrEditContRole=true;
        StrNewCont = StrNewContRole = StrAccContSec = false;
        setEditAccContRole();
    }    
    
    public void NewContCancel() {
        StrNewCont= StrNewContRole = StrEditContRole = false;
        StrAccContsec=true;
    }    
    
    public void setQuoteList() {
        try {
            String string_var_1 = opportunity.id;
            Boolean string_var_2 = true;            
            quoteList = Database.query(queryBuilder.getQueryString(VF_Query_Manager__c.getInstance('OWC-4').Query_Id__c));   
        }catch (exception e) {
            quoteList = new list<Quote__c>();
        }
    }
    
    public void setPageNumber() {
        pageNumber = 1;
        showInfo = true;
        //Anitha RecordType.Name
        try {
            pageNumber = (Integer) [Select ID, Name, Account_RT_Name__c, Opportunity_RT_Name__c, Opportunity_Type__c, Page_Number__c from Opportunity_Close_Won_Page_Setting__c WHERE
                                    Account_RT_Name__c = :account.RecordType.DeveloperName AND opportunity_Rt_name__c = :opportunity.RecordType.Name AND Opportunity_Type__c = :opportunity.type].Page_Number__c;
        } catch (Exception e ) {
            pageNumber = 0;
            
        }
    }
    
    
    public Accountcontactrelation getEditAccContRole() {
        return EditAccContRole;
    }
    
    //queried because it loads faster in the dynamic apex component rather than referencing it via map...
    public Accountcontactrelation  setEditAccContRole() {
        try {            
            for (Accountcontactrelation acr : acccontlist) {               
                if (acr.id == recordID) {
                    EditAccContRole = acr;
                    break;
                }
            }
            return EditAccContRole;
        } catch (Exception e) {
            ExceptionHandler.postToAll(e, false);
            return EditAccContRole;
        }
    }    
    
    
    public String getProfileName() {
        Id profileId = userinfo.getProfileId();
        return ( (Profile) Database.query(queryBuilder.getQueryString(VF_Query_Manager__c.getInstance('OWC-11').Query_Id__c)) ).Name ;
    }    
    
    public List<FieldMapping__c> getFieldMapping(String name) {
        return Database.query(queryBuilder.getQueryString(VF_Query_Manager__c.getInstance('OWC-10').Query_Id__c));
    }
    
    public Id getCustomerRecordTypeId() {
        String name = 'Customer';
        String sObjectType = 'Account';
        RecordType rt = Database.query(queryBuilder.getQueryString(VF_Query_Manager__c.getInstance('OWC-14').Query_Id__c));
        return rt.id;   
    }
    
    public String getEConnectDocumentsURL() {
        String url;
        if (UserInfo.getOrganizationId() == ProdOrgIDSetting__c.getInstance().ProdOrgID__c) {
            url = Label.eConnect_Documents;
        } else {
            url = Label.eConnect_Documents_Staging;
        }
        url = url.replace(':OPPORTUNITYID', opportunity.id);
        return url;        
    }
    
    public String getRaptorDocumentsURL() {
        String url;
        if (UserInfo.getOrganizationId() == ProdOrgIDSetting__c.getInstance().ProdOrgID__c) {
            url = Label.Raptor_Documents;
        } else {
            url = Label.Raptor_Documents_Staging;
        }
        url = url.replace(':OPPORTUNITYID', opportunity.id);
        return url;
    }
    
    //Method return type changed to void from PageReference by venkat 
    public void save() {
        Savepoint sp = Database.setSavepoint();
        
        try {
            list<account> compToDeleteList = new list<account>();
            list<Contact> contactsToUpdateCmp = new list<Contact>();
            List<SObject> UpdateTasklist = new List<SObject>();
            List<SObject> UpdateEventlist = new List<SObject>();
            List<SObject> UpdateChilds= new List<SObject>();
            List<SObject> prodAccountsToUpdate= new List<SObject>();
            list<Sobject> realignMentRequestItemToUpdate = new List<Sobject>();
            list<AccountTeamMember> atmList = new list<AccountTeamMember>();
            boolean isCustomerRecordType = false;
            integer prospectAccSize = 0;
            String Cmpid;
            
            String profileName = getProfileName();
            
            //SFDC-7069 Starts
            if(isCACEnable){    
                setAccDDI();
            }
          
            if(isCACEnable && opportunity.RecordType.Name =='Government'&& accDDI == null){
                Opportunity oppDDI = [SELECT Id,DDI__c,MuleSoft_Acknowledge__c,Integration_Status__c,
                                      Integration_Status_Code__c,Is_FutureJob_Running__c,
                                      RecordType.Name,Account__r.Recordtype.name 
                                      FROM Opportunity WHERE Id = :opportunity.Id];
                
                if(oppDDI.DDI__C != null){
                    opportunity.DDI__C=oppDDI.DDI__C;
                }
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Customer account creation in progress, please try again after 30 seconds.');
                ApexPages.addMessage(myMsg);
                return;
            } 
            //SFDC-7069 Ends
            
            List<SObject> toUpdate = new List<SObject>();               //make list of SObjects to do 1 DML instead of 5+
            opportunity oppid1=[select id,DDI__c,Integration_Status__c,Is_FutureJob_Running__c,Integration_Status_Code__c,Mulesoft_Acknowledge__c,RecordType.Name,ownerid,Accountid,stageName from opportunity where id=:opportunity.id];
            
            // @Dev         : Caleb Garcia
            // @date        : 10/25/2021
            // @story       : SFDC-6666
            // @description : Integration status code, Integration status and MuleSoft Acknowledgement fields are reset after every attempt.
            //Added integration_status_code__c == '503' || '500' || '400' || '401' Condition to trigger Integration again, Samba for 6218 & 6666, Start>>>
            if((oppid1.Integration_Status_Code__c == '503'|| oppid1.Integration_Status_Code__c == '500'|| oppid1.Integration_Status_Code__c == '400' ||
                oppid1.Integration_Status_Code__c == '401' || oppid1.Integration_Status__c == 'Failure') && !oppid1.Is_FutureJob_Running__c && account.Type == 'Prospect' && isCACEnable){
                    //start ddi creation
                    DDIAccountSignUpOnOptyCloseWon.autoCreateDDIAccountFuture(oppid1.Id,contactListDDICreation);
                }//SFDC-6666 continues line 1086
            Savepoint sp12 = Database.setSavepoint();
            if(isCACEnable){    
                setAccDDI();
            }
            opportunity oppid=[select id,DDI__c,Integration_Status__c,Integration_Status_Code__c,Mulesoft_Acknowledge__c,RecordType.Name,ownerid,Accountid,stageName,Is_FutureJob_Running__c from opportunity where id=:opportunity.id];
            //SFDC-6666, @desc: added integration status 'Failure' criteria
            if(isCACEnable && Opportunity.Integration_Status_Code__c != '' && !oppid.Is_FutureJob_Running__c && Opportunity.Integration_Status__c == 'Failure'){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Automatic DDI generation is failed due to Network Issue, please try after 30 Seconds. If the problem persist after the 3rd attempt please contact a Rackspace Salesforce Administrator.');
                ApexPages.addMessage(myMsg);
                return;
            }
            
            String str = 'Administrator'; 
            /*SFDC-6000*/
            opportunity.StageName=oppid.stageName;
            
            list<Account> ddiacc=new list<Account>();            
            ddiacc=[Select id,DDI__c,Company_Name__c from Account where DDI__C=:oppid.DDI__c and DDI__c !=null limit 1]; 
            
            if(ddiacc.size()==0 && oppid.Is_FutureJob_Running__c && isCACEnable){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.DDIgenerationinProgress);
                ApexPages.addMessage(myMsg); 
                Database.rollback(sp12); 
                return; 
            }else if(isCACEnable) {
                opportunity.DDI__c=oppid.DDI__c;
                opportunity.Integration_Status__c=oppid.Integration_Status__c;
                setAccDDI();
            }
            
            if (accDDI == null)
            {
                Account acc_company =new Account();
                for (FieldMapping__c fm : getFieldMapping('OpportunityWonController-save%')) {
                    acc_company.put(fm.TargetField__c, Reusable.getValue(account, fm.SourceField__c)); 
                }     
                
                //Added By: Vinod Thupakula
                //SFDC-2510   
                if (account.RecordType.DeveloperName == 'Prospect') {
                    account.Type = 'Customer';
                    account.RecordTypeId = Label.GovernmentRecordTypes.contains(account.RecordTypeId) ? account.RecordTypeId : getCustomerRecordTypeId();                   
                }
                account.FocusArea__c = opportunity.Focus_Area__c;               
                update account;
            }
            else {
                
                Account oppcompany=[select id,ownerid,CurrencyIsoCode from Account where id=:accDDI.Company_Name__c];
                opportunity.Account__c = accDDI.id; 
                /***SFDC-5806****/                
                accDDI.Ownerid=oppid.ownerid;
                oppcompany.ownerid=oppid.ownerid;
                oppcompany.CurrencyIsoCode = account.Company_Name__r.CurrencyIsoCode;// SFDC -7060
                accDDI.CurrencyIsoCode = account.CurrencyIsoCode;// SFDC -7060
                updateCase(oppcompany,oppid,accDDI);//SFDC-7064
                update oppcompany;
                /***SFDC-5806****/
                if(account.Type == 'Prospect' 
                   && (opportunity.RecordType.Name == USCloudRecordType ||
                       opportunity.RecordType.Name == INTLCloudRecordType || 
                       opportunity.RecordType.Name == GovernmentRecordType ||
                       opportunity.RecordType.Name == RBURecordType) && (Label.CloudOpportunityTypes.contains(opportunity.type) ||
                                                                         Label.Manual_Merge_Opportunity_Types.contains(opportunity.type))){
                                                                             setrscloud=true;
                                                                             RSCloudContinue();
                                                                         }
                if(AccContList != null){ toUpdate.addAll( (List<SObject>) AccContList); }
                if(RSOppList != null) { toUpdate.addAll( (List<SObject>) RsOppList); }                //transfer all to new DDI account
                if(RSTaskList != null){ toUpdate.addAll( (List<SObject>) RSTaskList);}
                if(RSEventList != null){toUpdate.addAll( (List<SObject>) RSEventList);}
                update accDDI;
                update toUpdate;
                
                //added following IF statement as a fix for SFDC-2235 (Users recieving ENTITY_IS_DELETED while closing opps)
                if(account.Id != accDDI.Id && (account.type != 'Cloud Customer' && account.type != 'Customer')) {//SFDC-2366- Added Account type is Customer
                    
                    Cmpid = account.Company_Name__c;
                    //Added by Sundarayya e for SFDC-6792 US to delete GAR Email Items from a Prospect Account
                    List<Realignment_Request_Item__c> rrItemlist = [Select Account__c, Account_Realignment_Request__c, Id , Name from Realignment_Request_Item__c where Account__c =:account.Id];
                    
                    set<Id> realReqItemIdSet = new Set<Id>();//SFDC-6792 by sundarayyae: used to store Realignment ids
                    if(rrItemlist.size() > 0){ // SFDC-6792 by sundarayyae: used to check size of Realignment ids
                        for(Realignment_Request_Item__c rrItemRec : rrItemlist ){
                            realReqItemIdSet.add(rrItemRec.Id);
                        }
                        list<GAR_Email_Item__c> garEmailList = [select Id, Realignment_Request_Item__c from GAR_Email_Item__c where Realignment_Request_Item__c IN:realReqItemIdSet ];
                        if(garEmailList.size() > 0)// deleting Gar Email Records if the size > 0
                            delete garEmailList;
                    }
                    
                    //Update realignMentRequestItemToUpdate;
                    list<Opportunity> opplist = [select Id,AccountId,Account__c from opportunity where Account__c =: account.Id];
                    delete account;     // account must be deleted after the child information from this account has been transferred to ddi account
                }
                
                //Added for SFDC-5872,Samba,Start,
                if(Cmpid != '' && Cmpid != null){
                    Account cmpOfAccount = [SELECT id, name,(select id, whatid from Tasks),(select id, whatid from events),
                                            (SELECT Id, AccountId, UserId, AccountAccessLevel,CaseAccessLevel,ContactAccessLevel, OpportunityAccessLevel ,TeamMemberRole FROM AccountTeamMembers),
                                            (select id, Company_Name__c,type,RecordTypeId from Account__r),
                                            (select id, Accountid from contacts) from Account where id =: Cmpid];
                    
                    for(account a : cmpOfAccount.Account__r){
                        if(a.RecordTypeId == System.Label.AccountCustomerRecordTypeId){
                            isCustomerRecordType = true;
                        }
                        if(a.RecordTypeId == System.Label.Account_Prospect_RecordType_ID){
                            prospectAccSize = prospectAccSize +1;
                        }
                    }
                    
                    if(!isCustomerRecordType && (cmpOfAccount.Account__r.size() == 0 || cmpOfAccount.Account__r.size() == prospectAccSize )){
                        if(cmpOfAccount.Account__r.size() >= 1){
                            for(account acc : cmpOfAccount.Account__r){
                                acc.Company_Name__c = accDDI.Company_Name__c;
                                prodAccountsToUpdate.add(acc);
                            }
                        }
                        compToDeleteList.add(cmpOfAccount);
                        
                        //Updating AccountTeamMembers with retained Company
                        if(cmpOfAccount.AccountTeamMembers.size() > 0){
                            for(AccountTeamMember ATM : cmpOfAccount.AccountTeamMembers){
                                atmList.add(new AccountTeamMember(AccountId = accDDI.Company_Name__c,UserId=ATM.UserId,
                                                                  AccountAccessLevel=ATM.AccountAccessLevel,TeamMemberRole=ATM.TeamMemberRole,
                                                                  CaseAccessLevel=ATM.CaseAccessLevel,
                                                                  ContactAccessLevel=ATM.ContactAccessLevel,
                                                                  OpportunityAccessLevel=ATM.OpportunityAccessLevel));   
                                atmList.add(atm);
                            }
                        }
                        
                        //Updating Contacts with retained Company if not duplicates
                        if(cmpOfAccount.Contacts.size() > 0){
                            for(Contact con : cmpOfAccount.Contacts){
                                con.Accountid = accDDI.Company_Name__c;
                                contactsToUpdateCmp.add(con);
                            }
                        }
                        
                        //Updating Tasks with retained Company
                        if(cmpOfAccount.Tasks.size() > 0){
                            for(Task ts : cmpOfAccount.Tasks){
                                ts.whatid = accDDI.Company_Name__c;
                                UpdateTaskList.add(ts);
                            }
                        }
                        
                        //Updating Events with retained Company
                        if(cmpOfAccount.Events.size() > 0){
                            for(Event ev : cmpOfAccount.Events){
                                ev.whatid = accDDI.Company_Name__c;
                                UpdateEventlist.add(ev);
                            }
                        }
                        
                        if(atmList.size()>0){
                            insert atmList;
                        }
                        
                        //updating all the child records in a single DML
                        if(prodAccountsToUpdate != null){UpdateChilds.addAll( (List<SObject>) prodAccountsToUpdate);}
                        if(contactsToUpdateCmp != null){UpdateChilds.addAll( (List<SObject>) contactsToUpdateCmp);}
                        if(UpdateTaskList != null){ UpdateChilds.addAll( (List<SObject>) UpdateTaskList);}
                        if(UpdateEventlist != null){UpdateChilds.addAll( (List<SObject>) UpdateEventlist);}
                        //if(casesToUpdateCmp != null){UpdateChilds.addAll((List<SObject>) casesToUpdateCmp);}
                        update UpdateChilds;
                        
                        if(compToDeleteList.size()> 0){
                            delete compToDeleteList;
                        }
                    }
                }
                //Added for SFDC-5872,Samba,End
            }
            if(opportunity.Partner_Company__c!=null) {
                opportunity.Partner_Contract_Type__c = opportunity.Partner_Company__r.Contract_Type__c; 
            }
            
            /*SFDC-6000*/            
            if(opportunity.StageName!='Closed Won'){
                opportunity.StageName='Closed Won';
                update opportunity;
            }            
            /*SFDC-6000*/
            
            String[] noEConnect = (Label.Not_Sent_to_eConnect).split(',');
            set<string> noEconnectSet = new set<string>();
            noEConnectset.addall(noEconnect);
            //////////////////////////////////////////////////////////////////////////////////////////////////
            // @developer   :    Diego Castro
            // @date        :    09/08/2017
            // @story       :    SFDC-514
            // @description :    For AWS opportunities when Contract Received = True THEN send to eConnect
            //////////////////////////////////////////////////////////////////////////////////////////////////            
            Set<String> contractOptionalTypes = new Set<String>();
            contractOptionalTypes.addAll(System.Label.Contract_Optional_Types.split(','));            
            ///////////////////////////////////////end SFDC-514///////////////////////////////////////////////
            //SFDC-1569: added opportunity.QuotingSystem__c check to automatically navigate back to opp when CW
            //SFDC-514 modification: added Contract Received criterion for SFDC-514, JY on 08/21/2017, changed condition 
            Boolean ContractReceived=[Select Contract_Received__c from Opportunity where id=:opportunity.id].Contract_Received__c;
            if (opportunity.QuotingSystem__c == 'Datapipe' || noEConnectSet.contains(opportunity.type) || (Label.Not_Sent_to_Raptor_ProServ.contains(opportunity.type) && Opportunity.Category__c == 'Bookings Credit') || (contractOptionalTypes.contains(opportunity.type) && !ContractReceived)) {
                redirectURL = getRedirectToOpp();
            } else {
                
                User u = getUser();
                if (String.isBlank(u.Region__c)) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.CW_User_Region_Required);
                    ApexPages.addMessage(myMsg);
                    Database.rollback(sp); 
                    return;
                } else {
                    redirectURL = getRedirectToOpp();               
                }
            } 
        } 
        
        catch(Exception e ) {
            Exceptionhandler.postToAll(e, false);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
            Database.rollback(sp);
        } 
    }
    
    //Added for SFDC-4959 for redirecting to opp on closed won
    public pagereference goToOpp(){
        return new PageReference('/'+ opportunity.id);
    }
    
    public String getRedirectToOpp() {
        return URL.getSalesforceBaseUrl().toExternalForm()+'/'+opportunity.id;
    }  
    
    public void query(String pageName) {
        try {
            pageManager = PageBuilder.getPage(pageName);
            sectionManager = PageBuilder.getSectionsByPageName(pageName); 
        } catch (Exception e) {            
            //can't use future method here or else it will complain on opportunities that don't have a wizard
            //ExceptionHandler.postToAll(e, false);
        }
    }    
    
    public void goToPage() {
        if(isCACEnable){
            pageNumber=7;
        }
        
        if (pageNumber == 2) {
            StrNewCont = StrNewContRole = StrEditContRole = false;
            StrAccContsec = true;
            LoadAccRoles();        
        }
        if (pageNumber == 3) {
            setQuoteList();
        }
        query('OppCloseWonWizardUS' + pageNumber );
    }
    
    //w/out distinct action methods and going w/generic onClick, both the client side validation AND server side validations fire, rendering one useless...
    public void saveAndNextUs1() {
        pageNumber = 1;
        query('OppCloseWonWizardUS' + pageNumber );
    }
    
    public void saveandnextUS2() {
        try {
            update account;
        } catch (Exception e) {            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());            
            ApexPages.addMessage(myMsg);
            return;
        }
        pageNumber = 2;
        StrNewCont = StrNewContRole = StrEditContRole = false;
        StrAccContsec = true;
        
        LoadAccRoles();        
        query('OppCloseWonWizardUS' + pageNumber );
    }
    
    public PageReference saveandnextUS3() {
        try {
            
            //Added Samba SFDc-6218, start
            list<Account> ddiacc=new list<Account>();
            list<Account> ddiacc1=new list<Account>();
            
            if((oldOptyDDI != null && opportunity.DDI__C != oldOptyDDI) || (oldOptyDDI == null && opportunity.DDI__C != null)){
                ddiacc =[Select id,DDI__c,Company_Name__c,Recordtype.name from Account where DDI__C=:opportunity.DDI__C and DDI__c!='' limit 1]; 
            }
            
            ddiacc1 =[Select id,DDI__c,Company_Name__c from Account where DDI__C=:opportunity.DDI__C and DDI__c!='' limit 1]; 
            
            if(account.Type == 'Prospect' && isCACEnable && opportunity.DDI__c !=null && ddiacc1.size() == 0){
                ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.Error, 'This is an invalid DDI. Please input valid DDI in Opportunity.')); 
                return null;
            } 
            if(ddiacc.size()>0){
                opportunity oppDDI1 = [Select id,DDI__c,MuleSoft_Acknowledge__c,Integration_Status__c,Integration_Status_Code__c,Is_FutureJob_Running__c,RecordType.Name,Account__r.Recordtype.name from opportunity where id = :opportunity.id];
                if(oppDDI1.DDI__c!='' && oppDDI1.RecordType.Name == 'Government' && ddiacc[0].Recordtype.name!='Government Account'){                  
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Opportunity DDI Product Account is not Government');
                    ApexPages.addMessage(myMsg);
                    return null;
                } 
            }
            
            //Added Samba SFDc-6218, End
            loadaccroles();
            string primaryacr;
            set<id> connid=new set<id>();
            list<string> accs=new list<string>();
            List<AccountContactRelation> acclist=[select id,contactid,contact.RPN__c,accountid,roles from AccountContactRelation where id in: AccContList];
            List<string> accrole=new list<string>();
            //SFDC-7067: get the account contact role id of the contact which role = primary contact.Line 871.
            for(AccountContactRelation acr:acclist){
                if(acr.roles!=null){
                    primaryacr=acr.roles;            
                    accrole=primaryacr.split(';');          
                }
                if(!acclist.isEmpty() && acr.contact.RPN__c != null && acr.roles.contains('Primary Contact') ){
                    RpnPrimCon = acr.id;
                }          
                for(string ac:accrole){
                    accs.add(ac);
                    if(ac=='Billing'){
                        connid.add(acr.contactid);
                    }else if(ac=='Primary Contact'){
                        connid.add(acr.contactid);
                    }
                    contactListDDICreation.addAll(connid);
                }
            }
            if (pageNumber == 2 || pageNumber == 9) {
                
                if (!accs.Contains('Primary Contact'))  {
                    ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.Error, 'A primary contact must be selected.') );
                    return null;
                } 
                //SFDC-2565
                else if(!accs.Contains('Billing')){
                    ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.Error, 'A billing contact must be selected.') );
                    return null;
                }
                
                //SFDC-6974: Checking for prospect account which contain Opportunity and mapped account contact id with string RpnPrimCon.
                else if(account.Type == 'Prospect' && !acclist.isEmpty() && accs.Contains('Primary Contact') && string.isNotBlank(RpnPrimCon)){
                    ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.Error, 'Primary Contact of this opportunity is being used with another Customer Account. Please update Primary Contact.'));
                    RpnPrimCon = '';
                    return null;
                }//SFDC-7067 end
				
                if(!connid.isempty()){
                    list<contact> crlist=[select id,name,mailingcity,mailingstreet,mailingcountry,mailingpostalcode,mailingstate from contact where id in:connid];
                    for(contact crprimary:crlist){
                        Boolean prevent = false;
                        list<string> fields = Label.Required_CW_Address_Fields.split(',');
                        
                        for (String field : fields) {
                            String str = (String)crprimary.get(field);
                            if (String.isBlank(str)) {
                                prevent = true;
                                ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.Error, field + ' is required in the ACR related contact ') );
                                
                            }
                        }
                        if (prevent) return null;
                    }
                }
                
                //if condition added for sfdc -2603 --PG    
                if(!connid.isempty()){      
                    list<contact> crlist=[select id,mailingcity,mailingstreet,mailingcountry,mailingpostalcode,mailingstate from contact where id in:connid];
                    for(contact cr:crlist){
                        Boolean prevent = false;
                        list<string> fields = Label.Required_CW_Address_Fields.split(',');
                        for (String field : fields) {
                            String str = (String)cr.get(field);
                            if (String.isBlank(str)) {
                                prevent = true;
                                ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.Error, field + ' is required for Billing Contact Role.') );
                            }
                        }
                        
                        if (prevent) return null;
                    }            
                }
                
                //to set DDI on Step2, Samba start
                setAccDDI();
                if(account.Type == 'Prospect' && isCACEnable && ddiacc.size() == 0 && !opportunity.MuleSoft_Acknowledge__c && opportunity.Integration_Status__c == null && pageNumber == 9){
                    DDIAccountSignUpOnOptyCloseWon.autoCreateDDIAccountFuture(opportunity.Id,contactListDDICreation);
                }
                //added by nanda
                opportunity oppDDI = [Select id,DDI__c,MuleSoft_Acknowledge__c,Integration_Status__c from opportunity where id = :opportunity.id];
                if(oppDDI.DDI__c!='' && oppDDI.Integration_Status__c=='Success' ){
                    opportunity.DDI__c = oppDDI.DDI__c ;
                }
            }
            
            //Added By Saswati for SFDC-3342(Customer Success - Opportunity Type condition added.)
            //updated by chaitanya for SFDC-5171 to include onica type PSO
            if (pageNumber == 4) {
                pageNumber=3;
            }
            //Added Samba For SFDC-6218, End
            if (pageNumber== 9){
                if(opportunity.Type =='Professional Services'|| opportunity.Type =='Customer Success'|| opportunity.Onica_Type__c =='PSO'){
                    pageNumber = 4;            
                }
                else{
                    pageNumber = 3;
                    setQuoteList();
                }
            }else if (pageNumber== 2 && account!= null && account.Type == 'Prospect' && opportunity.DDI__c == null && isCACEnable){
                pageNumber= 9;
            } else if (pageNumber== 2 && ddiacc.size() > 0 && Account.Type !='Cloud Customer' && Account.Type !='Customer') {
                pageNumber=8;
            } else {
                if(opportunity.Type =='Professional Services'|| opportunity.Type =='Customer Success'|| opportunity.Onica_Type__c =='PSO'){
                    pageNumber = 4;            
                }
                else{
                    pageNumber = 3;
                    setQuoteList();
                }
            }
            
            if(Label.OPPCloudType.contains(opportunity.type) && Account.Type=='Cloud Customer'){
                opportunity.DDI__c=Account.DDI__c;
                update opportunity;
            }            
        } catch (Exception e) {            
            ExceptionHandler.postToAll(e, false);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            
            ApexPages.addMessage(myMsg);
            
        }
        query('OppCloseWonWizardUS' + pageNumber);
        return null;
    }   
    
    public PageReference contractentiti() {   
        if (pageNumber == 7 ) {
            pageNumber=1;
        }
        
        opportunity.Contract_Signed__c = True ;
        query('OppCloseWonWizardUS' + pageNumber);
        return null;
    }
    
    //Added Samba For SFDC-6218, Start , To handle Action on Continue button after Step 2
    public PageReference handleContinue() {
        if (pageNumber == 8) {
            if(opportunity.Type =='Professional Services'|| opportunity.Type =='Customer Success'|| opportunity.Onica_Type__c =='PSO'){
                pageNumber = 4;            
            }
            else{
                pageNumber = 3;
                setQuoteList();
            }
        }
        query('OppCloseWonWizardUS' + pageNumber);
        return null;
    }
    //Added Samba For SFDC-6218, End 
    public PageReference saveandnextUS4() {
        try {
            list<account> ddiacc = new list<account>();
            ddiacc =[Select id,DDI__c,Company_Name__c from Account where DDI__C=:opportunity.DDI__C and DDI__c!='' limit 1];
            //added if condition by Saswati for SFDC-3360            
            //end
            opportunity oppDDI = [Select id,DDI__c,MuleSoft_Acknowledge__c,Integration_Status__c from opportunity where id = :opportunity.id];
            if(oppDDI.DDI__c!='' && oppDDI.Integration_Status__c=='Success' ){
                opportunity.DDI__c = oppDDI.DDI__c ;                
            }
            pageNumber = 4;
            loadaccroles(); 
        } catch (Exception e) {
            ExceptionHandler.postToAll(e, false);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);  
        }
        query('OppCloseWonWizardUS' + pageNumber );
        return null;
        
    }
    public PageReference saveandnextUS5() {
        
        opportunity oppDDI = [Select id,DDI__c,MuleSoft_Acknowledge__c,Integration_Status__c,Integration_Status_Code__c,Is_FutureJob_Running__c,RecordType.Name,Account__r.Recordtype.name from opportunity where id = :opportunity.id];
        
        if(oppDDI.MuleSoft_Acknowledge__c && oppDDI.DDI__C != null ){
            opportunity.MuleSoft_Acknowledge__c = oppDDI.MuleSoft_Acknowledge__c ;
            opportunity.DDI__C=oppDDI.DDI__C;
            //@story: SFDC-6666 , @desc: after close won process keep the set integration status and codes from MuleSoft.
            Opportunity.Integration_Status_Code__c=oppDDI.Integration_Status_Code__c;
            Opportunity.Integration_Status__c=oppDDI.Integration_Status__c;
            
        }
        list<Account> ddiacc=new list<Account>();
        ddiacc=[Select id,DDI__c,Company_Name__c,Recordtype.name from Account where DDI__C=:opportunity.DDI__C and DDI__c!='' limit 1]; 
        
        if(ddiacc.size()>0){
            if(oppDDI.DDI__c!='' && oppDDI.RecordType.Name == 'Government' && ddiacc[0].Recordtype.name!='Government Account'){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Opportunity DDI Product Account is not Government');
                ApexPages.addMessage(myMsg);
                return null;
            }
        }   
        
        //@story : SFDC-6666, @dev: Caleb Garcia, @description : Rechecks status codes after mulsefoft acknowledge. Will clear integration fieds and restart the autoDDI creation process.
        if(account.Type == 'Prospect' && isCACEnable && (oppDDI.Integration_Status__c=='Failure' || oppDDI.Integration_Status__c=='') && oppDDI.Integration_Status_Code__c != '' && !oppDDI.Is_FutureJob_Running__c && opportunity.DDI__c==null && ddiacc.size()==0){
            ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.Error, 'There is a problem with the Automatic DDI generation process, please wait 30 seconds and try again. If the problem persist after the 3rd attempt please contact a Rackspace salesforce administrator') );
            //initiate resetCACFields method
            resetCACFields();
            //re-trigger auto DDI creation.          
            DDIAccountSignUpOnOptyCloseWon.autoCreateDDIAccountFuture(oppDDI.Id,contactListDDICreation);
            return null;
        }//SFDC-6666 End
        
        if(account.Type == 'Prospect' && isCACEnable && oppDDI.Integration_Status__c=='Failure'  && oppDDI.MuleSoft_Acknowledge__c && opportunity.DDI__c!=null && ddiacc.size()==0){
            ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.Error, 'This is an invalid DDI. Please input valid DDI in Opportunity.') ); 
            return null;
        }
        
        if(oppDDI.DDI__c!='' && oppDDI.Integration_Status__c=='Success' ){
            opportunity.DDI__c = oppDDI.DDI__c ;
        }
        
        //Added by Chaitanya for SFDC-4545    
        if (opportunity.Expected_Revenue_Start_Date__c <= opportunity.CloseDate &&  
            opportunity.Cloud_Contract_Type__c != 'DCR' && opportunity.Cloud_Contract_Type__c != 'DCR - Offset' && 
            opportunity.Type!=  'Renewal'   &&   opportunity.Category__c != 'Renewal')              
        {  
            ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.Error, 'Expected Revenue Start Date must be greater than Close Date') ); 
            return null;    
        }  
        //END of SFDC-4545  
        
        else
            if(opportunity.account.recordtypeid!=null && System.Label.GovernmentRecordTypes.contains(opportunity.account.recordtypeid) && opportunity.QuotingSystem__c != 'Datapipe'){
                
                query('OppCloseWonWizardUS' + 6 );
                return null;
            }
        else{            
            actionFor5();            
            return null;
        }        
    }    
    
    public void actionFor5(){
        try { 
            opportunity.skip_government_validation__c = true;
            loadaccroles();
            setAccDDI();
            opportunity opp=[select id,name,AccountId,Account__c,RecordType.Name,Account__r.id from opportunity where id=:opportunity.id];
            if(account.Type == 'Prospect' && isCACEnable){
                opportunity.Account__c=opp.Account__r.id;
                opportunity.Accountid=opp.Accountid;
                
            }
            update opportunity;
            Opportunity opp1 = [Select id, approval_amount__c,Integration_Status_Code__c from opportunity where id = :opportunity.id];
            
            // SFDC-119, SFDC-77 stories to make why did we win required for specific scenarios
            // 'Prospect,Customer'.contains(account.RecordType.Name)// Anitha
            if 
                (
                    ( 
                        //why did we win is blank AND the user's profile isn't in the admin profiles AND the account record type is prospect,customer
                        String.isBlank(opportunity.Why_Did_We_Win__c) && 
                        !(Label.Admin_Profiles).contains(UserInfo.getProfileId()) &&
                        'Prospect,Customer'.contains(account.RecordType.DeveloperName)
                    )       
                    &&  
                    (   
                        //the opportunity is one of these
                        'AWS,Azure,Rackspace Cloud,Azure Resale,Google'.contains(opportunity.Type)                              || 
                        //or the opportunity is one of these and the opp's approval amount is > 1500
                        (
                            'Dedicated/Private Cloud,ObjectRocket,Open Stack Private,Mailgun'.contains(opportunity.Type) &&
                            opp1.Approval_Amount__c > Integer.valueOf(Label.CW_Why_Did_We_Win)                        
                        )
                    )
                ) 
            {
                String apiName = Schema.SObjectType.Opportunity.fields.getMap().get('Why_Did_We_Win__c').getDescribe().getLabel();
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, apiName + ' is required.');
                ApexPages.addMessage(myMsg);
            }else{ 
                pageNumber = 5;
            }
        } catch (Exception e) {
            ExceptionHandler.postToAll(e, false);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
        }
        query('OppCloseWonWizardUS' + pageNumber );
    }
    
    public PageReference deleteAccCont() {
        delete Database.query(queryBuilder.getQueryString(VF_Query_Manager__c.getInstance('OWC-13').Query_Id__c));
        LoadAccRoles();
        return null;
    }
    
    public void updateWhyDidWeWin() {
        opportunity.Why_Did_We_Win__c = recordId;  
    }    
    
    public void checkVal() {
        opportunity.Was_a_Partner_Involved__c = recordID;
    }  
    
    public User getUser() {
        User u = [Select Id, SSO_Username__c, Region__c from User Where Id = :UserInfo.getUserId() ];        
        return u;
    } 
    
    public void PrimaryQuoteUpdate(){
        try {
            primaryQuote = Database.query(queryBuilder.getQueryString(VF_Query_Manager__c.getInstance('OWC-8').Query_Id__c));
            primaryQuote.Is_Primary__c = true;
            
            for(quote_Line__c ql: primaryQuote.Quote_Lines__r) {
                opportunity.focus_area__c +=';'+ql.Focus_Area__c;
            }            
            update primaryQuote;            
            setQuoteList();
        } catch (Exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
        }
        quoteId = '';
    }   
    
    public PageReference  SaveContact(){
        try
        {
            AccountContactRelation ac=new AccountContactRelation ();
            Contact tmp = new Contact(); 
            string accid=AccContRole.Accountid;
            if (StrNewCont || StrNewContRole) {
                if (StrNewCont) {
                    String acrContact = AccContRole.Contactid;
                    if(acrContact!=null || acrContact!=''){
                        tmp = Database.query(queryBuilder.getQueryString(VF_Query_Manager__c.getInstance('OWC-7').Query_Id__c));
                        
                    }
                } else if (StrNewContRole) {
                    insert contact;             // inserted before since it's id is used in putting the id value to the ac
                    String acrContact = contact.id;                    
                    contact = new Contact();
                    tmp = Database.query(queryBuilder.getQueryString(VF_Query_Manager__c.getInstance('OWC-7').Query_Id__c));
                }
                
                for (FieldMapping__c fieldMap : getFieldMapping('StrNewContRole%')) 
                {
                    if (fieldMap.CompName__c.contains('account')) {
                        ac.put(fieldMap.TargetField__c, Reusable.getValue(account, fieldMap.SourceField__c));
                        
                    }
                    if (fieldMap.CompName__c .contains('contact')) {
                        ac.put(fieldMap.TargetField__c, Reusable.getValue(tmp, fieldMap.SourceField__c));
                    } 
                    
                    if (fieldMap.CompName__c .contains('acr')) {
                        ac.put(fieldMap.TargetField__c, Reusable.getValue(AccContRole, fieldMap.SourceField__c));
                    } 
                }   
                if(tmp.AccountId==null){
                    tmp.AccountId=opportunity.Accountid;  
                    update tmp;
                }
                insert ac;  
            }
            if (StrEditContRole){           
                update EditAccContRole;
                tmp.id=EditAccContRole.contactid;
                tmp.phone=EditAccContRole.contact.phone;
                tmp.Email=EditAccContRole.contact.Email;
                tmp.Mailingstreet=EditAccContRole.contact.Mailingstreet;
                tmp.MAilingcity=EditAccContRole.contact.MAilingcity;
                tmp.mailingpostalcode=EditAccContRole.contact.mailingpostalcode;
                tmp.MailingcountryCode=EditAccContRole.contact.MailingcountryCode;
                tmp.MailingStateCode=EditAccContRole.contact.MailingStateCode;
                update tmp;
            }
            
            LoadAccRoles();            
            StrEditContRole = StrNewCont = StrNewContRole = false;
            StrAccContsec=true;
        }
        catch(Exception e ) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
            ExceptionHandler.postToAll(e, false);
            return null;
        }
        return null; 
    }
    
    public List<Opportunity> getChildOpportunities()  {
        Id accountId = Account.Id;
        return Database.query(queryBuilder.getQueryString(VF_Query_Manager__c.getInstance('OWC-12').Query_Id__c));
    }
    
    
    public PageReference RSCloudContinue() {
        try{
            
            if (accDDI !=null && accDDI.RecordType.DeveloperName== 'Prospect') {
                accDDi.RecordTypeId = getCustomerRecordTypeID();
                accDDI.type = 'Customer';        //replaced for SFDC-796
            }
            if (accDDI != null && Account.Id != accDDI.Id) //SFDC-2787
            {         
                Map<String, List<FieldMapping__c>> compToFieldMapping = new Map<String, List<FieldMapping__c>>();
                for (FieldMapping__c mapping :  getFieldMapping('RSCloudContinue%')) {
                    if (compToFieldMapping.containsKey(mapping.CompName__c)) {
                        compToFieldMapping.get(mapping.CompName__c).add(mapping);
                    } else {
                        compToFieldMapping.put(mapping.CompName__c, new List<FieldMapping__c>{mapping});
                    }
                }
                
                for (FieldMapping__c fm : compToFieldMapping.get('RSCloudContinue-opportunity')) {
                    opportunity.put(fm.TargetField__c, Reusable.getValue(accDDI, fm.SourceField__c));
                }
                
                //Get all the Opportunities under this Account 
                RSOppList=new List<Opportunity>();
                
                for (Opportunity opp : getChildOpportunities()) 
                {
                    RSTaskList = new List<Task>();
                    RSEventList=new List<Event>(); 
                    for (FieldMapping__c fm : compToFieldMapping.get('RSCloudContinue-opp')) {                        
                        opp.put(fm.TargetField__c, Reusable.getValue(accDDI, fm.SourceField__c));
                    }
                    
                    RSOppList.add(opp);
                    for (Task task : opp.Tasks) {
                        for (FieldMapping__c fm : compToFieldMapping.get('RSCloudContinue-task')) {
                            task.put(fm.TargetField__c, Reusable.getValue(accDDI, fm.SourceField__c));
                        }
                        RSTaskList.add(task); 
                    }
                    
                    for (Event event : opp.Events) {
                        for (FieldMapping__c fm : compToFieldMapping.get('RSCloudContinue-event')) {
                            event.put(fm.TargetField__c, Reusable.getValue(accDDI, fm.SourceField__c));
                        }
                        RSEventList.add(event);
                    }
                }
                
            }
            if(setrscloud==false) {
                if(account.Type == 'Prospect' && isCACEnable){
                    saveAndNextUs2();
                } else {
                    saveAndNextUs3();
                } 
            }
        }
        catch(Exception e ) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        } 
        query('OppCloseWonWizardUS' + pageNumber); 
        return null;
    }    
    
    public void spin() {
        long now = datetime.now().gettime();
        while(datetime.now().gettime()-now<5000); // Busy loop for 5000 ms
    }
    
    @TestVisible
    private static void updateCase(Account oppcompany, Opportunity oppid, Account accDDI){
        List<Case> caseList = new List<Case>();
        try{
            for(Case cs:[SELECT AccountId,Account__c,Id,Opportunity_Name__c 
                         FROM Case WHERE Opportunity_Name__c =: oppid.Id])
            {
                cs.AccountId = oppcompany.Id; // Standard company
                cs.Account__c = accDDI.Id; // Product Account 
                caseList.add(cs);
            }
            update caseList;
        }catch(Exception ex){
            System.debug('Exception while updating cases'+ex.getMessage());
        }
    }
}