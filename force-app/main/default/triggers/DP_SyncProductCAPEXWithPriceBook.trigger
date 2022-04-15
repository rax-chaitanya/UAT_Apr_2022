/*
@Name            : SyncProductCAPEXWithPriceBook 
@Author          : customersuccess@cloud62.com
@Date            : July 16, 2013
@Description     : Syncs the standard pricebook price with the CAPEX value from the product
*/
trigger DP_SyncProductCAPEXWithPriceBook on Product2 (after insert, before update, after update) {
    
    /* added logic to skip the clone case */
    if(Trigger.new.size() == 1 && Trigger.new[0].DP_Clone_Process_Helper__c){
       DP_ProductCloneHelper.isClone = true;
       if(Trigger.isBefore && Trigger.isUpdate) Trigger.new[0].DP_Clone_Process_Helper__c = false;
       return;
    }
    
    if(DP_ProductCloneHelper.isClone) return;
        
    
    
    PriceBook2 pbStandard = [SELECT Id from PriceBook2 WHERE Name = 'Standard Price Book'];
    //Find existing pricebookentries for standard USD products
    List<PriceBookEntry> lstPBEs = [SELECT Id,UnitPrice,Name,Product2Id 
                                    FROM PriceBookEntry 
                                    WHERE Product2Id IN :Trigger.newMap.keySet() 
                                    AND PriceBook2.Name = 'Standard Price Book' 
                                    AND CurrencyISOCode = 'USD'];
    Map<Id,PriceBookEntry> mapProdPBE = new Map<Id,PriceBookEntry>();
    for(PriceBookEntry pbe : lstPBEs){
        mapProdPBE.put(pbe.Product2Id,pbe);
    }
    List<PriceBookEntry> lstUpsertPBE = new List<PriceBookEntry>();
    for(Product2 prod : Trigger.new){              
        if(mapProdPBE.containsKey(prod.Id)){
            //If the pricebooketnry exists and the CAPEX is different then update the pricebookentry
            PriceBookEntry pbe = mapProdPBE.get(prod.Id);
            if(pbe.UnitPrice != prod.DP_CAPEX__c){
                pbe.UnitPrice = prod.DP_CAPEX__c;
                lstUpsertPBE.add(pbe);
            }
        } else {
            //If the pricebookentry does not exist then create it
            PriceBookEntry pbe = new PriceBookEntry();
            pbe.UnitPrice = prod.DP_CAPEX__c;
            pbe.PriceBook2Id = pbStandard.Id;
            pbe.CurrencyIsoCode = 'USD';
            pbe.IsActive = true;
            pbe.Product2Id = prod.Id;
            lstUpsertPBE.add(pbe);
        }
    }
    upsert lstUpsertPBE;
    
    /*
    //only Standard Price Book is in use
    List<PricebookEntry> pbeTobeUpdate = new List<PricebookEntry>();
    for(PriceBookEntry pb: [select id, UnitPrice, Name, Product2Id from PriceBookEntry where Product2Id IN: trigger.newmap.keyset() and PriceBook2.Name = 'Standard Price Book']){
        //if CAPEX is different in Standard Price Book Entry, store it in a list
        if(trigger.newmap.get(pb.Product2ID) != null &&  trigger.newmap.get(pb.Product2ID).DP_CAPEX__c != pb.UnitPrice){
            pb.UnitPrice = trigger.newmap.get(pb.Product2ID).DP_CAPEX__c;
            pbeTobeUpdate.add(pb);
        }
    }
    
    //update Price Book Entries
    update pbeTobeUpdate;
    */
}