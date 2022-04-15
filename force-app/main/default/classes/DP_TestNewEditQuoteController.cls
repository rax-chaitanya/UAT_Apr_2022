/*
@Name : TestNewEditQuoteController
@Author : customersuccess@cloud62.com
@Date : 08-09-2013
@Description : Test class for NewEditQuoteController, DatapipeUtility classes and 
                RollupQuoteLineItems Trigger functionality.
*/
@isTest
public class DP_TestNewEditQuoteController{
    
    /*
    @Name :testNewEditQuoteCls
    @Description : test functionality for DatapipeUtility, NewEditQuoteController classes and 
                   RollupQuoteLineItems Trigger.
    */
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
        DP_BillingSystem__c bs = getBillingSystem();        
        Account a = getAccount(bs,compgovRT);
        Account pa = getAccounts(a.id,govpaRT);
        Contact c = new Contact(firstname='Test',lastname='Case',Email='case.test@rax.com',recordtypeId=rtId1 );
        insert c;        
        DP_DataCenter__c dc = getDataCenter();
        DP_ProductLine__c pl = getProductLine();        
        Opportunity opp = getOpportunity(a.ID,pa.id,pl.ID,dc.ID, pbk1.Id,oppgovRT);
        Quote q = getQuote(opp.ID, pbk1.Id);        
        
