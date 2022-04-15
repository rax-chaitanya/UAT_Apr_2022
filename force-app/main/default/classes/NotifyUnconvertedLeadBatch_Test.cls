@isTest(seeAlldata=false)
public class NotifyUnconvertedLeadBatch_Test {
    Id PartnerrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
    Id ProspectrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
    @isTest
    public static  void testMethod1(){
        //inserting custom setting 
      insert new Trigger_Manager__c(name='LeadTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='ContactTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='AccountTgr',Is_Active__c=true);
         insert new Trigger_Manager__c(name='AcrTgr',Is_Active__c=true); 
        
        Id PartnerrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
        Id ProspectrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        // TestDataFactory.getOrgConstants();
        // TestDataFactory.triggerManagerFlagValue  = true;
        // TestDataFactory.getTriggerManagers();
        Profile portalProfile = [select Id from Profile where Name = 'Rackspace Seller-US' limit 1];
        User user1 = new User(userName='abc@rackspace.com.rax12',SSO_Username__c='testP1234',FederationIdentifier='test1234',ProfileId = portalProfile.Id,Alias = 'test123',Email = 'test1234555576@test.com',EmailEncodingKey = 'UTF-8',LastName = 'RaxTesty',
                              Region__c = 'US', Group__c = 'US Other',CommunityNickname = 'test12345',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
        Database.insert(user1);
        System.runAs(user1){  
            Lead l = new Lead(firstname='asdasd',lastname='fssdfgsfd',company='Test compansdfdsfy',AnnualRevenue=100,
                              email='test.test@test.com.asda',Lead_Type__c='AWS',
                              Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',
                              country='India',postalcode='560037',LeadSource='Partner Network', IsConverted = false,Status='New');
            insert l;
            
            Account a1 = new Account(Name = 'Test Account',RecordTypeId=PartnerrecordTypeId,Partner_Account_Status__c ='Approved',phone ='1212121212', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka');
            insert a1;
            Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a1.id);
            //insert c;
            //Account a = new Account(Name='Custom Account',Company_Name__c=a1.id,recordTypeId = ProspectrecordTypeId, phone= '222222222',BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka');
            //insert a;
            Test.startTest();
            Database.executeBatch(new NotifyUnconvertedLeadBatch(), 5);
            String CRON_EXP = '0 0 0 3 9 ? 2022';
            String jobId = System.schedule('NotifyUnconvertedLeadBatchTest', CRON_EXP, new NotifyUnconvertedLeadBatch());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId]; 
            System.assertEquals(0, ct.TimesTriggered); 
            System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime)); 
            Test.stopTest();
            
            
        }
    }
    @isTest
    public static  void testMethod2()
    {
        //inserting custom setting 
       insert new Trigger_Manager__c(name='LeadTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='ContactTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='AccountTgr',Is_Active__c=true);
         insert new Trigger_Manager__c(name='AcrTgr',Is_Active__c=true);
        
         Id PartnerrecordTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
    Id ProspectrecordTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        
        Profile portalProfile1 = [select Id from Profile where Name = 'Rackspace Seller-INTL' limit 1];
        User user2 = new User(userName='abc@rackspace.com.rax',SSO_Username__c='testP12',FederationIdentifier='test12',ProfileId = portalProfile1.Id,Alias = 'test123',Email = 'test1234555576@test.com',EmailEncodingKey = 'UTF-8',LastName = 'RaxTesty',
                              Region__c = 'US', Group__c = 'US Other',CommunityNickname = 'test1235',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
        Database.insert(user2);
        System.runAs(user2){  
            Lead l1 = new Lead(firstname='asdyd',lastname='fssdsfd',company='Test compansfdc',AnnualRevenue=10000,
                               email='test.test@test.com',Lead_Type__c='AWS',
                               Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',
                               country='India',postalcode='560037',LeadSource='Partner Network', IsConverted = false,Status='New',PAMs_Manager__c='test@mail.com1',PAM_email__c='test@mail2.com');
            insert l1;
            //System.assertEquals(14, l1.Current_Owner_Assigned_Date__c);
             Account a1 = new Account(Name = 'Test Account',RecordTypeId=PartnerrecordTypeId1,Partner_Account_Status__c ='Approved',phone ='1212121212', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka');
            insert a1;
            Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a1.id);
         //   insert c;
           // Account a = new Account(Name='Custom Account',Company_Name__c=a1.id,recordTypeId = ProspectrecordTypeId1, phone= '222222222',BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka');
            //insert a;
            Test.startTest();
            Database.executeBatch(new NotifyUnconvertedLeadBatch());
            Test.stopTest();
            
       }
    }
    @isTest
    public static  void testMethod3(){
        //inserting custom setting 
      insert new Trigger_Manager__c(name='LeadTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='ContactTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='AccountTgr',Is_Active__c=true);
         insert new Trigger_Manager__c(name='AcrTgr',Is_Active__c=true);
       
        Id PartnerrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
        Id ProspectrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        // TestDataFactory.getOrgConstants();
        // TestDataFactory.triggerManagerFlagValue  = true;
        // TestDataFactory.getTriggerManagers();
        Profile portalProfile = [select Id from Profile where Name = 'Rackspace Seller-US' limit 1];
        User user1 = new User(userName='abc@rackspace.com.rax12',SSO_Username__c='testP1234',FederationIdentifier='test1234',ProfileId = portalProfile.Id,Alias = 'test123',Email = 'test1234555576@test.com',EmailEncodingKey = 'UTF-8',LastName = 'RaxTesty',
                              Region__c = 'US', Group__c = 'US Other',CommunityNickname = 'test12345',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US');
        Database.insert(user1);
        System.runAs(user1){  
            Lead l = new Lead(firstname='asdasd',lastname='fssdfgsfd',company='Test compansdfdsfy',AnnualRevenue=100,
                              email='test.test@test.com.asda',Lead_Type__c='AWS',
                              Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',
                              country='India',postalcode='560037',LeadSource='Partner Network', IsConverted = false,Status='New' ,PAM_email__c='Test.user1@example.com',PAMs_Manager__c='Test.Manager1@example.com');
            insert l;
            Test.setCreatedDate(l.Id, Datetime.now().addDays(-14));
                         
            /*Account a1 = new Account(Name = 'Test Account',RecordTypeId=PartnerrecordTypeId,Partner_Account_Status__c ='Approved',phone ='1212121212', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka');
            insert a1;
            Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a1.id);
            //insert c;
            Account a = new Account(Name='Custom Account',Company_Name__c=a1.id,recordTypeId = ProspectrecordTypeId, phone= '222222222',BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka');
            insert a;*/
            
            
            
        }
        Test.startTest();
		lead ld=[Select firstname, Createddate,LastTransferDate,Current_Owner_Assigned_Date__c from lead where firstname='asdasd'  LIMIT 1];
        System.debug('Lead date' + ld.LastTransferDate + 'Co:'+  ld.Current_Owner_Assigned_Date__c + 'crdate' + ld.Createddate);
		system.assertequals(ld.Current_Owner_Assigned_Date__c,Decimal.valueOf(Label.LeadNotConvertedDays));

            Database.executeBatch(new NotifyUnconvertedLeadBatch(), 5);
            String CRON_EXP = '0 0 0 3 9 ? 2022';
            String jobId = System.schedule('NotifyUnconvertedLeadBatchTest', CRON_EXP, new NotifyUnconvertedLeadBatch());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId]; 
            System.assertEquals(0, ct.TimesTriggered); 
            System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime)); 
            Test.stopTest();
        
        
    }
 
}