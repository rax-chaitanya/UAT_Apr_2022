/**
 * File : CompanyTrigger_Test.cls
 * Description : Tests the CompanyTrigger.trigger trigger. 
 * Created Date : 31/JAN/2017
 * @author : RDC (JY)
 */

@istest
public class ComTrigger_Test
{   
    @testSetup static void setupTestData() {
        Test.startTest();
            insertTriggerSettings();
            insertOrgConstants();
            insertFieldMapings();
           // insertCountryTerritoryMapping();        
            List<Contracting_Entity__c> ceList = ST_TestUtil.getContractingEntity('Rackspace Limited',1);
            insert ceList;
                        
        Test.stopTest();    
        
    }
    
    public static void insertTriggerSettings() {
        List<Trigger_Manager__c> triggerSettings = new List<Trigger_Manager__c>();
        triggerSettings = TestDataFactory.getTriggerManagers();
        
    }
    
   /* public static void insertCountryTerritoryMapping() {
        List<CountryCodeTerritoryMapping__c> mappings = new List<CountryCodeTerritoryMapping__c>();
        mappings.add(new CountryCodeTerritoryMapping__c(Name = 'CA', Country__c='Canada', Territory_Name__c = 'US/CANADA'));
        insert mappings;
    }*/
    
    public static void insertFieldMapings() {
        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountryCode', TargetField__c = 'Territory__c'));
        insert fieldMappings;
    }
    
    public static void insertOrgConstants() {
        Organization o = [SELECT Id FROM Organization LIMIT 1];
        ProcessDefinition p = [SELECT Id FROM ProcessDefinition WHERE DeveloperName = 'Company_Access_Request' AND Type = 'Approval' AND
                                TableEnumOrId = 'Account' LIMIT 1];
        User u = [SELECT Id FROM User WHERE alias = 'sysadmin' AND UserType = 'Standard' AND isActive = TRUE LIMIT 1];
        List<OrgConstants__c> constants = new List<OrgConstants__c>();
        constants.add(new OrgConstants__c(Name = 'Prod Org ID', Non_Prod_Value__c = o.Id, Prod_Value__c = o.Id));
        constants.add(new OrgConstants__c(Name = 'System Administrator ID', Non_Prod_Value__c = u.Id, Prod_Value__c = u.Id));
        constants.add(new OrgConstants__c(Name = 'Company Approval Process ID', Non_Prod_Value__c = p.Id, Prod_Value__c = p.Id));
        constants.add(new OrgConstants__c(Name = '#salesforce-errors', Non_Prod_Value__c = 'https://www.google.com', Prod_Value__c = 'https://www.google.com'));
        insert constants;
    }
        
    private static testmethod void testBeforeDelete() {         
        Account comp = new Account(Name = 'test', BillingCountry = 'Canada', ShippingCountry = 'Canada');
        insert comp;
        
        List<RecordType> customerType = new List<RecordType>();
        customerType = [SELECT Id FROM RecordType WHERE Name = 'Customer Account' AND SObjectType = 'Account'];
        //if(!customerType.isEmpty()) {
            Account acc = new Account(Name = 'test',ShippingCountry='India', Company_Name__c = comp.Id, RecordTypeId = customerType.get(0).Id);
            insert acc;
        
            Test.startTest();
            try {
                delete comp;
            }
            catch(exception ex){
                System.assert(ex.getMessage().contains(Label.Avoid_Company_Delete));
            }        
            Test.stopTest();
        //}
    }
    
    private static testmethod void testAfterDelete() {         
        Account comp = new Account(Name = 'test', BillingCountry = 'Canada', ShippingCountry = 'Canada');
        insert comp;
                  
        Test.startTest();
        delete comp;
        List<Account> companies = new List<Account>();
        companies = [SELECT Id FROM Account WHERE Id = :comp.Id];
        System.assertEquals(0, companies.size());
        undelete comp;
        companies = [SELECT Id FROM Account WHERE Id = :comp.Id];
        System.assertEquals(1, companies.size());
        Test.stopTest();
    }
    
    
    private static testmethod void testMerge() {        
        Account comp1 = new Account(Name = 'test1', BillingCountry = 'Canada', ShippingCountry = 'Canada');
        insert comp1;
        
        Account comp2 = new Account(Name = 'test2', BillingCountry = 'Canada', ShippingCountry = 'Canada', Old_Record_Id__c = comp1.Id);
        insert comp2;
                  
        Test.startTest();
        try{
            Merge comp1 comp2;
        }catch(Exception e) {//WE HAVE LOGIC IN cLogHandler TO UPDATE ALL CHILD RECORDS AFTER MERGE. SO, THE RECORDS IN TRANSACTION DUE TO MERGE(FROM APEX) CANNOT BE UPDATED IN THE SAME TRANSACTION
          //do nothing
        }
        Test.stopTest();
    }
            
