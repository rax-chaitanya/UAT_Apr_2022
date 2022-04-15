@isTest(seeAllData = true)
public class OpportunityCloseWonWizardControllerTest {
    
    @IsTest static void testOptyCloseWonWizard1(){
        
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
        Opportunity opty = new Opportunity(Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport',AccountId=a.Id,Account__c=ac.id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',QuotingSystem__c='Rackspace',CloseDate=System.today().addDays(15));
        insert opty;

        ApexPages.currentPage().getParameters().put('id', opty.Id); 
       //ApexPages.currentPage().getParameters().put('aid', a.Id); 
        Accountcontactrelation acr= new Accountcontactrelation(Contactid=c1.id,Roles='Technical',Accountid=a1.id);
        insert acr;
        OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
        System.assert(optycw.getIsPartnerInvolved(),true);
        Test.startTest();
        optycw.accDDI = ac;
        optycw.contact = c;
        optycw.pageNumber =2;
        optycw.saveAndNextUs1();
        optycw.saveAndNextUs2();
        optycw.saveAndNextUs3();
        optycw.pageNumber=3;
        optycw.saveAndNextUs3();
        optycw.saveAndNextUs4();
        optycw.saveAndNextUs5();
        optycw.PrimaryQuoteUpdate();
        optycw.cancel();
        optycw.NewContRole();
        optycw.NewContWithRole();
        optycw.NewContCancel();
        optycw.StrNewContRole = true;
        optycw.SaveContact();
        optycw.getChildOpportunities();
       // optycw.recordID = acr.Id;
        optycw.editAccCont();
        optycw.updateWhyDidWeWin();
        optycw.checkVal();
        optycw.getUser();
        optycw.deleteAccCont();
        test.stopTest();
    }
    
