/*
@Name : TestDP_NewEditQuoteANDConfigDocCls
@Author : customersuccess@cloud62.com
@Date : 08-09-2013
@Description : test DPNewConfigurationDocumentController,DatapipeUtility,DP_NewEditQuoteController classes and 
                RollupQuoteLineItems Trigger functionality.
*/
@isTest(seealldata=true)
public class DP_TestNewEditQuoteANDConfigDocCls {
    
    /*
    @Name :testClone
    @Description : test functionality for CloneQuoteController Trigger.
    */
    static testmethod void testClone(){
        //Get Test Data.
        Pricebook2 pbk1 = [Select Id, Name, IsActive From Pricebook2 where IsStandard = true LIMIT 1];
        DP_DataCenter__c dc = getDataCenter();
        Product2 p = getProduct2(dc.ID);
        Product2 cprod = getProduct2(dc.ID);
         PricebookEntry pbe1 = [select id, name, isActive,unitprice,UseStandardPrice from PricebookEntry where Product2ID=:p.id limit 1];
              
        DP_Product_Compatibility__c pcam = new DP_Product_Compatibility__c(DP_Parent_Product__c=p.ID,DP_Child_Product__c=cprod.ID,DP_Base_Quantity__c=10,
        DP_Increment_Quantity__c=1,DP_Maximum_Quantity__c=20,DP_Minimum_Quantity__c=0);
        insert pcam;
        DP_ProductLine__c pl = getProductLine();
        DP_BillingSystem__c bs = getBillingSystem();
        Account a = getAccount(bs);
        Opportunity opp = getOpportunity(a.ID,pl.ID,dc.ID, pbk1);
        Quote q = getQuote(opp.ID, pbk1);
        contact con =new Contact();
        Id rtId1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Government').getRecordTypeId(); 
        Contact c = new Contact(firstname='Test',lastname='Case',Email='case.test@rax.com',recordtypeId=rtId1 );
        insert c;
        DP_Quote_Line_Group__c qg = getQuoteLineGroup(q.ID);
        QuoteLineItem parentqli = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        QuoteLineItem childqli = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        childqli.DP_Parent_Quote_Line__c = parentqli.ID;
        update childqli;
        
        //start test
        Test.startTest();
        ApexPages.StandardController controller = new ApexPages.StandardController(q);
        Test.setCurrentPage(Page.DP_NewEditQuote);
        ApexPages.CurrentPage().getParameters().put('id',q.id);
        DP_CloneQuoteController cqc = new DP_CloneQuoteController(controller);
        cqc.refreshPricing = true;
        cqc.doClone();
        //validate the Quote counts before doClone.
        list<Quote> Quoteid =[select id from Quote where opportunityid =:opp.id ];
        System.assertEquals(1, [SELECT Count() FROM Quote WHERE OpportunityID=:opp.Id ]);
        //validate the QLI counts before doClone
        System.assertEquals(2, [SELECT Count() FROM QuoteLineItem WHERE Quote.OpportunityID=:opp.Id ]);
         cqc.refreshPricing = false;
        cqc.doClone();
        //validate the Quote counts after doClone.
        System.assertEquals(2, [SELECT Count() FROM Quote WHERE OpportunityID=:opp.Id ]);
        //validate the QLI counts after doClone
        System.assertEquals(4, [SELECT Count() FROM QuoteLineItem WHERE Quote.OpportunityID=:opp.Id]);
        //stop test
        Test.stopTest();
    }
    
   
    
