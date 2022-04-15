/*######################################
#trigger Name: RollupQuoteLineItems
#Created Date: 07-22-13
#Questions: customersuccess@cloud62.com
#Description: Rollup Quote Line Item field value to Quote. This also rollup the Data Center at Opportunity level
#www.cloud62.com
########################################
*/
trigger DP_RollupQuoteLineItems on QuoteLineItem (after insert,after update, after delete) {
    //this Set contains the ID Quote
//    Set<ID> quoteIDs = new Set<ID>();
     Set<String> quoteIDs = new Set<String>();
   
    //if user delete any QuoteLineItem
    if(Trigger.isDelete){
         for(QuoteLineItem qli : Trigger.Old){
             quoteIDs.add(qli.QuoteID); //keep the Id of Quote
        }
    }else{//if user insert or update any QuoteLineItem
        for(QuoteLineItem qli : Trigger.New){
            quoteIDs.add(qli.QuoteID); //keep the Id of Quote
        }
    }
    
    List<Quote> updateQuotes = new List<Quote>();
    
    Map<ID, String> oppDataCenterMap = new Map<ID, String>();   
    Map<Id, DP_DataCenter__C> datacenters = new Map<Id, DP_DataCenter__C>([SELECT name FROM DP_Datacenter__C]);
    
    //now do the calculation
    for(Quote q : [SELECT ID,OpportunityId, DP_Equipment_List__c,DP_Equipment_MRR__c,DP_Software_List__c,DP_Services_MRR__c,DP_Services_List__c,
                  DP_Plugin_Cost__c,DP_Plugin_List__c,DP_Plugin_MRR__c,DP_DP_Total_List_Price__c,DP_Software_MRR__c,DP_Total_MRR_USD__c,
                  DP_Equipment_Fully_Discounted__c,DP_Software_Fully_Discounted__c, DP_Plugin_Fully_Discounted__c,DP_Services_Fully_Discounted__c,
                  (SELECT DP_Asset_Action__c, DP_MRR__c, DP_Data_Center__r.Name, Id,DP_Equipment_List__c,DP_Equipment_MRR__c,DP_Software_List__c,DP_Services_MRR__c,DP_Services_List__c,
                  DP_MRR_USD__c,DP_Plugin_Cost__c,DP_Plugin_List__c,DP_Plugin_MRR__c,DP_DatapipeListPrice__c,DP_Software_MRR__c,
                  DP_Equipment_Fully_Discounted__c,DP_Software_Fully_Discounted__c, DP_Plugin_Fully_Discounted__c,DP_Services_Fully_Discounted__c FROM QuoteLineItems)
                  FROM Quote WHERE ID IN : quoteIDs]){
        Quote rollupquote = DP_DatapipeUtility.rollupQuoteLineItems(q);
        updateQuotes.add(rollupquote);
        String dc = '';
        Map<String,String> tempDataCenterMap = new Map<String, String>();
        for(QuoteLineItem qli:q.QuoteLineItems){
   DP_DataCenter__c data= datacenters.get(qli.DP_Data_Center__r.Id);//added by PG -jiratkt :105
           // if(qli.DP_Data_Center__r.Name!= null && qli.DP_Data_Center__r.Name != '' && !tempDataCenterMap.containsKey(qli.DP_Data_Center__r.Name)){
                if(data !=null  && !tempDataCenterMap.containsKey(qli.DP_Data_Center__r.Name)){
                dc = dc + qli.DP_Data_Center__r.Name +';';                
               tempDataCenterMap.put(qli.DP_Data_Center__r.Name,qli.DP_Data_Center__r.Name);
            }
        }
        //if(dc != null && dc != ''){
            oppDataCenterMap.put(q.OpportunityId,dc);
        //}
        
    }
    //update Quotes
    if(updateQuotes.size()>0){ 
        update updateQuotes;
    }
    

    List<Opportunity> updateOppList = new List<Opportunity>();
    
    for(Opportunity o: [select Id, DP_Data_Center__c from Opportunity where ID IN : oppDataCenterMap.keySet()]){
        if(oppDataCenterMap.get(o.Id) != null && oppDataCenterMap.get(o.Id) != ''){
            o.DP_Data_Center__c = oppDataCenterMap.get(o.Id);
        }else{
            o.DP_Data_Center__c = null;
        }
        updateOppList.add(o);
    }
    
    //update Opportunity with Data Centers
    update updateOppList;
}