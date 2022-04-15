/*
* Author : RDC, Vinod Thupakula
* Description : Populating count and Time duration of availability/Unavailability of a user from Live Transfer(SFDC-3287)
* Created Date : 6/June/2019 sss
* 
*/

trigger DailyAvailabilityTrigger on Daily_Availability__c (before insert, before update, before delete,
                              after insert, after update, after delete, after undelete) {                                  
 TriggerRouter.handler(new DailyAvailabilityHandler());                                 
    
}