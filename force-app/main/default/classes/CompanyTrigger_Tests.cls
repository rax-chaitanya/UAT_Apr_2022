@istest
public class CompanyTrigger_Tests{
@TestSetUp
    static void setDataUp(){
        
        TestClassUtility.setTestSetupData();
        List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
        fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
        insert fieldMappings;
        
    }  
@IsTest static void updatepartnerprimarymemberchange(){
 Id recordTypeIdacc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
Id recordTypeIdacc2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
         Account a1 = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId=recordTypeIdacc2);
        insert a1;
        Account a2 = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId=recordTypeIdacc2);
        insert a2;
        Id crecordType = [Select Id from RecordType where sobjectType='Contact' and Name ='Partner' limit 1].Id;
        Contact pcon = new Contact(recordtypeid=crecordType,FirstName='Partner',LastName='User',Email='rax.partner@rackspace.com',Phone='1233123',AccountId = a2.Id);
        
        insert pcon;

      // Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
        Account pacc = new Account(Name = 'Test Account', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=recordTypeIdacc,parentid=a1.id);
        insert pacc;
        Contact pcon2 = new Contact(FirstName='Partner',LastName='User',Email='rax.partner@rackspace.com',Phone='1233123',AccountId = pacc.Id,RecordTypeId = crecordType);
        
        insert pcon2;
        Contact pcon3 = new Contact(FirstName='Partner',LastName='User',Email='rax.partner@rackspace.com',Phone='1233123',AccountId = pacc.Id,RecordTypeId = crecordType);
        
        insert pcon3; 
        system.debug('pacc.recordtype.name==========='+pacc.recordtype.name);
        system.debug('pacc.parentid==========='+pacc.parentid);
        Test.startTest();
        Account accupdate=[select id,name,parentid from Account where id=:pacc.id];
        system.debug('pacc.parentid==========='+accupdate);
         system.debug('accupdate.parentid111==========='+accupdate.parentid);
        Account parentaccupdate=[select id,name,parentid from Account where id=:a2.id];
        accupdate.parentid=parentaccupdate.id;
       //companyhandler.StopBUAUCMPRecursion = 'After Update';
                update accupdate;
        system.debug('accupdate.parentid222==========='+accupdate.parentid);
        system.debug('pacc.recordtypeid==========='+pacc.recordtypeid);
        Test.stopTest();
        
       /* pacc.IsPartner = true;
        pacc.Primary_Member__c = pcon2.Id;
        pacc.Partner_Account_Status__c ='Approved';
        pacc.Partner_Level__c ='Master Agent';
        pacc.parentid=a2.id;
        update pacc;
        pacc.Primary_Member__c = pcon3.Id;
        system.debug('pacc.parentid==========='+pacc.parentid);
        update pacc;*/
       
        }
        @IsTest static void updatepartnerprimarymemberchange2(){
          Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.GovernmentRecordType);
        insert a;
        try{
        Delete a;
        }catch(Exception e){}
        }
        @IsTest static void updatepartnerprimarymemberchange3(){
        Test.startTest();
        Id srecordType = [Select Id from RecordType where sobjectType='Account' and Name ='Customer Account' limit 1].Id;

          Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a;
       
        Account acc=new Account(Name = 'test',ShippingCountry='India', Company_Name__c = a.Id, RecordTypeId = srecordType,Type='Customer');
        insert acc;
                
        try{
        Delete a;
        }catch(Exception e){}
        Test.stopTest();
        }
         @IsTest static void updatepartnerprimarymemberchange4(){
        Id srecordType = [Select Id from RecordType where sobjectType='Account' and Name ='Customer Account' limit 1].Id;

          Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a;
       
        Account acc=new Account(Name = 'test',ShippingCountry='India', Company_Name__c = a.Id, RecordTypeId = srecordType,Type='Former Cloud Customer');
        insert acc;
        try{
        Delete a;
        }catch(Exception e){}
        
        }
         @IsTest static void updatepartnerprimarymemberchange5(){
        Id srecordType = [Select Id from RecordType where sobjectType='Account' and Name ='Customer Account' limit 1].Id;

          Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a;
        
        Account acc=new Account(Name = 'test',ShippingCountry='India', Company_Name__c = a.Id, RecordTypeId = srecordType,Type='Former Customer');
        insert acc;
       try{
        Delete a;
        }catch(Exception e){}
        
        }
         @IsTest static void updatepartnerprimarymemberchange6(){
        Id srecordType = [Select Id from RecordType where sobjectType='Account' and Name ='Customer Account' limit 1].Id;

          Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert a;
        
        Account acc=new Account(Name = 'test',ShippingCountry='India', Company_Name__c = a.Id, RecordTypeId = srecordType,Type='Cloud Custome');
        insert acc;
        try{
        Delete a;
        }catch(Exception e){}
        }
    
    
        @istest static void VerifyMerge(){
         Id RTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account').getRecordTypeId();
      Account cmp = new Account(Name='Test Account12',BillingCountry='India',ShippingCountry='India',RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert cmp;
         Account acc = new Account(Name = 'test1',Type= 'Former Customer', ShippingCountry='India',Company_Name__c = cmp.Id, RecordTypeId = RTypeId);
        insert acc;
    }
    
     @isTest static void Partnerrole() {         	
        Test.startTest();	
        Id recordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Company').getRecordTypeId();
      	Account cmp = new Account(Name='Test Account12',BillingCountry='India',ShippingCountry='India',Opt_Out__c= true,Partner_Level__c ='Strategic',Territory__c='ANZ',RecordTypeId = recordTypeId);	
        insert cmp;	
     Id condevRecordTypeId3 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=cmp.id,MailingCountry='India',Email='test.t@test.com',
                                MailingStreet='Whitefield',Phone='12345676',RecordTypeId = condevRecordTypeId3, MailingCity='Bangalore',MailingPostalCode='560066',MailingState='Karnataka',Partner_Level__c = 'Marketplace',HasOptedOutOfEmail=false, HasOptedOutOfFax= false, Partner_Region__c='Africa');
         insert c;
        // c.Partner_Level__c!= cmp.Partner_Level__c;
         c.Partner_Level__c ='Strategic' ;
         c.Partner_Region__c = 'ANZ';
         update c;
         
         
         Test.stopTest(); 
   List<Account> acc1 = new List<Account>();
    //   CompanyTriggerHelper.updateRegionAndPartLevelOnContact(acc1);
                 	
    }
    
    }