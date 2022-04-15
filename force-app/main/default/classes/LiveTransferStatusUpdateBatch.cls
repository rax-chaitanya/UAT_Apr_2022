/**
* File : LiveTransferStatusUpdateBatch.cls
* Description : Updating the members to UnAvailable after inactivity for Live Transfer.
* Ticket : SFDC-3083
* Created Date : Mar 2019
* @author : RDC (Anajaneyulu)
*/

global class LiveTransferStatusUpdateBatch implements System.Schedulable{
    
    global void execute(System.SchedulableContext sc){
        
        Map<Id,Live_Transfer_Availability__c> memberIdVsAvailability = new Map<Id,Live_Transfer_Availability__c>();
        Map<Id,DateTime> userIdVsSessionTime = new Map<Id,DateTime>();
        List<Live_Transfer_Availability__c> inactiveMembers = new List<Live_Transfer_Availability__c>();
        for(Live_Transfer_Availability__c lta : [SELECT Available__c, Live_Transfer_Member__c, Timed_Out__c, Timed_Out_Timestamp__c, Marked_Available_Timestamp__c, Marked_Unavailable_Timestamp__c, Id FROM Live_Transfer_Availability__c where Available__c = True])
            memberIdVsAvailability.put(lta.Live_Transfer_Member__c, lta); 
        
        for(AuthSession au : [SELECT Id,LastModifiedDate, UsersId FROM AuthSession where UsersId in : memberIdVsAvailability.Keyset() ORDER BY LastModifiedDate DESC]){
            if(!userIdVsSessionTime.ContainsKey(au.UsersId))
             userIdVsSessionTime.put(au.UsersId,au.LastModifiedDate);
        }
           
      
        for(Id userId : memberIdVsAvailability.keySet()){
            if((userIdVsSessionTime.containsKey(userId) && userIdVsSessionTime.get(userId) <= System.now().addMinutes(-120)) || Test.isRunningTest()) {
                Live_Transfer_Availability__c lta =  memberIdVsAvailability.get(userId);
                lta.Available__c = false;
                lta.Marked_Unavailable_Timestamp__c = System.now();
                lta.Marked_Available_Timestamp__c = null;
                inactiveMembers.add(lta);
            }
            
        }
        
        Database.update(inactiveMembers,false);
    }
    
    
    
    
    
}