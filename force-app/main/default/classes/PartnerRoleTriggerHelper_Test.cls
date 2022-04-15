/**
* File : PartnerRoleTriggerHelper_Test.cls
* Description : Tests the PartnerRoleTrigger.trigger trigger. 
* Created Date : 27/JAN/2017
* @author : RDC (JY)
*/

@isTest
public with sharing class PartnerRoleTriggerHelper_Test {   

@testSetup static void setupTestData() {
    
     List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
     fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
     fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
     fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
     insert fieldMappings;
     TestDataFactory.getOrgConstants(); 
     TestDataFactory.getTriggerManagers();
     TestDataFactory.createFeatureFlags();
     //insertTriggerSettings();
     insertConnectionSettings();    
     
    Id accRID1= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();   
    Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();  
    Account a1 = new Account(Partner_Account_Status__c='Approved',Agreed_By_Timestamp__c=System.now().addDays(-10),Contract_Signed_Date__c =System.today(),Partner_Level__c='Referral',RecordTypeId= accRID1,Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
    insert a1;
    Account acc= new Account(Partner_Account_Status__c='Approved',Agreed_By_Timestamp__c=System.now().addDays(-7),Contract_Signed_Date__c =system.today().addDays(-1),Partner_Level__c='Reseller',RecordTypeId= accRID,Name='Test Account12345',BillingCountry='India',ShippingCountry='India');
    insert acc; 
    Lead l = new Lead(FirstName = 'Dummy', LastName='Lead', Company = 'Dummy Company',
                      Email = 'dummylead@rackspace.com.test', LeadSource = 'Chat', Lead_Type__c = 'AWS',
                      Focus_Area__c = 'Amazon', Street = 'Church Street', City = 'San Antonio', 
                      State = 'Texas', Country = 'United States', PostalCode = '78023');
    insert l;
      
    Id oppRId= Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('INTL Cloud').getRecordTypeId();  
    Opportunity opty = new Opportunity(AccountId=a1.Id,Skip_Validation__c = true,RecordTypeId=oppRId,Was_a_Partner_Involved__c='Yes',Type='AWS',Name='Test Opport', DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15));
    insert opty;
        
    rvpe__RVAccount__c rva = new rvpe__RVAccount__c(Name = 'Test RV Account', rvpe__ExtAccountId__c = 1234567891, 
                                                    rvpe__Comments__c = 'Just an apex test');
    insert rva;
    
    rvpe__RVMember__c rvm = new rvpe__RVMember__c(Name = 'Test RV Member', rvpe__ExtMemberId__c = 1234554321,
                                                  rvpe__UserName__c = 'testUser', rvpe__RVAccount__c = rva.Id);
    insert rvm;
}

 
 /*public static void insertTriggerSettings() {
        List<Trigger_Manager__c> triggerSettings = new List<Trigger_Manager__c>();
        triggerSettings.add(new Trigger_Manager__c(Name = 'LeadTgr', Is_Active__c = true));
        triggerSettings.add(new Trigger_Manager__c(Name = 'PartnerRoleTgr', Is_Active__c = true));
        triggerSettings.add(new Trigger_Manager__c(Name = 'AttachmentTgr', Is_Active__c = true));
        triggerSettings.add(new Trigger_Manager__c(Name = 'cLogTgr', Is_Active__c = true));
        triggerSettings.add(new Trigger_Manager__c(Name = 'AccountTrigger', Is_Active__c = true));
        insert triggerSettings;
    }*/
    
public static void insertConnectionSettings() {
    List<Connection_Object_Formula_Fields__c> connSettings = new List<Connection_Object_Formula_Fields__c>();
    connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'Attachment_Parent', Field_API_Name__c = 'ParentID'));
    connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'Lead', Field_API_Name__c = 'Old_lead_look_up_Ids__c'));
    connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'Partner_Role__c', Field_API_Name__c = 'Old_Role_look_up_Ids__c'));
    connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'rvpe__RVAccount__c', Field_API_Name__c = 'Lookup_id__c'));
    connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'rvpe__RVMember__c', Field_API_Name__c = 'Lookup_id__c'));
    connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'RV_Compensation_Detail__c', Field_API_Name__c = 'Lookup_id__c'));
    connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'RV_Compensation_Detail__c_Parent', Field_API_Name__c = 'RV_Compensation__c'));
    connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'RV_Compensation__c_Parent', Field_API_Name__c = 'Account__c'));
    connSettings.add(new Connection_Object_Formula_Fields__c(Name = 'Specialist__c', Field_API_Name__c = 'Old_Specialist_look_up_Ids__c'));
    insert connSettings;
}

