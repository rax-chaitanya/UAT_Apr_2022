@isTest
public class LeaderBoardController_Test {
    
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
            
            Id partnerAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
            Account partnerAccount1 = new Account(Name = 'Test Account1', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=partnerAccountRecordTypeId);
            Account partnerAccount2 = new Account(Name = 'Test Account2', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=partnerAccountRecordTypeId);
            Account partnerAccount3 = new Account(Name = 'Test Account3', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=partnerAccountRecordTypeId);
            insert new List<Account>{partnerAccount1, partnerAccount2, partnerAccount3};
            
            Id partnerContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
            
            Contact con1 = new Contact(LastName ='testCon1',Email='raxtest.partner1@rackspace.com',AccountId = partnerAccount1.Id,RecordTypeId = partnerContactRecordTypeId);
            Contact con2 = new Contact(LastName ='testCon2',Email='raxtest.partner2@rackspace.com',AccountId = partnerAccount2.Id,RecordTypeId = partnerContactRecordTypeId);
            Contact con3 = new Contact(LastName ='testCon3',Email='raxtest.partner3@rackspace.com',AccountId = partnerAccount3.Id,RecordTypeId = partnerContactRecordTypeId);
            insert new List<Contact>{con1, con2, con3};  
                
            
            partnerAccount1.IsPartner = true;
            partnerAccount1.Primary_Member__c = con1.Id;
            partnerAccount1.Partner_Level__c ='Master Agent';
            
            partnerAccount2.IsPartner = true;
            partnerAccount2.Primary_Member__c = con2.Id;
            partnerAccount2.Partner_Level__c ='Master Agent';
            
            partnerAccount3.IsPartner = true;
            partnerAccount3.Primary_Member__c = con3.Id;
            partnerAccount3.Partner_Level__c ='Master Agent';
            
            update new List<Account>{partnerAccount1, partnerAccount2, partnerAccount3};
            
            partnerAccount1.Partner_Account_Status__c ='Approved';
            partnerAccount2.Partner_Account_Status__c ='Approved';
            partnerAccount3.Partner_Account_Status__c ='Approved';
            
            update new List<Account>{partnerAccount1, partnerAccount2, partnerAccount3};
                
            Delete triggerManagers;
            TestDataFactory.triggerManagerFlagValue  = true;
            TestDataFactory.getTriggerManagers();
            setupReputationPointsSetting();
            
            Profile p = [Select id from Profile where name = 'Rackspace-Partners' limit 1];
            
            User partner1 = new User(alias = 'test1', email='test1@noemail.com',
                                     emailencodingkey='UTF-8', lastname='NetworkMember1', languagelocalekey='en_US',
                                     localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
                                     ContactId = con1.Id,
                                     timezonesidkey='America/Los_Angeles', username='raxtest.partner1@rackspace.com');
            
            User partner2 = new User(alias = 'test2', email='test1@noemai2.com',
                                     emailencodingkey='UTF-8', lastname='NetworkMember2', languagelocalekey='en_US',
                                     localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
                                     ContactId = con2.Id,
                                     timezonesidkey='America/Los_Angeles', username='raxtest.partner2@rackspace.com');
            User partner3 = new User(alias = 'test3', email='test3@noemail.com',
                                     emailencodingkey='UTF-8', lastname='NetworkMember3', languagelocalekey='en_US',
                                     localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
                                     ContactId = con3.Id,
                                     timezonesidkey='America/Los_Angeles', username='raxtest.partner3@rackspace.com');
            insert new List<User>{partner1, partner2, partner3};
                
                }
    }
    
    @isTest
    public static void testMethod1(){
        User adminUser = [SELECT Id, Name FROM User WHERE LastName = 'testAdminUser123' AND IsActive = true limit 1];
        Map<Id, User> partnerUsers = new Map<Id, User>([SELECT Id, Name FROM User WHERE LastName IN ('NetworkMember1', 'NetworkMember2', 'NetworkMember3') AND IsActive = true limit 3]);
        List<NetworkMember> networkMembers;
        System.runAs(adminUser){
            networkMembers = [SELECT Id, ReputationPoints, MemberId, Member.contactId, NetworkId FROM NetworkMember WHERE MemberId IN: partnerUsers.keySet()];
            for(Integer memberIndex = 0; memberIndex < networkMembers.size(); memberIndex++){
                networkMembers[memberIndex].ReputationPoints += (memberIndex+1);
            }
            Update networkMembers;
            
            LeaderBoardController.networkId = networkMembers[1].NetworkId;
            //LeaderBoardController.updateLevelIcons();
        }
        
        System.runAs(new User(Id = networkMembers[0].MemberId)){
            LeaderBoardController.networkId = networkMembers[0].NetworkId;
            LeaderBoardController.getUserDetails();
            LeaderBoardController.getMemberRanks();
            LeaderBoardController.getPartnerRanks();
        }
        
        System.runAs(new User(Id = networkMembers[1].MemberId)){
            LeaderBoardController.networkId = networkMembers[1].NetworkId;
            LeaderBoardController.getUserDetails();
            LeaderBoardController.getMemberRanks();
            LeaderBoardController.getPartnerRanks();
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