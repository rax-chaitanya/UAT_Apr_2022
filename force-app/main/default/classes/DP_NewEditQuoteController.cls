/*
@Name            : NewEditQuoteController
@Author          : customersuccess@cloud62.com
@Date            : July 16, 2013
@Description     : Controller for NewQuote page
*/
public class DP_NewEditQuoteController{
    //Class variables
    public Boolean cDynamic {get;set;}
    public String cServiceType {get;set;}
    public Decimal targetPrice {get;set;}
    public String cselQuoteGroup {get;set;}
    public String cstrQuoteGroup {get;set;}
    public List<SelectOption> cQuoteGroups {get;set;}
    private List<DP_Quote_Line_Group__c> lstQLG;
    private Integer cIntIndex {get;set;}
    private Map<String,DP_Quote_Line_Group__c> mapQLGs {get;set;}
    private Decimal cParentIndex {get;set;}
    private Decimal cGroupIndex {get;set;}
    public String cstrGroupName {get;set;}
    public List<SelectOption> clstGroupNames {get;set;}
    public Decimal cTotSetFee {get;set;}
    public Boolean hasChildren {get;set;}
    public Boolean showConfig {get;set;}
    public String strAddRowId {get;set;}
    private Map<String,Map<String,JQGridItem>> mapTypeChild {get;set;}
    private Map<String,Map<String,JQGridItem>> mapTypeReqChild {get;set;}
    private Map<String,Map<String,JQGridItem>> mapTypeChildDisplay {get;set;}
    private Map<String,Map<String,JQGridItem>> mapTypeReqChildDisplay {get;set;}
    public String cstrConfigProdType {get;set;}
    public String cstrConfigReqProdType {get;set;}
    public List<SelectOption> clstConfigProdTypes {get;set;}
    public List<SelectOption> clstConfigReqProdTypes {get;set;}
    public String cConfigName {get;set;}
    public String cstrPBEID {get;set;}
    public Decimal cOveragePrice {get;set;}
    public String cUnit {get;set;}
    public String cstrItemId {get;set;}
    public Quote cQuote {get;set;}
   // public Account cAccount {get;set;}
    public Account cAccount {get;set;}
    public Opportunity cOpportunity {get;set;}
    public String cSearchProd{get;set;}
    public List<SelectOption> clstProdTypes {get;set;}
    public Boolean cbolActive {get;set;}
    public String strJSONQLGrid {get;set;}
    public String strJSONConfigGrid {get;set;}
    public String strJSONPreviewGrid {get;set;}
    public String cSearchPBEId {get;set;}
    public Boolean configDisplay{get;set;}
    public List<DP_Product_Compatibility__c> prodCompLst{get;set;}
    public Map<Id, DP_Customer_Specific_Product__c> cCustSpecProdMap{get;set;}
    public String prodName{get;set;}
    public String qlIid{get;set;}
    public String pIdParam{get;set;}
    public String grpNameParam{get;set;}
    public String pbeRecId{get;set;}
    public String strParentQLIId {get;set;}
    private integer cIntGridIndex {get;set;}
    public Decimal cdecEXRate {get;set;}
    private DP_PricingSettings__c cPriceSettings {get;set;}
    private Map<String,String> allExistingGrp = new Map<String,String>();
    private DP_DataCenter__c cDefaultDC {get;set;}
    private DP_DataCenter__c cChosenDC {get;set;}
    public Decimal lease1{get;set;}
    public Decimal lease12{get;set;}
    public Decimal lease24{get;set;}
    public Decimal lease36{get;set;}
    public Decimal lease48{get;set;}
    public Decimal lease60{get;set;}
    public String cSearchDCId{get;set;}
    public String chDataCenter{get;set;}
    public String cReqProdType {get;set;}
    public string header{get;set;}
    public string Filetype{get;set;}
    public boolean isExcel {get;set;}
    public List<JQGridItemexcel> lstJQGridItem {get; set;}
     public List<QuoteLineItem> lstJQGI1 {get; set;}
    
     /*
    @Name   :JQGridItemexcel
    @Description :Wrapper class for jqgridexcel row
    */
     public class JQGridItemexcel{       
        public String strAction {get;set;}
        public String strAvailability {get;set;}
        public String strProduct {get;set;}
        public String strQLItemId{get;set;}
        public String strPBEId{get;set;}
        public String strProductId{get;set;}
        public Decimal decSetupFee{get;set;}
        public String strDCOpts {get;set;}
        public String strExempt {get;set;}
         public String strParentId {get;set;}
       public String strDataCenter {get;set;}
        public Decimal decMRR {get;set;}
        public Decimal decQty {get;set;}
        public Decimal decMinQty {get;set;}
        public Decimal baseQty {get;set;}
           public Decimal maxDiscount {get;set;}
        public Decimal decDiscount {get;set;}
        public Decimal decUnitMrr {get;set;}
        public Decimal decCAPEX {get;set;}
        public Decimal Totalprice {get;set;}
         public String StrLineItemGroup  {get;set;}
    }
    /*
    @Name   :JQGridItem
    @Description :Wrapper class for jqgrid row
    */
    public class JQGridItem{
        public Decimal decOveragePrice {get;set;}
        public String strUnit {get;set;}
        public String strServiceType {get;set;}
        public String strAction {get;set;}
        public String strAvailability {get;set;}
        public Boolean Isprodactive {get;set;}
        public String strProduct {get;set;}
        public String strDataCenter {get;set;}
        public Decimal decMRR {get;set;}
        public Decimal decQty {get;set;}
        public Decimal decMinQty {get;set;}
        
        public Decimal decMaxQty {get;set;}
        public Decimal decIncQty {get;set;}
        public Decimal decCAPEX {get;set;}
        public String strGroupName {get;set;}
        public String strQLItemId{get;set;}
        public String strPBEId{get;set;}
        public String strProductId{get;set;}
        public Decimal decSetupFee{get;set;}
        public String strDCOpts {get;set;}
        public String strExempt {get;set;}
        
        public Decimal decLandedCost {get;set;}
        public Decimal decUSDMRR {get;set;}
        public Decimal decKW {get;set;}
        public Decimal decCost {get;set;}
        public Decimal decMarkup {get;set;}
        public Decimal maxDiscount {get;set;}
        public Decimal decDiscount {get;set;}
        public String strParentId {get;set;}
        public Decimal decDPLPUSD {get;set;}
        public Decimal decKWCost {get;set;}
        
        public Decimal decKWMarkup {get;set;}
        public String strIsParent {get;set;}
        public String strQLIName {get;set;}
        public String strProdType {get;set;}
        public String strRequired {get;set;}
        public Decimal baseQty {get;set;}
        public Decimal decParentQty {get;set;}
        public String strProdCat {get;set;}
        public String strProdCompatId {get;set;}
        public Decimal decPreviousQty {get;set;}
        
        public Decimal decUnitMrr {get;set;}
        public Decimal decTypeOrder {get;set;}
        public Decimal decGroupOrder {get;set;}
        public Decimal dder {get;set;}
        public String isDynamic {get;set;}
        public Decimal decParentOrder {get;set;}
        public String strAssetAction {get;set;}
        public Decimal decOrigQty {get;set;}
    }
        
    /*
    @Name        :FlexItem
    @Description :Class to represent flexbox item that will be used in JSON for the flexboxes
    */
    public class FlexItem{
        public String id {get;set;}
        public String name {get;set;}
    }
    
    /*
    @Name        :FlexItemSource
    @Description :Class to represent flexbox source
    */
    public class FlexItemSource{
        public List<FlexItem> results {get;set;}
    }
    
