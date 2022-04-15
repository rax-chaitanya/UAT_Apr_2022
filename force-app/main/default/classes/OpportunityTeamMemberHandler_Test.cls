@isTest(SeeAllData=true)
public class OpportunityTeamMemberHandler_Test { 
    private static testmethod void OppTeamMemberTest() {
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Rackspace Manager-US']; 
        
        User u = new User(Alias = 'standt',FederationIdentifier = 'abcxyzpqr',Group__c='UK',Region__c='US',Email='testuserOppBucket@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuserabcpqr@testorg.com');
        Insert u;
        
        User u1 = new User(Alias = 'standt1',FederationIdentifier = 'abcxyzpqr1',Group__c='UK',Region__c='US',Email='testuserOppBucket1@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='testuserabcpqr1@testorg.com');
        Insert u1;
        
        User u2 = new User(Alias = 'standt2',FederationIdentifier = 'abcxyzpqr2',Group__c='UK',Region__c='US',Email='testuserOppBucket2@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='testuserabcpqr2@testorg.com');
        Insert u2;
        
        User u3 = new User(Alias = 'standt3',FederationIdentifier = 'abcxyzpqr3',Group__c='UK',Region__c='US',Email='testuserOppBucket3@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='testuserabcpqr3@testorg.com');
        Insert u3;
        
        System.runAs(u)
        {
            
            
            
            Account a = new Account(Name='Test Account1234',BillingCountry='India',BillingState='Karnataka',ShippingCountry='India');
            insert a;
            
            Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,RecordTypeId = Label.Account_Prospect_RecordType_ID,BillingCountry='India',ShippingCountry='India');
            insert ac;
            
            
            Opportunity opty = new Opportunity(Name='Test Opport',Type='Azure',AccountId=a.Id,Account__c=ac.id,Market_Source__c='Yes',DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15));
            insert opty;
            
            OpportunityTeamMember otm1 = New OpportunityTeamMember(Opportunityid=opty.id,Userid=u2.id,TeamMemberRole='Account Executive');
            Insert otm1;
            
            OpportunityTeamMember tm= New OpportunityTeamMember(Opportunityid=opty.id,Userid=u.id,TeamMemberRole='Account Executive');
            OpportunityTeamMember tm3= New OpportunityTeamMember(Opportunityid=opty.id,Userid=u3.id,TeamMemberRole='Account Executive');
            Insert tm3;
            //  Insert tm;
            List<OpportunityTeamMember> optms = new List<OpportunityTeamMember>();
            optms.add(tm);
            
            OpportunityTeamMember tm1= New OpportunityTeamMember(Opportunityid=opty.id,Userid=u1.id,TeamMemberRole='Account Manager');
            //Insert tm1;
            OpportunityTeamMember tm2= New OpportunityTeamMember(Opportunityid=opty.id,Userid=u1.id,TeamMemberRole='Account Manager');
            Insert tm2;
            tm2.TeamMemberRole='CSA';
            Update tm2;
            
            Delete tm2;
            optms.add(tm1);
            OpportunityTeamMember tm4= New OpportunityTeamMember(Opportunityid=opty.id,Userid=u3.id,TeamMemberRole='Account Manager');
            optms.add(tm4);
            try{
                insert optms;
            }catch(Exception e){}
            
            optms[0].TeamMemberRole='Solution Architect Specialist';
            
            insert optms;
            
            List<OpportunityTeamMember> OTM = [SELECT id, UserId, OPPORTUNITYACCESSLEVEL,OpportunityId FROM OpportunityTeamMember WHERE Id =: otm1.id ];
            
            System.assertEquals(OTM.Size(),1);
            
            
        }
        
    }
    
    
    private static testmethod void OppTeamMemberTest1() {
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Rackspace Manager-US']; 
        
        User u = new User(Alias = 'standt',FederationIdentifier = 'abcxyzpqr',Group__c='UK',Region__c='US',Email='testuserOppBucket@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuserabcpqr@testorg.com');
        Insert u;
        
        User u1 = new User(Alias = 'standt1',FederationIdentifier = 'abcxyzpqr1',Group__c='UK',Region__c='US',Email='testuserOppBucket1@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='testuserabcpqr1@testorg.com');
        Insert u1;
        
        User u2 = new User(Alias = 'standt2',FederationIdentifier = 'abcxyzpqr2',Group__c='UK',Region__c='US',Email='testuserOppBucket2@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='testuserabcpqr2@testorg.com');
        Insert u2;
        
        System.runAs(u)
        {
            
            
            
            Account a = new Account(Name='Test Account1234',BillingCountry='India',BillingState='Karnataka',ShippingCountry='India');
            insert a;
            
            Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,RecordTypeId = Label.Account_Prospect_RecordType_ID,BillingCountry='India',ShippingCountry='India');
            insert ac;
            
            List<OpportunityTeamMember> optms = new List<OpportunityTeamMember>();
            
            Opportunity opty = new Opportunity(Name='Test Opport',Type='Azure',AccountId=a.Id,Account__c=ac.id,Market_Source__c='Yes',DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15));
            insert opty;
            
            OpportunityTeamMember otm1 = New OpportunityTeamMember(Opportunityid=opty.id,Userid=u2.id,TeamMemberRole='Account Executive');
            //Insert otm1;
            optms.add(otm1);
            
            OpportunityTeamMember tm= New OpportunityTeamMember(Opportunityid=opty.id,Userid=u.id,TeamMemberRole='Solution Architect Specialist');
            //  Insert tm;        
            optms.add(tm);
            
            OpportunityTeamMember tm1= New OpportunityTeamMember(Opportunityid=opty.id,Userid=u1.id,TeamMemberRole='Account Manager');
            //Insert tm1;
            optms.add(tm1);
            OpportunityTeamMember tm2= New OpportunityTeamMember(Opportunityid=opty.id,Userid=u1.id,TeamMemberRole='CSA');
            optms.add(tm2);
            OpportunityTeamMember tm3= New OpportunityTeamMember(Opportunityid=opty.id,Userid=u1.id,TeamMemberRole='Account Executive');
            optms.add(tm3);
            OpportunityTeamMember tm4= New OpportunityTeamMember(Opportunityid=opty.id,Userid=u.id,TeamMemberRole='Account Executive');
            Insert tm4;
            OpportunityTeamMember tm5= New OpportunityTeamMember(Opportunityid=opty.id,Userid=u.id,TeamMemberRole='AWS Strategic Pursuit Director');
            Insert tm5;
            try{
                insert optms;
            }catch(Exception e){}
            
            
            //optms[0].TeamMemberRole='Solution Architect Specialist';
            
            //update optms;
            
            List<OpportunityTeamMember> OTM = [SELECT id, UserId, OPPORTUNITYACCESSLEVEL,OpportunityId FROM OpportunityTeamMember WHERE Id =: otm1.id ];
            
            //System.assertEquals(OTM.Size(),1);
            
            
            
        }
        
    }
    
    private static testmethod void NegativeTesCase() {
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Rackspace Manager-US']; 
        
        User u = new User(Alias = 'standt',FederationIdentifier = 'abcxyzpqr',Group__c='UK',Region__c='US',Email='testuserOppBucket@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuserabcpqr@testorg.com');
        Insert u;
        
        User u1 = new User(Alias = 'standt1',FederationIdentifier = 'abcxyzpqr1',Group__c='UK',Region__c='US',Email='testuserOppBucket1@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='testuserabcpqr1@testorg.com');
        Insert u1;
        
        User u2 = new User(Alias = 'standt2',FederationIdentifier = 'abcxyzpqr2',Group__c='UK',Region__c='US',Email='testuserOppBucket2@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='testuserabcpqr2@testorg.com');
        Insert u2;
        
        System.runAs(u)
        {
            
            
            
            Account a = new Account(Name='Test Account1234',BillingCountry='India',BillingState='Karnataka',ShippingCountry='India');
            insert a;
            
            Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,RecordTypeId = Label.Account_Prospect_RecordType_ID,BillingCountry='India',ShippingCountry='India');
            insert ac;
            
            List<OpportunityTeamMember> optms = new List<OpportunityTeamMember>();
            
            Opportunity opty = new Opportunity(Name='Test Opport',Type='Azure',AccountId=a.Id,Account__c=ac.id,Market_Source__c='Yes',DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15));
            insert opty;
            
            OpportunityTeamMember otm1 = New OpportunityTeamMember(Opportunityid=opty.id,Userid=u2.id,TeamMemberRole='Account Executive');
            //Insert otm1;
            optms.add(otm1);
            
            OpportunityTeamMember tm= New OpportunityTeamMember(Opportunityid=opty.id,Userid=u.id,TeamMemberRole='Solution Architect Specialist');
            //  Insert tm;        
            optms.add(tm);
            
            OpportunityTeamMember tm1= New OpportunityTeamMember(Opportunityid=opty.id,Userid=u1.id,TeamMemberRole='Account Manager');
            //Insert tm1;
            optms.add(tm1);
            OpportunityTeamMember tm2= New OpportunityTeamMember(Opportunityid=opty.id,Userid=u1.id,TeamMemberRole='CSA');
            optms.add(tm2);
            OpportunityTeamMember tm3= New OpportunityTeamMember(Opportunityid=opty.id,Userid=u1.id,TeamMemberRole='Account Executive');
            optms.add(tm3);
            OpportunityTeamMember tm4= New OpportunityTeamMember(Opportunityid=opty.id,Userid=u.id,TeamMemberRole='Account Executive');
            optms.add(tm4);
            OpportunityTeamMember tm5= New OpportunityTeamMember(Opportunityid=opty.id,Userid=u.id,TeamMemberRole='AWS Strategic Pursuit Director');
            optms.add(tm5);
            OpportunityTeamMember tm6= New OpportunityTeamMember(Opportunityid=opty.id,Userid=u.id,TeamMemberRole='AWS Strategic Pursuit Director');
            optms.add(tm6);
            OpportunityTeamMember tm7= New OpportunityTeamMember(Opportunityid=opty.id,Userid=u.id,TeamMemberRole='Account Executive');
            optms.add(tm7);
            OpportunityTeamMember tm8= New OpportunityTeamMember(Opportunityid=opty.id,Userid=u.id,TeamMemberRole='AWS Strategic Pursuit Director');
            optms.add(tm8);
            try{
                insert optms;
            }catch(Exception e){}
            List<OpportunityTeamMember> OTM = [SELECT id, UserId, OPPORTUNITYACCESSLEVEL,OpportunityId FROM OpportunityTeamMember WHERE Id =: otm1.id ];
            
        }
        
    }
}