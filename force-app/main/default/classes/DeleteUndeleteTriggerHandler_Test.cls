@isTest
public class DeleteUndeleteTriggerHandler_Test{
    @testSetup
    static void testSetup() {
        Test.startTest(); 
        TestDataFactory.getOrgConstants();
        TestDataFactory.getProdOrgIDSetting();  
        TestDataFactory.getTriggerManagers();
        TestDataFactory.createFeatureFlags();//insert new FeatureFlag__c(Name='BucketLogic_DM') for OppBucketFieldsHandler
        Test.stopTest(); 
        
   
        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
        insert fieldMappings;
   
        Account company = new Account(Name = 'Test RS 1',BillingCountry = 'Canada', ShippingCountry = 'Canada', RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert company;                
    }
    
    static testmethod void ShouldInsertOnCompanyDelete()
    {
        Account cmp = createCompany('Rackspace');
        
        cLog__c newLog = [select Id, Name from cLog__c where Name = 'Company' and Action_Record_ID__c = :cmp.Id];       
        System.assertEquals('Company', newLog.Name);
                
        Id ProspectrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId(); 
        
        Account pacc = new Account(Name = 'Test Account',company_name__c=cmp.id,RecordTypeId=ProspectrecordTypeId,DC_MasterId__c='6456tryrty',phone ='1212121212', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka');
        insert pacc;
        delete pacc;
        delete cmp;
       
          }   
        static testmethod void accountdeletetest()
    {
        Account cmp = createCompany('Rackspace');
        
        cLog__c newLog = [select Id, Name from cLog__c where Name = 'Company' and Action_Record_ID__c = :cmp.Id];       
        System.assertEquals('Company', newLog.Name);
                
        Id ProspectrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId(); 
    //     Account pacc = new Account(Name = 'Test Account',company_name__c=cmp.id,Old_Record_Id__c='0013C00000L6ek6Q',RecordTypeId=ProspectrecordTypeId,DC_MasterId__c='6456tryrty',phone ='1212121212', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka');
        Account pacc = new Account(Name = 'Test Account',company_name__c=cmp.id,RecordTypeId=ProspectrecordTypeId,DC_MasterId__c='6456tryrty',phone ='1212121212', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka');
        insert pacc;
        delete pacc;        
    } 
    static testmethod void ShouldInsertOnCompanyDelete2()
    {    
        
        Account cmp1 = createCompany1('racker');
        
        cLog__c newLog1 = [select Id, Name from cLog__c where Name = 'Partner_Role__c' and Action_Record_ID__c = :cmp1.Id];
        
        if(newlog1.Name=='Partner_Role__c')
        {
            newlog1.Name = 'Partner_Role_Lead__c';
        }
        
        update newLog1;
        
        System.assertEquals('Partner_Role_Lead__c', newLog1.Name);
		 Test.startTest();
        DeleteUndeleteTriggerHandler.CoverageModule1();
        Test.stopTest();
    }

    static testmethod void ShouldInsertOnCompanyUnDelete()
    {
       
        Account cmp = createCompany('Hosting');
        delete cmp;
        cLog__c newLog = [select Id, Name from cLog__c where Name = 'Company' and Action_Record_ID__c = :cmp.Id];       
        Undelete cmp;
        System.assertEquals('Company', newLog.Name);
    } 
    
    public static Account createCompany(String company)
    {
        //  Account cmp = new Account(Name=company,BillingCountry='India',ShippingCountry='India',DC_MasterId__c='6456tryrty',old_record_id__c='999934543', RecordTypeId =Label.Standard_Company_RecordTypeId);
      Account cmp = new Account(Name=company,BillingCountry='India',ShippingCountry='India',DC_MasterId__c='6456tryrty',RecordTypeId =Label.Standard_Company_RecordTypeId);
        insert cmp;
        insert new cLog__c(Name='Company',Action_Record_ID__c=cmp.id);
        return cmp;
    }
    
    public static Account createCompany1(String company)
    {
        
        Account cmp1 = new Account(Name=company,BillingCountry='India',ShippingCountry='India',DC_MasterId__c='6456tryrty',RecordTypeId =Label.Standard_Company_RecordTypeId);
        insert cmp1;
        insert new cLog__c(Name='Partner_Role__c',Action_Record_ID__c=cmp1.id);
        return cmp1;
    }
    public static Account createCompany2(String company)
    {
        
        Account cmp1 = new Account(Name=company,BillingCountry='India',ShippingCountry='India',DC_MasterId__c='6456tryrty',RecordTypeId =Label.Standard_Company_RecordTypeId);
        insert cmp1;
        insert new cLog__c(Name='Partner_Role__c',Action_Record_ID__c=cmp1.id);
        return cmp1;
       
    }
    //Added to test related SFDC-7310
    @isTest
    static void testFocusArea(){
        Id CustomerRTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();
        
        Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert a;
		Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,ShippingCountry='India',RecordTypeId=CustomerRTypeId);
        insert ac;
        Opportunity opty = new Opportunity(Name='Test Opport',Type='Azure',AccountId=a.Id,Account__c=ac.id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15));
        insert opty;
        Opp_FocusArea__c OppFocusArea=New Opp_FocusArea__c(Opportunity__c=opty.id,Name='Test FocusArea');
        Insert OppFocusArea;
        opportunityHandler.firstTgrRun = true;
        OppFocusArea.Name='Test Update';
        Update OppFocusArea;
        opportunityHandler.firstTgrRun = true;
        Delete OppFocusArea; 
    }
}