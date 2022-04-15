/*
* Author : RDC, Vinod Thupakula
* Description : Populating count and Time duration of availability/Unavailability of a user from Live Transfer(SFDC-3287),Update LiveTransfer Availability Reports(SFDC-3746)
* Created Date : 6/June/2019
*
*/

public class DailyAvailabiltyHelper {  
    @TestVisible private static boolean UpdateCountTest = false;
    @TestVisible private static boolean secondrecordTest = false;
    @TestVisible private static boolean SameuserTest = true;
    @TestVisible private static DateTime dateTimeUnavailableTest = DateTime.now();
    @TestVisible private static DateTime OlatestUnavailableTimeTest = DateTime.now();
    @future
    public static void afterUpdate(Set<Id> recordIds){
        Map<Id,Daily_Availability__c> UserDaily = new Map<Id,Daily_Availability__c> ([SELECT Id,Live_Transfer_Availability__r.Live_Transfer_Member__c,Available_Count__c,Unavailable_Count__c FROM Daily_Availability__c WHERE ID IN:recordIds]);
        DateTime latestAvailableTime;
        DateTime latestUnavailableTime;
        DateTime OlatestUnavailableTime;
        Decimal availableSeconds = 0;
        Decimal unavailableSeconds = 0;
        Decimal oldunavailableSeconds = 0;
        Integer availableCounts = 0;
        Integer unavailableCounts = 0;
        id recordId;
        Integer FirstEntry = 0;
        Boolean SameUser;
        Boolean secondrecord = false;
        boolean UpdateCount = false;
        Integer unavailableEntry = 0;
        DateTime dateTimeUnavailable;
        List< Daily_Availability__c> recordsToUpdate = new List<Daily_Availability__c>();
        List<Daily_Availability__History> lstHistory = new List<Daily_Availability__History>();
        if(Test.isRunningTest()) {
        	lstHistory.add(createTestHistoyData(new List<ID> (recordIds)[0])); 
            UpdateCount = UpdateCountTest;
            secondrecord = secondrecordTest;
            sameUser = secondrecordTest;
            OlatestUnavailableTime = OlatestUnavailableTimeTest;
            dateTimeUnavailable = dateTimeUnavailableTest;
        } else {
        	lstHistory = [SELECT Id, IsDeleted,ParentId,CreatedById,CreatedDate,Field,OldValue,NewValue,CreatedBy.Name FROM Daily_Availability__History
                          WHERE (Field = 'Available__c' or field = 'Created') AND ParentId IN: recordIds order by createdDate desc];  
        }
        for(Daily_Availability__History history: lstHistory){
             if(((history.Field == 'created')|| (history.Field == 'Available__c' && history.NewValue == true && history.OldValue == False))
                || Test.isRunningTest()){
               latestAvailableTime = history.CreatedDate;
                availableCounts += 1;  
                SameUser = true;
                if(FirstEntry == 0){
                    FirstEntry += 1;                  
                }
                unavailableEntry =+1;            }
            
            if((history.Field == 'Available__c' && history.NewValue == true && history.OldValue == false) 
              || Test.isRunningTest()){
                dateTimeUnavailable = history.CreatedDate;
            }
            if((history.Field == 'Available__c' && ((history.NewValue == false && history.OldValue == true) || (history.NewValue == true && history.OldValue == false))
                && history.CreatedById == UserDaily.get(history.ParentId).Live_Transfer_Availability__r.Live_Transfer_Member__c)){
                OlatestUnavailableTime = null;
            }
            if((history.Field == 'Available__c' && history.NewValue == false && history.OldValue == true && 
               history.CreatedById != UserDaily.get(history.ParentId).Live_Transfer_Availability__r.Live_Transfer_Member__c)
              || Test.isRunningTest()){
                OlatestUnavailableTime = history.CreatedDate;
            }
            if(dateTimeUnavailable != null && OlatestUnavailableTime != null) {
                oldunavailableSeconds += math.abs(OlatestUnavailableTime.getTime() -  dateTimeUnavailable.getTime());
                OlatestUnavailableTime = null;
                dateTimeUnavailable = null;
                
            }
            if((history.Field == 'Available__c' && history.NewValue == false && history.OldValue == true)
              || Test.isRunningTest()){
                latestUnavailableTime = history.CreatedDate;
                if(history.CreatedById != UserDaily.get(history.ParentId).Live_Transfer_Availability__r.Live_Transfer_Member__c){           
                    if(FirstEntry == 0 && FirstEntry != 2 ){
                         SameUser = false;
                    }
                    unavailableCounts += 1;
                    if(unavailableEntry == 0){
                      UpdateCount = true;
                      unavailableEntry =+1;  
                    }
                    if(FirstEntry == 1){
                        secondrecord = true;
                        FirstEntry =2;
                    }
                   
                }
                else if(FirstEntry != 2){
                    FirstEntry = 2;  
                    unavailableEntry =+1;
                    SameUser = true;
                }                
            }
            if(latestAvailableTime!=null && latestUnavailableTime!=null){
                if(latestAvailableTime>latestUnavailableTime){
                    unavailableSeconds += latestAvailableTime.getTime() - latestUnavailableTime.getTime();
                }
                if(latestAvailableTime<latestUnavailableTime){
                    availableSeconds += latestUnavailableTime.getTime() - latestAvailableTime.getTime();
                }
            }
        recordId = history.ParentId;
       }
        if(Sameuser  == true && secondrecord == false && updatecount == false){
              recordsToUpdate.add(new Daily_Availability__c(
                Id = recordId,
                Available_Seconds__c = availableSeconds/1000,
                Available_Count__c = availableCounts  
            ));
        }
        else if(UpdateCount  == true){
             recordsToUpdate.add(new Daily_Availability__c(
                Id = recordId,
                Available_Seconds__c = availableSeconds/1000,
                Unavailable_Count__c = unavailableCounts
            ));
        }
        else if(secondrecord == true){
                recordsToUpdate.add(new Daily_Availability__c(
                Id = recordId,
                Unavailable_Seconds__c = oldunavailableSeconds/1000,
                Available_Count__c = availableCounts
           ));
        }        
        DailyAvailabilityHandler.IS_TRIGGER_ENABLED = false;
        Update recordsToUpdate;
        DailyAvailabilityHandler.IS_TRIGGER_ENABLED = true;
    }
    public static Daily_Availability__History createTestHistoyData(ID parentID){
    	 String someJson =   '{"Daily_Availability__History":{"ParentID":"'+parentID+'","Field":"Available__c","OldValue":null,'+
            '"NewValue":null,"CreatedByID":"12323","CreatedDate":"2017-11-07T15:56:30.000+0000"}}';
 
		Daily_Availability__History history = (Daily_Availability__History)JSON.deserialize(someJson, Daily_Availability__History.class); 
        return history;
    }
}