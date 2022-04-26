@isTest
public class CampaignMemberTrigger_Test {
    @testSetup static void setupTestData(){        
        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
        insert fieldMappings;
        Trigger_Manager__c Tm = new Trigger_Manager__c (Name ='AccountContactRelation',Is_Active__c = true);
        insert Tm;
        
    }
    
    @isTest static void testCampaignMember(){
        insert new Trigger_Manager__c(name='CampaignMemberTrigger',Is_Active__c=true);
        insert new Trigger_Manager__c(name='AcrTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='ContactTgr',Is_Active__c=true);
        insert new Trigger_Manager__c(name='OpportunitySplitTgr',Is_Active__c=true);
        String pId=[select id,name from Profile where name='Integration API' limit 1].id;
        System.debug('User '+ [Select id from User where username='oraclesoafoundation@rackspace.com.rax.uat']);
        User conuser = new User(firstname='Connection',FederationIdentifier = 'dhar2815dummy',Group__c='UK',Region__c='US',Alias = 'standt', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', 
                                LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com');
        
        
        insert conuser;
        System.runAs(conuser){
            // insert new Trigger_Manager__c(name='CampaignMemberTrigger',Is_Active__c=true);
            campaign camp = new campaign(Name='Test Campaign',Status='In Progress',isActive=true,Channel__c='Alliance',Region__c='UK',Activity__c='Online');
            insert camp;
            Lead l = new Lead(firstname='Testfirst',lastname='lastname',company='Test company',
                              email='test.test@test.com',LeadSource='Chat',Lead_Type__c='AWS',
                              Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',
                              country='India',postalcode='560037');
            insert l;
            Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
            insert a;
            Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id,MailingCountry='India',Email='test.t@test.com',
                                    MailingStreet='Whitefield',Phone='12345676',MailingCity='Bangalore',MailingPostalCode='560066',MailingState='Karnataka');
            insert c;
            
            Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,ShippingCountry='India', RecordTypeId = Label.Account_Prospect_RecordType_ID);
            insert ac;
            Contact c2 = new Contact(firstname='Test Contact2',LastName='Test Las2t',AccountId=a.id,MailingCountry='India',Email='test1.t@test.com',
                                     MailingStreet='Whitefield',Phone='12345676',MailingCity='Bangalore',MailingPostalCode='560066',MailingState='Karnataka');
            insert c2;
            Opportunity opty = new Opportunity(Name='Test Opport',Type='Azure',AccountId=a.Id,Account__c=ac.id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15),OwnerId=UserInfo.getUserId());
            insert opty;
            //   Account_Contact_Role__c acr= new Account_Contact_Role__c(Account__c=ac.id,Contact__c=c.id,Role__c='Technical');
            //  insert acr;
            // AccountContactRelation acr= new AccountContactRelation(AccountId=a.id,ContactId=c.id,Roles='Technical');
            //insert acr;
            // campaignMember campMem = new campaignMember(CampaignId = camp.Id,Status='Sent',ACR_Id__c=acr.id,leadId = l.id);
            campaignMember campMem = new campaignMember(CampaignId = camp.Id,Status='Sent',ContactId=c2.id,leadId = l.id);
            insert campMem;
            System.assert(campMem.CampaignId == camp.Id,true);
            update campMem;
            delete campMem;
            CampaignMemberHandler cm = new CampaignMemberHandler();
            cm.afterUndelete();
            
            //   campaignMember campMem1 = new campaignMember(CampaignId = camp.Id,Status='Sent',ContactId=c.id);
            //   insert campMem1;
        }
        //undelete campMem;
        
        
    }
}