/**
* Created Date: 08/18/2020
* Description:  Test Class for CustomLookUpController 
* Author : Sundarayya E
* */
@isTest
public class CustomLookUpController_test {
     @testSetup static void setupTestData() {
          List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
        insert fieldMappings;
        TestDataFactory.getOrgConstants(); 
        TestDataFactory.getTriggerManagers();
        TestDataFactory.createFeatureFlags();
        //insertTriggerSettings();
        insertConnectionSettings();    
         
        
    }    
    static testMethod void insertPartnerUser() {
      	   
        
        Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId(); 
        Id conRID= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId(); 
        Account acc= new Account(Partner_Account_Status__c='Approved',Agreed_By_Timestamp__c=System.now().addDays(-7),Contract_Signed_Date__c =system.today().addDays(-1),Partner_Level__c='Master Agent',RecordTypeId= accRID,Name='Cus look rec',BillingCountry='India',ShippingCountry='India');
        insert acc; 
        
        Contact c = new Contact(RecordTypeId= conRID,firstname='Test Contact1',LastName='Test Last1',AccountId=acc.id,Email = System.now().millisecond() + 'test1@test.com');
        try{
        insert c;
        }catch(exception e){
            system.debug('Exception'+ e.getMessage());
        }
        system.debug('contact Id'+ c.Id);
        acc.Primary_Member__c = c.Id;
        
        update acc;
        
        Test.startTest();
        usertInsertion(c.Id);
        Test.stopTest();
    }
    @future
    Static void usertInsertion(Id conId){
         Profile portalProfile = [select Id from Profile where name = 'Rackspace-Partners' limit 1];
        User user = new User(Username = System.now().millisecond() + 'test1@test.com',SSO_Username__c='cus1234',FederationIdentifier='cus1234',
                             ContactId = conId,ProfileId = portalProfile.Id,Alias = 'cus1234',Email = 'cus1234@test.com',EmailEncodingKey = 'UTF-8',
                             LastName = 'cususer',CommunityNickname = 'cus1234457',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',
                             LanguageLocaleKey = 'en_US');
        Database.insert(user);
        
        system.runAs(user) {
            CustomLookUpController.RecordTypeId();
            CustomLookUpController.getChildAcc();
        }
    }
       public static void insertConnectionSettings() {
        List<Connection_Object_Formula_Fields__c> connSettings = new List<Connection_Object_Formula_Fields__c>();
        connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'Attachment_Parent', Field_API_Name__c = 'ParentID'));
        connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'Lead', Field_API_Name__c = 'Old_lead_look_up_Ids__c'));
        connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'Partner_Role__c', Field_API_Name__c = 'Old_Role_look_up_Ids__c'));
        connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'rvpe__RVAccount__c', Field_API_Name__c = 'Lookup_id__c'));
        connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'rvpe__RVMember__c', Field_API_Name__c = 'Lookup_id__c'));
        connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'RV_Compensation_Detail__c', Field_API_Name__c = 'Lookup_id__c'));
        connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'RV_Compensation_Detail__c_Parent', Field_API_Name__c = 'RV_Compensation__c'));
        connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'RV_Compensation__c_Parent', Field_API_Name__c = 'Account__c'));
        connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'Specialist__c', Field_API_Name__c = 'Old_Specialist_look_up_Ids__c'));
        insert connSettings;
    }
}