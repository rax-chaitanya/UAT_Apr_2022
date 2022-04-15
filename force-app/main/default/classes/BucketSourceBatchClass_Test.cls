@isTest
public class BucketSourceBatchClass_Test {
    @testSetup static void setupTestData() {
        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
        insert fieldMappings;
        TestDataFactory.getOrgConstants(); 
        TestDataFactory.getTriggerManagers();
        TestDataFactory.createFeatureFlags();
        //insertTriggerSettings();
        insertConnectionSettings();    
        
        Id accRID1= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();   
        Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();  
        Account a1 = new Account(Partner_Account_Status__c='Approved',Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =System.today(),Partner_Level__c='Referral',RecordTypeId= accRID1,Name='Test Account12346',BillingCountry='India',ShippingCountry='India');
        insert a1;
        Account acc= new Account(Partner_Account_Status__c='Approved',Agreed_By_Timestamp__c=System.now().addDays(-7),Contract_Signed_Date__c =system.today().addDays(-1),Partner_Level__c='Reseller',RecordTypeId= accRID,Name='Test Account123457',BillingCountry='India',ShippingCountry='India');
        insert acc; 
        Id oppRId= Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('INTL Cloud').getRecordTypeId();
        Opportunity opty = new Opportunity(AccountId=a1.Id,Skip_Validation__c = true,RecordTypeId=oppRId,Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport12', DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15));
        insert opty;
    }
    
    public static testmethod void updateOldOppBucketRec(){
        
        test.startTest();
        LeadSource_for_Bucket__c ledSrc = new LeadSource_for_Bucket__c();
        ledSrc.Name = 'Call In';
        ledSrc.lead_source__c = 'Call In';
        Insert ledSrc;
        
        Roles_BucketSource__c bktRoles = new Roles_BucketSource__c();
        bktRoles.name = 'US LDT';
        bktRoles.User_Role__c = 'US LDT';
        Insert bktRoles;
        SDR_Profiles_for_bktSrc__c sdrRole = new SDR_Profiles_for_bktSrc__c();
        sdrRole.name = 'System Administrator';
        sdrRole.sdr_Profile__c = 'System Administrator';
        insert sdrRole;
        
        List<Partner_Role__c> prole = new List<Partner_Role__c>();
        Account acc = [Select Id, Name from Account where Name = 'Test Account123457'];
        Opportunity opty = [select Id, Name from Opportunity where Name = 'Test Opport12'];
        prole.add(New Partner_Role__c(Status__c='Approved',Partner_Company__c=acc.id ,Justification__c='Test Source',Role__c='Source',Opportunity__c=opty.id));
        Insert prole;
       // date crdate = date.today() + 2; 
        //test.setCreatedDate(prole[0].Id, crdate);
		//test.startTest();
        opty.Bucket_Source__c = Null;
        Update opty;
        BucketSourceBatchClass batch = new BucketSourceBatchClass();
        database.executeBatch(batch);
        BucketSourceBatchClass2 bjob = new BucketSourceBatchClass2();
        database.executeBatch(bjob);
        test.stopTest();
        
    }
    
    public static testmethod void updateOldOppBucketRec2(){
        
        //test.startTest();
        LeadSource_for_Bucket__c ledSrc = new LeadSource_for_Bucket__c();
        ledSrc.Name = 'Call In';
        ledSrc.lead_source__c = 'Call In';
        Insert ledSrc;
        
        Roles_BucketSource__c bktRoles = new Roles_BucketSource__c();
        bktRoles.name = 'US LDT';
        bktRoles.User_Role__c = 'US LDT';
        Insert bktRoles;
        SDR_Profiles_for_bktSrc__c sdrRole = new SDR_Profiles_for_bktSrc__c();
        sdrRole.name = 'System Administrator';
        sdrRole.sdr_Profile__c = 'System Administrator';
        insert sdrRole;
        
        List<Partner_Role__c> prole = new List<Partner_Role__c>();
        Account acc = [Select Id, Name from Account where Name = 'Test Account123457'];
        Opportunity opty = [select Id, Name from Opportunity where Name = 'Test Opport12'];
        
        prole.add(New Partner_Role__c(Status__c='Approved',Partner_Company__c=acc.id ,Justification__c='Test Source',Role__c='Source',Opportunity__c=opty.id));
        Insert prole;
        opty.Bucket_Source__c = Null;
        Update opty;
        date crdate = date.today().addDays(20);
        
        test.setCreatedDate(prole[0].Id, crdate);
		test.startTest();
        
        BucketSourceBatchClass batch = new BucketSourceBatchClass();
        database.executeBatch(batch);
        BucketSourceBatchClass2 bjob = new BucketSourceBatchClass2();
        database.executeBatch(bjob);
        test.stopTest();
        
    }
    public static testmethod void updateOldOppBucketRec3(){
        
       // test.startTest();
        LeadSource_for_Bucket__c ledSrc = new LeadSource_for_Bucket__c();
        ledSrc.Name = 'Call In';
        ledSrc.lead_source__c = 'Call In';
        Insert ledSrc;
        
        Roles_BucketSource__c bktRoles = new Roles_BucketSource__c();
        bktRoles.name = 'US LDT';
        bktRoles.User_Role__c = 'US LDT';
        Insert bktRoles;
        SDR_Profiles_for_bktSrc__c sdrRole = new SDR_Profiles_for_bktSrc__c();
        sdrRole.name = 'System Administrator';
        sdrRole.sdr_Profile__c = 'System Administrator';
        insert sdrRole;
        
        List<Partner_Role__c> prole = new List<Partner_Role__c>();
        Account acc = [Select Id, Name from Account where Name = 'Test Account123457'];
        Opportunity opty = [select Id, Name from Opportunity where Name = 'Test Opport12'];
        prole.add(New Partner_Role__c(Status__c='Approved',Partner_Company__c=acc.id ,Justification__c='Test Source',Role__c='Source',Opportunity__c=opty.id));
        Insert prole;
        opty.Bucket_Source__c = Null;
        Update opty;
        date crdate = date.today() - 2; 
        test.setCreatedDate(prole[0].Id, crdate);
		test.startTest();
        
        //opty.Market_Source__c = 'yes';
        
        BucketSourceBatchClass batch = new BucketSourceBatchClass();
        database.executeBatch(batch);
        BucketSourceBatchClass2 bjob = new BucketSourceBatchClass2();
        database.executeBatch(bjob);
        test.stopTest();
        
    }
    public static testmethod void updateOldOppBucketRec4(){
        
        test.startTest();
        LeadSource_for_Bucket__c ledSrc = new LeadSource_for_Bucket__c();
        ledSrc.Name = 'Call In';
        ledSrc.lead_source__c = 'Call In';
        Insert ledSrc;
        
        Roles_BucketSource__c bktRoles = new Roles_BucketSource__c();
        bktRoles.name = 'US LDT';
        bktRoles.User_Role__c = 'US LDT';
        Insert bktRoles;
        SDR_Profiles_for_bktSrc__c sdrRole = new SDR_Profiles_for_bktSrc__c();
        sdrRole.name = 'System Administrator';
        sdrRole.sdr_Profile__c = 'System Administrator';
        insert sdrRole;
        
        //List<Partner_Role__c> prole = new List<Partner_Role__c>();
        Account acc = [Select Id, Name from Account where Name = 'Test Account123457'];
        Account a1 = [Select Id, Name from Account where Name = 'Test Account12346' limit 1];
        Opportunity opty = [select Id, Name from Opportunity where Name = 'Test Opport12'];
        opty.LeadSource = 'Call In';
        opty.Created_from_Lead__c = true;
        opty.Bucket_Source__c = Null;
        Update opty;
        Id oppRId= Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('INTL Cloud').getRecordTypeId();
        Opportunity opp = new Opportunity(LeadSource='Call In',Market_Source__c = 'Yes',AccountId=a1.Id,Skip_Validation__c = true,RecordTypeId=oppRId,Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport12', DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15));
        insert opp;
        //BucketSourceBatchClass batch = new BucketSourceBatchClass();
        //database.executeBatch(batch);
        test.stopTest();
        
    }
    public static testmethod void updateOldOppBucketRec5(){
        
        test.startTest();
        LeadSource_for_Bucket__c ledSrc = new LeadSource_for_Bucket__c();
        ledSrc.Name = 'Call In';
        ledSrc.lead_source__c = 'Call In';
        Insert ledSrc;
        
        Roles_BucketSource__c bktRoles = new Roles_BucketSource__c();
        bktRoles.name = 'US LDT';
        bktRoles.User_Role__c = 'US LDT';
        Insert bktRoles;
        SDR_Profiles_for_bktSrc__c sdrRole = new SDR_Profiles_for_bktSrc__c();
        sdrRole.name = 'System Administrator';
        sdrRole.sdr_Profile__c = 'System Administrator';
        insert sdrRole;
        
        List<Partner_Role__c> prole = new List<Partner_Role__c>();
        Map<Id,Opportunity> Oppmap = new Map<Id,Opportunity>();
        List<Opportunity> opplist= new List<Opportunity>();
        Account acc = [Select Id, Name from Account where Name = 'Test Account123457'];
        Account a1 = [Select Id, Name from Account where Name = 'Test Account12346' limit 1];
        
        Id oppRId= Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('INTL Cloud').getRecordTypeId();
        Opportunity opp = new Opportunity(LeadSource='Call In',Market_Source__c = 'Yes',AccountId=a1.Id,Skip_Validation__c = true,RecordTypeId=oppRId,Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport12', DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15));
        insert opp;
        
        prole.add(New Partner_Role__c(Status__c='Approved',Partner_Company__c=acc.id ,Justification__c='Test Source',Role__c='Source',Opportunity__c=opp.id));
        Insert prole;
        opplist.add(opp);
        Oppmap.put(opp.Id, opp);
        OppBucketFieldsHandler.updateBucketFields(Oppmap,opplist,false,true,false);
        test.stopTest();
        
    }
    public static testmethod void updateOldOppBucketRec6(){
        
        test.startTest();
        LeadSource_for_Bucket__c ledSrc = new LeadSource_for_Bucket__c();
        ledSrc.Name = 'Call In';
        ledSrc.lead_source__c = 'Call In';
        Insert ledSrc;
        
        Roles_BucketSource__c bktRoles = new Roles_BucketSource__c();
        bktRoles.name = 'US LDT';
        bktRoles.User_Role__c = 'US LDT';
        Insert bktRoles;
        SDR_Profiles_for_bktSrc__c sdrRole = new SDR_Profiles_for_bktSrc__c();
        sdrRole.name = 'System Administrator';
        sdrRole.sdr_Profile__c = 'System Administrator';
        insert sdrRole;
        
        List<Partner_Role__c> prole = new List<Partner_Role__c>();
        Account acc = [Select Id, Name from Account where Name = 'Test Account123457'];
        Opportunity opty = [select Id, Name from Opportunity where Name = 'Test Opport12'];
        opty.Market_Source__c = 'yes';
        opty.Bucket_Source__c = Null;
        Update opty;
        test.stopTest();
        
    }
    public static void insertConnectionSettings() {
        List<Connection_Object_Formula_Fields__c> connSettings = new List<Connection_Object_Formula_Fields__c>();
        connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'Attachment_Parent', Field_API_Name__c = 'ParentID'));
        connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'Lead', Field_API_Name__c = 'Old_lead_look_up_Ids__c'));
        connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'Partner_Role__c', Field_API_Name__c = 'Old_Role_look_up_Ids__c'));
        connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'rvpe__RVAccount__c', Field_API_Name__c = 'Lookup_id__c'));
        connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'rvpe__RVMember__c', Field_API_Name__c = 'Lookup_id__c'));
        connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'RV_Compensation_Detail__c', Field_API_Name__c = 'Lookup_id__c'));
        connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'RV_Compensation_Detail__c_Parent', Field_API_Name__c = 'RV_Compensation__c'));
        connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'RV_Compensation__c_Parent', Field_API_Name__c = 'Account__c'));
        connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'Specialist__c', Field_API_Name__c = 'Old_Specialist_look_up_Ids__c'));
        insert connSettings;
    }
}