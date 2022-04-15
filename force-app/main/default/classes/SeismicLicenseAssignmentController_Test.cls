@isTest
public class SeismicLicenseAssignmentController_Test {
    
    @testSetup
    public static void testSetup(){
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' limit 1];
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
            IsActive = true
        );
        Insert adminUser;
    }
    
    @isTest
    public static void testMethod1(){
        User adminUser = [SELECT Id, Name FROM User WHERE LastName = 'testAdminUser123' AND IsActive = true limit 1];
        System.runAs(adminUser){
            SeismicLicenseAssignmentController.AssignSeismicLicense();
            SeismicLicenseAssignmentController.AssignSeismicLicense();
        }
        
    }
}