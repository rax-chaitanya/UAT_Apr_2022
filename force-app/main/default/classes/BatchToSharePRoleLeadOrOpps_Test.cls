@isTest
public class BatchToSharePRoleLeadOrOpps_Test {
    @testSetup static void setupTestData() {
        
        List<Trigger_Manager__c> triggerSettings = new List<Trigger_Manager__c>();
        triggerSettings.add(new Trigger_Manager__c(Name = 'AcrTgr', Is_Active__c = true));
        triggerSettings.add(new Trigger_Manager__c(Name = 'ContactTgr', Is_Active__c = true));
       	triggerSettings.add(new Trigger_Manager__c(name='OpportunitySplitTgr',Is_Active__c=true));
       	triggerSettings.add(new Trigger_Manager__c(name='OpportunityTeamMemberTgr',Is_Active__c=true));
        insert triggerSettings;
        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
        insert fieldMappings;
        
        Trigger_Manager__c accTm = new Trigger_Manager__c (Name ='AccountContactRelation',Is_Active__c = true);
        insert accTm;
        
        Lead l = new Lead(FirstName = 'Dummy', LastName='Lead', Company = 'Dummy Company',
                          Email = 'dummylead@rackspace.com.test', LeadSource = 'Chat', Lead_Type__c = 'AWS',
                          Focus_Area__c = 'Amazon', Street = 'Church Street', City = 'San Antonio', 
                          State = 'Texas', Country = 'United States', PostalCode = '78023');
        insert l;
        Account nonPCompany = new Account(Name='Non Partner Company');
        insert nonPCompany;
        
        
        ID pcRecId=[SELECT Id, Name, SobjectType, IsActive FROM RecordType Where SobjectType='Account' and Name='Partner Company' Limit 1].ID;
        Account pCompany=new Account(Name='Partner Account',Partner_Account_Status__c='Approved',RecordTypeId=pcRecId);
        
        insert pCompany;
        
        pCompany.isPartner=true;
        Update pCompany;
        
        ID pconRecId=[SELECT Id, Name, SobjectType, IsActive FROM RecordType Where SobjectType='Contact' and Name='Partner' Limit 1].ID;
        Contact pContact=new Contact(AccountId=pCompany.Id,FirstName='Partner',LastName='User',phone='12346587',Email='testuser@mail.com',RecordTypeId=pconRecId);
        insert pContact;
        
    	//UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        //User pUser=new User( UserRoleId = portalRole.Id,UserName=pContact.Email+'.rax.partner.'+UserInfo.getUserName().substringAfterLast('.'),FirstName=pContact.FirstName,LastName=pContact.LastName,Email=pContact.Email,CommunityNickname=pContact.Email.Trim().toLowerCase(),ProfileId=Label.Rackspace_Partners_Login_Profile, Alias=pContact.FirstName,TimeZoneSidKey='America/Mexico_City',LocaleSidKey='en_US',LanguageLocaleKey='en_US',ContactId=pContact.Id,EmailEncodingKey='UTF-8');  
        //insert pUser;
    }
    private static testmethod void testLeadShare(){
        ID leadId = [SELECT Id FROM Lead LIMIT 1].Id;
        ID accountId=[Select Id,Name From Account Where Name='Partner Account' Limit 1].Id;
        Id nonPAccId=[Select Id,Name From Account where Name='Non Partner Company' Limit 1].ID;
        // Id oppId=[Select Id from Opportunity Limit 1].Id;
        
        
        
        Opportunity opty = new Opportunity(Type='AWS',Name='Test Opport',AccountId=nonPAccId,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15));
        insert opty;
        List<Partner_Role__c> pRolewithOppOrLeadlist=new List<Partner_Role__c>();
        for(Integer i=0;i<=99;i++){
            pRolewithOppOrLeadlist.add(new Partner_Role__c(Lead__c=leadId,Partner_Company__c=accountId,Role__c='Influence',Status__c='Approved',Justification__c='Testing',Commission_Role__c='Credit to this Opp-Acct'));
            pRolewithOppOrLeadlist.add(new Partner_Role__c(Opportunity__c=opty.Id,Partner_Company__c=accountId,Role__c='Influence',Status__c='Approved',Justification__c='Testing',Commission_Role__c='Credit to this Opp-Acct'));
        }insert pRolewithOppOrLeadlist;
        Test.startTest();
        Database.executeBatch(new BatchToSharePRoleLeadOrOpps(), 200);
        Test.stopTest();
        System.assert(pRolewithOppOrLeadlist.size()>0);
        
    }
    
}