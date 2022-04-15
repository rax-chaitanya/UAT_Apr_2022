/**
* Author: Vinod Thupakula
* Description : Test class for the business logic classes - QueueMemberHandler,QueueMemberHelper 
*/
@isTest
public class QueueMemberTriggerTest{
    
    @testSetup static void setupTestData() {
        insert new Trigger_Manager__c(Name = 'QueueMemberTgr', Is_Active__c = true);        
    }
    
    @isTest private static void assignRanksTest(){
        Queue__c q = new Queue__c(Name = 'US SMB', Classification__c = 'US');
        insert q;
        Queue_Member__c qm = new Queue_Member__c(Queue__c = q.Id, Member__c = Userinfo.getUserId());
        insert qm;
        system.assertEquals(true,qm.Id != null);
        update qm;
        delete qm;
        undelete qm;
    }
}