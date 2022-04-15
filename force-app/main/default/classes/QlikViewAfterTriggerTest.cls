@isTest
public class QlikViewAfterTriggerTest {
    
    @IsTest static void test1(){
    Account a1 = new Account(Name='Test Account',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Account_Prospect_RecordType_ID);
        insert a1;
   // Movers_Shakers_Details__c mv=new Movers_Shakers_Details__c();
   // mv.name='test';
    //mv.Account__c=a1.id;
    //mv.DDI__c='0909090';
    //insert mv;
    Movers_Shakers_Account__c msa=new Movers_Shakers_Account__c();
    //msa.name='test';
    msa.Account_Name__c='Test22';
    insert msa;
    
    }
    }