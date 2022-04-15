trigger DummyFA on Opp_FocusArea__c (before insert,before update) {

 for(Opp_FocusArea__c ofa: Trigger.New)
 {
   ofa.FA_OppExtId__c = ofa.Opportunity__c+'_'+ofa.Name; 
 }

}