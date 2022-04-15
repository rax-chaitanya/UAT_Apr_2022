@isTest
public class RelationEdgeLeadHandler_test {

    @isTest
    static void testCreateRELead(){

        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' ];
        user adminUser = new User(
            ProfileId = adminProfile.Id,
            LastName = 'testAdminUser123',
            Email = 'puser000@amamama.com',
            Username = 'adminuser@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            //UserRoleId = SARole.Id,
            Region__c = 'AMER',
            Group__c = 'US Other'
        );
        Insert adminUser;
            
        Id StandardCmpRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        Id ProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        Account a = new Account(Name='Test Account1234',RecordTypeId=StandardCmpRecordTypeId,Partner_Account_Status__c ='Approved',phone ='1212121212', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka');
        insert a; 
        Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,RecordTypeId=ProspectRecordTypeId,phone ='1212121212');
        insert ac;
        insert new Trigger_Manager__c(name='RelationEdgeLeadTrigger',Is_Active__c=true);
        insert new Rax2RE_Field_Mapping__c (name='Name',RE_Field__c='00N80000005hACh');
        
        RelationEdge_Lead__c rel = new RelationEdge_Lead__c(  Account__c=ac.id, 
            First_Name__c='fn', Last_Name__c='ln', Email__c='fnln@rackspace.com.test', State__c='Atlanta', Notes__c='test', RAX_Sales_Rep__c=adminUser.id);
        insert rel;
        
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_xml());
        Test.stopTest();
        
        update rel;
        delete rel;
    }
}