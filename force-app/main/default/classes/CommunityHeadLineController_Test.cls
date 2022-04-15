@isTest
public class CommunityHeadLineController_Test {
    @isTest
    public static void testMethod1(){
        List<Trigger_Manager__c> settings = new List<Trigger_Manager__c>();
        settings.add(new Trigger_Manager__c(name='CompanyTrigger',Is_Active__c=false));
        settings.add(new Trigger_Manager__c(name='AccountTrigger',Is_Active__c=false));
        settings.add(new Trigger_Manager__c(name='ContactTgr',Is_Active__c=false));         
        insert settings;
        Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        Id conRID= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        Id oppRID= Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('US Cloud').getRecordTypeId();
        Account a1 = new Account(Contract_Type__c='Agent Channel Agreement',Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =system.today(),Partner_Level__c='Reseller',RecordTypeId= accRID,Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert a1;
        Contact c = new Contact(RecordTypeId= conRID,firstname='Test Contact',LastName='Test Last',AccountId=a1.id,Email = System.now().millisecond() + 'test@test.com');
        insert c;
        a1.Primary_Member__c = c.Id;
        update a1;
        Profile portalProfile = [select Id from Profile where UserType = 'PowerPartner' limit 1];
        User user1 = new User(Region__c ='US',Username = System.now().millisecond() + 'test1234566@test.com',SSO_Username__c='testP1234',FederationIdentifier='test1234',ContactId = c.Id,ProfileId = portalProfile.Id,Alias = 'test123',Email = 'test1234555576@test.com',EmailEncodingKey = 'UTF-8',LastName = 'RaxTesty',CommunityNickname = 'test12345',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
        Database.insert(user1);
        Partner_Community_Data__c pcd =new Partner_Community_Data__c(Active__c=true,Head_Line__c='testdata1',Contract_Type__c='Agent Channel Agreement');
        insert pcd;  
        try{
            System.runAs(user1){
                Test.startTest();
                CommunityHeadLineController.getUserInfo();
                CommunityHeadLineController.getUserInfo2();
                Boolean chk=false;
                Partner_Community_Data__c data = CommunityHeadLineController.getExistingRecord(pcd.Contract_Type__c);
                Test.stopTest();
                System.assertEquals('testdata1', data.Head_Line__c);
            }
        }
        catch(Exception e){} 
    }
    
    
    
    @isTest
    public static void testAdminMethod(){
        CommunityHeadLineController.getUserInfo();
        CommunityHeadLineController.getUserInfo2();
        CommunityHeadLineController.getPicklistvalues('Contract_Type__c');
        Boolean chk=false;
        CommunityHeadLineController.getExistingRecord('test');
         Partner_Community_Data__c pcd =new Partner_Community_Data__c(Active__c=true,Head_Line__c='testdata1',Contract_Type__c='Agent Channel Agreement');
        insert pcd;  
        CommunityHeadLineController.updateHeadLineWithContractType(pcd.Head_Line__c,pcd.Contract_Type__c,pcd.id);
        CommunityHeadLineController.getExistingRecord('test');
        CommunityHeadLineController.getExistingRecord2('test');
         Partner_Community_Data__c pcd2 =new Partner_Community_Data__c(Active__c=true,Head_Line__c='testdata12324',Contract_Type__c='Agent Channel Agreement');
        insert pcd2; 
        CommunityHeadLineController.updateHeadLineWithContractType2(pcd2.Head_Line__c,pcd2.Contract_Type__c,pcd2.id);
        string recid='';
        CommunityHeadLineController.updateHeadLineWithContractType2(pcd2.Head_Line__c,pcd2.Contract_Type__c,recid);
         CommunityHeadLineController.updateHeadLineWithContractType(pcd.Head_Line__c,pcd2.Contract_Type__c,recid);
         try{
        CommunityHeadLineController.getCompanyProfile();
        }catch(Exception e){}
    }
    
    
}