//method to test the trigger - PartnerRoleTrigger on Partner Role - covers code rather than tests
private static testmethod void testPR1withLead() {
    Lead l = [SELECT Id FROM Lead LIMIT 1];
    Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();  
    Account acc = [SELECT Id FROM Account where Name='Test Account12345' LIMIT 1];
    rvpe__RVAccount__c rva = [SELECT Id FROM rvpe__RVAccount__c LIMIT 1];
    rvpe__RVMember__c rvm = [SELECT Id FROM rvpe__RVMember__c LIMIT 1];
    Test.startTest();
    ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = true; 
    Partner_Role__c role = new Partner_Role__c(Lead__c = l.Id,Partner_Company__c=acc.Id, RV_Account__c = rva.Id, RV_Member__c = rvm.Id, Role__c = 'Source', 
                                        Commission_Role__c = 'Pay Commissions', Justification__c = 'Just a justification');  
                             
    insert role ;
    Partner_Role__c role1 = new Partner_Role__c(Status__c='Approved',Lead__c = l.Id,Partner_Company__c=acc.Id, RV_Account__c = rva.Id, RV_Member__c = rvm.Id, Role__c = 'Source', 
                                        Commission_Role__c = 'Pay Commissions', Justification__c = 'Just a justification');  
                             
    try{insert role1 ;}catch(Exception ex){}
    Test.stopTest();
      
}

 private static testmethod void testPR1withOpportunity() {
    Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
    Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();  
     Account acc = [SELECT Id FROM Account where Name='Test Account12345' LIMIT 1]; 
    rvpe__RVAccount__c rva = [SELECT Id FROM rvpe__RVAccount__c LIMIT 1];
    rvpe__RVMember__c rvm = [SELECT Id FROM rvpe__RVMember__c LIMIT 1];
    Test.startTest();
    ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = true;
     
    Partner_Role__c role =  new Partner_Role__c(Opportunity__c = opp.Id,Partner_Company__c=acc.Id, RV_Account__c = rva.Id, RV_Member__c = rvm.Id, Role__c = 'Source', 
                                    Commission_Role__c = 'Pay Commissions', Justification__c = 'Just a justification');
                                      
    insert role;
    Partner_Role__c role1 = new Partner_Role__c(Status__c='Approved',Opportunity__c = opp.Id,Partner_Company__c=acc.Id, RV_Account__c = rva.Id, RV_Member__c = rvm.Id, Role__c = 'Source', 
                                        Commission_Role__c = 'Pay Commissions', Justification__c = 'Just a justification');  
                             
    try{insert role1 ;}catch(Exception ex){}
    Test.stopTest();
     
}

 private static testmethod void PRwithApprovedStatusofOpp() {
    Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
    Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();  
     Account acc = [SELECT Id FROM Account where Name='Test Account12345' LIMIT 1]; 
    rvpe__RVAccount__c rva = [SELECT Id FROM rvpe__RVAccount__c LIMIT 1];
    rvpe__RVMember__c rvm = [SELECT Id FROM rvpe__RVMember__c LIMIT 1];
    Test.startTest();
    ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = true;
     
    Partner_Role__c role =  new Partner_Role__c(Opportunity__c = opp.Id,Partner_Company__c=acc.Id, RV_Account__c = rva.Id, RV_Member__c = rvm.Id, Role__c = 'Source', 
                                    Commission_Role__c = 'Pay Commissions', Justification__c = 'Just a justification',Status__c='Approved');
                                      
    insert role;
    Test.stopTest();
    delete role;
    undelete role;
    List<Trigger_Manager__c> triggerSettings = new List<Trigger_Manager__c>();
    triggerSettings = [SELECT Id FROM Trigger_Manager__c];
    delete triggerSettings;
    update role;
     
}
private static testmethod void PRwithApprovedStatusofLead() {
    Lead l = [SELECT Id FROM Lead LIMIT 1];
    Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();  
    Account acc = [SELECT Id FROM Account where Name='Test Account12345' LIMIT 1];
    rvpe__RVAccount__c rva = [SELECT Id FROM rvpe__RVAccount__c LIMIT 1];
    rvpe__RVMember__c rvm = [SELECT Id FROM rvpe__RVMember__c LIMIT 1];
    Test.startTest();
    ExternalSharingHelperController.POPULATE_LOOKUP_FIELDS = true;
     
    Partner_Role__c role =  new Partner_Role__c(Lead__c = l.Id,Partner_Company__c=acc.Id, RV_Account__c = rva.Id, RV_Member__c = rvm.Id, Role__c = 'Source', 
                                    Commission_Role__c = 'Pay Commissions', Justification__c = 'Just a justification',Status__c='Approved');
                                      
    insert role;
    Test.stopTest();
    delete role;
    undelete role;
    List<Trigger_Manager__c> triggerSettings = new List<Trigger_Manager__c>();
    triggerSettings = [SELECT Id FROM Trigger_Manager__c];
    delete triggerSettings;
    update role; 
}


}