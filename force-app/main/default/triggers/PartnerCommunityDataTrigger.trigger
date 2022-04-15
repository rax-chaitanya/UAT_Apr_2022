/**********************************************************************************
Author: Ashok Cherapalli
Description: Trigger on which will call the PartnerCommunityDataHandler on all events.
**********************************************************************************/
trigger PartnerCommunityDataTrigger on Partner_Community_Data__c(before insert, before update, before delete,
                                                                 after insert, after update, after delete, after undelete) {
                                                                     
                                                                     TriggerRouter.handler(new PartnerCommunityDataHandler());
                                                                 }