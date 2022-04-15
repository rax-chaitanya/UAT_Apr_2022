@isTest(SeeAllData = true)
public class CommunityShareQueue_Test {
    
    private static testmethod void testMethod1() {    
        Lead ldRec = TestClassUtility.createLeads(1)[0];
        ldRec.AnnualRevenue = 1000;
                ldrec.LeadSource = 'Webinar';
                //insert ldRec;   
        Test.startTest();        
        CommunityShareQueue obj1 = new CommunityShareQueue(new List<sObject>{ldRec}, true);
        ID jobID = System.enqueueJob(obj1);
        //CommunityShareQueue obj2 = new CommunityShareQueue(new List<sObject>{ldRec}, false);
        //System.enqueueJob(obj2);
        Test.stopTest();
    }
    
    private static testmethod void testMethod2() {    
        Lead ldRec = TestClassUtility.createLeads(1)[0];
        ldRec.AnnualRevenue = 1000;
                ldrec.LeadSource = 'Webinar';
                insert ldRec;   
        Test.startTest();        
        CommunityShareQueue obj2 = new CommunityShareQueue(new List<sObject>{ldRec}, false);
        System.enqueueJob(obj2);
        Test.stopTest();
    }
    
    private static testmethod void testMethod3() {  
    String pId=[select id,name from Profile where name='Rackspace Seller-US' limit 1].id;
        
        User conuser = new User(firstname='Connection',Alias = 'standt', Email='selleruser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', group__c = 'APAC',
                                Region__c='US', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com', FederationIdentifier='test1111');
        insert conuser;
        Account acc= new Account();
        acc.name = 'Test';
        insert acc;  
        AccountTeamMember accTeamMem = new AccountTeamMember();
        accTeamMem.AccountId = acc.id;
        accTeamMem.userid=conuser.id;
        accTeamMem.teammemberrole='Sales Assistant';
        insert accTeamMem;  
        Test.startTest();        
        CommunityShareQueue obj2 = new CommunityShareQueue(new List<AccountTeamMember>{accTeamMem}, false);
        System.enqueueJob(obj2);
        Test.stopTest();
    }
    
    private static testmethod void testMethod4() {  
    String pId=[select id,name from Profile where name='Rackspace Seller-US' limit 1].id;
        
        User conuser = new User(firstname='Connection',Alias = 'standt', Email='selleruser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', group__c = 'APAC',
                                Region__c='US', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com', FederationIdentifier='test11222');
        insert conuser;
        Account acc= new Account();
        acc.name = 'Test';
        insert acc;  
        AccountTeamMember accTeamMem = new AccountTeamMember();
        accTeamMem.AccountId = acc.id;
        accTeamMem.userid=conuser.id;
        accTeamMem.teammemberrole='Sales Assistant';
        //insert accTeamMem;  
        Test.startTest();        
        CommunityShareQueue obj2 = new CommunityShareQueue(new List<AccountTeamMember>{accTeamMem}, true);
        System.enqueueJob(obj2);
        Test.stopTest();
    }
    
    private static testmethod void testMethod5() {  
    Lead ldRec = TestClassUtility.createLeads(1)[0];
        ldRec.AnnualRevenue = 1000;
                ldrec.LeadSource = 'Webinar';
                insert ldRec;
    String pId=[select id,name from Profile where name='Rackspace Seller-US' limit 1].id;
        
        User conuser = new User(firstname='Connection',Alias = 'standt', Email='selleruser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', group__c = 'APAC',
                                Region__c='US', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com', FederationIdentifier='test2222');
        insert conuser;
        Account acc= new Account();
        acc.name = 'Test';
        insert acc;  
        AccountTeamMember accTeamMem = new AccountTeamMember();
        accTeamMem.AccountId = acc.id;
        accTeamMem.userid=conuser.id;
        accTeamMem.teammemberrole='Sales Assistant';
        insert accTeamMem;  
        Test.startTest();        
        CommunityShareQueue obj2 = new CommunityShareQueue(new List<sObject>{ldRec}, new List<AccountTeamMember>{accTeamMem}, false);
        System.enqueueJob(obj2);
        Test.stopTest();
    }
    
    private static testmethod void testMethod6() {  
    Lead ldRec = TestClassUtility.createLeads(1)[0];
        ldRec.AnnualRevenue = 1000;
                ldrec.LeadSource = 'Webinar';
                //insert ldRec;
    String pId=[select id,name from Profile where name='Rackspace Seller-US' limit 1].id;
        
        User conuser = new User(firstname='Connection',Alias = 'standt', Email='selleruser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', group__c = 'APAC',
                                Region__c='US', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com', FederationIdentifier='test33333');
        insert conuser;
        Account acc= new Account();
        acc.name = 'Test';
        insert acc;  
        AccountTeamMember accTeamMem = new AccountTeamMember();
        accTeamMem.AccountId = acc.id;
        accTeamMem.userid=conuser.id;
        accTeamMem.teammemberrole='Sales Assistant';
        //insert accTeamMem;  
        Test.startTest();        
        CommunityShareQueue obj2 = new CommunityShareQueue(new List<sObject>{ldRec}, new List<AccountTeamMember>{accTeamMem}, true);
        System.enqueueJob(obj2);
        Test.stopTest();
    }
    
    private static testmethod void testMethod7() {  
    Lead ldRec = TestClassUtility.createLeads(1)[0];
        ldRec.AnnualRevenue = 1000;
                ldrec.LeadSource = 'Webinar';
                //insert ldRec;
    String pId=[select id,name from Profile where name='Rackspace Seller-US' limit 1].id;
        
        User conuser = new User(firstname='Connection',Alias = 'standt', Email='selleruser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', group__c = 'APAC',
                                Region__c='US', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com', FederationIdentifier='test44444');
        insert conuser;
        Account acc= new Account();
        acc.name = 'Test';
        insert acc;  
       /* Opportunity opp = new Opportunity();
        opp.name = 'Test';
        opp.StageName = 'Stage 1 - Planning & Identification';
        opp.CloseDate = System.today().addDays(20); */
        Id rtId1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Government').getRecordTypeId(); 
        Opportunity opp = new Opportunity(Name='Test Opportunity', DDI__c='12345655', StageName='Closed Won',recordtypeId=rtId1, CloseDate=System.today());
        insert opp;
        AccountTeamMember accTeamMem = new AccountTeamMember();
        accTeamMem.AccountId = acc.id;
        accTeamMem.userid=conuser.id;
        accTeamMem.teammemberrole='Sales Assistant';
        //insert accTeamMem;  
        OpportunityTeamMember otm = new OpportunityTeamMember (OpportunityId = opp.id,UserId = conuser.id,TeamMemberRole = 'role');
        Test.startTest();        
        CommunityShareQueue obj2 = new CommunityShareQueue(new List<sObject>{ldRec}, new List<AccountTeamMember>{accTeamMem}, new List<OpportunityTeamMember>{otm}, true);
        System.enqueueJob(obj2);
        Test.stopTest();
    }
    
    
    private static testmethod void testMethod8() {  
    Lead ldRec = TestClassUtility.createLeads(1)[0];
        ldRec.AnnualRevenue = 1000;
                ldrec.LeadSource = 'Webinar';
                insert ldRec;
    String pId=[select id,name from Profile where name='Rackspace Seller-US' limit 1].id;
        
        User conuser = new User(firstname='Connection',Alias = 'standt', Email='selleruser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', group__c = 'APAC',
                                Region__c='US', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com', FederationIdentifier='test55555');
        insert conuser;
        Account acc= new Account();
        acc.name = 'Test';
        insert acc;  
        //Opportunity opp = new Opportunity();
        Id rtId1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Government').getRecordTypeId(); 
        Opportunity opp = new Opportunity(Name='Test Opportunity', DDI__c='12345655', StageName='Closed Won',recordtypeId=rtId1, CloseDate=System.today());
        insert opp;
       
       /* opp.name = 'Test';
        opp.StageName = 'Stage 1 - Planning & Identification';
        opp.CloseDate = System.today().addDays(20); 
        insert opp; */
        AccountTeamMember accTeamMem = new AccountTeamMember();
        accTeamMem.AccountId = acc.id;
        accTeamMem.userid=conuser.id;
        accTeamMem.teammemberrole='Sales Assistant';
        insert accTeamMem;  
        OpportunityTeamMember otm = new OpportunityTeamMember (OpportunityId = opp.id,UserId = conuser.id,TeamMemberRole = 'role');
        insert otm;
        Test.startTest();        
        CommunityShareQueue obj2 = new CommunityShareQueue(new List<sObject>{ldRec}, new List<AccountTeamMember>{accTeamMem}, new List<OpportunityTeamMember>{otm}, false);
        System.enqueueJob(obj2);
        Test.stopTest();
    }
    
    private static testmethod void testMethod9() {  
    Lead ldRec = TestClassUtility.createLeads(1)[0];
        ldRec.AnnualRevenue = 1000;
                ldrec.LeadSource = 'Webinar';
                insert ldRec;
    String pId=[select id,name from Profile where name='Rackspace Seller-US' limit 1].id;
        
        User conuser = new User(firstname='Connection',Alias = 'standt', Email='selleruser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', group__c = 'APAC',
                                Region__c='US', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com', FederationIdentifier='test6666');
        //insert conuser;
        Account acc= new Account();
        acc.name = 'Test';
        insert acc;  
        Id rtId1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Government').getRecordTypeId(); 
        Opportunity opp = new Opportunity(Name='Test Opportunity', DDI__c='12345655', StageName='Closed Won',recordtypeId=rtId1, CloseDate=System.today());
        insert opp;
        
       /* Opportunity opp = new Opportunity();
        opp.name = 'Test';
        opp.StageName = 'Stage 1 - Planning & Identification';
        opp.CloseDate = System.today().addDays(20);
        insert opp; */
        AccountTeamMember accTeamMem = new AccountTeamMember();
        accTeamMem.AccountId = acc.id;
        accTeamMem.userid=conuser.id;
        accTeamMem.teammemberrole='Sales Assistant';
        //insert accTeamMem;  
        OpportunityTeamMember otm = new OpportunityTeamMember (OpportunityId = opp.id,UserId = conuser.id,TeamMemberRole = 'role');
        //insert otm;
        Test.startTest();        
        CommunityShareQueue obj2 = new CommunityShareQueue(new List<User>{conuser});
        System.enqueueJob(obj2);
        Test.stopTest();
    }
}