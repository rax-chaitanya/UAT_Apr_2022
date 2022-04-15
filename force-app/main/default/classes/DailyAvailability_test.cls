@istest(SeeAllData=false)
public class DailyAvailability_test {
    public static TestMethod void testLiveTransfer(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.debug('==========  this USer '+thisUSer);
        set<Id> setrecordid=New Set<Id>();
        Trigger_Manager__c obj = new Trigger_Manager__c();
        obj.name = 'DailyAvailabilityTgr1';
        obj.Is_Active__c = true;
        insert obj;
        Queue__c testQueue = new Queue__c(Name='Test Queue',isActive__c=true);
        insert testQueue;      
        Queue_Member__c testQueueMember = new Queue_Member__c(Member__c=thisUser.Id,Queue__c=testQueue.Id,Active_Member__c=true);
        insert testQueueMember;
        List<Live_Transfer_Availability__c> testLiveTransfer = new List<Live_Transfer_Availability__c>();
        Live_Transfer_Availability__c livedata =new Live_Transfer_Availability__c(Available__c=true,Live_Transfer_Member__c=thisUser.id);
        insert livedata;     
        testLiveTransfer.add(new Live_Transfer_Availability__c(Id=livedata.id,Available__c=false));
        LiveTransferAvailabilityTime.LiveTransferAvailabilityTime(testLiveTransfer);
        update testLiveTransfer;
        Daily_Availability__c da = new Daily_Availability__c(Live_Transfer_Availability__c=livedata.Id);
        insert da;
        DailyAvailabiltyHelper.afterUpdate(new Set<Id>{da.Id});
    }
     public static TestMethod void testLiveTransfer1(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.debug('==========  this USer '+thisUSer);
        set<Id> setrecordid=New Set<Id>();
        Trigger_Manager__c obj = new Trigger_Manager__c();
        obj.name = 'DailyAvailabilityTgr1';
        obj.Is_Active__c = true;
        insert obj;
        Queue__c testQueue = new Queue__c(Name='Test Queue',isActive__c=true);
        insert testQueue;      
        Queue_Member__c testQueueMember = new Queue_Member__c(Member__c=thisUser.Id,Queue__c=testQueue.Id,Active_Member__c=true);
        insert testQueueMember;
        List<Live_Transfer_Availability__c> testLiveTransfer = new List<Live_Transfer_Availability__c>();
        Live_Transfer_Availability__c livedata =new Live_Transfer_Availability__c(Available__c=true,Live_Transfer_Member__c=thisUser.id);
        insert livedata;     
        testLiveTransfer.add(new Live_Transfer_Availability__c(Id=livedata.id,Available__c=false));
        LiveTransferAvailabilityTime.LiveTransferAvailabilityTime(testLiveTransfer);
        update testLiveTransfer;
        Daily_Availability__c da = new Daily_Availability__c(Live_Transfer_Availability__c=livedata.Id);
        insert da;
        DailyAvailabiltyHelper.UpdateCountTest = true;
        DailyAvailabiltyHelper.SameuserTest = false;
        DailyAvailabiltyHelper.afterUpdate(new Set<Id>{da.Id});
    }
     public static TestMethod void testLiveTransfer2(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.debug('==========  this USer '+thisUSer);
        set<Id> setrecordid=New Set<Id>();
        Trigger_Manager__c obj = new Trigger_Manager__c();
        obj.name = 'DailyAvailabilityTgr1';
        obj.Is_Active__c = true;
        insert obj;
        Queue__c testQueue = new Queue__c(Name='Test Queue',isActive__c=true);
        insert testQueue;      
        Queue_Member__c testQueueMember = new Queue_Member__c(Member__c=thisUser.Id,Queue__c=testQueue.Id,Active_Member__c=true);
        insert testQueueMember;
        List<Live_Transfer_Availability__c> testLiveTransfer = new List<Live_Transfer_Availability__c>();
        Live_Transfer_Availability__c livedata =new Live_Transfer_Availability__c(Available__c=true,Live_Transfer_Member__c=thisUser.id);
        insert livedata;     
        testLiveTransfer.add(new Live_Transfer_Availability__c(Id=livedata.id,Available__c=false));
        LiveTransferAvailabilityTime.LiveTransferAvailabilityTime(testLiveTransfer);
        update testLiveTransfer;
        Daily_Availability__c da = new Daily_Availability__c(Live_Transfer_Availability__c=livedata.Id);
        insert da;
        DailyAvailabiltyHelper.UpdateCountTest = false;
        DailyAvailabiltyHelper.secondrecordTest = true;
        DailyAvailabiltyHelper.afterUpdate(new Set<Id>{da.Id});
    }

 }