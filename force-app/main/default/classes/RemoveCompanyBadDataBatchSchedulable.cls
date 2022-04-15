/************************************************************************************************************************************
 * Class Name : RemoveCompanyBadDataBatchSchedulable
 * Author : Shantan Nagulapalli
 * Creation Date : Feb 2016
 * Purpose : To Schedule RemoveCompanyBadDataBatch class
 ************************************************************************************************************************************/

global class RemoveCompanyBadDataBatchSchedulable implements Schedulable {
	global void execute(SchedulableContext sc) {
		RemoveCompanyBadDataBatch  b = new RemoveCompanyBadDataBatch ();
		database.executebatch(b, 200);
	}
}