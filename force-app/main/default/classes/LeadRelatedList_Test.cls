/**
 * @description       : 
 * @author            : Atheer Bdaiwi
 * @group             : 
 * @last modified on  : 06-16-2021
 * @last modified by  : Atheer Bdaiwi
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   06-16-2021   Atheer Bdaiwi   Initial Version
**/
@isTest
public class LeadRelatedList_Test {

@testSetup static void setupTestData() {
        Test.startTest();
            //insertTriggerSettings();
            //insertOrgConstants();
            insertFieldMapings();
            insertCountryTerritoryMapping();
            
            Test.stopTest();
            }
            

         /*public static void insertTriggerSettings() {
        TestDataFactory.triggerManagerFlagValue = true;
        List<Trigger_Manager__c> triggerSettings = new List<Trigger_Manager__c>();
        triggerSettings = TestDataFactory.getTriggerManagers();
        
    }*/   
    
     public static void insertCountryTerritoryMapping() {
        List<CountryTerritoryMapping__c> mappings = new List<CountryTerritoryMapping__c>();
        mappings.add(new CountryTerritoryMapping__c(Name = 'Canada', Territory_Name__c = 'US/CANADA'));
        mappings.add(new CountryTerritoryMapping__c(Name = 'Afghanistan', Territory_Name__c = 'EMEA'));
        mappings.add(new CountryTerritoryMapping__c(Name = 'Australia', Territory_Name__c = 'ANZ'));
        mappings.add(new CountryTerritoryMapping__c(Name = 'Anguilla', Territory_Name__c = 'LATAM'));
        mappings.add(new CountryTerritoryMapping__c(Name = 'India', Territory_Name__c = 'Asia'));
        mappings.add(new CountryTerritoryMapping__c(Name = 'Belgium', Territory_Name__c = 'Benelux'));
        mappings.add(new CountryTerritoryMapping__c(Name = 'Austria', Territory_Name__c = 'DACH'));
        mappings.add(new CountryTerritoryMapping__c(Name = 'United Kingdom', Territory_Name__c = 'EMEA'));
        insert mappings;
    }
    
    
    public static void insertFieldMapings() {
        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
        insert fieldMappings;
    }
    
    /*public static void insertOrgConstants() {
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
    }*/
            
    
  @isTest
    private static void Notestest(){
        
        
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
            Group__c = 'US Other',
            userroleid = role1.id
        );
        Insert adminUser;
        User partneruser = new user();
        System.runAs(adminUser){
        /*insert new Trigger_Manager__c(name='CampaignMemberTrigger',Is_Active__c=true);
        insert new Trigger_Manager__c(name='LeadTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='AcrTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='OpportunitySplitTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='SpecialistTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='cLogTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='ContactTgr',Is_Active__c=true);*/
            TestDataFactory.getOrgConstants();
            TestDataFactory.getProdOrgIDSetting();
            TestDataFactory.getTriggerManagers();
            TestDataFactory.getFeatureFlagSetting(); 
            TestDataFactory.createFocusAreaMapping();       
            TestDataFactory.createActivityTriggerSettings();
            TestDataFactory.createFeatureFlags();
            TestDataFactory.creteTeamMemberRoles();
            
             Gamification_Action_Points__c Gap = new Gamification_Action_Points__c(Name = 'Create Partner Lead',points__c = 2);
            Gamification_Action_Points__c Gap1 = new Gamification_Action_Points__c(Name = 'Create Subagent Company',points__c = 1);
            insert new List<Gamification_Action_Points__c>{Gap,Gap1};

            Id partnerAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
            Account partnerAccount = new Account(Name = 'Test Account', Partner_Level__c = 'Referral', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=partnerAccountRecordTypeId);
            insert partnerAccount;
            
            Id partnerContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
            Contact partnerContact = new Contact(FirstName='Partner Con',LastName='User',Email='rax.partner@rackspace.com',Phone='1233123',AccountId = partnerAccount.Id,RecordTypeId = partnerContactRecordTypeId);
            
            insert partnerContact;
            
            partnerAccount.IsPartner = true;
            partnerAccount.Primary_Member__c = partnerContact.Id;
            partnerAccount.Partner_Level__c ='Master Agent';
            partnerAccount.Partner_Account_Status__c ='Approved';
            update partnerAccount;
            
            Contact con = new Contact(LastName ='testCon',Email='raxtest.partner@rackspace.com',AccountId = partnerAccount.Id,RecordTypeId = partnerContactRecordTypeId);
            insert con; 
            
           
            Profile p = [Select id from Profile where name = 'Rackspace-Partners' limit 1];
            User user = new User(alias = 'test123', email='test123@noemail.com',emailencodingkey='UTF-8',                                       lastname='NetworkMember123',languagelocalekey='en_US',
                                  localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
                                  ContactId = con.Id,timezonesidkey='America/Los_Angeles', username='raxtest.partner11@rackspace.com');
            
            insert user;
            partneruser = user;
        }
        
