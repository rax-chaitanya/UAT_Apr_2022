@isTest(seeAllData = true)
public class OpportunityCloseWonWizardControllerTest2 {

        @IsTest static void withaccounttest(){

Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a;
        Account a1 = new Account(Name='Test Account',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a1;
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id,MailingCountry='India',Email='test.t@test.com',
                                MailingStreet='Whitefield',Phone='12345676',MailingCity='Bangalore',MailingPostalCode='560066',MailingState='Karnataka');
        
        Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,RecordTypeId = Label.Account_Prospect_RecordType_ID,BillingCountry='India',ShippingCountry='India');
        insert ac;
        Contact c1 = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id);
        insert c1; 
        Opportunity opty = new Opportunity(Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport',AccountId=a.Id,Account__c=ac.id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',QuotingSystem__c='Rackspace',Expected_Revenue_Start_Date__c=System.today(),CloseDate=System.today().addDays(15),Cloud_Contract_Type__c='Regular',Category__c='Downgrade');
        insert opty;
        ApexPages.currentPage().getParameters().put('id', opty.Id); 
      
        Accountcontactrelation acr= new Accountcontactrelation(Contactid=c1.id,Roles='Technical',Accountid=a1.id);
        insert acr;
        OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
          optycw.saveAndNextUs5();
        }
public static testmethod void CompanyProfileControllerTest(){ 
        Test.startTest();
      
        Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
        Id conRID= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        Account a1 = new Account(DDI__c='12345655',Contract_Type__c='Agent Channel Agreement',Partner_Account_Status__c='Approved',Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =system.today(),Partner_Level__c='Reseller',RecordTypeId= accRID,Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert a1;
        Contact c = new Contact(RecordTypeId= conRID,firstname='Test Contact',LastName='Test Last',AccountId=a1.id,Email = System.now().millisecond() + 'test@test.com');
        insert c;
        a1.Primary_Member__c = c.Id;
        update a1;
     
        Opportunity opty = new Opportunity(Partner_Company__c=a1.Id,Category__c='New Logo',Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport',DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15));
        insert opty;
         ApexPages.currentPage().getParameters().put('id', opty.Id); 
        
        OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
        optycw.save();
        Test.StopTest();
        }
         @IsTest static void withaccounttest2(){

Account a = new Account(Name='Test Account1234',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a;
        Account a1 = new Account(Name='Test Account',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a1;
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id,MailingCountry='India',Email='test.t@test.com',
                                MailingStreet='Whitefield',Phone='12345676',MailingCity='Bangalore',MailingPostalCode='560066',MailingState='Karnataka');
        
        Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,RecordTypeId = Label.Account_Prospect_RecordType_ID,BillingCountry='India',ShippingCountry='India',DDI__c='12345655');
        insert ac;
        Contact c1 = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id);
        insert c1; 
        Opportunity opty = new Opportunity(Was_a_Partner_Involved__c='Yes',Type='Professional Services',Name='Test Opport',AccountId=a.Id,Account__c=ac.id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',QuotingSystem__c='Rackspace',Expected_Revenue_Start_Date__c=System.today(),CloseDate=System.today().addDays(15),Cloud_Contract_Type__c='Regular',Category__c='Downgrade');
        insert opty;
        ApexPages.currentPage().getParameters().put('id', opty.Id); 
      
        Accountcontactrelation acr= new Accountcontactrelation(Contactid=c1.id,Roles='Billing',Accountid=a1.id);
        insert acr;
        OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
          optycw.pageNumber =2;
          optycw.saveandnextUS3();
          optycw.getEditAccContRole();
          optycw.RSCloudContinue();
        }
         @IsTest static void withaccounttest2nocontact(){

Account a = new Account(Name='Test Account1234',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a;
        Account a1 = new Account(Name='Test Account',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a1;
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id,MailingCountry='India',Email='test.t@test.com',
                                MailingStreet='Whitefield',Phone='12345676',MailingCity='Bangalore',MailingPostalCode='560066',MailingState='Karnataka');
        
        Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,RecordTypeId = Label.Account_Prospect_RecordType_ID,BillingCountry='India',ShippingCountry='India',DDI__c='12345655');
        insert ac;
        //Contact c1 = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id);
        //insert c1; 
        Opportunity opty = new Opportunity(Was_a_Partner_Involved__c='Yes',Type='Professional Services',Name='Test Opport',AccountId=a.Id,Account__c=ac.id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',QuotingSystem__c='Rackspace',Expected_Revenue_Start_Date__c=System.today(),CloseDate=System.today().addDays(15),Cloud_Contract_Type__c='Regular',Category__c='Downgrade');
        insert opty;
        ApexPages.currentPage().getParameters().put('id', opty.Id); 
      
       // Accountcontactrelation acr= new Accountcontactrelation(Contactid=c1.id,Roles='Billing',Accountid=a1.id);
       // insert acr;
        OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
          optycw.pageNumber =2;
          optycw.saveandnextUS3();
          optycw.getEditAccContRole();
          optycw.RSCloudContinue();
          optycw.goToOpp();
          optycw.goToPage();
          try{
          optycw.setVariables(opty.id,a1.id);
          }catch(Exception e){}
        }
}