/**********************************************************************************

Author: Diego Castro
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the trigger.

**********************************************************************************/

public class QuoteLineItemHandler implements TriggerInterface
{
  public static boolean firstTgrRun = true;
        
    public Boolean isActive()
    {
        return Trigger_Manager__c.getInstance('QuoteLineItemTgr').Is_Active__c;
    } 
    public void beforeInsert() {
    }
    
    public void beforeUpdate() {}
    
    public void beforeDelete() {
        try {
            delete [Select Id from Quote_Line__c where QuoteLineItem__c in :Trigger.oldMap.keySet()];
        } catch (Exception e) {
            Exceptionhandler.postToAll(e, false);
        }
    }
    
    public void afterInsert()  {
        try {
            
            
            List<fieldMapping__c> fm = new list<FieldMapping__c>();
            fm = ([Select TargetField__c, SourceField__C from FieldMapping__c where CompName__c = 'QuoteLineItem01']);
            
            List<Quote_Line__c> toUpsert = new list<Quote_Line__c>();
            
            QuoteLineItem[] qli_list = new list<QuoteLineItem>();
            if (fm.size() > 0) {
                set<id> ids = Trigger.newMap.keyset();
                String fields = '';
                
                String[] fieldMaplst = new list<String>();
                for (FieldMapping__c f : fm) {
                    fieldMaplst.add(f.SourceField__c);
                }
                fields = String.join(fieldmaplst,',');
                String query = 'SELECT '  + fields + ',quote.quotesynced__C,Quote.IsSyncing, (Select Id from RAX_Quote_Lines__r order by createddate LIMIT 1)  FROM QuoteLineItem Where Id in :ids';
                qli_list = Database.query(query);
                
                if (qli_list.size() > 0) {
                    for (QuoteLineItem qli : qli_list) {
                        
                        Quote_Line__c custom_qli = new Quote_Line__c();
                        
                        if (qli.RAX_Quote_Lines__r.size() > 0) {
                            custom_qli.Id = qli.RAX_Quote_Lines__r[0].Id;
                        }
                        
                        for (FieldMapping__c f :fm) {
                            custom_qli.put(f.TargetField__c, Reusable.getValue(qli, f.SourceField__c));
                        }
                          if(qli.quote.quotesynced__C || Qli.Quote.IsSyncing)
                        {
                        toUpsert.add(custom_qli);     
                        }               
                    }
                    
                }
            }
            
/*            
            for (QuoteLineItem qli : (List<QuoteLineItem>) Trigger.new) {
   
            }
*/
            
            if (toUpsert.size() > 0) {
                upsert toUpsert;
                
            }
            
        } catch (Exception e) {
            ExceptionHandler.postToAll(e, false);
        }
    }
 
    public void afterUpdate() {
        try {
            
            
            List<fieldMapping__c> fm = new list<FieldMapping__c>();
            fm = ([Select TargetField__c, SourceField__C from FieldMapping__c where CompName__c = 'QuoteLineItem01']);
            
            List<Quote_Line__c> toUpsert = new list<Quote_Line__c>();
            
            QuoteLineItem[] qli_list = new list<QuoteLineItem>();
            if (fm.size() > 0) {
                set<id> ids = Trigger.newMap.keyset();
                String fields = '';
                
                String[] fieldMaplst = new list<String>();
                for (FieldMapping__c f : fm) {
                    fieldMaplst.add(f.SourceField__c);
                }
                fields = String.join(fieldmaplst,',');
                String query = 'SELECT '  + fields + ',quote.quotesynced__C,quote.IsSyncing, (Select Id from RAX_Quote_Lines__r order by createddate LIMIT 1)  FROM QuoteLineItem Where Id in :ids';
                qli_list = Database.query(query);
                
                if (qli_list.size() > 0) {
                    for (QuoteLineItem qli : qli_list) {
                        
                        Quote_Line__c custom_qli = new Quote_Line__c();
                        
                        if (qli.RAX_Quote_Lines__r.size() > 0) {
                            custom_qli.Id = qli.RAX_Quote_Lines__r[0].Id;
                        }
                        
                        for (FieldMapping__c f :fm) {
                            custom_qli.put(f.TargetField__c, Reusable.getValue(qli, f.SourceField__c));
                        } 
                          if(qli.quote.quotesynced__C || qli.Quote.IsSyncing)
                        {                       
                        toUpsert.add(custom_qli);     
                        }               
                        
                    }
                    
                }
            }
            
            /*
            for (QuoteLineItem qli : (List<QuoteLineItem>) Trigger.new) {
   
            }
*/
            
            if (toUpsert.size() > 0) {
                upsert toUpsert;
                
            }
            
        } catch (Exception e) {
            ExceptionHandler.postToAll(e, false);
        }       
    }
 
    public void afterDelete() {}
    
    public void afterUndelete() {}
    

    
}