/************************************************************************************************************************************
 * Class Name : CompanyFortuneRankSchedule
 * Author : Matthew Lamb
 * Creation Date : November 2015
 * Purpose : Separate scheduleable class to run the CompanyFortuneRankBatch class on a repeating schedule.
 ************************************************************************************************************************************/

 global class CompanyFortuneRankSchedule implements Schedulable {
	global void execute(SchedulableContext sc) {
		CompanyFortuneRankBatch fortuneBatch = new CompanyFortuneRankBatch();
		Database.executeBatch(fortuneBatch);
	}
}