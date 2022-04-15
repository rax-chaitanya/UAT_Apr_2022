@isTest
public class PartnerRoleTriggerHelper1_Test {
    
    @testSetup static void setupTestData() {
        
        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
        insert fieldMappings;  
        
        insertTriggerSettings();
        insertOrgConstants();
        Lead l = new Lead(FirstName = 'Dummy', LastName='Lead', Company = 'Dummy Company',
                          Email = 'dummylead@rackspace.com.test', LeadSource = 'Chat', Lead_Type__c = 'AWS',
                          Focus_Area__c = 'Amazon', Street = 'Church Street', City = 'San Antonio', 
                          State = 'Texas', Country = 'United States', PostalCode = '78023');
        insert l;
        
        insert new Seismic_Industry_Mapping__c(Industry__c='Banking',Seismic_Name__c ='Financial Services');
        
        
        
        Account nonPCompany = new Account(Name = 'Non Partner Company', BillingCountry = 'Canada', ShippingCountry = 'Canada');
        insert nonPCompany;
        
        Account Company = new Account(Name = ' Partner ', BillingCountry = 'Canada', ShippingCountry = 'Canada');
        insert Company;
        
        ID pcRecId=[SELECT Id, Name,  IsActive FROM RecordType Where SobjectType='Account' and Name='Partner Company' Limit 1].ID;
        Account ggParent=new Account(Name='Grand Parent Company',Partner_Account_Status__c='Approved',RecordTypeId=pcRecId);
        insert ggParent;
        ggParent.IsPartner=true;
        update ggParent;
        
        Account gParent=new Account(Name='Garnad Parent Company',ParentId=ggParent.Id,Partner_Account_Status__c='Approved',RecordTypeId=pcRecId,Partner_Level__c='Master Agent');
        insert gParent;
        gParent.IsPartner=true;
        update gParent;
        Test.startTest();
        Account parent=new Account(Name='Parent Company',Partner_Account_Status__c='Approved',RecordTypeId=pcRecId);
        insert parent;
        gParent.IsPartner=true;
        gParent.ParentId=gParent.Id;
        update parent;
        
        Account child=new Account(Name='Child Company',Partner_Account_Status__c='Approved',RecordTypeId=pcRecId);
        insert child;
        child.IsPartner=true;
        child.ParentId=parent.Id;
        Update child;
        Test.stopTest();
        ID pconRecId=[SELECT Id, Name, SobjectType, IsActive FROM RecordType Where SobjectType='Contact' and Name='Partner' Limit 1].ID;
        insert new Trigger_Manager__c(name='AcrTgr',Is_Active__c=true);
        
        List<Contact> contacts=new List<Contact>();
        Contact childUser=new Contact(AccountId=child.Id,FirstName='Child',LastName='User',phone='123456789',Email='childuser@mail.com',RecordTypeId=pconRecId);
        contacts.add(childUser);
        Contact ParentUser=new Contact(AccountId=parent.Id,FirstName='Parent',LastName='User',phone='12346587',Email='parentuser@mail.com',RecordTypeId=pconRecId);
        contacts.add(ParentUser);
        Contact GrandParentUser=new Contact(AccountId=gParent.Id,FirstName='Grand Parent',LastName='User',phone='123465879',Email='grandparent@mail.com',RecordTypeId=pconRecId);
        contacts.add(GrandParentUser);
        Contact gGrandParentUser=new Contact(AccountId=ggParent.Id,FirstName='gGrand Parent',LastName='User',phone='1234065879',Email='ggrandparent1@mail.com',RecordTypeId=pconRecId);
        contacts.add(gGrandParentUser);
        
        insert contacts;
        //   UserRole role = [Select id from UserRole where name = 'CDW Corporation Partner User' limit 1];
        
        List<User> users=new List<User>();     
        
        users.add(new User(UserName=childUser.Email+'.rax.partner.'+UserInfo.getUserName().substringAfterLast('.'),FirstName=childUser.FirstName,LastName=childUser.LastName,Email=childUser.Email,CommunityNickname=childUser.Email.Trim().toLowerCase(),ProfileId=Label.Rackspace_Partners_Login_Profile, Alias=childUser.FirstName,TimeZoneSidKey='America/Mexico_City',LocaleSidKey='en_US',LanguageLocaleKey='en_US',ContactId=childUser.Id,EmailEncodingKey='UTF-8'));
        users.add(new User(UserName=ParentUser.Email+'.rax.partner.'+UserInfo.getUserName().substringAfterLast('.'),FirstName=ParentUser.FirstName,LastName=ParentUser.LastName,Email=ParentUser.Email,CommunityNickname=ParentUser.Email.Trim().toLowerCase(),ProfileId=Label.Rackspace_Partners_Login_Profile, Alias=ParentUser.FirstName,TimeZoneSidKey='America/Mexico_City',LocaleSidKey='en_US',LanguageLocaleKey='en_US',ContactId=ParentUser.Id,EmailEncodingKey='UTF-8'));
        users.add(new User(UserName=GrandParentUser.Email+'.rax.partner.'+UserInfo.getUserName().substringAfterLast('.'),FirstName=GrandParentUser.FirstName,LastName=GrandParentUser.LastName,Email=GrandParentUser.Email,CommunityNickname=GrandParentUser.Email.Trim().toLowerCase(),ProfileId=Label.Rackspace_Partners_Login_Profile, Alias='hdgjsns',TimeZoneSidKey='America/Mexico_City',LocaleSidKey='en_US',LanguageLocaleKey='en_US',ContactId=GrandParentUser.Id,EmailEncodingKey='UTF-8'));
        users.add(new User(UserName=gGrandParentUser.Email+'.rax.partner.'+UserInfo.getUserName().substringAfterLast('.'),FirstName=gGrandParentUser.FirstName,LastName=gGrandParentUser.LastName,Email=gGrandParentUser.Email,CommunityNickname=gGrandParentUser.Email.Trim().toLowerCase(),ProfileId=Label.Rackspace_Partners_Login_Profile, Alias='hdgjons',TimeZoneSidKey='America/Mexico_City',LocaleSidKey='en_US',LanguageLocaleKey='en_US',ContactId=gGrandParentUser.Id,EmailEncodingKey='UTF-8'));
        System.runAs(new User(Id=userInfo.getUserId())){
            insert users;
        }
       // Test.stopTest();
        
    }
    public static void insertTriggerSettings() {
        
        List<Trigger_Manager__c> triggerSettings = new List<Trigger_Manager__c>();
        triggerSettings.add(new Trigger_Manager__c(Name = 'LeadTgr', Is_Active__c = true));
        triggerSettings.add(new Trigger_Manager__c(Name = 'ContactTgr', Is_Active__c = false));
        //triggerSettings.add(new Trigger_Manager__c(Name = 'LeadTgr', Is_Active__c = true));
        triggerSettings.add(new Trigger_Manager__c(Name = 'PartnerRoleTgr', Is_Active__c = true));
        triggerSettings.add(new Trigger_Manager__c(Name = 'CompanyTrigger', Is_Active__c = true));
        //triggerSettings.add(new Trigger_Manager__c(Name = 'OpportunityTgr', Is_Active__c = true));
        //triggerSettings.add(new Trigger_Manager__c(Name = 'cLogTgr', Is_Active__c = true));
        triggerSettings.add(new Trigger_Manager__c(Name = 'OpportunityTeamMemberTgr', Is_Active__c = true));
        triggerSettings.add(new Trigger_Manager__c(Name = 'OpportunitySplitTgr', Is_Active__c = true));
        insert triggerSettings;
        
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
    private static testmethod void testLeadShare(){
              // 
        ID leadId = [SELECT Id FROM Lead LIMIT 1].Id;
        ID accountId=[Select Id,Name From Account Where Name='Child Company' Limit 1].Id;
        Id nonPAccId=[Select Id,Name From Account where Name='Non Partner Company' Limit 1].ID;
        // Id oppId=[Select Id from Opportunity Limit 1].Id;
        System.debug('cda'+accountId);
       Test.startTest();
        Partner_Role__c pRolewithLead=new Partner_Role__c(Lead__c=leadId,Partner_Company__c=accountId,Role__c='Influence',Status__c='Approved',Justification__c='Testing',Commission_Role__c='Credit to this Opp-Acct');
        insert pRolewithLead;
        
        Opportunity opty = new Opportunity(Type='AWS',Name='Test Opport',AccountId=nonPAccId,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15));
        insert opty;
        Partner_Role__c pRolewithOpp=new Partner_Role__c(Opportunity__c=opty.Id,Partner_Company__c=accountId,Role__c='Influence',Status__c='Approved',Justification__c='Testing',Commission_Role__c='Credit to this Opp-Acct');
        insert pRolewithOpp;
        Partner_Role__c UpdatepRolewithLead=new Partner_Role__c(Lead__c=leadId,Partner_Company__c=accountId,Role__c='Influence',Status__c='Pending Approval',Justification__c='Testing',Commission_Role__c='Credit to this Opp-Acct');
        insert UpdatepRolewithLead;
        UpdatepRolewithLead.Status__c='Approved';
        Update UpdatepRolewithLead;
        Partner_Role__c UpdatepRolewithOpp=new Partner_Role__c(Opportunity__c=opty.Id,Partner_Company__c=accountId,Role__c='Influence',Status__c='Pending Approval',Justification__c='Testing',Commission_Role__c='Credit to this Opp-Acct');
        insert UpdatepRolewithOpp;
        UpdatepRolewithOpp.Status__c='Approved';
        Update UpdatepRolewithOpp;
        Delete UpdatepRolewithOpp;
        Account a=[Select Id,name,ParentId from Account Where Name='Garnad Parent Company' Limit 1];
        Account acc=new Account(Id=accountId,ParentId=a.ParentId);
        
      //  update acc;
        Test.stopTest();
    } 
    
