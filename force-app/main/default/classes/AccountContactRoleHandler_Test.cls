@isTest
public class AccountContactRoleHandler_Test{
    @TestSetUp
    static void setDataUp(){
        List<Trigger_Manager__c> tms = new List<Trigger_Manager__c>();
            tms.add( new Trigger_Manager__c(name='ContactTgr',Is_Active__c=true));
            tms.add( new Trigger_Manager__c(name='AcrTgr',Is_Active__c=true));
    		tms.add( new Trigger_Manager__c (Name ='AccountContactRelation',Is_Active__c = true));
        insert tms;

        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
            fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
            fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
            fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
        insert fieldMappings;
    }
    @isTest
    static void accountContactRoleTest1(){
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
      
        User u=[Select id from User where id=:Label.FMW_API_User];
		System.runAs(u){  
        
            AccountContactRelation acr2=new AccountContactRelation(Contactid=c.id,Roles='Billing',Accountid=ac.id);
            insert acr2;
            AccountContactRelation acr=[select id,roles,contactid from AccountContactRelation where Accountid=:ac.id Limit 1];
           acr.roles='Billing';
            update acr;
        }
}
    
    @isTest
    static void accountContactRoleTest(){
        Account a1 = new Account(name='TestAccount',BillingCountry='India',ShippingCountry='India');
        insert a1;
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a1.id);
        insert c;
        Accounts__c a = new Accounts__c(Name='Custom Account',Company_Name__c=a1.id,Shipping_Country__c='India');
        insert a;
        
                List<Accounts__c> accList = new List<Accounts__c>();
                accList.add(new Accounts__c(Name = 'testComp', Company_Name__c = a1.Id, Shipping_Country__c = 'United States', 
                                            Menu_Pricing_Approved__c = TRUE,DDI__c='1234'));
                insert accList;
        List<Account_Contact_Role__c> acrlist = new List<Account_Contact_Role__c>();
        Account_Contact_Role__c acr= new Account_Contact_Role__c(Account__c=a.id,Contact__c=c.id,Role__c='Technical');
        insert acr;
        acrlist.add(new Account_Contact_Role__c(Account__c=a.id,Contact__c=c.id,Role__c='Abuse'));
        acrlist.add(new Account_Contact_Role__c(Account__c=a.id,Contact__c=c.id,Role__c='Billing'));
        
        insert acrlist;
        ExternalSharingHelperController.ELIMINATE_DUPLICATE_CONTACT_ROLES = true;
        update acrlist;
        ExternalSharingHelperController.ELIMINATE_DUPLICATE_CONTACT_ROLES = true;
        delete acrlist;
        undelete acrlist;
        try{
            insert new Account_Contact_Role__c(Account__c=a.id,Contact__c=c.id,Role__c='Abuse');
        }catch(Exception e){
             System.assertEquals((e.getMessage().contains('added twice with the same role')),true);
        }
        
        try{
            ExternalSharingHelperController.ELIMINATE_DUPLICATE_CONTACT_ROLES = true;
            acr.Role__c='Abuse';
            update acr;
        }catch(Exception e){
            System.assertEquals((e.getMessage().contains('added twice with the same role')),true);
        }
    }
    @isTest
    static void accountContactRoleTest2(){
        Account a1 = new Account(name='TestAccount',BillingCountry='India',ShippingCountry='India');
        insert a1;
        Account b = new Account(name='TestAccount',BillingCountry='India',ShippingCountry='India');
        insert b;
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a1.id);
        insert c;
        Accounts__c a = new Accounts__c(Name='Custom Account',Company_Name__c=a1.id,Shipping_Country__c='India');
        insert a;
        Accounts__c b2 = new Accounts__c(Name='Custom Account',Company_Name__c=b.id,Shipping_Country__c='India');
        insert b2;
        List<Account_Contact_Role__c> acrlist = new List<Account_Contact_Role__c>();
        Account_Contact_Role__c acr= new Account_Contact_Role__c(Account__c=b2.id,Contact__c=c.id,Role__c='Business');
        insert acr;
        acrlist.add(new Account_Contact_Role__c(Account__c=b2.id,Contact__c=c.id,Role__c='Abuse'));
        acrlist.add(new Account_Contact_Role__c(Account__c=b2.id,Contact__c=c.id,Role__c='Billing'));
        
        insert acrlist;
        
    }
}