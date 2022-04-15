public class TestClassUtility {
    
    public static Integer increment=1;
    public static List<rvpe__RVMember__c> createRvMembers(Integer noOfRecords){
        List<rvpe__RVMember__c> rvlist = new List<rvpe__RVMember__c>();
        
        for(Integer i=1;i<=noOfRecords;i++){
            rvlist.add(new rvpe__RVMember__c(Name='Rv Member'+i,rvpe__UserName__c='RVMemberUser'+i,rvpe__ExtMemberId__c=20170119+i));
        }
        return rvlist;
    }
    
    public static List<rvpe__RVAccount__c> createRVAccounts(Integer noOfRecords,Integer externalId){
        List<rvpe__RVAccount__c> rvlist = new List<rvpe__RVAccount__c>();
        
        for(Integer i=1;i<=noOfRecords;i++){
            rvlist.add(new rvpe__RVAccount__c(Name='RV Account'+i,rvpe__ExtAccountId__c=externalId+i));
        }
        return rvlist;
        
    }
    
    public static List<sObject> createRvCompensations(Integer noOfRecords){
        
        List<sObject> rvclist = new List<sObject>();
        
       // for(Integer i=1;i<=noOfRecords;i++)
         //   rvclist.add(new RV_Compensation__c(Name='RV Compensation '+i));
        return rvclist;
    }
    
    public static List<sObject> createCompensationDetails(Integer noOfRecords){
        
        List<sObject> rvcdlist = new List<sObject>();
        
       // for(Integer i=1;i<=noOfRecords;i++){
         //   rvcdlist.add(new RV_Compensation_Detail__c(Name='RV Compensation Detail '+i,Lookup_id__c=' , ,'));
      //  }
        return rvcdlist;
    }
    
    public static List<Lead> createLeads(Integer noOfRecords){
        
        List<Lead> leads = new List<Lead>();
        for(Integer i=1;i<=noOfRecords;i++)
            leads.add(new Lead(FirstName='Clarke'+i,lastName='Michel'+i,Company='Test Company',Status='New',Email='test@test.com',Phone='1234567',Focus_Area__c='Dedicated',Country='India',State='Karnataka'));
        return leads;
    }
    
    public static void setTestSetupData(){
        List<Trigger_Manager__c> tms = new List<Trigger_Manager__c>();
        tms.add(new Trigger_Manager__c(name='TaskTrigger',Is_Active__c=true));
        tms.add(new Trigger_Manager__c(name='EventTrigger',Is_Active__c=true));
        tms.add(new Trigger_Manager__c(name='cLogTgr',Is_Active__c=true));
        tms.add( new Trigger_Manager__c(name='OpportunityTeamMemberTgr',Is_Active__c=true)); 
        tms.add( new Trigger_Manager__c(name='OpportunityFocusAreaTgr',Is_Active__c=true)); 
        tms.add( new Trigger_Manager__c(name='ContactTgr',Is_Active__c=true)); 
        tms.add( new Trigger_Manager__c(name='OpportunitySplitTgr',Is_Active__c=true)); 
        tms.add( new Trigger_Manager__c(name='OpportunityTgr',Is_Active__c=true)); 
        tms.add( new Trigger_Manager__c(name='LeadTgr',Is_Active__c=true)); 
        tms.add( new Trigger_Manager__c(name='RVMemberTgr',Is_Active__c=true)); 
        tms.add( new Trigger_Manager__c(name='CompanyTrigger',Is_Active__c=true)); 
        tms.add( new Trigger_Manager__c(name='AcrTgr',Is_Active__c=true)); 
        tms.add( new Trigger_Manager__c(name='QuoteLineTgr',Is_Active__c=true)); 
        tms.add( new Trigger_Manager__c(name='SpecialistTgr',Is_Active__c=true)); 
        tms.add( new Trigger_Manager__c(name='PartnerRoleTgr',Is_Active__c=true)); 
        tms.add( new Trigger_Manager__c(name='QuoteTgr',Is_Active__c=true));
        tms.add( new Trigger_Manager__c(name='ComCampTgr',Is_Active__c=true));
        insert tms;
        
        List<OrgConstants__c> orgC = new List<OrgConstants__c>();
        orgC.add( new OrgConstants__c(Name='Prod Org ID',Prod_Value__c='00D61000000J4OKEA0',Non_Prod_Value__c='00D61000000J4OKEA0'));
        orgC.add( new OrgConstants__c(Name='Company Approval Process ID',Prod_Value__c='04a4C0000008PNQ',Non_Prod_Value__c='04a4C0000008PNQ'));
        orgC.add( new OrgConstants__c(Name = '#salesforce-errors', Prod_Value__c = 'https://hooks.slack.com/services/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', Non_Prod_Value__C = 'https://hooks.slack.com/services/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'));              
        orgC.add( new OrgConstants__c(Name='System Administrator ID',Prod_Value__c='00561000001ziVf',Non_Prod_Value__c='00561000001ziVf'));
        Insert orgC;
        
        List<FeatureFlag__c> ff = new List<FeatureFlag__c>();
        ff.add( new FeatureFlag__c (Name='BucketLogic_DM', Enabled__c=True));
        insert ff;
        
        List<Roles_MktSourced__c> MktRoles = new List<Roles_MktSourced__c>();
        MktRoles.add( new Roles_MktSourced__c (Name='US LDT', Max_Lead_Role__c='US LDT'));
        insert MktRoles;
        
        List<FieldMapping__C> fm = new List<FieldMapping__C>();
        fm.add( new FieldMapping__C(Name='ActivityTrigger-OldRecordID-1',CompName__c='ActivityTrigger-OldRecordID',SourceField__c='Account',TargetField__c='WhatId'));
        insert fm;
        
        List<Connection_Object_Formula_Fields__c> connSettings = new List<Connection_Object_Formula_Fields__c>();
        connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'Attachment_Parent', Field_API_Name__c = 'ParentID'));
        
        connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'Partner_Role__c', Field_API_Name__c = 'Old_Role_look_up_Ids__c'));
        connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'rvpe__RVAccount__c', Field_API_Name__c = 'Lookup_id__c'));
        connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'rvpe__RVMember__c', Field_API_Name__c = 'Lookup_id__c'));
        connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'RV_Compensation_Detail__c', Field_API_Name__c = 'Lookup_id__c'));
        connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'RV_Compensation_Detail__c_Parent', Field_API_Name__c = 'RV_Compensation__c'));
        connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'RV_Compensation__c_Parent', Field_API_Name__c = 'Account__c'));
        connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'Specialist__c', Field_API_Name__c = 'Old_Specialist_look_up_Ids__c'));
        insert connSettings;
        
        List<Activity_Trigger_Settings__c> atss = new List<Activity_Trigger_Settings__c>();
        atss.add(new Activity_Trigger_Settings__c(Name ='AT-07',Field__c='Campaign__c',Query__c='Select Id, Old_record_id__c from Campaign Where Id in :values',Sobject__c='Task',Fields_to_Retrieve__c='Old_Record_Id__c',Key_Field__c='Id'));
        atss.add(new Activity_Trigger_Settings__c(Name ='AT-01',Field__c='WhatId',Query__c='Select Id, Old_Record_Id__c from {0} Where Id In :values',Sobject__c='All',Fields_to_Retrieve__c='Old_Record_Id__c',Key_Field__c='Id'));                 
        atss.add(new Activity_Trigger_Settings__c(Name ='AT-05',Field__c='Country_of_Visit__c',Query__c='null',Sobject__c='Task',Fields_to_Retrieve__c='null',Key_Field__c='null'));
        atss.add(new Activity_Trigger_Settings__c(Name ='AT-02',Field__c='WhoId',Query__c='Select Id, Old_Record_Id__c from {0} Where Id In :values',Sobject__c='All',Fields_to_Retrieve__c='Old_Record_Id__c',Key_Field__c='Id'));
        atss.add(new Activity_Trigger_Settings__c(Name ='AT-06',Field__c='State_of_Visit__c',Query__c='null',Sobject__c='Task',Fields_to_Retrieve__c='null',Key_Field__c='null'));
        atss.add(new Activity_Trigger_Settings__c(Name ='AT-04',Field__c='RecordTypeID',Query__c='Select Id, SourceField__c, TargetField__c from FieldMapping__c where SourceField__c in :values',Sobject__c='Task',Fields_to_Retrieve__c='TargetField__c',Key_Field__c='SourceField__c'));
        atss.add(new Activity_Trigger_Settings__c(Name ='AT-03',Field__c='OwnerId',Query__c='Select Id, FederationIdentifier from {0} Where Id In :values',Sobject__c='All',Fields_to_Retrieve__c='FederationIdentifier',Key_Field__c='Id'));
        insert atss;
                
        createChildQuerySettings();
    }
    
    
    
    public static void createChildQuerySettings() {
        SObject[] toInsert = new list<SObject>();
        toInsert.add(new Child_Query_Settings__c(Name = 'Contact',Include__c = 'Tasks;'));
        toInsert.add(new Child_Query_Settings__c(Name = 'Lead', Include__c = 'Tasks;'));
        toInsert.add(new Child_Query_Settings__c(Name = 'Opportunity', Include__c = 'Tasks;'));
        
        insert toInsert;        
    }
    public static void createPageManagers(){
        List<Page_Manager__c> pagelist = new List<Page_Manager__c>();
        pagelist.add(new Page_Manager__c(Name='UploadCompanyLogoGVF',Title__c='Upload Company Logo',Page_ID__c='page',Standard_Stylesheets__c=true));
        pagelist.add(new Page_Manager__c(Name='OppCloseWonWizardUS4',Title__c='null',Page_ID__c='page-4',Standard_Stylesheets__c=false));
        pagelist.add(new Page_Manager__c(Name='OppCloseLostWizard',Title__c='Opportunity Close Lost',Page_ID__c='page',Standard_Stylesheets__c=true));
        pagelist.add(new Page_Manager__c(Name='CompanySearchBeforeCreate',Title__c='Company Search Before Create',Page_ID__c='page',Standard_Stylesheets__c=true));
        pagelist.add(new Page_Manager__c(Name='OppCloseWonWizardUS5',Title__c='null',Page_ID__c='page5',Standard_Stylesheets__c=false));
        pagelist.add(new Page_Manager__c(Name='ContactSearchBeforeCreate',Title__c='Contact Search',Page_ID__c='csbc',Standard_Stylesheets__c=true));
        pagelist.add(new Page_Manager__c(Name='EditFocusAreas',Title__c='Edit Focus Areas',Page_ID__c='editor',Standard_Stylesheets__c=true));  
        pagelist.add(new Page_Manager__c(Name='OppCloseWonWizardUS2',Title__c='null',Page_ID__c='page2',Standard_Stylesheets__c=false));
        pagelist.add(new Page_Manager__c(Name='OppCloseWonWizardUS2',Title__c='null',Page_ID__c='page2',Standard_Stylesheets__c=false));
        pagelist.add(new Page_Manager__c(Name='OppCloseWonWizardUS3',Title__c='null',Page_ID__c='page-3',Standard_Stylesheets__c=false));
        pagelist.add(new Page_Manager__c(Name='OppCloseWonWizardUS1',Title__c='Close Won Wizard',Page_ID__c='page',Standard_Stylesheets__c=false));
        insert pagelist;  
        
        insert new VF_Query_Manager__c(Name='ComSBC-1',Query_ID__c='a174C000000hGT2');
        new VF_Query_Manager__c(Name='ComSBC-3',Query_ID__c='a174C000000hGSz');
        

    }
    
}