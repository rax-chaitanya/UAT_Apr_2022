@isTest
public class LiveTransferStatusUpdateBatch_Test {

    
    @isTest
    static void testUpdate(){

         Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' limit 1];
        user adminUser = new User(
            ProfileId = adminProfile.Id,
            LastName = 'testAdminUser123',
            Email = 'puser000@amamama.com',
            Username = 'adminuser@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
           // UserRoleId = SARole.Id,
            Region__c = 'US',
            Group__c = 'US Other'
        );
        Insert adminUser;
        System.runAs(adminUser){
            Queue__c testQueue = new Queue__c(Name='Test Queue',isActive__c=true);
            insert testQueue;
            Queue_Member__c testQueueMember = new Queue_Member__c(Member__c=adminUser.Id,Queue__c=testQueue.Id,Active_Member__c=true);
            insert testQueueMember;
            Live_Transfer_Availability__c testLiveTransfer=new Live_Transfer_Availability__c(Available__c=true,Live_Transfer_Member__c=adminUser.Id);
            insert testLiveTransfer;
            
            Test.startTest();
            String jobId = System.schedule('NotifyUnconvertedLeadBatchTest', '0 0 0/2 1/1 * ? *', new LiveTransferStatusUpdateBatch());
            Test.stopTest();
        }
    }
}