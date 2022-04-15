@isTest
public class RavcWebhookHandler_Test {
    
    @TestSetUp
    static void setDataUp(){
        
        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
        insert fieldMappings;
        
        TestClassUtility.setTestSetupData();
        
    }
    @isTest
    static void postDatatoWebhooktest(){
        Test.setMock(HttpCalloutMock.class, new RsvcMockHttpResponseGenerator());
        list<opportunity> oppList = new List<Opportunity>();
        String pId=[select id,name from Profile where name='System Administrator' limit 1].id;
        User conuser = new User(firstname='webhookUser',Alias = 'standt', Email='webhookUser@testorg.com',EmailEncodingKey='UTF-8', LastName='PostData', 
                                LanguageLocaleKey='en_US',SSO_Username__c='user123',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='webhookUser@rackspace.com');
        insert conuser;
        
        Account a = new Account(Name='Test Account61234',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a;
        Account ac = new Account(Name='Test C11 Account',Company_Name__c=a.Id,  Is_Install_Base__c=true, RecordTypeId = Label.Account_Prospect_RecordType_ID);
        insert ac;
        Opportunity opty = new Opportunity(OwnerId=conuser.id,Integration_Status__c ='Failure',Integration_Type__c = 'RSVC',Was_a_Partner_Involved__c='Yes',Type='RSVC',Name='Test Opport RSVC',CVP_Verified__c = true, Account__c=ac.id,AccountId=a.Id,DDI__c='89789',Quotingsystem__C='Datapipe',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15),Agreement_Activated__c=true);
        insert opty;
        oppList.add(opty);
        Test.startTest();
        RsvcWebhookBatchClass bJob = new RsvcWebhookBatchClass();
        database.executeBatch(bJob);
        RsvcWebhookHandler.postDataToWebhook(oppList);
        Test.stopTest();        
    }
    
}