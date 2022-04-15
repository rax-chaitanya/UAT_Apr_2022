@isTest
public class ContactHelper_Test {
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
        Id recordType = [Select Id from RecordType where sobjectType='Account' and Name ='Partner Company' limit 1].Id;
        Id stdcompanyrectype = [Select Id from RecordType where sobjectType='Account' and Name ='Standard Company' limit 1].Id;
        
        Account pacc = new Account(Name = 'Test Account', Partner_License_Type__c='Partner Community',BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=recordType);
        insert pacc;
        Account pacc1 = new Account(Name = 'Test Account1',Partner_License_Type__c='Partner Community Login', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=recordType);
        insert pacc1;
        
        Id crecordType = [Select Id from RecordType where sobjectType='Contact' and Name ='Partner' limit 1].Id; 
        Id cstandrecordType = [Select Id from RecordType where sobjectType='Contact' and Name ='Standard' limit 1].Id; 
        Contact pcon = new Contact(FirstName='Partner',LastName='User',Email='rax.partner@rackspace.com',Phone='1233123',AccountId = pacc.Id,RecordTypeId = crecordType,Btlk_Country__c='United States',Btlk_Sate_Province__c='Florida');
        insert pcon;
        Contact pcon1 = new Contact(FirstName='Partner1',LastName='User1',Email='rax1.partne1r@rackspace.com',Phone='12343123',AccountId = pacc1.Id,RecordTypeId = crecordType,Btlk_Country__c='United States',Btlk_Sate_Province__c='Florida');
        insert pcon1;
        
        system.debug('The partner login license type =: '+pcon1.account.Partner_License_Type__c);
        system.debug('The partner login acc name =: '+pcon1.account.Name);
        system.debug('The partner login accid =: '+pcon1.accountid);
        pacc.IsPartner = true;
        pacc.Primary_Member__c = pcon.Id;
        pacc.Partner_Level__c ='Master Agent';
        pacc.Partner_Account_Status__c ='Approved';
        
        pacc1.IsPartner = true;
        pacc1.Primary_Member__c = pcon1.Id;
        pacc1.Partner_Level__c ='Master Agent';
        pacc1.Partner_Account_Status__c ='Approved';
        pacc1.Partner_License_Type__c='test';
        update pacc;
        update pacc1;
        
