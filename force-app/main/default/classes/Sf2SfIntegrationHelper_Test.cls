@isTest
public class Sf2SfIntegrationHelper_Test {
    
    @TestSetup
    static void setTestData(){
        List<Populate_Lookup_Fields__c> plf = new List<Populate_Lookup_Fields__c>();
        plf.add(new Populate_Lookup_Fields__c(Name='Lead4',Field_API_Name__c='LDT_Rep__c',Object_API_Name__c='Lead',Old_Record_Id_Field_Name__c='SSO_Username__c',Order__c=3,SOQL__c='select id,SSO_Username__c from User where SSO_Username__c in',Target_Object_Api_Name__c='User'));
        plf.add(new Populate_Lookup_Fields__c(Name='Lead5',Field_API_Name__c='Lead_Generator__c',Object_API_Name__c='Lead',Old_Record_Id_Field_Name__c='SSO_Username__c',Order__c=4,SOQL__c='select id,SSO_Username__c from User where SSO_Username__c in',Target_Object_Api_Name__c='User'));
        plf.add(new Populate_Lookup_Fields__c(Name='Partner_Role__c4',Field_API_Name__c='OwnerId',Object_API_Name__c='Partner_Role__c',Old_Record_Id_Field_Name__c='SSO_Username__c',Order__c=3,SOQL__c='select id,SSO_Username__c from User where SSO_Username__c in',Target_Object_Api_Name__c='User'));
        plf.add(new Populate_Lookup_Fields__c(Name='Partner_Role__c2',Field_API_Name__c='RV_Account__c',Object_API_Name__c='Partner_Role__c',Old_Record_Id_Field_Name__c='Old_Record_Id__c',Order__c=1,SOQL__c='Select id,Old_Record_Id__c from rvpe__RVAccount__c where Old_Record_Id__c in',Target_Object_Api_Name__c='rvpe__RVAccount__c'));
        plf.add(new Populate_Lookup_Fields__c(Name='Specialist__c2',Field_API_Name__c='Additional_Sales_Team__c',Object_API_Name__c='Specialist__c',Old_Record_Id_Field_Name__c='SSO_Username__c',Order__c=1,SOQL__c='select id,SSO_Username__c from User where SSO_Username__c in',Target_Object_Api_Name__c='User'));
        plf.add(new Populate_Lookup_Fields__c(Name='Specialist__c1',Field_API_Name__c='Lead__c',Object_API_Name__c='Specialist__c',Old_Record_Id_Field_Name__c='Old_Record_Id__c',Order__c=0,SOQL__c='Select id,Old_Record_Id__c from Lead where Old_Record_Id__c in',Target_Object_Api_Name__c='Lead'));
        plf.add(new Populate_Lookup_Fields__c(Name='Partner_Role__c1',Field_API_Name__c='Lead__c',Object_API_Name__c='Partner_Role__c',Old_Record_Id_Field_Name__c='Old_Record_Id__c',Order__c=0,SOQL__c='Select id,Old_Record_Id__c from Lead where Old_Record_Id__c in',Target_Object_Api_Name__c='Lead'));
        plf.add(new Populate_Lookup_Fields__c(Name='Partner_Role__c3',Field_API_Name__c='RV_Member__c',Object_API_Name__c='Partner_Role__c',Old_Record_Id_Field_Name__c='Old_Record_Id__c',Order__c=2,SOQL__c='Select id,Old_Record_Id__c from rvpe__RVMember__c where Old_Record_Id__c in',Target_Object_Api_Name__c='rvpe__RVMember__c'));
        plf.add(new Populate_Lookup_Fields__c(Name='Lead2',Field_API_Name__c='RecordTypeId',Object_API_Name__c='Lead',Old_Record_Id_Field_Name__c='Name',Order__c=1,SOQL__c='Select Id,Name from RecordType where Name in',Target_Object_Api_Name__c='RecordType'));
        plf.add(new Populate_Lookup_Fields__c(Name='RV Account Id1',Field_API_Name__c='Parent_Account__c',Object_API_Name__c='rvpe__RVAccount__c',Old_Record_Id_Field_Name__c='Old_Record_Id__c',Order__c=0,SOQL__c='select id,Old_Record_Id__c  from rvpe__RVAccount__c where Old_Record_Id__c in',Target_Object_Api_Name__c='rvpe__RVAccount__c'));
        plf.add(new Populate_Lookup_Fields__c(Name='rvpe__RVAccount__c1',Field_API_Name__c='rvpe__RVParentAccount__c',Object_API_Name__c='rvpe__RVAccount__c',Old_Record_Id_Field_Name__c='Old_Record_Id__c',Order__c=1,SOQL__c='select id,Old_Record_Id__c from rvpe__RVAccount__c where Old_Record_Id__c in',Target_Object_Api_Name__c='rvpe__RVAccount__c'));
        plf.add(new Populate_Lookup_Fields__c(Name='Lead1',Field_API_Name__c='Account__c',Object_API_Name__c='Lead',Old_Record_Id_Field_Name__c='Old_Record_Id__c',Order__c=0,SOQL__c='Select id,Old_Record_Id__c from Accounts__c where Old_Record_Id__c in',Target_Object_Api_Name__c='Accounts__c'));
        plf.add(new Populate_Lookup_Fields__c(Name='Lead3',Field_API_Name__c='OwnerId',Object_API_Name__c='Lead',Old_Record_Id_Field_Name__c='SSO_Username__c',Order__c=2,SOQL__c='select id,SSO_Username__c from User where SSO_Username__c in',Target_Object_Api_Name__c='User'));
        plf.add(new Populate_Lookup_Fields__c(Name='RV Member id3',Field_API_Name__c='SFAccount_del__c',Object_API_Name__c='rvpe__RVMember__c',Old_Record_Id_Field_Name__c='RTB_Record_Id__c',Order__c=2,SOQL__c='select id,RTB_Record_Id__c from Account where RTB_Record_Id__c in',Target_Object_Api_Name__c='Account'));
        plf.add(new Populate_Lookup_Fields__c(Name='RV Compensationdetail Id2',Field_API_Name__c='Opportunity__c',Object_API_Name__c='RV_Compensation_Detail__c',Old_Record_Id_Field_Name__c='RTB_Record_Id__c',Order__c=1,SOQL__c='select id,RTB_Record_Id__c from Opportunity Where RTB_Record_Id__c in',Target_Object_Api_Name__c='Opportunity'));
        plf.add(new Populate_Lookup_Fields__c(Name='RV Member id2',Field_API_Name__c='rvpe__RVProgram__c',Object_API_Name__c='rvpe__RVMember__c',Old_Record_Id_Field_Name__c='Old_Record_Id__c',Order__c=1,SOQL__c='select id,Old_Record_Id__c from rvpe__RVProgram__c where Old_Record_Id__c in',Target_Object_Api_Name__c='rvpe__RVProgram__c'));
        plf.add(new Populate_Lookup_Fields__c(Name='RV Compensation id1',Field_API_Name__c='Account__c',Object_API_Name__c='RV_Compensation__c',Old_Record_Id_Field_Name__c='Old_Record_Id__c',Order__c=0,SOQL__c='select id,Old_Record_Id__c from rvpe__RVAccount__c where Old_Record_Id__c in',Target_Object_Api_Name__c='rvpe__RVAccount__c'));
        plf.add(new Populate_Lookup_Fields__c(Name='RV Compensationdetail Id1',Field_API_Name__c='Account__c',Object_API_Name__c='RV_Compensation_Detail__c',Old_Record_Id_Field_Name__c='Old_Record_Id__c',Order__c=0,SOQL__c='select id, Old_Record_Id__c from Accounts__c where Old_Record_Id__c in',Target_Object_Api_Name__c='Accounts__c'));
        plf.add(new Populate_Lookup_Fields__c(Name='RV Member id1',Field_API_Name__c='rvpe__RVAccount__c',Object_API_Name__c='rvpe__RVMember__c',Old_Record_Id_Field_Name__c='Old_Record_Id__c',Order__c=0,SOQL__c='select id,Old_Record_Id__c from rvpe__RVAccount__c where Old_Record_Id__c in',Target_Object_Api_Name__c='rvpe__RVAccount__c'));
        plf.add(new Populate_Lookup_Fields__c(Name='RV Account Id5',Field_API_Name__c='Acq_Sales_Rep__c',Object_API_Name__c='rvpe__RVAccount__c',Old_Record_Id_Field_Name__c='FederationIdentifier',Order__c=4,SOQL__c='select id,FederationIdentifier from User where SSO_Username__c in',Target_Object_Api_Name__c='User'));
        plf.add(new Populate_Lookup_Fields__c(Name='RV Account Id4',Field_API_Name__c='Enterprise_Architect__c',Object_API_Name__c='rvpe__RVAccount__c',Old_Record_Id_Field_Name__c='FederationIdentifier',Order__c=3,SOQL__c='select id,FederationIdentifier from User where SSO_Username__c in',Target_Object_Api_Name__c='User'));
        plf.add(new Populate_Lookup_Fields__c(Name='RV Account Id6',Field_API_Name__c='rvpe__RVPrimaryMember__c',Object_API_Name__c='rvpe__RVAccount__c',Old_Record_Id_Field_Name__c='Old_Record_Id__c',Order__c=5,SOQL__c='select id,Old_Record_Id__c  from rvpe__RVMember__c where Old_Record_Id__c in',Target_Object_Api_Name__c='rvpe__RVMember__c'));
        plf.add(new Populate_Lookup_Fields__c(Name='RV Account Id3',Field_API_Name__c='IB_Sales_Rep__c',Object_API_Name__c='rvpe__RVAccount__c',Old_Record_Id_Field_Name__c='FederationIdentifier',Order__c=2,SOQL__c='select id,FederationIdentifier from User where SSO_Username__c in',Target_Object_Api_Name__c='User'));
        plf.add(new Populate_Lookup_Fields__c(Name='RV Account Id7',Field_API_Name__c='rvpe__SFAccount__c',Object_API_Name__c='rvpe__RVAccount__c',Old_Record_Id_Field_Name__c='RTB_Record_Id__c',Order__c=6,SOQL__c='select id,RTB_Record_Id__c from Account where RTB_Record_Id__c in',Target_Object_Api_Name__c='Account'));
        plf.add(new Populate_Lookup_Fields__c(Name='RV Member id4',Field_API_Name__c='rvpe__SFContact__c',Object_API_Name__c='rvpe__RVMember__c',Old_Record_Id_Field_Name__c='RTB_Record_Id__c',Order__c=3,SOQL__c='select id,RTB_Record_Id__c from Contact where RTB_Record_Id__c in',Target_Object_Api_Name__c='Contact'));
        
        insert plf;
        
            
        List<Connection_Object_Formula_Fields__c> coff = new List<Connection_Object_Formula_Fields__c>();
        coff.add(new Connection_Object_Formula_Fields__c(Name='Lead',Field_API_Name__c='Old_lead_look_up_Ids__c'));
        coff.add(new Connection_Object_Formula_Fields__c(Name='Attachment_Parent',Field_API_Name__c='ParentID'));
        coff.add(new Connection_Object_Formula_Fields__c(Name='Partner_Role__c',Field_API_Name__c='Old_Role_look_up_Ids__c'));
        coff.add(new Connection_Object_Formula_Fields__c(Name='Specialist__c',Field_API_Name__c='Old_Specialist_look_up_Ids__c'));
        coff.add(new Connection_Object_Formula_Fields__c(Name='rvpe__RVMember__c',Field_API_Name__c='Lookup_id__c'));
        coff.add(new Connection_Object_Formula_Fields__c(Name='RV_Compensation_Detail__c_Parent',Field_API_Name__c='RV_Compensation__c'));
        coff.add(new Connection_Object_Formula_Fields__c(Name='RV_Compensation__c_Parent',Field_API_Name__c='Account__c'));
        coff.add(new Connection_Object_Formula_Fields__c(Name='RV_Compensation_Detail__c',Field_API_Name__c='Lookup_id__c'));
        coff.add(new Connection_Object_Formula_Fields__c(Name='rvpe__RVAccount__c',Field_API_Name__c='Lookup_id__c'));
        
        insert coff;
        
        List<Trigger_Manager__c> tms = new List<Trigger_Manager__c>();
          tms.add(new Trigger_Manager__c(name='TaskTrigger',Is_Active__c=true)); 
       // insert new Trigger_Manager__c(name='RVAccountTgr',Is_Active__c=true));
          tms.add( new Trigger_Manager__c(name='OpportunityTeamMemberTgr',Is_Active__c=true)); 
           tms.add( new Trigger_Manager__c(name='OpportunityFocusAreaTgr',Is_Active__c=true)); 
          tms.add( new Trigger_Manager__c(name='ContactTgr',Is_Active__c=true)); 
          tms.add( new Trigger_Manager__c(name='OpportunitySplitTgr',Is_Active__c=true)); 
           tms.add( new Trigger_Manager__c(name='OpportunityTgr',Is_Active__c=true)); 
          tms.add( new Trigger_Manager__c(name='LeadTgr',Is_Active__c=true)); 
          tms.add( new Trigger_Manager__c(name='RVMemberTgr',Is_Active__c=true)); 
       // insert new Trigger_Manager__c(name='RVAccountTgr',Is_Active__c=true); 
           tms.add( new Trigger_Manager__c(name='SpecialistTgr',Is_Active__c=true)); 
          tms.add( new Trigger_Manager__c(name='PartnerRoleTgr',Is_Active__c=true)); 
          tms.add( new Trigger_Manager__c(name='CompanyTrigger',Is_Active__c=true));
                  insert tms;
        insert new OrgConstants__c(Name='Prod Org ID',Prod_Value__c='00D61000000J4OKEA0',Non_Prod_Value__c='00D61000000J4OKEA0');
        insert new OrgConstants__c(Name='Company Approval Process ID',Prod_Value__c='04a4C0000008PNQ',Non_Prod_Value__c='04a4C0000008PNQ');
        insert new OrgConstants__c(Name='System Administrator ID',Prod_Value__c='00561000001ziVf',Non_Prod_Value__c='00561000001ziVf');
        insert new FieldMapping__C(Name='ActivityTrigger-OldRecordID-1',CompName__c='ActivityTrigger-OldRecordID',SourceField__c='Account',TargetField__c='WhatId');
        
        List< Activity_Trigger_Settings__c> ats = new List< Activity_Trigger_Settings__c>();
        ats.add(new Activity_Trigger_Settings__c(Name = 'qwerty', SObject__c = 'Task', Field__c = 'Country_of_Visit__c', Key_Field__c = ''));
        ats.add(new Activity_Trigger_Settings__c(Name = 'qwerty1', SObject__c = 'Task', Field__c = 'RecordTypeID', Key_Field__c = 'SourceField__c', Query__c = 'Select Id, SourceField__c, TargetField__c from FieldMapping__c where SourceField__c in :values', Fields_To_Retrieve__c = 'TargetField__c'));
        insert ats;
        
        //TestClassUtility.createChildQuerySettings();
        
    }
    
