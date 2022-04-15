@isTest 
public class LiveTransferComponent_Test {
    public static TestMethod void testMethod1(){
       
         LiveTransferComponent.getStatus();
        LiveTransferComponent.createUpdateLiveTransfer('Away');
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
         Queue__c testQueue = new Queue__c(Name='Test Queue',isActive__c=true);
        insert testQueue;
       Queue_Member__c testQueueMember = new Queue_Member__c(Member__c=thisUser.Id,Queue__c=testQueue.Id,Active_Member__c=true);
        insert testQueueMember;
        Live_Transfer_Availability__c testLiveTransfer=new Live_Transfer_Availability__c(Available__c=true,Live_Transfer_Member__c=thisUser.id);
        insert testLiveTransfer;
       // Live_Transfer_Availability__c test=[Select id,Available__c,Queue_Member__c From Live_Transfer_Availability__c];
        LiveTransferComponent.getStatus();
        LiveTransferComponent.createUpdateLiveTransfer('Away');
        List<Live_Transfer_Availability__c> listLive=new List<Live_Transfer_Availability__c>();
        for(Integer i=0;i<=99;i++)
            listLive.add(new Live_Transfer_Availability__c(Available__c=true,Live_Transfer_Member__c=thisUser.id));
        insert listLive;
        Map<Id,Live_Transfer_Availability__c> listMap=new Map<Id,Live_Transfer_Availability__c>([Select Id,Live_Transfer_Member__c,Available__c from Live_Transfer_Availability__c]);
       // LiveTransferHelper.makeUserActiveOrInactive(listMap.keySet());
        System.assert(listLive.size()>0);                  
    }
}