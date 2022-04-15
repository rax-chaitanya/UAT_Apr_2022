@isTest
public class OppNutcaseGraphController_Test {

@TestSetUp
    static void setDataUp(){
        TestClassUtility.setTestSetupData();
        
        Account acc = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India', RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert acc;
        
      Account custAcc = new Account(Name='Test Custom Account', Company_Name__c=acc.Id,ShippingCountry = 'India', RecordTypeId = Label.Account_Prospect_RecordType_ID);
        insert custAcc; 
        
        Contact con = new Contact(firstname='Rackspace', LastName='Test Contact', AccountId=acc.id);
        insert con; 
        
        Opportunity opp = new Opportunity(Name='Test Opportunity', Cash_Points__c='1',AccountId=acc.Id, DDI__c='12345655', StageName='Stage 1 - Planning & Identification', CloseDate=System.today().addDays(15), Was_a_Partner_Involved__c='Yes', Type='AWS');
        insert opp;
        String pId = [select id,name from Profile where name='System Administrator' limit 1].id;
        User splitUser = new User(firstname='Test', LastName='SplitUser', Alias = 'standt', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', SSO_Username__c='user123',
                                  Region__c='US',LocaleSidKey='en_US', ProfileId = pId, TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com',FederationIdentifier='4566sfs');
        insert splitUser;        
    }
private static testmethod void OppNutcaseGraphControllerTest() {
        Opportunity opp = [SELECT id, OwnerId,Name,DDI__c,Cash_Points__c FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];
        FieldMapping__c  scust = new FieldMapping__c(CompName__c='ONGC',SourceField__c='Cash',TargetField__c='Cash_Points__c',Name='test');
        insert scust;
        List<string> str = new list<string>();
        str.add('test');
        Apexpages.StandardController sc = new Apexpages.StandardController(opp);
        OppNutcaseGraphController ext = new  OppNutcaseGraphController(sc); 
        ext.getInt('Cash_Points__c');
        ext.barColors = str;   
        ext.getXToYMap(); 
        ext.getbarColorString();
        OppNutcaseGraphController.Data  ext1 = new  OppNutcaseGraphController.Data('Nam',1); 
        ext.getData();
   }  
    
}