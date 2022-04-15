/*
* Author : RDC, Vinod Thupakula
* Description : Populating count and Time duration of availability/Unavailability of a user from Live Transfer(SFDC-3287)
* Created Date : 6/June/2019 
* 
*/
public class LiveTransferAvailabilityTime {
    
    @InvocableMethod(label='LiveTransferAvailabilityTime' description='Upsert the records based on timeline')
    public static void LiveTransferAvailabilityTime(List<Live_Transfer_Availability__c> newRecords){
        Set<Id> ids = new Set<Id>();  
        Map<Id,Daily_Availability__c> oldRecords = new Map<Id,Daily_Availability__c>();
        List<Daily_Availability__c> records = new list<Daily_Availability__c>();
        for(Live_Transfer_Availability__c availability : newRecords){
            ids.add(availability.Id);            
        }  
        for(Daily_Availability__c da : [SELECT Id,Live_Transfer_Availability__c FROM Daily_Availability__c where Live_Transfer_Availability__c IN: ids AND Availability_Date__c=:System.today()]){
            oldRecords.put(da.Live_Transfer_Availability__c,da);
        }
        for(Live_Transfer_Availability__c availability : newRecords){
            if(oldRecords.containsKey(availability.Id)){
                Daily_Availability__c editRecord =oldRecords.get(availability.Id); 
                editRecord.Available__c = availability.Available__c;
                editRecord.Availability_Date__c = System.today();
                records.add(editRecord);
            }
            else{
                Daily_Availability__c newRecord = new Daily_Availability__c();
                newRecord.Available__c = availability.Available__c;
                newRecord.Available_Count__c=1;
                newRecord.Availability_Date__c = System.today();
                newRecord.Live_Transfer_Availability__c=availability.Id;
                records.add(newRecord);
            }
        }
        if(!records.isEmpty()) upsert records;
    }   
}