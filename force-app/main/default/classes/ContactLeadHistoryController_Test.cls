/**
 * @description       : SFDC Case #00058275
 * @author            : Atheer Bdaiwi
 * @group             : 
 * @last modified on  : 04-28-2021
 * @last modified by  : Atheer Bdaiwi
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   04-19-2021   Atheer Bdaiwi   Initial Version
**/

@isTest
public with sharing class ContactLeadHistoryController_Test {
    // the unit test - we need to convert a Lead to test properly
    @isTest
    public static void test() {

        TestClassUtility.setTestSetupData();
        LeadRelatedList_Test.insertFieldMapings(); 
        LeadRelatedList_Test.insertCountryTerritoryMapping();  

        // Lead l = new Lead(FirstName = 'Test', LastName = 'Test', Territory__c = 'ANZ', Country = 'Australia', Company = 'Test', Email = 'test@test.com');
        Lead l = new Lead(firstname='asdasd123',lastname='fssdfgsfd123',company='Test123 compansdfdsfy',
        email='test.test@test.com.asda',LeadSource='Site Submission',Lead_Type__c='AWS',
        Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',country='United Kingdom',State='Kent',
        postalcode='56037',status='New',phone='9090909090',
        Campaign_Interest__c='E&A Cart');

        insert l;
        l.Status = 'Sales - Accepted Lead';
        update l;

        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(l.Id);
        
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);         
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        Contact contact = [select Id from Contact where Id = :lcr.getContactId() limit 1];        
        PageReference pr = Page.ContactLeadHistory;        
        Test.setCurrentPage(pr);
        
        ContactLeadHistoryController c = new ContactLeadHistoryController(new ApexPages.StandardController(contact));
        system.assertEquals(c.convertedLead.Id, l.Id);
        system.assertNotEquals(null, c.leadHistory);
    }
}