/**********************************************************************************

Author: Pradeep Guttha
Description: This apex class is created to Create Focus Area records upon the create action on Opportunity & Opp_FocusArea__c object. 

@changes - updated exception to ignore custom validation to not throw exception as this is already throwing validation
@dev- chaitanya
@date- APR 2022
@jira- SFDC-7331
@Test Class- CreateFocusAreaRecords_Test
**********************************************************************************/
public class CreateFocusAreaRecords {
    
    public static Boolean focusAreaFlag = true;
    
    //This method is being called from OpportunityHandler
    public static void OppFocusArea()
    {
        try {
            
            List<Opp_FocusArea__c> FocusAreaList = new List<Opp_FocusArea__c>();
            Map<Id, Opportunity> oppMap = (Map<Id, Opportunity>)Trigger.newMap;
            Map<Id, Boolean> oppwithQandQLVar = new Map<Id, Boolean>();
            List<Opportunity> oppList = New List<Opportunity>([Select id, (Select Id, Opportunity__c from Quotes__r),
                                                               (Select Id, Opportunity_Quote__c from Quote_Lines__r) 
                                                               from Opportunity where Id IN: Trigger.new]);
            for(opportunity oppRec : oppList){
                if(oppRec.Quotes__r.size() > 0 && oppRec.Quote_Lines__r.size() > 0){
                    oppwithQandQLVar.put(oppRec.Id, true);
                }else{
                    oppwithQandQLVar.put(oppRec.Id, false);
                }
            }
            
            Set<Id> oppIds = ((Map<Id, Opportunity>)Trigger.newMap).keySet();
            Set<Id> keepFAOppIds = new Set<Id>();
            Set<String> keepFAExtIds = new Set<String>();
            for(Opportunity opp : (List<Opportunity>)Trigger.new)
            {
                
                if(opp.Focus_Area__c != null && opp.Device_Count__c == 0 && focusAreaFlag && !oppwithQandQLVar.get(opp.Id)) {
                    string focusA = opp.Focus_Area__c.replaceAll('(\\s*)Customer Uncertain(\\;*(\\s*))', '');  //.remove('Customer Uncertain');
                    if (String.isNotBlank(focusA)) {
                        list<string> focusAreas = focusA.split(';');
                        
                        if (focusAreas.size() > 0) {
                            Decimal buf = 0.0;
                            for (Integer i = 0; i < focusAreas.size() - 1; ++i) {
                                Decimal equalValue = ((100.0 / focusAreas.size()).setScale(2));
                                buf += equalValue;
                                FocusAreaList.add(new Opp_FocusArea__c(
                                    Name = focusAreas[i], 
                                    Opportunity__c = Opp.id, 
                                    Focus_Area_Percentage__c = equalValue,
                                    FA_OppExtId__c = opp.id+'_'+focusAreas[i]
                                ));
                            }
                            FocusAreaList.add(new Opp_FocusArea__c(
                                Name = focusAreas[focusAreas.size() - 1], 
                                Opportunity__c = opp.id, 
                                Focus_Area_Percentage__c = (100.0  - buf),
                                FA_OppExtId__c = opp.id+'_'+focusAreas[focusAreas.size() - 1]
                            ));
                        }
                    }
                    
                }         
            }
            for(Opp_FocusArea__c focusArea : FocusAreaList){
                keepFAExtIds.add(focusArea.FA_OppExtId__c);
                keepFAOppIds.add(focusArea.Opportunity__c);
            }
            Database.delete([SELECT Id FROM Opp_FocusArea__c WHERE Opportunity__c IN: keepFAOppIds AND FA_OppExtId__c NOT IN: keepFAExtIds]);
            Database.upsert(FocusAreaList, Opp_FocusArea__c.fields.FA_OppExtId__c, true);
        } catch (Exception e) { //SFDC-7331 to remove validation thrown in exception
            if( system.isBatch() == false){
                ExceptionHandler.postToAll(e, false);
                //SFDC-7331 Added check for FIELD_CUSTOM_VALIDATION_EXCEPTION 
                String errorMsg = e.getMessage();
                if(!errorMsg.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                 throw new CustomException(e);
                }
            } 
   
            
            
            
        }
    }        
    //This method is being called from OpportunityFocusAreaHandler
    public static void FocusArea()
    {
        for(Opp_FocusArea__c fa : (List<Opp_FocusArea__c>)Trigger.new)
        {
            fa.FA_OppExtId__c = fa.Opportunity__c+'_'+fa.Name;       
        }
    }
    
}