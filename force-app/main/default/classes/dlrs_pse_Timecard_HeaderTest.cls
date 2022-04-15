/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_pse_Timecard_HeaderTest
{
    @IsTest(SeeAllData=true)
    private static void testTrigger()
    {
String CURRENCY_DEFAULT = 'USD';
String COUNTRY_DEFAULT = 'United States';
Id NULL_ID = null;
Decimal NULL_DECIMAL = null;
String NULL_STRING = null;

String USER_EMAIL_ENCODING_KEY_DEFAULT = 'ISO-8859-1';
String USER_LANGUAGE_LOCALE_KEY_DEFAULT = 'en_US';
String USER_LOCALE_SID_KEY_DEFAULT = 'en_US';
String USER_TIME_ZONE_SID_KEY_DEFAULT= 'America/New_York';
String RESOURCE_ROLE_DEFAULT = 'Consultant';
Integer nameIndex = 0;
Date weekStart = Date.today().toStartofWeek();
Date weekEnd = weekStart + 6;


Integer i = (integer)(Math.random()*1000);


  List<Profile> lstProfiles = new List<Profile>([
    SELECT Id 
      FROM Profile 
     WHERE Name = 'System Administrator' 
    LIMIT 1
  ]);
  if(lstProfiles.size() == 0) {
    System.debug('ERROR: no system admin profile found');
  }

User user1 = new User();
user1.firstName = 'test' + i;
user1.LastName = 'test' + i;
user1.Alias = 'tst' + i;
user1.Email = 'test' + i + '.test@financialforce.com';
user1.UserName='test'+ Math.random().format()+i+'user1@financialforce.com';
user1.EmailEncodingKey = USER_EMAIL_ENCODING_KEY_DEFAULT;
user1.LanguageLocaleKey = USER_LANGUAGE_LOCALE_KEY_DEFAULT;
user1.TimeZoneSidKey = USER_TIME_ZONE_SID_KEY_DEFAULT;
user1.CurrencyIsoCode = CURRENCY_DEFAULT;
user1.LocaleSidKey = USER_LOCALE_SID_KEY_DEFAULT;
user1.ProfileId = lstProfiles[0].Id;
user1.IsActive=true;

insert user1;

System.runas(user1) {
pse__Region__c reg = new pse__Region__c();
reg.Name = 'Region1';
insert reg;


pse__Permission_Control__c pc1 = new pse__Permission_Control__c();
pc1.pse__Staffing__c = true;
pc1.pse__Region__c = reg.Id;
pc1.pse__User__c = user1.Id;
insert pc1;


Account acc = new Account();
acc.Name = 'Test Account';
insert acc;

pse__Work_Calendar__c wc = new pse__Work_Calendar__c();
wc.Name ='Test Calender';
wc.pse__Week_Start_Day__c = 'Sunday';
wc.pse__Sunday_Hours__c = 0.0;
wc.pse__Monday_Hours__c = 8.0;
wc.pse__Tuesday_Hours__c = 8.0;
wc.pse__Wednesday_Hours__c = 8.0;
wc.pse__Thursday_Hours__c =8.0;
wc.pse__Friday_Hours__c = 8.0;
wc.pse__Saturday_Hours__c = 0.0;
insert wc;


Contact resource = new Contact();
resource.AccountId = acc.id;
resource.LastName = 'Test_' + (nameIndex++);
resource.pse__Region__c = reg.Id;
resource.CurrencyIsoCode = CURRENCY_DEFAULT;
resource.pse__Is_Resource_Active__c = true;
resource.pse__Is_Resource__c = true;
resource.pse__Resource_Role__c = RESOURCE_ROLE_DEFAULT;
resource.pse__Work_Calendar__c = wc.Id;
resource.pse__Salesforce_User__c = user1.id;
insert resource;


pse__Proj__c project = new pse__Proj__c();
project.name = 'Test';
project.pse__Region__c = reg.id;
project.pse__Start_Date__c = Date.today();
project.pse__End_Date__c = Date.today().addDays(30);
project.pse__Is_Active__c = TRUE ;
insert project;

pse__Milestone__c milestone = new pse__Milestone__c();
milestone.pse__Project__c = project.id;
milestone.pse__Target_Date__c = Date.today().addDays(30);
milestone.pse__Milestone_Amount__c = 0;
insert milestone;

pse__Schedule__c s = new pse__Schedule__c();
s.pse__Start_Date__c = Date.today();
s.pse__End_Date__c = Date.today().addDays(30);
insert s;



pse__Assignment__c assign = new pse__Assignment__c();
assign.pse__Bill_Rate__c = 0;
assign.pse__Schedule__c= s.id;
assign.pse__Project__c= project.id;   
assign.pse__Resource__c= resource.id;
insert assign;

pse__Timecard_Header__c timecard = new pse__Timecard_Header__c();
timecard.pse__Resource__c = resource.id;
timecard.pse__Project__c = project.id;
timecard.pse__Assignment__c = assign.id;
timecard.pse__Start_Date__c = weekStart;
timecard.pse__End_Date__c = weekEnd;
timecard.pse__Monday_Hours__c = 8;
timecard.pse__Monday_Notes__c = 'mon notes';
timecard.pse__Tuesday_Hours__c = 8;
timecard.pse__Tuesday_Notes__c = 'tues notes';
timecard.pse__Wednesday_Hours__c = 8;
timecard.pse__Wednesday_Notes__c = 'wed notes';
timecard.pse__Thursday_Hours__c = 8;
timecard.pse__Thursday_Notes__c = 'thurs notes';
timecard.pse__Friday_Hours__c = 8;
timecard.pse__Friday_Notes__c = 'fri notes';
insert timecard;

// Force the dlrs_pse_MilestoneTrigger to be invoked, fails the test if org config or other Apex code prevents this.
dlrs.RollupService.testHandler(timecard);
}
    }
}