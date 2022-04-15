/*
This trigger must be run only during Mriya Tool Data Migration. 
After the migration, this trigger must be deactivated. 
*/
trigger DataMigrationSupport_FA on Opp_FocusArea__c (before insert,before update) {

 for(Opp_FocusArea__c ofa: Trigger.New)
 {
   ofa.FA_OppExtId__c = ofa.Opportunity__c+'_'+ofa.Name; 
 }

}