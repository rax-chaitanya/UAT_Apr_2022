/*
@Name : TestDP_CloneQuoteController
@Author : customersuccess@cloud62.com
@Date : 08-09-2013
@Description : Test class for CloneQuoteController class functionality.
*/
@isTest
public class TestDP_CloneQuoteController{
@testSetup static void testsetupData() {

    Test.startTest(); 
                
        TestDataFactory.getProdOrgIDSetting();       
        TestDataFactory.getOrgConstants();
        TestDataFactory.getTriggerManagers();
        TestDataFactory.getFeatureFlagSetting();
        
        Id govpaRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Government').getRecordTypeId(); 
        Id compgovRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Government Company').getRecordTypeId(); 
        Id oppgovRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Government').getRecordTypeId(); 
        Id rtId1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Government').getRecordTypeId(); 
        
        Pricebook2 pbk1 = new Pricebook2(Id = Test.getStandardPricebookId(),IsActive = true);
        Update pbk1;        
        /*DP_BillingSystem__c bs = getBillingSystem();        
        Account a = getAccount(bs,compgovRT);
        Account pa = getAccounts(a.id,govpaRT);
        Contact c = new Contact(firstname='Test',lastname='Case',Email='case.test@rax.com',recordtypeId=rtId1 );
        insert c;        
        DP_DataCenter__c dc = getDataCenter();
        DP_ProductLine__c pl = getProductLine();        
        Opportunity opp = getOpportunity(a.ID,pa.id,pl.ID,dc.ID, pbk1.Id,oppgovRT);
        Quote q = getQuote(opp.ID, pbk1.Id);  */      
        
     Test.stopTest();   
     
    }
    @isTest
    static void DP_cloneQuoteControllertest(){
        //Get Test Data.
       // TestClassUtility.setTestSetupData();
        
         Pricebook2 pbk1 = new Pricebook2(Id = Test.getStandardPricebookId(),IsActive = true);
        Update pbk1;  
        DP_DataCenter__c dc = getDataCenter();
        Product2 p = getProduct2(dc.ID);
        Product2 cprod = getProduct2(dc.ID);
        PricebookEntry pbe1 = [select id, name, isActive from PricebookEntry where Product2ID=:p.id limit 1];
        DP_Product_Compatibility__c pcam = new DP_Product_Compatibility__c(DP_Parent_Product__c=p.ID,DP_Child_Product__c=cprod.ID,
                     DP_Base_Quantity__c=10,DP_Increment_Quantity__c=10,DP_Minimum_Quantity__c=10,DP_Maximum_Quantity__c=10);
        insert pcam;
         
        DP_ProductLine__c pl = getProductLine();
        DP_BillingSystem__c bs = getBillingSystem();
        Account a = getAccount(bs);
        Account pa = getAccounts(a.id);
        Opportunity opp = getOpportunity(a.ID,pa.id,pl.ID,dc.ID, pbk1);
//        Opportunity opp = getOpportunity(a.ID,pl.ID,dc.ID, pbk1);
        Quote q = getQuote(opp.ID, pbk1);
        Contact c = new Contact();
        c.LastName = 'Test';
        insert c;
       
        DP_Quote_Line_Group__c qg = getQuoteLineGroup(q.ID);
       /* QuoteLineItem parentqli = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
         QuoteLineItem childqli = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
         childqli.DP_Parent_Quote_Line__c = parentqli.ID;
     
        update childqli;
        */
      /*  QuoteLineItem qli2 = new QuoteLineItem (QuoteID=q.Id,DP_Quote_Group__c=qg.Id,PricebookentryId=pbe1.Id,Quantity=100,UnitPrice=1000,DP_index__c=1,
                                DP_Data_Center__c=dc.Id,DP_CAPEX__c=100,DP_Cost__c=100,DP_DatapipeListPriceUSD__c=100,DP_Discount__c=0,DP_DPListPrice__c=100,
                                DP_kW__c=10,DP_kW_Cost__c=10,DP_kW_Markup__c=1,DP_Markup__c=1,DP_Max_Discount__c=1,DP_MRR__c=1,DP_Setup_Fee__c=10,DP_Base_Quantity__c=1);
        insert qli2;
         qli2.DP_Parent_Quote_Line__c = parentqli.ID;
        update qli2;
       */
       
        
        //start test
        Test.startTest();
       
        
        QuoteLineItem parentqli = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
         QuoteLineItem childqli = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
         childqli.DP_Parent_Quote_Line__c = parentqli.ID;
     
        update childqli;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(q);
        Test.setCurrentPage(Page.DP_NewEditQuote);
        ApexPages.CurrentPage().getParameters().put('id',q.id);
        DP_CloneQuoteController cqc = new DP_CloneQuoteController(controller);
        cqc.refreshPricing = false;
        cqc.doClone();
        //validate the Quote counts before doClone.
        list<Quote> Quoteid =[select id from Quote where opportunityid =:opp.id ];
       // System.assertEquals(1, [SELECT Count() FROM Quote WHERE OpportunityID=:opp.Id ]);
        //validate the QLI counts before doClone
      //  System.assertEquals(2, [SELECT Count() FROM QuoteLineItem WHERE Quote.OpportunityID=:opp.Id ]);
         cqc.refreshPricing = true;
        cqc.doClone();
        //validate the Quote counts after doClone.
       // System.assertEquals(2, [SELECT Count() FROM Quote WHERE OpportunityID=:opp.Id ]);
        //validate the QLI counts after doClone
      //  System.assertEquals(4, [SELECT Count() FROM QuoteLineItem WHERE Quote.OpportunityID=:opp.Id]);
        //stop test
        Test.stopTest();
      
    }
     
    
    /*
    @Name :getSP
    @Description : prepare the test data for DP_Suggested_Product__c record.
    */
    private static List<DP_Suggested_Product__c> getSP(Product2 p,Product2 cprod){
        List<DP_Suggested_Product__c> spLst = new List<DP_Suggested_Product__c>();
        DP_Suggested_Product__c sp1 = new DP_Suggested_Product__c(Product__c=p.ID);
        DP_Suggested_Product__c sp2 = new DP_Suggested_Product__c(Product__c=cprod.ID);
        spLst.add(sp1);
        spLst.add(sp2);
        insert spLst;
        return spLst;
    }
    
