@isTest
public class TestDataFactory{
    
    public static boolean triggerManagerFlagValue = true;
    
    public static List<FeatureFlag__c> getFeatureFlagSetting(){
        List<FeatureFlag__c> fFlag = new List<FeatureFlag__c>();        
            fFlag.add(new FeatureFlag__c(Name = 'BucketLogic_DM', Enabled__c= false));
        insert fFlag;
        return fFlag;    
    }
    
    public static ProdOrgIDSetting__c getProdOrgIDSetting(){ 
        ProdOrgIDSetting__c prdorgset = new ProdOrgIDSetting__c(ProdOrgID__c='00D61000000J4OKEA0');
        insert prdorgset;
        return prdorgset;
    }    
    
    public static List<OrgConstants__c> getOrgConstants(){
        List<OrgConstants__c> constants = new List<OrgConstants__c>();
        
        constants.add(new OrgConstants__c(Name = 'Prod Org ID',
                                              Non_Prod_Value__c = '00D61000000J4OKEA0',
                                              Prod_Value__c  = '00D61000000J4OKEA0'
                                             ));
            
            constants.add(new OrgConstants__c(Name = 'System Administrator ID',
                                              Non_Prod_Value__c = '00561000001ziVf',
                                              Prod_Value__c  = '00561000001ziVf'
                                             ));
            
            constants.add(new OrgConstants__c(Name = 'Company Approval Process ID',
                                              Non_Prod_Value__c = '04a610000004ef0',
                                              Prod_Value__c  = '04a610000004ef0'
                                             ));
                                             
            constants.add(new OrgConstants__c(Name = 'RO-Domain',
                                              Non_Prod_Value__c = 'https://dev-rax.api.rackspacecloud.com/RO/v1/',
                                              Prod_Value__c  = 'https://rax.api.rackspacecloud.com/RO/v1/'
                                             ));

            constants.add(new OrgConstants__c(Name = 'RO-Certificate Name',
                                              Non_Prod_Value__c = 'SelfSignedCert_25Apr2018_1057AM',
                                              Prod_Value__c  = 'SelfSignedCert_25Apr2018_1057AM'
                                             ));

            constants.add(new OrgConstants__c(Name = 'RO-Summary-Account',
                                              Non_Prod_Value__c = 'companyinvoicesummary/{0}',
                                              Prod_Value__c  = 'companyinvoicesummary/{0}'
                                             ));

            constants.add(new OrgConstants__c(Name = 'RO-Summary-Accounts',
                                              Non_Prod_Value__c = 'accountinvoicesummary/{0}?accounttype={1}',
                                              Prod_Value__c  = 'accountinvoicesummary/{0}?accounttype={1}'
                                             ));
                                             
        insert constants;
        return constants;
    }
    
    public static List<Trigger_Manager__c> getTriggerManagers(){
        List<Trigger_Manager__c> triggerManager = new List<Trigger_Manager__c>();
        triggerManager.add(new Trigger_Manager__c(Name = 'LiveTransferTrigger',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'SalesSupportTgr',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'OpportunityFocusAreaTgr',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'PartnerRoleTgr',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'OpportunitySplitTgr',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'OppCompTgr',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'DealCenterTgr',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'ComponentManagerTrigger',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'AttachmentTgr',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'SpecialistTgr',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'RVCompensationTgr',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'RVAccountTgr',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'AccountTrigger',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'LeadTgr',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'RVMemberTgr',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'cLogTgr',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'CampaignMemberTrigger',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'TaskTrigger',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'AcrTgr',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'CompanyTrigger',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'ContactTgr',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'EventTrigger',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'OpportunityTeamMemberTgr',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'OpportunityTgr',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'QuoteTgr',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'QuoteLineTgr',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'RVCompensationDetailTgr',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'UserTrigger',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'TranscriptTgr',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'ContentDocumentLinkTgr',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'QuoteLineItemTgr',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'RealignmentRequestItemTrigger',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'AccountRealignmentRequestTrigger',
                                                  Is_Active__c = triggerManagerFlagValue
                                                 ));
        triggerManager.add(new Trigger_Manager__c(Name = 'IndividualEmailResultTrigger',
                                                  Is_Active__c = triggerManagerFlagValue));
        triggerManager.add(new Trigger_Manager__c(Name = 'IndividualLinkTrigger',
                                                  Is_Active__c = triggerManagerFlagValue));
        triggerManager.add(new Trigger_Manager__c(Name = 'DPQuoteTgr',
                                                  Is_Active__c = triggerManagerFlagValue));
                                                                                            
        insert triggerManager;
        
        return triggerManager;
    }
    
