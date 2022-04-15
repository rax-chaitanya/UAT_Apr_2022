@istest
public class cLogHandler_Test {
    
    static testmethod void  cloghandlertest(){
        Id STId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
         Account company = new Account(Name = 'TestCompany', BillingCountry = 'Canada', ShippingCountry = 'Canada',RecordTypeId=STId);
         insert company;
        Id RTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account').getRecordTypeId();
         Account acc = new Account(Name = 'test',Type= 'Customer' , ShippingCountry='India',Company_Name__c = company.Id, RecordTypeId = RTypeId);
        insert acc;
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=company.id,MailingCountry='India',Email='test.t@test.com',
                                MailingStreet='Whitefield',Phone='12345676',MailingCity='Bangalore',MailingPostalCode='560066',MailingState='Karnataka');
                                insert new Trigger_Manager__c(name='OpportunitySplitTgr',Is_Active__c=true);
        Opportunity opp = new Opportunity(Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport',AccountId=company.Id,Account__c=acc.id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15),QuotingSystem__c='Rackspace');
       
        insert opp;
         insert new Trigger_Manager__c(name='cLogTgr',Is_Active__c=true);
        cLog__C clog=new cLog__c(Name='Account',Master_Id__c=company.id,IsMerged__c=true);
        insert clog;
        update clog;
        delete clog;
        undelete clog;
    }

}