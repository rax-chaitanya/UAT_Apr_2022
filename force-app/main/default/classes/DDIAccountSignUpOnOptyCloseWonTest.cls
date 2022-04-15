@istest(seeAllData = true)
public class DDIAccountSignUpOnOptyCloseWonTest {
    @istest
    static void method1() {
     
        Id devRecordTypeId3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        Id condevRecordTypeId3 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account').getRecordTypeId();
        Contracting_Entity__c ce=new Contracting_Entity__c(Name='test Onica');
        insert ce;
        Account a = new Account(RecordTypeId =devRecordTypeId3,Name='Test Account1234',CurrencyIsoCode='USD',Tax_ID_VAT_Number__c='67jh5',BillingCountry='Australia',ShippingCountry='Japan',Partner_Account_Status__c='Approved',Contracting_Entity__c=ce.id);
        insert a;
        Account a1 = new Account(RecordTypeId =devRecordTypeId3,Name='Test Account12345',BillingCountry='Australia',ShippingCountry='Japan',Partner_Account_Status__c='Approved',Contracting_Entity__c=ce.id);
        insert a1;
        //Contact c = new Contact(RecordTypeId =condevRecordTypeId3,firstname='Test Contact',LastName='Test Last',AccountId=a.id,Salutation='Mr',suffix='ms',Email='test@gmail.com',Phone='9878765456',mailingpostalcode='2324',Mailingcity='Organ',MailingStreet='25',Mailingcountry='United States',Is_Primary_Member__c=True,mailingstate='California');
        //insert c;
        Account ac = new Account(RecordTypeId =devRecordTypeId,Name='Test C Account',Company_Name__c=a.Id,DDI__c='123456',BillingCountry='Japan', ShippingCountry='Japan',Tax_ID_VAT_Number__c='67jh9',Contracting_Entity__c=ce.id);
        insert ac; 
        Contact c1 = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a1.id,Salutation='Mr',suffix='ms',Email='test@gmail.com',Phone='9878765456',mailingpostalcode='2324',Mailingcity='Organ',MailingStreet='25',Mailingcountry='United States',Is_Primary_Member__c=True,mailingstate='California');
        insert c1; 
        Contact c2 = new Contact(firstname='Test Contact2',LastName='Test Last2',AccountId=ac.id, Salutation='Mr',suffix='ms',Email='test1@gmail.com',Phone='9878765459',mailingpostalcode='12324',Mailingcity='Organ',MailingStreet='25',Mailingcountry='United States',Is_Primary_Member__c=True,mailingstate='California');
        insert c2; 
        
        Set<Id> scon1=new Set<Id>();
        scon1.add(c2.Id);
        AccountContactRelation acr1=new AccountContactRelation(Contactid=c2.id,Roles='Primary',Accountid=a1.id);
        insert acr1;
        
        AccountContactRelation acr2=new AccountContactRelation(Contactid=c1.id,Roles='Billing',Accountid=ac.id);
        insert acr2;
        AccountContactRelation acr=[select id,roles,contactid from AccountContactRelation where Accountid=:ac.id Limit 1];
        acr.roles='Primary Contact';
        update acr; 
            
               List<contact> con=TestDataHelper.createTestContacts(10);
        for(contact c:con)
        {
            c.AccountId=a1.id;
        }
        insert con;
        Set<Id> scon=new Set<Id>();
        for(contact c:con)
        {
            scon.add(c.Id);
        }
// con.accountid = a.id;

         test.startTest();

