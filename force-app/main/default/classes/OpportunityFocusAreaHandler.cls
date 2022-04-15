/**********************************************************************************

Author: Shantan Nagulapalli
Description: This apex class is created for the Trigger Framework. This class 
controls the flow of execution of the trigger.

**********************************************************************************/

public class OpportunityFocusAreaHandler implements TriggerInterface
{ 
    public static Boolean IS_TRIGGER_ENABLED = true;
    public static boolean firstTgrRun = true;
    public static string stopRecursion = 'Before Update';
        
    public Boolean isActive()
    {
        return IS_TRIGGER_ENABLED && Trigger_Manager__c.getInstance('OpportunityFocusAreaTgr').Is_Active__c;
    }
 
    public void beforeInsert() 
    {
        CreateFocusAreaRecords.FocusArea();
        
        for (Opp_FocusArea__c fa : (List<Opp_FocusArea__c>) Trigger.new) {
            if (fa.Currency_Mismatch__c) {
                fa.CurrencyIsoCode = fa.OppCurrencyIsoCode__c;
            }
        }
    }
 
    public void beforeUpdate() {
        if(stopRecursion == 'Before Update'){
            stopRecursion = 'After Update'; 
        for (Opp_FocusArea__c fa : (List<Opp_FocusArea__c>) Trigger.new) {
            if (fa.Currency_Mismatch__c) {
                fa.CurrencyIsoCode = fa.OppCurrencyIsoCode__c;
            }
        }
        }
    }
    
    public void beforeDelete() {}
     
    public void afterInsert()  {
        
        try{
            if(opportunityHandler.firstTgrRun == true){
                  updateOppForHighLowMargin((List<Opp_FocusArea__c>)Trigger.new);
            }
        } catch(Exception ex){
            system.debug('Exception in HighLowMarginTriggerHandler.focusAreaTrigger'+ex.getMessage());
        }
    }
    
    public void afterUpdate() {
        
        try{
            if(opportunityHandler.firstTgrRun == true){
                updateOppForHighLowMargin((List<Opp_FocusArea__c>)Trigger.new);   
            }
        } catch(Exception ex){
            system.debug('Exception in HighLowMarginTriggerHandler.focusAreaTrigger'+ex.getMessage());
        }    
    }
    
    public void afterDelete() {
        List<Opp_FocusArea__c> OppFocusAreaList = (List<Opp_FocusArea__c>)Trigger.old;
        DeleteUndeleteTriggerHandler.DeleteUndelete(OppFocusAreaList, 'Opp_FocusArea__c');
        try{
            if(opportunityHandler.firstTgrRun == true){
                updateOppForHighLowMargin((List<Opp_FocusArea__c>)Trigger.new);   
            }
        } catch(Exception ex){
            system.debug('Exception in HighLowMarginTriggerHandler.focusAreaTrigger'+ex.getMessage());
        }
    }
    
    public void afterUndelete() {
        
        try{
            if(opportunityHandler.firstTgrRun == true){
                updateOppForHighLowMargin((List<Opp_FocusArea__c>)Trigger.new);   
            }
        } catch(Exception ex){
            system.debug('Exception in HighLowMarginTriggerHandler.focusAreaTrigger'+ex.getMessage());
        }
    }
    
    
    public void updateOppForHighLowMargin(List<Opp_FocusArea__c> OppFocusAreaList){
        
         //List<Opp_FocusArea__c> OppFocusAreaList = (List<Opp_FocusArea__c>)Trigger.new;
        //List<Opp_FocusArea__c> newOppFocusAreaList = [select Id,Focus_Area_Total__c,Opportunity__c from Opp_FocusArea__c where id =: OppFocusAreaList[0].Id];
        opportunityHandler.firstTgrRun = false;
        Map<String,Map<String, Decimal>> totalMap =  HighLowMarginTriggerHandler.setBookingTotalFieldOnOpportunity(OppFocusAreaList[0].Opportunity__c);  
        if(totalMap.get(OppFocusAreaList[0].Opportunity__c ) != null){
        	List<Opportunity> oppList = [SELECT Id, Booking_Total__c, Commission_Booking_Total__c FROM Opportunity WHERE Id=:OppFocusAreaList[0].Opportunity__c ];
            oppList[0].Booking_Total__c = totalMap.get(OppFocusAreaList[0].Opportunity__c ).get('bookingTotal');
            oppList[0].Commission_Booking_Total__c = totalMap.get(OppFocusAreaList[0].Opportunity__c ).get('cbBookingTotal');
            update OppList;    
        }
              
	}
    
}