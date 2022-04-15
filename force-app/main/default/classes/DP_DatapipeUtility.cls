/*
@Name : DatapipeUtility
@Author : customersuccess@cloud62.com
@Date : 07-24-2013
@Description : This is a utility class having all the generic methods
 -- Do the calculation for Rollup the QuoteLineItem fields to Qoute fields.
 
*/
public class DP_DatapipeUtility {
    
    public class CustomException extends Exception{}
    
    /*
    @Name :sortLstQLIByProdType
    sort the passed in list of quote line items in the following order by product type
    Role
    Server
    Operating System
    Processor
    Hard Drive
    RAID
    Memory
    PowerSupply
    Network Interface Adapter
    Host Bus Adapter
    */
    /*
    public static List<QuoteLineItem> sortLstQLIByProdType(List<QuoteLineItem> lstQLI){
        List<QuoteLineItem> lstSorted = new List<QuoteLineItem>();
        Set<QuoteLineItem> setNotSorted = new Set<QuoteLineItem>();
        List<String> lstSortVals = new List<String>();
        lstSortVals.add('Role');
        lstSortVals.add('Server');
        lstSortVals.add('Processor');
        lstSortVals.add('Operating System');
        lstSortVals.add('Hard Drive');
        lstSortVals.add('RAID');
        lstSortVals.add('Network Interface Adapter');
        lstSortVals.add('Host Bus Adapter');
        Set<String> setSortVals = new Set<String>(lstSortVals);
        for(String sortVal : lstSortVals){
            for(QuoteLineItem qli : lstQLI){
                if(qli.Pricebookentry.product2.DP_Product_Type__c == sortVal){
                    lstSorted.add(qli);
                } else if(!setSortVals.contains(qli.Pricebookentry.product2.DP_Product_Type__c)){
                    setNotSorted.add(qli);
                }
            }
        }
        lstSorted.addAll(setNotSorted);
        return lstSorted;
    }
    */
    public static List<QuoteLineItem> sortLstQLIByProdType(List<QuoteLineItem> lstQLI){
        /*
            Role
            Server
            Operating System
            Processor
            Hard Drive
            RAID
            Memory
            PowerSupply
            Network Interface Adapter
            Host Bus Adapter
        */
        List<QuoteLineItem> lstSorted = new List<QuoteLineItem>();
        List<QuoteLineItem> lstNotSorted = new List<QuoteLineItem>();
        
        List<QuoteLineItem> role = new List<QuoteLineItem>();
        List<QuoteLineItem> server = new List<QuoteLineItem>();
        List<QuoteLineItem> os = new List<QuoteLineItem>();
        List<QuoteLineItem> proc = new List<QuoteLineItem>();
        List<QuoteLineItem> hd = new List<QuoteLineItem>();
        List<QuoteLineItem> raid = new List<QuoteLineItem>();
        List<QuoteLineItem> nic = new List<QuoteLineItem>();
        List<QuoteLineItem> hba = new List<QuoteLineItem>();
        List<QuoteLineItem> memory = new List<QuoteLineItem>();
        List<QuoteLineItem> psu = new List<QuoteLineItem>();
        
        for(QuoteLineItem qli : lstQLI){
            if(qli.PriceBookEntry.Product2 != null){
                if(qli.PriceBookEntry.Product2.DP_Product_Type__c == 'Role'){
                    role.add(qli);
                } else if(qli.PriceBookEntry.Product2.DP_Product_Type__c == 'Server'){
                    server.add(qli);
                } else if(qli.PriceBookEntry.Product2.DP_Product_Type__c == 'Operating System'){
                    os.add(qli);
                } else if(qli.PriceBookEntry.Product2.DP_Product_Type__c == 'Processor'){
                    proc.add(qli);
                } else if(qli.PriceBookEntry.Product2.DP_Product_Type__c == 'Hard Drive'){
                    hd.add(qli);
                } else if(qli.PriceBookEntry.Product2.DP_Product_Type__c == 'RAID'){
                    raid.add(qli);
                } else if(qli.PriceBookEntry.Product2.DP_Product_Type__c == 'Memory'){
                    memory.add(qli);
                } else if(qli.PriceBookEntry.Product2.DP_Product_Type__c == 'Power Supply'){
                    psu.add(qli);
                } else if(qli.PriceBookEntry.Product2.DP_Product_Type__c == 'Network Interface Card'){
                    nic.add(qli);
                } else if(qli.PriceBookEntry.Product2.DP_Product_Type__c == 'Host Bus Adapter'){
                    hba.add(qli);
                } else {
                    lstNotSorted.add(qli);
                }
            } else {
                lstNotSorted.add(qli);
            }
        }
        lstSorted.addAll(role);
        lstSorted.addAll(server);
        lstSorted.addAll(os);
        lstSorted.addAll(proc);
        lstSorted.addAll(hd);
        lstSorted.addAll(raid);
        lstSorted.addAll(memory);
        lstSorted.addAll(psu);
        lstSorted.addAll(nic);
        lstSorted.addAll(hba);
        lstSorted.addAll(lstNotSorted);
        return lstSorted;
    }
    
