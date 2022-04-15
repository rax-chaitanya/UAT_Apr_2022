@isTest(seeAllData = true)
public class LeadRelatedList_Test3 {
    @isTest
    static void accountContactRoleTest(){
        
        //insert new Trigger_Manager__c(name='CompanyTrigger',Is_Active__c=true);
        Account a1 = new Account(name='TestAccount',BillingCountry='India',ShippingCountry='India');
        insert a1;
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a1.id);
        insert c;
        //insert new Trigger_Manager__c(name='AcrTgr',Is_Active__c=true);
        Accounts__c a = new Accounts__c(Name='Custom Account',Company_Name__c=a1.id,Shipping_Country__c='India');
        insert a;
        List<Account_Contact_Role__c> acrlist = new List<Account_Contact_Role__c>();
        Account_Contact_Role__c acr= new Account_Contact_Role__c(Account__c=a.id,Contact__c=c.id,Role__c='Technical');
        insert acr;
        // insert new Account_Contact_Role__c(Account__c=a.id,Contact__c=c.id,Role__c='Primary Contact');      
        // acrlist.add(new Account_Contact_Role__c(Account__c=a.id,Contact__c=c.id,Role__c='Primary Contact'));
        acrlist.add(new Account_Contact_Role__c(Account__c=a.id,Contact__c=c.id,Role__c='Abuse'));
        acrlist.add(new Account_Contact_Role__c(Account__c=a.id,Contact__c=c.id,Role__c='Billing'));
        
        insert acrlist;
        ExternalSharingHelperController.ELIMINATE_DUPLICATE_CONTACT_ROLES = true;
        update acrlist;
        ExternalSharingHelperController.ELIMINATE_DUPLICATE_CONTACT_ROLES = true;
        delete acrlist;
        undelete acrlist;
        try{
            insert new Account_Contact_Role__c(Account__c=a.id,Contact__c=c.id,Role__c='Abuse');
        }catch(Exception e){
           //   system.debug(e.getMessage());
             System.assertEquals((e.getMessage().contains('added twice with the same role')),true);
        }
        