    public static Account createCompany( String accountName){
        Account testAccount = new Account(
            Name = accountName
        );
        Insert testAccount;
        return testAccount;
    }
    
    public static Account createAccount( String accountName, Id companyId, Id ownerId){
        Account testAccount = new Account(
            Name = accountName,
            Company_Name__c = companyId,
            OwnerId = ownerId,
            RecordTypeId = Label.Account_Prospect_RecordType_ID
        );
        Insert testAccount;
        return testAccount;
    }
    
    public static Lead createLead(String name){
        Id rtIdLead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead').getRecordTypeId(); 
        Lead l = new Lead(
            firstname='Testfirst1',
            lastname = name,
            company='Test company1',
            email='test.test1@test.com',
            LeadSource='Chat',
            Lead_Type__c='AWS',
            AnnualRevenue = 100.00,
            Focus_Area__c='Amazon',
            street='Marathalli',
            city='Bangalore',
            State='Karnataka',
            country='India',
            postalcode='560037',
            Type_Of_Deal__c ='Referral',
            RecordTypeId = rtIdLead
        );
        Insert l;
        return l;
    }
    public static Account_Plan__c createAccountPlan( Id companyId, Id recordType){
        Account_Plan__c accountPlan = new Account_Plan__c(
            Company__c = companyId
        );
        if(recordType!=null){
            accountPlan.RecordTypeId = recordType;
        }
        Insert accountPlan;
        return accountPlan;
    }
    
    public static List<FocusAreaMapping__c> createFocusAreaMapping(){
        List<FocusAreaMapping__c> result = new List<FocusAreaMapping__c>();
        result.add(new FocusAreaMapping__c(Name='VMWare', OppFocusArea__c='VMWare'));
        result.add(new FocusAreaMapping__c(Name='Google', OppFocusArea__c='Google'));
        result.add(new FocusAreaMapping__c(Name='TriCore', OppFocusArea__c='TriCore'));
        result.add(new FocusAreaMapping__c(Name='Dedicated', OppFocusArea__c='Dedicated'));
        result.add(new FocusAreaMapping__c(Name='Amazon', OppFocusArea__c='Amazon'));
        result.add(new FocusAreaMapping__c(Name='Security', OppFocusArea__c='Security'));
        result.add(new FocusAreaMapping__c(Name='Cloud Office', OppFocusArea__c='Cloud Office'));
        result.add(new FocusAreaMapping__c(Name='OpenStack Private', OppFocusArea__c='OpenStack Private'));
        result.add(new FocusAreaMapping__c(Name='Data Stores', OppFocusArea__c='Data Stores'));
        result.add(new FocusAreaMapping__c(Name='Microsoft Public', OppFocusArea__c='MSFT Public'));
        result.add(new FocusAreaMapping__c(Name='OpenStack Public', OppFocusArea__c='OpenStack Public'));
        result.add(new FocusAreaMapping__c(Name='Digital', OppFocusArea__c='Digital'));
        result.add(new FocusAreaMapping__c(Name='Microsoft Private', OppFocusArea__c='MSFT Private'));
        result.add(new FocusAreaMapping__c(Name='Not Applicable', OppFocusArea__c='Not Applicable'));
        result.add(new FocusAreaMapping__c(Name='AliCloud', OppFocusArea__c='DataPipe'));
        result.add(new FocusAreaMapping__c(Name='Colo', OppFocusArea__c='DataPipe'));
        result.add(new FocusAreaMapping__c(Name='Molo', OppFocusArea__c='DataPipe'));
        result.add(new FocusAreaMapping__c(Name='DataPipe', OppFocusArea__c='DataPipe'));
        insert result;
        return result;
    }
    
