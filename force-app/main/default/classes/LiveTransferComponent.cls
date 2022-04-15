public class LiveTransferComponent{

    @AuraEnabled
    public static Boolean getStatus(){
    List<Live_Transfer_Availability__c> listLiveTransfers=new List<Live_Transfer_Availability__c>();
    listLiveTransfers = [Select id, Available__c From Live_Transfer_Availability__c WHERE Live_Transfer_Member__c=:UserInfo.getUserId()];
    if(listLiveTransfers.isEmpty())
        return false;
       return listLiveTransfers[0].Available__c;
    }
    
    @AuraEnabled
    public static Result createUpdateLiveTransfer(String status){
    Result result = null;
    Set<id> lstIdsOfQueueMembersAll = new Set<id>();
    Map<Id, Id> mapOfQueueMemToQueues = new Map<Id, Id>();
    List<Live_Transfer_Availability__c> listLiveTransfers=new List<Live_Transfer_Availability__c>();    
    listLiveTransfers=[Select id, Available__c,Live_Transfer_Member__c,Marked_Available_Timestamp__c,Marked_Unavailable_Timestamp__c from Live_Transfer_Availability__c Where Live_Transfer_Member__c =:UserInfo.getUserId()]; // Modififed by Thirupathi Aeneni SFDC-2283
    List<Live_Transfer_Availability__c> lstOfLiveTransferAvail = new List<Live_Transfer_Availability__c>();
    
    for(Queue_Member__c eachQueueMem : [Select id, Queue__c,Member__c from Queue_Member__c where Member__c =:UserInfo.getUserId()]){
        lstIdsOfQueueMembersAll.add(eachQueueMem.id);
    }   
        
        
    if(lstIdsOfQueueMembersAll.isEmpty()){
    result = new Result(false, Label.Not_part_of_any_Queue);
    return result;
    }
    
    
    
    if(listLiveTransfers.isEmpty()){
        lstOfLiveTransferAvail.add(new Live_Transfer_Availability__c(Available__c = (status == 'Away')?false:true,
                                                                     Marked_Available_Timestamp__c = (status == 'Away')? null:System.now(),// Added By Thirupathi Aeneni for SFDC - 2823
                                                                     Marked_Unavailable_Timestamp__c = (status == 'Away')?System.now():null,// Added By Thirupathi Aeneni for SFDC - 2823
                                                                     Live_Transfer_Member__c=UserInfo.getUserId()));
    }else{
        lstOfLiveTransferAvail.add(new Live_Transfer_Availability__c(id= listLiveTransfers[0].id, Available__c = (status == 'Away')?false:true,
                                                                     Marked_Available_Timestamp__c = (status == 'Away')?listLiveTransfers[0].Marked_Available_Timestamp__c:System.now(),// Added By Thirupathi Aeneni for SFDC - 2823
                                                                     Marked_Unavailable_Timestamp__c = (status == 'Away')?System.now():listLiveTransfers[0].Marked_Unavailable_Timestamp__c));// Added By Thirupathi Aeneni for SFDC - 2823
    }
    
    try{
    Database.upsert(lstOfLiveTransferAvail, true);
    result = (status == 'Away')?new Result(true, Label.Live_Transfer_Unavailable):new Result(true, Label.Live_Transfer_Available);
   }catch(Exception e){
       
    result = new Result(false, 'Some Exception Occured');
    }
    return result;
    }
    
    public class Result{
     @AuraEnabled  public Boolean isSuccess;
     @AuraEnabled  Public String message;
     public Result(Boolean isSuccess, String message){
         this.isSuccess = isSuccess;
         this.message = message;
     }
    }
}