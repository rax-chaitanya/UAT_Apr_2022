@isTest
public class ContactHandler_Test {

    @TestSetUp
    static void setDataUp(){
        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
        insert fieldMappings;
        List<BrightTALK__BrightTalk_State_Codes__c> btlkstatecode = new List<BrightTALK__BrightTalk_State_Codes__c>();
        btlkstatecode.add(new BrightTALK__BrightTalk_State_Codes__c(Name = 'Florida', BrightTALK__State_Alpha_2__c = 'FL'));
        insert btlkstatecode;
        TestClassUtility.setTestSetupData();
    }
    
    @isTest
    static void testHandler(){
        
        Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId=Label.Standard_Company_RecordTypeId);
        insert a;
          system.debug(a);
        Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,ShippingCountry='India',RecordTypeId=Label.Account_Prospect_RecordType_Id);
       insert ac;
       system.debug(ac);
         Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id,HasOptedOutOfEmail=false,Btlk_Country__c='United States',Btlk_Sate_Province__c='Florida');
        insert c;
          system.debug('contact' +c);
        c.HasOptedOutOfEmail = true;
        update c;
        //List<AccountContactRole> acrs = [Select id from AccountContactRole where AccountId =: a.id];
        
        //System.assert(acrs.size()>0,true);

List<AccountContactRelation> acrs = [Select id from AccountContactRelation where AccountId =: a.id];
        
       System.assert(acrs.size()>0,true);
        
        delete c;
        undelete c;
    }
}