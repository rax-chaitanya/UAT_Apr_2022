public class DPQuotelineitemHelper {
    public static void QuotelinedeleteUndelete(){
        
        Set<Id> SyncId = new Set<id>();
        Set<String> oppIds = new Set<String>();
        Boolean IsSync ;
        Boolean IsSyncing ;
        List<Quote> Q = new List<Quote>();
        
        for(Quote q1 :(List<Quote>)trigger.new){
            SyncId.add(q1.Id);
            oppIds.add(q1.Opportunityid);
            ISSync = q1.QuoteSynced__c;
            IsSyncing=q1.IsSyncing;
            q.add(q1);
        }
        set<id> QliIDs =new set<id>();
        List<Quote_Line__c> deleteItems = new List<Quote_Line__c>();
       
        List<Opportunity> OppSync = new list<Opportunity>{[select id,SyncedQuoteId from opportunity where ID in:oppids]};
       // if(OppSync[0].syncedQuoteid != null){
        if(!Issync && (!syncid.contains(OppSync[0].syncedQuoteid)) && !IsSyncing ){
            for(QuoteLineItem qli: [Select Id,QuoteId, QuoteOpportunityid__C,quote.quotesynced__C,Quote.issyncing
                                   from QuoteLineItem where
                                    Quote.Opportunityid IN:oppIds and Quoteid  in :SyncId ]){   
                       QliIds.add(qli.id);
            }
        }
        
        
        if(Issync && (syncid.contains(OppSYnc[0].syncedQuoteid)) ){
            for(QuoteLineItem qli: [Select Id,QuoteId, QuoteOpportunityid__C,quote.quotesynced__C,Quote.issyncing
                                   from QuoteLineItem where
                                    Quote.Opportunityid IN:oppIds and Quoteid not in :SyncId ])  
                        QliIds.add(qli.id);
            
        }
     //   }
        if(Qliids.size()>0)Delete [select id,Opportunity_Quote__C from quote_line__C where Quotelineitem__C in: QliIds];
    }  
}