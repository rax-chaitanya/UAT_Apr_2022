@isTest
public class PartnerOnboardingController_Test 
{
    @TestSetUp
    static void setDataUp(){
        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
        insert fieldMappings;
        
        List<BrightTALK__BrightTalk_State_Codes__c> btlkstatecode = new List<BrightTALK__BrightTalk_State_Codes__c>();
        btlkstatecode.add(new BrightTALK__BrightTalk_State_Codes__c(Name = 'Florida', BrightTALK__State_Alpha_2__c = 'FL'));
        insert btlkstatecode;
        
        List<CountryTerritoryMapping__c> mappings = new List<CountryTerritoryMapping__c>();
        mappings.add(new CountryTerritoryMapping__c(Name = 'United States', Territory_Name__c = 'US/CANADA'));
        mappings.add(new CountryTerritoryMapping__c(Name = 'Canada', Territory_Name__c = 'US/CANADA'));
        insert mappings;
        
        TestClassUtility.setTestSetupData();
        
        Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
        Id conRID= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        
        List<Account> accList = new List<Account>();
        Account resellerAcc = new Account(Name='Test Account12',BillingCountry='United States',BillingState='Florida',Program_Of_Interest__c ='Reseller - Rackspace Services Only (Excludes Email Services)',Contract_Type__c='US Referral/Reseller Agreement',ShippingCountry='United States',RecordTypeId=accRID);
        accList.add(resellerAcc);
        
        Account referalOrReselleracc = new Account(Name='Test Account123',BillingCountry='United States',BillingState='Florida',Program_Of_Interest__c ='Referral/Reseller - Rackspace Services Only (Excludes the resell of Email Services',Contract_Type__c='US Referral/Reseller Agreement',ShippingCountry='United States',RecordTypeId=accRID);
        accList.add(referalOrReselleracc);        
        insert accList;
        
        List<Contact> conList = new List<Contact>();
        Contact resellerCon = new Contact(firstname='Test Contact12',RecordTypeId= conRID,LastName='Test Last',AccountId=resellerAcc.id,HasOptedOutOfEmail=false,Btlk_Country__c='United States',Btlk_Sate_Province__c='Florida');
        conList.add(resellerCon);
        
        Contact referalOrResellercon = new Contact(firstname='Test Contact123',RecordTypeId= conRID,LastName='Test Last',AccountId=referalOrReselleracc.id,HasOptedOutOfEmail=false,Btlk_Country__c='United States',Btlk_Sate_Province__c='Florida');
        conList.add(referalOrResellercon);
        insert conList;
        
        resellerAcc.Primary_Member__c = resellerCon.Id;        
        update resellerCon;
        
        referalOrReselleracc.Primary_Member__c = referalOrResellercon.Id;        
        update referalOrReselleracc;
        
        Profile portalProfile = [select Id from Profile where UserType = 'PowerPartner' limit 1];
        
        List<User> usrList = new List<User>();
        
        User resellerConUser = new User(Username = System.now().millisecond() + 'test2212@test.com',SSO_Username__c='testP2212',FederationIdentifier='test2212',ContactId = resellerCon.Id,ProfileId = portalProfile.Id,Alias = 'test2212',Email = 'test2212@test.com',EmailEncodingKey = 'UTF-8',LastName = 'RaxTesty2212',CommunityNickname = 'test2212',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
        usrList.add(resellerConUser);
        User referalOrResellerUser = new User(Username = System.now().millisecond() + 'test2812@test.com',SSO_Username__c='testP2812',FederationIdentifier='test2812',ContactId = referalOrResellercon.Id,ProfileId = portalProfile.Id,Alias = 'test2812',Email = 'test2812@test.com',EmailEncodingKey = 'UTF-8',LastName = 'RaxTesty2812',CommunityNickname = 'test2812',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
        usrList.add(referalOrResellerUser);
        insert usrList;
        
    }
    
    private static testmethod void getPartnerAccountReferralTest(){
        PartnerOnboardingCntrl_Test_Helper.getPartnerAccountTestHelper('Referral Only','Referral');
    }
    private static testmethod void getPartnerAccountResellerTest(){
        User usr = [SELECT Id,Name,FederationIdentifier FROM User WHERE FederationIdentifier='test2212' LIMIT 1];
        System.runAs(usr){
            PartnerOnBoardingController.setAgreementDate();  
        }  
        PartnerOnboardingCntrl_Test_Helper.getPartnerAccountTestHelper('Reseller - Rackspace Services Only (Excludes Email Services)','Reseller');
    }
    
    private static testmethod void getPartnerAccountRackspaceServiceTest(){ 
        User usr = [SELECT Id,Name,FederationIdentifier FROM User WHERE FederationIdentifier='test2812' LIMIT 1];
        System.runAs(usr){
            PartnerOnBoardingController.setAgreementDate();  
        }  
        PartnerOnboardingCntrl_Test_Helper.getPartnerAccountTestHelper('Referral/Reseller - Rackspace Services Only (Excludes the resell of Email Services','Referral/Reseller');
    }    
}