@isTest(seeAllData = true)
public class EditFocusAreasControllerTest {

    @isTest
    static void testEditFocusArea(){
         string companyRecordTypeId =  Schema.sObjectType.account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
    
    string productAccountRecordTypeId =  Schema.sObjectType.account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
       Account cmpAc = new Account(Name='Comp account',RecordTypeId =companyRecordTypeId,BillingCountry='India',ShippingCountry='India',territory__c = 'ANZ');
        insert cmpAc ;
        
         Account a = new Account(Name='Test Account1234',RecordTypeId =productAccountRecordTypeId,BillingCountry='India',ShippingCountry='India',company_name__C = cmpAc.id);
        insert a;
        
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id);
        insert c;
        Opportunity opty = new Opportunity(Name='Test Opport',Type='Azure',accountid=cmpAc.id,Account__c=a.id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15));
        //Test.startTest();
        insert opty;
        //Test.stopTest();
        Opportunity ot= [select id from Opportunity where Name='Test Opport' limit 1];
        System.assert(ot.id!=null);
        Opp_FocusArea__c opf = new Opp_FocusArea__c(Name='Test Focus Area',Opportunity__c= opty.Id,Focus_Area_Percentage__c=100);
        insert opf;
        ApexPages.currentPage().getParameters().put('id', opf.id);
        ApexPages.StandardController stdController = new ApexPages.StandardController(opf);
        EditFocusAreasController ef = new EditFocusAreasController(stdController);
        ef.userClicked = 'save';
        PageReference p = ef.saveFAs();
        System.assert(p != null, true);
       ef.getTrue();
        ef.getFalse();
        ef.getDynamicPage();
        FrameWork f = new FrameWork();
        
        update opf;
        delete opf;
        undelete opf;
        delete opty;
    }
}