    private static testmethod void testLeadShare1(){
        ID leadId = [SELECT Id FROM Lead LIMIT 1].Id;
        ID accountId=[Select Id,Name From Account Where Name='Child Company' Limit 1].Id;         
        Id nonPAccId=[Select Id,Name From Account where Name='Non Partner Company' Limit 1].ID;
        // Id oppId=[Select Id from Opportunity Limit 1].Id;
        System.debug('cda'+accountId);
            Test.startTest();
        Partner_Role__c pRolewithLead=new Partner_Role__c(Lead__c=leadId,Partner_Company__c=accountId,Role__c='Source',Status__c='Approved',Justification__c='Testing',Commission_Role__c='Credit to this Opp-Acct');
        insert pRolewithLead;
        
        Opportunity opty = new Opportunity(Type='AWS',Name='Test Opport',AccountId=nonPAccId,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15));
        insert opty;
        Partner_Role__c pRolewithOpp=new Partner_Role__c(Opportunity__c=opty.Id,Partner_Company__c=accountId,Role__c='Source',Status__c='Approved',Justification__c='Testing',Commission_Role__c='Credit to this Opp-Acct');
        insert pRolewithOpp;
        Account a=[Select Id,name,ParentId from Account Where Name='Parent Company' Limit 1];
        Account ac=new Account(Id=accountId,ParentId=null);
        update ac;
        Account ac1 = new Account(Id=accountId,ParentId=a.Id);
        
        Update ac1;
        Test.stopTest();
        
        
    }
    
    private static testmethod void testLeadShare2(){        
        Account account=[Select Id,Name,Partner_Company__c From Account Where Name='Child Company' Limit 1]; 
        Account a=[Select Id,name,ParentId from Account Where Name='Parent Company' Limit 1];
        Contact c = [Select id from Contact where Email='childuser@mail.com' limit 1];
        //Test.startTest();         
        account.ParentId=a.Id;
        account.Industry='Banking';
        account.Partner_Company__c =a.Id;
        account.Primary_Member__c=c.Id;
        Test.startTest();
        Update account;
        system.debug(account);
        Test.stopTest();
        
        
    }
    
}