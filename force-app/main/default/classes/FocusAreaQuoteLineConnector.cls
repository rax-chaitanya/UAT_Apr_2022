public class FocusAreaQuoteLineConnector {
    
    public static void RelateQLToFocusArea()
    {
        try {         
            Map<String, Opp_FocusArea__c> faMap = new Map<String, Opp_FocusArea__c>();
            for(Quote_Line__c ql : (List<Quote_Line__c>)Trigger.new)
            {
                Opp_FocusArea__c fa = new Opp_FocusArea__c(FA_OppExtId__c = returnFAExtId(ql));
                fa.Opportunity__c = ql.Opportunity_Quote__c;
                fa.Name = returnFAExtId(ql).mid(19,returnFAExtId(ql).length());
                faMap.put(fa.FA_OppExtId__c, fa); 
                
                //ql.FocusArea__r = fa;                    
            }
            if(faMap.values().size() > 0)
            {
                CreateFocusAreaRecords.focusAreaFlag = false;
                Upsert faMap.values() FA_OppExtId__c;
                CreateFocusAreaRecords.focusAreaFlag = true;
                
                for(Quote_Line__c ql : (List<Quote_Line__c>)Trigger.new)
                {
                    //if(String.isNotBlank(ql.Focus_Area__c))
                    ql.FocusArea__c = faMap.get(returnFAExtId(ql)).Id; 
                    System.debug('****** Focus_Area ' + ql.Focus_Area__c);        
                }
            } 
        }catch (Exception e) {
            ExceptionHandler.postToAll(e, true);
        }
    }
    
    public Static String returnFAExtId(Quote_Line__c ql)
    {
        try {
            String s = '';
            
            System.debug('**** Workload_Platform'+  ql.Workload_Platform__c);
            
            if(ql.Workload_Platform__c == 'Microsoft Private')
            {
                s = ql.Opportunity_Quote__c+'_'+FocusAreaMapping__c.getInstance('Microsoft Private').OppFocusArea__c;
            }
            else if(ql.Workload_Platform__c == 'Fanatical Support for Microsoft Azure')
            {
                s = ql.Opportunity_Quote__c+'_'+FocusAreaMapping__c.getInstance('Microsoft Public').OppFocusArea__c;
            }
            else if(ql.Workload_Platform__c == 'OpenStack Private')
            {
                s = ql.Opportunity_Quote__c+'_'+FocusAreaMapping__c.getInstance('OpenStack Private').OppFocusArea__c;
            }
            else if(ql.Workload_Platform__c == 'OpenStack Public')
            {
                s = ql.Opportunity_Quote__c+'_'+FocusAreaMapping__c.getInstance('OpenStack Public').OppFocusArea__c;
            }          
            else
            {    
                System.debug(' Focus_Area '+ ql.Focus_Area__c);
                
                if(String.isNotBlank(ql.Focus_Area__c) && FocusAreaMapping__c.getInstance(ql.Focus_Area__c) != null) 
                {
                    s = ql.Opportunity_Quote__c+'_'+FocusAreaMapping__c.getInstance(ql.Focus_Area__c).OppFocusArea__c;
                    System.debug('**** string s FocusArea Not blank' + s);
                }
                else
                {
                    s = ql.Opportunity_Quote__c+'_'+FocusAreaMapping__c.getInstance('Not Applicable').OppFocusArea__c;
                    System.debug('**** string s FocusArea blank' + s);   
                }         
            } 
            
            return s;
        }
        catch (Exception e) {
            ExceptionHandler.postToAll(e);
            throw new CustomException(ExceptionHandler.getBody(e));        
        }
    }
}