@isTest(seeAllData=true)
public class RunAssignmentRules_Test{

@isTest
    private static void contactUpdateOnCaseNegativeTest(){  
         
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId(); 
        Account a = new Account(Partner_Account_Status__c='Approved',RecordTypeId=rtId,Name='Test Account1234',BillingCountry='United Kingdom',ShippingCountry='United Kingdom');
        insert a;
        rvpe__RVAccount__c rvAccount = TestClassUtility.createRVAccounts(1,123456)[0];
        insert rvAccount;
        rvpe__RVMember__c rvMember = TestClassUtility.createRvMembers(1)[0];
        rvMember.rvpe__RVAccount__c = rvAccount.Id;
        rvMember.rvpe__Email__c = 'case.test123@rax.com';
        insert rvMember;
        Id rtId1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Government').getRecordTypeId(); 
        Contact c = new Contact(firstname='Test',lastname='Case',Email='case.test@rax.com',recordtypeId=rtId1 );
        insert c;
        
        RecordType recordTyp = [Select id from RecordType where sobjectType='Case' and Name='Partner Portal' limit 1]; 
        Case cas = new Case(AccountId = a.Id,RecordTypeId=recordTyp.Id,rvpe__RVAccount__c=rvAccount.id,rvpe__RVMember__c = rvMember.Id,Origin = 'Email',Status ='1-New',Type='Problem');
        insert cas;
        Lead l = new Lead(firstname='Testfirst',lastname='lastname',company='Test company',
                          email='test.test@test.com',LeadSource='Chat',Lead_Type__c='AWS',
                         Focus_Area__c='Amazon',street='Marathalli',city='Bangalore',State='Karnataka',
                          country='India',postalcode='560037');
        insert l;
       RunAssignmentRules.runAssignmentRules(new List<id>{cas.Id});    
       RunAssignmentRules.runLeadAssignmentRules(new Set<Id>{l.Id});
       RunAssignmentRules.runLeadTerritoryAssignmentRules(new List<Lead>{l});
    }
}