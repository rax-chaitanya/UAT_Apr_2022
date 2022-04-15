/*
###########################################################################
# File..................: UserTriggerTest.cls
# Version...............: 1.0
# Created by............: Kartikeya Tewari (RDC)
# Created Date..........: 16-May-2017
# Description...........: This is an Apex test class to test User trigger.
*/
@istest(seeAllData=true)
public class UserTriggerTest
{
    static final Id standardRecordTypeId= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
 
     static testMethod void unitTest()
     {
       UserHandler u = new UserHandler();
        u.isActive();
       Profile p_test = [SELECT Id FROM Profile WHERE Name= 'Rackspace Marketing-US'];
       /*Trigger_Manager__c UserSetting = new Trigger_Manager__c();
           UserSetting.Name = 'UserTrigger';
           UserSetting.Is_Active__c = true;
           insert UserSetting;*/
           
           
           User testUser = new User(Alias = 'abcpqr', Email='testuser12@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p_test.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='abcxyzpqr@rackspacepqr.com', FederationIdentifier = '' , SSO_Username__c = 'abcxyz197'
                );
                try{
                insert testUser;
                }catch(Exception e){
                }
                
                testUser.FederationIdentifier= 'abcxyz197';
                update testUser;
                
                User TestUser2 = [Select FederationIdentifier, SSO_Username__c from User where UserName = 'abcxyzpqr@rackspacepqr.com'];
                System.assertEquals('abcxyz197',TestUser2.SSO_UserName__c);
                
                TestUser2.SSO_Username__c = 'abcxyz193';
                update TestUser2;
                
                User TestUser3 = [Select FederationIdentifier, SSO_Username__c from User where UserName = 'abcxyzpqr@rackspacepqr.com'];
                System.assertEquals('abcxyz197',TestUser3.SSO_Username__c);
                try{
                    u.beforeInsert();
                }catch(Exception e){
                }
                try{
                    u.beforeUpdate();
                }catch(Exception e){
                }
                u.beforeDelete();
                u.afterDelete();
                u.afterUndelete();
            Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
            insert a;
            contact cons = new Contact(pse__Resource_Role__c='Consultant',RecordTypeId=standardRecordTypeId,
                                       pse__Salesforce_User__c =testUser.Id ,LastName='PSAResource',email='example@test.com');
            
            insert cons;
         
         testUser.PSA_Resource__c = true;
         update testUser;

   }
   
}