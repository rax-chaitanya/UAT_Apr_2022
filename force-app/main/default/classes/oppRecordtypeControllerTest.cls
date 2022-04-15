@isTest
public class oppRecordtypeControllerTest {
    
    @IsTest static void oppRecordtypeControllertestt(){
     Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a;
        Account a1 = new Account(Name='Test Account',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a1;
         Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,RecordTypeId = Label.Account_Prospect_RecordType_ID,BillingCountry='India',ShippingCountry='India');
        insert ac;
        Opportunity opty = new Opportunity(CloseDate=system.today(),Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport',AccountId=a.Id,Account__c=ac.id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',QuotingSystem__c='Rackspace');
        //insert opty;
        ////OpportunityCloseWonWizardController optycw = new OpportunityCloseWonWizardController();
        oppRecordtypeController.fetchRecordTypeValues();
        string lrtlabel='Government';
        oppRecordtypeController.getRecTypeId(lrtlabel);
        string lrtlabel2='Government_Company';
        try{
        oppRecordtypeController.getDetailsFromAcc(lrtlabel2);
        }catch(Exception e){}
    
    }
    }