        try{
            ExternalSharingHelperController.ELIMINATE_DUPLICATE_CONTACT_ROLES = true;
            acr.Role__c='Abuse';
            update acr;
        }catch(Exception e){
            System.assertEquals((e.getMessage().contains('added twice with the same role')),true);
        }
    }

   @isTest()
   static void notesTest(){
       User u = [Select Id from User where Profile.Name='Rackspace-Partners' and Account.Partner_Level__c ='Master Agent' and isActive = true limit 1];
           Id recordType = [Select Id from RecordType where sobjectType='Account' and Name ='Partner Company' limit 1].Id;
        Id srecordType = [Select Id from RecordType where sobjectType='Account' and Name ='Standard Company' limit 1].Id;
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

       Profile p = [Select id from Profile where name = 'Rackspace-Partners' limit 1];
        User user3 = new User(alias = 'test4', email='test12343@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing1', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
                ContactId = pcon.Id,
                timezonesidkey='America/Los_Angeles', username='raxtest.partner13@rackspace.com');

       // insert user3;

        Id rtIdLead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead').getRecordTypeId(); 
        
       
       System.runAs(u){
           Lead l = new Lead(ownerid = u.id,firstname='Testfirst1',lastname='lastname1',company='Test company1',
                             email='test.test1@test.com',LeadSource='Chat',Lead_Type__c='AWS',AnnualRevenue = 100.00,
                             Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',
                             Campaign_Interest__c='E&A Cart',Territory__c='EMEA',
                             country='India',postalcode='560037',Type_Of_Deal__c ='Referral',RecordTypeId = rtIdLead
                             //  ,customer_comments__c= 'test'
                            );   
           
           insert l;
       }        
   }  
    
    @isTest()
    static void nonCusomterLeadTest(){
        test.startTest();
        Id rtIdLead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead').getRecordTypeId(); 
        Lead l = new Lead(firstname='Testfirs',lastname='lastnam',company='Test compan1',phone = '32423423423',
                             email='test.tet1@test.com',LeadSource='Site Submission',Lead_Type__c='AWS',AnnualRevenue = 100.00,
                             Focus_Area__c='Amazon',city='London',Campaign_Interest__c='E&A Cart',Territory__c='EMEA',
                             country='United Kingdom',Status='Sales - Accepted Lead',postalcode='WC1V 6DW',Type_Of_Deal__c ='Referral',RecordTypeId = rtIdLead
                             
                            );   
           
           insert l;
         List<Database.LeadConvert> leadsToConvert = new List<Database.LeadConvert>();
        
            Database.LeadConvert Leadconvert = new Database.LeadConvert();
            Leadconvert.setLeadId(l.Id);                
            Leadconvert.setConvertedStatus('Converted');
            Leadconvert.setOwnerId(userinfo.getUserId());
            leadsToConvert.add(Leadconvert);
       
        
        if (!leadsToConvert.isEmpty()) {
             Database.convertLead(leadsToConvert);
            
        }
        test.stopTest();
    }
    
    @isTest()
    static void specialistTest(){
       
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
        delete [select id from Trigger_Manager__c where name='SpecialistTgr'];
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
        delete sps;
        undelete sps;
        
        
        delete l;
        
        undelete l;
    }
    
        
    
     @isTest()
    static void specialistTest2(){
      
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
       Test.startTest();
        Campaign camp1 = new Campaign(Name = 'C102',type='email',Region__c = 'UK', Activity__c ='Event',Channel__c = 'Alliance');
        insert camp1;
        Lead lead1 = new Lead(firstname='SLead',lastname='test1',company='Test company1',Promo_Code__c ='C102',
                          email='test.test@gmail.com',LeadSource='Partner Network',Lead_Type__c='AWS',
                          Focus_Area__c='Amazon',street='Stagefour1',city='Berlin',State='Brandenburg',
                          country='Germany',postalcode='10037');
       
        insert lead1;
        Campaign camp2 = new Campaign(Name = 'C1amp',Type='email',Region__c = 'UK', Activity__c ='Event',Channel__c = 'Alliance'); 
        insert camp2;
        lead1.Promo_Code__c='C1amp';
        update lead1;
    Test.stopTest();
     
       list<campaignMember> CampMembers=[select id  from campaignMember where  LeadId=:lead1.Id AND CampaignID=:camp2.Id];
       System.assertEquals(1, CampMembers.size());
   }
   @isTest static void testAddLeadTocampaign2(){
     Test.startTest();
        Lead lead2 = new Lead(firstname='Neg',lastname='test',company='Neg company',
                          email='test1.test@test.com.asda',LeadSource='Partner Network',Lead_Type__c='AWS',
                          Focus_Area__c='Amazon',street='Stagefour1',city='Berlin',State='Brandenburg',
                          country='Germany',postalcode='20037');
        insert lead2;
        Campaign camp3 = new Campaign(Name = 'C1amp',Type='email',Region__c = 'UK', Activity__c ='Event',Channel__c = 'Alliance'); 
        insert camp3;  
        list<campaignMember> CampMembers2=[select id  from campaignMember where  LeadId=:lead2.Id AND CampaignID=:camp3.Id];
        System.assertEquals(0, CampMembers2.size());
     Test.stopTest();
   }
   @isTest static void testAddLeadTocampaign3(){
         Test.startTest();
        // Create Lead with UTM_Campaign.
        Campaign camp3 = new Campaign(Name = 'C1amp',Type='email',Region__c = 'UK', Activity__c ='Event',Channel__c = 'Alliance'); 
        insert camp3;
        Lead utmLead = new Lead(FirstName='Test',
                             LastName='Lead',
                             Phone='9995551235',
                             Company='Testers',
                             LeadSource='Site Submission',
                             UTM_Campaign__c='C1amp');
        insert utmLead;
      
        // Lookup campaign member records for UTM_Campaign__c lead.
        List<CampaignMember> UTMCampMembers = [SELECT id
                   FROM CampaignMember
                   WHERE CampaignId = :camp3.Id
                   AND LeadId = :utmLead.Id];
        System.assertEquals(1, UTMCampMembers.size());
     Test.stopTest();
   }
   @isTest static void testAddLeadTocampaign4(){
      Test.startTest();
        // Create Lead with CMP__c.
       Campaign camp3 = new Campaign(Name = 'C1amp',Type='email',Region__c = 'UK', Activity__c ='Event',Channel__c = 'Alliance'); 
        insert camp3; 
       Lead cmpLead = new Lead(FirstName='Test',
                             LastName='Lead',
                             Phone='9995551235',
                             Company='Testers',
                             LeadSource='Site Submission',
                             CMP__c='C1amp');
        insert cmpLead;
       
        // Lookup campaign member records for CMP__c lead.
        List<CampaignMember> CMPCampMembers = [SELECT id
                   FROM CampaignMember
                   WHERE CampaignId = :camp3.Id
                   AND LeadId = :cmpLead.Id];
        System.assertEquals(1, CMPCampMembers.size());
     Test.stopTest();
   }
   @isTest static void testAddLeadTocampaign5(){
      Test.startTest();
        // Create Lead without UTM_Campaign__c or CMP__c.
        Lead updateTestLead = new Lead(FirstName='Test',
                                       LastName='Lead',
                                       Phone='9995551235',
                                       Company='Testers',
                                       LeadSource='Site Submission');
        
        insert updateTestLead;
       Campaign camp1 = new Campaign(Name = 'C102',type='email',Region__c = 'UK', Activity__c ='Event',Channel__c = 'Alliance');
        insert camp1;
       Campaign camp3 = new Campaign(Name = 'C1amp',Type='email',Region__c = 'UK', Activity__c ='Event',Channel__c = 'Alliance'); 
        insert camp3;
        // Update lead with UTM_Campaign__c value.
        updateTestLead.UTM_Campaign__c='C1amp';
        update updateTestLead;
        // Lookup campaign member records for UTM_Campaign__c value.
        List<CampaignMember> UpdateTestCampMembers = [SELECT id
                                                      FROM CampaignMember
                                                      WHERE CampaignId = :camp3.Id
                                                      AND LeadId = :updateTestLead.Id];
        System.assertEquals(1, UpdateTestCampMembers.size());
        // Update lead with CMP__c value.
        updateTestLead.CMP__c='C102';
        update updateTestLead;
        Test.stopTest();
        // Lookup campaign member records for CMP__c value.
        UpdateTestCampMembers = [SELECT id
                                 FROM CampaignMember
                                 WHERE CampaignId = :camp1.Id
                                 AND LeadId = :updateTestLead.Id];
        System.assertEquals(1, UpdateTestCampMembers.size());
    }
    
    
    @istest()
    static void addcampaign(){
         map<id,lead> leadmap=new Map<id,Lead>();
        // Id recordType = [Select Id from RecordType where sobjectType='Account' and Name ='Government Account' limit 1].Id;
         //Account pacc = new Account(Name = 'Test Account', BillingCountry = 'United States', ShippingCountry = 'United States',BillingState='california',RecordTypeId=recordType);
         //insert pacc;
        campaign camp = new campaign(Name='Test Campaign',Status='In Progress',isActive=true,Region__c = 'UK', Activity__c ='Event',Channel__c = 'Alliance');
        insert camp;
        campaign camp1 = new campaign(Name='Test Campaign1',Status='In Progress',isActive=true,Region__c = 'UK', Activity__c ='Event',Channel__c = 'Alliance');
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
   private static void autoConvertLeadTest(){
     
       Id rtIdLead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead').getRecordTypeId();  
         Lead l =  new Lead(OwnerId=userinfo.getUserId(),firstname='Testfirst21',lastname='lastname21',company='Test company2',
                          email='test.test21@test.com',Phone='32423423423',LeadSource='Partner Network',Lead_Type__c='AWS',AnnualRevenue = 100.00,
                         Focus_Area__c='Amazon',Status='Sales - Accepted Lead',State='Kiev Oblast',
                          country='Ukraine',RecordTypeId = rtIdLead,Campaign_Interest__c ='E&A Cart',EMEA_Inquiry_Focus_Solution__c='Security', EMEA_Inquiry_Type_Product__c='AliCloud');
        insert l; 
        List<Database.LeadConvert> leadsToConvert = new List<Database.LeadConvert>();
        
            Database.LeadConvert Leadconvert = new Database.LeadConvert();
            Leadconvert.setLeadId(l.Id);                
            Leadconvert.setConvertedStatus('Converted');
            Leadconvert.setOwnerId(userinfo.getUserId());
            leadsToConvert.add(Leadconvert);
       
        
        if (!leadsToConvert.isEmpty()) {
             Database.convertLead(leadsToConvert);
            
        }
    }
}