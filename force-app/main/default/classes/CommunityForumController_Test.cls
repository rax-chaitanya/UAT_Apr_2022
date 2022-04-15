@isTest
public class CommunityForumController_Test {
    @testSetup
    public static void testSetup(){
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
            Region__c = 'US',
            Group__c = 'US Other'
        );
        Insert adminUser;
        
        System.runAs(adminUser){
            TestDataFactory.getOrgConstants();
            
            TestDataFactory.triggerManagerFlagValue  = false;
            List<Trigger_Manager__c> triggerManagers = TestDataFactory.getTriggerManagers();
            
            Gamification_Action_Points__c Gap = new Gamification_Action_Points__c(Name = 'Create Partner Lead',points__c = 2);
            Gamification_Action_Points__c Gap1 = new Gamification_Action_Points__c(Name = 'Create Subagent Company',points__c = 1);
            insert new List<Gamification_Action_Points__c>{Gap,Gap1};
                
                Id partnerAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
            Account partnerAccount = new Account(Name = 'Test Account',Partner_Level__c = 'Referral', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=partnerAccountRecordTypeId);
            insert partnerAccount;
            
            Account partnerAccount1 = new Account(Name = 'Test Account1',Partner_Level__c = 'Referral', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=partnerAccountRecordTypeId);
            insert partnerAccount1;
            
            Id partnerContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
            Contact partnerContact = new Contact(FirstName='Partner',LastName='User',Email='rax.partner@rackspace.com',Phone='1233123',AccountId = partnerAccount.Id,RecordTypeId = partnerContactRecordTypeId);
            
            insert partnerContact;
            partnerAccount.IsPartner = true;
            partnerAccount.Primary_Member__c = partnerContact.Id;
            partnerAccount.Partner_Level__c ='Master Agent';
            update partnerAccount;
            
            partnerAccount.Partner_Account_Status__c ='Approved';
            
            update partnerAccount;
            
            Contact con = new Contact(LastName ='testCon',Email='raxtest.partner@rackspace.com',AccountId = partnerAccount.Id,RecordTypeId = partnerContactRecordTypeId);
            insert con;  
            
            Delete triggerManagers;
            TestDataFactory.triggerManagerFlagValue  = true;
            TestDataFactory.getTriggerManagers();
            setupReputationPointsSetting();
            
            Profile p = [Select id from Profile where name = 'Rackspace-Partners' limit 1];
            
            User user = new User(alias = 'test123', email='test123@noemail.com',
                                 emailencodingkey='UTF-8', lastname='NetworkMember123', languagelocalekey='en_US',
                                 localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
                                 ContactId = con.Id,
                                 timezonesidkey='America/Los_Angeles', username='raxtest.partner@rackspace.com');
            
            insert user;
            
        }
    }
    
    @isTest
    public static void testMethod1(){
        User partnerUser = [SELECT Id, Name, ContactId, Contact.AccountId, Contact.Account.Name FROM User WHERE LastName = 'NetworkMember123' AND IsActive = true limit 1];
        System.runAs(partnerUser){
            List<NetworkMember> networkMembers = [SELECT Id, ReputationPoints, MemberId, Member.contactId, NetworkId FROM NetworkMember WHERE MemberId =: partnerUser.Id];
            for(NetworkMember member : networkMembers){
                member.ReputationPoints += 1;
            }
            update networkMembers;
            Test.startTest();
            CommunityForumController.optInGamification();
            CommunityForumController.markAsOptedIn();
            Test.stopTest();
        }
        
    }
    private static void setupReputationPointsSetting(){
        Insert new Reputation_Levels__c(
            Name = 'Level 1',
            Level_Number__c = 1,
            Threshold__c = 0,
            Image_URL__c = '/image/level1.png'
        );
        Insert new Reputation_Levels__c(
            Name = 'Level 2',
            Level_Number__c = 2,
            Threshold__c = 50,
            Image_URL__c = '/image/level2.png'
        );
    }
}