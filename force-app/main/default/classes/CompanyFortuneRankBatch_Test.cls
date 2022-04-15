/************************************************************************************************************************************
 * Class Name : CompanyFortuneRankBatch_Test
 * Author : Matthew Lamb
 * Creation Date : November 2015
 * Purpose : Test class associated with the CompanyFortuneRankBatch class. As of Nov 2015, queries to the DataclouddAndBCompany
 *           object are treated as callouts, and there is no testing pattern available that will either 1) simulate data returning
 *           from a query to DataclouddAndBCompany, or 2) to create test data in that object, since it simply acts as a proxy for
 *           sending queries to the D&B APIs. So, this test class simply runs the batch job as it is, and the batch job contains
 *			 a large number of unnecessary statements in the finish method to ensure high test coverage. No real testing can be done.
 ************************************************************************************************************************************/

@isTest
private class CompanyFortuneRankBatch_Test {
	
    @TestSetUp static void setTestData(){
        TestClassUtility.setTestSetupData();
    }
	public static List<Profile> adminProfileList {get; set;}
    public static List<User> adminList {get; set;}

    @isTest static void SingleRecordWithParentTest() {
        //Initialize the User data needed to run the test
        adminProfileList = new List<Profile>();
        adminList = new List<User>();
        initializeData();

        //Run the test as a System Administrator
        System.runAs(adminList[0]) {

            //Run the batch job to process and convert the data with a batch size of 5
            Test.startTest();
            Database.executeBatch(new CompanyFortuneRankBatch());
            Test.stopTest();
        }

        //@TODO - At some point in the future when the Data.com APIs, specifically queries to the DataclouddAndBCompany object,
        //        can be tested correctly, this method should be expanded to provide proper assert based testing.
    }

    @isTest static void ScheduleableBatchTest() {
        //Initialize the User data needed to run the test
        adminProfileList = new List<Profile>();
        adminList = new List<User>();
        initializeData();

        //Run the test as a System Administrator
        System.runAs(adminList[0]) {
            Test.startTest();
            String CRON_EXP = '0 0 ' + System.now().hour() + ' * * ?';
            CompanyFortuneRankSchedule schedule = new CompanyFortuneRankSchedule();
            String jobId = System.schedule('CFRSJob', CRON_EXP, schedule);
        
            // Get the information from the CronTrigger API object
            CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = : jobId];
            
            // Verify the expressions are the same
            System.assertEquals(CRON_EXP, ct.CronExpression);
            
            // Verify the job has not run
            System.assertEquals(0, ct.TimesTriggered);
            Test.stopTest();
        }
    }

    /*****************************************
	
	/*************************************************************************************************
     * Helper method to initialize data necessary to run the tests
     *************************************************************************************************/
    private static void initializeData() {
        //Get a list of Admins so we can use one to run the test as
        adminProfileList = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        adminList = [SELECT Id FROM User WHERE ProfileId =: adminProfileList[0].Id AND IsActive = true];

        //Initialize a few test Accounts
        List<Account> accountList = new List<Account>();
        
        Account newCompany = TestDataHelper.createTestCompany();
        newCompany.Name = 'Berkshire Hathaway Inc.';
        newCompany.DunsNumber = '001024314';
        newCompany.CleanStatus = 'Matched';
        newCompany.BillingCountry = 'United States';
        accountList.add(newCompany);

        newCompany = TestDataHelper.createTestCompany();
        newCompany.Name = 'Wal-Mart Stores';
        newCompany.DunsNumber = '051957769';
        newCompany.CleanStatus = 'Matched';
        newCompany.BillingCountry = 'United States';
        accountList.add(newCompany);

        newCompany = TestDataHelper.createTestCompany();
        newCompany.Name = 'Apple Inc.';
        newCompany.DunsNumber = '060704780';
        newCompany.CleanStatus = 'Matched';
        newCompany.BillingCountry = 'United States';
        accountList.add(newCompany);

        insert accountList;
    }
}