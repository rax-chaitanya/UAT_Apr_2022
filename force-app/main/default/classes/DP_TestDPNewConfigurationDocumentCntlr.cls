@isTest(seeAllData = true)
public class DP_TestDPNewConfigurationDocumentCntlr {
 
 static testmethod void newConfigurationDocumentClstest(){
        //get test data
        Pricebook2 pbk1 = [Select Id, Name, IsActive From Pricebook2 where IsStandard = true LIMIT 1];
        DP_DataCenter__c dc = getDataCenter();
        Product2 p = getProduct2(dc.ID);
        Product2 cprod = getProduct2(dc.ID);
        PricebookEntry pbe1 = [select id, name, isActive from PricebookEntry where Product2ID=:p.id limit 1];
        DP_Product_Compatibility__c pcam = new DP_Product_Compatibility__c(DP_Parent_Product__c=p.ID,DP_Child_Product__c=cprod.ID,
                DP_Base_Quantity__c=10,DP_Increment_Quantity__c=10,DP_Minimum_Quantity__c=10,DP_Maximum_Quantity__c=10);
        insert pcam;
        List<APXTConga4__Conga_Template__c> aList = getApexTemplate();
        List<Template_Thumbnail__c> tempLst = getTemplateLst(aList);
        List<Attachment> attachLst =  getAttachmentLst(tempLst);
        DP_ProductLine__c pl = getProductLine();
        DP_BillingSystem__c bs = getBillingSystem();
        Account a = getAccount(bs);
        Opportunity opp = getOpportunity(a.ID,pl.ID,dc.ID, pbk1);
        Quote q = getQuote(opp.ID, pbk1);
        DP_Quote_Line_Group__c qg = getQuoteLineGroup(q.ID);
        QuoteLineItem qli = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        QuoteLineItem chlidqli = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        // chlidqli.Parent_Quote_Line__c = qli.ID;
        update chlidqli;
        List<QuoteLineItem> qliLst = new List<QuoteLineItem>();
        qliLst.add(chlidqli);
        
        
        
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
       // System.assertEquals(null, nConfig.getSessionId());
        nConfig.getServerURL();
       // System.assertEquals(null, nConfig.getServerURL());
        nConfig.getFormattedQuote();
        nConfig.getSerializedGlobalizeMap();
        nConfig.buildTemplateString();
        nConfig.page=2;
        nConfig.nextPage();
        nConfig.home();
        nConfig.submitForApproval();
        for(DPNewConfigurationDocumentController.ExcludeWrapper ew : nConfig.excludeWrapperList){
            ew.checked = true;
            ew.hideChildPrice = true;
            ew.showdescription=true;
        }
        nConfig.hideChildPriceAll();
        nConfig.collapseQuoteLineAll();
        nConfig.updateCollapse();
        nConfig.getRole(qliLst);
        nConfig.getRole(qli,qliLst);
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
    @Name :getApexTemplate
    @Description : prepare the test data for APXTConga4__Conga_Template__c record.
    */
    private static List<APXTConga4__Conga_Template__c> getApexTemplate(){
        List<APXTConga4__Conga_Template__c> apexCongaTempLst = new List<APXTConga4__Conga_Template__c>();
        APXTConga4__Conga_Template__c a1 = new APXTConga4__Conga_Template__c();
        APXTConga4__Conga_Template__c a2 = new APXTConga4__Conga_Template__c();
        APXTConga4__Conga_Template__c a3 = new APXTConga4__Conga_Template__c();
        APXTConga4__Conga_Template__c a4 = new APXTConga4__Conga_Template__c();
        apexCongaTempLst.add(a1);
        apexCongaTempLst.add(a2);
        apexCongaTempLst.add(a3);
        apexCongaTempLst.add(a4);
        insert apexCongaTempLst;
        return apexCongaTempLst;
    }
    
    /*
    @Name :getTemplateLst
    @Description : prepare the test data for Template_Thumbnail__c record.
    */
    private static List<Template_Thumbnail__c> getTemplateLst(List<APXTConga4__Conga_Template__c> alst){
        List<Template_Thumbnail__c> tempLst = new List<Template_Thumbnail__c>();
        Template_Thumbnail__c a1 = new Template_Thumbnail__c(Conga_Template__c=alst[0].Id);
        Template_Thumbnail__c a2 = new Template_Thumbnail__c(Conga_Template__c=alst[1].Id);
        Template_Thumbnail__c a3 = new Template_Thumbnail__c(Conga_Template__c=alst[2].Id);
        Template_Thumbnail__c a4 = new Template_Thumbnail__c(Conga_Template__c=alst[3].Id);
        tempLst.add(a1);
        tempLst.add(a2);
        tempLst.add(a3);
        tempLst.add(a4);
        insert tempLst;
        return tempLst;
    }
    
    /*
    @Name :getTemplateLst
    @Description : prepare the test data for Template_Thumbnail__c record.
    */
    private static List<Attachment> getAttachmentLst(List<Template_Thumbnail__c> tempLst){
        List<Attachment> attachmentLst = new List<Attachment>();
        Attachment a1 = new Attachment(ParentId=tempLst[0].Id,Name = 'Test',Body = Blob.valueOf('test'));
        Attachment a2 = new Attachment(ParentId=tempLst[1].Id,Name = 'Test',Body = Blob.valueOf('test'));
        Attachment a3 = new Attachment(ParentId=tempLst[2].Id,Name = 'Test',Body = Blob.valueOf('test'));
        Attachment a4 = new Attachment(ParentId=tempLst[3].Id,Name = 'Test',Body = Blob.valueOf('test'));
        attachmentLst.add(a1);
        attachmentLst.add(a2);
        attachmentLst.add(a3);
        attachmentLst.add(a4);
        insert attachmentLst;
        return attachmentLst;
    }
    
    /*
    @Name :getPC
    @Description : prepare the test data for DP_Product_Compatibility__c record.
    */
    private static List<DP_Product_Compatibility__c> getPC(Product2 p,Product2 cprod){
        List<DP_Product_Compatibility__c> pcamlst = new List<DP_Product_Compatibility__c>();
        DP_Product_Compatibility__c pcam = new DP_Product_Compatibility__c(DP_Parent_Product__c=p.ID,DP_Child_Product__c=cprod.ID,
            DP_Product_Type__c='Server',DP_Base_Quantity__c=10,DP_Increment_Quantity__c=10,DP_Minimum_Quantity__c=10,DP_Maximum_Quantity__c=10);
        DP_Product_Compatibility__c pcam1 = new DP_Product_Compatibility__c(DP_Parent_Product__c=p.ID,DP_Include_All__c = true,
            DP_Product_Type__c='Server',DP_Base_Quantity__c=10,DP_Increment_Quantity__c=10,DP_Minimum_Quantity__c=10,DP_Maximum_Quantity__c=10);
        DP_Product_Compatibility__c pcam2 = new DP_Product_Compatibility__c(DP_Parent_Product__c=p.ID,DP_Include_All__c = true,
            DP_Product_Type__c='Server',DP_Base_Quantity__c=10,DP_Increment_Quantity__c=10,DP_Minimum_Quantity__c=10,DP_Maximum_Quantity__c=10);
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
        Product2 p = new Product2(DP_Setup__c=10,Name='Testing',DP_Product_Type__c = 'Server',DP_Data_Center__c=dc,
                            DP_Datapipe_Part_Number__c='Testing',DP_CAPEX__c=23,DP_Product_Category__c='Hardware',
                            DP_Markup__c=25,DP_Availability__c = 'Available',DP_Max_Discount__c=25);
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
    @Name :getQuote
    @Description : prepare the test data for Quote record.
    */
    private static Quote getQuote(String opp, PriceBook2 pb){
        Quote q = new Quote(Name='Test',OpportunityID=opp, Pricebook2Id=pb.Id, DP_Term__c='12', DP_Formatted_Quote__c = 'quote1', DP_Currency_Code__c = 'CNY', DP_Approval_Comments__c = 'approve comments');
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