@isTest
public class CalendarUtility_Test{
    
    @testSetup
    public static void testSetup(){
        UserRole SARole = [Select Id,Name from UserRole Where Name LIKE '%US Commercial SMB - ATX 1%' LIMIT 1];
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
            UserRoleId = SARole.Id,
            Region__c = 'US',
            Group__c = 'US Other'
        );
        Insert adminUser;
        
        System.runAs(adminUser){
            Holiday hDay = new Holiday(
                IsAllDay = true,
                Name = 'Test Holiday',
                ActivityDate = System.today().addDays(1)
            );
            Insert hDay;
        }
    }
    
    @isTest
    public static void testMethod1(){
        User adminUser = [SELECT Id, Name FROM User WHERE LastName = 'testAdminUser123' AND IsActive = true limit 1];
        System.runAs(adminUser){
            CalendarUtility.getNthBusinessDay(System.today(), 5);
            CalendarUtility.getBusinessDayCount();
        }
    }
}