    /*
    @Name :getPC
    @Description : prepare the test data for DP_Product_Compatibility__c record.
    */
    private static List<DP_Product_Compatibility__c> getPC(Product2 p,Product2 cprod){
        List<DP_Product_Compatibility__c> pcamlst = new List<DP_Product_Compatibility__c>();
        DP_Product_Compatibility__c pcam = new DP_Product_Compatibility__c(DP_Parent_Product__c=p.ID,DP_Child_Product__c=cprod.ID,
            DP_Product_Type__c='Software',DP_Base_Quantity__c=10,DP_Increment_Quantity__c=10,DP_Minimum_Quantity__c=10,DP_Maximum_Quantity__c=10);
        DP_Product_Compatibility__c pcam1 = new DP_Product_Compatibility__c(DP_Parent_Product__c=p.ID,DP_Include_All__c = true,
            DP_Product_Type__c='Software',DP_Base_Quantity__c=10,DP_Increment_Quantity__c=10,DP_Minimum_Quantity__c=10,DP_Maximum_Quantity__c=10);
        DP_Product_Compatibility__c pcam2 = new DP_Product_Compatibility__c(DP_Parent_Product__c=p.ID,DP_Include_All__c = true,
            DP_Product_Type__c='Software',DP_Base_Quantity__c=10,DP_Increment_Quantity__c=10,DP_Minimum_Quantity__c=10,DP_Maximum_Quantity__c=10);
        pcamlst.add(pcam);
        pcamlst.add(pcam1);
        pcamlst.add(pcam2);
        insert pcamlst;
        return pcamlst;
    }
    
    /*
    @Name :getProduct2
    @Description : prepare the test data for Product2 record.
    */
    private static Product2 getProduct2(String dc){
        Product2 p = new Product2(DP_Setup__c=10,Name='Testing',DP_Product_Type__c = 'Software',DP_Data_Center__c=dc,
                            DP_Datapipe_Part_Number__c='Testing',DP_CAPEX__c=23,DP_Product_Category__c='Hardware',
                            DP_Markup__c=25,DP_Availability__c = 'Available',DP_Max_Discount__c=25,IsActive=True);
        insert p;
        return p;
    }
    
        
    /*
    @Name :getDataCenter
    @Description : prepare the test data for DP_DataCenter__c record.
    */
    private static DP_DataCenter__c getDataCenter(){
        DP_DataCenter__c dc = new DP_DataCenter__c(Name='Northern Virginia - NOVA11',DP_DataCenterID__c=10000,DP_kWCost__c=0.47,DP_kW_Markup__c=50.00);
        insert dc;
        return dc;
    }
    
