public without sharing class CompanyTriggerHelper{
    public static boolean deleteCMPRun = true;
    
    public static boolean SHARE_COMPANIES_TO_PARTNERS = true;
    //To avoid users from deleting Company records with Accounts other than Prospects
    public static void avoidDeleteCompanies(List<Account> accList,Map<Id,Account> cmpMap){
        Id prospectTypeId =label.Account_Prospect_RecordType_ID;  
        List<Id> companyRecIds = CMPorACCRecordType_Utility.query_Utility(label.CompanyRecordTypes); 
        System.debug(companyRecIds);
        List<Account> companys = new List<Account>();
        companys = [Select id,(select id from Account__r WHERE RecordTypeId!=:prospectTypeId) From Account WHERE id IN : cmpMap.keySet() AND RecordTypeId IN : companyRecIds];      
        System.debug(companys);
        if(!companys.isEmpty()){
            integer cmpSize = companys.size();
            System.debug(cmpSize);
            for(integer i=0;i<cmpSize;++i){       
                if(!companys[i].Account__r.isEmpty())
                {           
                    Account com = (Account)cmpMap.get(companys[i].id);
                    System.debug('com '+com );
                    com.addError(Label.Avoid_Company_Delete);  
                    
                }                          
            }
        }
        else {
            List<Account> companyss = new List<Account>();
            
            List<String> peersetlist=System.label.ProductAccountDeletionRestricted.split(',');
            
            // List<PermissionSetAssignment> permissionsett = [Select PermissionSetId,AssigneeId FROM PermissionSetAssignment where PermissionSet.name in ('LA_Cloud_Office_Support_Permission_Set','LA_Supervisor_Cloud_Office_Support_Permission_Set','LA_Sales_Chat_Permission_Set','LA_Supervisor_Sales_Chat_Permission_Set') and AssigneeId = :UserInfo.getUserId()];
            List<PermissionSetAssignment> permissionsett = [Select PermissionSetId,AssigneeId FROM PermissionSetAssignment where PermissionSet.name in: peersetlist and AssigneeId = :UserInfo.getUserId()];    
            system.debug('permissionsett--------'+permissionsett);
            List<Id> AccountRecIds = CMPorACCRecordType_Utility.query_Utility(label.AccountRecordTypes); 
            companyss = [select id from Account WHERE id IN : cmpMap.keySet() and type!='Cloud Customer' and RecordTypeId IN : AccountRecIds];    
            if(permissionsett.size()>0 && System.label.ProfileList_Restricting_Deletion_ProductAccount.contains(userInfo.getProfileId())){
                System.debug('Profiles'+label.ProfileList_Restricting_Deletion_ProductAccount+'user prof'+userInfo.getProfileId());
                System.debug('companyss' + companyss);
                if(companyss.size()>0){
                    integer cmpSize = accList.size();
                    for(integer i=0;i<cmpSize;++i){     
                        accList[i].addError(Label.Avoid_Company_Delete);  
                        
                    }  
                }
            }
        }
        
        
    }
    //To createCompanyTeamMembersFromApprovalProcess 
    public static void createCompanyTeamMembersFromApprovalProcess() {
        //  try {
        String cap_process_ID = 'Company Approval Process ID';
        String sys_process_id = 'System Administrator ID';
        Id ProcessDefinitionId;         
        Id systemAdministratorId;
        if (UserInfo.getOrganizationId() == OrgConstants__c.getInstance('Prod Org ID').Prod_Value__c) {
            ProcessDefinitionID = (Id) OrgConstants__c.getInstance(cap_process_ID).get('Prod_value__c');
            systemAdministratorId = (Id) OrgConstants__c.getInstance(sys_process_id).get('Prod_value__c');
        } else {
            ProcessDefinitionID = OrgConstants__c.getInstance(cap_process_ID).Non_Prod_Value__c;
            systemAdministratorId = (Id) OrgConstants__c.getInstance(sys_process_id).Non_Prod_Value__c;
        }
        
        Set<id> approvedCompanyIDs = new Set<ID>();
        
        Map<String, list<Account>> mapper = new map<String, list<account>>();
        for (Account company : (List<Account>) Trigger.new) {
            //if the old company access submitter wasn't sys admin and now it is the sys admin
            if (((Map<Id, Account>) Trigger.oldMap).get(company.id).Company_Access_Submitter__c  != systemAdministratorId 
                && company.Company_Access_Submitter__c == systemAdministratorId) {
                    approvedCompanyids.add(company.id);
                    company.Company_Access_Submitter__c = null;//((Map<Id, Account>) Trigger.oldMap).get(company.id).Company_Access_Submitter__c;
                    
                }
        }
        if (approvedCompanyIds.size() > 0) {
            List<SObject> companyTeamMembers = new List<SObject>();
            
            for (Id approvedID : approvedCompanyIDs) {
                AccountTeamMember ctm = new AccountTeamMember();
                ctm.UserId = ((Map<Id, Account>) Trigger.oldMap).get(approvedID).Company_Access_Submitter__c;
                ctm.AccountId = approvedId;
                CTM.ACCOUNTACCESSLEVEL = 'Edit';
                CTM.OpportunityACCESSLEVEL = 'Edit';
                CTM.ContacTACCESSLEVEL = 'Edit';
                CTM.CaseACCESSLEVEL = 'Edit';
                CTM.TeamMemberRole = 'Additional Sales Rep';
                companyTeamMembers.add(ctm);
                
            }
            
            
            
            insert companyTeamMembers;
            
        }
        /* }
catch (Exception e) {
ExceptionHandler.postToAll(e, true);
}*/
        
    } 
    public static void createPartnerUser(List<Account> approvedCompanies){
        
        
        Set<Id> contactIds = new Set<Id>();
        List<User> partnerUsers = new List<User>(); 
        Map<Id,User> users = new Map<Id,User>();
        for(Account a : approvedCompanies)
            if(String.isNotBlank(a.Primary_Member__c))
            contactIds.add(a.Primary_Member__c);
        Map<Id,Contact> contactsMap = new Map<Id,Contact>([SELECT ID,Name,Email,FirstName,LastName,Title,AccountId,Account.Name FROM Contact where id in : contactIds]);
        
        for(User us : [Select Id,ContactId from User where contactId in : contactIds]){
            users.put(us.ContactId, us);  
        }
        Organization org = [SELECT IsSandbox FROM Organization LIMIT 1];
        for(Account a : approvedCompanies){
            if(String.isNotBlank(a.Primary_Member__c)){
                Contact c = contactsMap.get(a.Primary_Member__c);
                if(users != null && !users.containsKey(c.Id)){
                    if(org.IsSandbox){
                        if(a.Partner_License_Type__c == 'Partner Community Login')
                            partnerUsers.add(new User(userName=c.Email+'.rax.partner.'+UserInfo.getUserName().substringAfterLast('.'),Email=c.Email,FirstName=c.FirstName,LastName=c.LastName,CommunityNickname=c.Email.Trim().toLowerCase(),ProfileId=Label.Rackspace_Partners_Login_Profile,
                                                      Alias=c.Name.substring(0,7).deleteWhitespace().toLowerCase(),TimeZoneSidKey='America/Mexico_City',LocaleSidKey='en_US',LanguageLocaleKey='en_US',ContactId=c.Id,EmailEncodingKey='UTF-8'));
                        
                        else
                            partnerUsers.add(new User(userName=c.Email+'.rax.partner.'+UserInfo.getUserName().substringAfterLast('.'),Email=c.Email,FirstName=c.FirstName,LastName=c.LastName,CommunityNickname=c.Email.Trim().toLowerCase(),ProfileId=Label.Rackspace_Partners_Profile,
                                                      Alias=c.Name.substring(0,7).deleteWhitespace().toLowerCase(),TimeZoneSidKey='America/Mexico_City',LocaleSidKey='en_US',LanguageLocaleKey='en_US',ContactId=c.Id,EmailEncodingKey='UTF-8'));
                        
                    } else{
                        
                        if(a.Partner_License_Type__c == 'Partner Community Login')
                            partnerUsers.add(new User(userName=c.Email+'.rax.partner',Email=c.Email,FirstName=c.FirstName,LastName=c.LastName,CommunityNickname=c.Email.Trim().toLowerCase(),ProfileId=Label.Rackspace_Partners_Login_Profile,
                                                      Alias=c.Name.substring(0,7).deleteWhitespace().toLowerCase(),TimeZoneSidKey='America/Mexico_City',LocaleSidKey='en_US',LanguageLocaleKey='en_US',ContactId=c.Id,EmailEncodingKey='UTF-8'));
                        
                        else
                            partnerUsers.add(new User(userName=c.Email+'.rax.partner',Email=c.Email,FirstName=c.FirstName,LastName=c.LastName,CommunityNickname=c.Email.Trim().toLowerCase(),ProfileId=Label.Rackspace_Partners_Profile ,
                                                      Alias=c.Name.substring(0,7).deleteWhitespace().toLowerCase(),TimeZoneSidKey='America/Mexico_City',LocaleSidKey='en_US',LanguageLocaleKey='en_US',ContactId=c.Id,EmailEncodingKey='UTF-8'));
                        
                    }
                    
                }
                
            } } 
        if(!partnerUsers.isEmpty())
            System.enqueueJob(new PortalUserCreation(partnerUsers));
    }
    // Added by Thirupathi Aeneni For SFDC_1631-Starts
    public static void validatePartnerRelationshipUpdate(List<Account> companies,Set<Id> companyIds,Map<Id,Account> companynewMap){
        if(Trigger.isInsert){
            system.debug('companies.......'+companies);
            for(Account ac:companies){
                if(ac.RecordTypeId == Label.Company_Partner_RecordTypeID && String.isNotBlank(ac.parentId) && ac.Partner_Level__c == Label.PartnerLevel_MasterAgent && !System.Label.SkipUserIDs.contains(UserInfo.getUserId()) && !System.Label.System_Administrator_Profile_Id.contains(UserInfo.getProfileId()))
                    ac.addError(System.Label.Master_Agent_Update_Error_Message);
            }
        }
        
        if(Trigger.isUpdate){
            for(Account com:[Select Id,ParentId,Partner_Level__c,(Select Id,Partner_Level__c From ChildAccounts) From Account Where Id In :companyIds]){
                if(com.ChildAccounts.size()>0 && companynewMap.get(com.Id).Partner_Level__c != Label.PartnerLevel_MasterAgent){
                    companynewMap.get(com.Id).addError(System.Label.Master_Agent_Update_Error_Message);
                }
            }  
        }
    }
    
    
    Public static void removeOrUpdateCommunitySharing(){
        
        // system.debug('Partner record type.....'+Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner_Company').getRecordTypeId());
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
        Set<Id> companyIds = new Set<Id>();
        Set<Id> ParentCompanyIds = new Set<Id>();
        List<Account> newAccountList=(List<Account>)Trigger.new;
        List<Account> oldAccountList=(List<Account>)Trigger.old;
        Set<Id> sharecompanyIds = new Set<Id>();
        for(Integer i=0;i<newAccountList.size();i++){
            system.debug('newAccountList=============='+newAccountList[i]);
            system.debug('newAccountList[i].RecordTypeId=============='+newAccountList[i].RecordTypeId);
            system.debug('recordTypeId=============='+recordTypeId);
            system.debug('newAccountList[i].ParentId=============='+newAccountList[i].ParentId);
            system.debug('oldAccountList[i].ParentId=============='+oldAccountList[i].ParentId);
            //system.debug('newAccountList[i].RecordTypeId == recordTypeId=============='+newAccountList[i].RecordTypeId == recordTypeId);
            If(newAccountList[i].RecordTypeId == recordTypeId && newAccountList[i].ParentId != oldAccountList[i].ParentId){
                system.debug('Enter-----');
                companyIds.add(newAccountList[i].Id);
                sharecompanyIds.add(newAccountList[i].Id);
                If(String.isNotBlank(oldAccountList[i].ParentId))
                    ParentCompanyIds.add(oldAccountList[i].ParentId);
            }
            
        }        
        If(companyIds.size()>0 && ParentCompanyIds.size()>0){
            Map<Id,Account> companiesWithChilds = new Map<Id,Account>([Select Id,ParentId,Parent.ParentId,(Select Id From ChildAccounts) From Account Where Id In : companyIds]);
            
            for(Account a:[Select Id,ParentId From Account Where Id In:ParentCompanyIds])
                If(String.isNotBlank(a.ParentId))
                ParentCompanyIds.add(a.ParentId);
            
            for(Account ac : companiesWithChilds.values()){
                if(companiesWithChilds.get(ac.id).childAccounts.size()>0)
                    for(Account a : companiesWithChilds.get(ac.id).childAccounts )
                    companyIds.add(a.Id);             
                
            }
            
            Map<Id,Lead> mapLeads = new Map<Id,Lead>([Select Id,Partner_Company__c From Lead Where Partner_Company__c In:companyIds]);
            Map<Id,Opportunity> mapOpps=new Map<Id,Opportunity>([Select Id,Partner_Company__c From Opportunity Where Partner_Company__c In:companyIds]);
            Map<Id,Account> companiesSharesToDel=new Map<Id,Account>([Select Id,Partner_Company__c From Account Where Partner_Company__c In:companyIds]);
            Map<Id,User> ParentUsers=new Map<Id,User>([Select Id,AccountId,isActive From User Where isActive=true And AccountId in:ParentCompanyIds]);
            If(ParentUsers.size()>0){
                
                If(mapLeads.size()>0){
                    List<LeadShare> LeadShares=new List<LeadShare>([Select Id,LeadId,UserOrGroupId From LeadShare where LeadId In:mapLeads.Keyset() and UserOrGroupId In:ParentUsers.Keyset()]);
                    If(LeadShares.size()>0)
                        System.enqueueJob(new UpdateCommunityShare(LeadShares,'Delete'));
                }
                If(mapOpps.size()>0){
                    List<OpportunityTeamMember> otms=new List<OpportunityTeamMember>([Select Id,OpportunityId,UserId From OpportunityTeamMember Where OpportunityId in : mapOpps.keySet() AND UserId In : ParentUsers.keySet()]);
                    If(otms.size()>0)
                        System.enqueueJob(new UpdateCommunityShare(otms,'Delete'));
                }
                If(companiesSharesToDel.size()>0){
                    List<AccountTeamMember> ctms=new List<AccountTeamMember>([Select Id,AccountId,UserId From AccountTeamMember Where AccountId in : companiesSharesToDel.keySet() AND UserId In : ParentUsers.keySet()]);
                    If(ctms.size()>0)
                        System.enqueueJob(new UpdateCommunityShare(ctms,'Delete'));
                }
            }    
        }
        If(sharecompanyIds.size()>0){
            Map<Id,Account> companiesWithChilds = new Map<Id,Account>([Select Id,ParentId,Parent.ParentId,(Select Id From ChildAccounts) From Account Where Id In : sharecompanyIds]);
            Set<Id> ParentIds=new Set<Id>();
            for(Account ac:companiesWithChilds.values()){
                If(String.isNotBlank(ac.ParentId))
                    ParentIds.add(ac.ParentId);
                If(String.isNotBlank(ac.Parent.ParentId))
                    ParentIds.add(ac.Parent.ParentId);
                If(String.isBlank(ac.Parent.ParentId) && companiesWithChilds.get(ac.id).childAccounts.size()>0)
                    for(Account a : companiesWithChilds.get(ac.id).childAccounts )
                    sharecompanyIds.add(a.Id);
                
            }
            If(ParentIds.size()>0){
                Map<Id,Account> CompaniesMapWithLeads=new Map<Id,Account>([Select Id,ParentId,Parent.ParentId,(Select Id From Leads__r) From Account Where Id in : sharecompanyIds]);
                Map<Id,Account> CompaniesMapWithOpps=new Map<Id,Account>([Select Id,ParentId,Parent.ParentId,(Select Id From Opportunities__r) From Account Where Id in : sharecompanyIds]);
                Map<Id,Account> PCompaniesMapWithCompanies =new Map<Id,Account>([Select Id,ParentId,Parent.ParentId,(Select Id,Partner_Company__c From Accounts1__r )From Account Where Id in : sharecompanyIds]);
                Map<Id,User> ParentUsers =new Map<Id,User>([Select Id,AccountId,isActive From User Where isActive=:true AND AccountId In : ParentIds]);
                List<LeadShare> leadShares=new List<LeadShare>();
                List<OpportunityTeamMember> otms = new List<OpportunityTeamMember>();
                List<AccountTeamMember> atms = new List<AccountTeamMember>();
                If(CompaniesMapWithLeads.size()>0 && ParentUsers.size()>0){
                    
                    for(User u:ParentUsers.values()){
                        If(ParentIds.Contains(u.AccountId)){
                            for(Account a:CompaniesMapWithLeads.values()){
                                if(a.ParentId==u.AccountId){
                                    if(CompaniesMapWithLeads.get(a.Id).Leads__r.size()>0)
                                        for(Lead l : CompaniesMapWithLeads.get(a.Id).Leads__r)
                                        leadShares.add(new LeadShare(LeadId=l.Id,userOrGroupId = u.Id,leadAccessLevel='Read'));
                                }
                                if(a.Parent.ParentId==u.AccountId){
                                    if(CompaniesMapWithLeads.get(a.Id).Leads__r.size()>0)
                                        for(Lead l : CompaniesMapWithLeads.get(a.Id).Leads__r)
                                        leadShares.add(new LeadShare(LeadId=l.Id,userOrGroupId = u.Id,leadAccessLevel='Read'));
                                }   
                            }
                        }
                    }                       
                }
                If(CompaniesMapWithOpps.size()>0 && ParentUsers.size()>0){
                    
                    for(User u:ParentUsers.values()){
                        If(ParentIds.Contains(u.AccountId)){
                            for(Account a:CompaniesMapWithOpps.values()){
                                if(a.ParentId==u.AccountId){
                                    if(CompaniesMapWithOpps.get(a.Id).Opportunities__r.size()>0)
                                        for(Opportunity o : CompaniesMapWithOpps.get(a.Id).Opportunities__r)
                                        otms.add(new OpportunityTeamMember(OpportunityId=o.Id,UserId = u.Id,OpportunityAccessLevel='Edit',TeamMemberRole ='Partner User'));
                                }
                                if(a.Parent.ParentId==u.AccountId){
                                    if(CompaniesMapWithOpps.get(a.Id).Opportunities__r.size()>0)
                                        for(Opportunity o : CompaniesMapWithOpps.get(a.Id).Opportunities__r)
                                        otms.add(new OpportunityTeamMember(OpportunityId=o.Id,UserId = u.Id,OpportunityAccessLevel='Edit',TeamMemberRole ='Partner User'));
                                }   
                            }
                        }
                    }   
                }
                If(PCompaniesMapWithCompanies.size()>0 && ParentUsers.size()>0){
                    
                    for(User u:ParentUsers.values()){
                        If(ParentIds.Contains(u.AccountId)){
                            for(Account a:PCompaniesMapWithCompanies.values()){
                                if(a.ParentId==u.AccountId){
                                    if(PCompaniesMapWithCompanies.get(a.Id).Accounts1__r.size()>0)
                                        for(Account ac : PCompaniesMapWithCompanies.get(a.Id).Accounts1__r)
                                        atms.add(new AccountTeamMember(AccountId=ac.Id,UserId = u.Id,AccountAccessLevel='Edit',ContactAccessLevel='Edit',OpportunityAccessLevel='None',TeamMemberRole ='Partner User'));
                                }
                                if(a.Parent.ParentId==u.AccountId){
                                    if(PCompaniesMapWithCompanies.get(a.Id).Accounts1__r.size()>0)
                                        for(Account ac : PCompaniesMapWithCompanies.get(a.Id).Accounts1__r)
                                        atms.add(new AccountTeamMember(AccountId=ac.Id,UserId = u.Id,AccountAccessLevel='Edit',ContactAccessLevel='Edit',OpportunityAccessLevel='None',TeamMemberRole ='Partner User'));
                                }   
                            }
                        }
                    }   
                }
                If(leadShares.size()>0)
                    System.enqueueJob(new UpdateCommunityShare(leadShares,'Insert'));
                If(otms.size()>0)
                    System.enqueueJob(new UpdateCommunityShare(otms,'Insert'));
                
                
                If(atms.size()>0)
                    System.enqueueJob(new UpdateCommunityShare(atms,'Insert'));
            }
        } 
    }
    // Added by Thirupathi Aeneni For SFDC_1631-Ends 
    
    //Start : SFDC-983 Anil
    /*
* Author : Anil
* Purpose : Compying the Billing Address to Primary Address while creating the Company
* Date : 18-May-2018
*/
    public static void populatePrimaryAddress(List<Account> newAccList){
        Map<String,List<Account>> tmpcmpMap = new Map<String,List<Account>>();
        for(Account acc:newAccList){
            acc.ShippingCountry = acc.BillingCountry; 
            acc.ShippingCountryCode = acc.BillingCountryCode;
            acc.ShippingStreet = acc.BillingStreet;
            acc.Shippingcity = acc.BillingCity;
            acc.ShippingState = acc.BillingState;
            acc.ShippingStateCode = acc.BillingStateCode;
            acc.ShippingPostalCode = acc.BillingPostalCode;
            /*string paccrecordtype=System.Label.CompanyRecordTypes;
if(!paccrecordtype.contains('Company')){
Account accnumber = [select Id,AccountNumber from Account order by CreatedDate desc limit 1];
acc.AccountNumber=accnumber.AccountNumber+1;            
}*/
        }
    }
    //End : SFDC-983 Anil 
    /********************Added By Biswa for SFDC-2155***************************/
    Public static void addRemoveAccTM (){
        
        
        set<id> PrimaryMemberId = new set<id>();
        List<Contact> IsPrimaryMember = new List<Contact>();
        for(Account acc : (List<account>)Trigger.new){
            if(acc.RecordTypeId== Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId() && acc.Primary_Member__c != ((Map<Id, Account>)Trigger.oldMap).get(acc.Id).Primary_Member__c){
                PrimaryMemberId.add(acc.Id);
                if(String.isNotBlank(acc.Primary_Member__c))
                    IsPrimaryMember.add(new Contact(Id=acc.Primary_Member__c,is_Primary_Member__c = true));
                
                if(String.isNotBlank(((Map<Id, Account>)Trigger.oldMap).get(acc.Id).Primary_Member__c))
                    IsPrimaryMember.add(new Contact(Id=((Map<Id, Account>)Trigger.oldMap).get(acc.Id).Primary_Member__c,is_Primary_Member__c = false));
            }
            if(!PrimaryMemberId.isEmpty()){
                delete [select id,AccountId from AccountTeamMember where AccountId=:PrimaryMemberId and TeamMemberRole =: 'Primary Member'];
                
                List<AccountTeamMember> members = new List<AccountTeamMember>();
                for(User U : [Select id,accountId,Account.Primary_Member__c,ContactId From User Where accountId in : PrimaryMemberId])
                    if(u.ContactId == u.Account.Primary_Member__c)
                    members.add( new AccountTeamMember(UserId =u.Id,AccountId = u.AccountId,TeamMemberRole = 'Primary Member',AccountAccessLevel='Edit',ContactAccessLevel = 'Edit',OpportunityAccessLevel='Read'));
                
                if(members.size() > 0)
                    Database.insert(members, false);
                
                
            }
            if(IsPrimaryMember.size() >0)
                Update IsPrimaryMember;
        }
        
        
        
    }
    /********************Added By Biswa End of SFDC-2155***************************/
    
    
    //Added By:Vinod Thupakula
    //SFDC-2797
    public static void seismicIndustryMapping(List<Account> accounts){
        Map<String,String> seismicSettings = new Map<String,String>();
        for(Seismic_Industry_Mapping__c seismic: [SELECT Industry__c,Seismic_Name__c FROM Seismic_Industry_Mapping__c WHERE IsDeleted = false ]){
            seismicSettings.put(seismic.Industry__c,seismic.Seismic_Name__c);
        }
        if(seismicSettings.size()>0){
            for(Account acc:accounts){
                if(String.isNotBlank(acc.Industry)&&seismicSettings.containsKey(acc.Industry)){
                    acc.Vertical__c = seismicSettings.get(acc.Industry);
                }
                else{
                    acc.Vertical__c = '';
                }
            }
        }
        
    }
    /***********************************************************************************
@Description        : This method is used for to Create/Update Company Owner 
As Company Team Member
@Author             : Anwesh kumar 
@Parameter          : none
@Return             : void
@Story              : SFDC-3627
@Test class         : CompanyTrigger_Test
**************************************************************************************/
    public static void AddCompanyTeamMember(List<Account> CMPACCList){
        
        Set<Id> OldAcc= new Set<Id> ();
        List<AccountTeamMember> teamList = new List<AccountTeamMember>();   
        Set<Id> userIds = new Set<Id>();
        Map<Id,List<Id>> CMPAccids = new Map<Id,List<Id>>();
        system.debug('CMPACCList..........'+CMPACCList);
        for(Account ac : CMPACCList){
            userIds.add(ac.OwnerId); 
            if(trigger.isInsert && ac.company_name__c != null){
                if(!CMPAccids.containsKey(ac.Company_Name__c)){
                    CMPAccids.put(ac.Company_Name__c,new List<Id>{ac.Id});
                }else if(CMPAccids.containsKey(ac.Company_Name__c)){
                    CMPAccids.get(ac.Company_Name__c).add(ac.Id);
                }
            }
        }
        
        Map<Id,User> userMap = new Map<Id,User>([SELECT Id FROM User WHERE Id IN : userIds AND IsActive=false]);
        
        //Added to copy company tem members to the product account team  list start
        if(CMPAccids != null && CMPAccids.size() > 0){        
            for(AccountTeamMember ATM: [SELECT id,AccountId,UserId,AccountAccessLevel,TeamMemberRole,CaseAccessLevel,ContactAccessLevel,OpportunityAccessLevel from AccountTeamMember WHERE AccountId IN : CMPAccids.keySet() AND User.isActive = true]){            
                if((ATM != null && !userMap.containsKey(ATM.UserId)) && CMPAccids.containsKey(ATM.AccountId)){
                    System.debug('ATMownerIDIN::' + ATM.userid);          
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
        //Added to copy company tem members to the product account team  list End
        
        For(Account ac : CMPACCList){        
            System.debug('acownerIDOutside::' + ac.ownerID);          
            if(trigger.isInsert && !userMap.containsKey(ac.OwnerId)){
                System.debug('acownerIDIN::' + ac.ownerID);
                String CMPorACCId;          
                if(System.Label.CompanyRecordTypes.contains(ac.RecordTypeId)){
                    CMPorACCId = ac.Id;
                }else if(System.Label.AccountRecordTypes.contains(ac.RecordTypeId)){
                    CMPorACCId = ac.Company_Name__c;
                }           
                teamList.add(new AccountTeamMember(AccountId = CMPorACCId,UserId=ac.ownerID,
                                                   AccountAccessLevel='Edit',TeamMemberRole='Account Executive',
                                                   CaseAccessLevel='Edit',
                                                   ContactAccessLevel='Edit',
                                                   OpportunityAccessLevel='Edit')); 
                
                //to add Product account as Teammember                               
                if(System.Label.AccountRecordTypes.contains(ac.RecordTypeId)){
                    System.debug('ATMteamListAfterinsert::.....1'+ac.id );
                    teamList.add(new AccountTeamMember(AccountId = ac.id,UserId=ac.ownerID,
                                                       AccountAccessLevel='Edit',TeamMemberRole='Account Executive',
                                                       CaseAccessLevel='Edit',
                                                       ContactAccessLevel='Edit',
                                                       OpportunityAccessLevel='Edit')); 
                    /* if(String.isNotBlank(ac.Account_Manager__c)&&(ac.Account_manager__r.isactive) ){

teamList.add(new AccountTeamMember(AccountId = ac.id,UserId=ac.Account_Manager__c,
AccountAccessLevel='Edit',TeamMemberRole='Account Manager',
CaseAccessLevel='Edit',
ContactAccessLevel='Edit',
OpportunityAccessLevel='Edit')); 
}*/
                }                                        
            }
            
            
            if(trigger.isUpdate && !userMap.containsKey(ac.OwnerId)){
                System.debug('acownerIDUU::' + trigger.isUpdate);
                System.debug('ac.OwnerId.......:' + ac.OwnerId);               
                if(((Map<Id,Account>)Trigger.newMap).get(ac.Id).OwnerId != ((Map<Id,Account>)Trigger.oldMap).get(ac.Id).OwnerId){
                    System.debug('ATMteamListAfterinsert::.....2'+ac.id );
                    teamList.add(new AccountTeamMember(AccountId = ac.Id,
                                                       UserId=ac.ownerID,AccountAccessLevel='Edit',
                                                       TeamMemberRole='Account Executive',CaseAccessLevel='Edit',
                                                       ContactAccessLevel='Edit',
                                                       OpportunityAccessLevel='Edit'));
                    
                    OldAcc.add(((Map<Id,Account>)Trigger.oldMap).get(ac.Id).OwnerId);
                    
                    //to add Product account as Teammember                                 
                    if(System.Label.AccountRecordTypes.contains(ac.RecordTypeId)){
                        System.debug('ATMteamListAfterinsert::.....3'+ac.id ); 
                        teamList.add(new AccountTeamMember(AccountId = ac.Company_Name__c,UserId=ac.ownerID,
                                                           AccountAccessLevel='Edit',TeamMemberRole='Account Executive',
                                                           CaseAccessLevel='Edit',
                                                           ContactAccessLevel='Edit',
                                                           OpportunityAccessLevel='Edit')); 
                        /* teamList.add(new AccountTeamMember(AccountId = ac.id,UserId=ac.Account_Manager__c,
AccountAccessLevel='Edit',TeamMemberRole='Account Manager',
CaseAccessLevel='Edit',
ContactAccessLevel='Edit',
OpportunityAccessLevel='Edit'));        */                                                         
                    }
                }
                
            }
        }        
        if(teamList.size()>0){
            Insert teamList;
            System.debug('ATMteamListAfterinsert::' + teamList.size());    
        }
        if(OldAcc.size()>0){
            
            List<AccountTeamMember> delMem = [Select id,AccountId,UserId From AccountTeamMember Where AccountId In : Trigger.newMap.keySet() AND  UserId In: OldAcc];
            Delete delMem;
        }
    }
    /*GTMO-295 start added by samba 
public static void PopulateMatchingRecordtype(){
list<Account> comlist = new list<Account>();
string CompanyRecordType =label.CompanyRecordTypes;
for(Account a: (List<Account>) Trigger.new){
if(CompanyRecordType.contains(a.Recordtypeid)){
a.Is_Company_Record__c = 'True';
comlist.add(a);
}else {
a.Is_Company_Record__c = 'False';
}             
}
}
GTMO-295 Ed added by samba*/ 
    
    //Added by Rajasekhar for GTMO-151 - Starts
    public static void unlockRecord(List<Account> AccList,Map<Id, Account> aMap)
    {
        //  System.debug('AccList:' + AccList);
        //List<Account> ListUnlockRecords =  new List<Account>();
        Map<Id,String> mapApprovals = New Map<Id,String>();
        Integer accSize = AccList.size();   
        for(Integer i=0;i<accSize;++i)
        {
            System.debug('aMapValue:' + aMap.get(AccList[i].Id).Menu_Pricing_Approved__c);
            if(AccList[i].Menu_Pricing_Approved__c == false && aMap.get(AccList[i].Id).Menu_Pricing_Approved__c == true)
            {
                mapApprovals.put(AccList[i].Id, 'Reject');
                //ListUnlockRecords.add(acc);
            }
            if(AccList[i].Menu_Pricing_Approved__c == true && aMap.get(AccList[i].Id).Menu_Pricing_Approved__c == false)
            {
                mapApprovals.put(AccList[i].Id, 'Approve');
                //ListUnlockRecords.add(acc);
            }
            
        }
        
        // for(Accounts__c acc: ListUnlockRecords)
        //{
        //    mapApprovals.put(acc.Id, 'Reject');
        // }
        
        System.debug('mapApprovals' + mapApprovals);
        if(mapApprovals.size()>0)
        {
            ApprovalHelper.ApproveRecords(mapApprovals, 'Comments');
        }
    }
    //Added by Rajasekhar for GTMO-151 - Ends
    
    //Added by Anitha for GTMO-150 - Starts      
    public static void UpdateContractingEntity(){
        System.debug('UpdateContractingEntity');
        // 6028 commented code
        //Boolean isSledRep = FeatureManagement.checkPermission('SLED_Reps');
        string AccountRecordtype=label.AccountRecordtypes;
        Map<String,Id> mapConEntities = new Map<String,Id>();
        String territory;
        List<Account> UpdatedAccs = new List<Account>();
        
        for (Account acc: (List<Account>)Trigger.New) {
            //SFDC-2260 - Added condition to check if contracting entity in old record is null
            
            
            if(AccountRecordtype.contains(acc.Recordtypeid)) { 
                
                
                try{
                    if((((String.isNotBlank(acc.ShippingCountry)|| String.isNotBlank(acc.ShippingCountryCode))&& 
                         trigger.isInsert && 
                         acc.recordtypeid!=(system.Label.AccountGovernmentRecordTypeId)) || 
                         ((String.isNotBlank(acc.ShippingCountry)|| String.isNotBlank(acc.ShippingCountryCode)) && 
                         trigger.isUpdate && 
                         (((Map<Id, Account>)Trigger.oldMap).get(acc.Id).ShippingCountry != acc.ShippingCountry ||
                         ((Map<Id, Account>)Trigger.oldMap).get(acc.Id).ShippingCountryCode != acc.ShippingCountryCode ||
                          ((Map<Id, Account>)Trigger.oldMap).get(acc.Id).Company_Name__c != acc.Company_Name__c) && 
                         ((Map<Id, Account>)Trigger.oldMap).get(acc.Id).Contracting_Entity__c == null))){
                             //6028 commented code
                             //((Map<Id, Account>)Trigger.oldMap).get(acc.Id).Contracting_Entity__c == null)) && !isSledRep){
                             UpdatedAccs.add(acc);
                         }
                    // below code has been added as Part of SFDC-3018 by Raushan Kumar
                    else if(trigger.isInsert && 
                            (acc.recordtypeid==(system.Label.AccountGovernmentRecordTypeId))){            
                                acc.NotifiedSystems__c=system.label.AccountNotifiedSystems;
                                acc.Contracting_Entity__c=system.label.ContractingEntity;
                                if(acc.Type!='Cloud Customer'){
                                	acc.Type=system.label.Account_Type;
                                }
                            }
                  /*  6028 commented code
                   * else if(trigger.isInsert && isSledRep){
                        acc.Contracting_Entity__c=system.label.ContractingEntity;
                        acc.Type=system.label.Account_Type;
                        
                    }*/
                }
                catch (Exception e) {
                    ExceptionHandler.postToAll(e);
                    throw new CustomException(e.getMessage());
                }
            }
        }
        for (Contracting_Entity__c con : [select Id, Name, territory__c, Country__c from Contracting_Entity__c]) {
            mapConEntities.put(con.territory__c, con.Id);           
        }
        
        // System.debug(' UpdatedAccs ' + UpdatedAccs);
        
        if(UpdatedAccs.size() > 0) {
            for(Account a : UpdatedAccs) {  
                //    System.debug('Update Contract Contracting--acc2  '+a.Recordtypeid);
                if(AccountRecordtype.contains(a.Recordtypeid)) { 
                    
                    // System.debug(' ShippingCountry....' + a.ShippingCountry);
                    //  System.debug(' ShippingCountryCode...' + a.ShippingCountryCode);
                    //if((a.ShippingCountryCode== 'US') && (a.CompanyOwnerRegion__c== 'AMER')) {
                    if(((a.ShippingCountry== 'United States')||(a.ShippingCountryCode== 'US'))&& (a.CompanyOwnerRegion__c== 'AMER')) {
                        territory = 'US/CANADA';
                    }
                    else {
                        territory = 'International';
                    }                                   
                    if(!(a.Contracting_Entity__c != NULL && 
                         Label.ContractingEntitiesToSkip.contains(a.Contracting_Entity__c))) {
                             //  System.debug('Map CE is : ' + mapConEntities);
                             a.Contracting_Entity__c = mapConEntities.get(territory);
                         }
                }   
            }
        }                             
        
        /***Approval Process not required for now -- Change from business ***
//********** Update Contracting Entity upon Contracting Entity Approved **********/
        if(trigger.isUpdate) { 
            for (Account acc: (List<Account>)Trigger.New) {   
                System.debug('Update Contract Contracting--acc  '+acc.Recordtypeid);
                System.debug(system.Label.AccountGovernmentRecordTypeId);
                if(AccountRecordtype.contains(acc.Recordtypeid)) {
                    if(acc.recordtypeid==(system.Label.AccountGovernmentRecordTypeId) && acc.NotifiedSystems__c!=system.label.AccountNotifiedSystems && acc.Type!='Customer' && !system.label.System_Admin_Integration_Profiles.contains(UserInfo.getProfileID())){
                        acc.adderror('Notified System Value cannot be changed for Government Records.');
                    }
                    if(acc.DP_CustomerId__c==Null&&acc.recordtypeid==(system.Label.AccountGovernmentRecordTypeId)&& ((Map<Id,Account>)Trigger.oldMap).get(acc.Id).DP_CustomerId__c!=acc.DP_CustomerId__c ){               
                        acc.adderror('A DP Customer ID is required for Government accounts.  Please contact your Salesforce Support Team');
                    }
                    if(acc.Change_Contracting_Entity__c==False &&acc.Contracting_Entity__c!=system.label.ContractingEntity  && acc.recordtypeid==(system.Label.AccountGovernmentRecordTypeId) && acc.Type!='Customer' && !system.label.System_Admin_Integration_Profiles.contains(UserInfo.getProfileID())){
                        acc.adderror('If you want to change Contracting Entity Value.Please check the "Change Contracting Entity?" Field');
                    }
                    if(String.isNotBlank(acc.Contracting_Entity_to_Approve__c)) {      
                        //  System.debug('Update Contract Contracting  ');
                        if(acc.ContractingEntityApproved__c == 'Approved') {
                            //acc.Contracting_Entity__c = acc.NewContractingEntity__c;
                            acc.Contracting_Entity__c = acc.Contracting_Entity_to_Approve__c;
                            acc.ContractingEntityApproved__c = '';
                        }   
                    }
                }
            }
        }    
    }
    
    //Added by Anithafor GTMO-150 - Starts
    
    
    // Added by Anjaneyulu for SFSB-610
    public static void copyContactAddressToAcrs(){
        System.debug('copyContactAddressToAcrs');
        try{
            Set<String> companyIds = new Set<String>();
            string AccountRecordtype=label.AccountRecordtypes;
            // List<Id> AccIds = CMPorACCRecordType_Utility.query_Utility(Label.AccountRecordTypes);
            //  System.debug(' trigger.new ' + trigger.new);
            for(Account acc: (List<Account>) Trigger.new)
            {
                // System.debug('a.Recordtypeid.... '+a.Recordtypeid);
                if(AccountRecordtype.contains(acc.Recordtypeid)) {
                    companyIds.add(acc.Company_Name__c);
                }               
            }
            
            //  System.debug(' companyIds ' + companyIds);
            
            if(companyIds.isEmpty() == true ){
                return; 
            }
            
            Map<Id,Account> companies = new Map<Id,Account>([Select id,BillingCountry,BillingPostalCode,BillingStreet,BillingState,BillingCity,ShippingStreet,ShippingCity,ShippingState,ShippingCountry,ShippingCountryCode,ShippingPostalCode,OwnerId from Account where id in : companyIds]);
            
            //  System.debug(' companies ' + companies);
            
            if(companies == null || companies.isEmpty() == true) {
                return;
            }
            
            //   SYstem.debug(' updated Account 0 ' + Trigger.new);
            
            for(Account a : (List<Account>) Trigger.new){
                if(AccountRecordtype.contains(a.Recordtypeid)) {
                    
                    Account company = companies.get(a.Company_Name__c);
                    
                    // System.debug(' Shippin ' + (String.isBlank(a.ShippingCountryCode) && String.isBlank(a.shippingstatecode)));
                    
                    // System.debug(' Billing ' + (String.isBlank(a.BillingStateCode) && String.isBlank(a.BillingCountryCode)));
                    
                    if(String.isBlank(a.ShippingCountryCode) && string.isblank(a.shippingstatecode))
                    { // added by Abhi SFDC-270
                        a.ShippingStreet = company.ShippingStreet;
                        a.ShippingCity = company.ShippingCity;
                        a.ShippingState = company.ShippingState;
                        a.ShippingCountry = company.ShippingCountry;
                        a.ShippingPostalCode = company.ShippingPostalCode; 
                    }
                    if(String.isBlank(a.BillingStateCode) && String.isBlank(a.BillingCountryCode))
                    {
                        a.BillingStreet = company.BillingStreet;
                        a.BillingCity = company.BillingCity;
                        a.BillingState = company.BillingState;
                        a.BillingCountry = company.BillingCountry;
                        a.BillingPostalCode = company.BillingPostalCode;
                    }
                    System.debug('ownerId::' + a.OwnerId);
                    if(a.OwnerId==null)
                        a.OwnerId=company.OwnerId;
                }
            }
            
            //  SYstem.debug(' updated Account ' + Trigger.new);
            
        }catch (Exception e) {
            System.debug(' In to Exception ' + e.getMessage());
            ExceptionHandler.postToAll(e);
            throw new CustomException(e.getMessage());
        }
    }
    //Added by Anitha for GTMO-150 - Ends
    //@author : Anitha
    /***********Insert AccountRole************/    
    public static void insertAccountRole() {
        //List<Id> AccIds = CMPorACCRecordType_Utility.query_Utility(Label.AccountRecordTypes);
        string AccountRecordtype=label.AccountRecordtypes;
        list<AccountContactRelation > listInsertRoles = new list<AccountContactRelation >();
        List<AccountContactRelation> listToUpdate = new List<AccountContactRelation>();
        set<Id> companyIds = new set<Id>();
        map<Id, AccountContactRelation > contMap = new Map<Id, AccountContactRelation >();
        
        for(Account a : (List<Account>)trigger.new)  {
            //System.debug('a.recordtypeid in for companyTrigger helper....'+a.recordtypeid);
            if(AccountRecordtype.contains(a.Recordtypeid)) {
                //System.debug('a.AccountRecordtype in for companyTrigger helper....'+a.recordtypeid);  
                companyIds.add(a.Company_Name__c);    
            }
        }
        
        if(companyIds.isEmpty() == true ){
            return;
        }
        System.debug('cpomany trigger helper companyIds....'+companyIds);
        //get the primary contact role under company
        for(AccountContactRelation  c : [SELECT Id,accountId,contactId,Contact.Email,Contact.NPS_Survey_Opt_Out__c,Roles FROM AccountContactRelation  
                                         WHERE accountId IN :companyIds order by  CreatedDate asc LIMIT 1 ]){
                                             contMap.put(c.accountId, c);
                                             // System.debug('cc.accountId....'+c.accountId);
                                             // System.debug('cc.companyIds ....'+companyIds );
                                         }
        
        
        // Added by Anjaneyulu for SFSB-446 Starts
        Set<String> existingRole = new Set<String>();
        for(AccountContactRelation acr :[Select id,AccountId,ContactId,Contact.Email,Contact.NPS_Survey_Opt_Out__c,Roles from AccountContactRelation where Roles='Primary Contact' and  AccountId in : Trigger.newmap.keyset()]){
            existingRole.add(acr.AccountId+'_'+acr.Roles);
        }
        // Added by Anjaneyulu for SFSB-446 Ends
        List<String> Skip_Colle_Status           = System.Label.NPS_Skip_Collection_Status.split(',');
        String accStatus                         = System.Label.NPS_Account_Status;
        //String unQuali                           = System.Label.NPS_Skip_Unqualified;
       /* String SFDomain                          = System.Label.NPS_Skip_Email_Domain1;
        String rackDomain                        = System.Label.NPS_Skip_Email_Domain2;*/
       	list<string> skipemaildomains=System.Label.NPSallexclusionemails.split(','); // Emails excluded From ACR Creation
        List<String> Skip_OnicaCEIds             = System.Label.NPS_Skip_OnicaCntrType.split(',');
        for(Account a : (List<Account>)trigger.new) {
            
            AccountContactRelation  c = contMap.get(a.Company_Name__c);
            //System.debug('AccountContactRelation  c....'+c);
            
            // && !existingRole.contains(a+'_'+c.contactId+'_Primary Contact') Added to the below by Anjaneyulu for SFSB-446
            if(AccountRecordtype.contains(a.Recordtypeid)) {
                if(c != null && !existingRole.contains(a.Id+'_Primary Contact')) {
                    System.debug('company trigger helper a.recordtypeid in for....'+a.id);
                    AccountContactRelation acr = new AccountContactRelation(AccountId = a.Id, ContactId = c.contactId,Roles = 'Primary Contact');
                                        Boolean isEmail = false;
                    
                    if(!String.isBlank(c.Contact.Email)){
                        isEmail = Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}', String.valueOf(c.Contact.Email).trim());
                    }
                   //Removed this from below /*&& (!c.Contact.Email.toLowerCase().contains(SFDomain) && !c.Contact.Email.toLowerCase().contains(rackDomain))*/ 
                    if((a.Contracting_Entity__c == null || !Skip_OnicaCEIds.contains(a.Contracting_Entity__c)) && (!String.isBlank(a.NPS_Collection_Status__c) && !Skip_Colle_Status.contains(a.NPS_Collection_Status__c)) && (a.status__c == accStatus) && (isEmail && c.Contact.NPS_Survey_Opt_Out__c == false) 
                     && !skipemaildomains.contains(c.contact.Email.toLowerCase().split('@').get(1))
 
                      ){
                        acr.Roles += ';' + System.Label.NPS_Contact_Role;
                    }

                    
                    listInsertRoles.add(acr);
                    
                }
                
            }
            
        }
        
        
        //insert all primary contact role records in AccountContactRelation
        if(!listInsertRoles.isEmpty())      
            insert listInsertRoles;
        
        
        
        
    }
    
    @Future
    public static void PopulateRollupSummeryviaFuture(set<id> cmpids){
        CompanyTriggerHelper.PopulateRollupSummeryfields(cmpids);        
    }
    
    //GTMO-466 added by samba, Start    
    public static void PopulateRollupSummeryfields(set<id> cmpids ){
        Map<Id,Account> accMap = new Map<Id,Account>();
        List<AggregateResult> groupedResults = new List<AggregateResult>();
        Integer aggSize;
        list<account> accountslist = new list<account>();
        System.debug('cmpids.....'+ cmpids.size());
        if(cmpids.size()>0){
            groupedResults = [select count(Id) cnt,Company_Name__c cmp,Type tp from Account where Company_Name__c IN :cmpids group by Company_Name__c,Type];
        }
        aggSize = groupedResults.size();
        for(Integer i=0;i<aggSize;++i){
            Id cmpId = (Id)groupedResults[i].get('cmp');
            System.debug('cmpId::' + cmpId);
            if(!accMap.containsKey(cmpId)){
                accMap.put(cmpId, new Account(id=cmpid,Number_of_Accounts__c=0,Number_of_Cloud_Customer_Accounts__c=0,Number_of_Cloud_Accounts__c=0,Number_of_Customer_Accounts__c=0,Total_of_Prospects__c=0,Total_of_Former_Cloud_Customers__c=0,Total_of_Former_Customers__c=0));
            }
            if(accMap.containsKey(cmpId)){
                Integer ccnum;
                ccnum = (Integer)accMap.get(cmpId).Number_of_Accounts__c;
                ccnum += (Integer)groupedResults[i].get('cnt');
                accMap.get(cmpId).Number_of_Accounts__c = ccnum;
                if(groupedResults[i].get('tp') == 'Prospect'){
                    ccnum = (Integer)accMap.get(cmpId).Total_of_Prospects__c;
                    ccnum += (Integer)groupedResults[i].get('cnt');
                    accMap.get(cmpId).Total_of_Prospects__c = ccnum;
                    System.debug('ccnum ;;;::' + ccnum );
                }else if(groupedResults[i].get('tp') == 'Cloud Customer'){
                    ccnum = (Integer)accMap.get(cmpId).Number_of_Cloud_Customer_Accounts__c;
                    ccnum += (Integer)groupedResults[i].get('cnt');
                    accMap.get(cmpId).Number_of_Cloud_Customer_Accounts__c=ccnum;
                    accMap.get(cmpId).Number_of_Cloud_Accounts__c=ccnum;
                }else if(groupedResults[i].get('tp') == 'Customer'){
                    ccnum = (Integer)accMap.get(cmpId).Number_of_Customer_Accounts__c;
                    ccnum += (Integer)groupedResults[i].get('cnt');
                    accMap.get(cmpId).Number_of_Customer_Accounts__c=ccnum;
                }else if(groupedResults[i].get('tp') == 'Former Cloud Customer'){
                    ccnum = (Integer)accMap.get(cmpId).Total_of_Former_Cloud_Customers__c;
                    ccnum += (Integer)groupedResults[i].get('cnt');
                    accMap.get(cmpId).Total_of_Former_Cloud_Customers__c=ccnum;
                }else if(groupedResults[i].get('tp') == 'Former Customer'){
                    ccnum = (Integer)accMap.get(cmpId).Total_of_Former_Customers__c;
                    ccnum += (Integer)groupedResults[i].get('cnt');
                    accMap.get(cmpId).Total_of_Former_Customers__c=ccnum;
                }
            }       
        }
        System.debug('accMap::' + accMap.size());
        if(accMap.size()>0){
            update accMap.values();
        }
    }
    //GTMO-466 added by samba, End
    //SFDC-4456 added by sundarayya
    //Before Insert if the parent company is master agent then populate master_agent_info__c field by parent company id
    public static void populateMasterAgentInfo(List<Account> newAccList){
        system.debug('newAccList'+newAccList);
        list<Id> accParentIds = new List<Id>();
        set<Id> accId =new set<Id>();
        Map<Id, Id> IdtoParentIdMap = new Map<Id, Id>();
        for(Account acc : newAccList){
            //accId.add(acc.Id);
            
            accParentIds.add(acc.ParentId);
            
        }
        system.debug('AccList'+accParentIds);
        if(accParentIds.size() > 0){
            for(Account a : [select Id,Partner_level__c from Account where Id IN:accParentIds]){
                if(a.Partner_Level__c == 'Master Agent' ){
                    IdtoParentIdMap.put(a.Id, a.Id);
                }
            }
        }
        //system.debug('IdtoParentIdMap'+ IdtoParentIdMap);
        
        for(Account ac : newAccList){
            if(IdtoParentIdMap.containskey(ac.ParentId)){
                ac.Master_Agent_Info__c = IdtoParentIdMap.get(ac.ParentId);
            }
        }
    }
    
    
    //SFDC-4456 added by sundarayya
    //Before Update for updating partner companies Master Agent info if parent company changed partner level is 'Master Agent' 
    //and Deleting Master Agent Info on partner company if changed parent company partner level not equals to 'Master agent'
    public static void popMasterAgentInfoBU(List<Account> newAccList, Map<Id, Account> oldMap){
        Set<Id> masterAgentAccIds = new Set<Id>();
        Set<Id> notMasterAgentAccIds = New Set<Id>();
        Set<Id> ParentChangeAccIds = New Set<Id>();
        for(Account acc: newAccList){
            if(acc.Partner_Level__c != oldMap.get(acc.Id).Partner_level__c 
               && acc.Partner_level__c == 'Master Agent' ){
                   masterAgentAccIds.add(acc.Id);   
               }else if(acc.Partner_Level__c != oldMap.get(acc.Id).Partner_level__c 
                        && oldMap.get(acc.Id).Partner_level__c == 'Master Agent' ){
                            notMasterAgentAccIds.add(acc.Id);
                            
                        }else if(acc.ParentId != oldMap.get(acc.Id).ParentId){
                            ParentChangeAccIds.add(acc.ParentId);
                            //system.debug('ParentChnagesAccIDs'+ParentChangeAccIds);
                        }
        }
        List<Account> updateAcclist = new List<Account>();
        Id nullId = null;
        If(masterAgentAccIds.size()> 0){
            for(Account childAcc : [Select Id, Master_Agent_Info__c, ParentId, Parent.Partner_Level__c from Account where ParentId IN: masterAgentAccIds ]){
                childAcc.Master_Agent_Info__c = childAcc.ParentID;
                updateAcclist.add(childAcc);
            }
        }else if(notMasterAgentAccIds.size() > 0){
            for(Account childAcc : [Select Id, Master_Agent_Info__c, ParentId, Parent.Partner_Level__c from Account where ParentId IN: notMasterAgentAccIds]){
                childAcc.Master_Agent_Info__c = nullId;
                updateAcclist.add(childAcc);
            }
        }else if(ParentChangeAccIds.size() > 0){
            //system.debug('entered' + ParentChangeAccIds);
            Map<Id,Account> parentChangedAccMap =new Map<Id,Account>([Select Id,Name,Partner_level__c from Account where Id IN: ParentChangeAccIds]);
            for(Account acc : newAccList){
                
                if(parentChangedAccMap.containsKey(acc.ParentId) &&  parentChangedAccMap.get(acc.ParentId).Partner_Level__c== 'Master Agent' ){
                    
                    acc.Master_Agent_Info__c = acc.ParentId;
                }else if(parentChangedAccMap.containsKey(acc.ParentId) && parentChangedAccMap.get(acc.ParentId).Partner_Level__c != 'Master Agent'){
                    acc.Master_Agent_Info__c = nullId;
                }
                //updateAcclist.add(acc);
            }
        }
        
        if(updateAcclist.size() > 0){
            Update updateAcclist;
        }
        
    }
    //SFDC-4456 ED added by sundar
    
    //VerifyMerge
    public static void VerifyMerge(List<Account> Mergeaccs){
        Map<Id, Account> companiesMap = new Map<Id, Account>(Mergeaccs);
        // system.debug('companiesMap'+companiesMap);
        set<id> companiesid = companiesMap.keyset();
        List<Account> acclist=[select id,recordtypeid from account where id in:companiesid];
        //system.debug('acclist'+acclist);
        List<account> deletedacc =  [select id, name,MasterRecordId,Recordtype.name from account where isDeleted = true and LastModifiedDate=today and MasterRecordId!='' ALL ROWS];
        //system.debug('deletedacc-----'+deletedacc);
        // system.debug(deletedacc);
        for(Account accc:deletedacc)
        {
            // system.debug('deletedacc rec Id'+accc.recordTypeId);
            for(Account acc:acclist){
                // system.debug('Mergeaccs rec Id'+acc.recordTypeId);
                
                if(companiesid.contains(accc.MasterRecordId))
                {
                    //system.debug('acc.recordtypeid-----'+acc.recordtypeid);
                    // system.debug('accc.recordtypeid-----'+accc.recordtypeid);
                    if(acc.recordtypeid!=accc.recordtypeid || accc.recordtypeid!=acc.recordtypeid){
                        throw new CustomException('You cannot perform merge operation');
                    }
                }
            }
        } 
    }
    //Below Class created for SFDC-2909 by Raushan
    //It will Insert Account Team Member whenever a Custom Account with manager will be created or updated. 
  /*  public static void createOrUpdateAccountTeamMembers(){
        set<id> cmpid=new set<id>();
        string userid;
        List<AccountTeamMember> atms = new List<AccountTeamMember>();
        if(Trigger.isInsert){
            Set<Id> accid=New set<Id>();
            for(Account a:(List<Account>)Trigger.new){
                if(String.isNotBlank(a.Account_Manager__c) && a.Account_manager__c!=a.ownerid){
                    accid.add(a.id);
                    cmpid.add(a.Company_Name__c);
                    userid=a.Account_Manager__c;
                }
            }
            system.debug('accid-----------'+accid);
            //for(Account a :[Select id,Company_Name__c,name,Account_Manager__c,Account_manager__r.isactive from Account where id =: accid] ){
            for(Account a :[Select id,Company_Name__c,name,Account_Manager__c,Account_manager__r.isactive from Account where Company_Name__c =: cmpid] ){
                if(String.isNotBlank(a.Account_Manager__c)&&(a.Account_manager__r.isactive)){
                    atms.add(new AccountTeamMember(AccountId=a.Company_Name__c,
                                                   UserId = a.Account_Manager__c,
                                                   OpportunityAccessLevel='Edit',
                                                   contactaccesslevel='Edit',
                                                   accountaccesslevel='Edit',
                                                   caseaccesslevel='None',
                                                   TeamMemberRole='Account Manager'));
                    atms.add(new AccountTeamMember(AccountId=a.id,
                                                   UserId = userid,
                                                   OpportunityAccessLevel='Edit',
                                                   contactaccesslevel='Edit',
                                                   accountaccesslevel='Edit',
                                                   caseaccesslevel='None',
                                                   TeamMemberRole='Account Manager'));
                }
                
                
            }
            system.debug('atms-----------'+atms);
            
            
        }
        
        if(Trigger.isUpdate){
            
            Map<id,Account> accmap=New Map<id,Account>();
            Map<Id,String> oldaccIdVsManagerId = new Map<Id,String>();
            Set<Id> updateaccid=New set<Id>();
            set<id> oldmngrid=new set<id>();
            
            List<AccountTeamMember> delatms = new List<AccountTeamMember>();
            for(Account a:(List<Account>)Trigger.new){
                if(String.isNotBlank(a.Account_Manager__c)){
                    updateaccid.add(a.id);
                }
            }
            if(updateaccid.size()>0){
                for(Account acc:[select id,name,Company_Name__c,account_manager__c,Account_Manager__r.isactive from Account where id =:updateaccid]){
                    accmap.put(acc.id,acc);
                }
            }
            List<id> oldAccmanager =new list<id>();
            List<id> newaccmanager=new list<id>();
            string newaccid;
            List<string> acclistprod=new list<string>();
            
            for(Integer i=0;i<Trigger.size;i++){
                Account newAcc = (Account)Trigger.new[i];
                Account oldAcc = (Account)Trigger.old[i];            
                if(newAcc.Account_Manager__c != oldAcc.Account_Manager__c){
                    if(String.isNotBlank(newAcc.Account_Manager__c)&&(accmap.get(newAcc.id).Account_manager__r.isactive)){
                        atms.add(new AccountTeamMember(AccountId=newAcc.Company_Name__c,UserId = newAcc.Account_Manager__c,OpportunityAccessLevel='Edit',contactaccesslevel='Edit',accountaccesslevel='Edit',caseaccesslevel='None',TeamMemberRole='Account Manager'));
                        
                        atms.add(new AccountTeamMember(AccountId=newAcc.id,UserId = newAcc.Account_Manager__c,OpportunityAccessLevel='Edit',contactaccesslevel='Edit',accountaccesslevel='Edit',caseaccesslevel='None',TeamMemberRole='Account Manager'));
                    }
                    // oldaccIdVsManagerId.put(oldAcc.company_name__c,oldAcc.company_name__c+'_'+oldAcc.Account_Manager__c);
                    //oldaccIdVsManagerId.put(oldAcc.id,oldAcc.id+'_'+oldAcc.Account_Manager__c);
                    cmpid.add(newAcc.company_name__c);
                    oldmngrid.add(oldAcc.Account_Manager__c);
                    
                    userid=oldAcc.Account_Manager__c;          
                    
                }
            }   
            
            List<id> accid=new List<id>();
            
            List<Account> prodacclist=[Select Id,Company_Name__c,Account_Manager__c from Account where Company_Name__c in:cmpid];       
            List<AccountTeamMember> atmlist=[Select Id,UserId,AccountId,Account.Account_Manager__c,Account.RecordTypeId from AccountTeamMember where (AccountId in :prodacclist or Accountid in:cmpid) and userid in :oldmngrid];
            for(AccountTeamMember atm:atmlist){     
                if(atm.Account.Account_Manager__c!=userid ){      
                    delatms.add(atm);
                }      
            }                
            if(delatms.size() >0){
                Delete delatms; 
            }          
            for(Account atm2:prodacclist){
                if(atm2.Account_Manager__c==userid){
                    accid.add(atm2.id);
                    
                }
            }
            if(!accid.isempty()){
                
                for(Integer i=0;i<Trigger.size;i++){
                    Account newAcc = (Account)Trigger.new[i];
                    Account oldAcc = (Account)Trigger.old[i];            
                    if(newAcc.Account_Manager__c != oldAcc.Account_Manager__c){
                        //if(String.isNotBlank(newAcc.Account_Manager__c)&&(accmap.get(newAcc.id).Account_manager__r.isactive) && userid!=null){
                        if(userid!=null){
                            atms.add(new AccountTeamMember(AccountId=newAcc.Company_Name__c,UserId = userid,OpportunityAccessLevel='Edit',contactaccesslevel='Edit',accountaccesslevel='Edit',caseaccesslevel='None',TeamMemberRole='Account Manager'));
                            
                            atms.add(new AccountTeamMember(AccountId=newAcc.id,UserId = userid,OpportunityAccessLevel='Edit',contactaccesslevel='Edit',accountaccesslevel='Edit',caseaccesslevel='None',TeamMemberRole='Account Manager'));
                            
                            
                        }
                    }
                }
            } 
            
            
            /*   if(!oldaccIdVsManagerId.isEmpty()){

Set<String> managerIDAccId = new Set<String>();
for(Account acc : [Select Id,Company_Name__c,Account_Manager__c from Account where Company_Name__c in :oldaccIdVsManagerId.keySet() and Id not in : Trigger.newmap.keySet() ]){

managerIDAccId.add(acc.Company_Name__c+'_'+acc.Account_Manager__c);

}

for(AccountTeamMember atm : [Select Id,UserId,AccountId from AccountTeamMember where AccountId in : oldaccIdVsManagerId.keySet()]){
if(oldaccIdVsManagerId.values().contains(atm.AccountId+'_'+atm.UserId) && !managerIDAccId.contains(atm.AccountId+'_'+atm.UserId))   
delatms.add(atm);
}

if(delatms.size() >0)
Delete delatms;

}*/                        
      /*  }
        if(!atms.isEmpty())
            Insert atms;
    }  */  
    //added by sundarayya e: SFDC-5701 @@ moving Process builder to code 
    //GTMO_AutoUpdateRegionAndPartnerlevelOnContact process builder to code\\
    @future
    public static void updateRegionAndPartLevelOnContact(Set<Id> newAccList){
        Id recordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
        Map<Id, Account> newAccMap = new Map<Id, Account>([select Id ,RecordTypeId, Opt_Out__c,Partner_Level__c, Territory__c from Account where Id IN: newAccList]);
        list<contact> childConList = [Select Id, AccountId,Partner_Level__c,HasOptedOutOfEmail, HasOptedOutOfFax, Partner_Region__c from Contact where AccountId IN: newAccList];
        
        list<Contact> contactsToUpdate = new List<contact>();
        Map<Id,contact> updateconMap = New Map<Id, Contact>();
        if(childConList.size() > 0){
            childConList.sort();
            for(Contact con : childConList ){
                if(newAccmap.get(con.AccountId).RecordTypeId == recordTypeId && (con.Partner_Level__c != newAccMap.get(con.AccountId).Partner_Level__c || con.Partner_Region__c != newAccMap.get(con.AccountId).Territory__c)){
                    con.Partner_Level__c = newAccMap.get(con.AccountId).Partner_Level__c;
                    con.Partner_Region__c = newAccMap.get(con.AccountId).Territory__c;
                    //contactsToUpdate.add(con);
                    updateconMap.put(con.Id, con);
                }
                //system.debug('con.AccountId).Opt_Out__c......'+ newAccMap.get(con.AccountId).Opt_Out__c);
                //system.debug('con.HasOptedOutOfEmail...........'+con.HasOptedOutOfEmail);
                if(newAccMap.get(con.AccountId).Opt_Out__c == true && (con.HasOptedOutOfEmail == false || con.HasOptedOutOfFax == false) ){
                    //system.debug('isUpdateOptOut.............entered');
                    con.HasOptedOutOfEmail = true;
                    con.HasOptedOutOfFax = true;
                    //contactsToUpdate.add(con);
                    updateconMap.put(con.Id, con);
                }else if(newAccMap.get(con.AccountId).Opt_Out__c == false && (con.HasOptedOutOfEmail == true || con.HasOptedOutOfFax == true)){
                    //system.debug('isUpdateOptOut.............entered');
                    con.HasOptedOutOfEmail = false;
                    con.HasOptedOutOfFax = false;
                    //contactsToUpdate.add(con);
                    updateconMap.put(con.Id, con);
                }
            }
        }
        if(updateconMap.size() > 0){update updateconMap.values();}
    }
    //method ends SFDC-5701  
    
    //Added for SFDC-5613 
    // Add Transition manager role in Company team
  /*  public static void addTransitionManagerRoleOnCompanyTeam(){
        Map<Id,Set<Id>> usertoaccsid =new Map<Id,Set<Id>>();
        Map<Id,List<AccountTeamMember>> oldusertoteamid =new Map<Id,List<AccountTeamMember>>();
        Map<String,List<id>> mapAccountWiseCusacc = new Map<String,List<id>>();
        Map<String,List<id>> oldmapAccountWiseCusacc = new Map<String,List<id>>();
        //  Map<id,id> Accounttocompany = new Map<id,id>();
        List<id> allacclist=new List<id>();
        Map<Id,List<Id>> Acctoallacc =new Map<Id,List<Id>>();
        Map<Id, Account> accoldMap = (Map<Id, Account>)Trigger.oldMap;
        Set<String> stAccOldIds = new Set<String>();
        
        Set<String> stAccIds = new Set<String>();
        List<AccountTeamMember> NewTransteammem = new List<AccountTeamMember>();        
        List<AccountTeamMember> delTransteammem = new List<AccountTeamMember>();  
        //List<AccountTeamMember> deloldTeammem = new List<AccountTeamMember>();        
        
        
        For(Account acc : (List<Account>)Trigger.new)
        {
            if((trigger.isinsert) || (trigger.isupdate && acc.Transition_Manager__c!= accoldMap.get(acc.id).Transition_Manager__c )){
                
                //  if(String.isNotBlank(acc.Transition_Manager__c) && acc.Transition_Manager__c!=acc.ownerid)
                if(String.isNotBlank(acc.Transition_Manager__c))
                    
                    stAccIds.add(acc.company_name__c);//will get standardAccount Id's
            }
        }
        if(trigger.isupdate){
            for(Account a:(List<Account>)Trigger.new){
                if((a.Transition_Manager__c != accoldMap.get(a.Id).Transition_Manager__c) ){
                    stAccOldIds.add(a.company_name__c);
                }
            }}
        
        if(!stAccIds.isempty()){
            List<account> customacc = [select id,company_name__c from account where company_name__c in :stAccIds ];
            
            
            
            
            if(customacc.size()>0){
                For(account cusacc : customacc)
                {
                    if(mapAccountWiseCusacc.containsKey(cusacc.company_name__c))
                    {
                        List<id> lstCont = mapAccountWiseCusacc.get(cusacc.company_name__c);
                        lstCont.add(cusacc.id);
                        mapAccountWiseCusacc.put(cusacc.company_name__c,lstCont);
                    }
                    else
                    {
                        List<id> lstCont = new List<id>();
                        lstCont.add(cusacc.id);
                        mapAccountWiseCusacc.put(cusacc.company_name__c,lstCont);
                    }
                    
                }
            }
            
            for(Account a:(List<Account>)Trigger.new){
                if(a.Transition_Manager__c!=null && mapAccountWiseCusacc.containskey(a.company_name__c) ){
                    if(usertoaccsid.containsKey(a.Transition_Manager__c)){
                        set<id> allaccountid = usertoaccsid.get(a.Transition_Manager__c);
                        allaccountid.add(a.id);
                        allaccountid.add(a.Company_Name__c);
                        allaccountid.addAll(mapAccountWiseCusacc.get(a.Company_Name__c));  
                        usertoaccsid.put(a.Transition_Manager__c,allaccountid);                                                            
                    }
                    else{                   
                        Set<Id> allaccountid= new set<id>();
                        allaccountid.add(a.id);
                        allaccountid.add(a.Company_Name__c);
                        allaccountid.addAll(mapAccountWiseCusacc.get(a.Company_Name__c));
                        usertoaccsid.put(a.Transition_Manager__c,allaccountid);                        
                    }
                    
                } 
            }
            
            if(!usertoaccsid.isempty()) {
                for(id acctoteammemebr:usertoaccsid.keyset()){
                    
                    for(id useracc:usertoaccsid.get(acctoteammemebr)){                   
                        NewTransteammem.add(new AccountTeamMember(AccountId=useracc,
                                                                  UserId = acctoteammemebr,
                                                                  OpportunityAccessLevel='Edit',
                                                                  contactaccesslevel='Edit',
                                                                  accountaccesslevel='Edit',
                                                                  caseaccesslevel='None',
                                                                  TeamMemberRole='Transition Manager'));
                        
                        
                    }
                    
                }
                
            }
        }
        if(!stAccIds.isempty()||!stAccOldIds.isempty()){
            List<account> oldcustomacc = [select id,company_name__c,Transition_Manager__c from account where company_name__c in :stAccOldIds or id in:stAccOldIds ];
            Map<Id, id> oldcustomaccmap = new Map<Id, id>(); 
            //List<Account> oldcustomacctouserid=[select Transition_Manager__c from account where company_name__c in :stAccOldIds or id in:stAccOldIds ];
            List<AccountTeamMember> oldTeammem=[select id,UserId,AccountId,Account.Transition_Manager__c,TeamMemberRole from AccountTeamMember
                                                where   AccountId=:oldcustomacc  and TeamMemberRole='Transition Manager' ];
            
            Map<Id, AccountTeamMember> oldTeammemmap = new Map<Id, AccountTeamMember>(oldTeammem);
            
            for(Account oldcustid:oldcustomacc){
                if(oldcustid.Transition_Manager__c!=null){
                    oldcustomaccmap.put(oldcustid.Transition_Manager__c,oldcustid.id);
                }
            }
            For(AccountTeamMember cusaccteam : oldTeammem)
            {
                if(oldusertoteamid.containsKey(cusaccteam.userid))
                {
                    List<AccountTeamMember> oldteammemlist = oldusertoteamid.get(cusaccteam.userid);
                    oldteammemlist.add(cusaccteam);
                    oldusertoteamid.put(cusaccteam.userid,oldteammemlist);
                }
                else
                {
                    List<AccountTeamMember> oldteammemlist = new List<AccountTeamMember>();
                    oldteammemlist.add(cusaccteam);
                    oldusertoteamid.put(cusaccteam.userid,oldteammemlist);
                }
                
            }
            
            if(trigger.isupdate){
                for(Account oldacc:(List<Account>)Trigger.old){
                    
                    for(id userid:oldusertoteamid.keyset()){
                        if(oldacc.Transition_Manager__c==userid && !oldcustomaccmap.containskey(userid) ){
                            delTransteammem.addAll(oldusertoteamid.get(userid));
                        }
                        
                    }
                    
                }
            }
        }
        
        if(delTransteammem.size()>0){
            delete delTransteammem;
        }
        if(NewTransteammem.size()>0){
            insert NewTransteammem; 
        }
        
    }*/
    
    
    
    //Start SFDC#5631
    //Writting below code to create Opportunity Team Member when the owner Of the Account Changed
    public static void createOppTeaMember(){
        System.debug('Inside createOppTeaMember');
        //Declaring Set to preserve Account Id's for which owner is changed.
        Set<Id> accIdSet = new Set<Id>();
        Map<Id, Account> accMap = (Map<Id, Account>)Trigger.oldMap; 
        for(Account a:(List<Account>)Trigger.new){
            if((a.OwnerId != accMap.get(a.Id).OwnerId)){
                accIdSet.add(a.Id);
            }
        }
        System.debug('***accIdSet ***'+accIdSet);
        if(accIdSet.size() > 0){//Execute below code only when set is not nulll
            //Querying Corresponding Opportunities to get Its Partner ROle data as there is no direct relation between Account and Partner ROle.
            //Map<Id,Opportunity> oppTeamMap =new Map<Id,Opportunity>([select id,Account__c from opportunity where Account__c IN : accIdSet]);
            //   System.debug('***oppTeamMap*** '+oppTeamMap);
            //Map<Id,OpportunityTeamMember> exoppteam=new  Map<Id,OpportunityTeamMember>([select id,OpportunityId,UserId,TeamMemberRole from
            //   OpportunityTeamMember where OpportunityId IN : oppTeamMap.keyset() and TeamMemberRole IN : new List<String>{'Source', 'National PAM'}]);
            List<OpportunityTeamMember> oppTMLst = new List<OpportunityTeamMember>();
            //SFDC-6007 Updated the Query to exclude Cloud contract types of DCR and updated OppTeamMemberRole to Read-Only
            List<String> DcrCCtypes = System.Label.DCR_CC_Types.Split(',');
            //Getting Partner ROle data based on OppId's and Role's as 'Source', 'National PAM'
            //Start SFDC-6315
            for(Partner_Role__c partObj : [SELECT Id, Name, Role__c, Opportunity__c,Partner_Company__r.OwnerId,Opportunity__r.stagename,Partner_Company__r.Owner.isactive,Partner_Company__c,Opportunity__r.Partner_Company__c,Opportunity__r.Cloud_Contract_Type__c,
                                            
                                           Opportunity__r.Owner_Role__c,Opportunity__r.Category__c ,Opportunity__r.Type
                                           
                                           FROM Partner_Role__c where Opportunity__c!='' and Opportunity__r.stagename!='closed won' and Opportunity__r.stagename!='closed Lost' and 
                                           
                            (Not Opportunity__r.Owner_Role__c Like '%Service Delivery%') and Opportunity__r.Category__c != 'Renewal' and Opportunity__r.Type != 'Renewal'and
                                           
                                           Partner_Company__c IN : accIdSet AND Role__c IN : new List<String>{'Source', 'National PAM'} AND (Opportunity__r.Cloud_Contract_Type__c NOT IN: DcrCCtypes) ]){
                                              if(partObj.Partner_Company__r.Owner.isactive){
                                                   OpportunityTeamMember oppTeamMember = new OpportunityTeamMember();
                                                   oppTeamMember.OpportunityId = partObj.Opportunity__c;
                                                   //oppTeamMember.TeamMemberRole = partObj.Partner_Company__c==partObj.Opportunity__r.Partner_Company__c ? label.Source : partObj.Role__c;
                                                   oppTeamMember.TeamMemberRole = partObj.Role__c;
                                                   //oppTeamMember.TeamMemberRole = partObj.Partner_Company__c==partObj.Opportunity__r.Partner_Company__c ? label.Source : partObj.Role__c;                                            
                                                   oppTeamMember.OpportunityAccessLevel = 'Read';
                                                   oppTeamMember.UserId = partObj.Partner_Company__r.OwnerId;
                                                   oppTMLst.add(oppTeamMember);
                                               }
                                           }
            
            //Not checking null/Empty/size condition as it was already initialized null check is not required and size is also not required as dynamically it won't consider
            //if it has no records 
            if(oppTMLst.size()>0)
                insert oppTMLst;
        }
    }  //end of SFDC-5631
      
   //Start SFDC-6380 merged Account Manager and Transition Manager 
   public static void UpdateTeamMembersBasedOnManager(String managertype){
        Map<Id,Set<Id>> usertoaccsid =new Map<Id,Set<Id>>();
        Map<Id,List<AccountTeamMember>> oldusertoteamid =new Map<Id,List<AccountTeamMember>>();
        Map<String,List<id>> mapAccountWiseCusacc = new Map<String,List<id>>();
        Map<String,List<id>> oldmapAccountWiseCusacc = new Map<String,List<id>>();
        List<id> allacclist=new List<id>();
        Map<Id,List<Id>> Acctoallacc =new Map<Id,List<Id>>();
        Map<Id, Account> accoldMap = (Map<Id, Account>)Trigger.oldMap;
        Set<String> stAccOldIds = new Set<String>();        
        Set<String> stAccIds = new Set<String>();
        List<AccountTeamMember> NewTransteammem = new List<AccountTeamMember>();        
        List<AccountTeamMember> delTransteammem = new List<AccountTeamMember>();  
      
        For(Account acc : (List<Account>)Trigger.new)
        {
            if(managertype=='Transition Manager'){
                if((trigger.isinsert) || (trigger.isupdate && acc.Transition_Manager__c!= accoldMap.get(acc.id).Transition_Manager__c )){               
                    if(String.isNotBlank(acc.Transition_Manager__c))               
                        stAccIds.add(acc.company_name__c);//will get standardAccount Id's
                }
                
                if(trigger.isupdate){
                    for(Account a:(List<Account>)Trigger.new){
                        if((a.Transition_Manager__c != accoldMap.get(a.Id).Transition_Manager__c) ){
                            stAccOldIds.add(a.company_name__c);
                        }
                    }}
            }            
            if(managertype=='Account Manager'){
                
                if((trigger.isinsert) || (trigger.isupdate && acc.Account_Manager__c!= accoldMap.get(acc.id).Account_Manager__c )){               
                    if(String.isNotBlank(acc.Account_Manager__c))
                        
                        stAccIds.add(acc.company_name__c);//will get standardAccount Id's
                }
                if(trigger.isupdate){
                    for(Account a:(List<Account>)Trigger.new){
                        if((a.Account_Manager__c != accoldMap.get(a.Id).Account_Manager__c) ){
                            stAccOldIds.add(a.company_name__c);
                        }
                    }}
            }
        }      
        if(!stAccIds.isempty()){
            List<account> customacc = [select id,company_name__c from account where company_name__c in :stAccIds ];
            
            if(customacc.size()>0){
                For(account cusacc : customacc)
                {
                    if(mapAccountWiseCusacc.containsKey(cusacc.company_name__c))
                    {
                        List<id> lstCont = mapAccountWiseCusacc.get(cusacc.company_name__c);
                        lstCont.add(cusacc.id);
                        mapAccountWiseCusacc.put(cusacc.company_name__c,lstCont);
                    }
                    else
                    {
                        List<id> lstCont = new List<id>();
                        lstCont.add(cusacc.id);
                        mapAccountWiseCusacc.put(cusacc.company_name__c,lstCont);
                    }
                    
                }
            }          
            for(Account a:(List<Account>)Trigger.new){
                if(managertype=='Transition Manager'){
                    if(a.Transition_Manager__c!=null && mapAccountWiseCusacc.containskey(a.company_name__c) ){
                        if(usertoaccsid.containsKey(a.Transition_Manager__c)){
                            set<id> allaccountid = usertoaccsid.get(a.Transition_Manager__c);
                            allaccountid.add(a.id);
                            allaccountid.add(a.Company_Name__c);
                            allaccountid.addAll(mapAccountWiseCusacc.get(a.Company_Name__c));  
                            usertoaccsid.put(a.Transition_Manager__c,allaccountid);                                                            
                        }
                        else{                   
                            Set<Id> allaccountid= new set<id>();
                            allaccountid.add(a.id);
                            allaccountid.add(a.Company_Name__c);
                            allaccountid.addAll(mapAccountWiseCusacc.get(a.Company_Name__c));
                            usertoaccsid.put(a.Transition_Manager__c,allaccountid);                        
                        }
                        
                    } 
                }              
                if(managertype=='Account Manager'){
                    if(a.Account_Manager__c!=null && mapAccountWiseCusacc.containskey(a.company_name__c) ){
                        if(usertoaccsid.containsKey(a.Account_Manager__c)){
                            set<id> allaccountid = usertoaccsid.get(a.Account_Manager__c);
                            allaccountid.add(a.id);
                            allaccountid.add(a.Company_Name__c);
                            allaccountid.addAll(mapAccountWiseCusacc.get(a.Company_Name__c));  
                            usertoaccsid.put(a.Account_Manager__c,allaccountid);                                                            
                        }
                        else{                   
                            Set<Id> allaccountid= new set<id>();
                            allaccountid.add(a.id);
                            allaccountid.add(a.Company_Name__c);
                            allaccountid.addAll(mapAccountWiseCusacc.get(a.Company_Name__c));
                            usertoaccsid.put(a.Account_Manager__c,allaccountid);                        
                        }
                        
                    } 
                }            
            }
            
            if(!usertoaccsid.isempty()) {
                for(id acctoteammemebr:usertoaccsid.keyset()){
                    
                    for(id useracc:usertoaccsid.get(acctoteammemebr)){                   
                        NewTransteammem.add(new AccountTeamMember(AccountId=useracc,
                                                                  UserId = acctoteammemebr,
                                                                  OpportunityAccessLevel='Edit',
                                                                  contactaccesslevel='Edit',
                                                                  accountaccesslevel='Edit',
                                                                  caseaccesslevel='None',
                                                                  TeamMemberRole=managertype));
                    }
                    
                }
                
            }
        }
        if(!stAccIds.isempty()||!stAccOldIds.isempty()){
            List<account> oldcustomacc = [select id,company_name__c,Transition_Manager__c,Account_Manager__c from account where company_name__c in :stAccOldIds or id in:stAccOldIds ];
            Map<Id, id> oldcustomaccmap = new Map<Id, id>(); 
            Map<Id, id> oldcustomaccmaptrm = new Map<Id, id>(); 
            Map<Id, id> oldcustomaccmapacm = new Map<Id, id>(); 
            List<AccountTeamMember> oldTeammem=[select id,UserId,AccountId,Account.Transition_Manager__c,Account.Account_Manager__c,TeamMemberRole from AccountTeamMember
                                                where   AccountId=:oldcustomacc  and TeamMemberRole=:managertype ];
            
            Map<Id, AccountTeamMember> oldTeammemmap = new Map<Id, AccountTeamMember>(oldTeammem);
            
            for(Account oldcustid:oldcustomacc){
                if(oldcustid.Transition_Manager__c!=null){
                    oldcustomaccmaptrm.put(oldcustid.Transition_Manager__c,oldcustid.id);
                    oldcustomaccmap.put(oldcustid.Transition_Manager__c,oldcustid.id);
                }
                if(oldcustid.Account_Manager__c!=null){
                    oldcustomaccmapacm.put(oldcustid.Account_Manager__c,oldcustid.id);
                    oldcustomaccmap.put(oldcustid.Account_Manager__c,oldcustid.id);
                }
            }
            For(AccountTeamMember cusaccteam : oldTeammem)
            {
                if(oldusertoteamid.containsKey(cusaccteam.userid))
                {
                    List<AccountTeamMember> oldteammemlist = oldusertoteamid.get(cusaccteam.userid);
                    oldteammemlist.add(cusaccteam);
                    oldusertoteamid.put(cusaccteam.userid,oldteammemlist);
                }
                else
                {
                    List<AccountTeamMember> oldteammemlist = new List<AccountTeamMember>();
                    oldteammemlist.add(cusaccteam);
                    oldusertoteamid.put(cusaccteam.userid,oldteammemlist);
                }
                
            }
            
            if(trigger.isupdate){
                for(Account oldacc:(List<Account>)Trigger.old){
                    
                    for(id userid:oldusertoteamid.keyset()){
                        if(managertype=='Transition Manager'){
                            if(oldacc.Transition_Manager__c==userid && !oldcustomaccmaptrm.containskey(userid) ){
                                delTransteammem.addAll(oldusertoteamid.get(userid));
                            }
                        }
                        if(managertype=='Account Manager'){
                            if(oldacc.Account_Manager__c==userid && !oldcustomaccmapacm.containskey(userid) ){
                                delTransteammem.addAll(oldusertoteamid.get(userid));
                            }
                        }
                        
                    }
                    
                }
            }
        }
        
        if(delTransteammem.size()>0){
            delete delTransteammem;
        }
        if(NewTransteammem.size()>0){
            insert NewTransteammem; 
        }
        
    }
     //End SFDC-6380 merged Account Manager and Transition Manager 
    
}