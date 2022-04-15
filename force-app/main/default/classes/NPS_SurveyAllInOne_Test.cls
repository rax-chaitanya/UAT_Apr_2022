@isTest
public class NPS_SurveyAllInOne_Test {
    @TestSetUp
    static void setDataUp(){
        Test.startTest();
        List<Trigger_Manager__c> tms = new List<Trigger_Manager__c>();
        tms.add( new Trigger_Manager__c(name='ContactTgr',Is_Active__c=true)); 
        tms.add( new Trigger_Manager__c(name='CompanyTrigger',Is_Active__c=true));
        tms.add( new Trigger_Manager__c(name='AcrTgr',Is_Active__c=true));
        insert tms;
        
        insertFieldMapings();
        insertOrgConstants();
        
        Id stdCMPRTID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Standard_Company').getRecordTypeId();        
        Account a = new Account(RecordTypeId=stdCMPRTID,Name='NPS Survey Account1',BillingCountry='United States',ShippingCountry='United States',Partner_Account_Status__c='Approved');
        insert a;
        
        Id customerAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();        
        Account ac = new Account(RecordTypeId =customerAccRTId,Name='NPS Survey Customer Acc1',NPS_Collection_Status__c='CURRENT',Company_Name__c=a.Id,status__c='Active');
        insert ac;
        
        Id contactRTId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Standard').getRecordTypeId();        
        Contact c = new Contact(RecordTypeId =contactRTId,firstname='Test',LastName='NPS Contact1',email='testNPSCon1@testmail.com',AccountId=a.Id,mailingpostalcode='2324',Territory__c='US/CANADA',Mailingcity='Florida City',MailingStreet='Florida Street',Mailingcountry='United States',Mailingstate='Florida');
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
    
    
    @isTest
    static void contact_is_optedout_for_Survey(){
        Test.startTest();        
        Account a1 = [SELECT Id,Name FROM Account WHERE RecordType.Name Like '%Company' AND Name = 'NPS Survey Account1'];
        Account ac1 = [SELECT Id,Name,NPS_Collection_Status__c,status__c FROM Account WHERE RecordType.Name Like '%Account' AND Name = 'NPS Survey Customer Acc1'];
        Contact c1 = [SELECT Id,LastName,NPS_Survey_Opt_Out__c,Reasons_to_opt_out__c FROM Contact WHERE LastName = 'NPS Contact1'];
        
        //AccountContactRelation acr = new AccountContactRelation(ContactId=c.Id,AccountId=ac.Id,Roles='NPS Contact ONLY;Technical');
        //insert acr;
        
        c1.NPS_Survey_Opt_Out__c = true;
        c1.Reasons_to_opt_out__c = 'Invalid Contact';        
        update c1;        
        Test.stopTest();        
    }
    
    @isTest
    static void acc_DELINQ_Collection_Status(){
        Test.startTest();        
        Account a1 = [SELECT Id,Name FROM Account WHERE RecordType.Name Like '%Company' AND Name = 'NPS Survey Account1'];
        Account ac1 = [SELECT Id,Name,NPS_Collection_Status__c,status__c FROM Account WHERE RecordType.Name Like '%Account' AND Name = 'NPS Survey Customer Acc1'];
        Contact c1 = [SELECT Id,LastName,NPS_Survey_Opt_Out__c,Reasons_to_opt_out__c FROM Contact WHERE LastName = 'NPS Contact1'];
        
        //AccountContactRelation acr = new AccountContactRelation(ContactId=c.Id,AccountId=ac.Id,Roles='NPS Contact ONLY;Technical');
        //insert acr;
        
        ac1.NPS_Collection_Status__c = 'DELINQUENT_LEVEL_1';
        update ac1;
        
        ac1.NPS_Collection_Status__c = 'CURRENT';
        update ac1;
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
        
        Account ac2 = new Account(RecordTypeId =customerAccRTId,Name='NPS Survey Customer Acc2a',Company_Name__c=a.Id,status__c='New');
        insert ac2;
        
        Contact c2 = new Contact(RecordTypeId =contactRTId,firstname='Test',LastName='NPS Contact2a',email='testNPSCon2a@testmail.com',AccountId=a.Id,mailingpostalcode='2324',Territory__c='US/CANADA',Mailingcity='Florida City',MailingStreet='Florida Street',Mailingcountry='United States',Mailingstate='Florida');
        insert c2;
        
        Id conID = C2.id;
        Id accID = ac2.id;
        
        AccountContactRelation acr = [SELECT Id,ContactID,AccountId,Contact.NPS_CCDate__c,Contact.NPS_Eligible__c,Roles FROM AccountContactRelation WHERE ContactId =: conID AND AccountId =: accID];          
        acr.Roles += ';' + 'NPS Contact ONLY';
        update acr; 
        Test.stopTest();       
    }
    
    @isTest
    static void deleteNPSRoleACR(){
        Test.startTest();
        Account a1 = [SELECT Id,Name FROM Account WHERE RecordType.Name Like '%Company' AND Name = 'NPS Survey Account1'];
        Account ac1 = [SELECT Id,Name,NPS_Collection_Status__c,status__c FROM Account WHERE RecordType.Name Like '%Account' AND Name = 'NPS Survey Customer Acc1'];
        Contact c1 = [SELECT Id,LastName,NPS_Survey_Opt_Out__c,Reasons_to_opt_out__c FROM Contact WHERE LastName = 'NPS Contact1'];
        
        Id conID = C1.id;
        Id accID = ac1.id;
        
        AccountContactRelation acr = [SELECT Id,ContactID,AccountId,Contact.NPS_CCDate__c,Contact.NPS_Eligible__c,Roles FROM AccountContactRelation WHERE ContactId =: conID AND AccountId =: accID];          
        delete acr;      
        Test.stopTest();  
    }
    
    @isTest
    static void NPSCon_EvaluationList_SchedTest(){        
        Test.startTest();
        Date month1st = Date.newInstance(Date.today().year(), Date.today().month(), 01);
        NPSContact_Sched nps = new NPSContact_Sched();
        nps.sendNPSEmail(month1st,false,'','');       
        
        NPSContact_Sched nps1 = new NPSContact_Sched();
        String cronExpr = '0 0 0 1 * ? *';
        String jobId = System.schedule('Job Test 2nd Tues Every Month', cronExpr, nps1);
        
        Test.stopTest();
    }
    
    @isTest
    static void NPSCon_DistributionList_SchedTest(){
        
        Test.startTest();
        NPSContactEvalua_OR_DistributionList npsD = new NPSContactEvalua_OR_DistributionList(null,false);
        Database.executeBatch(npsD,10);
        
        NPSContact_Sched nps = new NPSContact_Sched();
        String cronExpr = '0 0 0 14 * ? *';
        String jobId = System.schedule('Job Test 2nd Tues Every Month', cronExpr, nps);
        Test.stopTest();
    }
    
    @isTest
    static void NPSCon_DistributionList_ErrorTest(){
        Datetime minus2months = Datetime.now().addDays(-61);
        Contact c1 = [SELECT Id,LastName,NPS_Survey_Opt_Out__c,Reasons_to_opt_out__c FROM Contact WHERE LastName = 'NPS Contact1'];
        
        NPSContactEvalua_OR_DistributionList.isFinalError = true;
        String npsCon = Label.NPS_Contact_Role;
        AccountContactRelation acr = [SELECT Id,ContactID,AccountId,Contact.NPS_CCDate__c,Contact.NPS_Eligible__c,Roles FROM AccountContactRelation WHERE Roles INCLUDES (:npsCon) LIMIT 1];
        Set<Id> acrtestErrorIds = new Set<Id>();
        acrtestErrorIds.add(acr.Id);
        NPSContactEvalua_OR_DistributionList nps = new NPSContactEvalua_OR_DistributionList(acrtestErrorIds, true);
        nps.acrErrorIds = new Set<Id>{acr.Id};
            Test.setCreatedDate(c1.Id, minus2months);  
        Test.startTest();
        Database.executeBatch(nps);
        
        NPSContactEvalua_OR_DistributionList nps1 = new NPSContactEvalua_OR_DistributionList(null, false);
        NPSContactEvalua_OR_DistributionList.run3rdTime = false;
        nps1.acrErrorIds = new Set<Id>{acr.Id};
            Database.executeBatch(nps1);        
        Test.stopTest();
    }
    
    /*@isTest
static void NPSSurveyRespCreationTest(){

Test.startTest();
String npsCon = Label.NPS_Contact_Role;
AccountContactRelation acr = [SELECT Id,ContactID,AccountId,Contact.NPS_CCDate__c,Contact.NPS_Eligible__c,Roles FROM AccountContactRelation WHERE Roles INCLUDES (:npsCon) LIMIT 1];

NPSSureyResponseCreation.SurveyResponseInput sRI = new NPSSureyResponseCreation.SurveyResponseInput();
sRI.name = 'Test NPS Survey Resp'; sRI.accountId = acr.AccountId; sRI.contactId = acr.ContactId; sRI.surveyedDate = Date.today(); sRI.respURL = 'www.qualtricsTest.com';
List<NPSSureyResponseCreation.SurveyResponseInput> sRIs = new List<NPSSureyResponseCreation.SurveyResponseInput>{sRI};

NPSSureyResponseCreation.createNPSSureyResponse(sRIs);
NPSSureyResponseCreation.createNPSSureyResponse(null);
Test.stopTest();
}*/
    
}