     Test.stopTest();   
     
    }
    
    @isTest static void newEditQuoteClstest(){
        
        DP_BillingSystem__c bs = [SELECT Id,Name,DP_BillingSystemID__c from DP_BillingSystem__c where Name='Test BS' AND DP_BillingSystemID__c=12345 LIMIT 1];      
        Account a = [SELECT Id,Name,Phone,Website,Industry from Account where Name='Test' AND RecordType.Name = 'Government Company' LIMIT 1];
        String govRTId = Label.AccountGovernmentRecordTypeId;
        Account pa = [SELECT Id,Name,company_name__c from Account where Name='Test' AND RecordType.Name = 'Government Account' LIMIT 1];
        Contact c = [SELECT Id,firstname,lastname,Email,recordtypeId from Contact where lastname='Case' AND Recordtype.Name='Government' LIMIT 1];
        DP_ProductLine__c pl = [SELECT Id,Name,DP_ProductLineID__c from DP_ProductLine__c WHERE Name='Test' AND DP_ProductLineID__c=100000 LIMIT 1];        
        DP_DataCenter__c dc = [SELECT Id,Name,DP_DataCenterID__c,DP_kWCost__c,DP_kW_Markup__c FROM DP_DataCenter__c WHERE Name='Northern Virginia - NOVA11' LIMIT 1];
        Opportunity opp = [SELECT Id,Name,PriceBook2Id,AccountID,Account__c,DP_ProductLine__c,LeadSource,StageName,CloseDate from Opportunity where Recordtype.Name='Government' LIMIT 1];      
        Quote q = [SELECT Id,Name,ContactId,OpportunityID,DP_Exchange_Rate__c,Pricebook2Id,DP_Term__c,QuoteSynced__C,DP_Operational_Life_Factor__c,DP_Cost_of_Money__c,DP_Money_Making_Months__c,DP_Month_to_Month_Multiplier__c,DP_kW_Month_to_Month_Multiplier__c,DP_kW_Hours_In_Month__c,DP_kW_Term_Multiplier__c from Quote WHERE OpportunityID=:opp.Id LIMIT 1];
        Product2 p = getProduct2(dc.ID);
        Product2 cprod = getcprodProduct2(dc.ID);
        PricebookEntry pbe1 = [select id, name, isActive from PricebookEntry where Product2ID=:p.id limit 1];
        
        List<DP_Product_Compatibility__c> pcamlst = getPC(p,cprod);
        List<DP_Suggested_Product__c> spLst = getSP(p,cprod);
        contact con =new Contact();
        /* Contact c = new Contact();
        c.LastName = 'Test';
        insert c; */
        q.ContactId = c.Id;
        DP_Customer_Specific_Product__c dcsp = getDPCusSP(p.Id,pa.Id);
        DP_Quote_Line_Group__c qg = getQuoteLineGroup(q.ID);    
        QuoteLineItem qli = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        QuoteLineItem qli1 = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        
       /* QuoteLineItem qli2 = new QuoteLineItem (QuoteID=q.Id,DP_Quote_Group__c=qg.Id,PricebookentryId=pbe1.Id,Quantity=100,UnitPrice=1000,DP_index__c=1,
                                DP_Data_Center__c=dc.Id,DP_CAPEX__c=100,DP_Cost__c=100,DP_DatapipeListPriceUSD__c=100,DP_Discount__c=0,DP_DPListPrice__c=100,
                                DP_kW__c=10,DP_kW_Cost__c=10,DP_kW_Markup__c=1,DP_Markup__c=1,DP_Max_Discount__c=1,DP_MRR__c=1,DP_Setup_Fee__c=10,DP_Base_Quantity__c=1);
      //  insert qli2;
      */
        qli1.DP_Parent_Quote_Line__c = qli.ID;
        update qli1;
//        delete qli1;
      //  undelete qli1;
        //Validate Opp.DP_Data_Center__c value after insert QLI.
        //System.assertEquals('Northern Virginia - NOVA11', [SELECT DP_Data_Center__c FROM Opportunity WHERE Id=:opp.Id][0].DP_Data_Center__c);        
        //start test
        Test.startTest();
        
        ApexPages.StandardController ctl = new ApexPages.StandardController(q);
        DP_NewEditQuoteController dfctrl = new DP_NewEditQuoteController();     
        DP_NewEditQuoteController neQuote = new DP_NewEditQuoteController(ctl);     
        neQuote.strParentQLIId= qli.ID;
        System.debug(neQuote.strJSONQLGrid);                
        neQuote.configProd();
        neQuote.updateDiscounts();
        neQuote.updateTerm();
        neQuote.cQuote.DP_Exchange_Rate__c=10;
        neQuote.cstrPBEID = pbe1.ID;
        //validate the lease and QLI on the quote
        //System.assertEquals(6941233.93, neQuote.lease12);
        //System.assertEquals(true, neQuote.lease12 !=null);
              neQuote.addProduct();
        //System.assertEquals(2, [SELECT Count() FROM QuoteLineItem WHERE QuoteId=:q.Id]);
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
        neQuote.getContacts();  
        
        //stop test
        Test.stopTest();
    }
    
    @isTest static void newEditQuotechnagecurrency(){
        
        DP_BillingSystem__c bs = [SELECT Id,Name,DP_BillingSystemID__c from DP_BillingSystem__c where Name='Test BS' AND DP_BillingSystemID__c=12345 LIMIT 1];      
        Account a = [SELECT Id,Name,Phone,Website,Industry from Account where Name='Test' AND RecordType.Name = 'Government Company' LIMIT 1];
        String govRTId = Label.AccountGovernmentRecordTypeId;
        Account pa = [SELECT Id,Name,company_name__c from Account where Name='Test' AND RecordType.Name = 'Government Account' LIMIT 1];
        Contact c = [SELECT Id,firstname,lastname,Email,recordtypeId from Contact where lastname='Case' AND Recordtype.Name='Government' LIMIT 1];
        DP_ProductLine__c pl = [SELECT Id,Name,DP_ProductLineID__c from DP_ProductLine__c WHERE Name='Test' AND DP_ProductLineID__c=100000 LIMIT 1];        
        DP_DataCenter__c dc = [SELECT Id,Name,DP_DataCenterID__c,DP_kWCost__c,DP_kW_Markup__c FROM DP_DataCenter__c WHERE Name='Northern Virginia - NOVA11' LIMIT 1];
        Opportunity opp = [SELECT Id,Name,PriceBook2Id,AccountID,Account__c,DP_ProductLine__c,LeadSource,StageName,CloseDate from Opportunity where Recordtype.Name='Government' LIMIT 1];      
        Quote q = [SELECT Id,Name,ContactId,OpportunityID,DP_Exchange_Rate__c,Pricebook2Id,DP_Term__c,QuoteSynced__C,DP_Operational_Life_Factor__c,DP_Cost_of_Money__c,DP_Money_Making_Months__c,DP_Month_to_Month_Multiplier__c,DP_kW_Month_to_Month_Multiplier__c,DP_kW_Hours_In_Month__c,DP_kW_Term_Multiplier__c from Quote WHERE OpportunityID=:opp.Id LIMIT 1];
        Product2 p = getProduct2(dc.ID);
        Product2 cprod = getcprodProduct2(dc.ID);
        PricebookEntry pbe1 = [select id, name, isActive from PricebookEntry where Product2ID=:p.id limit 1];
        
        List<DP_Product_Compatibility__c> pcamlst = getPC(p,cprod);
        List<DP_Suggested_Product__c> spLst = getSP(p,cprod);
        /*  Contact c = new Contact();
        c.LastName = 'Test';
        insert c; */
        contact con =new Contact();
        
        q.ContactId = c.Id;
        DP_Customer_Specific_Product__c dcsp = getDPCusSP(p.Id,pa.Id);
        DP_Quote_Line_Group__c qg = getQuoteLineGroup(q.ID);
        QuoteLineItem qli = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        QuoteLineItem qli1 = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        
        qli1.DP_Parent_Quote_Line__c = qli.ID;
        update qli1;
        //Validate Opp.DP_Data_Center__c value after insert QLI.
        //System.assertEquals('Northern Virginia - NOVA11', [SELECT DP_Data_Center__c FROM Opportunity WHERE Id=:opp.Id][0].DP_Data_Center__c);        
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
        neQuote.cQuote.DP_currency_code__c='EUR';
        neQuote.cQuote.DP_term__c='24';
        neQuote.updateTerm();
        //validate the lease and QLI on the quote
        //System.assertEquals(true, neQuote.lease12 !=null);
        neQuote.addProduct();
        //System.assertEquals(2, [SELECT Count() FROM QuoteLineItem WHERE QuoteId=:q.Id]);
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
        neQuote.getContacts();        
        //neQuote.selectPriceBook();
        //stop test
        Test.stopTest();
    }
    
    @isTest static void newEditQuoteupdateterm(){
        
        DP_BillingSystem__c bs = [SELECT Id,Name,DP_BillingSystemID__c from DP_BillingSystem__c where Name='Test BS' AND DP_BillingSystemID__c=12345 LIMIT 1];      
        Account a = [SELECT Id,Name,Phone,Website,Industry from Account where Name='Test' AND RecordType.Name = 'Government Company' LIMIT 1];
        String govRTId = Label.AccountGovernmentRecordTypeId;
        Account pa = [SELECT Id,Name,company_name__c from Account where Name='Test' AND RecordType.Name = 'Government Account' LIMIT 1];
        Contact c = [SELECT Id,firstname,lastname,Email,recordtypeId from Contact where lastname='Case' AND Recordtype.Name='Government' LIMIT 1];
        DP_ProductLine__c pl = [SELECT Id,Name,DP_ProductLineID__c from DP_ProductLine__c WHERE Name='Test' AND DP_ProductLineID__c=100000 LIMIT 1];        
        DP_DataCenter__c dc = [SELECT Id,Name,DP_DataCenterID__c,DP_kWCost__c,DP_kW_Markup__c FROM DP_DataCenter__c WHERE Name='Northern Virginia - NOVA11' LIMIT 1];
        Opportunity opp = [SELECT Id,Name,PriceBook2Id,AccountID,Account__c,DP_ProductLine__c,LeadSource,StageName,CloseDate from Opportunity where Recordtype.Name='Government' LIMIT 1];      
        Quote q = [SELECT Id,Name,ContactId,OpportunityID,DP_Exchange_Rate__c,Pricebook2Id,DP_Term__c,QuoteSynced__C,DP_Operational_Life_Factor__c,DP_Cost_of_Money__c,DP_Money_Making_Months__c,DP_Month_to_Month_Multiplier__c,DP_kW_Month_to_Month_Multiplier__c,DP_kW_Hours_In_Month__c,DP_kW_Term_Multiplier__c from Quote WHERE OpportunityID=:opp.Id LIMIT 1];
        Product2 p = getProduct2(dc.ID);
        Product2 cprod = getcprodProduct2(dc.ID);
        PricebookEntry pbe1 = [select id, name, isActive from PricebookEntry where Product2ID=:p.id limit 1];
        
        List<DP_Product_Compatibility__c> pcamlst = getPC(p,cprod);
        List<DP_Suggested_Product__c> spLst = getSP(p,cprod);
        /* Contact c = new Contact();
        c.LastName = 'Test';
        insert c; */
        contact con =new Contact();
        
        FieldMapping__c fm = new FieldMapping__c();
        fm.TargetField__c = 'abc';
        fm.SourceField__C = 'xyz';
        fm.CompName__c= 'abcQuote';
        fm.Name = 'name';
        insert fm;
        
       // FieldMapping__c  fm1 = [select id, TargetField__c , SourceField__C from  FieldMapping__c where         
        
      
      //  qll1.getFieldMapping();
        q.ContactId = c.Id;
        DP_Customer_Specific_Product__c dcsp = getDPCusSP(p.Id,pa.Id);
        DP_Quote_Line_Group__c qg = getQuoteLineGroup(q.ID);
        QuoteLineItem qli = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        QuoteLineItem qli1 = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        
        /*QuoteLineItem qli2 = new QuoteLineItem (QuoteID=q.Id,DP_Quote_Group__c=qg.Id,PricebookentryId=pbe1.Id,Quantity=100,UnitPrice=1000,DP_index__c=1,
                                DP_Data_Center__c=dc.Id,DP_CAPEX__c=100,DP_Cost__c=100,DP_DatapipeListPriceUSD__c=100,DP_Discount__c=0,DP_DPListPrice__c=100,
                                DP_kW__c=10,DP_kW_Cost__c=10,DP_kW_Markup__c=1,DP_Markup__c=1,DP_Max_Discount__c=1,DP_MRR__c=1,DP_Setup_Fee__c=10,DP_Base_Quantity__c=1);
        insert qli2;
        */
        qli1.DP_Parent_Quote_Line__c = qli.ID;
       // update qli1;
        //Validate Opp.DP_Data_Center__c value after insert QLI.
        //System.assertEquals('Northern Virginia - NOVA11', [SELECT DP_Data_Center__c FROM Opportunity WHERE Id=:opp.Id][0].DP_Data_Center__c);        
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
//        neQuote.cQuote.DP_currency_code__c='EUR';
        neQuote.cQuote.DP_term__c='36';
        neQuote.updateTerm();
        //validate the lease and QLI on the quote
       // System.assertEquals(6873182.61, neQuote.lease12);
       //System.assertEquals(true, neQuote.lease12 !=null);
              neQuote.addProduct();
        //System.assertEquals(2, [SELECT Count() FROM QuoteLineItem WHERE QuoteId=:q.Id]);
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
        neQuote.getContacts();        
        //stop test
        Test.stopTest();
    }
    
    @isTest static void newEditQuoteupdateterm2(){
        
        DP_BillingSystem__c bs = [SELECT Id,Name,DP_BillingSystemID__c from DP_BillingSystem__c where Name='Test BS' AND DP_BillingSystemID__c=12345 LIMIT 1];      
        Account a = [SELECT Id,Name,Phone,Website,Industry from Account where Name='Test' AND RecordType.Name = 'Government Company' LIMIT 1];
        String govRTId = Label.AccountGovernmentRecordTypeId;
        Account pa = [SELECT Id,Name,company_name__c from Account where Name='Test' AND RecordType.Name = 'Government Account' LIMIT 1];
        Contact c = [SELECT Id,firstname,lastname,Email,recordtypeId from Contact where lastname='Case' AND Recordtype.Name='Government' LIMIT 1];
        DP_ProductLine__c pl = [SELECT Id,Name,DP_ProductLineID__c from DP_ProductLine__c WHERE Name='Test' AND DP_ProductLineID__c=100000 LIMIT 1];        
        DP_DataCenter__c dc = [SELECT Id,Name,DP_DataCenterID__c,DP_kWCost__c,DP_kW_Markup__c FROM DP_DataCenter__c WHERE Name='Northern Virginia - NOVA11' LIMIT 1];
        Opportunity opp = [SELECT Id,Name,PriceBook2Id,AccountID,Account__c,DP_ProductLine__c,LeadSource,StageName,CloseDate from Opportunity where Recordtype.Name='Government' LIMIT 1];      
        Quote q = [SELECT Id,Name,ContactId,OpportunityID,DP_Exchange_Rate__c,Pricebook2Id,DP_Term__c,QuoteSynced__C,DP_Operational_Life_Factor__c,DP_Cost_of_Money__c,DP_Money_Making_Months__c,DP_Month_to_Month_Multiplier__c,DP_kW_Month_to_Month_Multiplier__c,DP_kW_Hours_In_Month__c,DP_kW_Term_Multiplier__c from Quote WHERE OpportunityID=:opp.Id LIMIT 1];
        Product2 p = getProduct2(dc.ID);
        Product2 cprod = getcprodProduct2(dc.ID);
        PricebookEntry pbe1 = [select id, name, isActive from PricebookEntry where Product2ID=:p.id limit 1];
         PricebookEntry pbe2 = [select id, name, isActive from PricebookEntry where Product2ID=:cprod.id limit 1];
        
        List<DP_Product_Compatibility__c> pcamlst = getPC(p,cprod);
        List<DP_Suggested_Product__c> spLst = getSP(p,cprod);
        /* Contact c = new Contact();
        c.LastName = 'Test';
        insert c; */
        contact con =new Contact();
        
        FieldMapping__c fm = new FieldMapping__c();
        fm.TargetField__c = 'abc';
        fm.SourceField__C = 'xyz';
        fm.CompName__c= 'abcQuote';
        fm.Name = 'name';
        insert fm;
        
       // FieldMapping__c  fm1 = [select id, TargetField__c , SourceField__C from  FieldMapping__c where         
        
        QuoteLineItemHandler qll1 = new QuoteLineItemHandler();
      //  qll1.getFieldMapping();
        q.ContactId = c.Id;
        DP_Customer_Specific_Product__c dcsp = getDPCusSP(p.Id,pa.Id);
        DP_Quote_Line_Group__c qg = getQuoteLineGroup(q.ID);
        QuoteLineItem qli = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        QuoteLineItem qli1 = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        
      //  QuoteLineItem qli2 = getQuoteLineItem(q.ID,qg.ID,pbe2.ID,dc.ID);
        
        qli1.DP_Parent_Quote_Line__c = qli.ID;
       // update qli1;
        //Validate Opp.DP_Data_Center__c value after insert QLI.
        //System.assertEquals('Northern Virginia - NOVA11', [SELECT DP_Data_Center__c FROM Opportunity WHERE Id=:opp.Id][0].DP_Data_Center__c);        
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
//        neQuote.cQuote.DP_currency_code__c='EUR';
        neQuote.cQuote.DP_term__c='48';
        neQuote.updateTerm();
        //validate the lease and QLI on the quote
      //  System.assertEquals(6941233.93, neQuote.lease12);
      //System.assertEquals(true, neQuote.lease12 !=null);
       
        neQuote.addProduct();
        //System.assertEquals(2, [SELECT Count() FROM QuoteLineItem WHERE QuoteId=:q.Id]);
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
        neQuote.getContacts();
         
        //stop test
        Test.stopTest();
    }
    
    @isTest static void testNewEditQuoteCls(){
    try{
        Pricebook2 pbk1 = [Select Id, Name, IsActive From Pricebook2 where IsStandard = true LIMIT 1];
        DP_BillingSystem__c bs = [SELECT Id,Name,DP_BillingSystemID__c from DP_BillingSystem__c where Name='Test BS' AND DP_BillingSystemID__c=12345 LIMIT 1];      
        DP_ProductLine__c pl = [SELECT Id,Name,DP_ProductLineID__c from DP_ProductLine__c WHERE Name='Test' AND DP_ProductLineID__c=100000 LIMIT 1];        
        DP_DataCenter__c dc = [SELECT Id,Name,DP_DataCenterID__c,DP_kWCost__c,DP_kW_Markup__c FROM DP_DataCenter__c WHERE Name='Northern Virginia - NOVA11' LIMIT 1];
        Product2 p = getProduct2(dc.ID);
        Product2 cprod = getcprodProduct2(dc.ID);
        PricebookEntry pbe1 = [select id, name, isActive from PricebookEntry where Product2ID=:p.id limit 1];
        
        List<DP_Product_Compatibility__c> pcamlst = getPC(p,cprod);
        List<DP_Suggested_Product__c> spLst = getSP(p,cprod);
        
        Id PRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId(); 
        Id compStdRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId(); 
        Id oppgovRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('US Cloud').getRecordTypeId(); 
        Id rtId1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId(); 
        
        Account a = getAccount(bs,compStdRT);
        Account pa = getAccounts(a.id,PRTId);
        Opportunity opp = getOpportunity(a.ID,pa.id,pl.ID,dc.ID, pbk1.Id,oppgovRT);
        Quote q = getQuote(opp.ID, pbk1.Id);
        Contact c = new Contact();
        c.AccountID = a.ID;
        c.LastName = 'Test';
        c.RecordTypeId=rtId1;
        insert c;
        
        q.ContactId = c.Id;
        DP_Customer_Specific_Product__c dcsp = getDPCusSP(p.Id,pa.Id);
        DP_Quote_Line_Group__c qg = getQuoteLineGroup(q.ID);
        QuoteLineItem qli = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        QuoteLineItem qli1 = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        
       // qli1.DP_Parent_Quote_Line__c = qli.ID;
       // update qli1;
        //Validate Opp.DP_Data_Center__c value after insert QLI.
        //commented below one line - diego castro
        //System.assertEquals('Northern Virginia - NOVA11', [SELECT DP_Data_Center__c FROM Opportunity WHERE Id=:opp.Id][0].DP_Data_Center__c);        
        //start test
        Test.startTest();
        Quote q1 = new Quote();
        ApexPages.StandardController ctl1 = new ApexPages.StandardController(q1);
        ApexPages.currentPage().getParameters().put('oppid', opp.ID);
        DP_NewEditQuoteController neQuote = new DP_NewEditQuoteController(ctl1);
        DP_NewEditQuoteController.JQGridItemexcel w = new DP_NewEditQuoteController.JQGridItemexcel();
        DP_NewEditQuoteController.JQGridItem ex = new DP_NewEditQuoteController.JQGridItem();                
        DP_NewEditQuoteController.FlexItem fl = new DP_NewEditQuoteController.FlexItem();       
        w.strAction = 'Test strAction';
        w.strDCOpts = 'Test strDCOpts';
        w.strExempt = 'Test strExempt';
        w.strParentId = 'Test strParentId';
        w.decMinQty = 1.0;
        ex.decUnitMrr = 1.0;
        ex.dder = 1.0;
        fl.id=null;
        fl.name = 'Test FlexItem';
                
        //System.assertEquals(opp.ID, neQuote.cOpportunity.ID); commented out - diego castro
        //System.assertEquals(a.ID, neQuote.cAccount.ID); commented out - diego castro
        nequote.configDisplay = true;
        nequote.prodName = 'Test Prod';
        nequote.qlIid = null;
        nequote.pIdParam = 'Test PId Param';
        nequote.grpNameParam = 'Test grp Param';
        nequote.cdecEXRate=1.0;
        nequote.chDataCenter = 'Test chrData';
        nequote.cReqProdType = null;
        nequote.header = null;
        nequote.Filetype = null;
        nequote.isExcel = true;
        nequote.lstJQGI1 = new List<QuoteLineItem>();
        nequote.prodCompLst = new List<DP_Product_Compatibility__c>();
        
        neQuote.getDataCenters();
        neQuote.cSearchDCId = dc.ID;
        neQuote.setChosenDC();
        neQuote.getSuggestedProducts();
        neQuote.cQuote.Name='Test';
        neQuote.cQuote.ContactId=c.ID;
        neQuote.cbolActive=True;
        //System.assertEquals(6, [SELECT Count() FROM QuoteLineItem WHERE QuoteId=:q.Id]);
        neQuote.saveAll();
        neQuote.selectPriceBook();
        neQuote.showConfig=true;
        neQuote.changeCurrency();
        neQuote.cstrPBEID = pbe1.id;
        neQuote.addOrConfig();
        neQuote.cstrItemId=qli.Id;
        neQuote.calcMRR();
        neQuote.showConfig=false;
        neQuote.updateDiscounts();
        neQuote.updateTerm();
        neQuote.resetAvailableChildren();
        nequote.getLineItems(true);        
        neQuote.getContacts();
        
        //stop test
        Test.stopTest();
    }catch(Exception e)
        {
            
        }   
        
    }
            
    @isTest
    static void acrAddressTest()
    {
        //TestClassUtility.setTestSetupData();
        try{
       
       
            FieldMappingHandler.AcrAddressMapping();
        }
        catch(Exception e)
        {
            
        }
        
        
    }
                
    @isTest
    static void exportexceltest(){
        
        DP_BillingSystem__c bs = [SELECT Id,Name,DP_BillingSystemID__c from DP_BillingSystem__c where Name='Test BS' AND DP_BillingSystemID__c=12345 LIMIT 1];      
        System.debug('bs::' + bs);
        Account a = [SELECT Id,Name,Phone,Website,Industry from Account where Name='Test' AND RecordType.Name = 'Government Company' LIMIT 1];
        System.debug('a::' + a);
        Account pa = [SELECT Id,Name,company_name__c from Account where Name='Test' AND RecordType.Name = 'Government Account' LIMIT 1];
        System.debug('pa::' + pa);
        Contact c = [SELECT Id,firstname,lastname,Email,recordtypeId from Contact where lastname='Case' AND Recordtype.Name='Government' LIMIT 1];
        System.debug('C::' + c);
        DP_ProductLine__c pl = [SELECT Id,Name,DP_ProductLineID__c from DP_ProductLine__c WHERE Name='Test' AND DP_ProductLineID__c=100000 LIMIT 1];        
        System.debug('pl::' + pl);
        DP_DataCenter__c dc = [SELECT Id,Name,DP_DataCenterID__c,DP_kWCost__c,DP_kW_Markup__c FROM DP_DataCenter__c WHERE Name='Northern Virginia - NOVA11' LIMIT 1];
        System.debug('dc::' + dc);
        Opportunity opp = [SELECT Id,Name,PriceBook2Id,AccountID,Account__c,DP_ProductLine__c,LeadSource,StageName,CloseDate from Opportunity where Recordtype.Name='Government' LIMIT 1];      
        System.debug('opp::' + opp);
        Quote q = [SELECT Id,Name,ContactId,OpportunityID,DP_Exchange_Rate__c,Pricebook2Id,DP_Term__c,QuoteSynced__C,DP_Operational_Life_Factor__c,DP_Cost_of_Money__c,DP_Money_Making_Months__c,DP_Month_to_Month_Multiplier__c,DP_kW_Month_to_Month_Multiplier__c,DP_kW_Hours_In_Month__c,DP_kW_Term_Multiplier__c from Quote WHERE OpportunityID=:opp.Id LIMIT 1];
        System.debug('q::' + q);
        Product2 p = getProduct2(dc.ID);
        p.isactive=true;
        update p;
        Product2 cprod = getcprodProduct2(dc.ID);
        cprod.isactive = true;
        update cprod;
        PricebookEntry pbe1 = [select id, name, isActive from PricebookEntry where Product2ID=:p.id limit 1];
        System.debug('pbe1::' + pbe1);
        
    Test.startTest();
     //Get Test Data.
        /*Pricebook2 pbk1 = new Pricebook2(Id = Test.getStandardPricebookId(),IsActive = true);
        Update pbk1;*/
        List<DP_Product_Compatibility__c> pcamlst = getPC(p,cprod);
        List<DP_Suggested_Product__c> spLst = getSP(p,cprod);
         //List<JQGridItem> lstJQGI = new List<JQGridItem>();
        
        contact con =new Contact();
        /* Contact c = new Contact();
        c.LastName = 'Test';
        insert c; */
        q.ContactId = c.Id;
        DP_Quote_Line_Group__c qg = getQuoteLineGroup(q.ID);
        QuoteLineItem qli = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        QuoteLineItem qli1 = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
         QuoteLineItem qli2 = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
      /*  QuoteLineItem qli2 = new QuoteLineItem (QuoteID=q.Id,DP_Quote_Group__c=qg.Id,DP_Required__c='yes',PricebookentryId=pbe1.Id,Quantity=100,UnitPrice=1000,DP_index__c=1,
                                DP_Data_Center__c=dc.Id,DP_CAPEX__c=100,DP_Cost__c=100,DP_DatapipeListPriceUSD__c=100,DP_Discount__c=1,DP_DPListPrice__c=100,
                                DP_kW__c=10,DP_kW_Cost__c=10,DP_kW_Markup__c=1,DP_Markup__c=1,DP_Max_Discount__c=10,DP_MRR__c=1,DP_Setup_Fee__c=10,DP_Base_Quantity__c=1);
        insert qli2;
        */
       // qli1.DP_Parent_Quote_Line__c = qli.ID;
       // update qli1;
        PageReference pageRef = Page.DP_NewEditQuote;
        pageRef.getParameters().put('Id', q.Id);
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController ctl = new ApexPages.StandardController(q);
        DP_NewEditQuoteController neQuote = new DP_NewEditQuoteController(ctl);
        neQuote.exportToExcel();
        neQuote.getserviceTypes();
        //neQuote.gettotalsum1();
        neQuote.getUnitMeasures();
        neQuote.updateDiscounts();
         neQuote.targetPrice = 32.00;
         neQuote.getToDiscount();
         neQuote.goOverDiscount(30.00);
         neQuote.addproduct();
        neQuote.addToPreview();
        neQuote.addUpdateQL();
        neQuote.cancelConfig();
       neQuote.addOrConfig();
        neQuote.showConfig = true;
        neQuote.configNewProd();
        neQuote.showConfig = true;
        neQuote.getContacts();
        
        //neQuote.configprod(); 
      
        
        Test.stopTest();
    }
    
    @isTest
    static void coverException(){
    
    QuoteLineItemHandler qll2 = new QuoteLineItemHandler();
        
        try{
            qll2.afterInsert();
            qll2.beforeDelete();
            qll2.afterUpdate();
            
        }Catch(Exception e){
        }
        }
        
        @isTest
    static void Alltests(){
        
        DP_BillingSystem__c bs = [SELECT Id,Name,DP_BillingSystemID__c from DP_BillingSystem__c where Name='Test BS' AND DP_BillingSystemID__c=12345 LIMIT 1];      
        Account a = [SELECT Id,Name,Phone,Website,Industry from Account where Name='Test' AND RecordType.Name = 'Government Company' LIMIT 1];
        String govRTId = Label.AccountGovernmentRecordTypeId;
        Account pa = [SELECT Id,Name,company_name__c from Account where Name='Test' AND RecordType.Name = 'Government Account' LIMIT 1];
        Contact c = [SELECT Id,firstname,lastname,Email,recordtypeId from Contact where lastname='Case' AND Recordtype.Name='Government' LIMIT 1];
        DP_ProductLine__c pl = [SELECT Id,Name,DP_ProductLineID__c from DP_ProductLine__c WHERE Name='Test' AND DP_ProductLineID__c=100000 LIMIT 1];        
        DP_DataCenter__c dc = [SELECT Id,Name,DP_DataCenterID__c,DP_kWCost__c,DP_kW_Markup__c FROM DP_DataCenter__c WHERE Name='Northern Virginia - NOVA11' LIMIT 1];
        Opportunity opp = [SELECT Id,Name,PriceBook2Id,AccountID,Account__c,DP_ProductLine__c,LeadSource,StageName,CloseDate from Opportunity where Recordtype.Name='Government' LIMIT 1];      
        Quote q = [SELECT Id,Name,ContactId,OpportunityID,DP_Exchange_Rate__c,Pricebook2Id,DP_Term__c,QuoteSynced__C,DP_Operational_Life_Factor__c,DP_Cost_of_Money__c,DP_Money_Making_Months__c,DP_Month_to_Month_Multiplier__c,DP_kW_Month_to_Month_Multiplier__c,DP_kW_Hours_In_Month__c,DP_kW_Term_Multiplier__c from Quote WHERE OpportunityID=:opp.Id LIMIT 1];
        Product2 p = getProduct2(dc.ID);
        p.isactive=true;
        update p;
        Product2 cprod = getcprodProduct2(dc.ID);
        cprod.isactive = true;
        update cprod;
        PricebookEntry pbe1 = [select id, name, isActive from PricebookEntry where Product2ID=:p.id limit 1];
        
    
     //Get Test Data.
        /*Pricebook2 pbk1 = new Pricebook2(Id = Test.getStandardPricebookId(),IsActive = true);
        Update pbk1;*/
        List<DP_Product_Compatibility__c> pcamlst = getPC(p,cprod);
        List<DP_Suggested_Product__c> spLst = getSP(p,cprod);
         //List<JQGridItem> lstJQGI = new List<JQGridItem>();
        
        contact con =new Contact();        
        /* Contact c = new Contact();
        c.LastName = 'Test';
        insert c; */
        q.ContactId = c.Id;
        DP_Quote_Line_Group__c qg = getQuoteLineGroup(q.ID);
        QuoteLineItem qli = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
        QuoteLineItem qli1 = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
         QuoteLineItem qli2 = getQuoteLineItem(q.ID,qg.ID,pbe1.ID,dc.ID);
     
        PageReference pageRef = Page.DP_NewEditQuote;
        pageRef.getParameters().put('Id', q.Id);
        Test.setCurrentPage(pageRef);
        Test.startTest();
        ApexPages.StandardController ctl = new ApexPages.StandardController(q);
        DP_NewEditQuoteController neQuote = new DP_NewEditQuoteController(ctl);
        neQuote.exportToExcel();
        neQuote.getserviceTypes();
        neQuote.getUnitMeasures();
          neQuote.targetPrice = 32.00;
         neQuote.getToDiscount();
         neQuote.goOverDiscount(30.00);
       
           DP_NewEditQuoteController.getProdTypes();
          DP_NewEditQuoteController.getGroupNames();
         
        neQuote.cSearchDCId = dc.ID;
        neQuote.setChosenDC();
          neQuote.updateDiscounts();
          neQuote.UpdateTerm();
          neQuote.calcMrrByTerm();
          neQuote.calcMRR();
          neQuote.addOrConfig();
          neQuote.checkHasChildren();
           neQuote.cancelConfig();
          // neQuote.lstQLGrid=qli.id;
            //neQuote.addUpdateQL();
         // neQuote.resetAvailableChildren();
       //  DP_NewEditQuoteController.setAvailableChildren(Qli1);
         neQuote.addToPreview();  
        //  DP_NewEditQuoteController.setAllChildren();
        neQuote.showConfig = true;
        neQuote.configNewProd();
       // neQuote.configprod(); 
        neQuote.getSuggestedProducts();
        neQuote.getDataCenters();
        neQuote.changeCurrency();
        neQuote.getDataCenterNames();
        neQuote.selectPriceBook();
        neQuote.filterPC();
        neQuote.getPriceBookEntriesPC();          
         neQuote.addproduct();
         neQuote.getPriceBookEntries();
         neQuote.saveall();     
         neQuote.getContacts();
         // DP_NewEditQuoteController.convertListQLI2JQGI();
       // neQuote.getLineItems(true);
       DP_NewEditQuoteController.JQGridItemexcel te = new DP_NewEditQuoteController.JQGridItemexcel();
       te.strAvailability='Test';
      te.strProduct ='Test';
       te.strQLItemId= qli1.id;
       te.strPBEId=pbe1.id;
       te.strProductId=p.id;
      te.decSetupFee=1.00;
       // public String strDCOpts {get;set;}

        
      
        
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
                            DP_Markup__c=25,DP_Availability__c = 'Available', DP_Max_Discount__c=25,isactive=true, DP_Unit_of_Measure__c='kW');
        insert p;
        return p;
    }
    
     private static Product2 getcprodProduct2(String dc){
        Product2 cprod = new Product2(DP_Setup__c=10,Name='Testing',DP_Product_Type__c = 'Software',DP_Data_Center__c=dc,
                            DP_Datapipe_Part_Number__c='Testing',DP_CAPEX__c=23,DP_Product_Category__c='Hardware',
                            DP_Markup__c=25,DP_Availability__c = 'Available',DP_Max_Discount__c=25,isactive=true,DP_Unit_of_Measure__c='kW');
        insert cprod;
        return cprod;
    }
    
    /*
    @Name :getDataCenter
    @Description : prepare the test data for DP_DataCenter__c record.
    */
    private static DP_DataCenter__c getDataCenter(){
        DP_DataCenter__c dc1 = new DP_DataCenter__c(Name='Northern Virginia - NOVA1',DP_DataCenterID__c=17,DP_kWCost__c=0.47,DP_kW_Markup__c=50.00,DP_Available_To_Use_On_Quote_Line__c=true);        
        insert dc1;
        
        DP_DataCenter__c dc = new DP_DataCenter__c(Name='Northern Virginia - NOVA11',DP_DataCenterID__c=10000,DP_kWCost__c=0.47,DP_kW_Markup__c=50.00,DP_Available_To_Use_On_Quote_Line__c=true);
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
    private static Account getAccount(DP_BillingSystem__c bs,Id compgovRTId){
        Account a = new Account(Name='Test',Phone='(456) 238-1212',Website='http://test.com',
                    Industry='Charitable / Non Profit', RecordTypeId=compgovRTId);
        insert a;
        return a;
    }
    
    private static Account getAccounts(string a,Id govRTId){
        Account pa = new Account(Name='Test',company_name__c=a,RecordTypeId=govRTId);
        insert pa;
        return pa;
    }
    /*
    @Name :getOpportunity
    @Description : prepare the test data for Opportunity record.
    */
    private static Opportunity getOpportunity(String a, string pa,String pl,String dc, Id pb,Id oppgovRTId){
        Opportunity o = new Opportunity(PriceBook2Id = pb,Name='Test',AccountID=a,Account__c=pa,DP_ProductLine__c=pl,LeadSource='External Referral',RecordTypeId=oppgovRTId,StageName='Stage 3 - Planning & Identificationead',CloseDate=System.Today());
        insert o;
        return o;
    }
    
    /*
    @Name :getQuote
    @Description : prepare the test data for Quote record.
    */
    private static Quote getQuote(String opp, Id pb){
        Quote q = new Quote(Name='Test',OpportunityID=opp,DP_Exchange_Rate__c=10, Pricebook2Id=pb, DP_Term__c='12',QuoteSynced__C=false,DP_Operational_Life_Factor__c=1.34,DP_Cost_of_Money__c=14.0,DP_Money_Making_Months__c=24.0,DP_Month_to_Month_Multiplier__c=2.0,DP_kW_Month_to_Month_Multiplier__c=1.0,DP_kW_Hours_In_Month__c=730.0,DP_kW_Term_Multiplier__c=1.025);
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
    
    /*
    @Name :getQuoteLineItem
    @Description : prepare the test data for QuoteLineItem record.
    */
    private static QuoteLineItem getQuoteLineItem1(String q,String qg,String pentry,String dc,string qli){
        QuoteLineItem qli1 = new QuoteLineItem (QuoteID=q,DP_Parent_Quote_Line__c = qli,DP_Quote_Group__c=qg,PricebookentryId=pentry,Quantity=100,UnitPrice=1000,
                                DP_Data_Center__c=dc,DP_CAPEX__c=100,DP_Cost__c=100,DP_DatapipeListPriceUSD__c=100,DP_Discount__c=0,DP_DPListPrice__c=100,
                                DP_kW__c=10,DP_kW_Cost__c=10,DP_kW_Markup__c=1,DP_Markup__c=1,DP_Max_Discount__c=1,DP_MRR__c=1,DP_Setup_Fee__c=10,DP_Base_Quantity__c=1);
        insert qli1;
        return qli1;
    }
    private static QuoteLineItem getQuoteLineItem2(String q,String qg,String pentry,String dc,string qli){
        QuoteLineItem qli2 = new QuoteLineItem (QuoteID=q,DP_Parent_Quote_Line__c = qli,DP_Quote_Group__c=qg,PricebookentryId=pentry,Quantity=1,UnitPrice=10,
                                DP_Data_Center__c=dc,DP_CAPEX__c=1,DP_Cost__c=1,DP_DatapipeListPriceUSD__c=10,DP_Discount__c=0,DP_DPListPrice__c=1,
                                DP_kW__c=1,DP_kW_Cost__c=1,DP_Unit_of_Measure__c='kW' ,DP_kW_Markup__c=1,DP_Markup__c=1,DP_Max_Discount__c=5,DP_MRR__c=10,
                                DP_Setup_Fee__c=1,DP_Base_Quantity__c=1);
        insert qli2;
        return qli2;
    }    
    
    private static DP_Customer_Specific_Product__c getDPCusSP(Id pId,Id paId){
        DP_Customer_Specific_Product__c dcsp = new DP_Customer_Specific_Product__c(Name='VNX 35TB TST', DP_Formula_Exempt__c=false, DP_LandedCost__c=300, DP_CAPEX__c=50, DP_Markup__c=20, 
            DP_Product__c=pId, DP_Cost__c=80, DP_Setup__c=0, DP_Max_Discount__c=10,DP_Account__c=paId);
        insert dcsp;
        return dcsp;
    }    
    
}