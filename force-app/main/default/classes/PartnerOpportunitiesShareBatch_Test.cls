@isTest
public class PartnerOpportunitiesShareBatch_Test {
 @isTest
    static void createPartnerUser(){
                         Test.startTest();

         User usr = [Select id from User where Id = :UserInfo.getUserId()];
        
        System.RunAs(usr)
        {

        TestClassUtility.setTestSetupData();
        insert new Trigger_Manager__c(Name='UserTrigger',Is_Active__c = true);
         // string companyRecordTypeId =  Schema.sObjectType.account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
   
        Id recordType = [Select Id from RecordType where sobjectType='Account' and Name ='Partner Company' limit 1].Id;
      //  Id srecordType = [Select Id from RecordType where sobjectType='Account' and Name ='Standard Company' limit 1].Id;
        Account pacc = new Account(Name = 'Test Account', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=recordType);
        insert pacc;
        Id crecordType = [Select Id from RecordType where sobjectType='Contact' and Name ='Partner' limit 1].Id;
        Contact pcon = new Contact(FirstName='Partner',LastName='User',Email='rax.partner@rackspace.com',Phone='1233123',AccountId = pacc.Id,RecordTypeId = crecordType);
        
        insert pcon;
        pacc.IsPartner = true;
        pacc.Primary_Member__c = pcon.Id;
        pacc.Partner_Level__c ='Master Agent';
        update pacc;
        
        pacc.Partner_Account_Status__c ='Approved';
        
        update pacc;
        
       Contact con = new Contact(LastName ='testCon',Email='raxtest.partner@rackspace.com',AccountId = pacc.Id,RecordTypeId = crecordType);
        insert con;  
                  Profile p = [Select id from Profile where name = 'Rackspace-Partners' limit 1];
        User user = new User(alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
                ContactId = con.Id,
                timezonesidkey='America/Los_Angeles', username='raxtest.partner@rackspace.com');
       
        insert user;
        
        
          Contact con1 = new Contact(LastName ='testCon1',Email='raxtest.partner1@rackspace.com',AccountId = pacc.Id,RecordTypeId = crecordType);
        insert con1; 
         User user1 = new User(alias = 'test1234', email='test1234@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing1', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
                ContactId = con1.Id,
                timezonesidkey='America/Los_Angeles', username='raxtest.partner1@rackspace.com');
       
        insert user1;
        
        
       /*  Account pacc1 = new Account(Partner_Level__c='Reseller',ParentId=pacc.Id,Partner_Account_Status__c ='Approved',Name = 'Test Account1', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=recordType);
        insert pacc1;
        
          Contact con2 = new Contact(LastName ='testCon21',Email='raxtest.partner12@rackspace.com',AccountId = pacc1.Id,RecordTypeId = crecordType);
        insert con2; 
         User user2 = new User(alias = 'test4', email='test12343@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing1', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
                ContactId = con2.Id,
                timezonesidkey='America/Los_Angeles', username='raxtest.partner132@rackspace.com');
       
        insert user2;
        
        
         Account pacc2 = new Account(Partner_Level__c='Referral',ParentId=pacc1.Id,Partner_Account_Status__c ='Approved',Name = 'Test Account2', BillingCountry = 'India',Partner_Company__c = pacc1.Id, ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=recordType);
        insert pacc2;
        
          Contact con3 = new Contact(LastName ='testCon1',Email='raxtest.partner1@rackspace.com',AccountId = pacc2.Id,RecordTypeId = crecordType);
        insert con3; 
         User user3 = new User(alias = 'test4', email='test12343@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing1', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
                ContactId = con3.Id,
                timezonesidkey='America/Los_Angeles', username='raxtest.partner13@rackspace.com');
       
        insert user3;
        Id rtIdLead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead').getRecordTypeId(); 
               
         Account cuacc1 = new Account(Partner_Level__c='Reseller',ParentId=pacc2.Id,Partner_Company__c=pacc.Id,Name = 'Test Account112', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=srecordType);
        insert cuacc1;
       
        Account a = new Account(Name='Test Account1234',Partner_Company__c=pacc2.Id,BillingCountry='India',ShippingCountry='India',RecordTypeId=srecordType);
        insert a;
        
        Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,ShippingCountry='India');
        insert ac;
        
               
        ExternalSharingHelperController.POPULATE_OPPTY_RECORD_TYPE = false;
        Opportunity opty = new Opportunity(Name='Test Opport',Type='Azure',Partner_Company__c=pacc2.Id,AccountId=a.Id,Product_Account__c=ac.id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15));
        insert opty;
 
        
        
        Contact con5 = new Contact(LastName ='testCon123',Email='raxtest.partner123@rackspace.com',AccountId = pacc.Id,RecordTypeId = crecordType);
        insert con5;  
             
        User user5 = new User(alias = 'test1235', email='test123345@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
                ContactId = con5.Id,
                timezonesidkey='America/Los_Angeles', username='raxtest.partner12345@rackspace.com');
       
        insert user5;*/
        DataBase.executeBatch(new PartnerOpportunitiesShareBatch());
       // List<OpportunityTeamMember> lshares = [Select Id from OpportunityTeamMember where OpportunityId =: opty.Id];
       // System.assert(lshares.size() > 0);
        Test.stopTest();
        }
    }
}