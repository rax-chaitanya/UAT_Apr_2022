@isTest
public class CompanyProfileController_Test {   
    private static testmethod void CompanyProfileControllerTest(){ 
        Test.startTest();
        List<Trigger_Manager__c> settings = new List<Trigger_Manager__c>();
        settings.add(new Trigger_Manager__c(name='CompanyTrigger',Is_Active__c=false));
        settings.add(new Trigger_Manager__c(name='AccountTrigger',Is_Active__c=false));
        settings.add(new Trigger_Manager__c(name='ContactTgr',Is_Active__c=false));
        settings.add(new Trigger_Manager__c(name='OpportunitySplitTgr',Is_Active__c=false));
        
        insert settings;

        Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        Id conRID= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        Account a1 = new Account(Contract_Type__c='Agent Channel Agreement',Partner_Account_Status__c='Approved',Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =system.today(),Partner_Level__c='Reseller',RecordTypeId= accRID,Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert a1;
        Contact c = new Contact(RecordTypeId= conRID,firstname='Test Contact',LastName='Test Last',AccountId=a1.id,Email = System.now().millisecond() + 'test@test.com');
        insert c;
        a1.Primary_Member__c = c.Id;
        update a1;
        Lead l = new Lead(firstname='asdasd',lastname='fssdfgsfd',company='Test compansdfdsfy',Partner_Company__c=a1.Id,
                                  Phone='932541678',email='test.test@test.com',LeadSource='Partner Network',Lead_Type__c='AWS',
                                 Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',HasOptedOutOfEmail=false,
                                  country='India',postalcode='560037',Campaign_Interest__c='E&A Cart');    
        insert l;
        l.Status = 'Sales - Accepted Lead';
        update l;
        database.leadConvert lc = new database.leadConvert();
        lc.setLeadId(l.id);
        leadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        //lc.setOpportunityName('Test compansdfdsfy-Opp');
        lc.setDoNotCreateOpportunity(TRUE);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        CompanyProfileController.getLeadData(a1.Id);        
        CompanyProfileController.getLeadData(null);
               
        Opportunity opty = new Opportunity(Partner_Company__c=a1.Id,Category__c='New Logo',Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport',DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15));
        insert opty;
        Partner_Role__c pr = new Partner_Role__c(Role__c='Source',Opportunity__c=opty.Id,Partner_Company__c=a1.Id);
        insert pr;
        CompanyProfileController.getOpportunityDeta(a1.Id);
        CompanyProfileController.checkPrimary();
        CompanyProfileController.getCompanyProfile();        
        CompanyProfileController.getPickListValuesIntoList('Account', 'BillingCountryCode','Partner_Solution__c', 'Partner_Product__c', 'Industry' );
        CompanyProfileController.getPickListValues('Account', 'Membership_Level__c', 'MemberShipLevel');
        CompanyProfileController.setCompanyProfile('test description 222','Networking','MySQL','Consumer Goods','India',a1);        
        CompanyProfileController.getAllFiles();
        Test.stopTest();
    }    
}