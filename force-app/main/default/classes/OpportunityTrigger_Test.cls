@isTest(seeAllData = false)
public class OpportunityTrigger_Test {
    
    @TestSetUp
    static void setDataUp(){
        
        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
        insert fieldMappings;
        Trigger_Manager__c Tm = new Trigger_Manager__c (Name ='AccountContactRelation',Is_Active__c = true);
        insert Tm;                
        TestClassUtility.setTestSetupData();
        
    }
    
    @isTest
    static void opportunityTriggerTest(){
        Test.startTest();
        String pId=[select id,name from Profile where name='System Administrator' limit 1].id;
        User conuser = new User(firstname='Connection',Alias = 'standt', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', 
                                LanguageLocaleKey='en_US',SSO_Username__c='user123',Region__c='US',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection12@rackspace.com');
        insert conuser;
        Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a;
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id,MailingCountry='India',Email='test.t@test.com',
                                MailingStreet='Whitefield',Phone='12345676',MailingCity='Bangalore',MailingPostalCode='560066',MailingState='Karnataka');
        insert c;
        Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,ShippingCountry='India',RecordTypeId = Label.Account_Prospect_RecordType_ID);
        insert ac;
        Contact c1 = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=ac.id);
        insert c1; 
        Opportunity opty = new Opportunity(OwnerId=conuser.id,Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport',AccountId=a.Id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15));
        insert opty;
        test.stopTest();
    }
    
    @isTest
    static void opportunityTriggerTest1(){
        String pId=[select id,name from Profile where name='System Administrator' limit 1].id;
        String sellerpid=[select id,name from Profile where name='Rackspace Seller-INTL' limit 1].id;
        
        User conuser = new User(firstname='Connection',Alias = 'standt', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', 
                                LanguageLocaleKey='en_US',SSO_Username__c='user123',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com',Region__c='APAC');
        insert conuser;
        User selleruser = new User(firstname='Test intl',Alias = 'standt', Email='testintluser1@testorg.com',EmailEncodingKey='UTF-8', LastName='erer', 
                                   LanguageLocaleKey='en_US',SSO_Username__c='seller123',LocaleSidKey='en_US', ProfileId = sellerpid,TimeZoneSidKey='America/Los_Angeles', UserName='testintluser1@rackspace.com',Region__c='EMEA');
        insert selleruser;
        
        Test.StartTest();
        Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId,Data_Steward_Approval__c='Approved');
        insert a;
        Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,ShippingCountry='India',RecordTypeId = Label.Account_Prospect_RecordType_ID);
        insert ac;
        Opportunity opty = new Opportunity(OwnerId=selleruser.id,Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport',Account__c=ac.id,AccountId=a.Id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15));
        insert opty;
        OpportunityTriggerHelper.UPDATE_ACCOUNT_DETAILS = true;
        //opty.StageName = 'Closed Won';
        opty.CloseDate= date.today();
        opty.Market_Source__c='No';
        opty.amount=55555;
        system.runAs(selleruser){
            try{
                
                update opty;
                system.debug('f user info'+UserInfo.getFirstName());
                
            }catch(Exception e){
                System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
                
            }
            
        }
        
        
        Opportunity opty2 = new Opportunity(OwnerId=conuser.id,Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport2',Account__c=ac.id,AccountId=a.Id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15));
        insert opty2;
        delete opty2;        
        
        OpportunityTriggerHelper.createOpportunityTeamMember(opty.Id,opty.OwnerId);
        OpportunityTriggerHelper.isClosedINTLNonUSDOpp(opty);
        Test.StopTest();
    }
}