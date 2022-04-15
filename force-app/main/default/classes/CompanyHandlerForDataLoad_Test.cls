@istest
public class CompanyHandlerForDataLoad_Test{
@TestSetUp
    public static void setTestSetupData(){
        List<Trigger_Manager__c> tms = new List<Trigger_Manager__c>();
        tms.add( new Trigger_Manager__c(name='ContactTgr',Is_Active__c=true)); 
        tms.add( new Trigger_Manager__c(name='AcrTgr',Is_Active__c=true)); 
         tms.add( new Trigger_Manager__c(name='AccountDataloadTgr',Is_Active__c=true));
        insert tms;
        }
        @isTest
    static void CompanyHandlerForDataLoadTest(){
          Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' limit 1];
          UserRole role1 = [select Id,name from UserRole where name ='Rackspace Corporate' limit 1];
        user adminUser = new User(
            ProfileId = adminProfile.Id,
            LastName = 'testAdminUser123',
            Email = 'puser000@amamama.com',
            Username = 'adminuser@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            Region__c = 'US',
            Group__c = 'US Other',
            userroleid = role1.id,
            isActive = true
        );
        Insert adminUser;
        
        user adminUser2 = new User(
            ProfileId = adminProfile.Id,
            LastName = 'testAdminUser123',
            Email = 'puser000@amamama.com',
            Username = 'adminuser@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            Region__c = 'US',
            Group__c = 'US Other',
            isActive = true,
            userroleid = role1.id
        );
        Insert adminUser2;
        
        system.runas(adminUser){Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard').getRecordTypeId(); 
     //   Id rtAccId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account').getRecordTypeId();
         Id MigRTid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Migration Record Account').getRecordTypeId();

        
        Account a = new Account(Name='Test Account1234',Old_Owner_Id__c = adminUser.id,BillingCountry='India',ShippingCountry='India',RecordTypeId =rtId);
        insert a;        
        
        AccountTeamMember atm = new AccountTeamMember(AccountId = a.id,UserId= userinfo.getuserid(),
                                                      AccountAccessLevel= 'edit',
                                                      TeamMemberRole= 'Account Executive',
                                                      CaseAccessLevel= 'edit',
                                                      ContactAccessLevel= 'edit',
                                                      OpportunityAccessLevel= 'edit');
        insert atm;
         AccountTeamMember atm2 = new AccountTeamMember(AccountId = a.id,UserId=userinfo.getuserid(),
                                                      AccountAccessLevel= 'edit',
                                                      TeamMemberRole= 'Account Executive',
                                                      CaseAccessLevel= 'edit',
                                                      ContactAccessLevel= 'edit',
                                                      OpportunityAccessLevel= 'edit');
        insert atm2;
        
        
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id);
        insert c;
        
        //Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
        Account ac = new Account(Name='Test C Account',Old_Owner_Id__c =userinfo.getuserid(),custom_account_sfdc_id__c= '0191hadags',Test_Rollup__c = 'test ',Company_Name__c=a.Id,ShippingCountry='India',RecordTypeId =MigRTid,ownerid=userinfo.getuserid());
        insert ac;
        
        Account ac2 = new Account(Name='Test C Account',Old_Owner_Id__c = userinfo.getuserid(),custom_account_sfdc_id__c= '0191hadags',Test_Rollup__c = 'test ',Company_Name__c=a.Id,ShippingCountry='India',RecordTypeId =rtId,ownerid= userinfo.getuserid());
        insert ac2;
        
        
        }
    }
 /* @IsTest static void updatepartnerprimarymemberchange(){
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
        
        } */
    }