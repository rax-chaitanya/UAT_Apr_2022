/**
* File : LeadAssignmentHelperTest.cls
* Description : Test class for the business logic class - LeadAssignmentHelper
* Created Date : 23/APR/2018
* @author : RDC (JY)
*/
@isTest
public with sharing class LeadAssignmentHelperTest {
    
    @testSetup static void setupTestData() {
        
        UserRole SARole = [Select Id,Name from UserRole Where Name LIKE '%US SA%' LIMIT 1];
        
        user adminUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'testAdminUser12343',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias1',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = SARole.Id
        );
        Insert adminUser;
        
        
        User testUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'testAdminUser123',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com1' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = SARole.Id,
            ManagerId= adminUser.Id
        );
        
        Insert testUser;
        System.runAs(testUser){
            Trigger_Manager__c tm = new Trigger_Manager__c(Name = 'LeadTgr', Is_Active__c = true);
            insert tm;
            List<Lead> leads = createLeads(testUser.Id,10, 'userxyz', 'testxyz', 'New', 'dummy', '8887776660', 'Amazon', 'AWS', 'United States', 'Texas', 'Chat', 'TestDummy Inc');
            insert Leads;
            List<Queue__c> queues = createQueues(2, 'US SMB ', 'US');
            insert queues;
            List<Queue__c> queuesWithAutoAssignment = createQueuesWithAutoAssignment(2, 'US AUTO ', 'US');
            insert queuesWithAutoAssignment;
            List<Lead> leadsWithQueue = createLeadsWithOriginalQueue(testUser.Id,10, 'userxyzwithQueue', 'testxyzwithQueue', 'New', 'dummywithQueue', '8887776660', 'Amazon', 'AWS', 'United States', 'Texas', 'Chat', 'TestDummy IncwithQueue',queuesWithAutoAssignment.get(0).Id);
            insert leadsWithQueue;
            List<Queue__c> queuesINTL = createQueues(2, 'UK SMB ', 'INTL');
            insert queuesINTL;
            List<User> members = new List<User>();
            members = [SELECT Id FROM User WHERE isActive = true AND Profile.Name IN ('Rackspace Seller-US', 'Rackspace Seller-INTL') ORDER BY Name LIMIT 3];
            List<Queue_Member__c> qMembers = new List<Queue_Member__c>(); 
            for(Queue__c q : queues) {
                qMembers.addAll(createQueueMembers(q.Id, members));
            }
            for(Queue__c q : queuesINTL) {
                qMembers.addAll(createQueueMembers(q.Id, members));
            }
            for(Queue__c q : queuesWithAutoAssignment) {
                qMembers.addAll(createQueueMembers(q.Id, members));
            }
            insert qMembers;
        }
    }
    
    public static List<Lead> createLeads(String owner,Integer count, String ln, String fn, String status, String email, String phone, String fa, String lt, String country, String state, String ls, String cmp) {
        List<Lead> leads = new List<Lead>();
        for(Integer i=1; i<=count; i++) {
            leads.add(new Lead(OwnerId=owner,FirstName = fn+i, lastName = ln+i,Status = status, Email = fn + ln + email + i + '@rackspace.com.test',
                               Phone = phone, Focus_Area__c = fa, Lead_Type__c = lt, Country = country, State = state, LeadSource = ls, Company = cmp));
        }
        return leads;
    }
    
    public static List<Lead> createLeadsWithOriginalQueue(String owner,Integer count, String ln, String fn, String status, String email, String phone, String fa, String lt, String country, String state, String ls, String cmp, String queue) {
        List<Lead> leads = new List<Lead>();
        for(Integer i=1; i<=count; i++) {
            leads.add(new Lead(OwnerId=owner,FirstName = fn+i, lastName = ln+i,Status = status, Email = fn + ln + email + i + '@rackspace.com.test',
                               Phone = phone, Focus_Area__c = fa, Lead_Type__c = lt, Country = country, State = state, LeadSource = ls, Company = cmp,Original_Queue__c=queue));
        }
        return leads;
    }
    public static List<Queue__c> createQueuesWithAutoAssignment(Integer count, String qName, String cls) {
        List<Queue__c> queues = new List<Queue__c>();
        for(Integer i=1; i<=count; i++) {
            queues.add(new Queue__c(Name = qName + i, Classification__c = cls, Auto_Assign_Leads__c =true));
        }
        return queues;
    }
    
    public static List<Queue__c> createQueues(Integer count, String qName, String cls) {
        List<Queue__c> queues = new List<Queue__c>();
        for(Integer i=1; i<=count; i++) {
            queues.add(new Queue__c(Name = qName + i, Classification__c = cls,Monthly_Reset_Rank__c=true));
        }
        return queues;
    }
    
    public static List<Queue_Member__c> createQueueMembers(Id qId, List<User> members) {
        List<Queue_Member__c> queueMembers = new List<Queue_Member__c>();
        for(User m : members) {
            queueMembers.add(new Queue_Member__c(Queue__c = qId, Member__c = m.Id));
        }
        return queueMembers;
    }
    
    @isTest
    static void testGetQueues() {
        LeadAssignmentApexController.getQueues();
    }
    
    @isTest
    static void testIsAuthorised() {
        LeadAssignmentApexController.isAuthorised();
    }
    
    @isTest
    static void testAssignLeads1() {
        List<Queue__c> queues = [SELECT Id FROM Queue__c LIMIT 2];
        List<Lead> leads = [SELECT Id FROM Lead LIMIT 10];
        if(!queues.isEmpty() && !leads.isEmpty()) {
            LeadAssignmentApexController.assignLeads(queues.get(0).Id, leads.get(0).Id);
        }
        List<Queue__c> queuesWithAutoAssignment = [Select Id,Auto_Assign_Leads__C From Queue__c Where Auto_Assign_Leads__C = true Limit 2];
        LIst<Lead> leadsWithQueues = [Select Id,Original_Queue__C From Lead Where Original_Queue__C!=null LIMIT 5];
        System.debug('queuesWithAutoAssignment'+queuesWithAutoAssignment);
        System.debug('leadsWithQueues'+leadsWithQueues);
        if(!queuesWithAutoAssignment.isEmpty() && !leadsWithQueues.isEmpty()){
            System.debug('calling');
            LeadAssignmentHelper.assignLeadsToQueueMembers(leadsWithQueues,null);
        }
    }
    
    @isTest
    static void testAssignLeads2() {
        user testuser = [SELECT Id, Name,ManagerId FROM User WHERE LastName = 'testAdminUser123' AND IsActive = true limit 1];
        List<Queue__c> queues = [SELECT Id FROM Queue__c LIMIT 1];
        List<Lead> leads = [SELECT Id FROM Lead LIMIT 1];
        System.runAs(testuser){
            if(!queues.isEmpty() && !leads.isEmpty()) {
                List<Queue_Member__c> members = [SELECT Id FROM Queue_Member__c WHERE Queue__c = :queues.get(0).Id];
                List<Queue_Member__c> membersToDelete = new List<Queue_Member__c>();
                for(Integer i=0; i < members.size(); i++) {
                    if(i != 0) {
                        membersToDelete.add(members.get(i));
                    }
                }
                if(!membersToDelete.isEmpty()) {
                    delete membersToDelete;
                }
                LeadAssignmentApexController.assignLeads(queues.get(0).Id, leads.get(0).Id);
                List<Lead> rejectedLead = [SELECT Id, Approval_Status__c, Previous_Status__c, Lead_Generator__c,
                                           Lead_Date_Passed__c, Q_Team_Member__c, Status, Reason__c,OwnerId
                                           FROM Lead WHERE Id = :leads.get(0).Id];
                
                if(!rejectedLead.isEmpty()) {
                    rejectedLead.get(0).Status = System.Label.LeadStatusUnQualifiedToLeadGen;
                    rejectedLead.get(0).Reason__c = 'Missing Key Info';
                    rejectedLead.get(0).Previous_Status__c = System.Label.LeadStatusUnQualifiedToLeadGen;
                    rejectedLead.get(0).Lead_Generator__c = UserInfo.getUserId();
                    rejectedLead.get(0).Q_Team_Member__c = UserInfo.getUserId();
                    rejectedLead.get(0).Lead_Date_Passed__c = System.Now();
                    rejectedLead.get(0).OwnerId = testuser.Id;                       
                    update rejectedLead;
                    rejectedLead = [SELECT Id, Approval_Status__c, Previous_Status__c, Lead_Generator__c,
                                    Lead_Date_Passed__c, Q_Team_Member__c, Status, Reason__c
                                    FROM Lead WHERE Id = :leads.get(0).Id];
                    rejectedLead.get(0).Approval_Status__c = System.Label.LeadRejectionApprovalStatus;
                    LeadAssignmentHelper.LeadAssignmentHelper_adjustCounters = TRUE;
                    update rejectedLead;
                }
            }
        }
    }
    
    @isTest
    static void testLeadCounterResetSchedulable() {
        Test.startTest();
        String schExp = '0 0 23 * * ?';
        System.schedule('Lead Counters Reset - ' + System.now().format(), schExp, new LeadCounterResetSchedulable());
        Test.StopTest();
    }
}