    /*
    @Name   :NewEditQuoteController
    @Description :Constructor
    */
    public DP_NewEditQuoteController(ApexPages.StandardController sc){
        cUnit = '';
        cOveragePrice = 0;
        cDynamic = false;
        cIntIndex = 0;
        clstProdTypes = getProdTypes();
        cSearchProd = clstProdTypes.get(0).getValue();
        clstGroupNames = getGroupNames();
        if(clstGroupNames.size() > 0){
            cstrGroupName = clstGroupNames.get(0).getValue();
        } else {
            clstGroupNames.add(new SelectOption('Details','Details'));
            cstrGroupName = 'Details';
        }
        strJSONConfigGrid = JSON.serialize(new List<JQGridItem>());
        strJSONPreviewGrid = JSON.serialize(new List<JQGridItem>());
        cDefaultDC = [SELECT Id, Name,DP_Name_Abbr__c, DP_kWCost__c, DP_kW_Markup__c FROM DP_DataCenter__c WHERE Name = 'Northern Virginia - NOVA1'];
        cPriceSettings = DP_PricingSettings__c.getOrgDefaults();
        cIntGridIndex = 0;
        hasChildren = false;
        showConfig = false;
        lease1 = 0;
        lease12 = 0;
        lease24 = 0;
        lease36 = 0;
        lease48 = 0;
        lease60 = 0;
        cQuote = (Quote)sc.getRecord();
        cbolActive = false;
        mapQLGs = new Map<String,DP_Quote_Line_Group__c>();
        cGroupIndex = 0;
        cQuoteGroups = new List<SelectOption>();
        cQuoteGroups.add(new SelectOption('','--None--'));
        if(cQuote.Id!=null){
            //Initalize the indexes for the groups
            List<DP_Quote_Line_Group__c> lstQLG = [SELECT Id,Name,DP_Order__c,DP_Quote__c FROM DP_Quote_Line_Group__c where DP_Quote__c = :cQuote.Id Order By Name ASC];
            Boolean bolNoIndex = false;
            Set<Decimal> setIndex = new Set<Decimal>();
            List<Decimal> lstIndex = new List<Decimal>();
            for(DP_Quote_Line_Group__c qlg : lstQLG){
                if(qlg.DP_Order__c == null){bolNoIndex = true;} 
                else {
                    setIndex.add(qlg.DP_Order__c);
                    lstIndex.add(qlg.DP_Order__c);
                    if(cGroupIndex <= qlg.DP_Order__c){
                        cGroupIndex = qlg.DP_Order__c + 1;
                    }
                }
                mapQLGs.put(qlg.Name,qlg);
            }
            if(bolNoIndex || setIndex.size() != lstIndex.size()){ //If any groups have no index or duplicate indexes then reassign all the ordering
                cGroupIndex = 0;
                for(DP_Quote_Line_Group__c qlg : lstQLG){
                    qlg.DP_Order__c = cGroupIndex++;
                }
            }
            cQuote = [SELECT Id,Name,DP_Asset_Change__c,Opportunity.Account__c,OpportunityId,DP_Term__c,PriceBook2Id, DP_Month_to_Month_Multiplier__c,DP_Exchange_Rate__c,DP_Operational_Life_Factor__c,
                      DP_Cost_of_Money__c,DP_Money_Making_Months__c,DP_Currency_Code__c,DP_kW_Hours_In_Month__c,DP_kW_Month_to_Month_Multiplier__c,DP_kW_Term_Multiplier__c,
                      DP_Discount__c,ContactId,Contact.Name ,Opportunity.type,Opportunity.DP_current_mrr__C     
                      FROM Quote
                      Where Id = :cQuote.Id];
            if(cQuote.DP_Discount__c == null){
                        cQuote.DP_Discount__c =0;
                }
              /*  if(cQuote.DPAccount__c == null){
                        cQuote.DPAccount__c =cQuote.opportunity.Account__c;
                }
               */
               
      
            cOpportunity = [SELECT Id,Name,AccountId,   Account__c,SyncedQuoteId,PriceBook2Id ,DP_current_mrr__C,type, 
                            (SELECT Id FROM Quotes) FROM Opportunity 
                            WHERE Id = :cQuote.OpportunityId];
                            if (cOpportunity.DP_current_mrr__C ==null &&(cOpportunity.type =='Renewal' || cOpportunity.type== 'Renewal - Downgrade' || cOpportunity.type=='Renewal - Straight' || cOpportunity.type =='Renewal - Upgrade'))
     {
     
      ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,(' \"Existing Solution MRR\" on Opportunity cannot be null when the Opportunity is from a \"Renewal\" type.Please update the missing field BEFORE creating or editing the quote . '));//Same old drama 
              ApexPages.addMessage(myMsg);
             // return null;
     }
           /* List<Account> lstAcc = [SELECT Id,Name,Phone,Website 
                        FROM Account 
                        WHERE Id = :cOpportunity.AccountId];*///commented to bring account from  product account(Account__C)
                        
           List<Account> lstAcc = [SELECT Id,Name,Website
                        FROM Account 
                        WHERE Id = :cOpportunity.Account__c];
            if(lstAcc.size() > 0){
                cAccount = lstAcc.get(0);
            } else {
                cAccount = new Account();
            }
            lstQLG = [SELECT Id,Name FROM DP_Quote_Line_Group__c WHERE DP_Quote__c = :cQuote.Id Order By DP_Order__c ASC];
            for(DP_Quote_Line_Group__c qlg : lstQLG){
                if(qlg.Name != 'Change' && qlg.Name != 'Remove'){
                    cQuoteGroups.add(new SelectOption(qlg.Name,qlg.Name));
                }
            }
            if(cQuote.DP_Exchange_Rate__c == null) cQuote.DP_Exchange_Rate__c = 1;
            if(cOpportunity.SyncedQuoteId == cQuote.Id) cbolActive = true;
        } else {
            String oppId = ApexPages.currentPage().getParameters().get('oppid');
            cOpportunity = [SELECT Id,Name,AccountId,Account__c,SyncedQuoteId,PriceBook2Id  ,type,DP_current_mrr__C,
                            (SELECT Id FROM Quotes) FROM Opportunity 
                            WHERE Id = :oppId];
                            if(cOpportunity.quotes.size()==0)cbolActive = true;
                            
      if (cOpportunity.DP_current_mrr__C ==null &&(cOpportunity.type =='Renewal' || cOpportunity.type== 'Renewal - Downgrade' || cOpportunity.type=='Renewal - Straight' || cOpportunity.type =='Renewal - Upgrade'))
     {
     
      ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'"Existing Solution MRR" on Opportunity cannot be null when the Opportunity is from a "Renewal" type. Please update the missing field BEFORE creating or Editing the quote .');// jira tkt 123
              ApexPages.addMessage(myMsg);
             // return null;
     }
           /* List<Account> lstAcc = [SELECT Id,Name,Phone,Website 
                        FROM Account 
                        WHERE Id = :cOpportunity.AccountId];
            if(lstAcc.size() > 0){
                cAccount = lstAcc.get(0);
            } else {
                cAccount = new Account();
            }*/
            List<Account> lstAcc = [SELECT Id,Name,Website
                        FROM Account 
                        WHERE Id = :cOpportunity.Account__c];
            if(lstAcc.size() > 0){
                cAccount = lstAcc.get(0);
            } else {
                cAccount = new Account();
            }
            cQuote.DP_Operational_Life_Factor__c = cPriceSettings.DP_OperationalLifeFactor__c;
            cQuote.DP_kW_Hours_In_Month__c = cPriceSettings.DP_kWHoursInMonth__c;
            cQuote.DP_Cost_of_Money__c = cPriceSettings.DP_CostOfMoney__c;
            cQuote.DP_Money_Making_Months__c = cPriceSettings.DP_MoneyMakingMonths__c;
            cQuote.DP_Month_to_Month_Multiplier__c = cPriceSettings.DP_MonthToMonthMultiplier__c;
            cQuote.DP_kW_Month_to_Month_Multiplier__c = cPriceSettings.DP_kWMonthToMonthMultiplier__c;
            cQuote.DP_kW_Term_Multiplier__c = cPriceSettings.DP_kWTermMultiplier__c;
            cQuote.DP_Exchange_Rate__c = 1;
            cQuote.DP_Currency_Code__c = 'USD';
            cQuote.DP_Term__c = '24';
        }
        getLineItems(cQuote.Id != null);
        system.debug('engtering calcMrrByTerm() ');
        calcMrrByTerm();
        
        cCustSpecProdMap = new Map<Id, DP_Customer_Specific_Product__c>();
        List<DP_Customer_Specific_Product__c> cusProdList = [SELECT id, Name, DP_Formula_Exempt__c, DP_LandedCost__c, DP_CAPEX__c, DP_Markup__c, 
            DP_Product__c, DP_Cost__c, DP_Setup__c, DP_Max_Discount__c FROM DP_Customer_Specific_Product__c WHERE DP_Account__c = :cAccount.id];
        for(DP_Customer_Specific_Product__c c: cusProdList){
            cCustSpecProdMap.put(c.DP_Product__c, c);
        } 
        cServiceType = 'Dedicated Hosting Services';
    }
    
    /*
    @Name   :getLineItems
    @Description :Populates the strJSONQLGrid
    
    */

    public void getLineItems(Boolean quoteExists){    
      
       
        List<QuoteLineItem> lstQLI;
        if((quoteExists) ){
            lstQLI = [SELECT Id,DP_Asset_Action__c,quote.opportunity.DP_current_mrr__C,quote.opportunity.type,PricebookentryId,Pricebookentry.Name,DP_MRR__c,Pricebookentry.Product2.DP_Availability__c, DP_Service_Type__c, DP_Unit_Of_Measure__c, DP_Overage_Unit_Price__c,
                        DP_Quote_Group__c,DP_Quote_Group__r.Name,DP_Data_Center__c,DP_Data_Center__r.Name,DP_Data_Center__r.DP_Name_Abbr__c,Quantity,UnitPrice,   
                        DP_Formula_Exempt__c, Pricebookentry.Product2.DP_LandedCost__c, QuoteId, PriceBookEntry.Product2.DP_Asset_Type__c,
                        Quote.DP_Operational_Life_Factor__c, Quote.DP_Cost_of_Money__c, Quote.DP_Money_Making_Months__c,
                        Quote.DP_Month_to_Month_Multiplier__c,DP_Setup_Fee__c,PriceBookentry.Product2.DP_Data_Center__r.Name,PriceBookEntry.Product2.DP_Data_Center__r.DP_Name_Abbr__c,
                        DP_Landed_Cost__c,DP_kW__c,DP_Cost__c,DP_Max_Discount__c,DP_Markup__c,DP_Discount__c,DP_Parent_Quote_Line__c,
                        DP_Parent_Quote_Line__r.PriceBookEntry.Product2Id, DP_kW_Landed_Cost__c,DP_DatapipeListPriceUSD__c,
                        DP_Data_Center__r.DP_kWCost__c,DP_Data_Center__r.DP_kW_Markup__c,DP_MRR_USD__c,DP_Index__c,DP_CAPEX__c,
                        Pricebookentry.Product2.DP_Product_Type__c,DP_Required__c,DP_Name__c,DP_Base_Quantity__c,
                        DP_Parent_Quote_Line__r.Quantity,DP_Product_Category__c,DP_Product_Compatibility__c,Pricebookentry.Product2.DP_Type_Order__c ,Pricebookentry.Product2.isactive                    
                        FROM QuoteLineItem 
                        WHERE QuoteId = :cQuote.Id 
                        Order By Pricebookentry.Product2.DP_Type_Order__c ASC];
                        
            if (lstQli.size()>0)
          {
          /* List<Quote>  lstQLI2 = [SELECT Id,opportunity.current_mrr__C,opportunity.type FROM QuoteLineItem 
                        WHERE QuoteId = :cQuote.Id    and opportunity.current_mrr__C =null and opportunity.type in(  'Renewal','Renewal - Downgrade' ,'Renewal - Straight' ,Renewal - Upgrade')    ];
          
        /*  if ( lstQLI2.size()>0)
          {'
          for(QuoteLineitem Qli2 :lstQLI2)          {
         // if(Qli2.quote.opportunity.current_mrr__C==null && (Qli2.quote.opportunity.type=='Renewal' || Qli2.quote.opportunity.type == 'Renewal'|| Qli2.quote.opportunity.type == 'Renewal - Downgrade' || Qli2.quote.opportunity.type=='Renewal - Straight' || Qli2.quote.opportunity.type =='Renewal - Upgrade'))
          
         // {
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'"Existing Solution MRR" on Opportunity cannot be null when the Opportunity is from a "Renewal" type. Please update the Opportunity before Quote is saved .');//Same old drama 
              ApexPages.addMessage(myMsg);
             // }
              //}////for
          }//if size
          */
          
          List<QuoteLineItem>  lstQLI1 = [SELECT Id,Pricebookentry.Product2.name FROM QuoteLineItem 
                        WHERE QuoteId = :cQuote.Id  and pricebookentry.product2.isactive =false            ];
               if ( lstQLI1.size()>0)
          {for(QuoteLineitem Qli1 :lstQLI1)

             {
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Product '+Qli1.Pricebookentry.Product2.name + ' is Inactive');//Same old drama 
              ApexPages.addMessage(myMsg);
             } 
          }
         }
        } 
        
        else {
            lstQLI = new List<QuoteLineItem>();           
        }
       
        //Initialize the ordering
        Boolean missingIndex = false;
        cParentIndex = 0;
        Set<Decimal> setIndex = new Set<Decimal>();
        List<Decimal> lstIndex = new List<Decimal>();
        for(QuoteLineItem qli : lstQLI){
            if(qli.DP_Parent_Quote_Line__c == null){//must be a parent, all children have the same index
                if(qli.DP_Index__c == null){
                    missingIndex = true;
                } else {
                    setIndex.add(qli.DP_Index__c);
                    lstIndex.add(qli.DP_Index__c);
                    if(cParentIndex <= qli.DP_Index__c){
                        cParentIndex = qli.DP_Index__c + 1;
                        system.debug('settin that index initially: '+cParentIndex);
                    }
                }
            }
        }
        if(missingIndex || setIndex.size() != lstIndex.size()){ //Reorder the items if there are any blanks or duplicates
            cParentIndex = 0;
            for(QuoteLineItem qliParent : lstQLI){
                if(qliParent.DP_Parent_Quote_Line__c == null){
                    qliParent.DP_Index__c = cParentIndex;
                    for(QuoteLineItem qliChild : lstQLI){
                        if(qliChild.DP_Parent_Quote_Line__c == qliParent.Id){
                            qliChild.DP_Index__c = qliParent.DP_Index__c;
                        }
                    }
                    cParentIndex++;
                    system.debug('setting that index after the fact: '+cParentIndex);
                }
            }
        }
      
        strJSONQLGrid = JSON.serialize(convertListQLI2JQGI(lstQLI));
        calcMrrByTerm();
        system.debug('that index after the fact: '+cParentIndex);
        
        
       
    }
    
    /*
    @Name   :convertPBE2JQGI
    @Description :Converts a pricebookentry to a jquery grid item
    */
    public JQGridItem convertPBE2JQGI(PriceBookEntry pbe,JQGridItem jqgiParent, DP_Product_Compatibility__c pc,String strReq){
        JQGridItem jqgi = new JQGridItem();
        jqgi.strAssetAction = 'add';
        jqgi.strProdCat = pbe.Product2.DP_Product_Category__c;
        jqgi.strRequired = strReq;
        jqgi.strProdType = pbe.Product2.DP_Product_Type__c;
        jqgi.decTypeOrder = pbe.Product2.DP_Type_Order__c;
        jqgi.strQLItemId = 'NEW' + cIntIndex++;
        jqgi.strServiceType = cServiceType;
        if(pbe.Product2.DP_Asset_Type__c == 'Dynamic'){ jqgi.isDynamic = 'true'; }else{ jqgi.isDynamic='false';}
        if(pbe.Product2.DP_Overage_Unit_Price__c != null && pbe.Product2.DP_Unit_Of_Measure__c != null && pbe.Product2.DP_Unit_Of_Measure__c != ''){
            jqgi.decOveragePrice = pbe.Product2.DP_Overage_Unit_Price__c;
            jqgi.strUnit = pbe.Product2.DP_Unit_Of_Measure__c;
        } else {
            jqgi.decOveragePrice = 0;
            jqgi.strUnit = 'None';
        }
        /*if(cDynamic){
            jqgi.isDynamic = 'true';
        } else {
            jqgi.isDynamic = 'false';
        }
        system.debug('cDynamic here: '+cDynamic);
        system.debug('making jqgi with isDynamic: '+jqgi.isDynamic);*/
        
        //check for special pricing on the product, but only if there are special pricing children to reduce SOQL
        DP_Customer_Specific_Product__c custProd = null;
        /*
        List<DP_Customer_Specific_Product__c> cusProdList = [SELECT id, DP_Formula_Exempt__c, DP_LandedCost__c, DP_CAPEX__c, DP_Markup__c, 
            DP_Cost__c, DP_Setup__c, DP_Max_Discount__c FROM DP_Customer_Specific_Product__c WHERE DP_Product__c = :pbe.Product2.ID AND DP_Account__c = :cAccount.id];
        if(cusProdList.size() > 0){
            system.debug('Product has custom children');
            custProd = cusProdList[0];
        }*/
        if(cCustSpecProdMap.containsKey(pbe.Product2.Id)){custProd = cCustSpecProdMap.get(pbe.Product2.Id);}
        //if the product has special pricing for this customer, use that pricing
        if(custProd != null){
            system.debug('Using customer specific pricing');
            jqgi.strQLIName = cCustSpecProdMap.get(pbe.Product2.Id).Name + '*';
            jqgi.strProduct = '<a href=/'+pbe.Product2Id+' target=_blank>'+cCustSpecProdMap.get(pbe.Product2.Id).Name+'*</a>';
            jqgi.strPBEId = pbe.Id;
            jqgi.strProductId = pbe.Product2Id;
            jqgi.strExempt = String.valueOf(custProd.DP_Formula_Exempt__c);
            jqgi.decLandedCost = custProd.DP_CAPEX__c / (1-(custProd.DP_Markup__c/100));
            if(custProd.DP_CAPEX__c == 0){
                jqgi.decLandedCost = custProd.DP_Cost__c / (1-(custProd.DP_Markup__c/100));
            }
            allExistingGrp.put(jqgi.strGroupName,jqgi.strGroupName);
            jqgi.strDCOpts = pbe.Product2.DP_Data_Center__r.DP_Name_Abbr__c;
            jqgi.decSetupFee = custProd.DP_Setup__c;
            if(jqgi.decSetupFee == null) jqgi.decSetupFee = 0;
            if(custProd.DP_CAPEX__c!=null){
                jqgi.decCAPEX = custProd.DP_CAPEX__c;
            } else {
                jqgi.decCAPEX = 0;
            }
            jqgi.strAvailability = pbe.Product2.DP_Availability__c;
            jqgi.IsProdActive = pbe.Product2.Isactive;
            if(pbe.Product2.DP_kW__c!=null){
                jqgi.decKW = pbe.Product2.DP_kW__c;
            } else {
                jqgi.decKW = 0;
            }
            if(custProd.DP_Cost__c!=null){
                jqgi.decCost = custProd.DP_Cost__c;
            } else {
                jqgi.decCost = 0;
            }
            if(custProd.DP_Markup__c!=null){
                jqgi.decMarkup = custProd.DP_Markup__c;
            } else {
                jqgi.decMarkup = 0;
            }
            if(custProd.DP_Max_Discount__c!=null){
                jqgi.maxDiscount = custProd.DP_Max_Discount__c;
            } else {
                jqgi.maxDiscount = 0;
            }
            if(cQuote.DP_Discount__c != null && cQuote.DP_Discount__c > jqgi.maxDiscount){
                jqgi.decDiscount = jqgi.maxDiscount;
            } else if(cQuote.DP_Discount__c != null){
                jqgi.decDiscount = cQuote.DP_Discount__c;
            } else {
                jqgi.decDiscount = 0;
            }
        //this is for 'regular' products
        } else {
            system.debug('Using reglar pricing');
            jqgi.strQLIName = pbe.Name;
            jqgi.strProduct = '<a href=/'+pbe.Product2Id+' target=_blank>'+pbe.Name+'</a>';
            jqgi.strPBEId = pbe.Id;
            jqgi.strProductId = pbe.Product2Id;
            jqgi.strExempt = String.valueOf(pbe.Product2.DP_Formula_Exempt__c);
            jqgi.decLandedCost = pbe.Product2.DP_CAPEX__c / (1-(pbe.Product2.DP_Markup__c/100));
            if(pbe.Product2.DP_CAPEX__c == 0){
                jqgi.decLandedCost = pbe.Product2.DP_Cost__c / (1-(pbe.Product2.DP_Markup__c/100));
            }
            allExistingGrp.put(jqgi.strGroupName,jqgi.strGroupName);
            jqgi.strDCOpts = pbe.Product2.DP_Data_Center__r.DP_Name_Abbr__c;
            jqgi.decSetupFee = pbe.Product2.DP_Setup__c;
            if(jqgi.decSetupFee == null) jqgi.decSetupFee = 0;
            if(pbe.Product2.DP_CAPEX__c!=null){
                jqgi.decCAPEX = pbe.Product2.DP_CAPEX__c;
            } else {
                jqgi.decCAPEX = 0;
            }
            jqgi.strAvailability = pbe.Product2.DP_Availability__c;
            if(pbe.Product2.DP_kW__c!=null){
                jqgi.decKW = pbe.Product2.DP_kW__c;
            } else {
                jqgi.decKW = 0;
            }
            if(pbe.Product2.DP_Cost__c!=null){
                jqgi.decCost = pbe.Product2.DP_Cost__c;
            } else {
                jqgi.decCost = 0;
            }
            if(pbe.Product2.DP_Markup__c!=null){
                jqgi.decMarkup = pbe.Product2.DP_Markup__c;
            } else {
                jqgi.decMarkup = 0;
            }
            if(pbe.Product2.DP_Max_Discount__c!=null){
                jqgi.maxDiscount = pbe.Product2.DP_Max_Discount__c;
            } else {
                jqgi.maxDiscount = 0;
            }
            if(cQuote.DP_Discount__c != null && cQuote.DP_Discount__c > jqgi.maxDiscount){jqgi.decDiscount = jqgi.maxDiscount;} 
            else if(cQuote.DP_Discount__c != null){
                jqgi.decDiscount = cQuote.DP_Discount__c;
            } else {
                jqgi.decDiscount = 0;
            }
        }
        if(pbe.Product2.DP_Data_Center__c != null){
            jqgi.strDataCenter = pbe.Product2.DP_Data_Center__r.DP_Name_Abbr__c;
            jqgi.decKWCost = pbe.Product2.DP_Data_Center__r.DP_kWCost__c;
            jqgi.decKWMarkup = pbe.Product2.DP_Data_Center__r.DP_kW_Markup__c;
        } if(cChosenDC == null){
            jqgi.strDataCenter = cDefaultDC.DP_Name_Abbr__c;
            jqgi.decKWCost = cDefaultDC.DP_kWCost__c;
            jqgi.decKWMarkup = cDefaultDC.DP_kW_Markup__c;
        } else {
            jqgi.strDataCenter = cChosenDC.DP_Name_Abbr__c;
            jqgi.decKWCost = cChosenDC.DP_kWCost__c;
            jqgi.decKWMarkup = cChosenDC.DP_kW_Markup__c;
        }
        jqgi.decKWMarkup = jqgi.decKWMarkup / 100;
        Decimal qty;
        Decimal bQty;
        if(jqgiParent == null){
            //We are creating a new parent
            system.debug('making a new parent.  cParentIndex: '+(cParentIndex+1) +' and action: '+jqgi.strAssetAction);
            jqgi.decParentOrder = cParentIndex++;
            jqgi.strIsParent = '0';
            jqgi.decMinQty = -1;
            jqgi.decMaxQty = -1;
            jqgi.decIncQty = -1;
            jqgi.decParentQty = -1;
            jqgi.baseQty = 0;
            jqgi.decQty = 1;
            jqgi.decOrigQty = 1;
            qty = jqgi.decQty;
            bQty = jqgi.baseQty;
            jqgi.strAction = '<a href="javascript:void(0)" onclick="javascript:delRow(\''+jqgi.strQLItemId+'\');">Del</a>';
            List<DP_Product_Compatibility__c> pcList = [SELECT Id,DP_Child_Product__c,DP_Parent_Product__c  
                                                    FROM DP_Product_Compatibility__c 
                                                    WHERE DP_Parent_Product__c = :pbe.Product2Id
                                                    AND (DP_Child_Product__c = null OR (DP_Minimum_Quantity__c = 0 AND DP_Child_Product__r.DP_Availability__c IN ('Available','Limited')))];
            if(pcList.size() > 0 || jqgi.isDynamic == 'true'){
                jqgi.strAction = jqgi.strAction +' / <a href="javascript:void(0)" onclick="javascript:configProdJS(\''+jqgi.strQLItemId+'\');">'+'Configure'+'</a>';
            }
            //jqgi.strGroupName = cstrGroupName;
            if(cstrQuoteGroup != null && cstrQuoteGroup != ''){
                cstrQuoteGroup = cstrQuoteGroup.replaceAll('   ', ' ');
                cstrQuoteGroup = cstrQuoteGroup.replaceAll('  ', ' ');
                jqgi.strGroupName = cstrQuoteGroup;
            } else if(cselQuoteGroup != null && cselQuoteGroup != ''){jqgi.strGroupName = cselQuoteGroup;} 
            else {
                jqgi.strGroupName = 'Details';
            }
            jqgi.strParentId = jqgi.strQLItemId;
            jqgi.strProdCompatId = null;
        } else {
            //We are creating a new child
            system.debug('making a new child.  decParentOrder: '+jqgiParent.decParentOrder +' and action: '+jqgiParent.strAssetAction);
            jqgi.decParentOrder = jqgiParent.decParentOrder;
            jqgi.strProdCompatId = pc.Id;
            jqgi.strIsParent = '1';
            jqgi.decMinQty = pc.DP_Minimum_Quantity__c;
            jqgi.decMaxQty = pc.DP_Maximum_Quantity__c;
            jqgi.decIncQty = pc.DP_Increment_Quantity__c;
            jqgi.decParentQty = jqgiParent.decQty;
            jqgi.baseQty = pc.DP_Base_Quantity__c;
            if(jqgi.baseQty == null) jqgi.baseQty = 0;
            jqgi.decQty = jqgi.decMinQty;
            if(jqgi.decQty == null || jqgi.decQty < 1) jqgi.decQty = 1;
            jqgi.decOrigQty = jqgi.decQty;
            qty = jqgi.decQty * jqgi.decParentQty;
            bQty = jqgi.baseQty * jqgi.decParentQty;
            if(jqgiParent.strRequired == 'No') jqgi.strAction = '<a href="javascript:void(0)" onclick="javascript:delRow(\''+jqgi.strQLItemId+'\');">Del</a>';
            //if(jqgi.strAssetAction == 'Change') jqgi.strAction = '<a href="javascript:void(0)" onclick="javascript:flipRow(\''+jqgi.strQLItemId+'\');">'+'Rem'+'</a>';
            jqgi.strGroupName = jqgiParent.strGroupName;
            jqgi.strParentId = jqgiParent.strParentId;
        }
        if(!mapQLGs.containsKey(jqgi.strGroupName)){
            DP_Quote_Line_Group__c qlg = new DP_Quote_Line_Group__c();
            qlg.Name = jqgi.strGroupName;
            qlg.DP_Order__c = cGroupIndex++;
            mapQLGs.put(qlg.Name,qlg);
        }
        jqgi.decGroupOrder = mapQLGs.get(jqgi.strGroupName).DP_Order__c;
        jqgi.decPreviousQty = jqgi.decQty;
        jqgi.decDPLPUSD = DP_DatapipeUtility.calculate_datapipeListPriceUSD(
                                        cQuote.DP_Term__c, 
                                        cQuote.DP_Operational_Life_Factor__c,
                                        cQuote.DP_Cost_of_Money__c,
                                        cQuote.DP_Money_Making_Months__c,
                                        cQuote.DP_Month_to_Month_Multiplier__c,
                                        cQuote.DP_kW_Month_to_Month_Multiplier__c,
                                        cQuote.DP_kW_Hours_In_Month__c,
                                        cQuote.DP_kW_Term_Multiplier__c,
                                        jqgi.decKW,
                                        jqgi.decKWCost,
                                        jqgi.decKWMarkup,
                                        qty,
                                        Boolean.valueOf(jqgi.strExempt),
                                        jqgi.decLandedCost,
                                        bQty);
        jqgi.decMRR = DP_DatapipeUtility.calculate_mrr(jqgi.decDPLPUSD,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount);
        jqgi.decUSDMRR = jqgi.decMRR * cQuote.DP_Exchange_Rate__c;
        system.debug('Making jqgi '+jqgi.strQLIName+' with isDynamic '+jqgi.isDynamic);
        return jqgi;
    }
    
    /*
    @Name   :convertListQLI2JQGI
    @Description :Converts a list of quotelineitem to a list of jquery grid item
    */
    public List<JQGridItem> convertListQLI2JQGI(List<QuoteLineItem> lstQLI){
        Set<Id> setQLIProdIds = new Set<Id>();
        Set<Id> setQLIParentProdIds = new Set<Id>();
        Set<Id> setPCIds = new Set<Id>();
        for(QuoteLineItem qli : lstQLI){
            setQLIProdIds.add(qli.PriceBookEntry.Product2Id);
            if(qli.DP_Parent_Quote_Line__c != null){
                setQLIParentProdIds.add(qli.DP_Parent_Quote_Line__r.PriceBookEntry.Product2Id);
            }
            if(qli.DP_Product_Compatibility__c != null){setPCIds.add(qli.DP_Product_Compatibility__c);}
        }
        List<DP_Product_Compatibility__c> pcList = [SELECT Id,DP_Child_Product__c,DP_Parent_Product__c,DP_Minimum_Quantity__c   
                                                 FROM DP_Product_Compatibility__c
                                                 WHERE DP_Parent_Product__c IN :setQLIProdIds];
        List<DP_Product_Compatibility__c> lstPC = [SELECT Id,DP_Parent_Product__c,DP_Child_Product__c,DP_Maximum_Quantity__c,DP_Minimum_Quantity__c,DP_Increment_Quantity__c,
                                                        DP_Include_All__c  
                                                        FROM DP_Product_Compatibility__c 
                                                        WHERE DP_Parent_Product__c IN :setQLIParentProdIds   
                                                        AND (DP_Child_Product__c IN :setQLIProdIds OR DP_Include_All__c = true)];
        Map<Id,DP_Product_Compatibility__c> mapAttachedPCs = new Map<Id,DP_Product_Compatibility__c>([SELECT Id,DP_Parent_Product__c,DP_Child_Product__c,DP_Maximum_Quantity__c,DP_Minimum_Quantity__c,DP_Increment_Quantity__c,
                                                        DP_Include_All__c  
                                                        FROM DP_Product_Compatibility__c 
                                                        WHERE Id IN :setPCIds]);
        Set<Id> setParents = new Set<Id>();
        for(DP_Product_Compatibility__c pc : pcList){
            if((pc.DP_Minimum_Quantity__c > 0 && pc.DP_Child_Product__c == null) || pc.DP_Minimum_Quantity__c == 0){
                setParents.add(pc.DP_Parent_Product__c);
            } 
        }
        List<JQGridItem> lstJQGI = new List<JQGridItem>();
        for(QuoteLineItem qli : lstQLI){
            JQGridItem jqgi = new JQGridItem();
            jqgi.strServiceType = qli.DP_Service_Type__c;
            if(qli.PriceBookEntry.Product2.DP_Asset_Type__c == 'Dynamic'){jqgi.isDynamic = 'true';} 
            else {
                jqgi.isDynamic = 'false';
            }
            if(qli.DP_Unit_Of_Measure__c != null){
                jqgi.strUnit = qli.DP_Unit_Of_Measure__c;
            } else {
                jqgi.strUnit = '';
            }
            if(qli.DP_Overage_Unit_Price__c != null){
                jqgi.decOveragePrice = qli.DP_Overage_Unit_Price__c;
            } else {
                jqgi.decOveragePrice = 0;
            }
            jqgi.decTypeOrder = qli.Pricebookentry.product2.DP_type_order__c;
            jqgi.strProdCompatId = qli.DP_Product_Compatibility__c;
            jqgi.strProdCat = qli.DP_Product_Category__c;
            jqgi.strQLItemId = qli.Id;
            jqgi.strIsParent = '0';
            if(qli.DP_Parent_Quote_Line__c != null){
                jqgi.strIsParent = '1';
                jqgi.strParentId = qli.DP_Parent_Quote_Line__c;
                //Set the quantity params for child quote lines
                DP_Product_Compatibility__c pc;
                pc = mapAttachedPCs.get(qli.DP_Product_Compatibility__c);
                /*for(DP_Product_Compatibility__c pcTemp : lstPC){
                    System.debug(pcTemp);
                    if(pcTemp.DP_Child_Product__c == qli.PriceBookEntry.Product2Id && pcTemp.DP_Parent_Product__c == qli.DP_Parent_Quote_Line__r.PriceBookEntry.Product2Id){
                        pc = pcTemp;
                        System.debug('found first');
                    } else if(pc == null && pcTemp.DP_Include_All__c && pcTemp.DP_Parent_Product__c == qli.DP_Parent_Quote_Line__r.PriceBookEntry.Product2Id){
                        pc = pcTemp;
                        System.debug('found second');
                    }
                }*/
                if(pc != null){
                    jqgi.decMinQty = pc.DP_Minimum_Quantity__c;
                    jqgi.decMaxQty = pc.DP_Maximum_Quantity__c;
                    jqgi.decIncQty = pc.DP_Increment_Quantity__c;
                } else {
                    jqgi.decMinQty = -1;
                    jqgi.decMaxQty = -1;
                    jqgi.decIncQty = -1;
                }
                jqgi.decParentQty = qli.DP_Parent_Quote_Line__r.Quantity;
                
            } else {
                jqgi.strParentId = jqgi.strQLItemId;
                jqgi.decMinQty = -1;
                jqgi.decMaxQty = -1;
                jqgi.decIncQty = -1;
                jqgi.decParentQty = -1;
            }
            jqgi.decParentOrder = qli.DP_Index__c;
            jqgi.strRequired = qli.DP_Required__c;
            jqgi.baseQty = qli.DP_Base_Quantity__c;
            jqgi.strProdType = qli.Pricebookentry.Product2.DP_Product_Type__c;
            jqgi.strPBEId = qli.PriceBookEntryId;
            jqgi.strProductId = qli.PriceBookEntry.Product2Id;
            jqgi.strExempt = String.valueOf(qli.DP_Formula_Exempt__c);
            jqgi.decLandedCost = qli.DP_Landed_Cost__c;
            jqgi.decMRR = qli.DP_MRR__c;
            jqgi.decUSDMRR = qli.DP_MRR_USD__c;
            jqgi.decSetupFee = qli.DP_Setup_Fee__c;
            jqgi.strGroupName = qli.DP_Quote_Group__r.Name;
            if(mapQLGs.get(jqgi.strGroupName) != null){
                jqgi.decGroupOrder = mapQLGs.get(jqgi.strGroupName).DP_Order__c;
            } else if(mapQLGs.get('Details') != null) {
                jqgi.strGroupName = 'Details';
                jqgi.decGroupOrder = mapQLGs.get(jqgi.strGroupName).DP_Order__c;
            } else {
                jqgi.strGroupName = 'Details';
                jqgi.decGroupOrder = cGroupIndex++;
                mapQLGs.put(jqgi.strGroupName,new DP_Quote_Line_Group__c(Name=jqgi.strGroupName,DP_Quote__c=cQuote.Id,DP_Order__c=jqgi.decGroupOrder));
            }
            
            jqgi.strDataCenter = qli.DP_Data_Center__r.DP_Name_Abbr__c;
            jqgi.decKWCost = qli.DP_Data_Center__r.DP_kWCost__c;
            jqgi.decKWMarkup = qli.DP_Data_Center__r.DP_kW_Markup__c / 100;
            jqgi.strDCOpts = qli.PriceBookEntry.Product2.DP_Data_Center__r.DP_Name_Abbr__c;
            jqgi.decQty = qli.Quantity;
            jqgi.decOrigQty = qli.Quantity;
            jqgi.decPreviousQty = jqgi.decQty;
            jqgi.decCAPEX = qli.DP_CAPEX__c;
            jqgi.strQLIName = qli.DP_Name__c;
            jqgi.strProduct = '<a href=/'+qli.Id+' target=_blank>'+qli.DP_Name__c+'</a>';
            jqgi.strAvailability = qli.Pricebookentry.Product2.DP_Availability__c;
            jqgi.Isprodactive = qli.Pricebookentry.Product2.Isactive;
            jqgi.decKW = qli.DP_kW__c;
            jqgi.decCost = qli.DP_Cost__c;
            jqgi.decMarkup = qli.DP_Markup__c;
            jqgi.maxDiscount = qli.DP_Max_Discount__c;
            jqgi.decDiscount = qli.DP_Discount__c;
            
            //this sets up the magic happening for Asset changing
            if(qli.DP_Asset_Action__c != null){
                jqgi.strAssetAction = qli.DP_Asset_Action__c;
                //if(qli.DP_Asset_Action__c == 'Change') {}
            } else {
                jqgi.strAssetAction = 'add';
            }
            
            if(jqgi.strRequired == 'No'){
                jqgi.strAction = '<a href="javascript:void(0)" onclick="javascript:delRow(\''+jqgi.strQLItemId+'\');">'+'Del'+'</a>';
                if(jqgi.isDynamic == 'true') jqgi.strAction = jqgi.strAction +' / <a href="javascript:void(0)" onclick="javascript:configProdJS(\''+jqgi.strQLItemId+'\');">'+'Configure'+'</a>';
                if(jqgi.strAssetAction == 'Change'){
                    if(jqgi.decMRR >= 0){ 
                        jqgi.strAction = '<a href="javascript:void(0)" onclick="javascript:flipRow(\''+jqgi.strQLItemId+'\');">'+'Rem'+'</a>';
                        jqgi.decMRR = 0;
                    }
                    else if(jqgi.decMRR < 0) {
                        jqgi.strAction = '<a href="javascript:void(0)" onclick="javascript:flipRow(\''+jqgi.strQLItemId+'\');">'+'Add'+'</a>';
                    }
                } else if(jqgi.strAssetAction == 'Remove'){jqgi.strAction = '';}
            }
            if(setParents.contains(qli.PriceBookEntry.Product2Id) && jqgi.strAssetAction != 'Remove'){
                jqgi.strAction = jqgi.strAction +' / <a href="javascript:void(0)" onclick="javascript:configProdJS(\''+jqgi.strQLItemId+'\');">'+'Configure'+'</a>';
            }
            
            if(qli.DP_DatapipeListPriceUSD__c!=null){
                jqgi.decDPLPUSD = qli.DP_DatapipeListPriceUSD__c;
            } else {
                jqgi.decDPLPUSD = 0;
            }
            lstJQGI.add(jqgi);
        }
        return lstJQGI;
    }
    
    /*
    @Name   :saveAll
    @Description :Saves the Quote, removes opportunity created line items, saves the chosen quotelineitems, and can sync to the opp
    */
    public PageReference saveAll(){
        PageReference prReturn = null;
        Savepoint sp = Database.setSavePoint();
        try{
            if(cQuote.DP_Term__c == null){
                throw new DP_DatapipeUtility.CustomException('Required fields are missing: [Term]');
            }
            Boolean isNew = cQuote.Id == null;
            List<JQGridItem> lstJQGI = (List<JQGridItem>)JSON.deserialize(strJSONQLGrid,List<JQGridItem>.class);
            Map<String,Id> mapDCNameIds = new Map<String,Id>();
            Map<String,Id> mapQGNameIds = new Map<String,Id>();
            Map<String,QuoteLineItem> mapGridIdQLI = new Map<String,QuoteLineItem>();
            Map<Id,QuoteLineItem> mapExistingQLI;
            Map<Id,DP_Quote_Line_Group__c> mapExistingQLG = new Map<Id,DP_Quote_Line_Group__c>([SELECT Id,Name 
                                                                                            FROM DP_Quote_Line_Group__c 
                                                                                            WHERE DP_Quote__c = :cQuote.Id]);
            
             //opportunityrenewlvalidation 
               List<Quote>  lstQ2 = [SELECT Id, opportunity.Account__c,opportunity.DP_current_mrr__C,opportunity.type FROM Quote  WHERE Id = :cQuote.Id AND opportunity.DP_current_mrr__C= null AND  opportunity.type IN( 'Renewal','Renewal - Downgrade','Renewal - Straight' ,'Renewal - Upgrade')      ];
                        if ( lstQ2.size()>0)
          {
        /*  for(Quote Q2 :lstQ2)
          {
          if(Q2.opportunity.current_mrr__C==null && (Q2.opportunity.type=='Renewal' ||Q2.opportunity.type == 'Renewal'|| Q2.opportunity.type == 'Renewal - Downgrade' || Q2.opportunity.type=='Renewal - Straight' || Q2.opportunity.type =='Renewal - Upgrade'))
          
          {*/
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'"Existing Solution MRR" on Opportunity cant be null when the Opportunity is from a "Renewal" type. Please update the missing field BEFORE creating or editing the quote  .');//Same old drama 
              ApexPages.addMessage(myMsg);
              return null;
              }
          // }//for          }//if size
          
              if(cbolActive == true)
              {cQuote.QuoteSynced__c=true;
              }
               if(cbolActive == false)
              {cQuote.QuoteSynced__c=false;
              }                  
               
            //Save the Quote
           upsert cQuote;
           // }
            //Remove the quotelineitems created that came from the existing opportunitylineitems
            mapExistingQLI = new Map<Id,QuoteLineItem>([SELECT Id,Quantity,UnitPrice,DP_Setup_Fee__c,DP_Data_Center__c,DP_MRR__c ,pricebookentry.product2.name,pricebookentry.product2.isactive
                                            FROM QuoteLineItem 
                                            WHERE QuoteId =:cQuote.Id]);
          //  system.debug('productinactivecature'+mapExistingQLI.pricebookentry.product2.name);
            if(isNew && mapExistingQLI.values().size() > 0){
                delete mapExistingQLI.values();
            }
        //    mapExistingQLI = new Map<Id,QuoteLineItem>([SELECT Id,Quantity,UnitPrice,DP_Setup_Fee__c,DP_Data_Center__c,DP_MRR__c ,pricebookentry.product2.name,pricebookentry.product2.isactive
          //                                  FROM QuoteLineItem 
            //                                WHERE QuoteId =:cQuote.Id]);
                                     
            for(DP_DataCenter__c dc : [SELECT Id, Name,DP_Name_Abbr__c, DP_kWCost__c, DP_kW_Markup__c from DP_DataCenter__c]){
                mapDCNameIds.put(dc.DP_Name_Abbr__c,dc.Id);
            }
            //Upsert the new groupings
            Set<String> setQLGNames = new Set<String>();
            list<product2>  prod = new list<product2 >([SELECT Id,name FROM Product2 WHERE isactive =false] );
//            id =: lstJQGI[].strproductid
   
            for(JQGridItem jqgi : lstJQGI)
             {
                setQLGNames.add(jqgi.strGroupName);
                if(mapQLGs.containsKey(jqgi.strGroupName)){
                    mapQLGs.get(jqgi.strGroupName).DP_Order__c = jqgi.decGroupOrder;
                }
                }
   
            for(JQGridItem jqgi : lstJQGI)
             {
          
              for(Integer j = 0; j < prod.size(); j++){
                  //system.debug('prod[j].Id== '+prod[j].Id);
                  //system.debug('jqgi.strProductId ='+ jqgi.strProductId);
      
                if( prod[j].Id== jqgi.strProductId){
                           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Product : '+ prod[j].name + ' is Inactive');//Same old drama 
                          ApexPages.addMessage(myMsg);
                      return null;
                      } 
                  }//J++ end
              
              }//
            
           List<DP_Quote_Line_Group__c> lstQLG = new List<DP_Quote_Line_Group__c>();
           //  Map<ID,DP_Quote_Line_Group__c> lstQLG = new map<Id,Quote_LIne_Group__C>();
            for(DP_Quote_Line_Group__c qlg : mapQLGs.values()){
                if(qlg.DP_Quote__c != null){
                    lstQLG.add(qlg);
                   // lstQLG.put(qlg.Id,qlg);
                } else {
                    DP_Quote_Line_Group__c qlgNew = new DP_Quote_Line_Group__c(DP_Quote__c=cQuote.Id,Name=qlg.Name,DP_Order__c=qlg.DP_Order__c);
                    lstQLG.add(qlgNew);
                   // lstQLG.put(qlg.ID,qlg);
                    //lstQLG.put(qlg.name,qlg);
                }
             
            }
            //opportunityrenewlvalidation 
               List<Quote>  lstQ1 = [SELECT Id,opportunity.DP_current_mrr__C,opportunity.type FROM Quote                    WHERE Id = :cQuote.Id          ];
                        if ( lstQ1.size()>0)
          {
          for(Quote Q1 :lstQ1)
          {
          if(Q1.opportunity.DP_current_mrr__C==null && (Q1.opportunity.type=='Renewal' ||Q1.opportunity.type == 'Renewal'|| Q1.opportunity.type == 'Renewal - Downgrade' || Q1.opportunity.type=='Renewal - Straight' || Q1.opportunity.type =='Renewal - Upgrade'))
          
          {ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'"Existing Solution MRR" on Opportunity cant be null when the Opportunity is from a "Renewal" type.Please update the missing field BEFORE creating or editing the quote .');//Same old drama 
              ApexPages.addMessage(myMsg);
              return null;
              }
           }//for
          }//if size
          
          
            upsert lstQLG;
          // upsert lstQLG.values();
            //System.debug(lstQLG);
            //Delete the groupings that are no longer in use
            List<DP_Quote_Line_Group__c> lstDeleteQLG = new List<DP_Quote_Line_Group__c>();
            for(DP_Quote_Line_Group__c qlg : mapExistingQLG.values()){
                if(mapQLGs.keySet().contains(qlg.Name) && !setQLGNames.contains(qlg.Name)){
                    lstDeleteQLG.add(qlg);
                }
            }
            delete lstDeleteQLG;
            //Resetup the map of quote line group name to id's
            mapQLGs.clear();
            mapExistingQLG = new Map<Id,DP_Quote_Line_Group__c>([SELECT Id,Name,DP_Quote__c,DP_Order__c  
                                                                FROM DP_Quote_Line_Group__c 
                                                                WHERE DP_Quote__c = :cQuote.Id]);
            for(DP_Quote_Line_Group__c qlg : mapExistingQLG.values()){
                mapQGNameIds.put(qlg.Name,qlg.Id);
                mapQLGs.put(qlg.Name,qlg);
            }
            //Upsert the new or existing QuoteLineItems
            for(JQGridItem jqgi : lstJQGI){
                QuoteLineItem qli;
                
                if((jqgi.strQLItemId.length() == 15 || jqgi.strQLItemId.length() == 18) && mapExistingQLI.containsKey(jqgi.strQLItemId)){ //15 or 18 is the valid size of an Id
                    qli = mapExistingQLI.get(jqgi.strQLItemId);
                           
                } else {
                    qli = new QuoteLineItem(QuoteId=cQuote.Id,PricebookEntryId=jqgi.strPBEId);
         
                }
         
         
                
              /*  map<Id, QuoteLineItem>  lstQLI1 = new map<id,QuoteLineitem>([SELECT Id,Pricebookentry.Product2.name FROM QuoteLineItem 
                        WHERE Id = :qli.Id  and pricebookentry.product2.isactive =false] );
                if (LstQli1.size()>0)     {            
                
               
                for(QuoteLineitem Qli1 :[SELECT Id,Pricebookentry.Product2.name FROM QuoteLineItem 
                        WHERE Id = :qli.Id  and pricebookentry.product2.isactive =false] )
                {
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Product '+Qli1.Pricebookentry.Product2.name + ' is Inactive');//Same old drama 
              ApexPages.addMessage(myMsg);
              return null;
             } 
            // }endif
            */
                qli.Quantity = jqgi.decQty;
                if(qli.Quantity != 0){
                   qli.UnitPrice = jqgi.decUSDMRR / qli.Quantity; 
                   system.debug('qli.UnitPrice ::'+qli.UnitPrice +'jqgi.decUSDMRR::'+ jqgi.decUSDMRR +'qli.Quantity::'+ qli.Quantity);
                } else {
                    qli.UnitPrice = 0;
                }
                
                qli.DP_Discount__c = jqgi.decDiscount;
                //qli.DP_Parent_Quote_Line__c = set this after everything has been saved as we need the id's that haven't been created yet
                if(mapDCNameIds.containsKey(jqgi.strDataCenter)){
                    qli.DP_Data_Center__c = mapDCNameIds.get(jqgi.strDataCenter);
                }
                if(jqgi.strProdCompatId != null && jqgi.strProdCompatId != '') qli.DP_Product_Compatibility__c = jqgi.strProdCompatId;
                qli.DP_Product_Category__c = jqgi.strProdCat;
                qli.DP_MRR__c = jqgi.decMRR;
                qli.DP_Index__c = jqgi.decParentOrder;
                //system.debug('Saving QuoteLineItem '+jqgi.strQLIName+' with index '+jqgi.decParentOrder+' and MRR '+jqgi.decMRR);
                qli.DP_Setup_Fee__c = jqgi.decSetupFee;
                qli.DP_Formula_Exempt__c = Boolean.valueOf(jqgi.strExempt);
                qli.DP_kW__c = jqgi.decKW;
                qli.DP_CAPEX__c = jqgi.decCAPEX;
                qli.DP_Cost__c = jqgi.decCost;
                qli.DP_Markup__c = jqgi.decMarkup;
                qli.DP_Base_Quantity__c = jqgi.baseQty;
                qli.DP_Max_Discount__c = jqgi.maxDiscount;
                qli.DP_Required__c = jqgi.strRequired;
                qli.DP_Service_Type__c = jqgi.strServiceType;
                qli.DP_Overage_Unit_Price__c = jqgi.decOveragePrice;
                qli.DP_Unit_Of_Measure__c = jqgi.strUnit;
                if(mapQGNameIds.containsKey(jqgi.strGroupName)){
                    qli.DP_Quote_Group__c = mapQGNameIds.get(jqgi.strGroupName);
                }
                qli.DP_kw_Cost__c = jqgi.decKWCost;
                qli.DP_kw_Markup__c = jqgi.decKWMarkup * 100;
                qli.DP_DatapipeListPriceUSD__c = jqgi.decDPLPUSD;
                qli.DP_Name__c = jqgi.strQLIName;
                system.debug('saving QLI '+qli.DP_Name__c+' with Service Type '+qli.DP_Service_Type__c);
                mapGridIdQLI.put(jqgi.strQLItemId,qli);
            }
            upsert mapGridIdQLI.values();
            //Add the parentid
            for(JQGridItem jqgi : lstJQGI){
                QuoteLineItem qli = mapGridIdQLI.get(jqgi.strQLItemId);
                if(jqgi.strParentId != null && jqgi.strParentId != '' && jqgi.strParentId != jqgi.strQLItemId && mapGridIdQLI.get(jqgi.strParentId)!=null){
                    qli.DP_Parent_Quote_Line__c = mapGridIdQLI.get(jqgi.strParentId).Id;
                }
            }
            update mapGridIdQLI.values();
            //Delete the QuoteLineItems that are not in the grid
            List<QuoteLineItem> lstDeleteQLI = new List<QuoteLineItem>();
            for(QuoteLineItem qli : mapExistingQLI.values()){
                if(!mapGridIdQLI.containsKey(qli.Id)){
                    lstDeleteQLi.add(qli);
                }
            }
            delete lstDeleteQlI;
            //Update the existing group list with new groups
            cQuoteGroups = new List<SelectOption>();
            cQuoteGroups.add(new SelectOption('','--None--'));
          //  lstQLG = new map<Id,DP_Quote_line_group__c>([SELECT Id,Name FROM DP_Quote_Line_Group__c WHERE DP_Quote__c = :cQuote.Id and name not in('Change','Remove') Order By DP_Order__c ASC]);
           // for(DP_Quote_Line_Group__c qlg : lstQLG.values()){
           
            lstQLG = [SELECT Id,Name FROM DP_Quote_Line_Group__c WHERE DP_Quote__c = :cQuote.Id Order By DP_Order__c ASC];
            for(DP_Quote_Line_Group__c qlg : lstQLG){
                if(qlg.Name != 'Change' && qlg.Name != 'Remove'){
                    cQuoteGroups.add(new SelectOption(qlg.Name,qlg.Name));
                    // cQuoteGroups.put(new SelectOption(qlg.Name,qlg.Name));
                }
            }
            //Sync/unsync the Quote to the Opp based on active checkbox
            if(cOpportunity.quotes.size()==0){
                cOpportunity.SyncedQuoteId = cQuote.Id;
                cbolActive = true;
                update cOpportunity;
            }
            else if(cOpportunity.SyncedQuoteId == cQuote.Id && cbolActive == false){
                cOpportunity.SyncedQuoteId = null;
                update cOpportunity;
            } else if(cOpportunity.SyncedQuoteId != cQuote.Id && cbolActive){
                cOpportunity.SyncedQuoteId = cQuote.Id;
                update cOpportunity;
            } 
            //prReturn = new PageReference('/' + cQuote.Id);
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM,cQuote.Name + ' saved'));
        } catch (Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,e.getMessage()));
            Database.rollback(sp);
            //Clone the quote except the id as the Id may be kept even though the DB was rolled back
            cQuote = cQuote.clone(false,true,false,false);
        }
        return prReturn;
    }
    
    /*
    @Name        :getPriceBookEntries
    @Description :Returns the list of PriceBookEntries for the FlexBox to use
    */
    public String getPriceBookEntries(){
        //List<PriceBookEntry> lstPBE;
        map<Id,PriceBookEntry> lstPBE;
        Set<String> setProdCodes = new Set<String>();

        if(cSearchProd != null && cSearchProd != '' && cSearchDCId!=null && cSearchDCId!=''){
           /* lstPBE = [SELECT Id,Product2.Name,Product2Id,Product2.DP_Product_Type__c,Product2.DP_Account__c, Product2.DP_Overage_Unit_price__c, Product2.DP_Unit_Of_Measure__c, Product2.DP_Customer_Specific__c
                                    FROM PriceBookEntry 
                                    WHERE Product2.DP_Product_Type__c = :cSearchProd
                                    AND Product2.DP_Service_Type__c INCLUDES (:cServiceType)
                                    AND Product2.DP_Product_Type__c != null 
                                    AND (Product2.DP_Data_Center__c = :cSearchDCId
                                    OR Product2.DP_Data_Center__c = null)  
                                    AND IsActive = true 
                                    AND IsDeleted = false 
                                    AND Product2.DP_Availability__c IN ('Available','Limited') 
                                    ORDER BY Product2.Name asc];*/
            lstPBE = new map<Id,pricebookentry>([SELECT Id,Product2.Name,Product2Id,Product2.DP_Product_Type__c,Product2.DP_Account__c, Product2.DP_Overage_Unit_price__c, Product2.DP_Unit_Of_Measure__c, Product2.DP_Customer_Specific__c
                                    FROM PriceBookEntry 
                                    WHERE Product2.DP_Product_Type__c = :cSearchProd
                                    AND Product2.DP_Service_Type__c INCLUDES (:cServiceType)
                                    AND Product2.DP_Product_Type__c != null 
                                    AND (Product2.DP_Data_Center__c = :cSearchDCId
                                    OR Product2.DP_Data_Center__c = null)  
                                    AND IsActive = true 
                                    AND IsDeleted = false 
                                    AND Product2.DP_Availability__c IN ('Available','Limited') 
                                    ORDER BY Product2.Name asc]);
        } else if(cSearchProd != null && cSearchProd != '' && (cSearchDCId==null || cSearchDCId=='')){
          /*  lstPBE = [SELECT Id,Product2.Name,Product2Id,Product2.DP_Product_Type__c,Product2.DP_Account__c, Product2.DP_Overage_Unit_price__c, Product2.DP_Unit_Of_Measure__c, Product2.DP_Customer_Specific__c
                                    FROM PriceBookEntry 
                                    WHERE Product2.DP_Product_Type__c = :cSearchProd
                                    AND Product2.DP_Service_Type__c INCLUDES (:cServiceType)
                                    AND Product2.DP_Product_Type__c != null 
                                    AND IsActive = true  
                                    AND IsDeleted = false 
                                    AND Product2.DP_Availability__c IN ('Available','Limited')  
                                    ORDER BY Product2.Name asc];*/
              lstPBE =new map<id,PriceBookEntry>([SELECT Id,Product2.Name,Product2Id,Product2.DP_Product_Type__c,Product2.DP_Account__c, Product2.DP_Overage_Unit_price__c, Product2.DP_Unit_Of_Measure__c, Product2.DP_Customer_Specific__c
                                    FROM PriceBookEntry 
                                    WHERE Product2.DP_Product_Type__c = :cSearchProd
                                    AND Product2.DP_Service_Type__c INCLUDES (:cServiceType)
                                    AND Product2.DP_Product_Type__c != null 
                                    AND IsActive = true  
                                    AND IsDeleted = false 
                                    AND Product2.DP_Availability__c IN ('Available','Limited')  
                                    ORDER BY Product2.Name asc]);
        } else if((cSearchProd == null || cSearchProd == '') && cSearchDCId!=null && cSearchDCId!=''){
             /*lstPBE = [SELECT Id,Product2.Name,Product2Id,Product2.DP_Product_Type__c,Product2.DP_Account__c, Product2.DP_Overage_Unit_price__c, Product2.DP_Unit_Of_Measure__c, Product2.DP_Customer_Specific__c
                                    FROM PriceBookEntry 
                                    WHERE (Product2.DP_Data_Center__c = :cSearchDCId
                                    OR Product2.DP_Data_Center__c = null) 
                                    AND Product2.DP_Service_Type__c INCLUDES (:cServiceType)
                                    AND Product2.DP_Product_Type__c != null 
                                    AND IsActive = true  
                                    AND IsDeleted = false 
                                    AND Product2.DP_Availability__c IN ('Available','Limited')  
                                    ORDER BY Product2.Name asc];*/
          lstPBE =new map<Id,PricebookEntry>([SELECT Id,Product2.Name,Product2Id,Product2.DP_Product_Type__c,Product2.DP_Account__c, Product2.DP_Overage_Unit_price__c, Product2.DP_Unit_Of_Measure__c, Product2.DP_Customer_Specific__c
                                    FROM PriceBookEntry 
                                    WHERE (Product2.DP_Data_Center__c = :cSearchDCId
                                    OR Product2.DP_Data_Center__c = null) 
                                    AND Product2.DP_Service_Type__c INCLUDES (:cServiceType)
                                    AND Product2.DP_Product_Type__c != null 
                                    AND IsActive = true  
                                    AND IsDeleted = false 
                                    AND Product2.DP_Availability__c IN ('Available','Limited')  
                                    ORDER BY Product2.Name asc]);
        } else {
           /* lstPBE = [SELECT Id,Product2.Name,Product2Id,Product2.DP_Product_Type__c,Product2.DP_Account__c, Product2.DP_Overage_Unit_price__c, Product2.DP_Unit_Of_Measure__c, Product2.DP_Customer_Specific__c
                                    FROM PriceBookEntry 
                                    WHERE Product2.DP_Product_Type__c != null 
                                    AND Product2.DP_Service_Type__c INCLUDES (:cServiceType)
                                    AND IsActive = true  
                                    AND IsDeleted = false 
                                    AND Product2.DP_Availability__c IN ('Available','Limited') 
                                    ORDER BY Product2.Name asc];*/
              lstPBE = new map<Id,PriceBookEntry>([SELECT Id,Product2.Name,Product2Id,Product2.DP_Product_Type__c,Product2.DP_Account__c, Product2.DP_Overage_Unit_price__c, Product2.DP_Unit_Of_Measure__c, Product2.DP_Customer_Specific__c
                                    FROM PriceBookEntry 
                                    WHERE Product2.DP_Product_Type__c != null 
                                    AND Product2.DP_Service_Type__c INCLUDES (:cServiceType)
                                    AND IsActive = true  
                                    AND IsDeleted = false 
                                    AND Product2.DP_Availability__c IN ('Available','Limited') 
                                    ORDER BY Product2.Name asc]);
        }
        
        Map<Id, DP_Customer_Specific_Product__c> cspMap = new Map<Id, DP_Customer_Specific_Product__c>();
        for (DP_Customer_Specific_Product__c csp : [SELECT Id, DP_Account__c, DP_Product__c 
                                                 FROM DP_Customer_Specific_Product__c 
                                                 WHERE DP_Account__c = :cAccount.Id AND DP_Product__r.DP_Customer_Specific__c = true]){
            cspMap.put(csp.DP_Product__c, csp);
        }
        List<PriceBookEntry> tmpList = new List<PriceBookEntry>();
        
        for (PriceBookEntry pbe : lstPBE.values()){
            if (pbe.Product2.DP_Customer_Specific__c){
                if (cspMap.containsKey(pbe.Product2Id)){
                    tmpList.add(pbe);
                }            
            } else {
                tmpList.add(pbe);
            }
        }
       // lstPBE = tmpList;
        tmpList =lstPBE.values();
        
        FlexItemSource fis = new FlexItemSource();
        List<FlexItem> lstFL = new list<FlexItem>();
        for(PriceBookEntry pbe : lstPBE.values()){
            //if(pbe.Product2.DP_Service_Type__c == cServiceType){
            if(pbe.Product2.DP_Account__c == null || pbe.Product2.DP_Account__c == cAccount.Id || cCustSpecProdMap.containsKey(pbe.Product2.Id)){
                FlexItem fl = new FlexItem();
                fl.id = pbe.id;
                if(cCustSpecProdMap.containsKey(pbe.Product2.Id)){
                    fl.name = cCustSpecProdMap.get(pbe.Product2.Id).Name+'*';
                } else {
                    fl.name = pbe.Product2.Name;
                }
                if(pbe.Product2.DP_Account__c != null){
                    fl.name += '*';
                }
                lstFL.add(fl);
            }
        }
        fis.results = lstFL;
        return JSON.serialize(fis);
    }
    
    /*
    @Name        :addProduct
    @Description :Add a product to the quote line items grid
    */
    public PageReference addProduct(){
        //Create the new quote line item as a serialized json item and return to the page, the oncomplete will add the new item to the grid
        List<PriceBookEntry> lstPBE = [SELECT Id,PriceBook2Id,Product2Id,Product2.DP_Availability__c,Name, Product2.DP_LandedCost__c,Product2.DP_CAPEX__c, Product2.DP_Overage_Unit_Price__c, Product2.DP_Unit_Of_Measure__c,
                                Product2.DP_Data_Center__c,Product2.DP_Data_Center__r.Name,Product2.DP_Data_Center__r.DP_Name_Abbr__c,Product2.DP_kW__c,Product2.DP_Cost__c,Product2.DP_Markup__c,
                                Product2.DP_Max_Discount__c,Product2.DP_Data_Center__r.DP_kWCost__c,Product2.DP_Data_Center__r.DP_kW_Markup__c, Product2.DP_Asset_Type__c,
                                product2.DP_type_order__c,Product2.DP_Formula_Exempt__c,Product2.DP_Product_Type__c,Product2.DP_Product_Category__c,Product2.DP_Setup__c,Product2.DP_Account__c      
                                FROM PriceBookEntry 
                                WHERE Id = :cstrPBEID];
        if(lstPBE.size() == 0){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Product no longer available.'));
        } else {
            JQGridItem jqgi = convertPBE2JQGI(lstPBE.get(0),null,null,'No');
            List<JQGridItem> lstJQGI = (List<JQGridItem>)JSON.deserialize(strJSONQLGrid,List<JQGridItem>.class);
            lstJQGI.add(jqgi);
            //add the required child products here
            List<DP_Product_Compatibility__c> pcList = [SELECT Id,DP_Child_Product__c,DP_Parent_Product__c,DP_Base_Quantity__c,DP_Minimum_Quantity__c,DP_Maximum_Quantity__c,DP_Increment_Quantity__c   
                                                     FROM DP_Product_Compatibility__c
                                                     WHERE DP_Parent_Product__c = :lstPBE[0].Product2Id 
                                                     AND DP_Child_Product__r.DP_Availability__c IN ('Available','Limited')];
            Map<String,DP_Product_Compatibility__c> childProdMap = new Map<String,DP_Product_Compatibility__c>();
            if(pcList.size()>0){
                for(DP_Product_Compatibility__c pc : pcList){
                    if(pc.DP_Child_Product__c!=null && pc.DP_Minimum_Quantity__c!=null && pc.DP_Minimum_Quantity__c>0){
                        childProdMap.put(pc.DP_Child_Product__c,pc);
                    }
                }
                List<PriceBookEntry> lstChildPBE = [SELECT Id,PriceBook2Id,Product2Id,Product2.DP_Availability__c,Name, Product2.DP_LandedCost__c,Product2.DP_CAPEX__c, Product2.DP_Overage_Unit_Price__c, Product2.DP_Unit_Of_Measure__c,
                                    Product2.DP_Data_Center__c,Product2.DP_Data_Center__r.Name,Product2.DP_Data_Center__r.DP_Name_Abbr__c,Product2.DP_kW__c,Product2.DP_Cost__c,Product2.DP_Markup__c,
                                    Product2.DP_Max_Discount__c,Product2.DP_Data_Center__r.DP_kWCost__c,Product2.DP_Data_Center__r.DP_kW_Markup__c,Product2.DP_Formula_Exempt__c,  
                                    product2.DP_type_order__c,Product2.DP_Product_Type__c,Product2.DP_Product_Category__c,Product2.DP_Setup__c,Product2.DP_Account__c, Product2.DP_Asset_Type__c
                                    FROM PriceBookEntry 
                                    WHERE Product2Id IN :childProdMap.keySet()]; 
                for(PriceBookEntry pbe : lstChildPBE){
                    
                    JQGridItem jqgiChild = convertPBE2JQGI(pbe,jqgi,childProdMap.get(pbe.Product2Id),'Yes');
                    lstJQGI.add(jqgiChild);
                }
            }
            strJSONQLGrid = JSON.serialize(lstJQGI);
            calcMrrByTerm();
            Map<String,String> exstngGrpsMap = new Map<String,String>();
            for(SelectOption s : cQuoteGroups){
                exstngGrpsMap.put(s.getLabel(),s.getLabel());    
            }
            for(String s : mapQLGs.keySet()){
                if(!exstngGrpsMap.containsKey(s) && s != null){
                    if(s != 'Change' && s != 'Remove'){
                        cQuoteGroups.add(new SelectOption(s,s));
                    }
                }
            }
            cstrQuoteGroup='';
        }
        cUnit = null;
        cOveragePrice = null;
        return null;
    } 
    
    /*
    @Name        :getPriceBookEntriesPC
    @Description :Returns the list of PriceBookEntries for the FlexBox to use in configure section and populates the configureation products grid
    */
    public String getPriceBookEntriesPC(){
        FlexItemSource fis = new FlexItemSource();
        List<FlexItem> lstFL = new list<FlexItem>();
        List<JQGridItem> lstJQGI = new List<JQGridItem>();
        if(cstrConfigReqProdType != null && cstrConfigReqProdType != ''){
            for(String strType : mapTypeReqChildDisplay.keySet()){
                if(strType == cstrConfigReqProdType){
                    for(JQGridItem jqgi : mapTypeReqChildDisplay.get(strType).values()){
                        FlexItem fl = new FlexItem();
                        fl.id = jqgi.strPBEId;
                        fl.name = jqgi.strQLIName;
                        lstFL.add(fl);
                        lstJQGI.add(jqgi);
                    }
                }
            }
        } else if (cstrConfigProdType != null && cstrConfigProdType != ''){
            for(String strType : mapTypeChildDisplay.keySet()){
                if(strType == cstrConfigProdType){
                    for(JQGridItem jqgi : mapTypeChildDisplay.get(strType).values()){
                        FlexItem fl = new FlexItem();
                        fl.id = jqgi.strPBEId;
                        fl.name = jqgi.strQLIName;
                        lstFL.add(fl);
                        lstJQGI.add(jqgi);
                    }
                }
            }
        } else if (mapTypeChildDisplay != null){
            for(String strType : mapTypeChildDisplay.keySet()){
                for(JQGridItem jqgi : mapTypeChildDisplay.get(strType).values()){
                    FlexItem fl = new FlexItem();
                    fl.id = jqgi.strPBEId;
                    fl.name = jqgi.strQLIName;
                    lstFL.add(fl);
                    lstJQGI.add(jqgi);
                }
            }
        }
        //If the user chooses a specific item then show only that item
        if(pbeRecId != null && pbeRecId != ''){
            JQGridItem jqgi1 = new JQGridItem();
            for(JQGridItem jqgi : lstJQGI){
                if(jqgi.strPBEId == pbeRecId){
                    jqgi1 = jqgi;
                    break;
                }
            }
            lstJQGI.clear();
            lstJQGI.add(jqgi1);
        }
        fis.results = lstFL;
        strJSONConfigGrid = JSON.serialize(lstJQGI);
        return JSON.serialize(fis);
    }
    
    /*
    @Name        :filterPC
    @Description :filter the product compatibilty based on selected product type and product
    */
    public PageReference filterPC(){
        getPriceBookEntriesPC();
        return null;
    }
    
    /*
    @Name        :selectPriceBook
    @Description :Show the select pricebook screen if the Opportunity does not have one
    */
    public PageReference selectPriceBook(){
        PageReference pg = null;
        if(cQuote.PriceBook2Id == null) {
            if(cOpportunity.PriceBook2Id != null){
                cQuote.PriceBook2Id = cOpportunity.PriceBook2Id;
            } else {
                List<PriceBook2> lstPBs = [SELECT Id,Name FROM PriceBook2 WHERE isActive = true];
                if(lstPBs.size() == 1){
                    cQuote.PriceBook2Id = lstPBs.get(0).Id;
                    cOpportunity.PriceBook2Id = lstPBs.get(0).Id;
                } else if(cQuote.Id == null){
                    pg = new PageReference('/oppitm/choosepricebook.jsp?id=' + cOpportunity.Id + 
                    //This is the return url for when the user clicks cancel
                    '&retURL=%2F' + cOpportunity.Id +
                    //This is the save url for when the user clicks save
                    '&sUrl=%2Fapex%2FNewEditQuote%3FoppId%3D' + cOpportunity.Id + '%26retURL=%2F' + cOpportunity.Id);
                } else {
                    pg = new PageReference('/oppitm/choosepricebook.jsp?id=' + cOpportunity.Id + 
                    //This is the return url for when the user clicks cancel
                    '&retURL=%2F' + cQuote.Id +
                    //This is the save url for when the user clicks save
                    '&sUrl=%2Fapex%2FNewEditQuote%3FId%3D' + cQuote.Id + '%26retURL=%2F' + cQuote.Id);
                }
            }
        }
        return pg;
    }
    
    /*
    @Name        :getDataCenterNames
    @Description :Returns all available data center names in alphabetical order asc in name:name; pairs to be used as the options for the qli grid dropdown
    */     
    public String getDataCenterNames(){
        String strReturn = '\'';
        List<DP_DataCenter__c> lstDC = [SELECT Id,Name,DP_Name_Abbr__c,DP_kWCost__c,DP_kW_Markup__c FROM DP_DataCenter__c WHERE DP_Available_To_Use_On_Quote_Line__c=True ORDER BY Name ASC];
        for(Integer i = 0;i < lstDC.size();i++){
            DP_DataCenter__c dc = lstDC.get(i);
            if(i == 0){
                strReturn += dc.DP_Name_Abbr__c+ ':' + dc.DP_Name_Abbr__c;
            } else {
                strReturn += ';' + dc.DP_Name_Abbr__c+ ':' + dc.DP_Name_Abbr__c;
            }
        }
        strReturn += '\'';
        return strReturn;
    }
    
    /*
    @Name        :changeCurrency
    @Description :Retrives the currency for the iso code using exchangerateintegration class
    */  
    public PageReference changeCurrency(){
        try{
            //Get the old and new currency rate
            Decimal oldExRate = cQuote.DP_Exchange_Rate__c;
            cQuote.DP_Exchange_Rate__c = ExchangeRateIntegration.getexchangerate(cQuote.DP_Currency_Code__c);
            List<JQGridItem> lstJQGI = (List<JQGridItem>)JSON.deserialize(strJSONQLGrid,List<JQGridItem>.class);
            for(JQGridItem jqgi : lstJQGI){
                //Set the setupfee back to us dollar's before chanigng it to another currency
                jqgi.decSetupFee = jqgi.decSetupFee * oldExRate;
                jqgi.decSetupFee = jqgi.decSetupFee / cQuote.DP_Exchange_Rate__c;
                Decimal qty = jqgi.decQty;
                Decimal bQty = jqgi.baseQty;
                if(jqgi.strIsParent == '1'){
                    qty = qty * jqgi.decParentQty;
                    bQty = bQty * jqgi.decParentQty;
                }
                jqgi.decDPLPUSD = DP_DatapipeUtility.calculate_datapipeListPriceUSD(
                                                cQuote.DP_Term__c, 
                                                cQuote.DP_Operational_Life_Factor__c,
                                                cQuote.DP_Cost_of_Money__c,
                                                cQuote.DP_Money_Making_Months__c,
                                                cQuote.DP_Month_to_Month_Multiplier__c,
                                                cQuote.DP_kW_Month_to_Month_Multiplier__c,
                                                cQuote.DP_kW_Hours_In_Month__c,
                                                cQuote.DP_kW_Term_Multiplier__c,
                                                jqgi.decKW,
                                                jqgi.decKWCost,
                                                jqgi.decKWMarkup,
                                                qty,
                                                Boolean.valueOf(jqgi.strExempt),
                                                jqgi.decLandedCost,
                                                bQty);
                jqgi.decMRR = DP_DatapipeUtility.calculate_mrr(jqgi.decDPLPUSD,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount);
                jqgi.decUSDMRR = jqgi.decMRR * cQuote.DP_Exchange_Rate__c;
            }
            strJSONQLGrid = JSON.serialize(lstJQGI);
            calcMrrByTerm();
            //Only recalc the config section if it is shown
            if(showConfig){
                List<JQGridItem> lstJQGIPreview = (List<JQGridItem>)JSON.deserialize(strJSONPreviewGrid,List<JQGridItem>.class);
                for(JQGridItem jqgi : lstJQGIPreview){
                    //Set the setupfee back to us dollar's before chanigng it to another currency
                    jqgi.decSetupFee = jqgi.decSetupFee * oldExRate;
                    jqgi.decSetupFee = jqgi.decSetupFee / cQuote.DP_Exchange_Rate__c;
                    Decimal qty = jqgi.decQty;
                    Decimal bQty = jqgi.baseQty;
                    if(jqgi.strIsParent == '1'){
                        qty = qty * jqgi.decParentQty;
                        bQty = bQty * jqgi.decParentQty;
                    }
                    jqgi.decDPLPUSD = DP_DatapipeUtility.calculate_datapipeListPriceUSD(
                                                    cQuote.DP_Term__c, 
                                                    cQuote.DP_Operational_Life_Factor__c,
                                                    cQuote.DP_Cost_of_Money__c,
                                                    cQuote.DP_Money_Making_Months__c,
                                                    cQuote.DP_Month_to_Month_Multiplier__c,
                                                    cQuote.DP_kW_Month_to_Month_Multiplier__c,
                                                    cQuote.DP_kW_Hours_In_Month__c,
                                                    cQuote.DP_kW_Term_Multiplier__c,
                                                    jqgi.decKW,
                                                    jqgi.decKWCost,
                                                    jqgi.decKWMarkup,
                                                    qty,
                                                    Boolean.valueOf(jqgi.strExempt),
                                                    jqgi.decLandedCost,
                                                    bQty);
                    jqgi.decMRR = DP_DatapipeUtility.calculate_mrr(jqgi.decDPLPUSD,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount);
                    jqgi.decUSDMRR = jqgi.decMRR * cQuote.DP_Exchange_Rate__c;
                }
                for(Map<String,JQGridItem> mapSJQGI : mapTypeChild.values()){
                    for(JQGridItem jqgi : mapSJQGI.values()){
                        //Set the setupfee back to us dollar's before chanigng it to another currency
                        jqgi.decSetupFee = jqgi.decSetupFee * oldExRate;
                        jqgi.decSetupFee = jqgi.decSetupFee / cQuote.DP_Exchange_Rate__c;
                        Decimal qty = jqgi.decQty;
                        Decimal bQty = jqgi.baseQty;
                        if(jqgi.strIsParent == '1'){
                            qty = qty * jqgi.decParentQty;
                            bQty = bQty * jqgi.decParentQty;
                        }
                        jqgi.decDPLPUSD = DP_DatapipeUtility.calculate_datapipeListPriceUSD(
                                                        cQuote.DP_Term__c, 
                                                        cQuote.DP_Operational_Life_Factor__c,
                                                        cQuote.DP_Cost_of_Money__c,
                                                        cQuote.DP_Money_Making_Months__c,
                                                        cQuote.DP_Month_to_Month_Multiplier__c,
                                                        cQuote.DP_kW_Month_to_Month_Multiplier__c,
                                                        cQuote.DP_kW_Hours_In_Month__c,
                                                        cQuote.DP_kW_Term_Multiplier__c,
                                                        jqgi.decKW,
                                                        jqgi.decKWCost,
                                                        jqgi.decKWMarkup,
                                                        qty,
                                                        Boolean.valueOf(jqgi.strExempt),
                                                        jqgi.decLandedCost,
                                                        bQty);
                        jqgi.decMRR = DP_DatapipeUtility.calculate_mrr(jqgi.decDPLPUSD,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount);
                        jqgi.decUSDMRR = jqgi.decMRR * cQuote.DP_Exchange_Rate__c;
                    }
                }
                for(Map<String,JQGridItem> mapSJQGI : mapTypeReqChild.values()){
                    for(JQGridItem jqgi : mapSJQGI.values()){
                        //Set the setupfee back to us dollar's before chanigng it to another currency
                        jqgi.decSetupFee = jqgi.decSetupFee * oldExRate;
                        jqgi.decSetupFee = jqgi.decSetupFee / cQuote.DP_Exchange_Rate__c;
                        Decimal qty = jqgi.decQty;
                        Decimal bQty = jqgi.baseQty;
                        if(jqgi.strIsParent == '1'){
                            qty = qty * jqgi.decParentQty;
                            bQty = bQty * jqgi.decParentQty;
                        }
                        jqgi.decDPLPUSD = DP_DatapipeUtility.calculate_datapipeListPriceUSD(
                                                        cQuote.DP_Term__c, 
                                                        cQuote.DP_Operational_Life_Factor__c,
                                                        cQuote.DP_Cost_of_Money__c,
                                                        cQuote.DP_Money_Making_Months__c,
                                                        cQuote.DP_Month_to_Month_Multiplier__c,
                                                        cQuote.DP_kW_Month_to_Month_Multiplier__c,
                                                        cQuote.DP_kW_Hours_In_Month__c,
                                                        cQuote.DP_kW_Term_Multiplier__c,
                                                        jqgi.decKW,
                                                        jqgi.decKWCost,
                                                        jqgi.decKWMarkup,
                                                        qty,
                                                        Boolean.valueOf(jqgi.strExempt),
                                                        jqgi.decLandedCost,
                                                        bQty);
                        jqgi.decMRR = DP_DatapipeUtility.calculate_mrr(jqgi.decDPLPUSD,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount);
                        jqgi.decUSDMRR = jqgi.decMRR * cQuote.DP_Exchange_Rate__c;
                    }
                }
                strJSONPreviewGrid = JSON.serialize(lstJQGIPreview);
                setAvailableChildren(lstJQGIPreview);
            }
        } catch (Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,e.getMessage()));
        }
        return null;
    }
    
    /*
    @Name        :getDataCenters
    @Description :Returns the list of Data Centers for the FlexBox to use
    */
    public String getDataCenters(){
        List<DP_DataCenter__c> lstDC = [SELECT Id,Name,DP_Name_Abbr__c FROM DP_DataCenter__c WHERE IsDeleted=false AND DP_Available_To_Use_On_Quote_Line__c=True ORDER BY Name asc];
        FlexItemSource fis = new FlexItemSource();
        List<FlexItem> lstFL = new list<FlexItem>();
        for(DP_DataCenter__c dc : lstDC){
            FlexItem fl = new FlexItem();
            fl.id = dc.id;
            fl.name = dc.Name;
            lstFL.add(fl);
        }
        fis.results = lstFL;
        return JSON.serialize(fis);
    }
    
    /*
    @Name   :getSuggestedProducts
    @Description : getter for SuggestedProducts
    */
    public Map<String,List<PriceBookEntry>> getSuggestedProducts(){

        Map<String,List<PriceBookEntry>> retList = new Map<String,List<PriceBookEntry>>();
        Set<Id> SuggestedProductIds = new Set<Id>();
        Set<String> setProdCodes = new Set<String>();
        for(Product2 prod : [SELECT Id,Name,ProductCode FROM Product2 WHERE DP_Account__c = :cAccount.Id]){
            setProdCodes.add(prod.ProductCode);
        }
        for(DP_Suggested_Product__c sp : [select Id,Product__c 
                                        from DP_Suggested_Product__c 
                                        where (Product__r.DP_Account__c = null AND Product__r.ProductCode not in :setProdCodes) 
                                        OR Product__r.DP_Account__c = :cAccount.Id ]){
            SuggestedProductIds.add(sp.Product__c);
        }
        List<Id> spList = new List<Id>();
        spList.addAll(SuggestedProductIds);
    for(PriceBookEntry pbe : database.query('select Product2.DP_Account__c,Product2.Name,Product2.DP_Product_Type__c,product2.DP_type_order__c, ' + DP_DatapipeUtility.getFields('PriceBookEntry') + ' from PriceBookEntry where Product2Id in (\'' + String.join(spList,'\',\'') + '\') AND Product2.DP_Availability__c = \'Available\' and product2.isActive=true')){
         
        //map <id,pricebookentry> pbes= new map<id,pricebookentry>([select Product2.DP_Account__c,Product2.Name,Product2.DP_Product_Type__c,product2.DP_type_order__c from PriceBookEntry where Product2Id in (select DP_Product__c from DP_Suggested_Product__c  where DP_Product__r.DP_Account__c = null OR DP_Product__r.DP_Account__c =:cAccount.Id)]);         
        // for(PriceBookEntry pbe : database.query('select Product2.DP_Account__c,Product2.Name,Product2.DP_Product_Type__c,product2.DP_type_order__c,' + DP_DatapipeUtility.getFields('PriceBookEntry') + ' from PriceBookEntry where Product2Id in (select DP_Product__c from DP_Suggested_Product__c  where Product__r.DP_Account__c = null OR Product__r.DP_Account__c =:cAccount.Id)')){
           
           
           // for(PriceBookEntry pbe :pbes.values()){
             //for(PriceBookEntry pbe :pbe){
            if(pbe.Product2.DP_Account__c != null){
                if (cCustSpecProdMap.containsKey(pbe.Product2.Id)){                
                    pbe.Product2.Name = cCustSpecProdMap.get(pbe.Product2.Id).Name + '*';    
                } else {
                    pbe.Product2.Name += '*';
                }        
                        
            }
            if(retList.containsKey(pbe.product2.DP_product_type__c)){
                retList.get(pbe.product2.DP_product_type__c).add(pbe);
            } else {
                List<PriceBookEntry> tmp = new List<PriceBookEntry>();
                tmp.add(pbe);
                retList.put(pbe.Product2.DP_product_type__c,tmp);
            }
        }
        
        return retList;
    }
    
    /*
    @Name   :configProd
    @Description : Sets up the configure section for the parent chosen from the quote ines grid
    */
    public PageReference configProd(){
        //Get the parent and children from the quote line grid
        List<JQGridItem> jqGridItemList = (List<JQGridItem>)JSON.deserialize(strJSONQLGrid,List<JQGridItem>.class);
        system.debug('jqgriditemlist:'+jqgriditemlist);
        List<JQGridItem> lstPreviewGrid = new List<JQGridItem>();
        JQGridItem jqgiParent;
        for(JQGridItem jqgiQL : jqGridItemList){
            if(strParentQLIId == jqgiQL.strParentId){
                if(jqgiQL.strRequired != 'Yes'){
                system.debug('Inside configprod strrequired:'+jqgiql.strrequired);
                    jqgiQL.strAction = '<a href="javascript:void(0)" onclick="javascript:delPreviewRow(\''+jqgiQL.strQLItemId+'\');">Del</a>';
                }
                if(jqgiQL.strAssetAction == 'Change'){
                    jqgiQL.strAction = '<a href="javascript:void(0)" onclick="javascript:flipPreviewRow(\''+jqgiQL.strQLItemId+'\');">Rem</a>';
                }
                if(strParentQLIId == jqgiQL.strQLItemId){
                    jqgiParent = jqgiQL;
                    jqgiQL.strAction = null;
                }
                if(jqgiQL.isDynamic == 'true'){
                    cDynamic = true;
                    cUnit = jqgiParent.strUnit;
                    cOveragePrice = jqgiParent.decOveragePrice;
                    system.debug('new cUnit etc: '+cUnit+' '+cOveragePrice);                 
                }
                jqgiQL.strServiceType = cServiceType;
                system.debug('Inside configprod before lstpreview:'+jqgiql);
               
                lstPreviewGrid.add(jqgiQL);
            }
        }
        setAllChildren(jqgiParent);
        //Set the preview grid to contain the same items from the quote line grid
        strJSONPreviewGrid = JSON.serialize(lstPreviewGrid);
        //Set the display name of the configure section
        cConfigName = jqgiParent.strQLIName;
        //Set the product type and required product type options
        setAvailableChildren(lstPreviewGrid);
        showConfig = true;
        return null;
    }

    
    /*
    @Name   :configNewProd
    @Description : Creates the new jqgriditem and loads the configure section for it
    */
    public PageReference configNewProd(){
        //Create the jqgrid item for the parent product
        List<PriceBookEntry> lstParentPBE = [SELECT Id,PriceBook2Id,Product2Id,Product2.DP_Availability__c,Name, Product2.DP_LandedCost__c,Product2.DP_CAPEX__c, Product2.DP_Overage_Unit_Price__c, Product2.DP_Unit_Of_Measure__c,
                                Product2.DP_Data_Center__c,Product2.DP_Data_Center__r.Name,Product2.DP_Data_Center__r.DP_Name_Abbr__c,Product2.DP_kW__c,Product2.DP_Cost__c,Product2.DP_Markup__c,
                                Product2.DP_Max_Discount__c,Product2.DP_Data_Center__r.DP_kWCost__c,Product2.DP_Data_Center__r.DP_kW_Markup__c, Product2.DP_Asset_Type__c,
                                product2.DP_type_order__c,Product2.DP_Formula_Exempt__c,Product2.DP_Product_Type__c,Product2.DP_Product_Category__c,Product2.DP_Setup__c,Product2.DP_Account__c       
                                FROM PriceBookEntry 
                                WHERE Id = :cstrPBEID];
        if(lstParentPBE.size() == 0){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Product no longer available.'));
        } else {
            JQGridItem jqgiParent = convertPBE2JQGI(lstParentPBE.get(0),null,null,'No');
            cUnit = jqgiParent.strUnit;
            cOveragePrice = jqgiParent.decOveragePrice;
            system.debug('new cUnit etc: '+cUnit+' '+cOveragePrice);
            jqgiParent.strAction = null;
            setAllChildren(jqgiParent);
            //Set the display name of the configure section
            cConfigName = jqgiParent.strQLIName;
            //Set the product type and required product type options
            setAvailableChildren(setAllChildren(jqgiParent));
            showConfig = true;
        }
        system.debug('strJSONPreviewGrid: '+strJSONPreviewGrid);
        return null;
    }
    
    /*
    @Name   :setAllChildren
    @Description : Gets the list of children with respect to required status and type
    */
    public List<JQGridItem> setAllChildren(JQGridItem jqgiParent){
        //Create the map of product types to jqgriditems for the children and required children
        mapTypeChild = new Map<String,Map<String,JQGridItem>>();
        mapTypeReqChild = new Map<String,Map<String,JQGridItem>>();
     /*   List<DP_Product_Compatibility__c> lstPCs = [SELECT Id,DP_Child_Product__c,DP_Product_Type__c,DP_Parent_Product__c,DP_Base_Quantity__c,DP_Minimum_Quantity__c,DP_Maximum_Quantity__c,DP_Increment_Quantity__c   
                                                     FROM DP_Product_Compatibility__c
                                                     WHERE DP_Parent_Product__c = :jqgiParent.strProductId 
                                                     AND (DP_Child_Product__c = null OR DP_Child_Product__r.DP_Availability__c IN ('Available','Limited'))];
                  */                                   
       
       System.debug('jqgiParent.strProductId:'+jqgiParent.strProductId);                                              
        Map<ID,DP_Product_Compatibility__c> lstPCs =new map<Id,DP_Product_Compatibility__C>( [SELECT Id,DP_Child_Product__c,DP_Product_Type__c,DP_Parent_Product__c,DP_Base_Quantity__c,DP_Minimum_Quantity__c,DP_Maximum_Quantity__c,DP_Increment_Quantity__c   
                                                     FROM DP_Product_Compatibility__c
                                                     WHERE DP_Parent_Product__c = :jqgiParent.strProductId 
                                                     AND (DP_Child_Product__c = null OR DP_Child_Product__r.DP_Availability__c IN ('Available','Limited'))]);
                                                     
        Set<Id> setChildProdIds = new Set<Id>();
        Map<String,Set<Id>> mapChildTypeIds = new Map<String,Set<Id>>();
        system.debug('lstpcs:Prodcomaptibilty:'+lstpcs);
        for(DP_Product_Compatibility__c pc : lstPCs.values()){
            if(pc.DP_Child_Product__c != null){
                setChildProdIds.add(pc.DP_Child_Product__c);
            } else {
                mapChildTypeIds.put(pc.DP_Product_Type__c,new Set<Id>());
            } 
        }
        
        system.debug(json.serialize(setChildProdIds));
         system.debug('line1561:::SetChildProdIds');
        
        Set<String> setProdCodes = new Set<String>();
        for(Product2 prod : [SELECT Id,Name,ProductCode FROM Product2 WHERE DP_Account__c = :cAccount.Id]){
            setProdCodes.add(prod.ProductCode);
        }
        
        system.debug(json.serialize(setProdCodes));
        List<PriceBookEntry> lstChildPBEs = [SELECT Id,PriceBook2Id,Product2Id,Product2.DP_Availability__c,Name, Product2.DP_LandedCost__c,Product2.DP_CAPEX__c, Product2.DP_Overage_Unit_Price__c, Product2.DP_Unit_Of_Measure__c,
                                Product2.DP_Data_Center__c,Product2.DP_Data_Center__r.Name,Product2.DP_Data_Center__r.DP_Name_Abbr__c,Product2.DP_kW__c,Product2.DP_Cost__c,Product2.DP_Markup__c,
                                Product2.DP_Max_Discount__c,Product2.DP_Data_Center__r.DP_kWCost__c,Product2.DP_Data_Center__r.DP_kW_Markup__c, Product2.DP_Asset_Type__c,
                                product2.DP_type_order__c,Product2.DP_Formula_Exempt__c, Product2.DP_Product_Type__c,Product2.DP_Product_Category__c,Product2.DP_Setup__c,Product2.DP_Account__c     
                                FROM PriceBookEntry 
                                WHERE CurrencyIsoCode = 'USD' 
                                AND IsActive = true 
                                AND Pricebook2.IsStandard = true 
                                AND (Product2Id IN :setChildProdIds 
                                OR Product2.DP_Product_Type__c IN :mapChildTypeIds.keySet()) 
                                AND Product2.DP_Availability__c IN ('Available','Limited') 
                                AND ((Product2.DP_Account__c = null AND Product2.ProductCode not in :setProdCodes) 
                                        OR Product2.DP_Account__c = :cAccount.Id) ]; 
                                        
                                        system.debug(json.serialize(setChildProdIds));
                                        system.debug(json.serialize(mapChildTypeIds.keySet()));
                                        system.debug(json.serialize(setProdCodes));
                                        system.debug(cAccount.Id);
                                        
        //system.debug(json.serialize(lstChildPBEs));
        Map<String,PriceBookEntry> mapProdPBE = new Map<String,PriceBookEntry>();
        for(PriceBookEntry pbe : lstChildPBEs){
            mapProdPBE.put(pbe.Product2Id,pbe);
            if(mapChildTypeIds.containsKey(pbe.Product2.DP_Product_Type__c)){
                mapChildTypeIds.get(pbe.Product2.DP_Product_Type__c).add(pbe.Product2Id);
            }
        }
        
        system.debug(json.serialize(mapchildtypeids));
        //Add the type based compatibilities first
       // for(DP_Product_Compatibility__c pc : lstPCs){
           for(DP_Product_Compatibility__c pc : lstPCs.values()){
            if(pc.DP_Child_Product__c == null){
                String type = pc.DP_Product_Type__c;
                system.debug('type = ' + type);
                if(mapChildTypeIds.containsKey(type)){
                    if(pc.DP_Minimum_Quantity__c > 0){
                        //Add the type items to the required child items map
                        for(Id prodId : mapChildTypeIds.get(type)){
                            if(mapProdPBE.containsKey(prodId)){
                                JQGridItem jqgiChild = convertPBE2JQGI(mapProdPBE.get(prodId),jqgiParent,pc,'Yes Type');
                                jqgiChild.strAction = '<a href="javascript:void(0)" onclick="javascript:addToPreviewAF(\''+jqgiChild.strQLItemId+'\');">'+'Add to Preview'+'</a>';
                                if(jqgiChild.decQty == 0) jqgiChild.decQty = 1;
                                if(mapTypeReqChild.containsKey(type)){
                                    mapTypeReqChild.get(type).put(prodId,jqgiChild);
                                } else {
                                    Map<String,JQGridItem> mapTemp = new Map<String,JQGridItem>();
                                    mapTemp.put(prodId,jqgiChild);
                                    mapTypeReqChild.put(type,mapTemp);
                                }
                                system.debug('added:');
                                system.debug(JSON.serialize(jqgiChild));
                            }
                        }
                    } else {
                        //Add the type items to the non required map
                        for(Id prodId : mapChildTypeIds.get(type)){
                            if(mapProdPBE.containsKey(prodId)){
                                JQGridItem jqgiChild = convertPBE2JQGI(mapProdPBE.get(prodId),jqgiParent,pc,'No');
                                jqgiChild.strAction = '<a href="javascript:void(0)" onclick="javascript:addToPreviewAF(\''+jqgiChild.strQLItemId+'\');">'+'Add to Preview'+'</a>';
                                if(mapTypeChild.containsKey(type)){
                                    mapTypeChild.get(type).put(prodId,jqgiChild);
                                } else {
                                    Map<String,JQGridItem> mapTemp = new Map<String,JQGridItem>();
                                    mapTemp.put(prodId,jqgiChild);
                                    mapTypeChild.put(type,mapTemp);
                                }
                            }
                        }
                    }
                }
            }
        }
        List<JQGridItem> lstReqItems = new List<JQGridItem>();
        //Add the child specific compatibilities last, this way they will overwrite the type based if they are for the same product
      //  for(DP_Product_Compatibility__c pc : lstPCs){
      for(DP_Product_Compatibility__c pc : lstPCs.values()){
            if(pc.DP_Child_Product__c != null){
                String type = pc.DP_Product_Type__c;
                Id prodId = pc.DP_Child_Product__c;
                if(pc.DP_Minimum_Quantity__c > 0 && mapProdPBE.containsKey(prodId)){
                    //Add the item to the required child items map
                    JQGridItem jqgiChild = convertPBE2JQGI(mapProdPBE.get(prodId),jqgiParent,pc,'Yes');
                    jqgiChild.strAction = null;
                    /*if(mapTypeReqChild.containsKey(type)){
                        mapTypeReqChild.get(type).put(prodId,jqgiChild);
                    } else {
                        Map<String,JQGridItem> mapTemp = new Map<String,JQGridItem>();
                        mapTemp.put(prodId,jqgiChild);
                        mapTypeReqChild.put(type,mapTemp);
                    }*/
                    lstReqItems.add(jqgiChild);
                } else if(mapProdPBE.containsKey(prodId)){
                    //Add the type items to the non required map
                    JQGridItem jqgiChild = convertPBE2JQGI(mapProdPBE.get(prodId),jqgiParent,pc,'No');
                    jqgiChild.strAction = '<a href="javascript:void(0)" onclick="javascript:addToPreviewAF(\''+jqgiChild.strQLItemId+'\');">'+'Add to Preview'+'</a>';          
                    if(mapTypeChild.containsKey(type)){
                        mapTypeChild.get(type).put(prodId,jqgiChild);
                    } else {
                        Map<String,JQGridItem> mapTemp = new Map<String,JQGridItem>();
                        mapTemp.put(prodId,jqgiChild);
                        mapTypeChild.put(type,mapTemp);
                    }
                }
            }
        }
        //Set the preview grid to contain the required individual items
        List<JQGridItem> lstJQGIPreview = new List<JQGridItem>();
        lstJQGIPreview.add(jqgiParent);
        lstJQGIPreview.addAll(lstReqItems);
        strJSONPreviewGrid = JSON.serialize(lstJQGIPreview);
        return lstJQGIPreview;
    }
    
    /*
    @Name   :addToPreview
    @Description : Add's the jqgriditem from the configure grid to the preview grid and removes it from the configure grid
    */
    public PageReference addToPreview(){
        if(strAddRowId != null && strAddRowId != ''){
            List<JQGridItem> lstConfigGrid = (List<JQGridItem>)JSON.deserialize(strJSONConfigGrid,List<JQGridItem>.class);
            List<JQGridItem> lstPreviewGrid = (List<JQGridItem>)JSON.deserialize(strJSONPreviewGrid,List<JQGridItem>.class);
            JQGridItem jqgiAdd;
            for(JQGridItem jqgi : lstConfigGrid){
                if(jqgi.strQLItemId == strAddRowId){
                    jqgiAdd = jqgi;
                    jqgiAdd.strAction = '<a href="javascript:void(0)" onclick="javascript:delPreviewRow(\''+jqgiAdd.strQLItemId+'\');">Del</a>';
                    break;
                }
            }
            lstPreviewGrid.add(jqgiAdd);
            strJSONPreviewGrid = JSON.serialize(lstPreviewGrid);
            //Update the items available as children so you cannot add the same item to the same parent twice
            pbeRecId = null;
            setAvailableChildren(lstPreviewGrid);
        }
        return null;
    }
    
    /*
    @Name   :setAvailableChildren
    @Description : Sets the available children based on the total children available - the children already added to that parent
    */
    public void setAvailableChildren(List<JQGridItem> lstPreviewGrid){
        mapTypeChildDisplay = new Map<String,Map<String,JQGridItem>>();
        mapTypeReqChildDisplay = new Map<String,Map<String,JQGridItem>>();
        Map<String,Integer> mapTypeAmount = new Map<String,Integer>();
        Set<String> setPreviewProds = new Set<String>();
        //Keep track of the number of items per type and the set of products already in the preview
        for(JQGridItem jqgi : lstPreviewGrid){
            system.debug('looking at preview products - straction: ' + jqgi.strAction);
            //don't include removed asset items
            if(jqgi.strAssetAction == 'Change' || jqgi.strAssetAction == 'Remove'){
                if(jqgi.strAction != null){
                    if(jqgi.strAction.contains('Add')) continue;
                }
            }
            system.debug('got here anyway sucka!');
                if(mapTypeAmount.containsKey(jqgi.strProdType)){
                    mapTypeAmount.put(jqgi.strProdType,mapTypeAmount.get(jqgi.strProdType) + 1);
                } else {
                    mapTypeAmount.put(jqgi.strProdType,1);
                }
                setPreviewProds.add(jqgi.strProductId);
        }
        //Set up the options to be all children - children in preview
        for(String strType : mapTypeChild.keySet()){
            for(String strProdId : mapTypeChild.get(strType).keySet()){
                JQgridItem jqgi = mapTypeChild.get(strType).get(strProdId);
                if(!setPreviewProds.contains(strProdId)){
                    if(mapTypeChildDisplay.containsKey(strType)){
                        mapTypeChildDisplay.get(strType).put(strProdId,jqgi);
                    } else {
                        Map<String,JQGridItem> mapTemp = new Map<String,JQGridItem>();
                        mapTemp.put(strProdId,jqgi);
                        mapTypeChildDisplay.put(strType,mapTemp);
                    }
                    setPreviewProds.add(strProdId);
                }
            }
        }
        for(String strType : mapTypeReqChild.keySet()){
            if(!mapTypeAmount.containsKey(strType)){
                for(String strProdId : mapTypeReqChild.get(strType).keySet()){
                    JQgridItem jqgi = mapTypeReqChild.get(strType).get(strProdId);
                    if(!setPreviewProds.contains(strProdId)){
                        if(mapTypeReqChildDisplay.containsKey(strType)){
                            mapTypeReqChildDisplay.get(strType).put(strProdId,jqgi);
                        } else {
                            Map<String,JQGridItem> mapTemp = new Map<String,JQGridItem>();
                            mapTemp.put(strProdId,jqgi);
                            mapTypeReqChildDisplay.put(strType,mapTemp);
                        }
                        setPreviewProds.add(strProdId);
                    }
                }
            }
        }
        clstConfigProdTypes = new List<SelectOption>();
        clstConfigProdTypes.add(new SelectOption('','--None--'));
        Boolean pTypeExists = false;
        Boolean pReqTypeExists = false;
        for(String type : mapTypeChildDisplay.keySet()){
            clstConfigProdTypes.add(new SelectOption(type,type));
            if(type == cstrConfigProdType) pTypeExists = true;
        }
        clstConfigReqProdTypes = new List<SelectOption>();
        for(String type : mapTypeReqChildDisplay.keySet()){
            clstConfigReqProdTypes.add(new SelectOption(type,type));
            if(type == cstrConfigReqProdType) pReqTypeExists = true;
        }
        if(clstConfigReqProdTypes.isEmpty()){
            clstConfigReqProdTypes.add(new SelectOption('','--None--'));
        }
        if(!pTypeExists) cstrConfigProdType = clstConfigProdTypes.get(0).getValue();
        if(!pReqTypeExists) cstrConfigReqProdType = clstConfigReqProdTypes.get(0).getValue();
    }
    
    /*
    @Name   :resetAvailableChildren
    @Description : Deserializes the preview grid and calls set available children
    */
    public PageReference resetAvailableChildren(){
        setAvailableChildren((List<JQGridItem>)JSON.deserialize(strJSONPreviewGrid,List<JQGridItem>.class));
        return null;
    }
    
    /*
    @Name   :addUpdateQL
    @Description : Adds, Deletes, or Updates items in the qoute line grid based on the items in the preview grid
    */
    public PageReference addUpdateQL(){
        system.debug(strJSONPreviewGrid);
        system.debug(strJSONQLGrid);
        List<JQGridItem> lstPreviewGrid = (List<JQGridItem>)JSON.deserialize(strJSONPreviewGrid,List<JQGridItem>.class);
        List<JQGridItem> lstQLGrid = (List<JQGridItem>)JSON.deserialize(strJSONQLGrid,List<JQGridItem>.class);
        Map<String,JQGridItem> mapIdPreview = new Map<String,JQGridItem>();
        String parentId;
        Set<String> setFoundIds = new Set<String>();
        for(JQGridItem jqgi : lstPreviewGrid){
            //Update the action links
            if(jqgi.strIsParent == '0'){
                if(jqgi.strAssetAction == 'Change') {
                    jqgi.strAction = '<a href="javascript:void(0)" onclick="javascript:flipRow(\''+jqgi.strQLItemId+'\');">'+'Rem'+'</a>';
                } else {
                jqgi.strAction = '<a href="javascript:void(0)" onclick="javascript:delRow(\''+jqgi.strQLItemId+'\');">Del</a>';
                }
                jqgi.strAction += ' / <a href="javascript:void(0)" onclick="javascript:configProdJS(\''+jqgi.strQLItemId+'\');">'+'Configure'+'</a>';
            } else if(jqgi.strRequired == 'No'){
                if(jqgi.strAssetAction == 'Change') {
                    jqgi.strAction = '<a href="javascript:void(0)" onclick="javascript:flipRow(\''+jqgi.strQLItemId+'\');">'+'Rem'+'</a>';
                } else {
                jqgi.strAction = '<a href="javascript:void(0)" onclick="javascript:delRow(\''+jqgi.strQLItemId+'\');">Del</a>';
                }
            } else {
                jqgi.strAction = null;
            }
            
            //if it's Dynamic, update the Overage Unit Price and Unit of Measure
            system.debug('strAssetAction in addUpdate: '+jqgi.strAssetAction);
            if(jqgi.isDynamic == 'true'){
                system.debug('cUnit and cOverage in addupdate: '+cUnit+' '+cOveragePrice);
                jqgi.strUnit = cUnit;
                jqgi.decOveragePrice = cOveragePrice;
            }
            
            mapIdPreview.put(jqgi.strQLItemId,jqgi);
            parentId = jqgi.strParentId;
        }
        List<Integer> lstDelIndexes = new List<Integer>();
        //If the item exists in the ql grid then update it, if not then add the index to be deleted
        //Keep track of the items found in the grid
        //Update the groups
        Set<String> setGroupNames = new Set<String>();
        for(Integer i = 0; i < lstQLGrid.size(); i++){
            JQGridItem jqgiQL = lstQLGrid.get(i);
            setGroupNames.add(jqgiQL.strGroupName);
            if(jqgiQL.strParentId == parentId){
                String strItemId = jqgiQL.strQLItemId;
                setFoundIds.add(strItemId);
                if(mapIdPreview.containsKey(strItemId)){
                    //jqgiQL = mapIdPreview.get(strItemId);
                    lstQLGrid.set(i, mapIdPreview.get(strItemId));
                } else {
                    lstDelIndexes.add(i);
                }
            }
        }
        //Delete the qoute lines that do not exist in the preview for this parent
        for(Integer i = lstDelIndexes.size() - 1; i > -1; i--){
            //Remove the items in reverse index order
            lstQLGrid.remove(lstDelIndexes.get(i));
        }
        //Add the grid items that did not exist in the qoute lines
        for(String strId : mapIdPreview.keySet()){
            if(!setFoundIds.contains(strId)){
                lstQLGrid.add(mapIdPreview.get(strId));
                setGroupNames.add(mapIdPreview.get(strId).strGroupName);
            }
        }
        //Update the groupings
        cQuoteGroups = new List<SelectOption>();
        cQuoteGroups.add(new SelectOption('','--None--'));
        List<String> lstGroups = new List<String>();
        lstGroups.addAll(setGroupNames);
        lstGroups.sort();
        for(String strGroup : lstGroups){
            if(strGroup != 'Change' && strGroup != 'Remove'){
                cQuoteGroups.add(new SelectOption(strGroup,strGroup));
            }
        }
        cstrQuoteGroup='';
        cancelConfig();
        strJSONQLGrid = JSON.serialize(lstQLGrid);
        calcMrrByTerm();
        return null;
    }
    
    /*
    @Name   :cancelConfig
    @Description : Resets the config variables and hides the config section
    */
    public PageReference cancelConfig(){
        //Reset the configure variables and send the quote lines back to the page
        mapTypeChild = null;
        mapTypeReqChild = null;
        mapTypeChildDisplay = null;
        mapTypeReqChildDisplay = null;
        cstrConfigProdType = null;
        cstrConfigReqProdType = null;
        clstConfigProdTypes = null;
        clstConfigReqProdTypes = null;
        cConfigName = null;
        strJSONPreviewGrid = null;
        strJSONConfigGrid = null;
        showConfig = false;
        cDynamic = false;
        cUnit = 'none';
        cOveragePrice = 0;
        return null;
    }
    
    /*
    @Name   :checkHasChildren
    @Description : Checks if the currently selected pricebookentry's product has any product compatibility records
    */
    public PageReference checkHasChildren(){
        hasChildren = false;
        List<PriceBookEntry> lstPBE = [SELECT Id,Product2Id, Product2.DP_Asset_Type__c, Product2.DP_Unit_of_Measure__c,
        Product2.DP_Overage_Unit_Price__c FROM PriceBookEntry WHERE Id = :cSearchPBEId];
        if(lstPBE.size() > 0){
            system.debug('Product2 Asset Type:  '+lstPBE.get(0).Product2.DP_Asset_Type__c);
            system.debug('Product2Id: '+lstPBE.get(0).Product2Id);
            cDynamic = false;
            if(lstPBE.get(0).Product2.DP_Asset_Type__c == 'Dynamic'){
                cDynamic = true;
                cOveragePrice = lstPBE.get(0).Product2.DP_Overage_Unit_Price__c;
                cUnit = lstPBE.get(0).Product2.DP_Unit_of_Measure__c;
            } else {
                cDynamic = false;
            }
            Id prodId = lstPBE.get(0).Product2Id;
            List<DP_Product_Compatibility__c> lstPC = [SELECT Id 
                                                    FROM DP_Product_Compatibility__c 
                                                    WHERE DP_Parent_Product__c = :prodId 
                                                    AND (DP_Child_Product__c = null OR (DP_Minimum_Quantity__c = 0 AND DP_Child_Product__r.DP_Availability__c IN ('Available','Limited')))];
            if(lstPC.size() > 0){
                hasChildren = true;
            }
            system.debug('cDynamic: '+cDynamic);
        }
        return null;
    }
    
    /*
    @Name   :addOrConfig
    @Description : Adds the pricebookentry product to the quote lines or configure section based on if it has any product compatibilities
    */
    public PageReference addOrConfig(){
        List<PriceBookEntry> lstPBE = [SELECT Id,Product2Id FROM PriceBookEntry WHERE Id = :cstrPBEID];
        if(lstPBE.size() > 0){
            Id prodId = lstPBE.get(0).Product2Id;
           /* List<DP_Product_Compatibility__c> lstPC = [SELECT Id 
                                                    FROM DP_Product_Compatibility__c 
                                                    WHERE DP_Parent_Product__c = :prodId 
                                                    AND (DP_Child_Product__c = null OR (DP_Minimum_Quantity__c = 0 AND DP_Child_Product__r.DP_Availability__c IN ('Available','Limited')))];
                                                    */
                                                    
                                                    
         Map<Id,DP_Product_Compatibility__c> lstPC =new Map<ID,DP_Product_Compatibility__C>([SELECT Id 
                                                    FROM DP_Product_Compatibility__c 
                                                    WHERE DP_Parent_Product__c = :prodId 
                                                    AND (DP_Child_Product__c = null OR (DP_Minimum_Quantity__c = 0 AND DP_Child_Product__r.DP_Availability__c IN ('Available','Limited')))]);
                                                    
                                                    
            if(lstPC.size() > 0){
                configNewProd();
            } else {
                addProduct();
            }
        }
        return null;
    }
    
    /*
    @Name        :calcMRR
    @Description :Update the MRR on the quote line item specified strItemId
    */ 
    public PageReference calcMRR(){
        List<JQGridItem> jqGridItemList = (List<JQGridItem>)JSON.deserialize(strJSONQLGrid,List<JQGridItem>.class);
        DP_DataCenter__c dc;
        JQGridItem jqgiParent;
        for(JQGridItem jqgi : jqGridItemList){
            system.debug('while changing quantity, the jqgi MRR is: '+jqgi.decMRR);
            Decimal originalQuantity = jqgi.decPreviousQty;
            if(jqgi.strQLItemId == cstrItemId){
                system.debug('changing up the quantity on a jqgi');
                //Yes this is a query in a for loop but the query will only execute once due to the if statement and break statement
                //Calculate the setupFee
                if(jqgi.decParentQty == -1){
                    Decimal decSetFee = jqgi.decSetupFee / jqgi.decPreviousQty;
                    jqgi.decSetupFee = decSetFee * jqgi.decQty;
                } else {
                    Decimal decSetFee = jqgi.decSetupFee / (jqgi.decPreviousQty * jqgi.decParentQty);
                    jqgi.decSetupFee = decSetFee * (jqgi.decQty * jqgi.decParentQty);
                }
                jqgi.decPreviousQty = jqgi.decQty;
                dc = [SELECT Id,Name,DP_Name_Abbr__c,DP_kWCost__c,DP_kW_Markup__c FROM DP_DataCenter__c WHERE DP_Name_Abbr__c = :jqgi.strDataCenter];
                jqgi.decKWMarkup = dc.DP_kw_Markup__c / 100;
                jqgi.decKWCost = dc.DP_kwCost__c;
                Decimal qty = jqgi.decQty;
                Decimal bQty = jqgi.baseQty;
                if(jqgi.strIsParent == '1'){
                    qty = qty * jqgi.decParentQty;
                    bQty = bQty * jqgi.decParentQty;
                }
                Decimal oldPrice = jqgi.decDPLPUSD;
                jqgi.decDPLPUSD = DP_DatapipeUtility.calculate_datapipeListPriceUSD(
                                                cQuote.DP_Term__c, 
                                                cQuote.DP_Operational_Life_Factor__c,
                                                cQuote.DP_Cost_of_Money__c,
                                                cQuote.DP_Money_Making_Months__c,
                                                cQuote.DP_Month_to_Month_Multiplier__c,
                                                cQuote.DP_kW_Month_to_Month_Multiplier__c,
                                                cQuote.DP_kW_Hours_In_Month__c,
                                                cQuote.DP_kW_Term_Multiplier__c,
                                                jqgi.decKW,
                                                jqgi.decKWCost,
                                                jqgi.decKWMarkup,
                                                qty,
                                                Boolean.valueOf(jqgi.strExempt),
                                                jqgi.decLandedCost,
                                                bQty);
                                                
                if(jqgi.strAssetAction == 'Change'){
                    Decimal newPrice = DP_DatapipeUtility.calculate_mrr(jqgi.decDPLPUSD,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount);
                    system.debug('calculating new price: ' + DP_DatapipeUtility.calculate_mrr(jqgi.decDPLPUSD,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount)+'-'+DP_DatapipeUtility.calculate_mrr(oldPrice,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount));
                    if(jqgi.decQty != jqgi.decOrigQty){
                    if(newPrice != 0){
                        jqgi.decMRR = newPrice - DP_DatapipeUtility.calculate_mrr(oldPrice,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount);
                    } else {
                        jqgi.decMRR = 0;
                    }
                    } else {
                        jqgi.decMRR = 0;
                    }
                    jqgi.decUSDMRR = jqgi.decMRR * cQuote.DP_Exchange_Rate__c;
                    jqgiParent = jqgi;
                    break;
                }else {
                    system.debug('recalculating. DPLP: '+jqgi.decDPLPUSD+', Exchange rate: '+cQuote.DP_Exchange_Rate__c+', discount: '+jqgi.decDiscount);
                    jqgi.decMRR = DP_DatapipeUtility.calculate_mrr(jqgi.decDPLPUSD,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount);
                    system.debug('result: '+jqgi.decMRR);
                    jqgi.decUSDMRR = jqgi.decMRR * cQuote.DP_Exchange_Rate__c;
                    jqgiParent = jqgi;
                    break;
                }
            }
        }
        //Update the quantity for children, then recalc the children mrr
        if(jqgiParent != null && jqgiParent.strIsParent == '0'){
            for(JQGridItem jqgi : jqGridItemList){
                if(jqgi.strParentId == jqgiParent.strQLItemId && jqgi.strQLItemId != jqgiParent.strQLItemId && jqgi.decParentQty != jqgiParent.decQty){
                    //Calculate the setupFee
                    if(jqgi.strAssetAction != 'Change'){
                        if(jqgi.decParentQty == -1){
                            Decimal decSetFee = jqgi.decSetupFee / jqgi.decPreviousQty;
                            jqgi.decSetupFee = decSetFee * jqgi.decQty;
                        } else {
                            Decimal decSetFee = jqgi.decSetupFee / (jqgi.decPreviousQty * jqgi.decParentQty);
                            jqgi.decSetupFee = decSetFee * (jqgi.decQty * jqgiParent.decQty);
                        }
                    }
                    jqgi.decParentQty = jqgiParent.decQty;
                    jqgi.decPreviousQty = jqgi.decQty;
                    jqgi.decKWMarkup = dc.DP_kw_Markup__c / 100;
                    jqgi.decKWCost = dc.DP_kwCost__c;
                    jqgi.decDPLPUSD = DP_DatapipeUtility.calculate_datapipeListPriceUSD(
                                                    cQuote.DP_Term__c, 
                                                    cQuote.DP_Operational_Life_Factor__c,
                                                    cQuote.DP_Cost_of_Money__c,
                                                    cQuote.DP_Money_Making_Months__c,
                                                    cQuote.DP_Month_to_Month_Multiplier__c,
                                                    cQuote.DP_kW_Month_to_Month_Multiplier__c,
                                                    cQuote.DP_kW_Hours_In_Month__c,
                                                    cQuote.DP_kW_Term_Multiplier__c,
                                                    jqgi.decKW,
                                                    jqgi.decKWCost,
                                                    jqgi.decKWMarkup,
                                                    jqgi.decQty * jqgi.decParentQty,
                                                    Boolean.valueOf(jqgi.strExempt),
                                                    jqgi.decLandedCost,
                                                    jqgi.baseQty * jqgi.decParentQty);
                    //break out if it's an Asset change and nothing happened
                    if(jqgi.strAssetAction == 'Change') continue;
                    jqgi.decMRR = DP_DatapipeUtility.calculate_mrr(jqgi.decDPLPUSD,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount);
                    jqgi.decUSDMRR = jqgi.decMRR * cQuote.DP_Exchange_Rate__c;
                }
            }
        }
        strJSONQLGrid = JSON.serialize(jqGridItemList);
        calcMrrByTerm();
        return null;
    }
    
    /*
    @Name   :calcMrrByTerm
    @Description : Rolls up the mrr for each term for item in the quote line grid
    */
    public PageReference calcMrrByTerm(){
        System.debug('strJSONQLGrid');
        System.debug(strJSONQLGrid);
     
     system.debug('In CalcMrrByTerm');
        List<JQGridItem> lstJQGI = (List<JQGridItem>)JSON.deserialize(strJSONQLGrid,List<JQGridItem>.class);
        cTotSetFee = 0;
        lease1 = 0;
        lease12 = 0;
        lease24 = 0;
        lease36 = 0;
        lease48 = 0;
        lease60 = 0;
        for(JQGridItem jqgi : lstJQGI){
            System.debug('jqgi: ' + jqgi);
        
            if(jqgi.strAssetAction == 'Change' && jqgi.decMRR > 0){
                continue;
            }
            //Sum the setup fee
            cTotSetFee += jqgi.decSetupFee;
            Decimal decDPLP;
            Decimal decMRR;
            Decimal qty = jqgi.decQty;
            Decimal bQty = jqgi.baseQty;
            if(jqgi.strIsParent == '1'){
                qty = qty * jqgi.decParentQty;
                bQty = bQty * jqgi.decParentQty;
            }
            //Only calculate the value if it is for a term other than the current term
            if(cQuote.DP_Term__c != '12'){
                decDPLP = DP_DatapipeUtility.calculate_datapipeListPriceUSD(
                                        '12', 
                                        cQuote.DP_Operational_Life_Factor__c,
                                        cQuote.DP_Cost_of_Money__c,
                                        cQuote.DP_Money_Making_Months__c,
                                        cQuote.DP_Month_to_Month_Multiplier__c,
                                        cQuote.DP_kW_Month_to_Month_Multiplier__c,
                                        cQuote.DP_kW_Hours_In_Month__c,
                                        cQuote.DP_kW_Term_Multiplier__c,
                                        jqgi.decKW,
                                        jqgi.decKWCost,
                                        jqgi.decKWMarkup,
                                        qty,
                                        Boolean.valueOf(jqgi.strExempt),
                                        jqgi.decLandedCost,
                                        bQty);
                lease12 += DP_DatapipeUtility.calculate_mrr(decDPLP,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount);    
            } else {
                lease12 += jqgi.decMRR;
            }
             system.debug('In CalcMrrByTerm'+jqgi.decMRR+'--'+Boolean.valueOf(jqgi.strExempt));
            if(cQuote.DP_Term__c != '24'){
                decDPLP = DP_DatapipeUtility.calculate_datapipeListPriceUSD(
                                        '24', 
                                        cQuote.DP_Operational_Life_Factor__c,
                                        cQuote.DP_Cost_of_Money__c,
                                        cQuote.DP_Money_Making_Months__c,
                                        cQuote.DP_Month_to_Month_Multiplier__c,
                                        cQuote.DP_kW_Month_to_Month_Multiplier__c,
                                        cQuote.DP_kW_Hours_In_Month__c,
                                        cQuote.DP_kW_Term_Multiplier__c,
                                        jqgi.decKW,
                                        jqgi.decKWCost,
                                        jqgi.decKWMarkup,
                                        qty,
                                        Boolean.valueOf(jqgi.strExempt),
                                        jqgi.decLandedCost,
                                        bQty);
                lease24 += DP_DatapipeUtility.calculate_mrr(decDPLP,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount); 
            } else {
                lease24 += jqgi.decMRR;
            }
system.debug('In CalcMrrByTerm'+ jqgi.decMRR +'---' + Boolean.valueOf(jqgi.strExempt));
            if(cQuote.DP_Term__c != '36'){
                decDPLP = DP_DatapipeUtility.calculate_datapipeListPriceUSD(
                                        '36', 
                                        cQuote.DP_Operational_Life_Factor__c,
                                        cQuote.DP_Cost_of_Money__c,
                                        cQuote.DP_Money_Making_Months__c,
                                        cQuote.DP_Month_to_Month_Multiplier__c,
                                        cQuote.DP_kW_Month_to_Month_Multiplier__c,
                                        cQuote.DP_kW_Hours_In_Month__c,
                                        cQuote.DP_kW_Term_Multiplier__c,
                                        jqgi.decKW,
                                        jqgi.decKWCost,
                                        jqgi.decKWMarkup,
                                        qty,
                                        Boolean.valueOf(jqgi.strExempt),
                                        jqgi.decLandedCost,
                                        bQty);
                lease36 += DP_DatapipeUtility.calculate_mrr(decDPLP,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount); 
            } else {
                lease36 += jqgi.decMRR;
            }
            if(cQuote.DP_Term__c != '48'){
                decDPLP = DP_DatapipeUtility.calculate_datapipeListPriceUSD(
                                        '48', 
                                        cQuote.DP_Operational_Life_Factor__c,
                                        cQuote.DP_Cost_of_Money__c,
                                        cQuote.DP_Money_Making_Months__c,
                                        cQuote.DP_Month_to_Month_Multiplier__c,
                                        cQuote.DP_kW_Month_to_Month_Multiplier__c,
                                        cQuote.DP_kW_Hours_In_Month__c,
                                        cQuote.DP_kW_Term_Multiplier__c,
                                        jqgi.decKW,
                                        jqgi.decKWCost,
                                        jqgi.decKWMarkup,
                                        qty,
                                        Boolean.valueOf(jqgi.strExempt),
                                        jqgi.decLandedCost,
                                        bQty);
                lease48 += DP_DatapipeUtility.calculate_mrr(decDPLP,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount); 
            } else {
                lease48 += jqgi.decMRR;
            }
            if(cQuote.DP_Term__c != '60'){
                decDPLP = DP_DatapipeUtility.calculate_datapipeListPriceUSD(
                                        '60', 
                                        cQuote.DP_Operational_Life_Factor__c,
                                        cQuote.DP_Cost_of_Money__c,
                                        cQuote.DP_Money_Making_Months__c,
                                        cQuote.DP_Month_to_Month_Multiplier__c,
                                        cQuote.DP_kW_Month_to_Month_Multiplier__c,
                                        cQuote.DP_kW_Hours_In_Month__c,
                                        cQuote.DP_kW_Term_Multiplier__c,
                                        jqgi.decKW,
                                        jqgi.decKWCost,
                                        jqgi.decKWMarkup,
                                        qty,
                                        Boolean.valueOf(jqgi.strExempt),
                                        jqgi.decLandedCost,
                                        bQty);
                lease60 += DP_DatapipeUtility.calculate_mrr(decDPLP,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount); 
            } else {
                lease60 += jqgi.decMRR;
            }
system.debug('In CalcMrrByTerm'+ jqgi.decMRR +'  ---' + Boolean.valueOf(jqgi.strExempt));
        }
        //lease1 = lease1.setScale(2);

        lease12 = lease12.setScale(2);
        lease24 = lease24.setScale(2);
        lease36 = lease36.setScale(2);
        lease48 = lease48.setScale(2);
        lease60 = lease60.setScale(2);

 system.debug('lease12 :' +lease12.setScale(2) +'lease24.setScale(2):'+ lease24.setScale(2));
        return null;
    }
    
    /*
    @Name   :updateTerm
    @Description : Updates the Mrr on each grid with the new term and runs calcMrrByTerm
    */
    public PageReference updateTerm(){
        List<JQGridItem> lstJQGI = (List<JQGridItem>)JSON.deserialize(strJSONQLGrid,List<JQGridItem>.class);
system.debug('In UpdateTerm'+lstJQGI);
        for(JQGridItem jqgi : lstJQGI){
            Decimal qty = jqgi.decQty;
            Decimal bQty = jqgi.baseQty;
            if(jqgi.strIsParent == '1'){
                qty = qty * jqgi.decParentQty;
                bQty = bQty * jqgi.decParentQty;
            }
            jqgi.decDPLPUSD = DP_DatapipeUtility.calculate_datapipeListPriceUSD(
                                            cQuote.DP_Term__c, 
                                            cQuote.DP_Operational_Life_Factor__c,
                                            cQuote.DP_Cost_of_Money__c,
                                            cQuote.DP_Money_Making_Months__c,
                                            cQuote.DP_Month_to_Month_Multiplier__c,
                                            cQuote.DP_kW_Month_to_Month_Multiplier__c,
                                            cQuote.DP_kW_Hours_In_Month__c,
                                            cQuote.DP_kW_Term_Multiplier__c,
                                            jqgi.decKW,
                                            jqgi.decKWCost,
                                            jqgi.decKWMarkup,
                                            qty,
                                            Boolean.valueOf(jqgi.strExempt),
                                            jqgi.decLandedCost,
                                            bQty);
            jqgi.decMRR = DP_DatapipeUtility.calculate_mrr(jqgi.decDPLPUSD,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount);
            jqgi.decUSDMRR = jqgi.decMRR * cQuote.DP_Exchange_Rate__c;
        }
        strJSONQLGrid = JSON.serialize(lstJQGI);
        calcMrrByTerm();
        //Only recalc the config section if it is shown
        if(showConfig){
            List<JQGridItem> lstJQGIPreview = (List<JQGridItem>)JSON.deserialize(strJSONPreviewGrid,List<JQGridItem>.class);
            for(JQGridItem jqgi : lstJQGIPreview){
                Decimal qty = jqgi.decQty;
                Decimal bQty = jqgi.baseQty;
                if(jqgi.strIsParent == '1'){
                    qty = qty * jqgi.decParentQty;
                    bQty = bQty * jqgi.decParentQty;
                }
                jqgi.decDPLPUSD = DP_DatapipeUtility.calculate_datapipeListPriceUSD(
                                                cQuote.DP_Term__c, 
                                                cQuote.DP_Operational_Life_Factor__c,
                                                cQuote.DP_Cost_of_Money__c,
                                                cQuote.DP_Money_Making_Months__c,
                                                cQuote.DP_Month_to_Month_Multiplier__c,
                                                cQuote.DP_kW_Month_to_Month_Multiplier__c,
                                                cQuote.DP_kW_Hours_In_Month__c,
                                                cQuote.DP_kW_Term_Multiplier__c,
                                                jqgi.decKW,
                                                jqgi.decKWCost,
                                                jqgi.decKWMarkup,
                                                qty,
                                                Boolean.valueOf(jqgi.strExempt),
                                                jqgi.decLandedCost,
                                                bQty);
                jqgi.decMRR = DP_DatapipeUtility.calculate_mrr(jqgi.decDPLPUSD,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount);
                jqgi.decUSDMRR = jqgi.decMRR * cQuote.DP_Exchange_Rate__c;
            }
            for(Map<String,JQGridItem> mapSJQGI : mapTypeChild.values()){
                for(JQGridItem jqgi : mapSJQGI.values()){
                    jqgi.decDPLPUSD = DP_DatapipeUtility.calculate_datapipeListPriceUSD(
                                                    cQuote.DP_Term__c, 
                                                    cQuote.DP_Operational_Life_Factor__c,
                                                    cQuote.DP_Cost_of_Money__c,
                                                    cQuote.DP_Money_Making_Months__c,
                                                    cQuote.DP_Month_to_Month_Multiplier__c,
                                                    cQuote.DP_kW_Month_to_Month_Multiplier__c,
                                                    cQuote.DP_kW_Hours_In_Month__c,
                                                    cQuote.DP_kW_Term_Multiplier__c,
                                                    jqgi.decKW,
                                                    jqgi.decKWCost,
                                                    jqgi.decKWMarkup,
                                                    jqgi.decQty,
                                                    Boolean.valueOf(jqgi.strExempt),
                                                    jqgi.decLandedCost,
                                                    jqgi.baseQty);
                    jqgi.decMRR = DP_DatapipeUtility.calculate_mrr(jqgi.decDPLPUSD,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount);
                    jqgi.decUSDMRR = jqgi.decMRR * cQuote.DP_Exchange_Rate__c;
                }
            }
            for(Map<String,JQGridItem> mapSJQGI : mapTypeReqChild.values()){
                for(JQGridItem jqgi : mapSJQGI.values()){
                    Decimal qty = jqgi.decQty;
                    Decimal bQty = jqgi.baseQty;
                    if(jqgi.strIsParent == '1'){
                        qty = qty * jqgi.decParentQty;
                        bQty = bQty * jqgi.decParentQty;
                    }
                    jqgi.decDPLPUSD = DP_DatapipeUtility.calculate_datapipeListPriceUSD(
                                                    cQuote.DP_Term__c, 
                                                    cQuote.DP_Operational_Life_Factor__c,
                                                    cQuote.DP_Cost_of_Money__c,
                                                    cQuote.DP_Money_Making_Months__c,
                                                    cQuote.DP_Month_to_Month_Multiplier__c,
                                                    cQuote.DP_kW_Month_to_Month_Multiplier__c,
                                                    cQuote.DP_kW_Hours_In_Month__c,
                                                    cQuote.DP_kW_Term_Multiplier__c,
                                                    jqgi.decKW,
                                                    jqgi.decKWCost,
                                                    jqgi.decKWMarkup,
                                                    qty,
                                                    Boolean.valueOf(jqgi.strExempt),
                                                    jqgi.decLandedCost,
                                                    bQty);
                    jqgi.decMRR = DP_DatapipeUtility.calculate_mrr(jqgi.decDPLPUSD,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount);
                    jqgi.decUSDMRR = jqgi.decMRR * cQuote.DP_Exchange_Rate__c;
                }
            }
            strJSONPreviewGrid = JSON.serialize(lstJQGIPreview);
            setAvailableChildren(lstJQGIPreview);
        }
        return null;
    }
    
    /*
    @Name   :updateDiscounts
    @Description : Sets the discount in the preview and quote line grid to the discount chosen or the max, whichever is lower
    */
    public PageReference updateDiscounts(){
        Decimal discount = 0;
        if(cQuote.DP_Discount__c != null) discount = cQuote.DP_Discount__c;
        List<JQGridItem> lstJQGI = (List<JQGridItem>)JSON.deserialize(strJSONQLGrid,List<JQGridItem>.class);
        for(JQGridItem jqgi : lstJQGI){
            if(discount > jqgi.maxDiscount){
                jqgi.decDiscount = jqgi.maxDiscount;
            } else {
                jqgi.decDiscount = discount;
            }
            jqgi.decMRR = DP_DatapipeUtility.calculate_mrr(jqgi.decDPLPUSD,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount);
            jqgi.decUSDMRR = jqgi.decMRR * cQuote.DP_Exchange_Rate__c;
        }
        strJSONQLGrid = JSON.serialize(lstJQGI);
        calcMrrByTerm();
        //Only recalc the config section if it is shown
        if(showConfig){
            List<JQGridItem> lstJQGIPreview = (List<JQGridItem>)JSON.deserialize(strJSONPreviewGrid,List<JQGridItem>.class);
            for(JQGridItem jqgi : lstJQGIPreview){
                if(discount > jqgi.maxDiscount){
                    jqgi.decDiscount = jqgi.maxDiscount;
                } else {
                    jqgi.decDiscount = discount;
                }
            jqgi.decMRR = DP_DatapipeUtility.calculate_mrr(jqgi.decDPLPUSD,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount);
            jqgi.decUSDMRR = jqgi.decMRR * cQuote.DP_Exchange_Rate__c;
            }
            for(Map<String,JQGridItem> mapSJQGI : mapTypeChild.values()){
                for(JQGridItem jqgi : mapSJQGI.values()){
                    if(discount > jqgi.maxDiscount){
                        jqgi.decDiscount = jqgi.maxDiscount;
                    } else {
                        jqgi.decDiscount = discount;
                    }
                    jqgi.decMRR = DP_DatapipeUtility.calculate_mrr(jqgi.decDPLPUSD,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount);
                    jqgi.decUSDMRR = jqgi.decMRR * cQuote.DP_Exchange_Rate__c;
                }
            }
            for(Map<String,JQGridItem> mapSJQGI : mapTypeReqChild.values()){
                for(JQGridItem jqgi : mapSJQGI.values()){
                    if(discount > jqgi.maxDiscount){
                        jqgi.decDiscount = jqgi.maxDiscount;
                    } else {
                        jqgi.decDiscount = discount;
                    }
                    jqgi.decMRR = DP_DatapipeUtility.calculate_mrr(jqgi.decDPLPUSD,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount);
                    jqgi.decUSDMRR = jqgi.decMRR * cQuote.DP_Exchange_Rate__c;
                }
            }
            strJSONPreviewGrid = JSON.serialize(lstJQGIPreview);
            setAvailableChildren(lstJQGIPreview);
        }
        system.debug('Exiting updateDiscounts');
        return null;
    }
    
    /*
    @Name   :setChosenDC
    @Description : Sets datacenter for the choen datacenter in the choose products section
    */
    public PageReference setChosenDC(){
        if(cSearchDCId != null && cSearchDCId != ''){
            cChosenDC = [SELECT Id, Name,DP_Name_Abbr__c, DP_kWCost__c, DP_kW_Markup__c FROM DP_DataCenter__c WHERE Id = :cSearchDCId];
        } else {
            cChosenDC = null;
        }
        return null;
    }
    
    /*
    @Name        :getContacts
    @Description :Returns the list of Contacts for the FlexBox to use
    */
    public String getContacts(){
        List<Contact> lstCon = [SELECT Id,Name FROM Contact WHERE AccountId = :cAccount.Id order by Name asc]; //
        FlexItemSource fis = new FlexItemSource();
        List<FlexItem> lstFL = new list<FlexItem>();
        for(Contact con : lstCon){
            FlexItem fl = new FlexItem();
            fl.id = con.id;
            fl.name = con.Name;
            lstFL.add(fl);
        }
        fis.results = lstFL;
        return JSON.serialize(fis);
    }
    
    /*
    @Name   :getGroupNames
    @Description :Converted the picklist values in the DP_Group_Name__c field on DP_Quote_Line_Group__c object to select list options
    */
    public static List<SelectOption> getGroupNames(){
        List<SelectOption> lstReturn = new List<SelectOption>();
        List<Schema.PicklistEntry> lstPLEs = Schema.sObjectType.DP_Quote_Line_Group__c.fields.DP_Group_Name__c.getPicklistValues();
        for(Schema.PicklistEntry ple : lstPLEs){
            lstReturn.add(new SelectOption(ple.getValue(),ple.getValue()));
        }
        return lstReturn;
    }
    
    /*
    @Name   :getProdTypes
    @Description :Converted the picklist values in the DP_Product_Type__c field on Product2 object to select list options
    */
    public static List<SelectOption> getProdTypes(){
        List<SelectOption> lstReturn = new List<SelectOption>();
        List<Schema.PicklistEntry> lstPLEs = Schema.sObjectType.Product2.fields.DP_Product_Type__c.getPicklistValues();
        lstReturn.add(new SelectOption('','--None--'));
        for(Schema.PicklistEntry ple : lstPLEs){
            lstReturn.add(new SelectOption(ple.getValue(),ple.getValue()));
        }
        return lstReturn;
    }
    
    
    
    /*
    @Name   :getToDiscount
    @Description : Sets the discount on the quote lines to get to a target price
    */
    public PageReference getToDiscount(){
        Decimal quotePrice;
        Decimal finalDiscount;
        Boolean goOverMax = false;
        
        //First off, get the correct lease price
        if(Integer.valueOf(cQuote.DP_Term__c) == 12){ quotePrice = lease12; }
        if(Integer.valueOf(cQuote.DP_Term__c) == 24){ quotePrice = lease24; }
        if(Integer.valueOf(cQuote.DP_Term__c) == 36){ quotePrice = lease36; }
        if(Integer.valueOf(cQuote.DP_Term__c) == 48){ quotePrice = lease48; }
        if(Integer.valueOf(cQuote.DP_Term__c) == 60){ quotePrice = lease60; }    
        if(quotePrice == 0){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING,'MRR By Term must be greater than zero!'));
            return null;
        }
        
        List<JQGridItem> allLstJQGI = (List<JQGridItem>)JSON.deserialize(strJSONQLGrid,List<JQGridItem>.class);
        Decimal availPrice = 0;
        Decimal availDiscount = 0;
        //find what the available price for discounting is
        for(JQGridItem jqgi : allLstJQGI){
                if(jqgi.decDiscount != jqgi.maxDiscount){
                        availPrice += jqgi.decMRR;
                        availDiscount += jqgi.decMRR*((100-jqgi.maxDiscount)/100); //this only really works if decDiscount is 0
                }
        }
        system.debug('Original Availprice: '+availPrice+' and discount: '+availDiscount);
        if(quotePrice - availDiscount > targetPrice){ //the target is below the max discount without approval
            goOverMax = true;
            system.debug('Outside loop goOverMax = '+goOverMax);
        } else {
            //do calculation of discount
            Decimal targetDollarsDiscounted = (quotePrice-targetPrice);
            Decimal discount;
            if(availPrice != 0){//prevent divide by 0 if discounts are maxed
                discount = ((targetDollarsDiscounted/availPrice)*100).setScale(2);
            } else {
                discount = 0;
            }
            finalDiscount = discount;
            Integer bounces = 0;
            while(quotePrice != targetPrice){
                //recursively max out discounts to calculate needed total discount
                system.debug('Loop Run/QuotePrice = ' +quotePrice+' :: discount = '+discount);
                Decimal startingDiscount = discount;
                Decimal startingQuotePrice = quotePrice;
                Decimal secondAvailPrice;
                if(discount == 0){
                    secondAvailPrice = quotePrice;
                } else {
                    secondAvailPrice = 0;
                }
                for(JQGridItem jqgi : allLstJQGI){
                    Decimal mrrBefore = jqgi.decMRR;
                    if(discount > jqgi.maxDiscount){
                        //max out the discount if greater than the line's max
                        if(jqgi.decDiscount != jqgi.maxDiscount){
                            jqgi.decDiscount = jqgi.maxDiscount;
                            jqgi.decMRR = DP_DatapipeUtility.calculate_mrr(jqgi.decDPLPUSD,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount).setScale(4);
                            jqgi.decUSDMRR = jqgi.decMRR * cQuote.DP_Exchange_Rate__c;
                            quotePrice = quotePrice - (mrrBefore-jqgi.decMRR);
                        }
                    } else {
                        if(jqgi.decDiscount != jqgi.maxDiscount){
                            //set the line discount, calc the new amount available for discounting
                            secondAvailPrice += jqgi.decMRR;
                            jqgi.decDiscount = discount;
                            jqgi.decMRR = DP_DatapipeUtility.calculate_mrr(jqgi.decDPLPUSD,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount).setScale(4);
                            jqgi.decUSDMRR = jqgi.decMRR * cQuote.DP_Exchange_Rate__c;
                            quotePrice = quotePrice - (mrrBefore-jqgi.decMRR);
                        }
                    }
                }
                //quotePrice = quotePrice.setScale(2); //round the quote price
                system.debug('New quotePrice = '+ quotePrice);
                system.debug('Avail Price = '+secondAvailPrice);
                Decimal secondTargetDollars = (quotePrice-targetPrice);
                if(secondAvailPrice != 0){
                    discount += ((secondTargetDollars/secondAvailPrice)*100).setScale(2);
               system.debug('(secondTargetDollars/secondAvailPrice)*100).setScale(2):' + ((secondTargetDollars/secondAvailPrice)*100).setScale(2));
                    if(((secondTargetDollars/secondAvailPrice)*100).setScale(2) < 0){
                        bounces++; //this is to prevent the loop from bouncing up and down by 0.01 infinitely
                    }
                    system.debug('New discount = '+discount);
                } else {
                    //all lines are at max discount
                    goOverMax = true;
                    //system.debug('Inside loop goOverMax = '+goOverMax);
                    break;
                }
                 system.debug('quotePrice.setScale(2):' + quotePrice.setScale(2) +'targetprice' + targetprice);
                if(quotePrice.setScale(2) == targetPrice || quotePrice == startingQuotePrice || discount == startingDiscount || bounces >= 3){
                    //if we're at target or nothing has changed within 2 decimal places, break out of loop
                    system.debug('Breaking loop at quotePrice = '+quotePrice);
                    finalDiscount = discount;
                    break;
                }
            }
        }
        //found the needed discount, update everything with it
        if(!goOverMax){
            system.debug('quoteprice after loop is '+quoteprice);
            system.debug('finalDiscount after loop is '+finalDiscount);
            cQuote.DP_Discount__c = finalDiscount;
            if(quotePrice != targetPrice){
                Boolean gotThere = false;
                quotePrice = 0;
                for(JQGridItem jqgi : allLstJQGI){
                    quotePrice += jqgi.decMRR;
                }
                system.debug('recalcd quoteprice is: '+quoteprice);
                
                quotePrice = quotePrice.setScale(3);
              
            system.debug('quotePrice.setScale(3):' + quotePrice.setScale(3));
                Decimal singleDiscount = quotePrice - targetPrice;
                system.debug('singleDiscount: '+singleDiscount);
                for(JQGridItem jqgi : allLstJQGI){
                    if(jqgi.decDiscount != jqgi.maxDiscount && jqgi.decMRR != 0){
                        Decimal availMRR = jqgi.decMRR/(1-(jqgi.decDiscount/100));
                        Decimal targetMRR = jqgi.decMRR - singleDiscount;
                        Decimal targetJQGIDiscount;
                        if(availMRR != 0){
                            targetJQGIDiscount = 1-(targetMRR/availMRR).setScale(4);
                        }
                        Decimal newMrr = availMRR*(1-targetJQGIDiscount);
             system.debug('setscale :' + jqgi.decMrr.setScale(3) +'newmrr :' +newMrr.setScale(3));

                        if(jqgi.decMrr.setScale(3)-newMrr.setScale(3) == singleDiscount){
                            system.debug('Found a qli to set single discount. setting to: '+targetJQGIDiscount*100);
                            jqgi.decDiscount = targetJQGIDiscount*100;
                            jqgi.decMRR = DP_DatapipeUtility.calculate_mrr(jqgi.decDPLPUSD,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount);
                            jqgi.decUSDMRR = jqgi.decMRR * cQuote.DP_Exchange_Rate__c;
                            gotThere = true;
                            break;
                        }
                    }
                }
                if(!gotThere){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING,'Target Price is not mathematically possible within 2 decimal places!'));
                }
            }
            strJSONQLGrid = JSON.serialize(allLstJQGI);
            calcMrrByTerm();
        } else {
            goOverDiscount(targetPrice);
        }
        return null;
    }
    
    /*
    @Name   :goOverDiscount
    @Description : Sets the discount on the quote lines to above their max.  Will put into approval process.
    */
    public void goOverDiscount(Decimal targetPrice){
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING,'Target Price is over the maximum discount and will require approval.'));
        system.debug('goOverDiscount entered/targetPrice is: ' + targetPrice);
        Decimal quotePrice;
        Integer scale = targetPrice.scale();
        system.debug('scale: '+scale);
        
        //First off, get the correct lease price
        if(Integer.valueOf(cQuote.DP_Term__c) == 12){quotePrice = lease12;}
        if(Integer.valueOf(cQuote.DP_Term__c) == 24){quotePrice = lease24;}
        if(Integer.valueOf(cQuote.DP_Term__c) == 36){quotePrice = lease36;}
        if(Integer.valueOf(cQuote.DP_Term__c) == 48){quotePrice = lease48;}
        if(Integer.valueOf(cQuote.DP_Term__c) == 60){quotePrice = lease60;}
        Decimal targetDollarsDiscounted = (quotePrice-targetPrice);
        system.debug('target dollars discounted is: ' + targetDollarsDiscounted);
        Decimal discount = ((targetDollarsDiscounted/quotePrice)*100).setScale(2);
        system.debug('discount percent is: ' + discount);
        //if (cQuote.DP_Discount__c == null) cQuote.DP_Discount__c = 0;
        cQuote.DP_Discount__c = (cQuote.DP_Discount__c == null) ? discount : cQuote.DP_Discount__c + discount ;
        
        List<JQGridItem> lstJQGI = (List<JQGridItem>)JSON.deserialize(strJSONQLGrid,List<JQGridItem>.class);
        quotePrice = 0;
        for(JQGridItem jqgi : lstJQGI){
            jqgi.decDiscount = discount;
            jqgi.decMRR = DP_DatapipeUtility.calculate_mrr(jqgi.decDPLPUSD,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount);
            jqgi.decUSDMRR = jqgi.decMRR * cQuote.DP_Exchange_Rate__c;
            quotePrice += jqgi.decMRR;
            system.debug('quote price is: '+quotePrice);
        }
       system.debug('setscale :' + quotePrice.setScale(2) +'targetprice :' +targetprice);
        if(quotePrice.setScale(2) != targetPrice){
            quotePrice = quotePrice.setScale(2);
            Decimal singleDiscount = quotePrice - targetPrice;
            for(JQGridItem jqgi : lstJQGI){
                if(jqgi.decMRR != 0){
                    Decimal availMRR = jqgi.decMRR/(1-(jqgi.decDiscount/100));
                    Decimal targetMRR = jqgi.decMRR - singleDiscount;
                    Decimal targetJQGIDiscount;
                    if(availMRR != 0){
                        targetJQGIDiscount = 1-(targetMRR/availMRR).setScale(4);
                    }
                    Decimal newMrr = availMRR*(1-targetJQGIDiscount);
                    if(jqgi.decMrr.setScale(3)-newMrr.setScale(3) == singleDiscount){
                        jqgi.decDiscount = targetJQGIDiscount*100;
                        jqgi.decMRR = DP_DatapipeUtility.calculate_mrr(jqgi.decDPLPUSD,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount);
                        jqgi.decUSDMRR = jqgi.decMRR * cQuote.DP_Exchange_Rate__c;
                        system.debug('found one');
                        break;
                    }
                }
            }
        }
         system.debug('setscale :' + quotePrice.setScale(2));
        if(quotePrice.setScale(2) != targetPrice){ //if it's still not there
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING,'Target Price is not mathematically possible within 2 decimal places!'));
        }
        strJSONQLGrid = JSON.serialize(lstJQGI);
        calcMrrByTerm();
        //Only recalc the config section if it is shown
        if(showConfig){
            List<JQGridItem> lstJQGIPreview = (List<JQGridItem>)JSON.deserialize(strJSONPreviewGrid,List<JQGridItem>.class);
            for(JQGridItem jqgi : lstJQGIPreview){
                jqgi.decDiscount = discount;
                jqgi.decMRR = DP_DatapipeUtility.calculate_mrr(jqgi.decDPLPUSD,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount);
                jqgi.decUSDMRR = jqgi.decMRR * cQuote.DP_Exchange_Rate__c;
            }
            for(Map<String,JQGridItem> mapSJQGI : mapTypeChild.values()){
            system.debug('mapsJQGI:'+mapsJQGI);
                for(JQGridItem jqgi : mapSJQGI.values()){
                    jqgi.decDiscount = discount;
                    jqgi.decMRR = DP_DatapipeUtility.calculate_mrr(jqgi.decDPLPUSD,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount);
                    jqgi.decUSDMRR = jqgi.decMRR * cQuote.DP_Exchange_Rate__c;
                }
            }
            for(Map<String,JQGridItem> mapSJQGI : mapTypeReqChild.values()){
            system.debug('mapsJQGI:'+mapsJQGI);
                for(JQGridItem jqgi : mapSJQGI.values()){
                    jqgi.decDiscount = discount;
                    jqgi.decMRR = DP_DatapipeUtility.calculate_mrr(jqgi.decDPLPUSD,cQuote.DP_Exchange_Rate__c,jqgi.decDiscount);
                    jqgi.decUSDMRR = jqgi.decMRR * cQuote.DP_Exchange_Rate__c;
                }
            }
            strJSONPreviewGrid = JSON.serialize(lstJQGIPreview);
            setAvailableChildren(lstJQGIPreview);
        }
        //return null;
    }
    
    public List<SelectOption> getserviceTypes(){
        List<SelectOption> rtn = new List<SelectOption>();
        List<String> serviceTypes = new List<String>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = Product2.getSObjectType(); 
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        // Get the list of picklist values for this field.
        List<Schema.PicklistEntry> values = fieldMap.get('DP_Service_Type__c').getDescribe().getPickListValues();
        serviceTypes = new List<String>();
        for(Schema.PicklistEntry v: values){
            serviceTypes.add(v.getValue());
        }
        for (String a : serviceTypes){ 
            rtn.add(new SelectOption(a, a)); 
        }
        return rtn;
    }
    
    public List<SelectOption> getUnitMeasures(){
        List<SelectOption> rtn = new List<SelectOption>();
        List<String> serviceTypes = new List<String>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = Product2.getSObjectType(); 
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        // Get the list of picklist values for this field.
        List<Schema.PicklistEntry> values = fieldMap.get('DP_Unit_of_Measure__c').getDescribe().getPickListValues();
        serviceTypes = new List<String>();
        for(Schema.PicklistEntry v: values){
            serviceTypes.add(v.getValue());
        }
        for (String a : serviceTypes){ 
            rtn.add(new SelectOption(a, a)); 
        }
        return rtn;
    }
                               
    
   public DP_NewEditQuoteController(){
        Filetype = '';
           // lstJQGridItem = new List<JQGridItemexcel>();
           header = 'strAction,strAvailability \r\n';                     
    }
 
 public pagereference exportToExcel(){
 lstJQGridItem = new List<JQGridItemexcel>();
 String strquote  = ApexPages.currentPage().getParameters().get('Id');
 //'0Q0U0000000YXcC';
  string queryString = 'SELECT Id,DP_Asset_Action__c,PricebookentryId,Pricebookentry.Name,DP_MRR__c,Pricebookentry.product2.Name,Pricebookentry.Product2.DP_Availability__c,DP_Data_Center__r.Name,Quantity,UnitPrice,  QuoteId,DP_Setup_Fee__c,PriceBookentry.Product2.DP_Data_Center__r.Name, DP_Max_Discount__c,DP_Markup__c,DP_Discount__c,DP_Parent_Quote_Line__c,DP_Data_Center__r.DP_kWCost__c,DP_Data_Center__r.DP_kW_Markup__c,DP_MRR_USD__c,DP_Name__c,DP_Base_Quantity__c,DP_Parent_Quote_Line__r.Quantity,DP_CAPEX__c,TotalPrice,DP_Quote_group__c FROM QuoteLineItem WHERE QuoteId =:strquote';
 List<QuotelineItem> lstJQGI1 =DataBase.Query(queryString);
   //List<QuotelineItem> lstJQGI1 =  (List<JQGridItem>)JSON.deserialize(strJSONQLGrid,List<JQGridItem>.class);
          if(lstJQGI1.size()>0){
                         for(QuoteLineItem csd :lstJQGI1){
                  JQGridItemexcel w = new JQGridItemexcel();
                //  w.strQLItemId = csd.strQLItemId;
                //  w.strQLItemId = csd.Id;
               //   system.debug('w.strQLItemId :'+w.strQLItemId);
               //  w.strParentId = strquote;
                //  w.strPBEId = csd.strPBEId;
                //  w.strAction = csd.strAction ;
              w.strproduct = csd.Pricebookentry.product2.Name;
                   w.strDataCenter = csd.DP_Data_Center__r.Name;
                    w.decSetupFee = csd.DP_Setup_Fee__c;
                     w.decQty  = csd.Quantity;
                      w.baseQty = csd.DP_Base_Quantity__c;
                       w.decDiscount = csd.DP_Discount__c;
                        w.maxDiscount  = csd.DP_Max_Discount__c;
                        w.decUnitMrr = csd.UnitPrice;
                       w.decMRR = csd.DP_MRR_USD__c;
                       w.TotalPrice =csd.TotalPrice;
                       w.decCAPEX = csd.DP_capex__c;
                       w.strLineItemGroup =csd.DP_Quote_group__c;
                 //w.strAvailability = csd.Pricebookentry.Product2.DP_Availability__c;
               //   w.strPBEId = csd.PricebookentryId;
                   
                lstJQGridItem.add(w); 
                             
              }     
               system.debug('lstJQGridItem :'+lstJQGridItem.size());         
          }
          system.debug('lstJQGridItem :'+lstJQGI1.size());
         // return new Pagereference('/apex/ViewQuoteGrid'); 
          PageReference p=new Pagereference('/apex/QuoteLineGridExport');
         return p;
   }
 
/*   public Void gettotalsum1(){
   String strquote  = ApexPages.currentPage().getParameters().get('Id');
 AggregateResult[] groupedresult=DataBase.Query('SELECT sum(UnitPrice),sum(DP_CAPEX__c),sum(TotalPrice) FROM QuoteLineItem WHERE QuoteId =:strquote');
 object totalsum1=groupedresult[0].get('DP_CAPEX__c');
//return totalsum;
}*/

 }