        Account stdacc = new Account(Name = 'Test Accountstd',BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka',RecordTypeId=stdcompanyrectype);
        insert stdacc;
        
    }
    
    
    @isTest
    static void createPartnerUser(){
        
        //  TestClassUtility.setTestSetupData();
        // insert new Trigger_Manager__c(Name='UserTrigger',Is_Active__c = true);
        
        List<contact> listCon =new LIst<Contact>();
        List<contact> listCon1 =new LIst<Contact>();
        set<Id> setId = new set<Id>();
        
        Id crecordType = [Select Id from RecordType where sobjectType='Contact' and Name ='Partner' limit 1].Id;   
        Id Emprecordtype = [Select Id from RecordType where sobjectType='Contact' and Name ='Employee' limit 1].Id;       
        Id stdrecordtype = [Select Id from RecordType where sobjectType='Contact' and Name ='Standard' limit 1].Id;         
        
        
        //system.debug('The partner login license type Account Level  =: '+pacc1.Partner_License_Type__c);
        contact pcon =[select Id ,Name from Contact where Name = 'Partner User' limit 1];
        contact pcon1 =[select Id ,Name from Contact where Name = 'Partner1 User1' limit 1];
        Account pacc = [select id, Name from Account Where Name = 'Test Account' limit 1];
        listCon.add(pcon);
        listCon.add(pcon1);
        ContactHelper.createPartnerUser(listCon);
        Profile p = [Select id from Profile where name = 'Rackspace - Partners Login' limit 1];
        Profile intergrationprofile = [Select id from Profile where name = 'Integration Api' limit 1];
        User user = new User(alias = 'test123', email='test123@noemail.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
                             ContactId = pcon1.Id,
                             timezonesidkey='America/Los_Angeles', username='raxtest.partner@rackspace.com');
        
        insert user;
        User integrationuser = new User(alias = 'int123', email='testint123@noemail.com',
                                        emailencodingkey='UTF-8', lastname='Testingn', languagelocalekey='en_US',
                                        localesidkey='en_US', profileid = intergrationprofile.Id, country='United States',IsActive =true,
                                        timezonesidkey='America/Los_Angeles', username='raxtestint.partner@rackspace.com.sand');
        insert integrationuser;
        
        Profile p1 = [Select id from Profile where name = 'Rackspace-Partners' limit 1];
        User user1 = new User(alias = 'test124', email='test124@noemail.com',
                              emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                              localesidkey='en_US', profileid = p1.Id, country='United States',IsActive =true,
                              ContactId = pcon.Id,
                              timezonesidkey='America/Los_Angeles', username='raxtest2.partner@rackspace.com');
        
        insert user1;
        
        setId.add(user.ContactId);
        setId.add(user1.ContactId);
        
        ContactHelper.activeInactiveUsers(setId);
        system.runAs(user1){
            Test.StartTest(); 
            Contact pcon2 = new Contact(FirstName='Partner3',LastName='User1',Email='rax13.partne1r@rackspace.com',Phone='12343123',AccountId = pacc.Id,RecordTypeId = crecordType);
            insert pcon2;
            pcon2.FirstName= 'Partner11';
            try{
                update pcon2;
            }catch(Exception e){}
            pcon2.inactive__c= true;
            try{
                update pcon2;
            }catch(Exception e){}
            
        }
        //ContactHelper.createPartnerUser(listCon);
        system.runAs(integrationuser){
            Account stdac= [select id, Name from Account Where Name = 'Test Accountstd' limit 1];
            Contact empcon = new Contact(FirstName='first',LastName='User',Email='rax.employeetest@rackspace.com',Phone='1233123',AccountId = stdac.Id,RecordTypeId = Emprecordtype,Btlk_Country__c='United States',
                                         Start_Date__c=date.parse('09/24/2018'),Btlk_Sate_Province__c='Florida',manager__c='manager User',Employee_Number__c='123',Manager_Employee_Number__c='234');
            
            
            Contact manager = new Contact(FirstName='manager',LastName='User',Email='rax.employeetest@rackspace.com',Phone='1233123',AccountId = stdac.Id,RecordTypeId = Emprecordtype,Btlk_Country__c='United States',
                                         Start_Date__c=date.parse('09/24/2018'),Btlk_Sate_Province__c='Florida',manager__c='manager 1',Employee_Number__c='234',Manager_Employee_Number__c='456');
            
            Contact manager1 = new Contact(FirstName='manager',LastName='1',Email='rax.employeetest@rackspace.com',Phone='1233123',AccountId = stdac.Id,RecordTypeId = Emprecordtype,Btlk_Country__c='United States',
                                         Start_Date__c=date.parse('09/24/2018'),Btlk_Sate_Province__c='Florida',manager__c='manager 2',Employee_Number__c='456',Manager_Employee_Number__c='798');
            
            Contact manager2 = new Contact(FirstName='manager',LastName='2',Email='rax.employeetest@rackspace.com',Phone='1233123',AccountId = stdac.Id,RecordTypeId = Emprecordtype,Btlk_Country__c='United States',
                                         Start_Date__c=date.parse('09/24/2018'),Btlk_Sate_Province__c='Florida',manager__c='manager 3',Employee_Number__c='789',Manager_Employee_Number__c='101');
            
            insert manager;
            insert manager1;
            insert manager2;
            Test.StopTest(); 
            insert empcon;
        }
        
    }
    @isTest
    static void createPartnerUser2(){
        
        //  TestClassUtility.setTestSetupData();
        // insert new Trigger_Manager__c(Name='UserTrigger',Is_Active__c = true);
        
        List<contact> listCon =new LIst<Contact>();
        List<contact> listCon1 =new LIst<Contact>();
        set<Id> setId = new set<Id>();
        
        Id crecordType = [Select Id from RecordType where sobjectType='Contact' and Name ='Partner' limit 1].Id;         
        //system.debug('The partner login license type Account Level  =: '+pacc1.Partner_License_Type__c);
        contact pcon =[select Id ,Name from Contact where Name = 'Partner User' limit 1];
        contact pcon1 =[select Id ,Name from Contact where Name = 'Partner1 User1' limit 1];
        Account pacc = [select id, Name from Account Where Name = 'Test Account' limit 1];
        listCon.add(pcon);
        listCon.add(pcon1);
        ContactHelper.createPartnerUser(listCon);
        Profile p = [Select id from Profile where name = 'Rackspace - Partners Login' limit 1];
        User user = new User(alias = 'test123', email='test123@noemail.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
                             ContactId = pcon1.Id,
                             timezonesidkey='America/Los_Angeles', username='raxtest.partner@rackspace.com');
        
        insert user;
        
        
        setId.add(user.ContactId);
        
        ContactHelper.activeInactiveUsers(setId);
        
        ContactHelper.createPartnerUser(listCon);
        
    }
}