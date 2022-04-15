/**********************************************************************************

Author: Shantan Nagulapalli
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the trigger.

**********************************************************************************/
public class QuoteHandler implements TriggerInterface
{

    public static boolean firstTgrRun = true;
        
    public Boolean isActive()
    {
        try {
            return Trigger_Manager__c.getInstance('QuoteTgr').Is_Active__c;
        } catch (Exception e) {
            ExceptionHandler.postToAll(e);
            throw new CustomException(ExceptionHandler.getBody(e));
        }
        
    }
 
    public void beforeInsert() {}
    
    public void beforeUpdate() {
        try {
            
            Map<Id, Quote__c> oppToQuoteMap = new Map<id, Quote__c>();
            
            Set<Id> opportunityIds = new Set<ID>();
            for (Quote__c q : (List<Quote__c>) Trigger.new) {
                if (q.Is_Primary__c) {
                    opportunityIds.add(q.Opportunity__c);
                }
            }
            
            if (opportunityIds.size() > 0) {
                List<Quote__c> quotes = [Select Id, Name,Is_Primary__c from Quote__c where Is_Primary__c = true AND Opportunity__c in :opportunityIds and ID NOT IN :Trigger.newMap.keyset()];
                
                for (Quote__c q: quotes) {
                    System.debug('quote: ' + quote.Name);
                    q.Is_Primary__c = false;
                }
                update quotes;
            } 
        } catch (Exception e) {
            ExceptionHandler.postToAll(e);
            throw new CustomException(ExceptionHandler.getBody(e));
        }
    }
    
    public void beforeDelete() {}
 
    /************************************************************************************************************************************
     * If the Opportunity Stage is lower than stage 3 and a quote is created, a trigger must update the stage to stage 3. 
     * Stages of Closed Lost and Status Nurture should be an exception. If either of these are the stage, do not change the stage to stage 3.
     * and then of course, if the stage is higher than stage 3, do not move it back down to stage 3. 
     ************************************************************************************************************************************/
    public void afterInsert() 
    {
        List<Quote__c> quoteList = (List<Quote__c>)Trigger.New;
        //List<Opportunity> updatedOpps = new List<Opportunity>();
        //set<Opportunity> oppSet = new set<Opportunity>();
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        try
        {
            for (Quote__c qo : quoteList)
            {
               if (qo.OppStatus__c != 'Nurture')
               {
                   if (qo.OppStage__c == 'Stage 1 - Planning & Identification' || 
                       qo.OppStage__c == 'Stage 2 - Opportunity Development')
                   {
                       //updatedOpps.add(new Opportunity(Id = qo.Opportunity__c, StageName = 'Stage 3 - Proposal & Quote'));
                       //oppSet.add(new Opportunity(Id = qo.Opportunity__c, StageName = 'Stage 3 - Proposal & Quote'));
                       if(!oppMap.containsKey(qo.Opportunity__c))
                       {
                           oppMap.put(qo.Opportunity__c, new Opportunity(Id = qo.Opportunity__c, StageName = 'Stage 3 - Proposal & Quote'));
                       }
                       //updatedOpps.addAll(oppSet);
                   }   
               }
            }
        }
        catch (Exception e)
        {
            ExceptionHandler.postToAll(e);
            throw new CustomException(ExceptionHandler.getBody(e));
        }
        
        try 
        {
            if (oppMap.values().size() > 0)
            {
                update oppMap.values() ; 
            }  
        }
        catch (DmlException e)
        {
            ExceptionHandler.postToAll(e);
            throw new CustomException(ExceptionHandler.getBody(e));
        }
        
    }
 
    public void afterUpdate() {}
 
    public void afterDelete() {
        try {
            
        List<Quote__c> QuoteList = (List<Quote__c>)Trigger.old;
        DeleteUndeleteTriggerHandler.DeleteUndelete(QuoteList, 'Quote__c');
        } catch (Exception e)
        {
            ExceptionHandler.postToAll(e);
            throw new CustomException(ExceptionHandler.getBody(e));
        }
        
            
    }
 
    public void afterUndelete() {}
    
}