    public static List<Activity_Trigger_Settings__c> createActivityTriggerSettings(){
        List<Activity_Trigger_Settings__c> activityTgrSettings = new List<Activity_Trigger_Settings__c>();
        activityTgrSettings.add(new Activity_Trigger_Settings__c(
            Name = 'AT-01',
            Field__c = 'WhatId',
            Fields_to_Retrieve__c = 'Old_Record_Id__c',
            Key_Field__c = 'Id',
            SObject__c = 'All',
            Query__c  = 'Select Id, Old_Record_Id__c from {0} Where Id In :values'
        ));
        activityTgrSettings.add(new Activity_Trigger_Settings__c(
            Name = 'AT-02',
            Field__c = 'WhoId',
            Fields_to_Retrieve__c = 'Old_Record_Id__c',
            Key_Field__c = 'Id',
            SObject__c = 'All',
            Query__c  = 'Select Id, Old_Record_Id__c from {0} Where Id In :values'
        ));
        activityTgrSettings.add(new Activity_Trigger_Settings__c(
            Name = 'AT-03',
            Field__c = 'OwnerId',
            Fields_to_Retrieve__c = 'FederationIdentifier',
            Key_Field__c = 'Id',
            SObject__c = 'All',
            Query__c  = 'Select Id, FederationIdentifier from {0} Where Id In :values'
        ));
        activityTgrSettings.add(new Activity_Trigger_Settings__c(
            Name = 'AT-04',
            Field__c = 'RecordTypeID',
            Fields_to_Retrieve__c = 'TargetField__c',
            Key_Field__c = 'SourceField__c',
            SObject__c = 'Task',
            Query__c  = 'Select Id, SourceField__c, TargetField__c from FieldMapping__c where SourceField__c in :values'
        ));
        activityTgrSettings.add(new Activity_Trigger_Settings__c(
            Name = 'AT-05',
            Field__c = 'Country_of_Visit__c',
            Fields_to_Retrieve__c = 'null',
            Key_Field__c = 'null',
            SObject__c = 'Task',
            Query__c  = 'null'
        ));
        activityTgrSettings.add(new Activity_Trigger_Settings__c(
            Name = 'AT-06',
            Field__c = 'State_of_Visit__c',
            Fields_to_Retrieve__c = 'null',
            Key_Field__c = 'null',
            SObject__c = 'Task',
            Query__c  = 'null'
        ));
        activityTgrSettings.add(new Activity_Trigger_Settings__c(
            Name = 'AT-07',
            Field__c = 'Campaign__c',
            Fields_to_Retrieve__c = 'Old_Record_Id__c',
            Key_Field__c = 'Id',
            SObject__c = 'Task',
            Query__c  = 'Select Id, Old_record_id__c from Campaign Where Id in :values'
        ));
        
        Insert activityTgrSettings;
        return activityTgrSettings;
    }
    
    public static List<FeatureFlag__c> createFeatureFlags(){
        List<FeatureFlag__c> result = new List<FeatureFlag__c>();
        result.add(new FeatureFlag__c(Name='BucketLogic_DM', Enabled__c=false));
        Insert result;
        return result;
    }
    
    public static List<Opp_Team_Member_Roles_Setup__c> creteTeamMemberRoles(){
        List<Opp_Team_Member_Roles_Setup__c> result = new List<Opp_Team_Member_Roles_Setup__c>();
        result.add(new Opp_Team_Member_Roles_Setup__c(Name='Test',Select_Role__c=false,Role__c='US SA - AWS',Team_Member_Role__c='Solutions Architect Specialist'));
        result.add(new Opp_Team_Member_Roles_Setup__c(Name='Test1',Select_Role__c=true,Role__c='EMEA Portfolio Architect - ACQ',Team_Member_Role__c='TestSolution'));
        result.add(new Opp_Team_Member_Roles_Setup__c(Name= 'Test2',Role__c='US Sub-Segment - Tech Sales', Select_Role__c=false, Team_Member_Role__c='Solution Engineer'));
        result.add(new Opp_Team_Member_Roles_Setup__c(Name= 'Test3',Role__c='Hong Kong Sales Engineer', Select_Role__c=true, Team_Member_Role__c='Solution Engineer'));
        Insert result;
        return result;
    }
}