        List<Database.LeadConvert> leadsToConvert = new List<Database.LeadConvert>();
        System.runAs(partneruser){  
        Id rtIdLead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Partner Lead').getRecordTypeId();
        Lead l = new Lead(firstname='Testfirst1',lastname='lastname1',company='Test company1',customer_comments__c= '',
                         Partner_company__c= partneruser.accountid, Partner_Contact__c =partneruser.contactid,
                          email='test.test1@test.com',LeadSource='Chat',Lead_Type__c='AWS',AnnualRevenue = 100.00,
                          Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',
                         Campaign_Interest__c='E&A Cart',
                          country='India',postalcode='560037',RecordTypeId = rtIdLead,Type_Of_Deal__c ='Referral'
                         );   
        insert l;
        }      
    }   
    @isTest()
    static void specialistTest(){
        insert new Trigger_Manager__c(name='CompanyTrigger',Is_Active__c=true);
        insert new Trigger_Manager__c(name='CampaignMemberTrigger',Is_Active__c=true);
        insert new Trigger_Manager__c(name='LeadTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='ContactTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='AcrTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='OpportunitySplitTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='SpecialistTgr',Is_Active__c=true);
        Lead l = new Lead(firstname='asdasd',lastname='fssdfgsfd',company='Test compansdfdsfy',
                          email='test.test@test.com.asda',LeadSource='Chat',Lead_Type__c='AWS',
                          Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',HasOptedOutOfEmail=false,
                          country='India',postalcode='560037',Campaign_Interest__c='E&A Cart');
        insert l;
        l.HasOptedOutOfEmail=true;
        update l;
        
        Lead l2 = new Lead(firstname='asdasd',lastname='fssdfgsfd',company='Test compansdfdsfy',
                           email='test.test@test.com.asda',LeadSource='Site Submission',Lead_Type__c='AWS',
                           Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',
                           country='India',postalcode='560037',Campaign_Interest__c='E&A Cart');
        insert l2;
        
        update l2;
        
        Specialist__c sp= new Specialist__c(Additional_Sales_Team__c=UserInfo.getUserId(),Additional_Team_Type__c='Solution Engineer',Lead__c=l.id);
        //delete [select id from Trigger_Manager__c where name='SpecialistTgr'];
        insert sp;
        //insert new Trigger_Manager__c(name='SpecialistTgr',Is_Active__c=true);
        ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS =true;
        List<Specialist__c> sps = new List<Specialist__c>();
        sps.add(new Specialist__c(Additional_Sales_Team__c=UserInfo.getUserId(),Additional_Team_Type__c='Sales Associate',Lead__c=l.id));
        sps.add(new Specialist__c(Additional_Sales_Team__c=UserInfo.getUserId(),Additional_Team_Type__c='Cloud Specialist',Lead__c=l.id));
        sps.add(new Specialist__c(Additional_Sales_Team__c=UserInfo.getUserId(),Additional_Team_Type__c='Digital Practice',Lead__c=l.id));
        insert sps;
        ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS =true;  
        update sps;
        ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS =true;  
        //delete sps;
        //undelete sps;
        
        
        //delete l;
        
        //undelete l;
    }
    
    
    
    @isTest()
    static void specialistTest2(){
        insert new Trigger_Manager__c(name='CompanyTrigger',Is_Active__c=true);
        insert new Trigger_Manager__c(name='CampaignMemberTrigger',Is_Active__c=true);
        insert new Trigger_Manager__c(name='LeadTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='ContactTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='AcrTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='OpportunitySplitTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='SpecialistTgr',Is_Active__c=true);
        
        Lead newLead = new Lead(firstname='asdasd123',lastname='fssdfgsfd123',company='Test123 compansdfdsfy',
                                email='test.test@test.com.asda',LeadSource='Site Submission',Lead_Type__c='AWS',
                                Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',country='United Kingdom',State='Kent',
                                postalcode='56037',status='New',phone='9090909090',
                                Campaign_Interest__c='E&A Cart');
        insert newLead;
        LiveChatVisitor liveChatVisitor = new LiveChatVisitor();
        insert liveChatVisitor;
        
        LiveChatTranscript liveChatTran = new LiveChatTranscript();
        liveChatTran.LiveChatVisitorId = liveChatVisitor.id;
        insert liveChatTran;
        
        liveChatTran.LeadId = newLead.Id;
        update liveChatTran;
        newlead.Status = 'Sales - Accepted Lead';
        update newlead;
        database.leadConvert lc = new database.leadConvert();
        lc.setLeadId(newLead.id);
        leadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        //Database.LeadConvertResult lcr = Database.convertLead(lc);
        //System.assert(lcr.isSuccess());
        lc.setOpportunityName('Cole Swain');
        //liveChatTran.LeadId = lcr.getLeadId();        
        //update liveChatTran;
    }
    
    /**
* Test LeadHandler.AddLeadTocampaign() and LeadHandler.UpdateAddLeadTocampaign()
* @see SFDC-2705, SFDC-3058, SFDC-3214
*/
    @isTest static void testAddLeadTocampaign(){
        insert new Trigger_Manager__c(name='CampaignMemberTrigger',Is_Active__c=true);
        insert new Trigger_Manager__c(name='CompanyTrigger',Is_Active__c=true);
        insert new Trigger_Manager__c(name='LeadTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='ContactTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='AcrTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='OpportunitySplitTgr',Is_Active__c=true); 
        insert new Trigger_Manager__c(name='SpecialistTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='cLogTgr',Is_Active__c=true);
        
        Campaign camp1 = new Campaign(Name = 'C102',type='email',Channel__c='Alliance',Region__c='UK',Activity__c='Online');
        insert camp1;
        Lead lead1 = new Lead(firstname='SLead',lastname='test1',company='Test company1',Promo_Code__c ='C102',
                              email='test.test@gmail.com',LeadSource='Partner Network',Lead_Type__c='AWS',
                              Focus_Area__c='Amazon',street='Stagefour1',city='Berlin',State='Brandenburg',
                              country='Germany',postalcode='10037');
        insert lead1;
        Campaign camp2 = new Campaign(Name = 'C1amp',Type='email',Channel__c='Alliance',Region__c='UK',Activity__c='Online'); 
        insert camp2;
        lead1.Promo_Code__c='C1amp';
        update lead1;
        //campaignMember  cm5 = new campaignMember(LeadId=lead1.Id,CampaignID=camp2.Id);
        //insert cm5;
        list<campaignMember> CampMembers=[select id  from campaignMember where  LeadId=:lead1.Id AND CampaignID=:camp2.Id];
        System.assertEquals(1, CampMembers.size());
        
        Lead lead2 = new Lead(firstname='Neg',lastname='test',company='Neg company',
                              email='test1.test@test.com.asda',LeadSource='Partner Network',Lead_Type__c='AWS',
                              Focus_Area__c='Amazon',street='Stagefour1',city='Berlin',State='Brandenburg',
                              country='Germany',postalcode='20037');
        insert lead2;
        Campaign camp3 = new Campaign(Name = 'C1amp',Type='email',Channel__c='Alliance',Region__c='UK',Activity__c='Online'); 
        insert camp3;  
        list<campaignMember> CampMembers2=[select id  from campaignMember where  LeadId=:lead2.Id AND CampaignID=:camp3.Id];
        System.assertEquals(0, CampMembers2.size());
        
        // Create Lead with UTM_Campaign.
        Lead utmLead = new Lead(FirstName='Test',
                                LastName='Lead',
                                Phone='9995551235',
                                Company='Testers',
                                LeadSource='Site Submission',
                                UTM_Campaign__c='C1amp');
        insert utmLead;
        //campaignMember  cmr = new campaignMember(LeadId=utmLead.Id,CampaignID=camp3.Id);
        //insert cmr;
        // Lookup campaign member records for UTM_Campaign__c lead.
        List<CampaignMember> UTMCampMembers = [SELECT id
                                               FROM CampaignMember
                                               WHERE CampaignId = :camp3.Id
                                               AND LeadId = :utmLead.Id];
        System.assertEquals(1, UTMCampMembers.size());
        
        // Create Lead with CMP__c.
        Lead cmpLead = new Lead(FirstName='Test',
                                LastName='Lead',
                                Phone='9995551235',
                                Company='Testers',
                                LeadSource='Site Submission',
                                CMP__c='C1amp');
        insert cmpLead;
        //campaignMember  cm1 = new campaignMember(LeadId=cmpLead.Id,CampaignID=camp3.Id);
        //insert cm1;
        // Lookup campaign member records for CMP__c lead.
        List<CampaignMember> CMPCampMembers = [SELECT id
                                               FROM CampaignMember
                                               WHERE CampaignId = :camp3.Id
                                               AND LeadId = :cmpLead.Id];
        System.assertEquals(1, CMPCampMembers.size());
        cmpLead.CMP__c = 'C102';
        update cmpLead;
        CMPCampMembers = [SELECT id
                        FROM CampaignMember
                        WHERE (CampaignId = :camp1.Id OR CampaignId = :camp3.Id)
                        AND LeadId = :cmpLead.Id];
        System.assertEquals(2, CMPCampMembers.size());
        
        // Create Lead without UTM_Campaign__c or CMP__c.
        Lead updateTestLead = new Lead(FirstName='Test',
                                       LastName='Lead',
                                       Phone='9995551235',
                                       Company='Testers',
                                       LeadSource='Site Submission');
        insert updateTestLead;
        // Update lead with UTM_Campaign__c value.
        updateTestLead.UTM_Campaign__c='C1amp';
        update updateTestLead;
        //campaignMember  cm3 = new campaignMember(LeadId=updateTestLead.Id,CampaignID=camp3.Id);
        //insert cm3;
        // Lookup campaign member records for UTM_Campaign__c value.
        List<CampaignMember> UpdateTestCampMembers = [SELECT id
                                                      FROM CampaignMember
                                                      WHERE CampaignId = :camp3.Id
                                                      AND LeadId = :updateTestLead.Id];
        System.assertEquals(1, UpdateTestCampMembers.size());
        // Update lead with CMP__c value.
        updateTestLead.CMP__c='C102';
        update updateTestLead;
        //campaignMember  cm4 = new campaignMember(LeadId=updateTestLead.Id,CampaignID=camp1.Id);
        //insert cm4;
        // Lookup campaign member records for CMP__c value.
        UpdateTestCampMembers = [SELECT id
                                 FROM CampaignMember
                                 WHERE CampaignId = :camp1.Id
                                 AND LeadId = :updateTestLead.Id];
        System.assertEquals(1, UpdateTestCampMembers.size());

        // Create lead and assign to campaign directly.
        Test.startTest();
        Lead duplicateMemberTestLead = new Lead(FirstName='Existing',
                                       LastName='Member',
                                       Phone='9995551236',
                                       Company='Testers',
                                       LeadSource='Site Submission');
        insert duplicateMemberTestLead;
        CampaignMember existingCM = new CampaignMember(LeadId=duplicateMemberTestLead.Id,CampaignID=camp1.Id);
        insert existingCM;
        // Update Lead with campaign name from existing CM record.
        duplicateMemberTestLead.CMP__c='C102';
        update duplicateMemberTestLead;
        Test.stopTest();
        List<CampaignMember> duplicateCM = [SELECT id
                          FROM CampaignMember
                          WHERE CampaignId = :camp1.Id
                          AND LeadId = :duplicateMemberTestLead.Id];
        System.assertEquals(1, duplicateCM.size());
    }
    
    @isTest static void testAddLeadToCampaignMatchingCmpUtm(){
        insert new Trigger_Manager__c(name='CampaignMemberTrigger',Is_Active__c=true);
        insert new Trigger_Manager__c(name='CompanyTrigger',Is_Active__c=true);
        insert new Trigger_Manager__c(name='LeadTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='ContactTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='AcrTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='OpportunitySplitTgr',Is_Active__c=true); 
        insert new Trigger_Manager__c(name='SpecialistTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='cLogTgr',Is_Active__c=true);

        Campaign camp1 = new Campaign(Name = 'C102',type='email',Channel__c='Alliance',Region__c='UK',Activity__c='Online');
        insert camp1;
        Lead matchingCmpUtmLead = new Lead(FirstName='Matching',
                                       LastName='Values',
                                       Phone='9995551239',
                                       Company='Testers',
                                       LeadSource='Site Submission',
                                       UTM_Campaign__c='C102',
                                       CMP__c='C102');     
        insert matchingCmpUtmLead;
        List<CampaignMember> members = [SELECT id
                          FROM CampaignMember
                          WHERE CampaignId = :camp1.Id
                          AND LeadId = :matchingCmpUtmLead.Id];
        System.assertEquals(1, members.size());
    }

    @istest()
    static void addcampaign(){
        insert new Trigger_Manager__c(name='CampaignMemberTrigger',Is_Active__c=true);
        insert new Trigger_Manager__c(name='LeadTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='ContactTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='AcrTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='OpportunitySplitTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='SpecialistTgr',Is_Active__c=true);
        
        map<id,lead> leadmap=new Map<id,Lead>();
        Id GovernmentrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Government Company').getRecordTypeId();
        //Id recordType = [Select Id from RecordType where sobjectType='Account' and Name ='Government' limit 1].Id;
        Account pacc = new Account(Name = 'Test Account',RecordTypeId=GovernmentrecordTypeId,phone ='3333333333', BillingCountry = 'United States', ShippingCountry = 'United States',BillingState='california');
        insert pacc;
        campaign camp = new campaign(Name='Test Campaign',Status='In Progress',isActive=true,Channel__c='Alliance',Region__c='UK',Activity__c='Online');
        insert camp;
        campaign camp1 = new campaign(Name='Test Campaign1',Status='In Progress',isActive=true, Channel__c='Alliance',Region__c='UK',Activity__c='Online');
        insert camp1;
        lead Ld=new Lead();
        Ld.FirstName='test';
        Ld.LastName='abc';
        Ld.CurrencyIsoCode ='USD';
        Ld.Company='Accion';
        Ld.Status='Sales - Accepted Lead';
        Ld.Type_Of_Deal__c='Google';
        Ld.Leadsource='E-Mail';
        Ld.Email='xyz@gmail.com';
        Ld.Title='lkjh';
        Ld.Phone='7865488';
        Ld.Focus_Area__c='Amazon';
        Ld.Country='Algeria';
        Ld.Territory__c='EMEA';
        Ld.State='Annaba';
        Ld.Lead_Type__c = 'Azure';
        insert Ld;
        
        // leadmap.put(Ld.id,Ld);
        //LeadHelper.mapLeadFiledsforAccountAndOpportunity(leadmap);
    }
    @istest private static void processLeadTest(){
        createCompany(5,'1234','www.test.com');
        createLead(); 
    } 
    private static void createCompany(Integer n,String duns,String wsite){
        Id accRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        List<Account> ac = new List<Account>();
        for(Integer i =0;i<n;i++){
            ac.add(new Account(RecordTypeId =accRecTypeId,Name='Test Comp'+i,website=wsite,BillingCountry='United States',Territory__c='US/CANADA'));
        }
        insert ac;
    }
    private static void createLead(){
        List<Lead> l = new List<Lead>();
        l.add(new Lead(lastName='Test Lead11',D_U_N_S__c='1234',Company = 'Test Company',Country = 'United States',Territory__c='US/CANADA'));
        //  l.add(new Lead(lastName='Test Lead21',Company = 'Test Comp0',Country = 'United States',Territory__c='US/CANADA'));
        // l.add(new Lead(lastName='Test Lead32',website ='www.test.com',Company='Test Company',Country = 'United States',Territory__c='US/CANADA'));
        //l.add(new Lead(lastName='Test Lead41',Email ='test@test.com',Company='Test Company',Country = 'United States',Territory__c='US/CANADA'));
        insert l;        
    }    
           @isTest
    private static void autoConvertLeadTest4(){
               
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' limit 1];
          UserRole role = [select Id,name from UserRole where name ='Rackspace Corporate' limit 1];
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
            Group__c = 'US Other',
            userroleid = role.id
        );
        Insert adminUser;
        User admuser = new user();
        System.runAs(adminUser){
            TestDataFactory.getOrgConstants();
            TestDataFactory.getProdOrgIDSetting();
            TestDataFactory.getTriggerManagers();
            TestDataFactory.getFeatureFlagSetting(); 
            TestDataFactory.createFocusAreaMapping();       
            TestDataFactory.createActivityTriggerSettings();
            TestDataFactory.createFeatureFlags();
            TestDataFactory.creteTeamMemberRoles();
            
             Gamification_Action_Points__c Gap = new Gamification_Action_Points__c(Name = 'Create Partner Lead',points__c = 2);
            Gamification_Action_Points__c Gap1 = new Gamification_Action_Points__c(Name = 'Create Subagent Company',points__c = 1);
            insert new List<Gamification_Action_Points__c>{Gap,Gap1};

          
        
          Profile adminProfile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator' limit 1];
          UserRole role1 = [select Id,name from UserRole where name ='Rackspace Corporate' limit 1];
            
            User user2 = new User(ProfileId = adminProfile1.Id,
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
            Group__c = 'US Other',
            userroleid = role1.id);
            
            insert user2;
            admuser = user2;
        }
        
        Id rtIdLead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead').getRecordTypeId();                         
        System.runAs(admuser){  
          Id StandardRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        Id ProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account').getRecordTypeId();
        
        Account StAccount = new Account(Name = 'Test Account', Partner_Level__c = 'Referral', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=StandardRecordTypeId,OwnerId=adminUser.id);
        insert StAccount;
        Account pAccount = new Account(Name = 'Test Account',company_name__c = StAccount.id, Partner_Level__c = 'Referral', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=ProspectRecordTypeId,OwnerId= adminUser.id);
        insert pAccount;
        
        Contact pcon = new Contact(FirstName='Partner',LastName='User',Email='rax.partner@rackspace.com',Phone='1233123',AccountId = pAccount.Id); 
        insert pcon;
        
        Opportunity opty = new Opportunity(OwnerId=adminUser.id,Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport',AccountId=StAccount.Id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15), Lead_Id__C = 'L-GARBAGE');
        insert opty;
        note notes = new note(parentId = pcon.id,title ='Test notes');
        insert notes;
        
        Lead l =  new Lead(OwnerId=admuser.id,firstname='Testfirst21d',lastname='lastname21d',company='Test Company21d',email='test.test21d@test.com',Phone='3242342341',LeadSource='Site Submission',Lead_Type__c='AWS',Focus_Area__c='Amazon',State='London',country='United Kingdom',RecordTypeId = rtIdLead,Status='Sales - Accepted Lead',Campaign_Interest__c ='E&A Cart',Territory__c = 'EMEA');
        insert l;
        
        Specialist__c sp= new Specialist__c(Additional_Sales_Team__c=UserInfo.getUserId(),Additional_Team_Type__c='Solution Engineer',Lead__c=l.id);
        //delete [select id from Trigger_Manager__c where name='SpecialistTgr'];
        insert sp;
        //insert new Trigger_Manager__c(name='SpecialistTgr',Is_Active__c=true);
        ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS =true;
        List<Specialist__c> sps = new List<Specialist__c>();
        sps.add(new Specialist__c(Additional_Sales_Team__c=UserInfo.getUserId(),Additional_Team_Type__c='Sales Associate',Lead__c=l.id));
        sps.add(new Specialist__c(Additional_Sales_Team__c=UserInfo.getUserId(),Additional_Team_Type__c='Cloud Specialist',Lead__c=l.id));
        sps.add(new Specialist__c(Additional_Sales_Team__c=UserInfo.getUserId(),Additional_Team_Type__c='Digital Practice',Lead__c=l.id));
        insert sps;
        ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS =true;  
        update sps;
        ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS =true; 
        
        List<Database.LeadConvert> leadsToConvert = new List<Database.LeadConvert>();
        Database.LeadConvert Leadconvert = new Database.LeadConvert();
        Leadconvert.setLeadId(l.Id);   
        Leadconvert.setaccountid(StAccount.Id);
        Leadconvert.setConvertedStatus('Converted');
        Leadconvert.setOwnerId(userinfo.getUserId());
        leadsToConvert.add(Leadconvert);
        
       Test.startTest();  
        Database.convertLead(leadsToConvert);
            
        //LeadHelper.run = true;
        //LeadHelper.runAft = true;
        //LeadHelper.runOnceBefore();
        //LeadHelper.runOnceAfter();
        //LeadHelper.runOnceBefore();
        //LeadHelper.runOnceAfter();
        
       Test.stopTest();
        }      
    }
    
    @isTest
    private static void autoConvertLeadTest(){
        
        TestDataFactory.getOrgConstants();
        TestDataFactory.getProdOrgIDSetting();
        TestDataFactory.getTriggerManagers();
        TestDataFactory.getFeatureFlagSetting(); 
        TestDataFactory.createFocusAreaMapping();       
        TestDataFactory.createActivityTriggerSettings();
        TestDataFactory.createFeatureFlags();
        TestDataFactory.creteTeamMemberRoles();
        
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' limit 1];
          UserRole role1 = [select Id,name from UserRole where name ='Rackspace Corporate' limit 1];
        /* user adminUser1 = new User(
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
            Group__c = 'US Commercial',
            userroleid = role1.id
        );
        Insert adminUser1;*/
        Id rtIdLead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead').getRecordTypeId();     
        Lead l =  new Lead(OwnerId=userinfo.getuserid(),firstname='Testfirst21d',lastname='lastname21d',company='Test Company21d',email='test.test21d@test.com',Phone='3242342341',LeadSource='Site Submission',Lead_Type__c='AWS',Focus_Area__c='Amazon',State='London',country='United Kingdom',RecordTypeId = rtIdLead,Status='Sales - Accepted Lead',Campaign_Interest__c ='E&A Cart',Territory__c = 'EMEA');
        insert l;
        Id StandardRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        Id ProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account').getRecordTypeId();
        
        Account StAccount = new Account(Name = 'Test Account', Partner_Level__c = 'Referral', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=StandardRecordTypeId);
        insert StAccount;
        Account pAccount = new Account(Name = 'Test Account',company_name__c = StAccount.id, Partner_Level__c = 'Referral', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=ProspectRecordTypeId);
        insert pAccount;
        
        Contact pcon = new Contact(FirstName='Partner',LastName='User',Email='rax.partner@rackspace.com',Phone='1233123',AccountId = pAccount.Id); 
        insert pcon;
        
        Opportunity opty = new Opportunity(Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport',AccountId=StAccount.Id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15), Lead_Id__C = 'L-GARBAGE');
        insert opty;
        note notes = new note(parentId = pcon.id,title ='Test notes');
        insert notes;
        
        List<Database.LeadConvert> leadsToConvert = new List<Database.LeadConvert>();
        
        Database.LeadConvert Leadconvert = new Database.LeadConvert();
        Leadconvert.setLeadId(l.Id);   
        Leadconvert.setaccountid(StAccount.Id);     
        Leadconvert.setConvertedStatus('Converted');
        Leadconvert.setOwnerId(userinfo.getUserId());
        leadsToConvert.add(Leadconvert);
        
       Test.startTest();  
        Database.convertLead(leadsToConvert);
            
        //LeadHelper.run = true;
        //LeadHelper.runAft = true;
        //LeadHelper.runOnceBefore();
        //LeadHelper.runOnceAfter();
        //LeadHelper.runOnceBefore();
        //LeadHelper.runOnceAfter();
        
       Test.stopTest(); 
 
             
    }      
     @isTest
    private static void autoConvertLeadTest2(){
        
        TestDataFactory.getOrgConstants();
        TestDataFactory.getProdOrgIDSetting();
        TestDataFactory.getTriggerManagers();
        TestDataFactory.getFeatureFlagSetting(); 
        TestDataFactory.createFocusAreaMapping();       
        TestDataFactory.createActivityTriggerSettings();
        TestDataFactory.createFeatureFlags();
        TestDataFactory.creteTeamMemberRoles();
        
        Id rtIdLead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead').getRecordTypeId(); 
        
        Lead l =  new Lead(OwnerId=userinfo.getUserId(),firstname='Testfirst21d',lastname='lastname21d',company='Test Company21d',email='test.test21d@test.com',Phone='3242342341',LeadSource='Site Submission',Lead_Type__c='AWS',Focus_Area__c='Amazon',State='London',country='United Kingdom',RecordTypeId = rtIdLead,Status='Sales - Accepted Lead',Campaign_Interest__c ='E&A Cart',Territory__c = 'EMEA');
        insert l;
        
        Id StandardRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        Id ProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account').getRecordTypeId();
        Account SAccount = new Account(Name = 'Test Account', Partner_Level__c = 'Referral', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=StandardRecordTypeId);
        insert SAccount;
        Account pAccount = new Account(Name = 'Test Account',company_name__c = SAccount.id, Partner_Level__c = 'Referral', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=ProspectRecordTypeId,Type ='Prospect');
        insert pAccount;
        Contact pcon = new Contact(FirstName='Partner',LastName='User',Email='rax.partner@rackspace.com',Phone='1233123',AccountId = pAccount.Id); 
        insert pcon;
        note notes = new note(parentId = pcon.id,title ='Test notes');
        insert notes;
        
        List<Database.LeadConvert> leadsToConvert = new List<Database.LeadConvert>();
        
        Database.LeadConvert Leadconvert = new Database.LeadConvert();
        Leadconvert.setLeadId(l.Id); 
        Leadconvert.setaccountId(pAccount.Id);      
        Leadconvert.setConvertedStatus('Converted');
        Leadconvert.setOwnerId(userinfo.getUserId());
        leadsToConvert.add(Leadconvert);
        
       Test.startTest();  
        Database.convertLead(leadsToConvert);
            
        //LeadHelper.run = true;
        //LeadHelper.runAft = true;
        //LeadHelper.runOnceBefore();
        //LeadHelper.runOnceAfter();
        //LeadHelper.runOnceBefore();
        //LeadHelper.runOnceAfter();
        
       Test.stopTest();  
             
    }
          @isTest
    private static void autoConvertLeadTest3(){
        
        TestDataFactory.getOrgConstants();
        TestDataFactory.getProdOrgIDSetting();
        TestDataFactory.getTriggerManagers();
        TestDataFactory.getFeatureFlagSetting(); 
        TestDataFactory.createFocusAreaMapping();       
        TestDataFactory.createActivityTriggerSettings();
        TestDataFactory.createFeatureFlags();
        TestDataFactory.creteTeamMemberRoles();
        
        
        Id GCmpRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Government Company').getRecordTypeId();
        Id GacctRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Government Account').getRecordTypeId();
        Id GcontactRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Government').getRecordTypeId();
        
        Account SAccount = new Account(Name = 'Test Account', Partner_Level__c = 'Referral', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=GCmpRecordTypeId);
        insert SAccount;
        Account pAccount = new Account(Name = 'Test Account',company_name__c = SAccount.id, Partner_Level__c = 'Referral', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=GacctRecordTypeId);
        insert pAccount;
        Contact pcon = new Contact(FirstName='Partner',LastName='User',Email='rax.partner@rackspace.com',Phone='1233123',RecordTypeId=GcontactRecordTypeId,AccountId = SAccount.Id); 
        insert pcon;
        note notes = new note(parentId = pcon.id,title ='Test notes');
        insert notes;
        
        Id rtIdLead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Government').getRecordTypeId(); 
        
        Lead l =  new Lead(OwnerId=userinfo.getUserId(),firstname='Testfirst21d',lastname='lastname21d',company='Test Company21d',email='test.test21d@test.com',Phone='3242342341',LeadSource='Site Submission',Lead_Type__c='AWS',Focus_Area__c='Amazon',State='London',country='United Kingdom',RecordTypeId = rtIdLead,Status='Sales - Accepted Lead',Campaign_Interest__c ='E&A Cart',Territory__c = 'EMEA');
        insert l;
        List<Database.LeadConvert> leadsToConvert = new List<Database.LeadConvert>();
        
        Database.LeadConvert Leadconvert = new Database.LeadConvert();
        Leadconvert.setLeadId(l.Id);    
        Leadconvert.setaccountid(SAccount.Id);
        Leadconvert.setcontactid(pcon.Id);      
        Leadconvert.setConvertedStatus('Converted');
        Leadconvert.setOwnerId(userinfo.getUserId());
        leadsToConvert.add(Leadconvert);
        
       Test.startTest();  
        Database.convertLead(leadsToConvert);
            
        //LeadHelper.run = true;
        //LeadHelper.runAft = true;
        //LeadHelper.runOnceBefore();
        //LeadHelper.runOnceAfter();
        //LeadHelper.runOnceBefore();
        //LeadHelper.runOnceAfter();
        
       Test.stopTest();  
             
    }
    @isTest
    private static void PartnerLeadTest(){
               
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
            Group__c = 'US Other',
            userroleid = role1.id
        );
        Insert adminUser;
        User partneruser = new user();
        System.runAs(adminUser){
            TestDataFactory.getOrgConstants();
            TestDataFactory.getProdOrgIDSetting();
            TestDataFactory.getTriggerManagers();
            TestDataFactory.getFeatureFlagSetting(); 
            TestDataFactory.createFocusAreaMapping();       
            TestDataFactory.createActivityTriggerSettings();
            TestDataFactory.createFeatureFlags();
            TestDataFactory.creteTeamMemberRoles();
            
             Gamification_Action_Points__c Gap = new Gamification_Action_Points__c(Name = 'Create Partner Lead',points__c = 2);
            Gamification_Action_Points__c Gap1 = new Gamification_Action_Points__c(Name = 'Create Subagent Company',points__c = 1);
            insert new List<Gamification_Action_Points__c>{Gap,Gap1};

            Id partnerAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
            Account partnerAccount = new Account(Name = 'Test Account', Partner_Level__c = 'Referral', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=partnerAccountRecordTypeId);
            insert partnerAccount;
            
            Id partnerContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
            Contact partnerContact = new Contact(FirstName='Partner Con',LastName='User',Email='rax.partner@rackspace.com',Phone='1233123',AccountId = partnerAccount.Id,RecordTypeId = partnerContactRecordTypeId);
            
            insert partnerContact;
            
            partnerAccount.IsPartner = true;
            partnerAccount.Primary_Member__c = partnerContact.Id;
            partnerAccount.Partner_Level__c ='Master Agent';
            update partnerAccount;
            
            partnerAccount.Partner_Account_Status__c ='Approved';
            
            update partnerAccount;
            
            Contact con = new Contact(LastName ='testCon',Email='raxtest.partner@rackspace.com',AccountId = partnerAccount.Id,RecordTypeId = partnerContactRecordTypeId);
            insert con;  
            
              //UserRole partnerrole = [select Id,name from UserRole where name ='Omnicom Group Inc. Partner User' limit 1];           
            Profile p = [Select id from Profile where name = 'Rackspace-Partners' limit 1];
            
            User user = new User(alias = 'test123', email='test123@noemail.com',emailencodingkey='UTF-8',                                       lastname='NetworkMember123',languagelocalekey='en_US',
                                  localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
                                  ContactId = con.Id,timezonesidkey='America/Los_Angeles', username='raxtest.partner11@rackspace.com');
            
            insert user;
            partneruser = user;
        }
        
        List<Database.LeadConvert> leadsToConvert = new List<Database.LeadConvert>();
        Id rtIdLead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead').getRecordTypeId();                         
        System.runAs(partneruser){  
        Lead l =  new Lead(firstname='Testfirst21d',lastname='lastname21d',Type_Of_Deal__c='Referral',Status = 'new',recordTypeId=rtIdLead,company='Test Company21d',email='test.test21dwew@test.com',Phone='3242342341',LeadSource='Partner Network',Lead_Type__c='AWS',AnnualRevenue = 100.00,Focus_Area__c ='Amazon',State='Kiev Oblast',country='Ukraine',Campaign_Interest__c ='E&A Cart',EMEA_Inquiry_Focus_Solution__c='Cloud Commits', EMEA_Inquiry_Type_Product__c='AliCloud');
        insert l;
        }      
    } 
         @isTest
    private static void PartnerLeadTest2(){
               
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
            Group__c = 'US Other',
            userroleid = role1.id
        );
        Insert adminUser;
        User partneruser = new user();
        System.runAs(adminUser){
            TestDataFactory.getOrgConstants();
            TestDataFactory.getProdOrgIDSetting();
            TestDataFactory.getTriggerManagers();
            TestDataFactory.getFeatureFlagSetting(); 
            TestDataFactory.createFocusAreaMapping();       
            TestDataFactory.createActivityTriggerSettings();
            TestDataFactory.createFeatureFlags();
            TestDataFactory.creteTeamMemberRoles();
            
             Gamification_Action_Points__c Gap = new Gamification_Action_Points__c(Name = 'Create Partner Lead',points__c = 2);
            Gamification_Action_Points__c Gap1 = new Gamification_Action_Points__c(Name = 'Create Subagent Company',points__c = 1);
            insert new List<Gamification_Action_Points__c>{Gap,Gap1};

            Id partnerAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
            Account partnerAccount = new Account(Name = 'Test Account', Partner_Level__c = 'Referral', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=partnerAccountRecordTypeId);
            insert partnerAccount;
            
            Id partnerContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
            Contact partnerContact = new Contact(FirstName='Partner Con',LastName='User',Email='rax.partner@rackspace.com',Phone='1233123',AccountId = partnerAccount.Id,RecordTypeId = partnerContactRecordTypeId);
            
            insert partnerContact;
            
            partnerAccount.IsPartner = true;
            partnerAccount.Primary_Member__c = partnerContact.Id;
            partnerAccount.Partner_Level__c ='Master Agent';
            update partnerAccount;
            
            partnerAccount.Partner_Account_Status__c ='Approved';
            
            update partnerAccount;
            
            Contact con = new Contact(LastName ='testCon',Email='raxtest.partner@rackspace.com',AccountId = partnerAccount.Id,RecordTypeId = partnerContactRecordTypeId);
            insert con;  
            
              //UserRole partnerrole = [select Id,name from UserRole where name ='Omnicom Group Inc. Partner User' limit 1];           
            Profile p = [Select id from Profile where name = 'Rackspace-Partners' limit 1];
            
            User user = new User(alias = 'test123', email='test123@noemail.com',emailencodingkey='UTF-8',                                       lastname='NetworkMember123',languagelocalekey='en_US',
                                  localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
                                  ContactId = con.Id,timezonesidkey='America/Los_Angeles', username='raxtest.partner11@rackspace.com');
            
            insert user;
            partneruser = user;
        }
        
        List<Database.LeadConvert> leadsToConvert = new List<Database.LeadConvert>();
        Id rtIdLead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead').getRecordTypeId();                         
        System.runAs(partneruser){  
        Lead l =  new Lead(firstname='Testfirst21d',lastname='lastname21d',Type_Of_Deal__c='Referral',Status = 'new',recordTypeId=rtIdLead,company='Test Company21d',email='test.test21dwew@test.com',Phone='3242342341',LeadSource='Partner Network',Lead_Type__c='AWS',AnnualRevenue = 100.00,Focus_Area__c ='Amazon',State='Kiev Oblast',country='Ukraine',Campaign_Interest__c ='E&A Cart',EMEA_Inquiry_Focus_Solution__c='Cloud Commits', EMEA_Inquiry_Type_Product__c='AliCloud');
        //,Customer_Comments__c = 'Testing leadhelper class'
        insert l;
        }      
    }
}