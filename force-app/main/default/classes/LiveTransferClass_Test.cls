@isTest 
public class LiveTransferClass_Test {
    
    public static TestMethod void testLiveTransferClass()
    {
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        
        
        
        Queue__c testQueue = new Queue__c(Name='Test Queue',isActive__c=true);
        insert testQueue;
        Queue_Member__c testQueueMember = new Queue_Member__c(Member__c=thisUser.Id,Queue__c=testQueue.Id,Active_Member__c=true);
        insert testQueueMember;
        Live_Transfer_Availability__c testLiveTransfer=new Live_Transfer_Availability__c(Available__c=true,Live_Transfer_Member__c=thisUser.Id);
        insert testLiveTransfer;
        LiveTransferClass.EachUser eac=new LiveTransferClass.EachUser(testQueueMember.Member__c,testQueueMember.Member__r.name, testQueueMember.Member__r.Email,testQueueMember.Member__r.Phone);
        
        LiveTransferClass.getUsers(testQueue.Id, 1);
        Lead testLead=new Lead(Lastname='TestLead',Phone='636556888',
                               Email='hggfg@gmail.com',Status='New',Lead_Type__c='AWS',LeadSource='Chat',Company='TestAcc');
        insert testLead;
        LiveTransferClass.updateUserStatus(thisUser.Id);
        LiveTransferClass.updateOwner(testLead.Id,thisUser.Id,testQueue.Id);
        Lead l=new lead();
        User u=new User();
        Queue__c q=new Queue__c();
        try{
            LiveTransferClass.updateOwner(l.Id,u.Id,q.Id);
        }Catch(Exception e){
        }
        
        
        
    }
    
}