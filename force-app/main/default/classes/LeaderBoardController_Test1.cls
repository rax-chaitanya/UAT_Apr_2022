@isTest
public class LeaderBoardController_Test1{
    
    @isTest(SeeAllData=true)
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
        User partnerUser;
        System.runAs(adminUser){
            
            DELETE [SELECT Id FROM Trigger_Manager__c];
            TestDataFactory.triggerManagerFlagValue  = false;
            List<Trigger_Manager__c> triggerManagers = TestDataFactory.getTriggerManagers();
            
            Id partnerAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
            Account partnerAccount = new Account(Name = 'Test Account',Partner_Level__c = 'Referral', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=partnerAccountRecordTypeId);
            insert partnerAccount;
            
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
            
            partnerUser = new User(alias = 'test123', email='test123@noemail.com',
                                   emailencodingkey='UTF-8', lastname='NetworkMember123', languagelocalekey='en_US',
                                   localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
                                   ContactId = con.Id,
                                   timezonesidkey='America/Los_Angeles', username='raxtest.partner@rackspace.com');
            
            insert partnerUser;
            
            List<NetworkMember> networkMembers = [SELECT Id, ReputationPoints, MemberId, Member.contactId, NetworkId FROM NetworkMember WHERE MemberId =: partnerUser.Id];
            for(NetworkMember member : networkMembers){
                member.ReputationPoints += 1;
            }
            Update networkMembers;
            LeaderBoardController.networkId = networkMembers[0].NetworkId;
            LeaderBoardController.updateLevelIcons();
        }
    }
    
    
    private static void setupReputationPointsSetting(){
        Insert new Reputation_Levels__c(
            Name = 'Level 1',
            Level_Number__c = 1,
            Threshold__c = 1,
            Image_URL__c = '/image/level1.png'
        );
    }
}