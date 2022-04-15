@isTest(seealldata=true)
private class DatapipeUtilities_Test {
    
    static testmethod void testDatapipeUtilities(){
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
       // Contact c = new Contact();
         Id rtId1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Government').getRecordTypeId(); 
        Contact c = new Contact(firstname='Test',lastname='Case',Email='case.test@rax.com',recordtypeId=rtId1 );
        insert c;
        
        
        q.ContactId = c.Id;
        DP_Quote_Line_Group__c qg = getQuoteLineGroup(q.ID);
        List<QuoteLineItem> qlil = new List<QuoteLineItem>();
        QuoteLineItem qli = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID); 
        qli.DP_Asset_Action__c = 'Change';
        qli.DP_MRR__c = -1;
        qlil.add(qli);
        /*QuoteLineItem qli1 = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        qli1.PriceBookEntry.Product2.Product_Type__c = 'Role';
        //p1.Product_Type__c = 'Role';
        update qli1;//p1;
        qlil.add(qli1);
        QuoteLineItem qli2 = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        Product2 p2 = qli2.PriceBookEntry.Product2;
        p2.DP_Product_Type__c = 'Server';
        update p2;
        qlil.add(qli2);
        QuoteLineItem qli3 = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        Product2 p3 = qli3.PriceBookEntry.Product2;
        p3.DP_Product_Type__c = 'Operating System';
        update p3;
        qlil.add(qli3);
        QuoteLineItem qli4 = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        Product2 p4 = qli4.PriceBookEntry.Product2;
        p4.DP_Product_Type__c = 'Processor';
        update p4;
        qlil.add(qli4);
        QuoteLineItem qli5 = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        Product2 p5 = qli5.PriceBookEntry.Product2;
        p5.DP_Product_Type__c = 'Hard Drive';
        update p5;
        qlil.add(qli5);
        QuoteLineItem qli6 = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        Product2 p6 = qli6.PriceBookEntry.Product2;
        p6.DP_Product_Type__c = 'RAID';
        update p6;
        qlil.add(qli6);
        QuoteLineItem qli7 = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        Product2 p7 = qli7.PriceBookEntry.Product2;
        p7.DP_Product_Type__c = 'Memory';
        update p7;
        qlil.add(qli7);
        QuoteLineItem qli8 = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        Product2 p8 = qli8.PriceBookEntry.Product2;
        p8.Product_Type__c = 'Power Supply';
        update p8;
        qlil.add(qli8);
        QuoteLineItem qli9 = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        Product2 p9 = qli9.PriceBookEntry.Product2;
        p9.DP_Product_Type__c = 'Network Interface Card';
        update p9;
        qlil.add(qli9);
        QuoteLineItem qli10 = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        Product2 p10 = qli10.PriceBookEntry.Product2;
        p10.DP_Product_Type__c = 'Host Bus Adapter';
        update p10;
        qlil.add(qli10);*/
        Test.startTest();
        List<QuoteLineItem> asdf = DP_DatapipeUtility.sortLstQLIByProdType(qlil);
        Decimal d = DP_DatapipeUtility.calculate_Lease1(1, 1);
        Decimal e = DP_DatapipeUtility.calculate_kW1(1, 1);
        Quote boo = DP_DatapipeUtility.rollupQuoteLineItems(q);
        Test.stopTest();
    }
    
    static testmethod void testTestUtils(){
        Test.startTest();
        Integer i = DP_DatapipeUtility.testUtil();
        Test.stopTest();
    }
    /*
    @Name :getContract
    @Description : prepare the test data for Product2 record.
    */
    private static Contract getContract(String a,String o){
        Contract c = new Contract(AccountId=a,startDate=System.Today(),Name='test', DP_Opportunity__c=o);
        insert c;
        return c;
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
    @Description : prepare the test data for Quote_Line_Group__c record.
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
    
     /*
    @Name :getBillingSystem
    @Description : prepare the test data for BillingSystem__c record.
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
    
    /*
    @Name :getOpportunity
    @Description : prepare the test data for Opportunity record.
    */
    private static Opportunity getOpportunity(String a,String pl,String dc, PriceBook2 pb){
        Opportunity o = new Opportunity(PriceBook2Id = pb.Id,Name='Test',AccountID=a,DP_ProductLine__c=pl,LeadSource='External Referral',
                            StageName='Lead',NextStep='3',
                            CloseDate=System.Today());
        insert o;
        return o;
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
                            DP_Markup__c=25,DP_Availability__c = 'Available',DP_Max_Discount__c=25,isActive=true);
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
}