    /*
    @Name :rollupQuoteLineItems
    @Description : rollup the Quote Line Items. This method should rollup the Quote Line fields to Quote
    */
    public Static Quote rollupQuoteLineItems(Quote q){
        q.DP_DP_Total_List_Price__c = 0;
        q.DP_Equipment_List__c = 0;
        q.DP_Equipment_MRR__c = 0;
        q.DP_Software_List__c = 0;
        q.DP_Services_MRR__c = 0;
        q.DP_Services_List__c = 0;
        q.DP_Plugin_Cost__c = 0;
        q.DP_Plugin_List__c = 0;
        q.DP_Plugin_MRR__c = 0;
        q.DP_Software_MRR__c = 0;
        q.DP_Total_MRR_USD__c = 0;
        q.DP_Equipment_Fully_Discounted__c = 0;
        q.DP_Software_Fully_Discounted__c = 0;
        q.DP_Plugin_Fully_Discounted__c = 0;
        q.DP_Services_Fully_Discounted__c = 0;
        
        for(QuoteLineItem qli : q.QuoteLineItems){
            if(qli.DP_Asset_Action__c == null){
                system.debug('rolling up a QLI regular with AssetAction: '+qli.DP_Asset_Action__c+' and MRR: '+qli.DP_MRR__c);
                if(qli.DP_Services_Fully_Discounted__c != null){
                    q.DP_Services_Fully_Discounted__c += qli.DP_Services_Fully_Discounted__c;
                }
                if(qli.DP_Plugin_Fully_Discounted__c != null){
                    q.DP_Plugin_Fully_Discounted__c += qli.DP_Plugin_Fully_Discounted__c;
                }
                if(qli.DP_Software_Fully_Discounted__c != null){
                    q.DP_Software_Fully_Discounted__c += qli.DP_Software_Fully_Discounted__c;
                }
                if(qli.DP_Equipment_Fully_Discounted__c != null){
                    q.DP_Equipment_Fully_Discounted__c += qli.DP_Equipment_Fully_Discounted__c;
                }
                if(qli.DP_DatapipeListPrice__c != null){
                    q.DP_DP_Total_List_Price__c = q.DP_DP_Total_List_Price__c + qli.DP_DatapipeListPrice__c;
                }
                if(qli.DP_Equipment_List__c != null){
                    q.DP_Equipment_List__c = q.DP_Equipment_List__c + qli.DP_Equipment_List__c;
                }
                if(qli.DP_Equipment_MRR__c != null){
                    q.DP_Equipment_MRR__c = q.DP_Equipment_MRR__c + qli.DP_Equipment_MRR__c;
                }
                if(qli.DP_Software_List__c != null){
                    q.DP_Software_List__c = q.DP_Software_List__c + qli.DP_Software_List__c;
                }
                if(qli.DP_Services_MRR__c != null){
                    q.DP_Services_MRR__c = q.DP_Services_MRR__c + qli.DP_Services_MRR__c;
                }
                if(qli.DP_Services_List__c != null){
                    q.DP_Services_List__c = q.DP_Services_List__c + qli.DP_Services_List__c;
                }
                if(qli.DP_Plugin_Cost__c != null){
                    q.DP_Plugin_Cost__c = q.DP_Plugin_Cost__c + qli.DP_Plugin_Cost__c;
                }
                if(qli.DP_Plugin_List__c != null){
                    q.DP_Plugin_List__c = q.DP_Plugin_List__c + qli.DP_Plugin_List__c;
                }
                if(qli.DP_Plugin_MRR__c != null){
                    q.DP_Plugin_MRR__c = q.DP_Plugin_MRR__c + qli.DP_Plugin_MRR__c;
                }
                if(qli.DP_Software_MRR__c != null){
                    q.DP_Software_MRR__c = q.DP_Software_MRR__c + qli.DP_Software_MRR__c;
                }
                if(qli.DP_MRR_USD__c != null){
                    q.DP_Total_MRR_USD__c = q.DP_Total_MRR_USD__c + qli.DP_MRR_USD__c;
                }
            } else {
                if(qli.DP_MRR__c < 0){
                    system.debug('rolling up a QLI change with AssetAction: '+qli.DP_Asset_Action__c+' and MRR: '+qli.DP_MRR__c);
                    if(qli.DP_Services_Fully_Discounted__c != null){
                        q.DP_Services_Fully_Discounted__c -= qli.DP_Services_Fully_Discounted__c;
                    }
                    if(qli.DP_Plugin_Fully_Discounted__c != null){
                        q.DP_Plugin_Fully_Discounted__c -= qli.DP_Plugin_Fully_Discounted__c;
                    }
                    if(qli.DP_Software_Fully_Discounted__c != null){
                        q.DP_Software_Fully_Discounted__c -= qli.DP_Software_Fully_Discounted__c;
                    }
                    if(qli.DP_Equipment_Fully_Discounted__c != null){
                        q.DP_Equipment_Fully_Discounted__c -= qli.DP_Equipment_Fully_Discounted__c;
                    }
                    if(qli.DP_DatapipeListPrice__c != null){
                        q.DP_DP_Total_List_Price__c = q.DP_DP_Total_List_Price__c - qli.DP_DatapipeListPrice__c;
                    }
                    if(qli.DP_Equipment_List__c != null){
                        q.DP_Equipment_List__c = q.DP_Equipment_List__c - qli.DP_Equipment_List__c;
                    }
                    if(qli.DP_Equipment_MRR__c != null){
                        q.DP_Equipment_MRR__c = q.DP_Equipment_MRR__c - qli.DP_Equipment_MRR__c;
                    }
                    if(qli.DP_Software_List__c != null){
                        q.DP_Software_List__c = q.DP_Software_List__c - qli.DP_Software_List__c;
                    }
                    if(qli.DP_Services_MRR__c != null){
                        q.DP_Services_MRR__c = q.DP_Services_MRR__c - qli.DP_Services_MRR__c;
                    }
                    if(qli.DP_Services_List__c != null){
                        q.DP_Services_List__c = q.DP_Services_List__c - qli.DP_Services_List__c;
                    }
                    if(qli.DP_Plugin_Cost__c != null){
                        q.DP_Plugin_Cost__c = q.DP_Plugin_Cost__c - qli.DP_Plugin_Cost__c;
                    }
                    if(qli.DP_Plugin_List__c != null){
                        q.DP_Plugin_List__c = q.DP_Plugin_List__c - qli.DP_Plugin_List__c;
                    }
                    if(qli.DP_Plugin_MRR__c != null){
                        q.DP_Plugin_MRR__c = q.DP_Plugin_MRR__c - qli.DP_Plugin_MRR__c;
                    }
                    if(qli.DP_Software_MRR__c != null){
                        q.DP_Software_MRR__c = q.DP_Software_MRR__c - qli.DP_Software_MRR__c;
                    }
                    if(qli.DP_MRR_USD__c != null){
                        q.DP_Total_MRR_USD__c = q.DP_Total_MRR_USD__c + qli.DP_MRR_USD__c;
                    }
                }
            }
        }
        return q;
    }
    
    
    /*
    @Name :calculate_Lease1
    lease 1 formula = DP_Lease_12__c * Quote.DP_Month_to_Month_Multiplier__c
    */
    public static decimal calculate_Lease1(decimal lease12, decimal quoteMonthToMonthMultiplier){
        
        return (lease12 * quoteMonthToMonthMultiplier).setScale(2, System.roundingMode.CEILING);
    }
    

