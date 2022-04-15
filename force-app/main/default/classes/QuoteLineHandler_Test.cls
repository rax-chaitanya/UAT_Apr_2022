@isTest
public class QuoteLineHandler_Test {
    
    @TestSetUp
    static void setDataUp(){
        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
        insert fieldMappings;  
        
        TestClassUtility.setTestSetupData();
    }
    
    @isTest
    static void qlHandlerTest(){
        Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert a;
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id);
        insert c;
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,ShippingCountry='India',RecordTypeId =devRecordTypeId);
        insert ac;
        Opportunity opty = new Opportunity(Name='Test Opport',Type='Azure',AccountId=a.Id,Account__c=ac.id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15),OwnerId=UserInfo.getUserId());
        insert opty;
        Test.StartTest(); 
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
        update ql;
        
        Quote_Line__c ql4 = new Quote_Line__c(Name='Test QL',Opportunity_Quote__c=opty.Id,Quote__c=q.id,FocusArea__c=ofa.id,Workload_Platform__c = 'OpenStack Public');
        insert ql4;
        // ql4.Is_Primary__c=false;
        update ql4;
        delete ql4;
        
        
        
        delete ql;
        Test.StopTest();
        //undelete ql;
        
        /* insert new Quote_Line__c(Name='Test QL1',Opportunity_Quote__c=opty.Id,Quote__c=q.id,
FocusArea__c=ofa.id,Workload_Platform__c = 'Fanatical Support for Microsoft Azure');
insert new Quote_Line__c(Name='Test QL2',Opportunity_Quote__c=opty.Id,Quote__c=q.id,
FocusArea__c=ofa.id,Workload_Platform__c = 'OpenStack Private');
insert new Quote_Line__c(Name='Test QL3',Opportunity_Quote__c=opty.Id,Quote__c=q.id,
FocusArea__c=ofa.id,Workload_Platform__c = 'OpenStack Public');
insert new Quote_Line__c(Name='Test QL4',Opportunity_Quote__c=opty.Id,Quote__c=q.id,
FocusArea__c=ofa.id);
Test.StartTest();
update q;
delete q;
undelete q;*/
        
        
    }
    /*  @isTest
static void qlHandlerTest2(){
Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
insert a;
Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id);
insert c;
Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,ShippingCountry='India',RecordTypeId =devRecordTypeId);
insert ac;
Opportunity opty = new Opportunity(Name='Test Opport',Type='Azure',AccountId=a.Id,Account__c=ac.id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15),OwnerId=UserInfo.getUserId());
insert opty;

Quote__c q = new Quote__c(Name='Test Quote',opportunity__c  = opty.id,Is_Primary__c=true);
insert q;

Opp_FocusArea__c ofa = new Opp_FocusArea__c(Name='Test OFA',Opportunity__c=opty.id);
insert ofa;



FocusAreaMapping__c fam2=new FocusAreaMapping__c();
fam2.Name='Microsoft Public';
fam2.OppFocusArea__c='MSFT Public';
insert fam2;


Quote_Line__c ql = new Quote_Line__c(Name='Test QL',Opportunity_Quote__c=opty.Id,Quote__c=q.id,FocusArea__c=ofa.id,Workload_Platform__c = 'Fanatical Support for Microsoft Azure');
insert ql;

update ql;

delete ql;

//undelete ql;

insert new Quote_Line__c(Name='Test QL1',Opportunity_Quote__c=opty.Id,Quote__c=q.id,
FocusArea__c=ofa.id,Workload_Platform__c = 'Fanatical Support for Microsoft Azure');
insert new Quote_Line__c(Name='Test QL2',Opportunity_Quote__c=opty.Id,Quote__c=q.id,
FocusArea__c=ofa.id,Workload_Platform__c = 'OpenStack Private');
insert new Quote_Line__c(Name='Test QL3',Opportunity_Quote__c=opty.Id,Quote__c=q.id,
FocusArea__c=ofa.id,Workload_Platform__c = 'OpenStack Public');
insert new Quote_Line__c(Name='Test QL4',Opportunity_Quote__c=opty.Id,Quote__c=q.id,
FocusArea__c=ofa.id);

update q;
delete q;
undelete q;
}
@isTest
static void qlHandlerTest3(){
Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
insert a;
Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id);
insert c;
Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,ShippingCountry='India',RecordTypeId =devRecordTypeId);
insert ac;
Opportunity opty = new Opportunity(Name='Test Opport',Type='Azure',AccountId=a.Id,Account__c=ac.id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15),OwnerId=UserInfo.getUserId());
insert opty;

Quote__c q = new Quote__c(Name='Test Quote',opportunity__c  = opty.id,Is_Primary__c=true);
insert q;

Opp_FocusArea__c ofa = new Opp_FocusArea__c(Name='Test OFA',Opportunity__c=opty.id);
insert ofa;
FocusAreaMapping__c fam=new FocusAreaMapping__c();
fam.Name='OpenStack Private';
fam.OppFocusArea__c='OpenStack Private';
insert fam;


FocusAreaMapping__c fam3=new FocusAreaMapping__c();
fam3.Name='Microsoft Private';
fam3.OppFocusArea__c='MSFT Private';
insert fam3;


Quote_Line__c ql = new Quote_Line__c(Name='Test QL',Opportunity_Quote__c=opty.Id,Quote__c=q.id,FocusArea__c=ofa.id,Workload_Platform__c = 'OpenStack Private');
insert ql;

update ql;

delete ql;

//undelete ql;

insert new Quote_Line__c(Name='Test QL1',Opportunity_Quote__c=opty.Id,Quote__c=q.id,
FocusArea__c=ofa.id,Workload_Platform__c = 'Fanatical Support for Microsoft Azure');
insert new Quote_Line__c(Name='Test QL2',Opportunity_Quote__c=opty.Id,Quote__c=q.id,
FocusArea__c=ofa.id,Workload_Platform__c = 'OpenStack Private');
insert new Quote_Line__c(Name='Test QL3',Opportunity_Quote__c=opty.Id,Quote__c=q.id,
FocusArea__c=ofa.id,Workload_Platform__c = 'OpenStack Public');
insert new Quote_Line__c(Name='Test QL4',Opportunity_Quote__c=opty.Id,Quote__c=q.id,
FocusArea__c=ofa.id);

update q;
delete q;
undelete q;
}
@isTest
static void qlHandlerTest4(){
Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
insert a;
Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id);
insert c;
Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,ShippingCountry='India',RecordTypeId =devRecordTypeId);
insert ac;
Opportunity opty = new Opportunity(Name='Test Opport',Type='Azure',AccountId=a.Id,Account__c=ac.id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15),OwnerId=UserInfo.getUserId());
insert opty;

Quote__c q = new Quote__c(Name='Test Quote',opportunity__c  = opty.id,Is_Primary__c=true);
insert q;

Opp_FocusArea__c ofa = new Opp_FocusArea__c(Name='Test OFA',Opportunity__c=opty.id);
insert ofa;
FocusAreaMapping__c fam=new FocusAreaMapping__c();
fam.Name='Microsoft Private';
fam.OppFocusArea__c='MSFT Private';
insert fam;


FocusAreaMapping__c fam4=new FocusAreaMapping__c();
fam4.Name='OpenStack Public';
fam4.OppFocusArea__c='OpenStack Public';
insert fam4;

Quote_Line__c ql = new Quote_Line__c(Name='Test QL',Opportunity_Quote__c=opty.Id,Quote__c=q.id,FocusArea__c=ofa.id,Workload_Platform__c = 'OpenStack Public');
insert ql;

update ql;

delete ql;

//undelete ql;

insert new Quote_Line__c(Name='Test QL1',Opportunity_Quote__c=opty.Id,Quote__c=q.id,
FocusArea__c=ofa.id,Workload_Platform__c = 'Fanatical Support for Microsoft Azure');
insert new Quote_Line__c(Name='Test QL2',Opportunity_Quote__c=opty.Id,Quote__c=q.id,
FocusArea__c=ofa.id,Workload_Platform__c = 'OpenStack Private');
insert new Quote_Line__c(Name='Test QL3',Opportunity_Quote__c=opty.Id,Quote__c=q.id,
FocusArea__c=ofa.id,Workload_Platform__c = 'OpenStack Public');
insert new Quote_Line__c(Name='Test QL4',Opportunity_Quote__c=opty.Id,Quote__c=q.id,
FocusArea__c=ofa.id);

update q;
delete q;
undelete q;
}*/
}