    /*
    @Name :testNewConfigurationDocumentCls
    @Description : test functionality for DPNewConfigurationDocumentController class.
    */
    static testmethod void testNewConfigurationDocumentCls(){
        //get test data
        Pricebook2 pbk1 = [Select Id, Name, IsActive From Pricebook2 where IsStandard = true LIMIT 1];
        DP_DataCenter__c dc = getDataCenter();
        Product2 p = getProduct2(dc.ID);
        Product2 cprod = getProduct2(dc.ID);
        PricebookEntry pbe1 = [select id, name, isActive from PricebookEntry where Product2ID=:p.id limit 1];
        DP_Product_Compatibility__c pcam = new DP_Product_Compatibility__c(DP_Parent_Product__c=p.ID,DP_Child_Product__c=cprod.ID,DP_Base_Quantity__c=10,
        DP_Increment_Quantity__c=1,DP_Maximum_Quantity__c=20,DP_Minimum_Quantity__c=0);
        insert pcam;
        DP_ProductLine__c pl = getProductLine();
        DP_BillingSystem__c bs = getBillingSystem();
        Account a = getAccount(bs);
        Opportunity opp = getOpportunity(a.ID,pl.ID,dc.ID, pbk1);
        Quote q = getQuote(opp.ID, pbk1);
        DP_Quote_Line_Group__c qg = getQuoteLineGroup(q.ID);
        QuoteLineItem qli = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        //start test
        Test.startTest();
        ApexPages.currentPage().getParameters().put('Id', q.ID);
        DPNewConfigurationDocumentController nConfig = new DPNewConfigurationDocumentController();
        System.assertEquals(q.ID, nConfig.getRecordId());
        nConfig.editQuote();
        nConfig.previousPage();
        nConfig.getExceptionQuoteLineItems();
        nConfig.cancel();
        nConfig.doUpdate();
        nConfig.getSessionId();
        //System.assertEquals(null, nConfig.getSessionId()); commented out - diego castro
        nConfig.getServerURL();
        System.assertEquals(null, nConfig.getServerURL());
        nConfig.getFormattedQuote();
        nConfig.getSerializedGlobalizeMap();
        nConfig.buildTemplateString();
        nConfig.nextPage();
        nConfig.home();
        nConfig.submitForApproval();
        for(DPNewConfigurationDocumentController.ExcludeWrapper ew : nConfig.excludeWrapperList){
            ew.checked = true;
            ew.hideChildPrice = true;
            ew.showdescription=true;
        }
        nConfig.updateCollapse();
        //stop test
        Test.stopTest();
    }
    
    
    
