@isTest
private class ContactSearchAndCreateCtrl_Test
{

     private static testmethod void setupData() {
        
        /*Account a1 = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert a1;
        Contact c = new Contact(firstname='Test',LastName='Test',AccountId=a1.id,Email = System.now().millisecond() + 'test@test.com');
        insert c;
        */
         Test.startTest();
         Trigger_Manager__c Acc = new Trigger_Manager__c(name='AcrTgr',Is_Active__c=true);
         insert Acc;
        Trigger_Manager__c tri = new Trigger_Manager__c();
        tri.name = 'ContactTgr';
        tri.is_Active__c = true;
        insert tri;
        
         
         Lead l = new Lead(firstname='Testfirst',lastname='lastname',company='Test company',
                          email='test.test@test.com',LeadSource='Chat',Lead_Type__c='AWS',
                         Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',
                          country='India',postalcode='560037');
        insert l;
         /* Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert a;
         Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id,MailingCountry='India',Email='test.t@test.com',
                                MailingStreet='Whitefield',Phone='12345676',MailingCity='Bangalore',MailingPostalCode='560066',MailingState='Karnataka');
        insert c;
        Accounts__c ac = new Accounts__c(Name='Test C Account',Company_Name__c=a.Id,Shipping_Country__c='India');
        insert ac;
        */
        ContactSearchAndCreateCtrl.fetchSearchResultData('Test','Test','Test','Test');
         ContactSearchAndCreateCtrl.fetchContactRecordTypes();
        Test.stopTest();
    }
    
}