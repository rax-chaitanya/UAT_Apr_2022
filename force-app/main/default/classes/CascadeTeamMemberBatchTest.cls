@isTest(seeAllData = true)
public class CascadeTeamMemberBatchTest {

    
    @isTest static void testCacsadeTeamBatchLevel1(){
        String pId=[select id,name from Profile where name='System Administrator' limit 1].id;
          User conuser = new User(firstname='Connection',FederationIdentifier = 'dhar2815dummy',Group__c='UK',Region__c='US',Alias = 'standt', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', 
                                LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com');
       
        insert conuser;
        
        Account a1 =  new Account(Name='Test Account123411',BillingCountry='India',ShippingCountry='India',CleanStatus = 'Matched');
        insert a1;
        insert new AccountTeamMember(AccountId =a1.id,userId= conuser.id );
       Account a =  new Account(ParentId=a1.id,Name='Test Account12341',BillingCountry='India',ShippingCountry='India',CleanStatus = 'Matched');
        insert a;
        insert new AccountTeamMember(AccountId =a.id,userId= conuser.id );
   Account a2 =  new Account(ParentId=a.id,Name='Test Account12341',BillingCountry='India',ShippingCountry='India',CleanStatus = 'Matched');
        insert a2;
        System.runAs(conuser){      Test.startTest();
        Database.executeBatch(new CascadeTeamMemberBatch(),200);
        Test.stopTest();
        }
    }
    
     @isTest static void testCacsadeTeamBatchSchedule(){
        String pId=[select id,name from Profile where name='System Administrator' limit 1].id;
          User conuser = new User(firstname='Connection',FederationIdentifier = 'dhar2815dummy',Group__c='UK',Region__c='US',Alias = 'standt', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', 
                                LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com');
          insert conuser;
        
        Account a1 =  new Account(Name='Test Account123411',DunsNumber='006220594',BillingCountry='India',ShippingCountry='India',CleanStatus = 'Matched');
        insert a1;
        insert new AccountTeamMember(AccountId =a1.id,userId= conuser.id );
       Account a =  new Account(ParentId=a1.id,Name='Test Account12341',BillingCountry='India',ShippingCountry='India',CleanStatus = 'Matched');
        insert a;
          insert new AccountTeamMember(AccountId =a.id,userId= conuser.id );
  
       DateTime d = System.now();
        String cronexp= '0 ' +(Integer.valueOf(d.minute())+1)+' '+d.hour()+' '+d.day()+' '+d.month()+' '+' ? '+d.year();
        System.debug('Exp '+cronexp);
        Test.startTest();
        Id jobID =System.schedule('CascadeTeamMemberBatchScheduler', cronexp, new CascadeTeamMemberBatchScheduler());
        Test.stopTest();
        
        CronTrigger ct = [SELECT TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobID];
       System.assert(ct != null ,false);
        }
  
    
  
}