@isTest
public class PartnerRankingController_Test{
    
    @TestSetUp
    static void setDataUp(){
        Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId(); 
        Id conRID= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        List<OrgConstants__c> lrecords = new List<OrgConstants__c>();
        lrecords.add(new OrgConstants__c(Name='Prod Org ID',Prod_Value__c='00D61000000J4OKEA0',Non_Prod_Value__c='00D61000000J4OKEA0'));
        lrecords.add(new OrgConstants__c(Name='Company Approval Process ID',Prod_Value__c='04a4C0000008PNQ',Non_Prod_Value__c='04a4C0000008PNQ'));
        lrecords.add(new OrgConstants__c(Name = '#salesforce-errors', Prod_Value__c = 'https://hooks.slack.com/services/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', Non_Prod_Value__C = 'https://hooks.slack.com/services/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'));              
        lrecords.add(new OrgConstants__c(Name='System Administrator ID',Prod_Value__c='00561000001ziVf',Non_Prod_Value__c='00561000001ziVf'));
        Insert lrecords;
        List<Trigger_Manager__c> tms = new List<Trigger_Manager__c>();
        tms.add( new Trigger_Manager__c(name='ContactTgr',Is_Active__c=false));
        tms.add( new Trigger_Manager__c(name='OpportunityTgr',Is_Active__c=false)); 
        tms.add( new Trigger_Manager__c(name='OpportunitySplitTgr',Is_Active__c=false)); 
        insert tms;
        Account acc = new Account(Name='Test Partner',BillingCountry='India',ShippingCountry='India', Partner_Account_Status__c = 'Approved', RecordTypeId = accRID);
        insert acc;      
        Account a1 = new Account(ParentId= acc.Id,Partner_Account_Status__c ='Approved', Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =system.today(),Partner_Level__c='Master Agent',RecordTypeId= accRID,Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert a1;
        Contact c = new Contact(firstname='Test',lastname='Case',Email='case.test@rax.com',recordtypeId=conRID,AccountId=a1.Id);
        insert c;
        // a1.Primary_Member__c = c.Id;
        update a1;
        Id RtId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Government').getRecordTypeId();
        Opportunity opp = new Opportunity(RecordTypeId=RtId,Name='Test Opportunity',Partner_Company__c=acc.id, DDI__c='12345655', StageName='Closed Won', CloseDate=System.today(), Was_a_Partner_Involved__c='Yes', Type='ObjectRocket',Exchange_Fee__c=50);
        insert opp; 
    }
     static testmethod void getchartDataTest1(){       
          Test.startTest();
            PartnerRankingController pRanking = new PartnerRankingController();
            pRanking.strDtFilter = 'Year';
            pRanking.PartnerName = 'Test Partner';
            pRanking.getchartData();
        Test.stopTest();
        
     }
     static testmethod void getchartDataTest2(){          
        Test.startTest();
            PartnerRankingController pRanking = new PartnerRankingController();
            pRanking.strDtFilter = 'Quarter';
            pRanking.PartnerName = 'Test Partner';
            pRanking.getchartData();
        PartnerRankingController.data d = new PartnerRankingController.data('TestData', 12,'Title');
        Test.stopTest();
        
     }
}