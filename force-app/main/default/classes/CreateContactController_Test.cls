@isTest
public class CreateContactController_Test {
    @testSetup static void setup() {
        Trigger_Manager__c tms = new Trigger_Manager__c(name='ContactTgr',Is_Active__c=False);
        insert tms;
        Id recordTypes = [Select Id from RecordType where sobjectType='Account' and Name ='Partner' limit 1].Id;
        Account pacc1 = new Account(Name = 'Test Account', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=recordTypes);
        insert pacc1;
        Id crecordType1 = [Select Id from RecordType where sobjectType='Contact' and Name ='Partner' limit 1].Id;
        
        Contact pcontact = new Contact(FirstName='Partner',LastName='User',Email='rax.partner@rackspace.com',Phone='1233123',AccountId = pacc1.Id,RecordTypeId = crecordType1,is_Primary_Member__c=true);
        insert pcontact;
        
        
        
        
        
        
    }
    @isTest
    Public static void Createcontactest(){
        Contact partnerContact = [SELECT Id From Contact Limit 1];
        string po = [Select id from Profile where name = 'Rackspace-Partners' limit 1].id;
        User partnerUser = new User(alias = 'test123', email='test123@noemail.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = po, country='United States',IsActive =true,
                             ContactId =partnerContact.Id,
                             timezonesidkey='America/Los_Angeles', username='raxtest.partner@rackspace.com');
        insert partnerUser;
        System.runAs(partnerUser){
        CreateContactController.Createcontact('FirstName','LastName','','','', 
                                              '53566656','', '665655', '', 'contact@gmail.com',
                                              'India', 'Karnataka','Asia', 
                                              'Bangalore', '560037', 'Marthahalli');
        
        CreateContactController.getPickListData();
        
        }
        
    }
    
    
}