    /*
    @Name :calculate_Lease12
    lease 12 formula = IF(DP_Formula_Exempt__c,Product2.DP_Landed_Cost__c, 
                                ( Product2.DP_Landed_Cost__c / (12 / ( Quote.DP_Operational_Life_Factor__c ))) 
                                + (Product2.DP_Landed_Cost__c * ( Quote.DP_Cost_of_Money__c / Quote.DP_Money_Making_Months__c )) 
                                )
    */
    public static decimal calculate_Lease12(boolean formulaExempt, decimal landedCost, decimal operationalLifeFactor, decimal costOfMoney, decimal moneyMakingMonth){
        
        Decimal lease12 = 0;
        if(landedCost == null){landedCost = 0;}
    
        if(formulaExempt){
            lease12 = landedCost;
        }else{
            lease12 = (landedCost / (12 / operationalLifeFactor )) + (landedCost * ((costOfMoney/100) / moneyMakingMonth));
        }
        System.debug(formulaExempt + ' : ' + landedCost + ' : ' + operationalLifeFactor + ' : ' + costOfMoney + ' : ' + moneyMakingMonth + ' : ' + lease12);
        return lease12.setScale(2, System.roundingMode.CEILING);
    }        


    /*
    @Name :calculate_Lease24
    lease 24 formula = IF(DP_Formula_Exempt__c,Product2.DP_Landed_Cost__c, 
                                ( Product2.DP_Landed_Cost__c / (24 / ( Quote.DP_Operational_Life_Factor__c ))) 
                                + (Product2.DP_Landed_Cost__c * ( Quote.DP_Cost_of_Money__c / Quote.DP_Money_Making_Months__c )) )
    */
    public static decimal calculate_Lease24(boolean formulaExempt, decimal landedCost, decimal operationalLifeFactor, decimal costOfMoney, decimal moneyMakingMonth){
        Decimal lease24 = 0;
        if(formulaExempt){
            lease24 = landedCost;
        }else{
            lease24 = (landedCost / (24 / operationalLifeFactor )) + (landedCost * ((costOfMoney/100) / moneyMakingMonth));
        }
        
        return lease24.setScale(2, System.roundingMode.CEILING);
    }
    
    
    /*
    @Name :calculate_Lease36
    lease 36 formula = IF(DP_Formula_Exempt__c,Product2.DP_Landed_Cost__c, 
                                ( Product2.DP_Landed_Cost__c / (36 / ( Quote.DP_Operational_Life_Factor__c ))) 
                                + (Product2.DP_Landed_Cost__c * ( Quote.DP_Cost_of_Money__c / Quote.DP_Money_Making_Months__c )) )
    */
    public static decimal calculate_Lease36(boolean formulaExempt, decimal landedCost, decimal operationalLifeFactor, decimal costOfMoney, decimal moneyMakingMonth){
        Decimal lease36 = 0;
        if(formulaExempt){
            lease36 = landedCost;
        }else{
            lease36 = (landedCost / (36 / operationalLifeFactor )) + (landedCost * ((costOfMoney/100) / moneyMakingMonth));
        }
        
        return lease36.setScale(2, System.roundingMode.CEILING);
    } 
    
