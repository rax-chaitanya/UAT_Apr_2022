/*
* Name: CohortRectificationScheduler
* Created On: 1 Feb 2022
* Author: Mrinal Tripathi (mrinal.tripathi@rackspace.com)
* Description: Schedules CohortRectificationBatch
*/
global class CohortRectificationScheduler implements Schedulable{
	
    global void execute(SchedulableContext ctx) {
    
        Cohort_Calculation_Settings__c CS = Cohort_Calculation_Settings__c.getInstance();
        if(cs.is_active__c){
            CohortRectificationBatch batch = new CohortRectificationBatch();
            database.executebatch(batch,100);
           
        }
        
    }
}