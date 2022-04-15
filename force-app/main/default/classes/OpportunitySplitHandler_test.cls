@isTest
Public class OpportunitySplitHandler_test{
    @TestSetUp
    static void setDataUp(){
        TestClassUtility.setTestSetupData();
        
        Account acc = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India', RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert acc;
        
      Account custAcc = new Account(Name='Test Custom Account', Company_Name__c=acc.Id,ShippingCountry = 'India', RecordTypeId = Label.Account_Prospect_RecordType_ID);
        insert custAcc; 
        
        Contact con = new Contact(firstname='Rackspace', LastName='Test Contact', AccountId=acc.id);
        insert con; 
        
        Opportunity opp = new Opportunity(Name='Test Opportunity', AccountId=acc.Id, DDI__c='12345655', StageName='Stage 1 - Planning & Identification', CloseDate=System.today().addDays(15), Was_a_Partner_Involved__c='Yes', Type='AWS');
        insert opp;
        String pId = [select id,name from Profile where name='System Administrator' limit 1].id;
        User splitUser = new User(firstname='Test', LastName='SplitUser', Alias = 'standt', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', SSO_Username__c='user123',
                                  Region__c='US',LocaleSidKey='en_US', ProfileId = pId, TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com',FederationIdentifier='4566sfs');
        insert splitUser;        
    }
    
    static testmethod void OpportunitySplitTest1(){        
        Opportunity opp = [SELECT id, OwnerId FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];
        User usr = [SELECT id, Name FROM User WHERE Name = 'Test SplitUser' LIMIT 1];
        
        OpportunitySplit oppSplit = new OpportunitySplit();
        oppSplit.OpportunityId = opp.id;
        oppSplit.SplitPercentage = 0;
        oppSplit.SplitOwnerId = usr.id;
        Insert oppSplit;
        
        Delete oppSplit;
        OpportunitySplitHandler splitHandler = new OpportunitySplitHandler();
        splitHandler.afterUndelete();
    }
}