    @IsTest static void testOptyCloseWonWizardNegative(){
        
        Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a;
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id);
        insert c;
        Account ac1 = new Account(Name='Test C Account1',Company_Name__c=a.Id,DDI__c='12345655',RecordTypeId = Label.Account_Prospect_RecordType_ID);
        insert ac1;
        Account ac = new Account(Name='Test C Account',BillingCountry='India',ShippingCountry='India',Company_Name__c=a.Id,RecordTypeId = Label.Account_Prospect_RecordType_ID);
        insert ac;
        Opportunity opt = new Opportunity(Was_a_Partner_Involved__c='No',Why_Did_We_Win__c='Contract negotiations',Name='Test Opport',Type='Azure',AccountId=a.Id,Account__c=ac.id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15));
        List<Opportunity> li=new List<Opportunity>();
        li.add(opt);
        insert li;
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
       /* Account pa = new Account(Name='Test Account1234',RecordTypeId =devRecordTypeId,Partner_Account_Status__c='Approved',Old_Record_Id__c='');
        insert pa;*/
        Opportunity opty = new Opportunity(Was_a_Partner_Involved__c='No',Why_Did_We_Win__c='Contract negotiations',Name='Test Opport',Type='Azure',AccountId=a.Id,Account__c=ac.id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15));
        Insert opty;
        
       /* List<Account_Contact_Role__c> acrlist = new List<Account_Contact_Role__c>();
        Account_Contact_Role__c acr= new Account_Contact_Role__c(Contact__c=c.id,Role__c='Technical');
        insert acr;*/
        
        ApexPages.currentPage().getParameters().put('id', opty.Id); 
        
        OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
        System.assert(!optycw.getIsPartnerInvolved(),true);
        
        optycw.accDDI = ac1;
        optycw.contact = c;
        //optycw.recordID = acr.id;
        optycw.pageNumber =3;
        User u = [Select Id,Region__c from user where isActive=:true AND Region__c=:null Limit 1];
        Test.startTest();
        optycw.RSCloudContinue();
        optycw.save();
        system.runAs(u){
            //optycw.recordID = acr.id;
            optycw.pageNumber =3;
            optycw.accDDI = null; 
            optycw.save();
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
        
        //28-Mar-2018
        
        optycw.getCustomerRecordTypeId();
        test.stopTest();
    }
    
    @IsTest static void testOptyCloseWonWizardNegative2(){
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert a;
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id);
        insert c;
        Account ac = new Account(RecordTypeId =devRecordTypeId,Name='Test C Account',Company_Name__c=a.Id,BillingCountry='India',ShippingCountry='India');
        insert ac;
      //  Contact c3= new Contact(firstname='Test Contact',LastName='Test Last',AccountId=ac.id);
      //  insert c3; 
        Opportunity opt = new Opportunity(Was_a_Partner_Involved__c='No',Why_Did_We_Win__c='Contract negotiations',Name='Test Opport',Type='Azure',
        AccountId=a.Id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',
        CloseDate=System.today().addDays(15),Account__c=ac.id);
        List<Opportunity> li=new List<Opportunity>();
        li.add(opt);
        insert li;
        Opportunity opty = new Opportunity(Was_a_Partner_Involved__c='No',Why_Did_We_Win__c='Contract negotiations',Name='Test Opport',Type='Azure',AccountId=a.Id,Account__c=ac.id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15));
        Insert opty;
        Quote__c q = new Quote__c(Name='Test Quote',opportunity__c  = opty.id,Is_Primary__c=true);
        insert q;
        Quote_Line__c qq=new Quote_Line__c(
            Opportunity_Quote__c = opty.Id,
            Focus_Area__c = 'Amazon',
            Quote__c=q.id,
      New_MRR__c = 100);
        insert qq;
          Id devRecordTypeId2 = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        Account ac2 = new Account(Name='Test C Account',Company_Name__c=a.Id,Old_Record_Id__c='',RecordTypeId =devRecordTypeId2);
        insert ac2;
         AccountContactRelation acr=new AccountContactRelation(Contactid=c.id,Roles='Billing',Accountid=ac2.id);
        /*List<Account_Contact_Role__c> acrlist = new List<Account_Contact_Role__c>();
        AccountContactRelation acr= new AccountContactRelation(Contactid=c.id,Roles='Billing');
        insert acr;
        acrlist.add(new Account_Contact_Role__c(Contact__c=c.id,Role__c='Abuse'));
        acrlist.add(new Account_Contact_Role__c(Contact__c=c.id,Role__c='Billing'));*/
        ApexPages.currentPage().getParameters().put('id', opty.Id); 
        Test.startTest();
        OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
        System.assert(!optycw.getIsPartnerInvolved(),true);
       
        optycw.accDDI = ac;
        optycw.contact = c;
        optycw.recordID = acr.id;
        optycw.pageNumber =3;
        User u = [Select Id,Region__c from user where isActive=:true AND Region__c=:null Limit 1];
        
        optycw.save();
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
        optycw.PrimaryQuoteUpdate();
        test.stopTest();
    }
   @IsTest static void testOptyCloseWonWizardNegative3(){
    Id devRecordTypeId3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
     Id condevRecordTypeId3 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        
         User u = [Select Id,Region__c from user where isActive=:true AND Region__c=:null Limit 1];
        
        Account a = new Account(RecordTypeId =devRecordTypeId3,Name='Test Account1234',BillingCountry='Australia',ShippingCountry='Australia',Partner_Account_Status__c='Approved');
        insert a;
        Contact c = new Contact(RecordTypeId =condevRecordTypeId3,firstname='Test Contact',LastName='Test Last',AccountId=a.id);
        insert c;
        Account ac = new Account(RecordTypeId =devRecordTypeId,Name='Test C Account',Company_Name__c=a.Id);
        insert ac;
       // Contact c3= new Contact(firstname='Test Contact',LastName='Test Last',AccountId=ac.id);
       // insert c3; 
        
        Opportunity opt = new Opportunity(Was_a_Partner_Involved__c='No',Why_Did_We_Win__c='Contract negotiations',Name='Test Opport',Type='Azure',
        AccountId=a.Id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',
        CloseDate=System.today().addDays(15),Account__c=ac.id);
        List<Opportunity> li=new List<Opportunity>();
        li.add(opt);
        insert li;
        Opportunity opty = new Opportunity(Was_a_Partner_Involved__c='No',Why_Did_We_Win__c='Contract negotiations',
        Name='Test Opport',Type='Azure',AccountId=a.Id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',
        CloseDate=System.today().addDays(15));
        try{
        Insert opty;
        }catch(Exception e){
        }
        
  Test.startTest();
        
          Id devRecordTypeId2 = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        Account ac2 = new Account(Name='Test C Account',Company_Name__c=a.Id,Old_Record_Id__c='',RecordTypeId =devRecordTypeId2);
        insert ac2;
         AccountContactRelation acr=new AccountContactRelation(Contactid=c.id,Roles='Billing',Accountid=ac2.id);
        /*List<Account_Contact_Role__c> acrlist = new List<Account_Contact_Role__c>();
        AccountContactRelation acr= new AccountContactRelation(Contactid=c.id,Roles='Billing');
        insert acr;
        acrlist.add(new Account_Contact_Role__c(Contact__c=c.id,Role__c='Abuse'));
        acrlist.add(new Account_Contact_Role__c(Contact__c=c.id,Role__c='Billing'));*/
        ApexPages.currentPage().getParameters().put('id', opt.Id); 
        
        OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
        System.assert(!optycw.getIsPartnerInvolved(),true);
        
        optycw.accDDI = null;
        optycw.contact = c;
        optycw.recordID = acr.id;
        optycw.pageNumber =3;
       
        optycw.save();
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
        
        
       /* optycw.RSCloudContinue();
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
   @IsTest static void testOptyCloseWonWizardNegative4(){
    Id devRecordTypeId3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
     Id condevRecordTypeId3 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        Account a = new Account(RecordTypeId =devRecordTypeId3,Name='Test Account1234',BillingCountry='Australia',ShippingCountry='Australia',Partner_Account_Status__c='Approved');
        insert a;
        Contact c = new Contact(RecordTypeId =condevRecordTypeId3,firstname='Test Contact',LastName='Test Last',AccountId=a.id);
        insert c;
        Account ac = new Account(RecordTypeId =devRecordTypeId,Name='Test C Account',Company_Name__c=a.Id);
        insert ac;
        Contact c3= new Contact(RecordTypeId =condevRecordTypeId3,firstname='Test Contact',LastName='Test Last',AccountId=a.id);
        insert c3; 
        Opportunity opt = new Opportunity(Was_a_Partner_Involved__c='No',Why_Did_We_Win__c='Contract negotiations',Name='Test Opport',Type='Azure',
        AccountId=a.Id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',
        CloseDate=System.today().addDays(15),Account__c=ac.id);
        List<Opportunity> li=new List<Opportunity>();
        li.add(opt);
        insert li;
      
          Id devRecordTypeId2 = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        Account ac2 = new Account(Name='Test C Account',Company_Name__c=a.Id,Old_Record_Id__c='',RecordTypeId =devRecordTypeId2);
        insert ac2;
        // Contact c4 = new Contact(firstname='Test4 Contact',LastName='Test Last',AccountId=ac.id);
        //insert c4;
         AccountContactRelation acr=new AccountContactRelation(Contactid=c.id,Roles='Billing',Accountid=ac.id);
        //insert acr;
        // c.phone='567890';
       //  update c;
        /*List<Account_Contact_Role__c> acrlist = new List<Account_Contact_Role__c>();
        AccountContactRelation acr= new AccountContactRelation(Contactid=c.id,Roles='Billing');
        insert acr;
        acrlist.add(new Account_Contact_Role__c(Contact__c=c.id,Role__c='Abuse'));
        acrlist.add(new Account_Contact_Role__c(Contact__c=c.id,Role__c='Billing'));*/
        ApexPages.currentPage().getParameters().put('id', opt.Id); 
        
        OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
        System.assert(!optycw.getIsPartnerInvolved(),true);
        
        optycw.accDDI = null;
        optycw.contact = c;
        optycw.recordID = acr.id;
        optycw.pageNumber =3;
        User u = [Select Id,Region__c from user where isActive=:true AND Region__c=:null Limit 1];
        Test.startTest();
        optycw.save();
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
        optycw.PrimaryQuoteUpdate();
        test.stopTest();
    }
 @IsTest static void testOptyCloseWonWizardNegative5(){
    Id devRecordTypeId3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
     Id condevRecordTypeId3 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        Account a = new Account(RecordTypeId =devRecordTypeId3,Name='Test Account1234',BillingCountry='Australia',ShippingCountry='Australia',Partner_Account_Status__c='Approved');
        insert a;
        Contact c = new Contact(RecordTypeId =condevRecordTypeId3,firstname='Test Contact',LastName='Test Last',AccountId=a.id,Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California');
        insert c;
        Account ac = new Account(RecordTypeId =devRecordTypeId,Name='Test C Account',Company_Name__c=a.Id,DDI__c='123456');
        insert ac;
       /* Contact c3= new Contact(RecordTypeId =condevRecordTypeId3,firstname='Test Contact',LastName='Test Last',AccountId=a.id);
        insert c3; 
        Contact c4= new Contact(RecordTypeId =condevRecordTypeId3,firstname='Test Contact',LastName='Test Last',AccountId=ac.id);
        insert c4;*/
        AccountContactRelation acr=new AccountContactRelation(Contactid=c.id,Roles='Billing',Accountid=ac.id);
        Opportunity opt = new Opportunity(DDI__c='12345',Was_a_Partner_Involved__c='No',Why_Did_We_Win__c='Contract negotiations',Name='Test Opport',Type='Azure',
        AccountId=a.Id,StageName='Stage 1 - Planning & Identification',
        CloseDate=System.today().addDays(15),Account__c=ac.id);
        List<Opportunity> li=new List<Opportunity>();
        li.add(opt);
        insert li;
      
          Id devRecordTypeId2 = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        Account ac2 = new Account(Name='Test C Account',Company_Name__c=a.Id,Old_Record_Id__c='',RecordTypeId =devRecordTypeId2);
        insert ac2;
        // Contact c4 = new Contact(firstname='Test4 Contact',LastName='Test Last',AccountId=ac.id);
        //insert c4;
         
        //insert acr;
        // c.phone='567890';
       //  update c;
        /*List<Account_Contact_Role__c> acrlist = new List<Account_Contact_Role__c>();
        AccountContactRelation acr= new AccountContactRelation(Contactid=c.id,Roles='Billing');
        insert acr;
        acrlist.add(new Account_Contact_Role__c(Contact__c=c.id,Role__c='Abuse'));
        acrlist.add(new Account_Contact_Role__c(Contact__c=c.id,Role__c='Billing'));*/
        ApexPages.currentPage().getParameters().put('id', opt.Id); 
        
        OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
        System.assert(!optycw.getIsPartnerInvolved(),true);
        
        optycw.accDDI = null;
        optycw.contact = c;
        optycw.recordID = acr.id;
        optycw.pageNumber =3;
        User u = [Select Id,Region__c from user where isActive=:true AND Region__c=:null Limit 1];
        Test.startTest();
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
        optycw.PrimaryQuoteUpdate();
        test.stopTest();
    }
    @IsTest static void noaccounttest(){

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
        Opportunity opty = new Opportunity(Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport',DDI__c='12345655',StageName='Stage 1 - Planning & Identification',QuotingSystem__c='Rackspace',CloseDate=System.today().addDays(15));
        insert opty;
        ApexPages.currentPage().getParameters().put('id', opty.Id); 
       // ApexPages.currentPage().getParameters().put('aid', ac.Id); 
        Accountcontactrelation acr= new Accountcontactrelation(Contactid=c1.id,Roles='Technical',Accountid=a1.id);
        insert acr;
        OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
        }
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
        Opportunity opty = new Opportunity(Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport',AccountId=a.Id,Account__c=ac.id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',QuotingSystem__c='Rackspace',CloseDate=System.today().addDays(15));
        insert opty;
        ApexPages.currentPage().getParameters().put('id', opty.Id); 
       // ApexPages.currentPage().getParameters().put('aid', ac.Id); 
        Accountcontactrelation acr= new Accountcontactrelation(Contactid=c1.id,Roles='Technical',Accountid=a1.id);
        insert acr;
        OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
        }

  
}