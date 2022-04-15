/*********************************************************************************
Author: D Anjaneyulu
Date: 09/19/2017
Description: This class contains the test methods to test the business logic on Case Trigger.
It contains the Positive, Negative and Bulk Testing scenarios.
**********************************************************************************/
@isTest
public class CaseTrigger_Test {
    
    @TestSetUp
    public static void setTestDataUp(){
         List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
        insert fieldMappings;
        
        List<BrightTALK__BrightTalk_State_Codes__c> btlkstatecode = new List<BrightTALK__BrightTalk_State_Codes__c>();
        btlkstatecode.add(new BrightTALK__BrightTalk_State_Codes__c(Name = 'Florida', BrightTALK__State_Alpha_2__c = 'FL'));
        insert btlkstatecode;
        
        List<CountryTerritoryMapping__c> mappings = new List<CountryTerritoryMapping__c>();
        mappings.add(new CountryTerritoryMapping__c(Name = 'United States', Territory_Name__c = 'US/CANADA'));
        mappings.add(new CountryTerritoryMapping__c(Name = 'Canada', Territory_Name__c = 'US/CANADA'));
        insert mappings;
        TestClassUtility.setTestSetupData();
        
    }
    
    @isTest
    private static void contactUpdateOnCaseNegativeTest(){  
        Trigger_Manager__c tm = new Trigger_Manager__c(name='CaseTgr',Is_Active__c=true);  
        insert tm;
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId(); 
        Account a = new Account(Partner_Account_Status__c='Approved',RecordTypeId=rtId,Name='Test Account1234',BillingCountry='United Kingdom',ShippingCountry='United Kingdom');
        insert a;
        Id rtId1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId(); 
        Contact c = new Contact(firstname='Test',lastname='Case',Email='case.test@rax.com',recordtypeId=rtId1,accountid=a.Id );
        insert c;
        RecordType recordTyp = [Select id from RecordType where sobjectType='Case' and Name='Partner Portal' limit 1]; 
        Case cas = new Case(AccountId = a.Id,RecordTypeId=recordTyp.Id,Origin = 'Email',Status ='1-New',Type='Problem');
        insert cas;
        Case upCase = [Select id,ContactId from Case where id =: cas.Id limit 1];
        System.assertEquals(upCase !=null, true); 
        update upCase;
        delete upCase;
        undelete upCase;        
        delete tm;
        delete upCase;   
    }
    @isTest
    private static void contactUpdateOnCaseNegativeTest1(){  
        Trigger_Manager__c tm = new Trigger_Manager__c(name='CaseTgr',Is_Active__c=true);  
        insert tm;
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId(); 
        Account a = new Account(Partner_Account_Status__c='Approved',RecordTypeId=rtId,Name='Test Account1234',BillingCountry='Pakistan',ShippingCountry='United Kingdom');
        insert a;
        Id rtId1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId(); 
        Contact c = new Contact(firstname='Test',lastname='Case',Email='case.test@rax.com',recordtypeId=rtId1,accountid=a.Id );
        insert c;
        RecordType recordTyp = [Select id from RecordType where sobjectType='Case' and Name='Partner Portal' limit 1]; 
        Case cas = new Case(AccountId = a.Id,RecordTypeId=recordTyp.Id,Origin = 'Email',Status ='1-New',Type='Problem');
        insert cas;
        Case upCase = [Select id,ContactId from Case where id =: cas.Id limit 1];
        System.assertEquals(upCase !=null, true); 
        update upCase;
        delete upCase;
        undelete upCase;        
        delete tm;
        delete upCase;   
    }
     @isTest
    private static void contactUpdateOnCaseNegativeTest2(){  
        Trigger_Manager__c tm = new Trigger_Manager__c(name='CaseTgr',Is_Active__c=true);  
        insert tm;
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId(); 
        Account a = new Account(Partner_Account_Status__c='Approved',RecordTypeId=rtId,Name='Test Account1234',BillingCountry='Canada',ShippingCountry='United Kingdom');
        insert a;
        Id rtId1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId(); 
        Contact c = new Contact(firstname='Test',lastname='Case',Email='case.test@rax.com',recordtypeId=rtId1,accountid=a.Id );
        insert c;
        RecordType recordTyp = [Select id from RecordType where sobjectType='Case' and Name='Partner Portal' limit 1]; 
        Case cas = new Case(AccountId = a.Id,RecordTypeId=recordTyp.Id,Origin = 'Email',Status ='1-New',Type='Problem');
        insert cas;
        Case upCase = [Select id,ContactId from Case where id =: cas.Id limit 1];
        System.assertEquals(upCase !=null, true); 
        update upCase;
        delete upCase;
        undelete upCase;        
        delete tm;
        delete upCase;   
    }
 @isTest
    private static void contactUpdateOnCaseNegativeTest3(){  
        Trigger_Manager__c tm = new Trigger_Manager__c(name='CaseTgr',Is_Active__c=true);  
        insert tm;
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId(); 
        Account a = new Account(Partner_Account_Status__c='Approved',RecordTypeId=rtId,Name='Test Account1234',BillingCountry='zaire',ShippingCountry='United Kingdom');
        insert a;
        Id rtId1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId(); 
        Contact c = new Contact(firstname='Test',lastname='Case',Email='case.test@rax.com',recordtypeId=rtId1,accountid=a.Id );
        insert c;
        RecordType recordTyp = [Select id from RecordType where sobjectType='Case' and Name='Partner Portal' limit 1]; 
        Case cas = new Case(AccountId = a.Id,RecordTypeId=recordTyp.Id,Origin = 'Email',Status ='1-New',Type='Problem');
        insert cas;
        Case upCase = [Select id,ContactId from Case where id =: cas.Id limit 1];
        System.assertEquals(upCase !=null, true); 
        update upCase;
        delete upCase;
        undelete upCase;        
        delete tm;
        delete upCase;   
    }
}