    private static testmethod void testBeforeUpdate() {
        Test.startTest();
        
        Account comp = new Account(Name = 'test',industry='Technology',BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId());
        insert comp;
        
        Id RTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Government Company').getRecordTypeId();
        Account comp2 = new Account(Name = 'test',industry='Technology',BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(), RecordTypeId=RTId);
        insert comp2;
        
        List<RecordType> customerType = new List<RecordType>();
        customerType = [SELECT Id FROM RecordType WHERE Name = 'Customer Account' AND SObjectType = 'Account'];
        
        Account acc = new Account(Name = 'test',ShippingCountry='India',Company_Name__c = comp.Id, RecordTypeId = customerType.get(0).Id);
        insert acc;
        
        comp.Company_Access_Submitter__c = OrgConstants__c.getInstance('System Administrator ID').Prod_Value__c;
        update comp;
         
        /*comp2.Menu_Pricing_Approved__c  = false;
        update comp2;*/ 
                     
        Test.stopTest();    
    }         
    
    @isTest static void unlockRecordApprove(){
        Test.startTest(); 
            Account comp = new Account(Name = 'test', BillingCountry = 'Canada', ShippingCountry = 'Canada');
            insert comp;
            Account acc = [SELECT id,Name,Menu_Pricing_Approved__c,ShippingCountry,Contracting_Entity__c,Contracting_Entity_Change__c from Account where Company_Name__c =: comp.Id];            
            
            Contracting_Entity__c ce = [SELECT Id,Name from Contracting_Entity__c LIMIT 1];
            acc.Contracting_Entity_to_Approve__c = ce.Id;            
            acc.Contracting_Entity_Change__c = true;
            acc.ContractingEntityApproved__c = 'Approved';            
            acc.ShippingCountry = 'United States';
            acc.Menu_Pricing_Approved__c = true;
            update acc;
            
            acc.ShippingCountry = 'India';
            acc.Menu_Pricing_Approved__c = false;
            update acc;
        
       Test.stopTest();  
    }
    @isTest static void createPartnerTest() {   
        Test.startTest();
            Id RTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
            Id cRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId();        
            Account ab = new Account(Name = 'test1BPC',Phone='9876543225',BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(),RecordTypeId=RTId,Partner_Account_Status__c='Approved');
            insert ab;
            Account a = new Account(Name = 'test1BPC',Phone='9876543225',BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(),RecordTypeId=RTId);
            insert a;
            Contact cb = New Contact(FirstName='Testb',LastName='Con2',Phone='9876543235',email='testconb2@test.com', AccountID = a.id,RecordTypeId=cRTId);
            insert cb;
            
            List<Account> pcList = new List<Account>();
            pcList.add(a);  
            pcList[0].Partner_Account_Status__c = 'Approved';
            pcList[0].Partner_Company__c = ab.Id;
            pcList[0].Primary_Member__c = cb.Id;
            update pcList;
            CompanyTriggerHelper.createPartnerUser(pcList); 
        Test.stopTest();
    }
        
    private static testmethod void testBeforeUpdatePartner() {         
        Test.startTest();
                
        Seismic_Industry_Mapping__c sim = new Seismic_Industry_Mapping__c(Seismic_Name__c='Technology/Media/Telecom',industry__c='Technology');
        insert sim;                                        
        
        //if(!customerType.isEmpty()) {            
            
            Id RTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
            Account Partcomp1a = new Account(Name = 'testPC1',industry='Technology',Partner_Account_Status__c='Approved',BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(),RecordTypeId=RTId);
            insert Partcomp1a;
        
            CompanyTriggerHelper.seismicIndustryMapping(new List<Account>{Partcomp1a});
                        
            Account PartcompforOld = new Account(Name = 'testPC1forOld',ParentId=Partcomp1a.Id, BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(),RecordTypeId=RTId,Partner_Account_Status__c='Approved');
             insert PartcompforOld;
             
            CompanyTriggerHelper.seismicIndustryMapping(new List<Account>{PartcompforOld});                 
             
             Account Partcomp1 = new Account(Name = 'testPC1a',ParentId=PartcompforOld.Id, BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(),RecordTypeId=RTId,Partner_Account_Status__c='Approved');
             insert Partcomp1;
            
            //Opportunity opp = new Opportunity(Name='OppPCTest1',StageName='Stage 1 - Planning & Identification',CloseDate=System.Today(),AccountId=Partcomp1.Id,Type='Dedicated/Private Cloud',Focus_Area__c='Dedicated');
            //insert opp;
                        
            Partcomp1.ParentId =  Partcomp1a.Id;
            update Partcomp1;
            
            Test.stopTest();
        //}
    }
    
