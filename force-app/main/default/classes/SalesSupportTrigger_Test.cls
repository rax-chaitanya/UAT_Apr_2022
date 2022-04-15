@isTest
public class SalesSupportTrigger_Test {

    @isTest
    public static void testSalesSupportTrigger(){
        insert new Trigger_Manager__c(name='ContactTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='OpportunitySplitTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='SalesSupportTgr',Is_Active__c=true);
         insert new Trigger_Manager__c(name='DealCenterTgr',Is_Active__c=true);
         insert new Trigger_Manager__c(name='AcrTgr',Is_Active__c=true);
        
       Account a = new Account(Name='Test Account123',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
       insert a;
       
        Account ac = new Account(Name='Test Account123',Company_Name__c=a.Id,RecordTypeId = Label.Account_Prospect_RecordType_ID);
       insert ac;
       
       
         Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id);
        insert c;
        //Accounts__c ac = new Accounts__c(Name='Test C Account',Company_Name__c=a.Id,Shipping_Country__c='India');
        //insert ac;
        Opportunity opty = new Opportunity(Name='Test Opport',Type='Azure',DDI__c='12345654',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15));
        insert opty;
        
        Sales_Support_Portfolio__c ssp = new Sales_Support_Portfolio__c(Opportunity__c=opty.id);
        insert ssp;
        
        update ssp;
        delete ssp;
        undelete ssp;
        
        Deal_Center_Request__c dc = new Deal_Center_Request__c(Due_Date_to_Customer__c=System.today().addDays(10),
                                                              Opportunity__c=opty.Id,Who_Would_Sign_the_Rackspace_HSA__c='Ultimate Customer',NDA_Status__c='Yes',
                                                              What_is_business_case_for_engagement__c='Testing the details',Request_Type__c='Application');
        insert dc;
        update dc;
        delete dc;
        undelete dc;
        
    }
}