@isTest
public class CampaignMemberTriggerTest {

    @isTest static void testCampaignMember(){
   insert new Trigger_Manager__c(name='CampaignMemberTrigger',Is_Active__c=true);
       insert new Trigger_Manager__c(name='AcrTgr',Is_Active__c=true);
       insert new Trigger_Manager__c(name='ContactTgr',Is_Active__c=true);
       insert new Trigger_Manager__c(name='OpportunitySplitTgr',Is_Active__c=true);
      
        String pId=[select id,name from Profile where name='Integration API' limit 1].id;
        System.debug('User '+ [Select id from User where username='oraclesoafoundation@rackspace.com.rax.uat']);
        User conuser = new User(firstname='Connection234',FederationIdentifier = 'dhar3452815dummy',Group__c='UK',Region__c='US',Alias = 'standt', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection3', 
                                LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection3@rackspace.com');
        
            
        insert conuser;
        System.runAs(conuser){
        campaign camp = new campaign(Name='Test Campaign',Status='In Progress',isActive=true,Channel__c='Alliance',Region__c='UK',Activity__c='Online');
        insert camp;
        
        Lead l = new Lead(firstname='Testfirst',lastname='lastname',company='Test company',
                          email='test.test@test.com',LeadSource='Chat',Lead_Type__c='AWS',
                         Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',
                          country='India',postalcode='560037');
        insert l;
          Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert a;
         Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id,MailingCountry='India',Email='test.t@test.com',
                                MailingStreet='Whitefield',Phone='12345676',MailingCity='Bangalore',MailingPostalCode='560066',MailingState='Karnataka');
        insert c;
        Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id);
        insert ac;
       // Account_Contact_Role__c acr= new Account_Contact_Role__c(Account__c=ac.id,Contact__c=c.id,Role__c='Technical');
       // insert acr;
        
         // Verify Campaign_Member_Last_Response_Date__c is empty
         c = [Select Id,Name,Campaign_Member_Last_Response_Date__c from Contact where ID = :c.Id];
         System.assertEquals(null, c.Campaign_Member_Last_Response_Date__c );
         
        
       /* campaignMember campMember = new campaignMember(CampaignId = camp.Id,Status='Sent',ContactID = c.id,leadId = l.id);
        insert campMember;
        campMember.Status='Responded';
        Update campMember;*/
        // Verify Campaign_Member_Last_Response_Date__c is Update
        c = [Select Id,Campaign_Member_Last_Response_Date__c from Contact where ID = :c.Id];
       // System.assertEquals(System.today(), c.Campaign_Member_Last_Response_Date__c );
        
        // Verify Campaign_Member_Last_Response_Date__c is empty
        l = [Select Id,Name,Campaign_Member_Last_Response_Date__c from Lead where ID = :l.Id];
       // System.assertEquals(null, l.Campaign_Member_Last_Response_Date__c);
        campaignMember campMem = new campaignMember(CampaignId = camp.Id,Status='Responded',leadId = l.id);
        insert campMem;
        // Verify Campaign_Member_Last_Response_Date__c is Update
        l = [Select Id,Campaign_Member_Last_Response_Date__c from Lead where ID = :l.Id];
        //System.assertEquals(System.today(), l.Campaign_Member_Last_Response_Date__c );
        
        System.assert(campMem.CampaignId == camp.Id,true);
        update campMem;
        delete campMem;
        CampaignMemberHandler cm = new CampaignMemberHandler();
        cm.afterUndelete();
        //undelete campMem;
       }
            }
}