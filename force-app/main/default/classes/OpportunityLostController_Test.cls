@isTest(SeeAllData = true)
public class OpportunityLostController_Test {

    /*@TestSetUp static void setupTestData(){
        TestClassUtility.setTestSetupData();
    }*/
    @isTest
    static void testOpportunityLostNegative(){
         Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert a;
         Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id);
        insert c;
        Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id);
        insert ac;
        Opportunity opty = new Opportunity(Name='Test Opport',WHy_Did_We_Lose__c = 'Price', Type='Azure',Lost_Reason__c='Price',AccountId=a.Id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',Support_Offers_Pitched__c='Manage & Operate',CloseDate=System.today().addDays(15),OwnerId=UserInfo.getUserId());
        insert opty;
        opty.Support_Offers_Pitched__c='Manage & Operate';
            update opty;
        system.debug('$$$$$$$$$$$$$$$$$$'+opty.Support_Offers_Pitched__c);
        ApexPages.currentPage().getParameters().put('id', opty.Id);
        OpportunityLostController optylostController = new OpportunityLostController();
        
        PageReference p = optylostController.checkRequired();
        System.assert(p==null,true);
        
        List<String> errors = optylostController.getErrorMessages();
        System.assert(errors != null, true);
        optylostController.changeLostReason();
        optylostController.saveOpp();
    }
    
     @isTest
    static void testOpportunityLostPositive(){
         Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert a;
         Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id);
        insert c;
        Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id);
        insert ac;
        Opportunity opty = new Opportunity(Name='Test Opport',Type='Azure',Lost_Reason__c='Price',AccountId=a.Id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',Support_Offers_Pitched__c='Platform Essentials',CloseDate=System.today().addDays(15),OwnerId=UserInfo.getUserId());
        opty.Lost_Reason__c='Bid Declined';
        opty.Lost_Sub_Reason__c='Bandwidth Pricing';
        opty.Pain_Point__c='ServiceNow';
        opty.What_did_we_do_well__c='Pricing negotiations';
        opty.Competitors__c='In-house';
        insert opty;
        opty.Support_Offers_Pitched__c='Platform Essentials';
            update opty;
        system.debug('$$$$$$$$$$$$$$$$$$'+opty.Support_Offers_Pitched__c);
        ApexPages.currentPage().getParameters().put('id', opty.Id);
        OpportunityLostController optylostController = new OpportunityLostController();
        
        PageReference p = optylostController.checkRequired();
        System.assert(p==null,true);
       optylostController.changeLostReason();
        optylostController.saveOpp();
        optylostController.getOppNewComp();
        optylostController.getOppEditComp();
        optylostController.getOppNewComp();
        optylostController.getOpportunity();
        optylostController.NewCompetitor();
        optylostController.EditCompetitor();
        optylostController.SaveNewComp();
       // optylostController.Edit();
        optylostController.cancel();
    }
}