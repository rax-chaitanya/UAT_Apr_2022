@isTest(seeAllData = true)
public class OpportunityCloseWonWizardController_Test {
    
    
    @IsTest static void testOptyCloseWonWizardNegative6(){
    Id devRecordTypeId3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
     Id condevRecordTypeId3 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        
        Account a = new Account(RecordTypeId =devRecordTypeId3,Name='Test Account1234',BillingCountry='Australia',ShippingCountry='Australia',Partner_Account_Status__c='Approved');
        insert a;
         Account a1 = new Account(RecordTypeId =devRecordTypeId3,Name='Test Account12345',BillingCountry='Australia',ShippingCountry='Australia',Partner_Account_Status__c='Approved');
        insert a1;
        Contact c = new Contact(RecordTypeId =condevRecordTypeId3,firstname='Test Contact',LastName='Test Last',AccountId=a1.id,mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California');
        insert c;
        Account ac = new Account(RecordTypeId =devRecordTypeId,Name='Test C Account',Company_Name__c=a.Id,DDI__c='123456');
        insert ac;
      Test.startTest();
        AccountContactRelation acr2=new AccountContactRelation(Contactid=c.id,Roles='Billing',Accountid=ac.id);
        insert acr2;
        AccountContactRelation acr=[select id,roles,contactid from AccountContactRelation where Accountid=:ac.id Limit 1];
       acr.roles='Billing';
        update acr;
        Opportunity opt = new Opportunity(DDI__c='12345',Was_a_Partner_Involved__c='No',Why_Did_We_Win__c='Contract negotiations',Name='Test Opport',Type='Azure',
        AccountId=a.Id,StageName='Stage 1 - Planning & Identification',
        CloseDate=System.today().addDays(15),Account__c=ac.id);
        List<Opportunity> li=new List<Opportunity>();
        li.add(opt);
        insert li;
      
          Id devRecordTypeId2 = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        Account ac2 = new Account(Name='Test C Account',Company_Name__c=a.Id,Old_Record_Id__c='',RecordTypeId =devRecordTypeId2);
        insert ac2;
        
        ApexPages.currentPage().getParameters().put('id', opt.Id); 
        
        OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
        System.assert(!optycw.getIsPartnerInvolved(),true);
        
        optycw.accDDI = null;
        optycw.contact = c;
        optycw.recordID = acr.id;
        optycw.pageNumber =3;
        User u = [Select Id,Region__c from user where isActive=:true AND Region__c=:null Limit 1];
        
        optycw.save();
        optycw.LoadAccRoles();
        system.runAs(u){
            system.debug('After runAs');
            optycw.recordID = acr.id;
            optycw.pageNumber =3; 
            optycw.save();
            system.debug('Current user'+UserInfo.getUserName());
        }
        optycw.saveAndNextUs1();
        optycw.saveAndNextUs2();
        optycw.saveAndNextUs3();
        
        optycw.saveAndNextUs4();
       /* optycw.saveAndNextUs5();
        optycw.SaveContact();
        optycw.LoadAccRoles();
        optycw.RsOppList=li;
        optycw.getChildOpportunities();
        
        
        optycw.RSCloudContinue();
        optycw.getCustomerRecordTypeID();
        optycw.getEConnectDocumentsURL();
        optycw.getRaptorDocumentsURL();
        //28-Mar-2018
        optycw.getRedirectToOpp();
        optycw.query('Unknown');
        optycw.account = null;
        optycw.saveandnextUS2();
        optycw.PrimaryQuoteUpdate();*/
        test.stopTest();
    }
    @isTest
    static void accountContactRoleTest1(){
    Trigger_Manager__c Tm = new Trigger_Manager__c (Name ='ContactTgr1',Is_Active__c = true);
    insert Tm;
        Id StandardCmpRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        Id ProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        
        Account cmp = new Account(Name='Test Account1234',RecordTypeId=StandardCmpRecordTypeId,Partner_Account_Status__c ='Approved',phone ='1212121212', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka');
        insert cmp;
         Account cmp1 = new Account(Name='Test Account12634',RecordTypeId=StandardCmpRecordTypeId,Partner_Account_Status__c ='Approved',phone ='12121271212', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka');
        insert cmp1;
        Account pac = new Account(Name='Test C Account',Company_Name__c=cmp.Id,RecordTypeId=ProspectRecordTypeId,phone ='1212121212');
        insert pac;
         Account pac2 = new Account(Name='Test C Account2',Company_Name__c=cmp.Id,RecordTypeId=ProspectRecordTypeId,phone ='1212412166');
        insert pac2;
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=cmp1.id,mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California');
        insert c;
        //Contact c1 = new Contact(firstname='Test Contact2',LastName='Test Last',AccountId=pac.id,mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California');
        //insert c1;
         Contact c2 = new Contact(firstname='Test Contact3',LastName='Test Last',AccountId=cmp.id,mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California');
        insert c2;
        
        AccountContactRelation acr= new AccountContactRelation(Accountid=pac.id,Contactid=c.id,Roles='Billing');
        //insert acr;
       // delete acr;
         Test.startTest();
    
Opportunity opt = new Opportunity(Was_a_Partner_Involved__c='No',Why_Did_We_Win__c='Contract negotiations',Name='Test Opport',Type='Azure',
        AccountId=cmp.Id,StageName='Stage 1 - Planning & Identification',
        CloseDate=System.today().addDays(15),Account__c=pac.id);
        List<Opportunity> li=new List<Opportunity>();
        li.add(opt);
        
        insert li;
      
        //  Id devRecordTypeId2 = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
       // Account ac2 = new Account(Name='Test C Account',Company_Name__c=a.Id,Old_Record_Id__c='',RecordTypeId =devRecordTypeId2);
        //insert ac2;
        ApexPages.currentPage().getParameters().put('id', opt.Id); 
        
        OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
        System.assert(!optycw.getIsPartnerInvolved(),true);
        
        optycw.accDDI = null;
        optycw.contact = c;
        optycw.recordID = acr.id;
        optycw.pageNumber =3;
        User u = [Select Id,Region__c from user where isActive=:true AND Region__c=:null Limit 1];
       
        optycw.save();
        optycw.LoadAccRoles();
        system.runAs(u){
            system.debug('After runAs');
            optycw.recordID = acr.id;
            optycw.pageNumber =3; 
            optycw.save();
            system.debug('Current user'+UserInfo.getUserName());
        }
        optycw.saveAndNextUs1();
        optycw.saveAndNextUs2();
        optycw.saveAndNextUs3();
        
        optycw.saveAndNextUs4();
        optycw.saveAndNextUs5();
        optycw.SaveContact();
        optycw.LoadAccRoles();
        optycw.RsOppList=li;
        optycw.getChildOpportunities();
        
        
        optycw.RSCloudContinue();
        optycw.getCustomerRecordTypeID();
        optycw.getEConnectDocumentsURL();
        optycw.getRaptorDocumentsURL();
        //28-Mar-2018
        optycw.getRedirectToOpp();
        optycw.query('Unknown');
        optycw.account = null;
        optycw.saveandnextUS2();
        //optycw.PrimaryQuoteUpdate();
        test.stopTest();
    }
  /*   @isTest
    static void accountContactRoleTest1_1(){
    Trigger_Manager__c Tm = new Trigger_Manager__c (Name ='ContactTgr1',Is_Active__c = true);
    insert Tm;
   user u= [SELECT Name FROM user WHERE Id = :UserInfo.getUserId()];
   system.runas(u){
        Id StandardCmpRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        Id ProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        Account cmp = new Account(Name='Test Account1234',RecordTypeId=StandardCmpRecordTypeId,Partner_Account_Status__c ='Approved',phone ='1212121212', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka');
        insert cmp;
        Account cmp1 = new Account(Name='Test Account12354',RecordTypeId=StandardCmpRecordTypeId,Partner_Account_Status__c ='Approved',phone ='12125121212', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka');
        insert cmp1;
        Account pac = new Account(Name='Test C Account',Company_Name__c=cmp.Id,RecordTypeId=ProspectRecordTypeId,phone ='1212121212');
        insert pac;
         Account pac2 = new Account(Name='Test C Account2',Company_Name__c=cmp.Id,RecordTypeId=ProspectRecordTypeId,phone ='1212412166');
        insert pac2;
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=cmp1.id,mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California');
        insert c;
        Contact c1 = new Contact(firstname='Test Contact2',LastName='Test Last',AccountId=pac.id,mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California');
        insert c1;
         Contact c2 = new Contact(firstname='Test Contact3',LastName='Test Last',AccountId=cmp.id,mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California');
        insert c2;
      Account cmp2 = new Account(Name='Test Account1234',RecordTypeId=StandardCmpRecordTypeId,Partner_Account_Status__c ='Approved',phone ='1212121212', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka');
        insert cmp2;
        Contact c3 = new Contact(firstname='Test Contact90',LastName='Test Last890',AccountId=cmp2.id,mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California');
     insert c3;
        
 
      //  AccountContactRelation acr= new AccountContactRelation(Accountid=pac.id,Contactid=c.id,Roles='Primary Contact');
      // insert acr;
       /* AccountContactRelation acr2= new AccountContactRelation(Accountid=pac.id,Contactid=c2.id,Roles='Primary Contact');
        insert acr2;
       // delete acr;
        
    
 Opportunity opt = new Opportunity(Was_a_Partner_Involved__c='No',Why_Did_We_Win__c='Contract negotiations',Name='Test Opport',Type='Azure',
        AccountId=cmp.Id,StageName='Stage 1 - Planning & Identification',
        CloseDate=System.today().addDays(15),Account__c=pac.id);
       // List<Opportunity> li=new List<Opportunity>();
       // li.add(opt);
        insert opt;
      
        ApexPages.currentPage().getParameters().put('id', opt.Id); 
        
        OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
        System.assert(!optycw.getIsPartnerInvolved(),true);
        
        optycw.accDDI = null;
        optycw.contact = c;
      //  optycw.recordID = acr.id;
        optycw.pageNumber =3;
       // User u = [Select Id,Region__c from user where isActive=:true AND Region__c=:null Limit 1];
        Test.startTest();
        optycw.save();
       // optycw.LoadAccRoles();
        system.runAs(u){
            system.debug('After runAs');
           // optycw.recordID = acr.id;
            optycw.pageNumber =3; 
            optycw.save();
            system.debug('Current user'+UserInfo.getUserName());
        }
        optycw.saveAndNextUs1();
        optycw.saveAndNextUs2();
        optycw.saveAndNextUs3();
        
        optycw.saveAndNextUs4();
        optycw.saveAndNextUs5();
        optycw.SaveContact();
        optycw.LoadAccRoles();
        //optycw.RsOppList=li;
        optycw.getChildOpportunities();
        
        
        optycw.RSCloudContinue();
        optycw.getCustomerRecordTypeID();
        optycw.getEConnectDocumentsURL();
        optycw.getRaptorDocumentsURL();
        //28-Mar-2018
        optycw.getRedirectToOpp();
        optycw.query('Unknown');
        optycw.account = null;
        optycw.saveandnextUS2();
        optycw.PrimaryQuoteUpdate();
        test.stopTest();
    }
    }*/
     @IsTest static void withaccounttest(){

Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a;
        Account a1 = new Account(Name='Test Account',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a1;
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id,MailingCountry='India',Email='test.t@test.com',
                                MailingStreet='Whitefield',Phone='12345676',MailingCity='Bangalore',MailingPostalCode='560066',MailingState='Karnataka');
        // insert c;
        Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,RecordTypeId = Label.Account_Prospect_RecordType_ID,BillingCountry='India',ShippingCountry='India');
        insert ac;
        Contact c1 = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id);
        insert c1; 
        Opportunity opty = new Opportunity(Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport',AccountId=a.Id,Account__c=ac.id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',QuotingSystem__c='Rackspace',Expected_Revenue_Start_Date__c=System.today(),CloseDate=System.today().addDays(15),Cloud_Contract_Type__c='Regular',Category__c='Downgrade');
        insert opty;
        ApexPages.currentPage().getParameters().put('id', opty.Id); 
       // ApexPages.currentPage().getParameters().put('aid', ac.Id); 
        Accountcontactrelation acr= new Accountcontactrelation(Contactid=c1.id,Roles='Technical',Accountid=a1.id);
        insert acr;
        OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
          optycw.saveAndNextUs5();
        }
}