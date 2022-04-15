/**********************************************************************************

Author: Omkar Narkar
Description: This apex class is created for the QuoteLine trigger. SFDC-1306.

**********************************************************************************/

public class QuoteLineHelper{
    public static void calculateFocusAreaPercentage(List<Quote_Line__c> quoteLines){
        
        Set<Id> opportunityIds = new Set<Id>();
        Map<Id, Set<Id>> focusAreaQuoteLines = new Map<Id, Set<Id>>();
        List<Opp_FocusArea__c> deleteFocusAreaRecords = new List<Opp_FocusArea__c>();
        List<Opp_FocusArea__c> updateFocusAreaRecords = new List<Opp_FocusArea__c>();
        
        for(Quote_Line__c quoteLine : quoteLines){
            opportunityIds.add(quoteLine.Opportunity_Quote__c);
            if(Trigger.isUpdate){
                   opportunityIds.add(((Map<Id, Quote_Line__c>)Trigger.oldMap).get(quoteLine.Id).Opportunity_Quote__c);
            }
        }
        
        Map<Id, Opp_FocusArea__c> focusAreaMap = new Map<Id, Opp_FocusArea__c>([SELECT Id, Opportunity__c FROM Opp_FocusArea__c WHERE Opportunity__c   IN: opportunityIds]);
        for(Id focusAreaId : focusAreaMap.keySet()){
            focusAreaQuoteLines.put(focusAreaId, new Set<Id>());
        }
        Map<Id, Quote_Line__c> quoteLineMap = new Map<Id, Quote_Line__c>([SELECT Id, FocusArea__c, Opportunity_Quote__c, Final_MRR__c FROM Quote_Line__c WHERE Opportunity_Quote__c IN: opportunityIds]);
        Map<Id, Decimal> OpportunityMRR = new Map<Id, Decimal>();
        for(Quote_Line__c quoteLine : quoteLineMap.values()){
            if(!focusAreaQuoteLines.containsKey(quoteLine.FocusArea__c)){
                focusAreaQuoteLines.put(quoteLine.FocusArea__c, new Set<Id>());
            }
            focusAreaQuoteLines.get(quoteLine.FocusArea__c).add(quoteLine.Id);
            
            if(!OpportunityMRR.containsKey(quoteLine.Opportunity_Quote__c)){
                OpportunityMRR.put(quoteLine.Opportunity_Quote__c, 0);
            }
            if(quoteLine.Final_MRR__c != null)
                OpportunityMRR.put(quoteLine.Opportunity_Quote__c, OpportunityMRR.get(quoteLine.Opportunity_Quote__c) + quoteLine.Final_MRR__c);
            else
                OpportunityMRR.put(quoteLine.Opportunity_Quote__c, OpportunityMRR.get(quoteLine.Opportunity_Quote__c));
            
        }
        
        if(Trigger.isDelete){
            for(Quote_Line__c quoteLine : quoteLines){
                if(focusAreaQuoteLines.containsKey(quoteLine.FocusArea__c)){
                    focusAreaQuoteLines.get(quoteLine.FocusArea__c).remove(quoteLine.Id);
                }
            }
        }
        
        Map<Id, Integer> oppotunityPositiveFACount = new Map<Id, Integer>();
        Map<Id, Decimal> focusAreaMRRMap = new Map<Id, Decimal>();
        for(Id focusAreaId : focusAreaQuoteLines.keySet()){
            if(focusAreaQuoteLines.get(focusAreaId).isEmpty()){
                deleteFocusAreaRecords.add(new Opp_FocusArea__c(Id = focusAreaId));
            }
            else{
                if(focusAreaMap.containsKey(focusAreaId)){
                    Id oppId = focusAreaMap.get(focusAreaId).Opportunity__c;
                    Decimal TotalMRR = OpportunityMRR.get(oppId);
                    Decimal FocusAreaMRR = getFocusAreaMRR(focusAreaQuoteLines.get(focusAreaId), quoteLineMap);
                    if(!oppotunityPositiveFACount.containsKey(oppId)){
                        oppotunityPositiveFACount.put(oppId, 0);
                    }
                    if(FocusAreaMRR<0){
                        OpportunityMRR.put(oppId, TotalMRR-FocusAreaMRR);
                    }else{
                        oppotunityPositiveFACount.put(oppId, oppotunityPositiveFACount.get(oppId)+1);
                    }
                    focusAreaMRRMap.put(focusAreaId, FocusAreaMRR);
                }
            } 
        }
        
        for(Id focusAreaId : focusAreaMRRMap.keySet()){
            Id oppId = focusAreaMap.get(focusAreaId).Opportunity__c;
            Decimal TotalMRR = OpportunityMRR.get(oppId);
            Decimal FocusAreaMRR = focusAreaMRRMap.get(focusAreaId);
            Integer positiveFACount = oppotunityPositiveFACount.get(oppId);
            updateFocusAreaRecords.add(new Opp_FocusArea__c(Id = focusAreaId, 
                                                            Focus_Area_Percentage__c = calculatePercentage(TotalMRR, FocusAreaMRR, positiveFACount),
                                                            Bypass_Validation_Timestamp__c = System.now()
                                                           ));
        }
        CreateFocusAreaRecords.focusAreaFlag = false;
        if(!deleteFocusAreaRecords.isEmpty()){
            Database.delete(deleteFocusAreaRecords);
        }
        if(!updateFocusAreaRecords.isEmpty()){
            Database.update(updateFocusAreaRecords);
        }
        CreateFocusAreaRecords.focusAreaFlag = true;
       //Added by Sreeram for SFDC-3317
        OpportunityChildRecordUtility.updateFocusAreaOnOpp(opportunityIds);
    }
    
    public static Decimal getFocusAreaMRR(Set<Id> selectedQuoteLines, Map<Id, Quote_Line__c> quoteLineMap){
        Decimal focusAreaMRR = 0;
        for(Id quoteLineId : selectedQuoteLines){
            if(quoteLineMap.containsKey(quoteLineId) && quoteLineMap.get(quoteLineId).Final_MRR__c!= null){
                focusAreaMRR += quoteLineMap.get(quoteLineId).Final_MRR__c;
            }
        }
        return focusAreaMRR;
    }
    public static Decimal calculatePercentage(Decimal TotalMRR, Decimal FocusAreaMRR, Integer positiveFACount){
        if((TotalMRR == null || TotalMRR == 0) && positiveFACount > 0 && FocusAreaMRR >= 0){
            return 100/positiveFACount;
        }
        if(TotalMRR != null && TotalMRR > 0 && FocusAreaMRR > 0){
            return FocusAreaMRR / TotalMRR * 100;
        }
        return 0;
    }
}