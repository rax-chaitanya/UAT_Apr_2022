@istest(SeeAllData=true)
public class TermsandConditionsTrigger_Test {
    private static testmethod void afterinsert() { 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User testUserPFC = new User(Alias = 'sgodh', Email='newuser543@testorg.com',
                                    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                    LocaleSidKey='en_US', ProfileId = p.Id,
                                    TimeZoneSidKey='America/Los_Angeles', UserName='testUserPFC@gmail.com');
        
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        system.debug('RecordTypeId@@@@' + RecordTypeId);
        
        Account comp = new Account(RecordTypeId=RecordTypeId, Name = 'Test Shravan', BillingCountry = 'United States',BillingCity='Hyd',BillingState='Alabama',BillingStreet='Test',BillingPostalCode='502319');
        insert comp;
        comp.IsPartner=True;
        Update comp;
        Id ConRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId();

        Contact Con = new Contact (LastName='Test',AccountId=comp.id,RecordTypeId=ConRecordTypeId,Email='Shravangodha@test.com',Phone='9999999999');
        Insert Con;
        Terms_and_Conditions__c TandC = new Terms_and_Conditions__c(Name='Test',Terms_and_Conditions__c='Test',Contact__c=Con.id,I_Accept__c=True);
        Insert TandC;
        TandC.Terms_and_Conditions__c ='Test Test ';
        Update TandC;
        delete TandC;
        
    }
}