    /*
    @Name :getProductLine
    @Description : prepare the test data for DP_ProductLine__c record.
    */
    private static DP_ProductLine__c getProductLine(){
        DP_ProductLine__c pl = new DP_ProductLine__c(Name='Test',DP_ProductLineID__c=100000);
        insert pl;
        return pl;
    }
    
    /*
    @Name :getBillingSystem
    @Description : prepare the test data for DP_BillingSystem__c record.
    */
    private static DP_BillingSystem__c getBillingSystem(){
        DP_BillingSystem__c bs = new DP_BillingSystem__c(Name='Test BS', DP_BillingSystemID__c=12345);
        insert bs;
        return bs;
    }
    
    
     /*
    @Name :getAccount
    @Description : prepare the test data for Account record.
    */
    private static Account getAccount(DP_BillingSystem__c bs){
        Account a = new Account(Name='Test',Phone='(456) 238-1212',Website='http://test.com',
                    Industry='Charitable / Non Profit');
        insert a;
        return a;
    }
    
    private static Account getAccounts(string a){
        Account pa = new Account(Name='Test',company_name__C=a, RecordTypeId = Label.Account_Prospect_RecordType_ID);
        insert pa;
        return pa;
    }
    
    /*
    @Name :getOpportunity
    @Description : prepare the test data for Opportunity record.
    */
    
  /*   private static Opportunity getOpportunity(String a, string pa,String pl,String dc, PriceBook2 pb){
        Opportunity o = new Opportunity(PriceBook2Id = pb.Id,Name='Test',AccountID=a,Account__C =pa,DP_ProductLine__c=pl,LeadSource='External Referral',
                            StageName='Stage 3 - Planning & Identificationead',
                            CloseDate=System.Today());
        insert o;
        return o;
    }*/
     private static Opportunity getOpportunity(String a, string pa,String pl,String dc, PriceBook2 pb){
        Opportunity o = new Opportunity(PriceBook2Id = pb.id,Name='Test',AccountID=a,Account__c=pa,DP_ProductLine__c=pl,LeadSource='External Referral',StageName='Stage 3 - Planning & Identificationead',CloseDate=System.Today());
        insert o;
        return o;
    }
    
    /*
    @Name :getQuote
    @Description : prepare the test data for Quote record.
    */
    private static Quote getQuote(String opp, PriceBook2 pb){
        Quote q = new Quote(Name='Test',OpportunityID=opp,DP_Exchange_Rate__c=10, Pricebook2Id=pb.Id, DP_Term__c='12');
        insert q;
        return q;
    }
    
    /*
    @Name :getQuoteLineGroup
    @Description : prepare the test data for DP_Quote_Line_Group__c record.
    */
    private static DP_Quote_Line_Group__c getQuoteLineGroup(String q){
        DP_Quote_Line_Group__c qg = new DP_Quote_Line_Group__c(Name='Test',DP_Quote__c=q);
        insert qg;
        return qg;
    }
    
    /*
    @Name :getQuoteLineItem
    @Description : prepare the test data for QuoteLineItem record.
    */
    private static QuoteLineItem getQuoteLineItem(String q,String qg,String pentry,String dc){
        QuoteLineItem qli = new QuoteLineItem (QuoteID=q,DP_Quote_Group__c=qg,PricebookentryId=pentry,Quantity=100,UnitPrice=1000,
                                DP_Data_Center__c=dc,DP_CAPEX__c=100,DP_Cost__c=100,DP_DatapipeListPriceUSD__c=100,DP_Discount__c=0,DP_DPListPrice__c=100,
                                DP_kW__c=10,DP_kW_Cost__c=10,DP_kW_Markup__c=1,DP_Markup__c=1,DP_Max_Discount__c=1,DP_MRR__c=1,DP_Setup_Fee__c=10,DP_Base_Quantity__c=1);
        insert qli;
        return qli;
    }
    
    
   
    
    
}