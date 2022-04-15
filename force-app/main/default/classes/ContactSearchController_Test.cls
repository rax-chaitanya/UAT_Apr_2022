@isTest(SeeAllData = true)
public with sharing class ContactSearchController_Test {
static testmethod void Contacttest()
    {

        
        
        
        Account acc = TestDataHelper.createTestCompany();
        insert acc;
        
        Contact con = TestDataHelper.createTestContact(); 
        con.accountid = acc.id;
        insert con;
        
        Lead l = TestDataHelper.createTestLeads(1).get(0);
        l.focus_Area__c='Amazon';
        insert l;
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(con);
        contactSearchController c = new contactSearchController();
        c.getContactsMapSize();
        c.createContactShare();
        c.showPage();
        contactSearchController c1 = new contactSearchController(sc1);
        c1.searchRecords();
        c1.companyName = 'Test Account';
        c1.firstName = 'test';
        c1.lastName = 'test';
        c1.email = 'test@testdata.com';
        c1.searchRecords();
        c1.currentPageURL = '/'+acc.id;
        c1.cancel();
    }
    
}