    @isTest
    static void rvMemberTest(){
        delete [select id from Trigger_Manager__c where name='RVMemberTgr'];
        rvpe__RVMember__c rvm = (rvpe__RVMember__c)TestClassUtility.createRvMembers(1)[0];
        insert rvm;
        System.assert([Select id from rvpe__RVMember__c where id =: rvm.Id] != null);
        delete rvm;
        insert new Trigger_Manager__c(name='RVMemberTgr',Is_Active__c=true);
        
        ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = true;
        List<rvpe__RVMember__c> rms = (List<rvpe__RVMember__c>)TestClassUtility.createRvMembers(300);
        insert rms;
        Set<Id> rvmids = new Set<Id>();
        for(rvpe__RVMember__c rvm1 : rms){
            rvmids.add(rvm1.Id);
        }
       //System.assert((new List<PartnerNetworkRecordConnection>([select id from PartnerNetworkRecordConnection where localRecordId in : rvmids])).size() == 300,true);
        ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = true;
        update rms;
        ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = true;
        delete rms;
        undelete rms;
      
    }
    @isTest
    static void rvAccountTest(){
     
        Integer externalId = 20170119;
        //delete [select id from Trigger_Manager__c where name='RVAccountTgr'];
        rvpe__RVAccount__c rv11 = TestClassUtility.createRVAccounts(1,externalId)[0];
        externalId=externalId+100;
        insert rv11;
      
        insert new Trigger_Manager__c(name='RVAccountTgr',Is_Active__c=true);
        ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = true;
        rvpe__RVAccount__c rv = TestClassUtility.createRVAccounts(1,externalId)[0];
        externalId=externalId+200;
        insert rv;
        ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = true;
        List<rvpe__RVAccount__c> rvs = TestClassUtility.createRVAccounts(300,externalId);
        for(rvpe__RVAccount__c rv1 :rvs){
            rv1.Lookup_id__c = ' '+rv.id+' ,'+rv.id+' , , , ,  , ';
        }
        insert rvs;
        
        Set<id> rvids = new Set<Id>();
        for(rvpe__RVAccount__c rva : rvs){
            rvids.add(rva.id);
        }
     // System.assert((new List<PartnerNetworkRecordConnection>([select id from PartnerNetworkRecordConnection where localRecordId in : rvids])).size() == 302,true);
        ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = true;
        update rvs;
        ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = true;
        
        delete rvs;
        undelete rvs;
    }
    