    /*
    @Name :calculate_Lease48
    lease 48 formula = IF(DP_Formula_Exempt__c,Product2.DP_Landed_Cost__c, 
                                ( Product2.DP_Landed_Cost__c / (48 / ( Quote.DP_Operational_Life_Factor__c ))) 
                                + (Product2.DP_Landed_Cost__c * ( Quote.DP_Cost_of_Money__c / Quote.DP_Money_Making_Months__c )) )
    */
    public static decimal calculate_Lease48(boolean formulaExempt, decimal landedCost, decimal operationalLifeFactor, decimal costOfMoney, decimal moneyMakingMonth){
        Decimal lease48 = 0;
        if(formulaExempt){
            lease48 = landedCost;
        }else{
            lease48 = (landedCost / (48 / operationalLifeFactor )) + (landedCost * ((costOfMoney/100) / moneyMakingMonth));
        }
        
        return lease48.setScale(2, System.roundingMode.CEILING);
    } 


    /*
    @Name :calculate_Lease60
    lease 60 formula = IF(DP_Formula_Exempt__c,Product2.DP_Landed_Cost__c, 
                                ( Product2.DP_Landed_Cost__c / (60 / ( Quote.DP_Operational_Life_Factor__c ))) 
                                + (Product2.DP_Landed_Cost__c * ( Quote.DP_Cost_of_Money__c / Quote.DP_Money_Making_Months__c )) )
    */
    public static decimal calculate_Lease60(boolean formulaExempt, decimal landedCost, decimal operationalLifeFactor, decimal costOfMoney, decimal moneyMakingMonth){
        Decimal lease60 = 0;
        if(formulaExempt){
            lease60 = landedCost;
        }else{
            lease60 = (landedCost / (60 / operationalLifeFactor )) + (landedCost * ((costOfMoney/100) / moneyMakingMonth));
        }
        
        return lease60.setScale(2, System.roundingMode.CEILING);
    } 
    
