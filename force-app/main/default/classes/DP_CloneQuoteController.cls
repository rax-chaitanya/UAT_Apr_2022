/*
@Name            : CloneQuoteController
@Author          : customersuccess@cloud62.com
@Date            : August 12, 2013
@Description     : Controller for CloneQuote page
*/
public class DP_CloneQuoteController {
    public Quote newQuote {get;set;}
    public List<QuoteLineItem> OldQuoteLineItems {get;set;}
    public List<QuoteLineItem> NewQuoteLineItems {get;set;}
    public Boolean refreshPricing {get;set;}
    public Map<Id,QuoteLineItem> quoteMap {get;set;}
    public Map<String,DP_Quote_Line_Group__c> mapGroups {get;set;}
    public String cErr {get;set;}
    
    public DP_CloneQuoteController(ApexPages.StandardController controller) {   
        mapGroups = new Map<String,DP_Quote_Line_Group__c>();
        refreshPricing = false;
        quoteMap = new Map<Id,QuoteLineItem>();
        Quote theQuote = database.query('select ' + DP_DatapipeUtility.getFields('Quote') + ' from Quote where id = \'' + ApexPages.CurrentPage().getParameters().get('id') + '\'');
       
        system.debug('theQuote'+ theQuote);                                        
        newQuote = theQuote.clone(false,true,false,false);
        NewQuoteLineItems = new List<QuoteLineItem>();
       Map<Id,String> QlIds = new Map<Id,String>();
         List<QuoteLineItem>  lstQLI1 = [SELECT Id,pricebookentry.product2.name,DP_PArent_quote_line__C FROM QuoteLineItem WHERE QuoteId = :theQuote.Id and pricebookentry.product2.isactive =true  and pricebookentry.product2.Dp_Availability__C in('Available' ,'Limited')    ];
        
         
        if ( lstQLI1.size()>0)
        {     
      // for(QuoteLineItem qli : database.query('select DP_Parent_Quote_Line__r.Quantity,DP_Quote_Group__r.Name,pricebookentry.product2.name,' + DP_DatapipeUtility.getFields('QuoteLineItem') + ' from QuoteLineItem where QuoteId = \'' + theQuote.Id + '\''))
         
          for(QuoteLineItem qli : database.query('select DP_Parent_Quote_Line__r.Quantity,DP_Quote_Group__r.Name,pricebookentry.product2.name,' + DP_DatapipeUtility.getFields('QuoteLineItem') + ' from QuoteLineItem where pricebookentry.product2.isactive= true and  QuoteId = \'' + theQuote.Id + '\''))
         
          {
           // Quotelineitem.add(qli.id);
                
          if ( lstQLI1.size()>0)         
           {
         
           if(Qli.acquisitionid__C !=null || qli.acquisition__C!=null)
           {
           qli.acquisitionid__C=null;
           qli.acquisition__C=null;
           }
            quoteMap.put(qli.Id,qli.clone(false,true,false,false));
            
            }
            } //for Qli   
            } 
          
       for(DP_Quote_Line_Group__c qlg : database.query('select ' + DP_DatapipeUtility.getFields('DP_Quote_Line_Group__c') + ' from DP_Quote_Line_Group__c where DP_Quote__c = \'' + theQuote.Id + '\''))
       { 
            mapGroups.put(qlg.Name,qlg.clone(false,true,false,false));
        }
         //throw error if trying to clone quote older than 1/1/2014
        Profile p = [SELECT Id,Name from Profile WHERE Id = :UserInfo.getProfileId()];
        Date dt = Date.newInstance(2014,1,1);
        if(theQuote.CreatedDate < dt && p.Name != 'System Administrator') cErr = 'Cannot clone quotes created before 1/1/2014';
            
        }
        