 /*
    @Name :testDP_NewEditQuoteCls
    @Description : test functionality for DatapipeUtility, DP_NewEditQuoteController classes and 
                   RollupQuoteLineItems Trigger.
    */
    static testmethod void testDP_NewEditQuoteCls(){
        //Get Test Data.
        Pricebook2 pbk1 = [Select Id, Name, IsActive From Pricebook2 where IsStandard = true LIMIT 1];
        DP_DataCenter__c dc = getDataCenter();
        Product2 p = getProduct2(dc.ID);
        Product2 cprod = getProduct2(dc.ID);
        PricebookEntry pbe1 = [select id, name, isActive from PricebookEntry where Product2ID=:p.id limit 1];
        List<DP_Product_Compatibility__c> pcamlst = getPC(p,cprod);
        List<DP_Suggested_Product__c> spLst = getSP(p,cprod);
        DP_ProductLine__c pl = getProductLine();
        DP_BillingSystem__c bs = getBillingSystem();
        Account a = getAccount(bs);
        Opportunity opp = getOpportunity(a.ID,pl.ID,dc.ID, pbk1);
        Quote q = getQuote(opp.ID, pbk1);
        contact con =new Contact();
        Id rtId1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Government').getRecordTypeId(); 
        Contact c = new Contact(firstname='Test',lastname='Case',Email='case.test@rax.com',recordtypeId=rtId1 );
        insert c;
        q.ContactId = c.Id;
        DP_Quote_Line_Group__c qg = getQuoteLineGroup(q.ID);
        QuoteLineItem qli = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        QuoteLineItem qli1 = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        qli1.DP_Parent_Quote_Line__c = qli.ID;
        update qli1;
        //Validate Opp.DP_Data_Center__c value after insert QLI.
        System.assertEquals('Northern Virginia - NOVA11', [SELECT DP_Data_Center__c FROM Opportunity WHERE Id=:opp.Id][0].DP_Data_Center__c);        
        //start test
        Test.startTest();
        
         ApexPages.StandardController ctl = new ApexPages.StandardController(q);
        DP_NewEditQuoteController neQuote = new DP_NewEditQuoteController(ctl);
        neQuote.strParentQLIId= qli.ID;
        System.debug(neQuote.strJSONQLGrid);
        neQuote.configProd();
        neQuote.updateDiscounts();
        
        neQuote.cQuote.DP_Exchange_Rate__c=10;
        neQuote.cstrPBEID = pbe1.ID;
       // neQuote.cQuote.DP_currency_code__c='EUR';
     //   neQuote.cQuote.DP_term__c='12';
      //  neQuote.updateTerm();
        //validate the lease and QLI on the quote
        System.assertEquals(20.00, neQuote.lease12);
        neQuote.addProduct();
        System.assertEquals(2, [SELECT Count() FROM QuoteLineItem WHERE QuoteId=:q.Id]);
        neQuote.getDataCenters();
        neQuote.getSuggestedProducts();
        neQuote.cQuote.ContactId = c.ID;
        neQuote.cstrQuoteGroup = 'Test';
        neQuote.cstrPBEID = pbe1.ID;
        neQuote.addProduct();
        //validate the lease
        //System.assertEquals(3.43, neQuote.lease12);
        neQuote.saveAll();
        //validate the QLI count and lease on the quote
        //System.assertEquals(6, [SELECT Count() FROM QuoteLineItem WHERE QuoteId=:q.Id]);
        //System.assertEquals(3.43, neQuote.lease12);
        neQuote.getPriceBookEntriesPC();
        neQuote.calcMRR();
        neQuote.addToPreview();
        neQuote.addUpdateQL();
        neQuote.cancelConfig();
        neQuote.cSearchPBEId=pbe1.ID;
        neQuote.checkHasChildren();
        neQuote.getPriceBookEntries();
        neQuote.cSearchProd='Software';
        neQuote.cSearchDCId=dc.ID;
        neQuote.getPriceBookEntries();
        neQuote.cSearchDCId='';
        neQuote.getPriceBookEntries();
        neQuote.cSearchProd=null;
        neQuote.cSearchDCId=dc.ID;
        neQuote.getPriceBookEntries();
        neQuote.updateDiscounts();
        neQuote.updateTerm();
        neQuote.getDataCenterNames();
        neQuote.changeCurrency();
        neQuote.filterPC();
        neQuote.pbeRecId = pbe1.id;
        neQuote.filterPC();
        neQuote.cQuote.PriceBook2Id = null;
        neQuote.cOpportunity.PriceBook2Id = null;
        neQuote.selectPriceBook();
        //stop test
        Test.stopTest();
        
        
        /*
        
        ApexPages.StandardController ctl = new ApexPages.StandardController(q);
        DP_NewEditQuoteController neQuote = new DP_NewEditQuoteController(ctl);
        neQuote.strParentQLIId= qli.ID;
        System.debug(neQuote.strJSONQLGrid);
       // neQuote.configProd();
        neQuote.cQuote.DP_Exchange_Rate__c=10;
        neQuote.cstrPBEID = pbe1.ID;
        //validate the lease and QLI on the quote
        System.assertEquals(2, neQuote.lease12);
        neQuote.addProduct();
        System.assertEquals(2, [SELECT Count() FROM QuoteLineItem WHERE QuoteId=:q.Id]);
        //System.assertEquals(2.72, neQuote.lease12);
        neQuote.getDataCenters();
        neQuote.getSuggestedProducts();
        neQuote.cQuote.ContactId = c.ID;
        //neQuote.cstrQuoteGroup = 'Test';
        neQuote.cstrPBEID = pbe1.ID;
        neQuote.addProduct();
        //validate the lease
        //System.assertEquals(3.43, neQuote.lease12);
        neQuote.saveAll();
        //validate the QLI count and lease on the quote
        //System.assertEquals(6, [SELECT Count() FROM QuoteLineItem WHERE QuoteId=:q.Id]);
        //System.assertEquals(3.43, neQuote.lease12);
        neQuote.getPriceBookEntriesPC();
        neQuote.calcMRR();
        neQuote.addToPreview();
        neQuote.addUpdateQL();
        neQuote.cancelConfig();
        neQuote.cSearchPBEId=pbe1.ID;
        neQuote.checkHasChildren();
        neQuote.getPriceBookEntries();
        //neQuote.cSearchProd.DP_Product_Type__c='Software';
        neQuote.cSearchDCId=dc.ID;
        neQuote.getPriceBookEntries();
        neQuote.cSearchDCId='';
        neQuote.getPriceBookEntries();
        //neQuote.cSearchProd.DP_Product_Type__c=null;
        neQuote.cSearchDCId=dc.ID;
        neQuote.getPriceBookEntries();
        neQuote.updateDiscounts();
        neQuote.updateTerm();
        neQuote.getDataCenterNames();
        neQuote.changeCurrency();
        neQuote.filterPC();
        neQuote.pbeRecId = pbe1.id;
        neQuote.filterPC();
        neQuote.cQuote.PriceBook2Id = null;
        neQuote.cOpportunity.PriceBook2Id = null;
        neQuote.selectPriceBook();
        
        Quote q1 = new Quote();
        ApexPages.StandardController ctl1 = new ApexPages.StandardController(q1);
        ApexPages.currentPage().getParameters().put('oppid', opp.ID);
        DP_NewEditQuoteController neQuote1 = new DP_NewEditQuoteController(ctl1);
        System.assertEquals(opp.ID, neQuote1.cOpportunity.ID);
        System.assertEquals(a.ID, neQuote1.cAccount.ID);
        neQuote1.getDataCenters();
        neQuote1.getSuggestedProducts();
        neQuote1.cQuote.Name='Test';
        neQuote1.cQuote.ContactId=c.ID;
        neQuote1.cbolActive=True;
        //System.assertEquals(6, [SELECT Count() FROM QuoteLineItem WHERE QuoteId=:q.Id]);
        neQuote.saveAll();
        neQuote1.selectPriceBook();
        neQuote1.showConfig=true;
        neQuote1.changeCurrency();
        neQuote1.cstrPBEID = pbe1.id;
       // neQuote1.addOrConfig();
        neQuote1.cstrItemId=qli.Id;
        neQuote1.calcMRR();
        neQuote1.showConfig=false;
        neQuote1.updateDiscounts();
        neQuote1.updateTerm();
        neQuote1.resetAvailableChildren();
        //stop test
        Test.stopTest();
        */
       
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
            DP_Minimum_Quantity__c=10,DP_Maximum_Quantity__c=20,DP_Increment_Quantity__c=10,DP_Base_Quantity__c=10,DP_Product_Type__c='Software');
        DP_Product_Compatibility__c pcam1 = new DP_Product_Compatibility__c(DP_Parent_Product__c=p.ID,DP_Include_All__c = true,DP_Base_Quantity__c=10,
            DP_Product_Type__c='Software',DP_Minimum_Quantity__c=10,DP_Maximum_Quantity__c=20,DP_Increment_Quantity__c=10);
        DP_Product_Compatibility__c pcam2 = new DP_Product_Compatibility__c(DP_Parent_Product__c=p.ID,DP_Include_All__c = true,DP_Base_Quantity__c=10,
            DP_Product_Type__c='Software',DP_Increment_Quantity__c=1,DP_Maximum_Quantity__c=20,DP_Minimum_Quantity__c=0);
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
                            DP_Markup__c=25,DP_Availability__c = 'Available',DP_Max_Discount__c=25,isactive=true);
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
    @Name :getAccount
    @Description : prepare the test data for Account record.
    */
    private static Account getAccount(DP_BillingSystem__c bs){
        Account a = new Account(Name='Test',Phone='(456) 238-1212',Website='http://test.com',
                    Industry='Charitable / Non Profit'
                                //,DP_BillingSystem__c=bs.ID commented out - diego castro
                                );
        insert a;
        return a;
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
    @Name :getOpportunity
    @Description : prepare the test data for Opportunity record.
    */
    private static Opportunity getOpportunity(String a,String pl,String dc, PriceBook2 pb){
        Opportunity o = new Opportunity(PriceBook2Id = pb.Id,Name='Test',AccountID=a,DP_ProductLine__c=pl,LeadSource='External Referral',
                                        StageName='Lead',
                                        // DP_Commit__c='Pipeline',NextStep='3',DP_InitialContactDate__c=System.Today(), commented out - diego castro
                                        CloseDate=System.Today());
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