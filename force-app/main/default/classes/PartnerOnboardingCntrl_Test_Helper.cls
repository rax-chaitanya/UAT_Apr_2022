Public class PartnerOnboardingCntrl_Test_Helper{
    
    public static  void getPartnerAccountTestHelper(String prgintst,String prlevel){
        
        Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId(); 
        Id conRID= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId();         
        
        Account acc = new Account(Name='Test Account1234',BillingCountry='United States',BillingState='Florida',Program_Of_Interest__c ='Referral Only',Contract_Type__c='US Referral/Reseller Agreement',ShippingCountry='United States',RecordTypeId=accRID);
        insert acc;
        
        Account ac = new Account(Name='Test C Account',Company_Name__c=acc.Id,ShippingCountry='United States',Contract_Type__c='US Referral/Reseller Agreement',RecordTypeId=Label.Account_Prospect_RecordType_Id);
        insert ac;
        
        Contact con = new Contact(firstname='Test Contact',RecordTypeId= conRID,LastName='Test Last',AccountId=acc.id,HasOptedOutOfEmail=false,Btlk_Country__c='United States',Btlk_Sate_Province__c='Florida');
        insert con;
        
        acc.Primary_Member__c = con.Id;        
        update acc;
        
        Profile portalProfile = [select Id from Profile where UserType = 'PowerPartner' limit 1];
        User user = new User(Username = System.now().millisecond() + 'test12345667@test.com',SSO_Username__c='testP12347',FederationIdentifier='test12347',ContactId = con.Id,ProfileId = portalProfile.Id,Alias = 'test1237',Email = 'test12345555767@test.com',EmailEncodingKey = 'UTF-8',LastName = 'RaxTesty1',CommunityNickname = 'test123457',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
        Database.insert(user);

        
        System.runAs(user){  
            
            Test.StartTest(); 
            Account partnerAccount = PartnerOnboardingController.getPartnerAccount(); 
            String agreementStage = PartnerOnBoardingController.saveProcessAndClose('agreements');
            String paymentStage = PartnerOnBoardingController.saveProcessAndClose('payments');
            String onboardingStage = PartnerOnBoardingController.saveProcessAndClose('onboarding');
            String completedStage = PartnerOnBoardingController.saveProcessAndClose('completed');
            
            PartnerOnBoardingController.setAgreementDate();            
            PartnerOnBoardingController.territoryBasedContractType('Referral','Africa');
            PartnerOnBoardingController.territoryBasedContractType('Reseller','US/CANADA');            
            PartnerOnBoardingController.territoryBasedContractType('Referral/Reseller','Asia');
            PartnerOnBoardingController.territoryBasedContractType('Referral','LATAM');
            
            Test.StopTest();
            System.assertEquals('success', agreementStage, 'Verifying Agreements Stage');  
        } 
    }
    
}