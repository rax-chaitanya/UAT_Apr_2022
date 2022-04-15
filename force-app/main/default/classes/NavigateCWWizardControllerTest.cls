@isTest(seeAllData = true)
private class NavigateCWWizardControllerTest {
    @IsTest static void TestNavigateCWWizard(){
        
        Id devRecordTypeId3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        Id condevRecordTypeId3 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        Id opptyRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('US_Cloud').getRecordTypeId();
        Contracting_Entity__c ce=new Contracting_Entity__c(Name='test Onica');
        insert ce;
        Account a = new Account(RecordTypeId =devRecordTypeId3,Type='Prospect',Name='Onica Test Acc2',BillingCountry='Australia',ShippingCountry='Japan',Partner_Account_Status__c='Approved',Contracting_Entity__c=ce.id);
        insert a; 
        Account ac = new Account(RecordTypeId =devRecordTypeId,Name='Onica Test C2',Company_Name__c=a.Id,DDI__c='123456',Contracting_Entity__c=ce.id,BillingCountry='Japan', ShippingCountry='Japan');
        insert ac;
        Contact c = new Contact(RecordTypeId =condevRecordTypeId3,Email='Test@gmail.com',Phone='098900000',firstname='Test Contact',LastName='Test Last',AccountId=a.id,mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California');
        insert c;
        Opportunity opty = new Opportunity(Name='Test Opport',Type='Azure',AccountId=a.Id,Account__c=ac.id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15));
        insert opty;
        
        NavigateCWWizardController.getUserInfo();
        NavigateCWWizardController.getLegalApprovalInfo(opty.Id);
        NavigateCWWizardController.getRaptorURL(opty.Id);
        NavigateCWWizardController.getUserPermission('test');
        
    }
    //Method will test a US Professional Services Opportunity with SOW Approval Type = ProServ
    @IsTest static void TestNavigateCWWizardProServ(){
        //Get Record Type ID's for objects Company, Contact, Accounts, Opportunity
        Id devCompRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        Id devContRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Id devAcctRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        Id opptyRecordTypeId2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('US_Cloud').getRecordTypeId();
        //insert test records
        Contracting_Entity__c cne=new Contracting_Entity__c(Name='Rackspace US, Inc');
        insert cne;
        Account acct = new Account(RecordTypeId =devCompRecordTypeId,Name='Test Standard Company',BillingCountry='United States',ShippingCountry='United States',Partner_Account_Status__c='Approved',Contracting_Entity__c=cne.Id);
        insert acct; 
        Account acctprosp = new Account(RecordTypeId =devAcctRecordTypeId,Name='Test Prospect Account',Company_Name__c=acct.Id,DDI__c='123456',Contracting_Entity__c=cne.Id,BillingCountry='United States', ShippingCountry='United States');
        insert acctprosp;
        Contact stdcont = new Contact(RecordTypeId =devContRecordTypeId,Email='Test@gmail.com',Phone='098900000',firstname='Test Contact',LastName='Test Last',AccountId=acct.id,mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California');
        insert stdcont;
        Opportunity proservopty = new Opportunity(Name='Test Proserv Opp',Type='Professional Services',AccountId=acct.Id,Account__c=acctprosp.Id,DDI__c='12345655',StageName='Stage 3 - Proposal & Quote',CloseDate=System.today(),service_fees__c = 1, Onica_Type__c = 'ProServ');
        insert proservopty;
        Approval__c sow = new Approval__c (Opportunity__c =proservopty.id,Document_Type__c = 'SOW', Status__c = 'Completed');
        insert sow;
        
        NavigateCWWizardController.getUserInfo();
        NavigateCWWizardController.getLegalApprovalInfo(proservopty.Id);
        NavigateCWWizardController.getRaptorURL(proservopty.Id);
        NavigateCWWizardController.getUserPermission('test');
    }   
    
    @IsTest static void testGovernmentRec(){
        
        Id govRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Government_Company').getRecordTypeId();
        Id govRecTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Government').getRecordTypeId();
        Id congovRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Government').getRecordTypeId();
        Id opptyRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Government').getRecordTypeId();
        
        Account a = new Account(RecordTypeId =govRecTypeId,Name='test gov comp',BillingCountry='Australia',ShippingCountry='Japan',Partner_Account_Status__c='Approved');
        insert a; 
        Account ac = new Account(RecordTypeId =govRecTypeIdAcc,Name='test Gov Acc',Company_Name__c=a.Id,BillingCountry='Japan', ShippingCountry='Japan');
        insert ac;
        Contact c = new Contact(RecordTypeId = congovRecTypeId,Email='Test@gmail.com',Phone='098900000',firstname='Test Contact',LastName='Test Last',AccountId=a.id,mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California');
        insert c;
        Opportunity opty = new Opportunity(Name='Test Opport',Type='AWS',AccountId=a.Id,Account__c=ac.id,StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15),DDI__c= '456754');
        insert opty;
        
        NavigateCWWizardController.checkgovtopptydetails(opty.Id);
        
    }
}