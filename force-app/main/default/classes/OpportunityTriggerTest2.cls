@isTest(seeAllData = true)
public class OpportunityTriggerTest2 {
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
      @isTest
    static void validationTest(){
    String pId=[select id,name from Profile where name='Standard User' limit 1].id;
        User conuser = new User(firstname='Connection',Alias = 'standt', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', 
                                LanguageLocaleKey='en_US',SSO_Username__c='user123',Region__c='US',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com');
        insert conuser;
        system.Runas(conuser){        
         DmlException validException;
         boolean isValidation = true;
         string opprecordtypeid = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('INTL Dedicated').getRecordTypeId();
     Test.startTest();
    try
    {
       List<Opportunity> oplst = new List<Opportunity>();
        Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a;
        //Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id,MailingCountry='India',Email='test.t@test.com',
            // MailingStreet='Whitefield',Phone='12345676',MailingCity='Bangalore',MailingPostalCode='560066',MailingState='Karnataka');
        // insert c;
        Account ac = new Account(Name='Test C 11Account',Company_Name__c=a.Id, RecordTypeId = Label.Account_Prospect_RecordType_ID);
        insert ac;
        Contact c1 = new Contact(firstname='Test Contact11',LastName='Test Last',AccountId=a.id);
        insert c1; 

        Opportunity opty = new Opportunity(OwnerId=conuser.id,RecordTypeId = opprecordtypeid,Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport',AccountId=a.Id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(20), Lead_Id__C = 'L-GARBAGE');
        insert opty;
        OpportunityHandler.isValidationFire = true;
         opty.type = 'Google';
         opty.Gross_Margin_Min__c = 0;
         opty.stageName='Stage 3 - Proposal & Quote';
         opty.Amount=24000;
         opty.Focus_Area__c='Amazon'; 
         opty.Category__c = 'New Logo'; 
         oplst.add(opty);       
         OpportunityHandler.isValidationFire = true; 
         update opty;
           //OpportunityTriggerHelper.grossMarginValidation(oplst,isValidation);
    }
    catch (DmlException d)
    {
        validException = d;
    }
    Test.stopTest();

    system.assertNotEquals(null, validException, 'The record is validated');
    }
    }
  }