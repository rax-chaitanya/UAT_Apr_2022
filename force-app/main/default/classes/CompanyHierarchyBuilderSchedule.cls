/************************************************************************************************************************************
 * Class Name : CompanyHierarchyBuilderSchedule
 * Author : Matthew Lamb
 * Creation Date : October 2015
 * Purpose : Separate scheduleable class to run the CompanyHierarchyBuilderBatch class on a repeating schedule.
 ************************************************************************************************************************************/

 global class CompanyHierarchyBuilderSchedule implements Schedulable {
	global void execute(SchedulableContext sc) {
		CompanyHierarchyBuilderBatch builderBatch = new CompanyHierarchyBuilderBatch();
		Database.executeBatch(builderBatch);
	}
}