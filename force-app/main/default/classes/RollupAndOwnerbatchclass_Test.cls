@isTest
public class RollupAndOwnerbatchclass_Test {
    @TestSetUp
    static void setDataUp(){
        
        TestClassUtility.setTestSetupData();
    }
    
    @isTest
    static void RollupbatchTest(){
        Id StandardrtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId(); 
        Id ProspectrtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account').getRecordTypeId();
        
        Account cmp = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId =StandardrtId);
        insert cmp;
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=cmp.id);
        insert c;
        
        Test.startTest();
        RollupUpdateCompany rollbatch = new RollupUpdateCompany();
        database.executeBatch(rollbatch);
        Test.stopTest();
    } 
    @isTest
    static void OwnerandrecordtypeupdatebatchTest(){
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' limit 1];
        UserRole role1 = [select Id,name from UserRole where name ='Rackspace Corporate' limit 1];
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
            userroleid = role1.id
        );
        Insert adminUser;
        System.runAs(adminUser){
            //Product account Record types
            Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId(); 
            Id govtrtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Government Company').getRecordTypeId();
            Id MigRtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Migration Record Account').getRecordTypeId();
            Id govtaccountrtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Government Company').getRecordTypeId();     
            //Getting all the Custom Account record Types
            Id ProspectRtId = Schema.SObjectType.Accounts__c.getRecordTypeInfosByName().get('Prospect').getRecordTypeId(); 
            Id GovernmentRtId = Schema.SObjectType.Accounts__c.getRecordTypeInfosByName().get('Government').getRecordTypeId();
            Id CustomerRtId = Schema.SObjectType.Accounts__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Id RBURtId = Schema.SObjectType.Accounts__c.getRecordTypeInfosByName().get('RBU').getRecordTypeId();
            Id ReadOnlyRtId = Schema.SObjectType.Accounts__c.getRecordTypeInfosByName().get('Read Only').getRecordTypeId();
            
            Account cmp = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId =rtId);
            insert cmp;
            Account govtcmp = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId =govtrtId);
            insert govtcmp;
            Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=cmp.id);
            insert c;
            
            
            Account ac = new Account(Name='Test C Account',custom_account_sfdc_id__c = '0191hadags',ownerid= adminUser.id,Old_Owner_Id__c = userinfo.getUserId(),old_RecordTypeId__c=ProspectRtId,Test_Rollup__c = 'test ',Company_Name__c=cmp.Id,ShippingCountry='India',RecordTypeId =MigRtId);
            insert ac;
            //Account ac1 = new Account(Name='Test C Account',custom_account_sfdc_id__c = '0191hadags',ownerid= adminUser.id,Old_Owner_Id__c = userinfo.getUserId(),old_RecordTypeId__c=GovernmentRtId,Test_Rollup__c = 'test ',Company_Name__c=govtcmp.Id,ShippingCountry='India',RecordTypeId =govtaccountrtId);
            //insert ac1;
            Account ac2 = new Account(Name='Test C Account',custom_account_sfdc_id__c = '0191hadags',ownerid= adminUser.id,Old_Owner_Id__c = userinfo.getUserId(),old_RecordTypeId__c=CustomerRtId,Test_Rollup__c = 'test ',Company_Name__c=cmp.Id,ShippingCountry='India',RecordTypeId =MigRtId);
            insert ac2;
            Account ac3 = new Account(Name='Test C Account',custom_account_sfdc_id__c = '0191hadags',ownerid= adminUser.id,Old_Owner_Id__c = userinfo.getUserId(),old_RecordTypeId__c=RBURtId,Test_Rollup__c = 'test ',Company_Name__c=cmp.Id,ShippingCountry='India',RecordTypeId =MigRtId);
            insert ac3;
            Account ac4 = new Account(Name='Test C Account',custom_account_sfdc_id__c = '0191hadags',ownerid= adminUser.id,Old_Owner_Id__c = userinfo.getUserId(),old_RecordTypeId__c=ReadOnlyRtId,Test_Rollup__c = 'test ',Company_Name__c=cmp.Id,ShippingCountry='India',RecordTypeId =MigRtId);
            insert ac4;
            
            Test.startTest();
            Ownerandrecordtypeupdatebatchclass rbatch = new Ownerandrecordtypeupdatebatchclass();
            database.executeBatch(rbatch);
            Test.stopTest();
        }
    } 
}