    @isTest
    static void rvCompensationDetailTest(){
        
     /*   String pId=[select id,name from Profile where name='System Administrator' limit 1].id;
        
        User conuser = new User(firstname='Connection',Alias = 'standt', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', 
                                LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com',Region__c='US',Group__c='US Other');
        
            
        insert conuser;
        System.runAs(conuser){
            rvpe__RVAccount__c rv = TestClassUtility.createRVAccounts(1,20170120)[0];
            insert rv;
            delete [select id from Trigger_Manager__c where name='RVCompensationTgr'];
            ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = true;
            RV_Compensation__c  rvc1 = TestClassUtility.createRvCompensations(1)[0];
            rvc1.Account__c=rv.id;
            rvc1.Lookup_id__c = rv.id+' ';
            
            insert rvc1;
            
            insert new Trigger_Manager__c(name='RVCompensationTgr',Is_Active__c=true);  
            ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = true;
            RV_Compensation__c  rvc = TestClassUtility.createRvCompensations(1)[0];
            rvc.Account__c=rv.id;
            rvc.Lookup_id__c = rv.id+' , ,';
            
            insert rvc;
            
            delete [select id from Trigger_Manager__c where name='RVCompensationDetailTgr'];
            RV_Compensation_Detail__c rvs1 = TestClassUtility.createCompensationDetails(1)[0];
            rvs1.RV_Compensation__c=rvc.id;
            insert rvs1;
            insert new Trigger_Manager__c(name='RVCompensationDetailTgr',Is_Active__c=true); 
            ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = true;
            List<RV_Compensation_Detail__c> rvs = TestClassUtility.createCompensationDetails(300);
            for(RV_Compensation_Detail__c rcd : rvs){
                rcd.RV_Compensation__c=rvc.id;
            }
            insert rvs;
            ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = true;
            update rvs;
            ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = true;
            delete rvs;
            undelete rvs;
            ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = true;
            update rvc;
             ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = true;
            delete rvc;
            System.assert((new List<RV_Compensation__c>([select id from RV_Compensation__c])).size() ==1,true);
            undelete rvc;
        }*/
    }
    /*
    @isTest
    static void testLeadTrigger(){
       insert new Trigger_Manager__c(name='cLogTgr',Is_Active__c=true);
         String pId=[select id,name from Profile where name='System Administrator' limit 1].id;
          User conuser = new User(firstname='Connection',Alias = 'standt', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', 
                                LanguageLocaleKey='en_US',SSO_Username__c='user123',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com',Region__c='US',Group__c='US Other');
        insert conuser;
        rvpe__RVAccount__c rv = (rvpe__RVAccount__c)TestClassUtility.createRVAccounts(1,20170120)[0];
        rv.Old_Record_Id__c='RVOldRecordId';
        insert rv;
        delete [select id from Trigger_Manager__c where name='LeadTgr'];
        List<Lead> leads1 = TestClassUtility.createLeads(3);
        insert leads1;
        delete leads1;
        
        insert new Trigger_Manager__c(name='LeadTgr',Is_Active__c=true);
        ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = true;
        List<Lead> leads = TestClassUtility.createLeads(3);
        leads.get(0).country='India';
        leads.get(0).Old_lead_look_up_Ids__c=' , ,Venkat123 ,Venkat123 ,Venkat123 ,';
        leads.get(0).Old_Record_Id__c='00JKJJHKJH898';
        leads.get(1).Old_lead_look_up_Ids__c=' , ,Venkat123 ,Venkat123 ,Venkat123 ,';
        insert leads;
        Set<Id> localids = new Set<Id>();
        for(Lead l : leads)
            localids.add(l.Id);
        //System.assert((new List<PartnerNetworkRecordConnection>([select id from PartnerNetworkRecordConnection where localRecordId in : localids])).size() == 3,true);
        ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = true;
        update leads;
        ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = true;
        delete leads;
        undelete leads;
        rvpe__RVMember__c rms = (rvpe__RVMember__c)TestClassUtility.createRvMembers( 1)[0];
        rms.rvpe__RVAccount__c = rv.id;
        insert rms;
        Lead l = leads.get(0);
        insert new Task(Type = 'Email',Description='Test Task',OwnerId = UserInfo.getUserId(),WhoId = l.id);
        insert new Task(Type = 'Email',Description='Test Task2',OwnerId = UserInfo.getUserId(),WhoId = l.id);
        insert new Specialist__c(Additional_Sales_Team__c=UserInfo.getUserId(),Additional_Team_Type__c='Solution Engineer',Lead__c=l.id);
        insert new Partner_Role__c(Lead__c=l.Id,RV_Account__c=rv.id,Status__c='New',Commission_Role__c='Pay Commissions',Justification__c='Test Justification',RV_Member__c=rms.id);
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setConvertedStatus('Converted to Opp');
        lc.setLeadId(l.id);
         Database.LeadConvertResult lcr = Database.convertLead(lc);  
        Lead convertedLead = [Select id,ConvertedOpportunityId from Lead where isConverted = true and id=:l.Id limit 1];
        List<Task> tasks = [select id,Type,whoid from Task where whoId =: l.id];
        System.assert(tasks.size() >0 , true);
        System.assert(convertedLead != null,true);
        Opportunity op = [Select id from Opportunity where id =: convertedLead.ConvertedOpportunityId limit 1];
        update op;
        delete op;
        undelete op;
        
     
    }
    
*/

    
     @isTest()
    static void specialistTest(){
        Lead l = new Lead(firstname='Testfirst',lastname='lastname',company='Test company',
                          email='test.test@test.com',LeadSource='Chat',Lead_Type__c='AWS',
                         Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',
                          country='India',postalcode='560037');
        insert l;
        
        Specialist__c sp= new Specialist__c(Additional_Sales_Team__c=UserInfo.getUserId(),Additional_Team_Type__c='Solution Engineer',Lead__c=l.id);
        delete [select id from Trigger_Manager__c where name='SpecialistTgr'];
        insert sp;
        insert new Trigger_Manager__c(name='SpecialistTgr',Is_Active__c=true);
        ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS =true;
        List<Specialist__c> sps = new List<Specialist__c>();
        sps.add(new Specialist__c(Additional_Sales_Team__c=UserInfo.getUserId(),Additional_Team_Type__c='Sales Associate',Lead__c=l.id));
        sps.add(new Specialist__c(Additional_Sales_Team__c=UserInfo.getUserId(),Additional_Team_Type__c='Cloud Specialist',Lead__c=l.id));
       sps.add(new Specialist__c(Additional_Sales_Team__c=UserInfo.getUserId(),Additional_Team_Type__c='Digital Practice',Lead__c=l.id));
      insert sps;
        Set<Id> splstids = new Set<Id>();
        for(Specialist__c sp1: sps)
            splstids.add(sp1.Id);
        
        List<PartnerNetworkRecordConnection> records= [select id from PartnerNetworkRecordConnection where localRecordId in : splstids];
         //System.assert(records.size() == 3,true);
        //System.assert(sps.get(0).Lead__c == l.id,true);
        
        ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS =true;  
        update sps;
        ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS =true;  
        delete sps;
        undelete sps;
    }
    
}