    private static testmethod void testpartnercmp(){
        Id RTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
        Account Partcomp1a = new Account(Name = 'testPC1',Partner_Level__c='Reseller',Partner_Account_Status__c='Approved',BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(),RecordTypeId=RTId);
        insert Partcomp1a;                
        
        Lead ld = new Lead(LastName='TestLd1',Phone='976543258',email='testld1@test.com',Company='PatnerCMPTest',LeadSource='Other'); 
        insert ld;         
                                         
        Test.startTest();
         Account Partcomp = new Account(Name = 'testPC1a',Partner_Level__c='Reseller',parentId=Partcomp1a.Id,Partner_Account_Status__c='Approved',BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(),RecordTypeId=RTId);
         insert Partcomp;        
         Account PartcompforOld = new Account(Name = 'testPC1forOld',Partner_Level__c='Reseller',ParentId=Partcomp.Id, BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(),RecordTypeId=RTId,Partner_Account_Status__c='Approved');
         insert PartcompforOld;
         Account Partcomp1 = new Account(Name = 'testPC1a',Partner_Level__c='Reseller',ParentId=PartcompforOld.Id, BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(),RecordTypeId=RTId,Partner_Account_Status__c='Approved');
         insert Partcomp1; 
         
         ld.Partner_Company__c=PartcompforOld.Id;
         update ld;
         
         PartcompforOld.ParentId=null;
         List<Account> newAccountList = new List<Account>{ PartcompforOld };
         System.debug(newAccountList);
         update newAccountList;        
        Test.stopTest();
            
    }
        
    /*private static testmethod void testAfterUpdate() {
        Id RTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
        Id cRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId();        
        Account ab = new Account(Name = 'test1BPC',Phone='9876543225',BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(),RecordTypeId=RTId,Partner_Account_Status__c='Approved');
        insert ab;
        Contact cb = New Contact(FirstName='Test4b',LastName='Con2',Phone='9876543235',email='testconb2@test.com', AccountID = ab.id,RecordTypeId=cRTId);
        insert cb;
        Account a = new Account(Name = 'test14PC',ParentId=ab.Id,Phone='9876543225',Partner_Level__c='Master Agent',Partner_Company__c=ab.Id,BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(),RecordTypeId=RTId);
        insert a;
        Contact c = New Contact(FirstName='Te4st',LastName='Con2',Phone='9876543215',email='testcon2@test.com', AccountID = a.id,RecordTypeId=cRTId);
        insert c;
        User newUser = createPartnerUser(c.id);
        System.runAs(newUser) {
            /*Account comp2 = new Account(Name = 'test2PC',BillingCountry = 'Canada',Partner_Company__c=a.Id,Primary_Member__c=c.Id,ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(),RecordTypeId=RTId);
            insert comp2;*/   
              
         /*   a.Primary_Member__c=c.Id;
            a.Partner_Level__c='Strategic';            
            a.Partner_Account_Status__c='Approved';
            update a;
            List<Account> partnerCompanies = new List<Account>();
            //partnerCompanies.add(ab);
            partnerCompanies.add(a);
            CommunitySharingHelper.shareRecordsOnCreation(partnerCompanies, 'Account');
            CompanyTriggerHelper.createPartnerUser(partnerCompanies);
            //CompanyTriggerHelper.removeOrUpdateCommunitySharing();
        }*/
        /*Contact con1 = new Contact(FirstName='Test',LastName='Con1',Phone='9876543214',email='testcon1@test.com');
        insert con1;
        Contact con2 = new Contact(FirstName='Test',LastName='Con2',Phone='9876543215',email='testcon2@test.com');  
        insert con2;
        Account comp = new Account(Name = 'test1PC',BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(),RecordTypeId=RTId,Partner_Account_Status__c='Approved');
        Account comp2 = new Account(Name = 'test2PC',BillingCountry = 'Canada', ShippingCountry = 'Canada', Company_Access_Submitter__c = UserInfo.getUserId(),RecordTypeId=RTId);
        insert comp;
        insert comp2;
        List<id> ids = new List<Id>();
        ids.add(comp.Id);
        ids.add(comp2.Id);
        List<Account> accspartner = [select id,Name,Partner_Company__c,Partner_Account_Status__c from Account where id IN : ids];    
        System.debug('accspartner::' + comp.Id);
        comp2.Partner_Company__c=comp.Id;
        comp2.Partner_Account_Status__c='Approved';
        update comp2;
        List<Account> partnerCompanies = new List<Account>();
        partnerCompanies.add(comp2);
        CommunitySharingHelper.shareRecordsOnCreation(partnerCompanies, 'Account');
        CompanyTriggerHelper.createPartnerUser(partnerCompanies);
        CompanyTriggerHelper.removeOrUpdateCommunitySharing();*/
 //   }
    
    private static user createPartnerUser(ID cId){
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
        Profile p = [Select ID, Name from Profile Where Name = 'Rackspace-Partners'];
        user u = New User(
            UserName = 'test_' + math.random() + '@test.com',
            FirstName = 'Test-First',
            LastName = 'Test-Last',
            Alias = 'test',
            email = 'test' + math.random() + '@test.com',
            CommunityNickName = string.valueOf(math.random()).substring(0,6),
            ProfileID = p.Id,
            TimeZoneSidKey = 'America/New_York', 
            LocaleSidKey = 'en_US', 
            EmailEncodingKey = 'UTF-8', 
            LanguageLocaleKey = 'en_US',
            ContactID = cId,
            IsActive =true
            );
    
        insert u;
        System.debug('User::' + u.AccountId + '---' + u.ContactId);
        return u;
        }        
        return null;
    
    }
          
}