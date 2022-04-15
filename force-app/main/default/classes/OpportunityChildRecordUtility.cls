public without sharing class OpportunityChildRecordUtility{
    Public static Boolean OCR_UTIL=False;
    
    public static void updateOpportunityChildRecords(Set<Id> oppIds){
        //Disable child Triggers
        OpportunityFocusAreaHandler.IS_TRIGGER_ENABLED = False;
        OpportunitySplitHandler.IS_TRIGGER_ENABLED = False;
        
        //Update child records
        if(oppIds.size() > 0 && !Trigger.isInsert){
            Update [SELECT Id FROM Opp_FocusArea__c WHERE Opportunity__c IN: oppIds ];
            Update [SELECT Id FROM OpportunitySplit WHERE OpportunityId IN: oppIds ];
        }
        //Enable child triggers
        OpportunityFocusAreaHandler.IS_TRIGGER_ENABLED = True;
        OpportunitySplitHandler.IS_TRIGGER_ENABLED = True;
        OCR_UTIL=True;
    }
    
    //Added by Sreeram for SFDC-3317
    public static void updateFocusAreaOnOpp(Set<Id> oppIds) {
        
        List<Opportunity> opplist = [SELECT Id, Name, Skip_Validation__c ,(SELECT Id, Name, Opportunity__c FROM Focus_Areas__r ORDER BY Name) FROM Opportunity WHERE Id IN:oppIds];
            for(Opportunity opp:opplist)
        {
            String focusAreaValues = '';
            for(Opp_FocusArea__c focusArea:opp.Focus_Areas__r){
                if(String.isBlank(focusAreaValues)){
                    focusAreaValues = focusArea.Name;
                }Else
                {
                    focusAreaValues += ';'+focusArea.Name;
                }
            }
            opp.Focus_Area__c = focusAreaValues;
            opp.Skip_Validation__c = !opp.Skip_Validation__c;
        }
        
        OpportunityHandler.IS_TRIGGER_ENABLED = false;
        Update opplist;
        OpportunityHandler.IS_TRIGGER_ENABLED = true;

    }
}