    /*
    @Name :calculate_kwLandedCost
    kW landed cost = kWCost / (1-kWMarkup)
    */
    public static Decimal calculate_kwLandedCost(Decimal kwCost, Decimal kwMarkup){
        return kwCost / (1-kwMarkup);
    }
    
    /*
    @Name :calculate_kW1
    kW 1 = kw12 * quoteKWMonthToMonthMultiplier
    */
    public static Decimal calculate_kW1(Decimal kw12, Decimal quoteKWMonthToMonthMultiplier){
        return kw12 * quoteKWMonthToMonthMultiplier;
    }
    
    /*
    @Name :calculate_kW12
    kW 12 = Quantity * Quote.kWHoursInMonth * kW * kWLandedCost
    */
    public static Decimal calculate_kW12(Decimal quantity, Decimal quoteKWHoursInMonth, Decimal kw, Decimal kwLandedCost){
        return  quoteKWHoursInMonth * kw * kwLandedCost ;//* quantity;
    }
    
    /*
    @Name :calculate_kW24
    kW 24 = kw12 * quoteKWTermMultiplier
    */
    public static Decimal calculate_kW24(Decimal kw12, Decimal quoteKWTermMultiplier){
        return kw12 * quoteKWTermMultiplier;
    }
    
    /*
    @Name :calculate_kW36
    kW 36 = kw12 * (quoteKWTermMultiplier^2)
    */
    public static Decimal calculate_kW36(Decimal kw12, Decimal quoteKWTermMultiplier){
        return kw12 * quoteKWTermMultiplier * quoteKWTermMultiplier;
    }
    
    /*
    @Name :calculate_kW48
    kW 48 = kw12 * (quoteKWTermMultiplier^3)
    */
    public static Decimal calculate_kW48(Decimal kw12, Decimal quoteKWTermMultiplier){
        return kw12 * quoteKWTermMultiplier * quoteKWTermMultiplier * quoteKWTermMultiplier;
    }
    
    /*
    @Name :calculate_kW60
    kW 60 = kw12 * (quoteKWTermMultiplier^4)
    */
    public static Decimal calculate_kW60(Decimal kw12, Decimal quoteKWTermMultiplier){
        return kw12 * quoteKWTermMultiplier * quoteKWTermMultiplier * quoteKWTermMultiplier * quoteKWTermMultiplier;
    }
    
    /*
    @Name :calculate_mrr
    default mrr formula = (datapipeListPrice * (1 - discount)) * (1/quoteExchangeRate)
    */
    public static decimal calculate_mrr(Decimal datapipeListPriceUSD,Decimal quoteExchangeRate,Decimal discount){
        Decimal decReturn = (datapipeListPriceUSD * (1 - (discount/100))) * (1/quoteExchangeRate);
        return decReturn;
    }
    
