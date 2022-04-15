/**
 * File : AttachmentTriggerHelper_Test.cls
 * Description : Tests the AttachmentTrigger.trigger trigger. 
 * Created Date : 27/JAN/2017
 * @author : RDC (JY)
 */

@isTest
public with sharing class AttachmentTriggerHelper_Test {    
    
    @testSetup static void setupTestData() {
        
        insertTriggerSettings();
        insertConnectionSettings();     
        
        Lead l = new Lead(FirstName = 'Dummy', LastName='Lead', Company = 'Dummy Company',
                          Email = 'dummylead@rackspace.com.test', LeadSource = 'Chat', Lead_Type__c = 'AWS',
                          Focus_Area__c = 'Amazon', Street = 'Church Street', City = 'San Antonio', 
                          State = 'Texas', Country = 'United States', PostalCode = '78023');
        insert l;
        
        Partner_Role__c pr = new Partner_Role__c(Lead__c = l.Id, Role__c = 'Influence',Justification__c='Testing the Justification');
        insert pr;
    }
    
    public static void insertTriggerSettings() {
        List<Trigger_Manager__c> triggerSettings = new List<Trigger_Manager__c>();
        triggerSettings.add(new Trigger_Manager__c(Name = 'LeadTgr', Is_Active__c = true));
        triggerSettings.add(new Trigger_Manager__c(Name = 'PartnerRoleTgr', Is_Active__c = true));
        triggerSettings.add(new Trigger_Manager__c(Name = 'AttachmentTgr', Is_Active__c = true));
        insert triggerSettings;
        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
        insert fieldMappings;
    }
    
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
    
    //method to test the trigger - AttachmentTrigger on Attachment
    private static testmethod void testAttachment1() {      
        Partner_Role__c pr = [SELECT Id FROM Partner_Role__c LIMIT 1];
        Test.startTest();
        Attachment att = new Attachment(Name = 'Att1', ParentId = pr.Id, Body = Blob.valueOf('Sample attachment'), isPrivate = false);
        insert att;
        Test.stopTest();
        Partner_Role__c pr1 = [SELECT Id, Has_Attachment__c, Status__c FROM Partner_Role__c WHERE Id = :pr.Id];
        System.assertEquals(pr1.Has_Attachment__c, TRUE);
        System.assertEquals(pr1.Status__c, 'Approved');
    }
    
    //method to cover the remaining empty place holder methods from handler
    private static testmethod void testAttachment2() {      
        Partner_Role__c pr = [SELECT Id FROM Partner_Role__c LIMIT 1];
        Attachment att = new Attachment(Name = 'Att1', ParentId = pr.Id, Body = Blob.valueOf('Sample attachment'), isPrivate = false);
        insert att;
        Test.startTest();
        update att;
        delete att;
        undelete att;
        List<Trigger_Manager__c> triggerSettings = new List<Trigger_Manager__c>();
        triggerSettings = [SELECT Id FROM Trigger_Manager__c];
        delete triggerSettings;
        update att;
        Test.stopTest();
    }
}