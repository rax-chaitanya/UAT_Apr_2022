@isTest
public class ContactHandler_Test {
    
    @TestSetUp
    static void setDataUp(){
        List<Trigger_Manager__c> tms = new List<Trigger_Manager__c>();
        tms.add( new Trigger_Manager__c (Name ='AccountContactRelation',Is_Active__c = true));
        insert tms;
        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
        insert fieldMappings;
        List<BrightTALK__BrightTalk_State_Codes__c> btlkstatecode = new List<BrightTALK__BrightTalk_State_Codes__c>();
        btlkstatecode.add(new BrightTALK__BrightTalk_State_Codes__c(Name = 'Florida', BrightTALK__State_Alpha_2__c = 'FL'));
        insert btlkstatecode;
        TestClassUtility.setTestSetupData();
        
    }
    
    @isTest
    static void testHandler(){
        
        Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId=Label.Standard_Company_RecordTypeId);
        insert a;
        system.debug(a);
        Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,ShippingCountry='India',RecordTypeId=Label.Account_Prospect_RecordType_Id);
        insert ac;
        system.debug(ac);
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id,HasOptedOutOfEmail=false,Btlk_Country__c='United States',Btlk_Sate_Province__c='Florida');
        insert c;
        system.debug('contact' +c);
        c.HasOptedOutOfEmail = true;
        update c;
        //List<AccountContactRole> acrs = [Select id from AccountContactRole where AccountId =: a.id];
        
        //System.assert(acrs.size()>0,true);
        
        List<AccountContactRelation> acrs = [Select id from AccountContactRelation where AccountId =: a.id];
        
        System.assert(acrs.size()>0,true);
        
        delete c;
        undelete c;
    }
    @isTest
    static void duplicateCheck(){
        /*List<Trigger_Manager__c> tms = new List<Trigger_Manager__c>();
tms.add( new Trigger_Manager__c (Name ='AccountContactRelation',Is_Active__c = true));
insert tms;*/
        /*Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId=Label.Standard_Company_RecordTypeId);
insert a;*/
        Id recordTypeIdacc2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId=recordTypeIdacc2);
        Test.startTest();
        insert a;
        Account ac22 = new Account(Name='Test C1 Account',Company_Name__c=a.Id,ShippingCountry='India',RecordTypeId=Label.Account_Prospect_RecordType_Id);
        insert ac22;
        List<Contact> updatedCon = new List<Contact>();
        Contact primaryCon = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id,HasOptedOutOfEmail=false,Btlk_Country__c='United States',Btlk_Sate_Province__c='Florida',Email='Test123@gmail.com' ); /*,NPS_Eligible__c = false,NPS_Survey_Opt_Out__c = true,Reasons_to_opt_out__c = 'Contact no longer with Company'*/
        insert primaryCon;
        CheckRecursive.firstcall= false;
        Contact secondaryCon = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id,HasOptedOutOfEmail=false,Btlk_Country__c='United States',Btlk_Sate_Province__c='Florida' ,Email='Test123@gmail.com');
        insert secondaryCon;
        CheckRecursive.firstcall= false;
        primaryCon.NPS_Eligible__c = false;
        primaryCon.NPS_Survey_Opt_Out__c = true;
        primaryCon.Reasons_to_opt_out__c = 'Contact no longer with Company';
        update primaryCon;
        Contact secondarytoUpdate = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id,HasOptedOutOfEmail=false,Btlk_Country__c='United States',Btlk_Sate_Province__c='Florida' ,Email='Test123@gmail.com');
        insert secondarytoUpdate;
        updatedCon.add(secondarytoUpdate);
        database.executeBatch(new ContactUpdateSurevyOPTBatchJob(primaryCon,updatedCon));
        List<Contact> conList = new List<Contact>();
        Account a1 = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId=Label.Standard_Company_RecordTypeId);
        insert a1;
        Contact primaryCon1 = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a1.id,HasOptedOutOfEmail=false,Btlk_Country__c='United States',Btlk_Sate_Province__c='Florida',Email='Test@gmail.com' );
        insert primaryCon1;
        CheckRecursive.firstcall = false;
        Contact secondaryCon1 = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a1.id,HasOptedOutOfEmail=false,Btlk_Country__c='United States',Btlk_Sate_Province__c='Florida',Email='Test@gmail.com',NPS_Eligible__c = false,NPS_Survey_Opt_Out__c = true,Reasons_to_opt_out__c = 'Contact no longer with Company');
        conList.add(secondaryCon1);
        database.executeBatch(new ContactUpdateSurevyOPTBatchJob(null,conList));
        //Secondary contact update by Mrinal (SFDC-7476)
        Contact primaryCon2 = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a1.id,HasOptedOutOfEmail=false,Btlk_Country__c='United States',Btlk_Sate_Province__c='Florida',Email='Test@gmail.com' );
        insert primaryCon2;
        conList.add(primaryCon2);
        primaryCon2.email = 'testing@email.com';
        update primaryCon2;
        
    }
}