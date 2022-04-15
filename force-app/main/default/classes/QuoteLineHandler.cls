/**********************************************************************************

Author: Pradeep Guttha
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the trigger.

**********************************************************************************/

public class QuoteLineHandler implements TriggerInterface
{
  public static boolean firstTgrRun = true;
        
    public Boolean isActive()
    {
        return Trigger_Manager__c.getInstance('QuoteLineTgr').Is_Active__c;
    } 
    public void beforeInsert() {
        FocusAreaQuoteLineConnector.RelateQLToFocusArea();
    }
    
    public void beforeUpdate() {
        FocusAreaQuoteLineConnector.RelateQLToFocusArea();
    }
    
    public void beforeDelete() {}
 
    public void afterInsert()  {
        //FocusAreaQuoteLineConnector.RelateQLToFocusArea();
         
        //Added by Omkar - SFDC-1306
        QuoteLineHelper.calculateFocusAreaPercentage((List<Quote_Line__c>)Trigger.new);
        updateOppForHighLowMargin((List<Quote_Line__c>)Trigger.new);
    }
 
    public void afterUpdate() {
        //Added by Omkar - SFDC-1306
        QuoteLineHelper.calculateFocusAreaPercentage((List<Quote_Line__c>)Trigger.new);
        updateOppForHighLowMargin((List<Quote_Line__c>)Trigger.new);
      
    }
 
    public void afterDelete() {
        List<Quote_Line__c> QuoteLineList = (List<Quote_Line__c>)Trigger.old;
        DeleteUndeleteTriggerHandler.DeleteUndelete(QuoteLineList, 'Quote_Line__c');
        
        //Added by Omkar - SFDC-1306
        QuoteLineHelper.calculateFocusAreaPercentage(QuoteLineList);
        updateOppForHighLowMargin((List<Quote_Line__c>)Trigger.new);
    }
    
    public void afterUndelete() {
        updateOppForHighLowMargin((List<Quote_Line__c>)Trigger.new);
    }

    public void updateOppForHighLowMargin(List<Quote_Line__c> qlList){
        
        try{
            Map<String,Map<String, Decimal>> totalMap =  HighLowMarginTriggerHandler.setBookingTotalFieldOnOpportunity(qlList[0].Opportunity_Quote__c);  
            
            if(totalMap.get(qlList[0].Opportunity_Quote__c) != null){
           		List<Opportunity> oppList = [SELECT Id, Booking_Total__c, Commission_Booking_Total__c FROM Opportunity WHERE Id=:qlList[0].Opportunity_Quote__c ];
                oppList[0].Booking_Total__c = totalMap.get(qlList[0].Opportunity_Quote__c).get('bookingTotal');
                oppList[0].Commission_Booking_Total__c = totalMap.get(qlList[0].Opportunity_Quote__c).get('cbBookingTotal');
                update oppList;
            }
            
        } catch(Exception ex){
            system.debug('Exception in HighLowMarginTriggerHandler.quoteLineTrigger'+ex.getMessage());
        }
    }
    
}