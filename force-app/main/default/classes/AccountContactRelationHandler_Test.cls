@isTest(seeAllData = false)

public class AccountContactRelationHandler_Test{
    @TestSetUp
    static void setDataUp(){
        TestClassUtility.setTestSetupData();
        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
        insert fieldMappings;
        
    }
    
    
    
    @isTest
    static void accountContactRoleTest1(){
    Trigger_Manager__c Tm = new Trigger_Manager__c (Name ='AccountContactRelation',Is_Active__c = true);
    insert Tm;
     Id devRecordTypeId3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
     Id condevRecordTypeId3 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account').getRecordTypeId();
        Account a = new Account(RecordTypeId =devRecordTypeId3,Name='Test Account1234',BillingCountry='Australia',ShippingCountry='Australia',Partner_Account_Status__c='Approved');
        insert a;
         Account a1 = new Account(RecordTypeId =devRecordTypeId3,Name='Test Account12345',BillingCountry='Australia',ShippingCountry='Australia',Partner_Account_Status__c='Approved');
        insert a1;
        Contact c = new Contact(RecordTypeId =condevRecordTypeId3,firstname='Test Contact',LastName='Test Last',AccountId=a1.id,mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California');
        insert c;
        Account ac = new Account(RecordTypeId =devRecordTypeId,Name='Test C Account',Company_Name__c=a.Id,DDI__c='123456');
        insert ac;
      
        AccountContactRelation acr2=new AccountContactRelation(Contactid=c.id,Roles='Billing',Accountid=ac.id);
        insert acr2;
        AccountContactRelation acr=[select id,roles,contactid from AccountContactRelation where Accountid=:ac.id Limit 1];
       acr.roles='Billing';
        update acr;
}
 @isTest
    static void accountContactRoleTest1_Update(){
    Trigger_Manager__c Tm = new Trigger_Manager__c (Name ='AccountContactRelation',Is_Active__c = true);
    insert Tm;
     Id devRecordTypeId3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
     Id condevRecordTypeId3 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account').getRecordTypeId();
        Account a = new Account(RecordTypeId =devRecordTypeId3,Name='Test Account1234',BillingCountry='Australia',ShippingCountry='Australia',Partner_Account_Status__c='Approved');
        insert a;
        Account a1 = new Account(RecordTypeId =devRecordTypeId3,Name='Test Account12345',BillingCountry='Australia',ShippingCountry='Australia',Partner_Account_Status__c='Approved');
        insert a1;
        Contact c = new Contact(RecordTypeId =condevRecordTypeId3,firstname='Test Contact',LastName='Test Last',AccountId=a1.id,mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California');
        insert c;
        Account ac = new Account(RecordTypeId =devRecordTypeId,Name='Test C Account',Company_Name__c=a.Id,DDI__c='123456');
        insert ac;
      
        AccountContactRelation acr2=new AccountContactRelation(Contactid=c.id,Roles='Billing',Accountid=ac.id);
        insert acr2;
        
        update acr2;
}
@isTest
    static void accountContactRoleTest1Delete(){
    Trigger_Manager__c Tm = new Trigger_Manager__c (Name ='AccountContactRelation',Is_Active__c = true);
    insert Tm;
     Id devRecordTypeId3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
     Id condevRecordTypeId3 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account').getRecordTypeId();
        Account a = new Account(RecordTypeId =devRecordTypeId3,Name='Test Account1234',BillingCountry='Australia',ShippingCountry='Australia',Partner_Account_Status__c='Approved');
        insert a;
        Account a1 = new Account(RecordTypeId =devRecordTypeId3,Name='Test Account12345',BillingCountry='Australia',ShippingCountry='Australia',Partner_Account_Status__c='Approved');
        insert a1;
        Contact c = new Contact(RecordTypeId =condevRecordTypeId3,firstname='Test Contact',LastName='Test Last',AccountId=a1.id,mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California');
        insert c;
        Account ac = new Account(RecordTypeId =devRecordTypeId,Name='Test C Account',Company_Name__c=a.Id,DDI__c='123456');
        insert ac;
      
        AccountContactRelation acr2=new AccountContactRelation(Contactid=c.id,Roles='Billing',Accountid=ac.id);
        insert acr2;
        
        update acr2;
        Delete acr2;
}
@isTest static void ACRUpdateTest3(){
            Trigger_Manager__c Tm = new Trigger_Manager__c (Name ='AccountContactRelation',Is_Active__c = true);
            insert Tm;
            Id devRecordTypeId3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();   
            Id condevRecordTypeId3 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId();  
            Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account').getRecordTypeId();
            Account a = new Account(RecordTypeId =devRecordTypeId3,Name='Test Account1234',BillingCountry='Australia',ShippingCountry='Australia',Partner_Account_Status__c='Approved');
            insert a;
             Account a1 = new Account(RecordTypeId =devRecordTypeId3,Name='Test Account12345',BillingCountry='Australia',ShippingCountry='Australia',Partner_Account_Status__c='Approved');
            insert a1;
            Contact c = new Contact(RecordTypeId =condevRecordTypeId3,firstname='Test Contact',LastName='Test Last',AccountId=a1.id,mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California');
            insert c;
            Contact c2 = new Contact(RecordTypeId =condevRecordTypeId3,firstname='Test Contact',LastName='Test Last',AccountId=a1.id,mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California');
            insert c2;
    		Contact c5 = new Contact(RecordTypeId =condevRecordTypeId3,firstname='Test Contact1',LastName='Test Last1',AccountId=a1.id,mailingpostalcode='23245',Mailingcity='Test1',MailingStreet='Test1',Mailingcountry='United States',mailingstate='California');
            insert c5;
            Account ac = new Account(RecordTypeId =devRecordTypeId,Name='Test C Account',Company_Name__c=a.Id,DDI__c='123456');
            insert ac;
            
            AccountContactRelation acr1=new AccountContactRelation(Contactid=c.id,Accountid=ac.id,Roles='Primary Contact');
            acr1.roles='Billing';
    		//AccountContactRelation acr5=new AccountContactRelation(Contactid=c5.id,Accountid=ac.id,Roles='Billing');
            //acr5.roles='NPS Contact ONLY';
       		//update acr1;
       		
     		//Delete acr1;
}
            
           
              
            

@isTest static void ACRUpdateRoleTest(){
            Trigger_Manager__c Tm = new Trigger_Manager__c (Name ='AccountContactRelation',Is_Active__c = true);
            insert Tm;
            Id devRecordTypeId3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();   
            Id condevRecordTypeId3 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId();  
            Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account').getRecordTypeId();
            Account a = new Account(RecordTypeId =devRecordTypeId3,Name='Test Account1234',BillingCountry='Australia',ShippingCountry='Australia',Partner_Account_Status__c='Approved');
            insert a;
             Account a1 = new Account(RecordTypeId =devRecordTypeId3,Name='Test Account12345',BillingCountry='Australia',ShippingCountry='Australia',Partner_Account_Status__c='Approved');
            insert a1;
            Contact c = new Contact(RecordTypeId =condevRecordTypeId3,firstname='Test Contact',LastName='Test Last',AccountId=a1.id,mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California');
            insert c;
            Contact c2 = new Contact(RecordTypeId =condevRecordTypeId3,firstname='Test Contact',LastName='Test Last',AccountId=a1.id,mailingpostalcode='2324',Mailingcity='Test',MailingStreet='Test',Mailingcountry='United States',mailingstate='California');
            insert c2;
            Account ac = new Account(RecordTypeId =devRecordTypeId,Name='Test C Account',Company_Name__c=a.Id,DDI__c='123456');
            insert ac;
List<AccountContactRelation> listACRs = new List<AccountContactRelation>();
            
            AccountContactRelation acr1=new AccountContactRelation(Contactid=c.id,Accountid=ac.id,Roles='Primary Contact');
    listACRs.add(acr1);
            //insert acr1;
    Test.startTest();
    try{
                AccountContactRelation acr2=new AccountContactRelation(Contactid=c2.id,Accountid=ac.id,Roles='Primary Contact');
          listACRs.add(acr2);
            //insert acr2;
            Database.insert(listACRs);

    } catch (Exception e)
        
    {
        System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      //  system.debug( 'e.getMessage()   '+e.getMessage());
      //  Boolean expectedExceptionThrown =  e.getMessage().contains('You can not create more than one Primary Account Contact Relationship') ? true : false;
      //  system.debug( 'expectedExceptionThrown   '+expectedExceptionThrown);
		//System.AssertEquals(expectedExceptionThrown,false );

    }
    
   
  
            User u=[Select id from User where id=:Label.FMW_API_User];
            
            System.runAs(u){  

                AccountContactRelation acr3=new AccountContactRelation(id=acr1.id,Contactid=c2.id,Accountid=ac.id,Roles='Primary Contact');
                update acr3;
            }
     Test.stopTest();
}


}