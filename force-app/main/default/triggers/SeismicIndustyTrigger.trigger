/**********************************************************************************

Author: Vinod Thupakula
Description: Trigger on Seismic_Industry_Mapping__c which will call the SeismicIndustyHandler using the TriggerRouter 
on the following events: before insert, before update, before delete, after insert, after update,
 after delete, after undelete.

**********************************************************************************/
trigger SeismicIndustyTrigger on Seismic_Industry_Mapping__c (before insert, before update, before delete,
                              after insert, after update, after delete, after undelete) 
{
    TriggerRouter.handler(new SeismicIndustyHandler());
}