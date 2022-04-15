@isTest
public class DeleteOppQuoteLines_Test {
    
    @TestSetUp
    static void setDataUp(){
        
        TestClassUtility.setTestSetupData();
    }
    
 
    @isTest
    static void DeleteHandlerTest(){
         User u=[Select id from User where id=:Label.FMW_API_User];
        
        System.runAs(u)
        {
        
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId(); 
        Id rtAccId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account').getRecordTypeId(); 
        Id rtOPPId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('INTL Cloud').getRecordTypeId();
       // Id rtConId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Government').getRecordTypeId();
        
        Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId =rtId);
        insert a;
         Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id);
        insert c;
        //Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,ShippingCountry='India',RecordTypeId =rtAccId);
        insert ac;
        
        
        Opportunity opty = new Opportunity(RecordTypeId=rtOPPId,Name='Test Opport',Type='Azure',AccountId=a.Id,Account__c=ac.id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15),OwnerId=UserInfo.getUserId());
        insert opty;
        
        
        Quote__c q = new Quote__c(Name='Test Quote',opportunity__c  = opty.id,Is_Primary__c=true);
        insert q;
        
        Opp_FocusArea__c ofa = new Opp_FocusArea__c(Name='Test OFA',Opportunity__c=opty.id);
        insert ofa;
        FocusAreaMapping__c fam=new FocusAreaMapping__c();
        fam.Name='Microsoft Private';
        fam.OppFocusArea__c='MSFT Private';
        insert fam;
        
       
        
        Quote_Line__c ql = new Quote_Line__c(Name='Test QL',Opportunity_Quote__c=opty.Id,Quote__c=q.id,FocusArea__c=ofa.id,Workload_Platform__c = 'Microsoft Private');
        insert ql;        
        
        FocusAreaMapping__c fam3=new FocusAreaMapping__c();
        fam3.Name='OpenStack Private';
        fam3.OppFocusArea__c='MSFT Private';
        insert fam3;
        
        FocusAreaMapping__c fam2=new FocusAreaMapping__c();
        fam2.Name='Microsoft Public';
        fam2.OppFocusArea__c='MSFT Public';
        insert fam2;
       
        
        Quote_Line__c ql2 = new Quote_Line__c(Name='Test QL',Opportunity_Quote__c=opty.Id,Quote__c=q.id,FocusArea__c=ofa.id,Workload_Platform__c = 'Fanatical Support for Microsoft Azure');
        insert ql2;
       
        
        Quote_Line__c ql3 = new Quote_Line__c(Name='Test QL',Opportunity_Quote__c=opty.Id,Quote__c=q.id,FocusArea__c=ofa.id,Workload_Platform__c = 'OpenStack Private');
        insert ql3;
        
        FocusAreaMapping__c fam4=new FocusAreaMapping__c();
        fam4.Name='OpenStack Public';
        fam4.OppFocusArea__c='OpenStack Public';
        insert fam4;
         //update ql;
           
        Quote_Line__c ql4 = new Quote_Line__c(Name='Test QL',Opportunity_Quote__c=opty.Id,Quote__c=q.id,FocusArea__c=ofa.id,Workload_Platform__c = 'OpenStack Public');
        insert ql4;
        
       // Opportunity opt = [Select id,Delete_QL__c from Opportunity where id =: opty.id]; 
        opty.Delete_QL__c='All';
        Test.StartTest();
        ExternalSharingHelperController.POPULATE_OPPTY_RECORD_TYPE = true;
        OpportunityHandler.stopRecursion = 'Before Update';
        Update opty;
        
        
  /*      opty.Delete_QL__c='All';
        ExternalSharingHelperController.POPULATE_OPPTY_RECORD_TYPE = true;
        Update opty; */
        
        Test.StopTest();
        
    }
    }
        @isTest
    static void DeleteHandlerTest2(){
         User u=[Select id from User where id=:Label.FMW_API_User];
        
        System.runAs(u)
        {
        
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId(); 
        Id rtAccId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account').getRecordTypeId(); 
        Id rtOPPId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('INTL Cloud').getRecordTypeId();
       // Id rtConId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Government').getRecordTypeId();
        
        Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId =rtId);
        insert a;
         Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id);
        insert c;
        //Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,ShippingCountry='India',RecordTypeId =rtAccId);
        insert ac;
        
        
        Opportunity opty = new Opportunity(RecordTypeId=rtOPPId,Name='Test Opport',Type='Azure',AccountId=a.Id,Account__c=ac.id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15),OwnerId=UserInfo.getUserId());
        insert opty;
        
        
        Quote__c q = new Quote__c(Name='Test Quote',opportunity__c  = opty.id,Is_Primary__c=true);
        insert q;
        
        Opp_FocusArea__c ofa = new Opp_FocusArea__c(Name='Test OFA',Opportunity__c=opty.id);
        insert ofa;
        FocusAreaMapping__c fam=new FocusAreaMapping__c();
        fam.Name='Microsoft Private';
        fam.OppFocusArea__c='MSFT Private';
        insert fam;
        
       
        
        Quote_Line__c ql = new Quote_Line__c(Name='Test QL',Opportunity_Quote__c=opty.Id,Quote__c=q.id,FocusArea__c=ofa.id,Workload_Platform__c = 'Microsoft Private');
        insert ql;        
        
        FocusAreaMapping__c fam3=new FocusAreaMapping__c();
        fam3.Name='OpenStack Private';
        fam3.OppFocusArea__c='MSFT Private';
        insert fam3;
        
        FocusAreaMapping__c fam2=new FocusAreaMapping__c();
        fam2.Name='Microsoft Public';
        fam2.OppFocusArea__c='MSFT Public';
        insert fam2;
       
        
        Quote_Line__c ql2 = new Quote_Line__c(Name='Test QL',Opportunity_Quote__c=opty.Id,Quote__c=q.id,FocusArea__c=ofa.id,Workload_Platform__c = 'Fanatical Support for Microsoft Azure');
        insert ql2;
       
        
        Quote_Line__c ql3 = new Quote_Line__c(Name='Test QL',Opportunity_Quote__c=opty.Id,Quote__c=q.id,FocusArea__c=ofa.id,Workload_Platform__c = 'OpenStack Private');
        insert ql3;
        
        FocusAreaMapping__c fam4=new FocusAreaMapping__c();
        fam4.Name='OpenStack Public';
        fam4.OppFocusArea__c='OpenStack Public';
        insert fam4;
         //update ql;
           
        Quote_Line__c ql4 = new Quote_Line__c(Name='Test QL',Opportunity_Quote__c=opty.Id,Quote__c=q.id,FocusArea__c=ofa.id,Workload_Platform__c = 'OpenStack Public');
        insert ql4;
        
       // Opportunity opt = [Select id,Delete_QL__c from Opportunity where id =: opty.id]; 
        opty.Delete_QL__c='Migrate';
        Test.StartTest();
        ExternalSharingHelperController.POPULATE_OPPTY_RECORD_TYPE = true;
        OpportunityHandler.stopRecursion = 'Before Update';
        Update opty;
        
        
  /*      opty.Delete_QL__c='All';
        ExternalSharingHelperController.POPULATE_OPPTY_RECORD_TYPE = true;
        Update opty; */
        
        Test.StopTest();
        
    }
    }
       @isTest
    static void DeleteHandlerTest3(){
         User u=[Select id from User where id=:Label.FMW_API_User];
        
        System.runAs(u)
        {
        
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId(); 
        Id rtAccId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account').getRecordTypeId(); 
        Id rtOPPId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('INTL Cloud').getRecordTypeId();
       // Id rtConId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Government').getRecordTypeId();
        
        Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId =rtId);
        insert a;
         Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id);
        insert c;
        //Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,ShippingCountry='India',RecordTypeId =rtAccId);
        insert ac;
        
        
        Opportunity opty = new Opportunity(RecordTypeId=rtOPPId,Name='Test Opport',Type='Azure',AccountId=a.Id,Account__c=ac.id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15),OwnerId=UserInfo.getUserId());
        insert opty;
        
        
        Quote__c q = new Quote__c(Name='Test Quote',opportunity__c  = opty.id,Is_Primary__c=true);
        insert q;
        
        Opp_FocusArea__c ofa = new Opp_FocusArea__c(Name='Test OFA',Opportunity__c=opty.id);
        insert ofa;
        FocusAreaMapping__c fam=new FocusAreaMapping__c();
        fam.Name='Microsoft Private';
        fam.OppFocusArea__c='MSFT Private';
        insert fam;
        
       
        
        Quote_Line__c ql = new Quote_Line__c(Name='Test QL',Opportunity_Quote__c=opty.Id,Quote__c=q.id,FocusArea__c=ofa.id,Workload_Platform__c = 'Microsoft Private');
        insert ql;        
        
        FocusAreaMapping__c fam3=new FocusAreaMapping__c();
        fam3.Name='OpenStack Private';
        fam3.OppFocusArea__c='MSFT Private';
        insert fam3;
        
        FocusAreaMapping__c fam2=new FocusAreaMapping__c();
        fam2.Name='Microsoft Public';
        fam2.OppFocusArea__c='MSFT Public';
        insert fam2;
       
        
        Quote_Line__c ql2 = new Quote_Line__c(Name='Test QL',Opportunity_Quote__c=opty.Id,Quote__c=q.id,FocusArea__c=ofa.id,Workload_Platform__c = 'Fanatical Support for Microsoft Azure');
        insert ql2;
       
        
        Quote_Line__c ql3 = new Quote_Line__c(Name='Test QL',Opportunity_Quote__c=opty.Id,Quote__c=q.id,FocusArea__c=ofa.id,Workload_Platform__c = 'OpenStack Private');
        insert ql3;
        
        FocusAreaMapping__c fam4=new FocusAreaMapping__c();
        fam4.Name='OpenStack Public';
        fam4.OppFocusArea__c='OpenStack Public';
        insert fam4;
         //update ql;
           
        Quote_Line__c ql4 = new Quote_Line__c(Name='Test QL',Opportunity_Quote__c=opty.Id,Quote__c=q.id,FocusArea__c=ofa.id,Workload_Platform__c = 'OpenStack Public');
        insert ql4;
        
       // Opportunity opt = [Select id,Delete_QL__c from Opportunity where id =: opty.id]; 
        opty.Delete_QL__c='Line_Item';
        Test.StartTest();
        ExternalSharingHelperController.POPULATE_OPPTY_RECORD_TYPE = true;
        OpportunityHandler.stopRecursion = 'Before Update';
        Update opty;
        
        
  /*      opty.Delete_QL__c='All';
        ExternalSharingHelperController.POPULATE_OPPTY_RECORD_TYPE = true;
        Update opty; */
        
        Test.StopTest();
        
    }
    }
 }