public class AccountRealignmentRequestHelper{
  public static void handleStatusChange(){
        Map<Id, Account_Realignment_Request__c> requestMap = new Map<Id, Account_Realignment_Request__c>();
        Map<Id, Account_Realignment_Request__c> oldMap = (Map<Id, Account_Realignment_Request__c>)Trigger.oldMap;
        for(Account_Realignment_Request__c request : (List<Account_Realignment_Request__c>)Trigger.new){
            Account_Realignment_Request__c oldRequest = ((Map<Id, Account_Realignment_Request__c>)Trigger.oldMap).get(request.Id);
            if((request.Status__c == 'Approved' || request.Status__c == 'Auto Approved' || request.Status__c == 'Rejected') && (oldRequest.Status__c != 'Approved' && oldRequest.Status__c != 'Auto Approved' && request.Status__c != 'Rejected')){
                request.Actual_Approver__c = UserInfo.getUserId();
                request.Approval_date__c = System.today();
            }
            requestMap.put(request.Id, request);
        }
        if(!requestMap.isEmpty()){
            List<Realignment_Request_Item__c> requestItems = [SELECT Id, Request_Status__c, Account_Realignment_Request__c, Account__r.Name, 
                                                              Account__r.Account_Number__c, Previous_Account_Owner__r.Name, New_Account_Owner__r.Name 
                                                              FROM Realignment_Request_Item__c WHERE Account_Realignment_Request__c IN: requestMap.keySet()];
            if(!requestItems.isEmpty()){
                for(Realignment_Request_Item__c item : requestItems){
                    if(item.Request_Status__c != 'Rejected'){
                        item.Request_Status__c = requestMap.get(item.Account_Realignment_Request__c).Status__c;
                        item.Approved__c = requestMap.get(item.Account_Realignment_Request__c).Status__c == 'Approved' || requestMap.get(item.Account_Realignment_Request__c).Status__c == 'Auto Approved';
                    }
                }
               //Sfdc-6892 due to cpu time issue we modifed the code in to 2 ways one is sync and asyn 
                //Added By Sundarayya E
                // if the processing records are less than 100 it will enter to sync
                if(requestItems.size() < 100){
                    Database.update(requestItems);
                }else{
                    // if processing records are more than 100 it will execute batch class and process the records.
                    //RealignmentRequestBatch batch1 = new RealignmentRequestBatch();
                    Database.executeBatch(new RealignmentRequestBatch(requestItems, false), 5);
                }
                //sfdc-6892 ends
                
            }
        }
    }
}