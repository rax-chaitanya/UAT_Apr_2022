@isTest
public class CreateLatticeTaskControllerTest {
    private static testmethod void loggedInUser() { 
        TestClassUtility.setTestSetupData();
        String pId=[select id,name from Profile where name='Rackspace Seller-US' limit 1].id;
        User conuser = new User(firstname='Connection',Alias = 'standt', Email='selleruser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', group__c = 'APAC',
                                Region__c='US', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com', FederationIdentifier='test'+System.today());
        insert conuser;
        campaign camp = new campaign(Name='Test Campaign',Status='In Progress',isActive=true);
        insert camp;
        Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert a;
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id,MailingCountry='India',Email='test.t@test.com',
                                MailingStreet='Whitefield',Phone='12345676',MailingCity='Bangalore',MailingPostalCode='560066',MailingState='Karnataka');
        insert c;
        Account acc = [SELECT id FROM Account WHERE Name = 'Test Account1234' Limit 1];
        Contact con  = [SELECT id FROM Contact WHERE AccountId =: acc.id Limit 1];
        
        Task ts = new Task(Subject='Test Task', Status='Completed', Priority='Normal', CallType='Outbound', Whatid= acc.id, Whoid= con.id,Recordtypeid='01261000000j3YQ');
        String fld = 'Status';
        String myJSON = JSON.serialize(ts);
        CreateLatticeTaskController.getCampaigName(camp.Name);
        CreateLatticeTaskController.getContactName(c.firstname);
        CreateLatticeTaskController.fetchUser();
        CreateLatticeTaskController.getselectOptions(ts, fld);
        CreateLatticeTaskController.saveCallTask(myJSON);
    }
    
}