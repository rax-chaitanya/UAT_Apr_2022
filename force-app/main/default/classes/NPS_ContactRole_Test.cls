@isTest
public class NPS_ContactRole_Test {
    @TestSetUp
    static void setDataUp(){
        Test.startTest();
            List<Trigger_Manager__c> tms = new List<Trigger_Manager__c>();
            tms.add( new Trigger_Manager__c(name='ContactTgr',Is_Active__c=true)); 
            tms.add( new Trigger_Manager__c(name='CompanyTrigger',Is_Active__c=true));
            tms.add( new Trigger_Manager__c(name='AcrTgr',Is_Active__c=true));
        	tms.add( new Trigger_Manager__c(name='AccountContactRelation',Is_Active__c=true));
            insert tms;
            
            insertFieldMapings();
            insertOrgConstants();
            
            Id stdCMPRTID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Standard_Company').getRecordTypeId();        
            Account a = new Account(RecordTypeId=stdCMPRTID,Name='NPS Survey Account1',BillingCountry='United States',ShippingCountry='United States',Partner_Account_Status__c='Approved');
            insert a;
            
            Id customerAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();        
            Account ac = new Account(RecordTypeId =customerAccRTId,Name='NPS Survey Customer Acc1',NPS_Collection_Status__c='CURRENT',Company_Name__c=a.Id,status__c='Active',Contracting_Entity__c='a0M61000002lLZq');
            insert ac;
    
            Id contactRTId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Standard').getRecordTypeId();        
            Contact c = new Contact(RecordTypeId =contactRTId,firstname='Test',LastName='NPS Contact1',email='testNPSCon1@testmail.com',AccountId=a.Id,mailingpostalcode='2324',Territory__c='US/CANADA',Mailingcity='Florida City',MailingStreet='Florida Street',Mailingcountry='United States',Mailingstate='Florida',NPS_Survey_Opt_Out__c=false,NPS_Eligible__c=false);
            insert c;
         
        Test.stopTest();
        
    }  
    
    public static void insertFieldMapings() {
        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
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

    
   // @isTest
    static void contact_is_optedout_for_Survey(){
        Test.startTest();        
            Account a1 = [SELECT Id,Name FROM Account WHERE RecordType.Name Like '%Company' AND Name = 'NPS Survey Account1'];
            Account ac1 = [SELECT Id,Name,NPS_Collection_Status__c,status__c,Contracting_Entity__c FROM Account WHERE RecordType.Name Like '%Account' AND Name = 'NPS Survey Customer Acc1'];
            Contact c1 = [SELECT Id,LastName,RecordTypeId,firstname,NPS_Survey_Opt_Out__c,email,Reasons_to_opt_out__c,AccountId,NPS_Eligible__c FROM Contact WHERE LastName = 'NPS Contact1'];
            
            AccountContactRelation acr = new AccountContactRelation(ContactId=c1.Id,AccountId=ac1.Id,Roles='NPS Contact ONLY');
            insert acr;
            //acr.roles='Administrative';
            //c1.NPS_Eligible__c = false;
            c1.NPS_Survey_Opt_Out__c = true;
            c1.Reasons_to_opt_out__c = 'Invalid Contact';        
            update c1;        
        Test.stopTest();        
    }
    

    
      @isTest
    static void updateacrRolewithoutEligible(){
        Test.startTest();
            Id stdCMPRTID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Standard_Company').getRecordTypeId();        
            Id contactRTId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Standard').getRecordTypeId();
            Id customerAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
            
            Account a = new Account(RecordTypeId=stdCMPRTID,Name='NPS Survey Account2a',BillingCountry='United States',ShippingCountry='United States',Partner_Account_Status__c='Approved');
            insert a;
                    
            Account ac2 = new Account(RecordTypeId =customerAccRTId,Name='NPS Survey Customer Acc2a',Company_Name__c=a.Id,status__c='Active',NPS_Collection_Status__c='CURRENT',Contracting_Entity__c='a0M61000002lLZq');
            insert ac2;
            
            Contact c2 = new Contact(RecordTypeId =contactRTId,firstname='Test',LastName='NPS Contact2a',email='testNPSCon2a@testmail.com',AccountId=a.Id,mailingpostalcode='2324',Territory__c='US/CANADA',Mailingcity='Florida City',MailingStreet='Florida Street',Mailingcountry='United States',Mailingstate='Florida',NPS_Eligible__c=true,NPS_Survey_Opt_Out__c=false);
            insert c2;
            
            Id conID = C2.id;
            Id accID = ac2.id;
            
            AccountContactRelation acr = [SELECT Id,ContactID,AccountId,Contact.NPS_CCDate__c,Contact.NPS_Eligible__c,Roles FROM AccountContactRelation WHERE ContactId =: conID AND AccountId =: accID];          
            acr.Roles = 'Reviewer';
            update acr; 
        Test.stopTest();  

        
    }
    
       @isTest
    static void updateacrRolewithoutEligible1(){
        Test.startTest();
            Id stdCMPRTID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Standard_Company').getRecordTypeId();        
            Id contactRTId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Standard').getRecordTypeId();
            Id customerAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
            
            Account a = new Account(RecordTypeId=stdCMPRTID,Name='NPS Survey Account2a',BillingCountry='United States',ShippingCountry='United States',Partner_Account_Status__c='Approved');
            insert a;
                    
            Account ac2 = new Account(RecordTypeId =customerAccRTId,Name='NPS Survey Customer Acc2ac',Company_Name__c=a.Id,status__c='Active',NPS_Collection_Status__c='CURRENT',Contracting_Entity__c='a0M61000002lLZq');
            insert ac2;
            
            Contact c2 = new Contact(RecordTypeId =contactRTId,firstname='Test',LastName='NPS Contact2a',email='testNPSCon3a@testmail.com',AccountId=a.Id,mailingpostalcode='2324',Territory__c='US/CANADA',Mailingcity='Florida City',MailingStreet='Florida Street',Mailingcountry='United States',Mailingstate='Florida',NPS_Survey_Opt_Out__c=false);
            insert c2;
            
            Id conID = C2.id;
            Id accID = ac2.id;
            
            AccountContactRelation acr = [SELECT Id,ContactID,AccountId,Contact.NPS_CCDate__c,Contact.NPS_Eligible__c,Roles FROM AccountContactRelation WHERE ContactId =: conID AND AccountId =: accID];          
      acr.Roles ='Technical';
            update acr; 
        Test.stopTest();  

        
    }
   
  
    
}