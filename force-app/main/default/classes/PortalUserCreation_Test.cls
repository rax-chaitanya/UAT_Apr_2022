@isTest(SeeAllData = false)
public class PortalUserCreation_Test {
    
    private static testmethod void testMethod1() {  
    String pId=[select id,name from Profile where name='Rackspace Seller-US' limit 1].id;
    User conuser = new User(firstname='Connection',Alias = 'standt', Email='selleruser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', group__c = 'APAC',
                                Region__c='AMER', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com', FederationIdentifier='test'+System.today());
        insert conuser;
        PortalUserCreation obj = new PortalUserCreation(new List<User>{conuser});
        System.enqueueJob(obj);
    }
}