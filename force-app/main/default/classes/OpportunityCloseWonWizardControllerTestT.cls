@isTest(seeAllData = true)
public class OpportunityCloseWonWizardControllerTestT {
    //@Dev: Caleb Garcia, @Story: SFDC-6666, @Description: to test failure scenarios of failure codes 400,401, and 200 (when integration status = failure)
    @IsTest static void Test_DDI_Failure_Integration(){
        Id devRecordTypeId3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        Id condevRecordTypeId3 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        Account a = new Account(RecordTypeId =devRecordTypeId3,Name='Test Acc6',BillingCountry='United States',ShippingCountry='United States',Partner_Account_Status__c='Approved');
        insert a;
        Account ac = new Account(RecordTypeId =devRecordTypeId,Name='Test C6',Company_Name__c=a.Id);
        insert ac;
        Contact c = new Contact(RecordTypeId =condevRecordTypeId3,firstname='Test Contact6',LastName='Test Last',AccountId=a.id,Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='American Samoa',Email='Testrackspace@gmail.com');
        insert c;
        Id recordTypeId =Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('US_Cloud').getRecordTypeId();
        /*Opportunity oppty1 = new Opportunity(Was_a_Partner_Involved__c='No',Why_Did_We_Win__c='Contract negotiations',Name='Test Opport Int400',Type='Azure',
        StageName='Stage 5 - Closing the Business', CloseDate=System.today().addDays(15),Account__c=ac.id,RecordTypeId=recordTypeId,integration_status_code__c='400',Is_FutureJob_Running__c=false,Integration_Status__c = 'Failure',MuleSoft_Acknowledge__c = true);*/
        Opportunity oppty2 = new Opportunity(Was_a_Partner_Involved__c='No',Why_Did_We_Win__c='Contract negotiations',Name='Test Opport Int401',Type='Azure',
        StageName='Stage 5 - Closing the Business', CloseDate=System.today().addDays(15),Account__c=ac.id,RecordTypeId=recordTypeId,integration_status_code__c='401',Is_FutureJob_Running__c=false,Integration_Status__c = 'Failure',MuleSoft_Acknowledge__c = false);
        Opportunity oppty3 = new Opportunity(Was_a_Partner_Involved__c='No',Why_Did_We_Win__c='Contract negotiations',Name='Test Opport IntFailure200',Type='AWS',
        StageName='Stage 5 - Closing the Business', CloseDate=System.today().addDays(15),Account__c=ac.id,RecordTypeId=recordTypeId,Integration_status_code__c='200',Is_FutureJob_Running__c=false,Integration_Status__c = 'Failure',MuleSoft_Acknowledge__c = true, DDI__c = '');
        List<Opportunity> li=new List<Opportunity>();

        li.add(oppty2);
        li.add(oppty3);
        insert li;

        ApexPages.currentPage().getParameters().put('id', oppty2.Id);
        
        OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
        System.assert(!optycw.getIsPartnerInvolved(),true);
        
        optycw.accDDI = null;
        optycw.contact = c;
        optycw.pageNumber =3;
        Test.StartTest();
        optycw.saveAndNextUs1();
        optycw.saveAndNextUs2();
        optycw.saveAndNextUs3();
        optycw.saveAndNextUs4();
        optycw.saveAndNextUs5();
        optycw.save();
        optycw.RSCloudContinue();
        optycw.PrimaryQuoteUpdate();
        optycw.cancel();
        Test.StopTest();
    }
    //SFDC-6666 End Test
    @IsTest static void Test_WithAccount(){
        Id devRecordTypeId3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        Id condevRecordTypeId3 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        Account a = new Account(RecordTypeId =devRecordTypeId3,Name='Test Acc3',BillingCountry='Australia',ShippingCountry='Australia',Partner_Account_Status__c='Approved');
        insert a;
        Account ac = new Account(RecordTypeId =devRecordTypeId,Name='Test C3',Company_Name__c=a.Id);
        insert ac;
        Contact c = new Contact(RecordTypeId =condevRecordTypeId3,firstname='Test Contact',LastName='Test Last',AccountId=a.id,Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California',Email='Testrackspace@gmail.com');
        insert c;
        Id recordTypeId =Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('US_Cloud').getRecordTypeId();
        Opportunity opt = new Opportunity(Was_a_Partner_Involved__c='No',Why_Did_We_Win__c='Contract negotiations',Name='Test Opport',Type='Azure',
                                          AccountId=a.Id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',
                                          CloseDate=System.today().addDays(15),Account__c=ac.id);
        Opportunity opt1 = new Opportunity(Was_a_Partner_Involved__c='No',Why_Did_We_Win__c='Contract negotiations',Name='Test Opport',Type='Azure',
                                           AccountId=a.Id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',
                                           CloseDate=System.today().addDays(15),Account__c=ac.id,RecordTypeId=recordTypeId,integration_status_code__c='503',Is_FutureJob_Running__c=false);
        
        List<Opportunity> li=new List<Opportunity>();
        li.add(opt);
        li.add(opt1);
        insert li;
        
        ApexPages.currentPage().getParameters().put('id', opt.Id); 
        
        OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
        System.assert(!optycw.getIsPartnerInvolved(),true);
        // optycw.opportunity=li[1];
        optycw.accDDI = null;
        optycw.contact = c;
        optycw.pageNumber =3;
        Test.StartTest();
        
        optycw.save();
        optycw.saveAndNextUs1();
        optycw.saveAndNextUs2();
        optycw.saveAndNextUs3();
        optycw.RSCloudContinue();
        optycw.cancel();
        optycw.getEConnectDocumentsURL();
        optycw.getRaptorDocumentsURL();
        optycw.getChildOpportunities();
        optycw.saveandnextUS2();
        optycw.getRedirectToOpp();
        optycw.query('Unknown');
        optycw.account = null;
        optycw.saveandnextUS2();
        optycw.PrimaryQuoteUpdate();
        optycw.checkVal();
        optycw.goToOpp();
        Test.StopTest();
    }
    
    @IsTest static void Test_WithDDI(){
        Id devRecordTypeId3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        Id condevRecordTypeId3 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        Account a = new Account(RecordTypeId =devRecordTypeId3,Name='Test Acc2',BillingCountry='Australia',ShippingCountry='Australia',Partner_Account_Status__c='Approved');
        insert a;
        Account ac = new Account(RecordTypeId =devRecordTypeId,Name='Test C2',Company_Name__c=a.Id,DDI__c='123456');
        insert ac;
        Contact c = new Contact(RecordTypeId =condevRecordTypeId3,firstname='Test Contact',LastName='Test Last',AccountId=a.id,mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California',Email='Testrackspace@gmail.com');
        insert c;
        Opportunity opt = new Opportunity(DDI__c='12345',Was_a_Partner_Involved__c='No',Why_Did_We_Win__c='Contract negotiations',Name='Test Opport2',Type='Azure',
                                          AccountId=a.Id,StageName='Stage 1 - Planning & Identification',
                                          CloseDate=System.today().addDays(15));
        List<Opportunity> li=new List<Opportunity>();
        li.add(opt);
        insert li;
        ApexPages.currentPage().getParameters().put('id', opt.Id); 
        
        OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
        optycw.accDDI = null;
        optycw.contact = c;
        optycw.pageNumber =3;
        Test.StartTest();
        optycw.save();
        optycw.saveAndNextUs1();
        optycw.saveAndNextUs2();
        optycw.saveAndNextUs3();
        optycw.updateWhyDidWeWin();
        optycw.checkVal();
        optycw.RSCloudContinue();
        optycw.cancel();
        optycw.getEConnectDocumentsURL();
        optycw.getRaptorDocumentsURL();
        Test.StopTest();
    }
    
    @IsTest static void Test_WithoutAccount(){
        Id devRecordTypeId3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        Id condevRecordTypeId3 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        Account a = new Account(RecordTypeId =devRecordTypeId3,Name='Test Acc',BillingCountry='Australia',ShippingCountry='Australia',Partner_Account_Status__c='Approved');
        insert a;
        Account ac = new Account(RecordTypeId =devRecordTypeId,Name='Test C1',Company_Name__c=a.Id,DDI__c='12345');
        insert ac;
        Contact c = new Contact(RecordTypeId =condevRecordTypeId3,firstname='Test Contact',LastName='Test Last',AccountId=a.id,mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California',Email='Testrackspace@gmail.com');
        insert c;
        Opportunity opt = new Opportunity(DDI__c='12345',Was_a_Partner_Involved__c='No',Name='Test Opport3',Type='Azure',
                                          AccountId=a.Id,StageName='Stage 1 - Planning & Identification',
                                          CloseDate=System.today().addDays(15));
        List<Opportunity> li=new List<Opportunity>();
        li.add(opt);
        insert li;
        ApexPages.currentPage().getParameters().put('id', opt.Id); 
        
        OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
        // optycw.accDDI = null;
        optycw.contact = c;
        optycw.pageNumber =3;
        Test.StartTest();
        optycw.save();
        optycw.saveAndNextUs1();
        optycw.saveAndNextUs2();
        optycw.saveAndNextUs3();
        optycw.saveAndNextUs4();
        optycw.saveAndNextUs5();
        optycw.RSCloudContinue();
        optycw.PrimaryQuoteUpdate();
        Test.StopTest();
    }
    
    @IsTest static void Test_Failure(){
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Rackspace Seller-US'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert u;
        Id devRecordTypeId3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        Id condevRecordTypeId3 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        system.runas(u){
            Account a = new Account(RecordTypeId =devRecordTypeId3,Name='Test Acc',BillingCountry='Australia',ShippingCountry='Australia',Partner_Account_Status__c='Approved');
            insert a;
            Account ac = new Account(RecordTypeId =devRecordTypeId,Name='Test C1',Company_Name__c=a.Id,DDI__c='12345',ShippingCountry='Australia',BillingCountry='Australia');
            insert ac;
            Contact c = new Contact(RecordTypeId =condevRecordTypeId3,firstname='Test Contact',LastName='Test Last',AccountId=a.id,mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California',Email='Testrackspace@gmail.com');
            insert c;
            Opportunity opt = new Opportunity(Hosting_Fee__c=100,Contract_Length__c=10,DDI__c='12345',Was_a_Partner_Involved__c='No',Name='Test Opport3',Type='AWS',Category__c='New Logo',
                                              AccountId=a.Id,Account__c=ac.id,StageName='Stage 1 - Planning & Identification',Market_Source__c='No',
                                              CloseDate=System.today().addDays(15),Expected_Revenue_Start_Date__c=System.today().addDays(2));
            List<Opportunity> li=new List<Opportunity>();
            li.add(opt);
            insert li;
            ApexPages.currentPage().getParameters().put('id', opt.Id); 
            
            OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
            // optycw.accDDI = null;
            optycw.contact = c;
            optycw.pageNumber =3;
            Test.StartTest();
            optycw.save();
            optycw.saveAndNextUs1();
            optycw.saveAndNextUs2();
            optycw.saveAndNextUs3();
            optycw.saveAndNextUs4();
            optycw.saveAndNextUs5();
            optycw.RSCloudContinue();
            optycw.PrimaryQuoteUpdate();
            Test.StopTest();
        }
        
    }
    
    @IsTest static void CompanyProfileControllerTest(){ 
        
        Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
        Id conRID= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        Id oppRID= Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('US Cloud').getRecordTypeId();
        Account a1 = new Account(DDI__c='12345675',Contract_Type__c='Agent Channel Agreement',Partner_Account_Status__c='Approved',Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =system.today(),Partner_Level__c='Reseller',RecordTypeId= accRID,Name='Test Acc1234',BillingCountry='India',ShippingCountry='India');
        insert a1;
        Contact c = new Contact(RecordTypeId= conRID,firstname='Test C',LastName='Test Last',AccountId=a1.id,Email = System.now().millisecond() + 'test@test.com');
        insert c;
        a1.Primary_Member__c = c.Id;
        update a1;
        
        Opportunity opty = new Opportunity(Partner_Company__c=a1.Id,Category__c='New Logo',Was_a_Partner_Involved__c='Yes',
                                           Type='AWS',
                                           //CAC_Integration_Status__c='Success', MuleSoft_Acknowledge__c=True ,
                                           Onica_Type__c='PSO',
                                           RecordTypeId = oppRID,Name='Test Oppty1',DDI__c='12345675',StageName='Stage 1 - Planning & Identification',
                                           CloseDate=System.today().addDays(15));
        insert opty;
        ApexPages.currentPage().getParameters().put('id', opty.Id); 
        
        OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
        Test.startTest();
        optycw.save();
        optycw.saveAndNextUs2();
        optycw.pageNumber =2;
        optycw.saveandnextUS3();
        optycw.getEditAccContRole();
        optycw.RSCloudContinue();
        Test.StopTest();
    }
    
    //@story: SFDC-6974, @dev: Caleb Garcia, @date: 11/29/21
    @IsTest static void Test_RPN_PrimaryContact(){
       
        Id devRecordTypeId3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        Id condevRecordTypeId3 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        Id opptyRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('US_Cloud').getRecordTypeId();
        Account accst = new Account(RecordTypeId =devRecordTypeId3,Name='Test AccStd',Partner_Account_Status__c='Approved',BillingCountry='United States',ShippingCountry='United States');
        insert accst;
        Account accp = new Account(RecordTypeId =devRecordTypeId,Name='Test AccProsp2S',Company_Name__c=accst.Id,DDI__c='123456',Type = 'Prospect',BillingCountry='United States', ShippingCountry='United States');
        insert accp;
        Contact cRPN = new Contact(RecordTypeId =condevRecordTypeId3,Email='Test@gmail.com',Phone='098900000',firstname='Test Contact',LastName='Test Last',AccountId=accst.id, RPN__c = 'RPN-123-456-789',mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California');
        insert cRPN;
        Contact cBilling = new Contact(RecordTypeId =condevRecordTypeId3,Email='Test2@gmail.com',Phone='098900001',firstname='Test ContactB',LastName='Test LastB',AccountId=accst.id, RPN__c = 'RPN-123-456-780',mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='');
        insert cBilling;
        Opportunity opt = new Opportunity(RecordTypeId = opptyRecordTypeId,Amount=100,Type='AWS',DDI__c='12345',Was_a_Partner_Involved__c='No',Why_Did_We_Win__c='Contract negotiations',Name='Test Opport RPN',
                                          AccountId=accst.Id,Account__c=accp.id,StageName='Stage 5 - Closing the Business',Primary_Contact__c = cRPN.id,
                                          CloseDate=System.today().addDays(15));
        List<Opportunity> li=new List<Opportunity>();
        li.add(opt);
        insert li;
        AccountContactRelation acrPrimary=[Select id,roles,Contactid from AccountContactRelation where AccountId =:accp.id AND Contactid=:cRPN.id];
        acrPrimary.Roles='Primary Contact';
        update acrPrimary;
        AccountContactRelation acrBilling = new Accountcontactrelation(Contactid = cBilling.id,AccountId = accp.id,roles = 'Billing');
        insert acrBilling;
        ApexPages.currentPage().getParameters().put('id', opt.Id); 
        OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
        
        Test.StartTest();       
        optycw.saveAndNextUs1();
        optycw.saveAndNextUs2();
        update opt;
        optycw.saveAndNextUs3();
        optycw.saveAndNextUs4();
        optycw.saveandnextUS5();
        optycw.save();
        optycw.updateWhyDidWeWin();
        optycw.checkVal();
        optycw.RSCloudContinue();
        optycw.NewContRole();
        optycw.NewContWithRole();
        optycw.editAccCont();
        optycw.NewContCancel();
        optycw.SaveContact();
        optycw.getEditAccContRole();
        optycw.deleteAccCont();
        optycw.contractentiti();
        optycw.handleContinue();
        Test.StopTest();
    }
    
    @IsTest static void Test_Onica(){
       
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
        User u = [Select Id,Region__c from user where isActive=:true  Limit 1];
        Opportunity opt = new Opportunity(Support_Offers_Pitched__c='Security',AcquisitionId__c='123ght',Technical_Owner__c=u.id,Amount=100,Onica_BU_Practice__c='EE',Onica_Practice_Lead__c='Brandon Pierce',Onica_LA_Date_scoping_meeting_was_held__c=System.today(),RecordTypeId =opptyRecordTypeId,Onica_Type__c='EE',Type='AWS',DDI__c='123456',Was_a_Partner_Involved__c='No',Why_Did_We_Win__c='Contract negotiations',Name='Test Opport2',
                                          AccountId=a.Id,Account__c=ac.id,StageName='Stage 1 - Planning & Identification',
                                          CloseDate=System.today().addDays(15));
        List<Opportunity> li=new List<Opportunity>();
        li.add(opt);
        insert li;
        AccountContactRelation acr=[Select id,roles,Contactid from AccountContactRelation where AccountId =:ac.id];
        acr.Roles='Billing; Primary Contact';
        Update acr;
        Contact cc=[Select id,mailingpostalcode,Mailingcity,MailingStreet,Mailingcountry,mailingstate from contact where id =:acr.contactid];
        cc.mailingpostalcode='2324';cc.Mailingcity='Test';cc.MailingStreet='Test';cc.Mailingcountry='United States';cc.mailingstate='California';
        update cc;
        
        ApexPages.currentPage().getParameters().put('id', opt.Id); 
        
        OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
        
        Test.StartTest();       
        optycw.saveAndNextUs1();
        optycw.saveAndNextUs2();
        //opt.CAC_Integration_Status__c='Success';
        //opt.MuleSoft_Acknowledge__c=True;
        update opt;
        optycw.saveAndNextUs3();
        optycw.saveAndNextUs4();
        optycw.saveandnextUS5();
        optycw.save();
        optycw.updateWhyDidWeWin();
        optycw.checkVal();
        optycw.RSCloudContinue();
        optycw.NewContRole();
        optycw.NewContWithRole();
        optycw.editAccCont();
        optycw.NewContCancel();
        optycw.SaveContact();
        optycw.getEditAccContRole();
        optycw.deleteAccCont();
        optycw.contractentiti();
        optycw.handleContinue();
        
        Test.StopTest();
    }
    
    @IsTest static void TestAllMethods(){
        
        Id devRecordTypeId3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        Id condevRecordTypeId3 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        Id opptyRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('US_Cloud').getRecordTypeId();
        Id opptyGovtRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Government').getRecordTypeId();
        
        Contracting_Entity__c ce=new Contracting_Entity__c(Name='test Onica');
        insert ce;
        Account a = new Account(RecordTypeId =devRecordTypeId3,Type='Prospect',Name='Onica Test Acc2',BillingCountry='Australia',ShippingCountry='Japan',Partner_Account_Status__c='Approved',Contracting_Entity__c=ce.id);
        insert a; 
        List<Account> acclist = new List<Account>();
        
        Account ac = new Account(RecordTypeId =devRecordTypeId,Name='Onica Test C2',Company_Name__c=a.Id,DDI__c='123456',Contracting_Entity__c=ce.id,BillingCountry='Japan', ShippingCountry='Japan');
        acclist.add(ac);
        Account acc = new Account(RecordTypeId =devRecordTypeId,Name='Onica Test',Company_Name__c=a.Id,DDI__c='12345',Contracting_Entity__c=ce.id,BillingCountry='Japan', ShippingCountry='Japan',Type='Cloud Customer');
        acclist.add(acc);
        
        Account accd = new Account(RecordTypeId =devRecordTypeId,Name='Acc testing',Company_Name__c=a.Id,DDI__c='12345678',Contracting_Entity__c=ce.id,BillingCountry='Japan', ShippingCountry='Japan',Type='Prospect');
        acclist.add(accd);
        
        Account acced = new Account(RecordTypeId =devRecordTypeId,Name='Acct testing',Company_Name__c=a.Id,Contracting_Entity__c=ce.id,BillingCountry='Japan', ShippingCountry='Japan',Type='Prospect');
        acclist.add(acced);
        
        insert acclist;
        
        Contact c = new Contact(RecordTypeId =condevRecordTypeId3,Email='Test@gmail.com',Phone='098900000',firstname='Test Contact',LastName='Test Last',AccountId=a.id,mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California');
        insert c;
        User u = [Select Id,Region__c from user where isActive=:true  Limit 1];
        
        Opportunity opt = new Opportunity(Support_Offers_Pitched__c='Security',AcquisitionId__c='123ght',Technical_Owner__c=u.id,Amount=100,Onica_BU_Practice__c='EE',Onica_Practice_Lead__c='Brandon Pierce',Onica_LA_Date_scoping_meeting_was_held__c=System.today(),RecordTypeId =opptyRecordTypeId,Onica_Type__c='EE',Type='AWS',DDI__c='123456',Was_a_Partner_Involved__c='No',Why_Did_We_Win__c='Contract negotiations',Name='Test Opport2',
                                          AccountId=a.Id,Account__c=ac.id,StageName='Stage 1 - Planning & Identification',
                                          CloseDate=System.today().addDays(15));
        
        Opportunity govtOpt = new Opportunity(Support_Offers_Pitched__c='Security',AcquisitionId__c='123GOVT',Technical_Owner__c=u.id,Amount=100,RecordTypeId =opptyGovtRecordTypeId,Type='AWS',Was_a_Partner_Involved__c='No',Why_Did_We_Win__c='Contract negotiations',Name='Test Opport2',
                                          AccountId=a.Id,Account__c=acc.id,StageName='Stage 1 - Planning & Identification',
                                          CloseDate=System.today().addDays(15));
        
        Opportunity usOpt = new Opportunity(Support_Offers_Pitched__c='Security',AcquisitionId__c='123US',Technical_Owner__c=u.id,Amount=100,RecordTypeId =opptyRecordTypeId,Type='ObjectRocket',Was_a_Partner_Involved__c='No',Why_Did_We_Win__c='Contract negotiations',Name='Test Opport2',
                                              AccountId=a.Id,Account__c=accd.id,StageName='Stage 1 - Planning & Identification',
                                              CloseDate=System.today().addDays(15));
        
        Opportunity recOpt = new Opportunity(Support_Offers_Pitched__c='Security',AcquisitionId__c='123U',Technical_Owner__c=u.id,Amount=100,RecordTypeId =opptyRecordTypeId,Type='AWS',Was_a_Partner_Involved__c='No',Why_Did_We_Win__c='Contract negotiations',Name='Test Oppt2',
                                            AccountId=a.Id,Account__c=acced.id,StageName='Stage 1 - Planning & Identification',
                                            CloseDate=System.today().addDays(15));
        
        List<Opportunity> li=new List<Opportunity>();
        li.add(opt);
        li.add(govtOpt);
        li.add(usOpt);
        li.add(recOpt);
        insert li; 
        
        Quote__c qut = new Quote__c();
        qut.Name = 'New Quote';
        qut.Opportunity__c = opt.Id;
        qut.CurrencyIsoCode = 'USD';
        insert qut;
        
        Case cs = new Case();
        cs.AccountId = a.Id;
        cs.Account__c = ac.Id;
        cs.Opportunity_Name__c = opt.Id;
        cs.Origin = 'Email';
        cs.Status ='1-New';
        cs.Type='Problem';
        insert cs;
        
        AccountContactRelation acr=[Select id,roles,Contactid ,AccountId from AccountContactRelation where AccountId =:ac.id];
        ApexPages.currentPage().getParameters().put('id', govtOpt.Id); 
        OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
        optycw.AccContRole = acr;
        optycw.primaryQuote = qut;
        optycw.NewContRole();
        optycw.SaveContact();
        optycw.StrNewCont = false;
        optycw.StrNewContRole = true;
        optycw.SaveContact();
        optycw.PrimaryQuoteUpdate();
        optycw.spin();
        optycw.copyAccountDDitoOpty();
        OpportunityCloseWonWizardController.updateCase(a,opt,ac);
        OpportunityCloseWonWizardController.updateCase(a,null,ac);
    }
    
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
    
    @isTest static void closeWonSaveTest(){
        
         Id devRecordTypeId3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        Id condevRecordTypeId3 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        Id opptyGovtRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Government').getRecordTypeId();
        
        Contracting_Entity__c ce=new Contracting_Entity__c(Name='test Onica');
        insert ce;
        Account a = new Account(RecordTypeId =devRecordTypeId3,Type='Prospect',Name='Onica Test Acc2',BillingCountry='Australia',ShippingCountry='Japan',Partner_Account_Status__c='Approved',Contracting_Entity__c=ce.id);
        insert a;       
        Account accd = new Account(RecordTypeId =devRecordTypeId,Name='Acc testing',Company_Name__c=a.Id,Contracting_Entity__c=ce.id,BillingCountry='Japan', ShippingCountry='Japan',Type='Prospect');
        insert accd;
        
        Contact c = new Contact(RecordTypeId =condevRecordTypeId3,Email='Test@gmail.com',Phone='098900000',firstname='Test Contact',LastName='Test Last',AccountId=a.id,mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California');
        insert c;
        User u = [Select Id,Region__c from user where isActive=:true  Limit 1];
        
        Opportunity usOpt = new Opportunity(Support_Offers_Pitched__c='Security',AcquisitionId__c='123US',Technical_Owner__c=u.id,Amount=100,RecordTypeId =opptyGovtRecordTypeId,Type='AWS',Was_a_Partner_Involved__c='No',Why_Did_We_Win__c='Contract negotiations',Name='Test Opport2',
                                              AccountId=a.Id,Account__c=accd.id,StageName='Stage 1 - Planning & Identification',
                                              CloseDate=System.today().addDays(15));
        insert usOpt; 
        
        AccountContactRelation acr=[Select id,roles,Contactid ,AccountId from AccountContactRelation where AccountId =:accd.id];
        ApexPages.currentPage().getParameters().put('id', usOpt.Id); 
        
        OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
        optycw.isCACEnable = true;
        optycw.opportunity.RecordType.Name = 'Government';
        optycw.accDDI = null;
        optycw.save();
    }
    
}