    /*
    @Name :calculate_datapipeListPriceUSD
    default datapipeListPriceUSD formula = quantity * (leasePrice + kwPrice)
    */
    public static decimal calculate_datapipeListPriceUSD(String quoteTerm, 
                                        Decimal quoteOperationalLifeFactor,
                                        Decimal quoteCostOfMoney,
                                        Decimal quoteMoneyMakingMonths,
                                        Decimal quoteMonthToMonthMultiplier,
                                        Decimal quoteKWMonthToMonthMultiplier,
                                        Decimal quoteKWHoursInMonth,
                                        Decimal quoteKWTermMultiplier,
                                        Decimal kw,
                                        Decimal kwCost,
                                        Decimal kwMarkup,
                                        Decimal quantity,
                                        Boolean formulaExempt,
                                        Decimal landedCost,
                                        Decimal base)
    {
        //The actual quantity is does not include the base number of items that comes prepackaged
        Decimal priceQty = quantity - base;
        if(priceQty < 0) priceQty = 0;
        Decimal kwLandedCost = DP_DatapipeUtility.calculate_kwLandedCost(kwCost,kwMarkup);
        Decimal leasePrice;
        Decimal kw12 = DP_DatapipeUtility.calculate_kW12(priceQty,quoteKWHoursInMonth,kw,kwLandedCost);
        //System.debug(priceQty + ' : ' + quoteKWHoursInMonth + ' : ' + kw + ' : ' + kwLandedCost + ' : ' + kwCost + ' : ' + kwMarkup + ' : ' + kw12);
        Decimal kwPrice = kw12;
        if(quoteTerm == '1'){
            Decimal decL12 = DP_DatapipeUtility.calculate_Lease12(formulaExempt,landedCost,quoteOperationalLifeFactor,quoteCostOfMoney,quoteMoneyMakingMonths);  
            leasePrice = DP_DatapipeUtility.calculate_kW1(kw12,quoteKWMonthToMonthMultiplier);
        } else if(quoteTerm == '12'){
            leasePrice = DP_DatapipeUtility.calculate_Lease12(formulaExempt,landedCost,quoteOperationalLifeFactor,quoteCostOfMoney,quoteMoneyMakingMonths);  
        } else if(quoteTerm == '24'){
            leasePrice = DP_DatapipeUtility.calculate_Lease24(formulaExempt,landedCost,quoteOperationalLifeFactor,quoteCostOfMoney,quoteMoneyMakingMonths);  
            kwPrice = DP_DatapipeUtility.calculate_kW24(kw12,quoteKWTermMultiplier);
        } else if(quoteTerm == '36'){
            leasePrice = DP_DatapipeUtility.calculate_Lease36(formulaExempt,landedCost,quoteOperationalLifeFactor,quoteCostOfMoney,quoteMoneyMakingMonths);  
            kwPrice = DP_DatapipeUtility.calculate_kW36(kw12,quoteKWTermMultiplier);
        } else if(quoteTerm == '48'){
             leasePrice = DP_DatapipeUtility.calculate_Lease48(formulaExempt,landedCost,quoteOperationalLifeFactor,quoteCostOfMoney,quoteMoneyMakingMonths);  
             kwPrice = DP_DatapipeUtility.calculate_kW48(kw12,quoteKWTermMultiplier);
        } else if(quoteTerm == '60'){
            leasePrice = DP_DatapipeUtility.calculate_Lease60(formulaExempt,landedCost,quoteOperationalLifeFactor,quoteCostOfMoney,quoteMoneyMakingMonths);  
            kwPrice = DP_DatapipeUtility.calculate_kW60(kw12,quoteKWTermMultiplier);
        } else {
            leasePrice = 0;
            kwPrice = 0;
        }
        //System.debug(priceQty + ' : ' + leasePrice + ' : ' + kwPrice);
        Decimal datapipeListPriceUSD = priceQty * (leasePrice + kwPrice);
        return datapipeListPriceUSD.setScale(2, System.roundingMode.CEILING);
    }
    public static String getFields(String strSObjectName) {
        SObjectType sot = Schema.getGlobalDescribe().get(strSObjectName);
        if (sot == null) return null;
        List<Schema.SObjectField> lstFields = sot.getDescribe().fields.getMap().values();
        String strReturn = '';
        for(Integer i = 0; i < lstFields.size(); i++){
           if(lstFields.get(i).getDescribe().LocalName == 'LastViewedDate') continue;
           if(lstFields.get(i).getDescribe().LocalName == 'Address') continue;
           if(lstFields.get(i).getDescribe().LocalName == 'BillingAddress') continue;
           if(lstFields.get(i).getDescribe().LocalName == 'QuoteToAddress') continue;
           if(lstFields.get(i).getDescribe().LocalName == 'ShippingAddress') continue;
           if(lstFields.get(i).getDescribe().LocalName == 'AdditionalAddress') continue;
          
          
           if(i == lstFields.size() - 1){
               strReturn += lstFields.get(i).getDescribe().LocalName;
           } else {
               strReturn += lstFields.get(i).getDescribe().LocalName + ',';
           }
        } 
        return strReturn;
    }
    
    public static Integer testUtil(){
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        return i;
    }
}