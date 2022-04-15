@isTest
public class OppBucketFieldsHandler_Test { 
  
    @TestSetUp
    static void setDataUp(){
     
        TestClassUtility.setTestSetupData();
        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
        insert fieldMappings;
   }
    
    private static testmethod void testOppBucketFields1() {
  
       
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' Limit 1]; 
        UserRole ur = new UserRole(Name = 'US LDT');
        insert ur;
        User u = new User(Alias = 'standt', Email='testuserOppBucket@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='testuserOppBucket@testorg.com',UserRoleId=ur.id);
        Insert u;
        
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();

        List<Partner_Role__c> prole = new List<Partner_Role__c>();
        Opportunity opty = new Opportunity();
        
        System.runAs(u)
        {
          Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a;

        Account acc = new Account(Name='Test Account',recordtypeid = RecordTypeIdAcc,Partner_Account_Status__c = 'Approved',BillingCountry='India',ShippingCountry='India');
        insert acc;
       
        Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id, BillingCountry = 'India', ShippingCountry = 'Canada', RecordTypeId = Label.Account_Prospect_RecordType_ID);
        insert ac; 
        
        campaign camp = new campaign(Name='Test Campaign',Status='In Progress',isActive=true,Region__c = 'Asia', Activity__c= 'Online',Channel__c= 'Content');
        insert camp;
         test.startTest();
        opty = new Opportunity(Name='Test Opport',campaignId=camp.id,LeadSource= 'Call In',Market_Source__c='Yes',Type='Azure',AccountId=a.Id,Account__c=ac.id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',LDT_Rep__c=u.id,CloseDate=System.today().addDays(15));
        insert opty;
       
      
        prole.add(New Partner_Role__c(Status__c='Approved',Partner_Company__c=acc.id,Justification__c='Test Source',Role__c='Source',Opportunity__c=opty.id));
            
        //prole.add(New Partner_Role__c(Status__c='Approved',Partner_Company__c=acc.id,Justification__c='Test Influence',Role__c='Influence',Opportunity__c=opty.id,RV_Account__c=rv.id,RV_Member__c=rvm.id));
         Insert prole;
         
         prole[0].Status__c='Approved';
        
        
         update prole[0];
            
            test.stopTest();
         }

  }
    public static testmethod void updateOldOppBucketRec(){
        test.startTest();
        LeadSource_for_Bucket__c ledSrc = new LeadSource_for_Bucket__c();
        ledSrc.Name = 'Call In';
        ledSrc.lead_source__c = 'Call In';
        Insert ledSrc;
     
        Roles_BucketSource__c bktRoles = new Roles_BucketSource__c();
        bktRoles.name = 'US LDT';
        bktRoles.User_Role__c = 'US LDT';
        Insert bktRoles;
        SDR_Profiles_for_bktSrc__c sdrRole = new SDR_Profiles_for_bktSrc__c();
        sdrRole.name = 'System Administrator';
        sdrRole.sdr_Profile__c = 'System Administrator';
        insert sdrRole;
        
       
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();

        List<Partner_Role__c> prole = new List<Partner_Role__c>();
        Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert a;
        
        Account acc = new Account(Name='Test Account',recordtypeid = RecordTypeIdAcc,Partner_Account_Status__c = 'Approved',BillingCountry='India',ShippingCountry='India');    
        insert acc;
        
         Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id, BillingCountry = 'India', ShippingCountry = 'Canada', RecordTypeId = Label.Account_Prospect_RecordType_ID);
        insert ac;
        
        campaign camp = new campaign(Name='Test Campaign',Status='In Progress',isActive=true,Region__c = 'Asia', Activity__c= 'Online',Channel__c= 'Content');
        insert camp;
        
        Opportunity opty = new Opportunity(campaignId=camp.id,LeadSource= 'Call In',Market_Source__c='Yes',Type='Azure',Name='Test Opport',Account__c=ac.id,AccountId=a.Id,StageName='Closed Won',CloseDate=System.today().addDays(15));
        insert opty;
        prole.add(New Partner_Role__c(Status__c='Approved',Partner_Company__c=acc.id,Justification__c='Test Source',Role__c='Source',Opportunity__c=opty.id));
        Insert prole;
        
        test.stopTest();
       

    }

}