    public PageReference doClone(){
        Savepoint sp = database.setSavePoint();
        try{
            //Refresh the pricing to the default prices for a new quote
            if(refreshPricing){
                //Refresh the pricing for the quote
                DP_PricingSettings__c cPriceSettings = DP_PricingSettings__c.getOrgDefaults();
                newQuote.DP_Operational_Life_Factor__c = cPriceSettings.DP_OperationalLifeFactor__c;
                newQuote.DP_kW_Hours_In_Month__c = cPriceSettings.DP_kWHoursInMonth__c;
                newQuote.DP_Cost_of_Money__c = cPriceSettings.DP_CostOfMoney__c;
                newQuote.DP_Money_Making_Months__c = cPriceSettings.DP_MoneyMakingMonths__c;
                newQuote.DP_Month_to_Month_Multiplier__c = cPriceSettings.DP_MonthToMonthMultiplier__c;
                newQuote.DP_kW_Month_to_Month_Multiplier__c = cPriceSettings.DP_kWMonthToMonthMultiplier__c;
                newQuote.DP_kW_Term_Multiplier__c = cPriceSettings.DP_kWTermMultiplier__c;
                //Get the updated prices for the datacenters
                Map<Id,DP_DataCenter__c> mapDCs = new Map<Id,DP_DataCenter__c>([SELECT Id, Name, DP_kWCost__c, DP_kW_Markup__c FROM DP_DataCenter__c]);
                //Get the updated prices for the products
                Set<Id> setProdIds = new Set<Id>();
                
                if(quoteMap.values()!= null)
                {
                for(QuoteLineItem qli : quoteMap.values()){
                             setProdIds.add(qli.Pricebookentry.product2id);
                  
                }
                }
               
          
            Map<Id,Product2> mapProds = new Map<Id,Product2>([SELECT Id,DP_Availability__c,Name,DP_LandedCost__c,DP_CAPEX__c,
                                DP_kW__c,DP_Cost__c,DP_Markup__c,DP_Max_Discount__c,DP_Formula_Exempt__c,DP_Product_Type__c     
                                FROM Product2 
                                WHERE Id IN :setProdIds and isactive=true]);
                               
                //Get the old and new currency rate
                Decimal oldExRate =0;
                if(newQuote.DP_Exchange_Rate__c!=0)
                {
                 oldExRate = newQuote.DP_Exchange_Rate__c;
                }
                if(newQuote.DP_Exchange_Rate__c==0 && newQuote.DP_Currency_Code__c=='USD')
                {
                 oldExRate = 1;
                }
                
                newQuote.DP_Exchange_Rate__c = ExchangeRateIntegration.getexchangerate(newQuote.DP_Currency_Code__c);
                
                if(quoteMap.values()!= null)
                {
                //Update all of the values on the quote line item to the new pricing
              //  system.debug('quoteMap.values()'+quoteMap.values());
                
                for(QuoteLineItem qli : quoteMap.values()){
                    Product2 updatedProd = mapProds.get(qli.pricebookentry.product2id);
                    DP_DataCenter__c updatedDC = mapDCs.get(qli.DP_Data_Center__c);
                    if(updatedProd.DP_kW__c == null){
                        qli.DP_kW__c = 0;
                    } else {
                        qli.DP_kW__c = updatedProd.DP_kW__c;
                    }
                    qli.DP_kw_Cost__c = updatedDC.DP_kWCost__c;
                    qli.DP_kw_Markup__c = updatedDC.DP_kw_Markup__c;
                    qli.DP_Formula_Exempt__c = updatedProd.DP_Formula_Exempt__c;
                    Decimal decLandedCost = updatedProd.DP_CAPEX__c / (1-(updatedProd.DP_Markup__c/100));
                    if(updatedProd.DP_CAPEX__c == 0){
                        decLandedCost = updatedProd.DP_Cost__c / (1-(updatedProd.DP_Markup__c/100));
                    }
                    //Set the setupfee back to us dollar's before chanigng it to another currency
                    qli.DP_Setup_Fee__c = qli.DP_Setup_Fee__c * oldExRate;
                    qli.DP_Setup_Fee__c = qli.DP_Setup_Fee__c / newQuote.DP_Exchange_Rate__c;
                    Decimal decPQty = 1;
                    if(qli.DP_Parent_Quote_Line__c != null && qli.DP_Parent_Quote_Line__r.Quantity != null){
                        decPQty = qli.DP_Parent_Quote_Line__r.Quantity;
                    }
                    qli.DP_DatapipeListPriceUSD__c = DP_DatapipeUtility.calculate_datapipeListPriceUSD(
                                                    newQuote.DP_Term__c, 
                                                    newQuote.DP_Operational_Life_Factor__c,
                                                    newQuote.DP_Cost_of_Money__c,
                                                    newQuote.DP_Money_Making_Months__c,
                                                    newQuote.DP_Month_to_Month_Multiplier__c,
                                                    newQuote.DP_kW_Month_to_Month_Multiplier__c,
                                                    newQuote.DP_kW_Hours_In_Month__c,
                                                    newQuote.DP_kW_Term_Multiplier__c,
                                                    qli.DP_kW__c,
                                                    qli.DP_kw_Cost__c,
                                                    qli.DP_kw_Markup__c / 100,
                                                    qli.Quantity * decPQty,
                                                    qli.DP_Formula_Exempt__c,
                                                    decLandedCost,
                                                    qli.DP_Base_Quantity__c * decPQty);
                    qli.DP_MRR__c = DP_DatapipeUtility.calculate_mrr(qli.DP_DatapipeListPriceUSD__c,newQuote.DP_Exchange_Rate__c,qli.DP_Discount__c);
                }
                }
            }
            system.debug('before quote inert');
            if(newQuote.AcquisitionId__c!=null ||newQuote.Acquisition__c !=null)
            { newquote.AcquisitionId__c=null;
            newquote.Acquisition__C=null;
            }
           
            insert newQuote;  
          
            system.debug('after quote inert');
            //Insert the cloned groups 
           if(quoteMap.values()!= null)
                {
            for(DP_Quote_Line_Group__c qlg : mapGroups.values()){
                qlg.DP_Quote__c = newQuote.id;
         
           if(qlg.AcquisitionId__c!=null ||qlg.Acquisition__c !=null)
            { qlg.AcquisitionId__c=null;
            qlg.Acquisition__C=null;
            }
            } 
            system.debug('before mapgroups inert');    
            insert mapGroups.values();
           system.debug('after mapgroups inert');    
            } 
            List<QuoteLineItem> parentQuoteLines = new List<QuoteLineItem>();
            List<QuoteLineItem> childQuoteLines = new List<QuoteLineItem>();
           // system.debug('before quote lineitems inert'+ quoteMap.values());
            if(quoteMap.values()!= null)
                {
           for(QuoteLineItem qli : quoteMap.values()){
                qli.DP_Quote_Group__c = mapGroups.get(qli.DP_Quote_Group__r.Name).id;
                qli.QuoteId = newQuote.Id;
           if(qli.DP_Parent_Quote_Line__c == null)
           {     parentQuoteLines.add(qli);
                 }                
            }
             insert parentQuoteLines;
            for(QuoteLineItem qli : quoteMap.values())
            {
                   if(qli.DP_Parent_Quote_Line__c != null ){
                   List<QuoteLineItem>  chldQLI1 = [SELECT Id,DP_PArent_quote_line__C FROM QuoteLineItem WHERE  pricebookentry.product2.isactive =true  and pricebookentry.product2.Dp_Availability__C in('Available' ,'Limited')   and id=: qli.DP_Parent_Quote_Line__c];
         if(chldQli1.size()>0)
         {
                 
                   qli.DP_Parent_Quote_Line__c = quoteMap.get(qli.DP_Parent_Quote_Line__c).Id;
                    ChildQuoteLines.add(qli); 
                                       
                }    
                }//if chldqli1         
            }  
            if(ChildQuoteLines.size()>0)
            {
            insert ChildQuoteLines;}
               }
            return new PageReference('/apex/DP_NewEditQuote?Id=' + newQuote.id + '&retURL=%2F' + newQuote.id + '&oppid=' + newQuote.OpportunityId);
            
        }catch(Exception e){
            database.rollback(sp);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(myMsg);
        }    
        return null;
    }
    }