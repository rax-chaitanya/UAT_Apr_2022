@isTest(seeAllData = true)
public class OpportunityTriggerTest {
    
    @isTest
    static void opportunityTriggerTest(){
        
        OpportunityHandler oh = new OpportunityHandler();
        try{oh.afterDelete();}catch(Exception e){}
        try{oh.isActive();}catch(Exception e){}
        try{oh.beforeInsert();}catch(Exception e){}
        try{oh.afterInsert();}catch(Exception e){}
        try{oh.beforeUpdate();}catch(Exception e){}
        
        Test.startTest();
        String pId=[select id,name from Profile where name='System Administrator' limit 1].id;
        User conuser = new User(firstname='Connection',Alias = 'standt', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', 
                                LanguageLocaleKey='en_US',SSO_Username__c='user123',Region__c='US',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com');
        insert conuser;
        Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a;
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id,MailingCountry='India',Email='test.t@test.com',
                                MailingStreet='Whitefield',Phone='12345676',MailingCity='Bangalore',MailingPostalCode='560066',MailingState='Karnataka');
        // insert c;
        Account ac = new Account(Name='Test C 11Account',Company_Name__c=a.Id, RecordTypeId = Label.Account_Prospect_RecordType_ID);
        insert ac;
        Contact c1 = new Contact(firstname='Test Contact11',LastName='Test Last',AccountId=a.id);
        insert c1; 
        
        Test.stopTest();
        CompanyHandler.isLeadConverting = true; 
        Opportunity opty = new Opportunity(OwnerId=conuser.id,Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport',AccountId=a.Id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15), Lead_Id__C = 'L-GARBAGE');
        insert opty;
        
        OpportunityTriggerHelper.createOpportunityTeamMember(opty.Id, UserInfo.getUserId());
        OpportunityTriggerHelper.getPartnerRoleMap_filteredOnUser(new set<id>{opty.Id});
        delete opty;
        undelete opty;
    }
    @isTest
    static void opportunityTriggerTest2noocomp(){
       
        Test.startTest();
        String pId=[select id,name from Profile where name='System Administrator' limit 1].id;
        User conuser = new User(firstname='Connection',Alias = 'standt', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', 
                                LanguageLocaleKey='en_US',SSO_Username__c='user123',Region__c='US',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com');
        insert conuser;
        Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a;
       
        Account ac=[select id,name from Account where company_name__c=:a.id];
        Delete ac;
        Test.stopTest();
        CompanyHandler.isLeadConverting = true; 
        Opportunity opty = new Opportunity(OwnerId=conuser.id,Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport',AccountId=a.Id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15), Lead_Id__C = 'L-GARBAGE');
        insert opty;
     
       try{
        OpportunityTriggerHelper.beforeInsert();
        }catch(Exception e){}
        
        }
    
    
    @isTest
    static void opportunityTriggerTest1(){
        String pId=[select id,name from Profile where name='System Administrator' limit 1].id;
        User conuser = new User(firstname='Connection',Alias = 'standt', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', 
                                LanguageLocaleKey='en_US',SSO_Username__c='user123',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com');
        insert conuser;
        
        Account a = new Account(Name='Test Account61234',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a;
        Account ac = new Account(Name='Test C11 Account',Company_Name__c=a.Id,  Is_Install_Base__c=true, RecordTypeId = Label.Account_Prospect_RecordType_ID);
        insert ac;
        CompanyHandler.isLeadConverting = true; 
        Opportunity opty = new Opportunity(OwnerId=conuser.id,Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport',Account__c=ac.id,AccountId=a.Id,DDI__c='12345655',Quotingsystem__C='Datapipe',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15),Agreement_Activated__c=true);
        insert opty;
    }
   
    @isTest
    static void opportunityTriggerTestnocomp2(){
        String pId=[select id,name from Profile where name='System Administrator' limit 1].id;
        User conuser = new User(firstname='Connection',Alias = 'standt', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', 
                                LanguageLocaleKey='en_US',SSO_Username__c='user123',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com');
        insert conuser;
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Government').getRecordTypeId(); 
        Id rtAccId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Government').getRecordTypeId(); 
        Id rtOPPId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Government').getRecordTypeId(); 
        Account a = new Account(Data_Steward_Approval__c='Approved',RecordTypeId = Label.Standard_Company_RecordTypeId,Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert a;
        Account ac = new Account(RecordTypeId = Label.Account_Prospect_RecordType_ID,Name='Test C Account',Company_Name__c=a.Id,DP_CustomerId__c='test',Is_Install_Base__c=true);
        insert ac;        
        Opportunity opty = new Opportunity(RecordTypeId=rtOPPId,Email_Account_Num__c='1234',OwnerId=conuser.id,Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport',Account__c=ac.id,AccountId=a.Id,DDI__c='12345655',StageName='Closed Won',CloseDate=System.today().addDays(15), Agreement_Activated__c=true);
        insert opty;
        Quote_Line__c ol = new Quote_Line__c(Migration_Device__c=true,Name ='Test',Opportunity_Quote__c = opty.Id,CreatedById=Label.FMW_API_User);
        insert ol;
        Test.startTest();
        opty.Delete_QL__c = 'All'; 
        ExternalSharingHelperController.POPULATE_OPPTY_RECORD_TYPE =true;
        

        try{update opty;}catch(exception ex){}
        //opty.Delete_QL__c = 'Migrate'; 
                
        //ExternalSharingHelperController.POPULATE_OPPTY_RECORD_TYPE =true;
        //try{update opty;}catch(exception ex){}
        
        ol.Migration_Device__c=false;
        update ol;
        Test.stopTest();
        
        
        opty.Delete_QL__c = 'Line_Item'; 
        ExternalSharingHelperController.POPULATE_OPPTY_RECORD_TYPE =true;
        try{update opty;}catch(exception ex){}
        
        
        companyRecordtypeController.fetchRecordTypeValues();
        companyRecordtypeController.getRecTypeId('US Cloud');
        companyRecordtypeController.getDetailsFromAcc(a.Id);
        
        
    }
    
    @isTest
    static void opportunitycloneTest(){
        String pId=[select id,name from Profile where name='System Administrator' limit 1].id;
   //     Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard').getRecordTypeId(); 
        Id rtAccId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId(); 
        Id rtOPPId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('INTL Cloud').getRecordTypeId(); 
        Id oppReadOnlyId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Read Only').getRecordTypeId(); 
        Account a = new Account(RecordTypeId = Label.Standard_Company_RecordTypeId,Name='Test Account1234',BillingCountry='India',ShippingCountry='India',Data_Steward_Approval__c='Approved');
        insert a;
        Account ac = new Account(RecordTypeId = Label.Account_Prospect_RecordType_ID,Name='Test C Account',Company_Name__c=a.Id);
        insert ac;      
        CompanyHandler.isLeadConverting = true;   
        Opportunity opty = new Opportunity(RecordTypeId=rtOPPId,Email_Account_Num__c='1234',StageName='Stage 1 - Planning & Identification',OwnerId=UserInfo.getUserId(),Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport',Account__c=ac.id,AccountId=a.Id,DDI__c='12345655',CloseDate=System.today().addDays(15));
        insert opty;
        
        
        Test.startTest();
        opty.Email_Account_Num__c='Test';
        opty.StageName ='Closed Won';
        opty.RecordTypeId = oppReadOnlyId;
        
        update opty;
        Test.stopTest();
        
        
        CloneOpp.getDetailsFromOpp(opty.Id);
        CloneOpportunity.getDetailsFromOpp(opty.Id);
    }
    @isTest
    static void opportunityreopen(){
    String pId=[select id,name from Profile where name='System Administrator' limit 1].id;
        User conuser = new User(firstname='Connection',Alias = 'standt', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', 
                                LanguageLocaleKey='en_US',SSO_Username__c='user123',Region__c='US',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com');
        insert conuser;
        Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a;
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id,MailingCountry='India',Email='test.t@test.com',
                                MailingStreet='Whitefield',Phone='12345676',MailingCity='Bangalore',MailingPostalCode='560066',MailingState='Karnataka');
        // insert c;
        Account ac = new Account(Name='Test C 11Account',Company_Name__c=a.Id, RecordTypeId = Label.Account_Prospect_RecordType_ID);
        insert ac;
        Contact c1 = new Contact(firstname='Test Contact11',LastName='Test Last',AccountId=a.id);
        insert c1; 
        
        CompanyHandler.isLeadConverting = true; 
        Opportunity opty = new Opportunity(OwnerId=conuser.id,Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport',AccountId=a.Id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15), Lead_Id__C = 'L-GARBAGE');
        insert opty;
         opty.StageName='Closed Lost';
         update opty;
         opty.stageName='Stage 3 - Proposal & Quote';
         update opty;
         OpportunityTriggerUpdates otp=new OpportunityTriggerUpdates();
    }
     @isTest
    static void opportunityTriggerTestcontractentiityupdate(){
        
        OpportunityHandler oh = new OpportunityHandler();
        try{oh.afterDelete();}catch(Exception e){}
        try{oh.isActive();}catch(Exception e){}
        try{oh.beforeInsert();}catch(Exception e){}
        try{oh.afterInsert();}catch(Exception e){}
        try{oh.beforeUpdate();}catch(Exception e){}
        
        Test.startTest();
        String pId=[select id,name from Profile where name='System Administrator' limit 1].id;
        User conuser = new User(firstname='Connection',Alias = 'standt', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', 
                                LanguageLocaleKey='en_US',SSO_Username__c='user123',Region__c='US',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com');
        insert conuser;
        Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a;
        a.contracting_entity__C=Null;
        update a;
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id,MailingCountry='India',Email='test.t@test.com',
                                MailingStreet='Whitefield',Phone='12345676',MailingCity='Bangalore',MailingPostalCode='560066',MailingState='Karnataka');
        // insert c;
        Account ac = new Account(Name='Test C 11Account',Company_Name__c=a.Id, RecordTypeId = Label.Account_Prospect_RecordType_ID);
        insert ac;
         ac.contracting_entity__C=Null;
        update ac;
        Contact c1 = new Contact(firstname='Test Contact11',LastName='Test Last',AccountId=a.id);
        insert c1; 
         Account ac2 = new Account(Name='Test C 11Account223',Company_Name__c=a.Id, RecordTypeId = Label.Account_Prospect_RecordType_ID);
        insert ac2;
         ac2.contracting_entity__C=Null;
        update ac2;
        Test.stopTest();
        CompanyHandler.isLeadConverting = true; 
        Opportunity opty = new Opportunity(Quotingsystem__C='Datapipe',account__c=ac.id,OwnerId=conuser.id,Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport',AccountId=a.Id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15), Lead_Id__C = 'L-GARBAGE');
        insert opty;
        opty.Quotingsystem__C='Rackspace';
        opty.account__c=ac2.id;
        update opty;
        OpportunityTriggerHelper.createOpportunityTeamMember(opty.Id, UserInfo.getUserId());
        OpportunityTriggerHelper.getPartnerRoleMap_filteredOnUser(new set<id>{opty.Id});
        delete opty;
        undelete opty;
    }
    
}