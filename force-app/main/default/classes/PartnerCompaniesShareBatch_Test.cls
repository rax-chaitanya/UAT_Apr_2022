@isTest
public class PartnerCompaniesShareBatch_Test {
    
    @isTest
    static void createPartnerUser(){
        
        TestClassUtility.setTestSetupData();
        insert new Trigger_Manager__c(Name='UserTrigger',Is_Active__c = true);
        Id recordType = [Select Id from RecordType where sobjectType='Account' and Name ='Partner' limit 1].Id;
        Id srecordType = [Select Id from RecordType where sobjectType='Account' and Name ='Standard' limit 1].Id;
        Account pacc = new Account(Name = 'Test Account', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=recordType);
        insert pacc;
        Id crecordType = [Select Id from RecordType where sobjectType='Contact' and Name ='Partner' limit 1].Id;
        Contact pcon = new Contact(FirstName='Partner',LastName='User',Email='rax.partner@rackspace.com',Phone='1233123',AccountId = pacc.Id,RecordTypeId = crecordType);
        
        insert pcon;
        
        Contact pcon23 = new Contact(FirstName='Partner23',LastName='User23',Email='rax.partner23@rackspace.com',Phone='1233123',AccountId = pacc.Id,RecordTypeId = crecordType);
        
        insert pcon23;
        pacc.IsPartner = true;
        pacc.Primary_Member__c = pcon.Id;
        update pacc;
        pacc.Partner_Level__c ='Master Agent';
        pacc.Partner_Account_Status__c ='Approved';
        pacc.Primary_Member__c = pcon23.Id;
        update pacc;
        List<Account> listAcc =new LIst<Account>();
        listAcc.add(pacc);
        CompanyTriggerHelper.createPartnerUser(listAcc);
        
        // update pacc;
        
        Contact con = new Contact(LastName ='testCon',Email='raxtest.partner@rackspace.com',AccountId = pacc.Id,RecordTypeId = crecordType);
        insert con;  
        Profile p = [Select id from Profile where name = 'Rackspace-Partners' limit 1];
        User user = new User(alias = 'test123', email='test1230987@noemail.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
                             ContactId = con.Id,
                             timezonesidkey='America/Los_Angeles', username='raxtest.partner@rackspace.com');
        System.runAs(new User(Id=userInfo.getUserId())){
            insert user;
        }
        Contact con1 = new Contact(LastName ='testCon1',Email='raxtest.partner1@rackspace.com',AccountId = pacc.Id,RecordTypeId = crecordType);
        insert con1; 
        User user1 = new User(alias = 'test1234', email='test123534@noemail.com',
                              emailencodingkey='UTF-8', lastname='Testing1', languagelocalekey='en_US',
                              localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
                              ContactId = con1.Id,
                              timezonesidkey='America/Los_Angeles', username='raxtest.partner1@rackspace.com');
        System.runAs(new User(Id=userInfo.getUserId())){
            insert user1;
        }
        
        Account pacc1 = new Account(Partner_Level__c='Reseller',ParentId=pacc.Id,Partner_Account_Status__c ='Approved',Name = 'Test Account1', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=recordType);
        insert pacc1;
        
        Contact con2 = new Contact(LastName ='testCon21',Email='raxtest.partner12@rackspace.com',AccountId = pacc1.Id,RecordTypeId = crecordType);
        insert con2; 
        User user2 = new User(alias = 'test4', email='test123483@noemail.com',
                              emailencodingkey='UTF-8', lastname='Testing1', languagelocalekey='en_US',
                              localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
                              ContactId = con2.Id,
                              timezonesidkey='America/Los_Angeles', username='raxtest.partner132@rackspace.com');
        System.runAs(new User(Id=userInfo.getUserId())){
            insert user2;
        }
        
        Account pacc2 = new Account(Partner_Level__c='Referral',ParentId=pacc1.Id,Partner_Account_Status__c ='Approved',Name = 'Test Account2', BillingCountry = 'India',Partner_Company__c = pacc1.Id, ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=recordType);
        insert pacc2;
        
        Contact con3 = new Contact(LastName ='testCon1',Email='raxtest.partner1@rackspace.com',AccountId = pacc2.Id,RecordTypeId = crecordType);
        insert con3; 
        User user3 = new User(alias = 'test4', email='test120343@noemail.com',
                              emailencodingkey='UTF-8', lastname='Testing1', languagelocalekey='en_US',
                              localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
                              ContactId = con3.Id,
                              timezonesidkey='America/Los_Angeles', username='raxtest.partner13@rackspace.com');
        System.runAs(new User(Id=userInfo.getUserId())){
            insert user3;
        }
        Id rtIdLead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead').getRecordTypeId(); 
        
        /*   Lead l = new Lead(firstname='Testfirst1',lastname='lastname1',company='Test company1',
email='test.test1@test.com',LeadSource='Chat',Lead_Type__c='AWS',AnnualRevenue = 100.00,
Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',
country='India',postalcode='560037',Type_Of_Deal__c ='Referral',RecordTypeId = rtIdLead);   
System.runAs(user3){


insert l;

}*/
        
        
        
        Account cuacc1 = new Account(Partner_Level__c='Reseller',ParentId=pacc2.Id,Partner_Company__c=pacc2.Id,Name = 'Test Account112', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=srecordType);
        insert cuacc1;
        
        Contact con5 = new Contact(LastName ='testCon123',Email='raxtest.partner123@rackspace.com',AccountId = pacc.Id,RecordTypeId = crecordType);
        insert con5;  
        
        User user5 = new User(alias = 'test1235', email='test123305@noemail.com',
                              emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                              localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
                              ContactId = con5.Id,
                              timezonesidkey='America/Los_Angeles', username='raxtest.partner12345@rackspace.com');
        System.runAs(new User(Id=userInfo.getUserId())){
            insert user5;
        }
        Test.startTest();
        DataBase.executeBatch(new PartnerCompaniesShareBatch());
        List<AccountTeamMember> lshares = [Select Id from AccountTeamMember limit 10];
        System.debug('lshares '+lshares);
        //System.assert(lshares.size() > 0);
        Test.stopTest();
    }
}