        Opportunity opty = new Opportunity(Type='AWS',Name='Test Opporty',AcquisitionId__c='123ght',AccountId=a.Id,Account__c=ac.id,StageName='Stage 1 - Planning & Identification',CloseDate=System.today());
        insert opty; 
        Test.stopTest(); 
        DDIAccountSignUpOnOptyCloseWon.DDIAccountSignUpPayload(opty.id,scon1);
        //  DDIAccountSignUpOnOptyCloseWon dc= new DDIAccountSignUpOnOptyCloseWon();
        //List<DDIAccountSignUpOnOptyCloseWon__c> DDIAccount = [Select Id ,Name , Type__c,BusinessType__c from DDIAccountSignUpOnOptyCloseWon__c Limit 1] ;
        
        
        
    }
        @istest
    static void method2() {
     
        Id devRecordTypeId3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        Id condevRecordTypeId3 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account').getRecordTypeId();
        Contracting_Entity__c ce=new Contracting_Entity__c(Name='test Onica');
        insert ce;
        Account a = new Account(RecordTypeId =devRecordTypeId3,Name='Test Account1234',CurrencyIsoCode='USD',Tax_ID_VAT_Number__c='67jh5',BillingCountry='Australia',ShippingCountry='Japan',Partner_Account_Status__c='Approved',Contracting_Entity__c=ce.id);
        insert a;
        Account a1 = new Account(RecordTypeId =devRecordTypeId3,Name='Test Account12345',BillingCountry='Australia',ShippingCountry='Japan',Partner_Account_Status__c='Approved',Contracting_Entity__c=ce.id);
        insert a1;
        //Contact c = new Contact(RecordTypeId =condevRecordTypeId3,firstname='Test Contact',LastName='Test Last',AccountId=a.id,Salutation='Mr',suffix='ms',Email='test@gmail.com',Phone='9878765456',mailingpostalcode='2324',Mailingcity='Organ',MailingStreet='25',Mailingcountry='United States',Is_Primary_Member__c=True,mailingstate='California');
        //insert c;
        Account ac = new Account(RecordTypeId =devRecordTypeId,Name='Test C Account',Company_Name__c=a.Id,DDI__c='123456',BillingCountry='Japan', ShippingCountry='Japan',Tax_ID_VAT_Number__c='67jh9',Contracting_Entity__c=ce.id);
        insert ac; 
        Contact c1 = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a1.id,Salutation='Mr',suffix='ms',Email='test@gmail.com',Phone='9878765456',mailingpostalcode='2324',Mailingcity='Organ',MailingStreet='25',Mailingcountry='United States',Is_Primary_Member__c=True,mailingstate='California');
        insert c1; 
        Contact c2 = new Contact(firstname='Test Contact2',LastName='Test Last2',AccountId=ac.id, Salutation='Mr',suffix='ms',Email='test1@gmail.com',Phone='9878765459',mailingpostalcode='12324',Mailingcity='Organ',MailingStreet='25',Mailingcountry='United States',Is_Primary_Member__c=True,mailingstate='California');
        insert c2; 
        
        Set<Id> scon1=new Set<Id>();
        scon1.add(c2.Id);
        AccountContactRelation acr1=new AccountContactRelation(Contactid=c2.id,Roles='Billing',Accountid=a1.id);
        insert acr1;
        
        AccountContactRelation acr2=new AccountContactRelation(Contactid=c1.id,Roles='Billing',Accountid=ac.id);
        insert acr2;
        AccountContactRelation acr=[select id,roles,contactid from AccountContactRelation where Accountid=:ac.id Limit 1];
        acr.roles='Billing';
        update acr; 
            
               List<contact> con=TestDataHelper.createTestContacts(10);
        for(contact c:con)
        {
            c.AccountId=a1.id;
        }
        insert con;
        Set<Id> scon=new Set<Id>();
        for(contact c:con)
        {
            scon.add(c.Id);
        }
// con.accountid = a.id;
           Test.startTest(); 
        Opportunity opty = new Opportunity(Type='AWS',Name='Test Opporty',AcquisitionId__c='123ght',AccountId=a.Id,Account__c=ac.id,StageName='Stage 1 - Planning & Identification',CloseDate=System.today());
        insert opty; 
         
           Test.stopTest(); 
        DDIAccountSignUpOnOptyCloseWon.DDIAccountSignUpPayload(opty.id,scon1);
        //  DDIAccountSignUpOnOptyCloseWon dc= new DDIAccountSignUpOnOptyCloseWon();
        //List<DDIAccountSignUpOnOptyCloseWon__c> DDIAccount = [Select Id ,Name , Type__c,BusinessType__c from DDIAccountSignUpOnOptyCloseWon__c Limit 1] ;
        
    }
    
    
}