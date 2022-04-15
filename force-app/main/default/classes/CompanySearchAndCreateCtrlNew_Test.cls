@isTest(seealldata=False)
private class CompanySearchAndCreateCtrlNew_Test
{
    @testSetup 
    static void setupData() {
        
        Account acc = new Account(Name='Test Account1234',Territory__c='EMEA',BillingCountry='United Kingdom',BillingState='Angus',ShippingCountry='United Kingdom');
        insert acc;
        
    }

    @isTest
    static void testMethodOne()
    {
        List<Account> accList = [Select Id,Name From Account limit 1];
        List<String> terList = new List<String>{'APAC'};
        Test.startTest();
        CompanySearchAndCreateCtrlNew.fetchLocationType();
        CompanySearchAndCreateCtrlNew.getTerritory();
        CompanySearchAndCreateCtrlNew.getDependentCountryState();
        CompanySearchAndCreateCtrlNew.getCountry();
        CompanySearchAndCreateCtrlNew.fetchResult('test','test','0',terList,'India','Karnataka');
        Test.stopTest();
        String obj = '{"CloudDBCompList":[],"companyList":[{"compObj":{"Id":"0016100001G026uAAB","Name":"test","OwnerId":"00561000001zt6XAAQ","Owner":{"Name":"Test","Id":"00561000001zt6XAAQ"}},"isAccessible":1}],"compLimit":10,"compOffSet":0,"dbLimit":10,"dbOffSet":0,"totalCmp":200,"totalDBComp":2000}';
        String obj2 = '{"CloudDBCompList":[],"companyList":[{"compObj":{"Id":"0016100001G026uAAB","Name":"test","OwnerId":"00561000001zt6XAAQ","Owner":{"Name":"Test","Id":"00561000001zt6XAAQ"}},"isAccessible":1}],"compLimit":10,"compOffSet":10,"dbLimit":10,"dbOffSet":10,"totalCmp":200,"totalDBComp":2000}';
        
        CompanySearchAndCreateCtrlNew.compNext(obj,'test','test',terList,'India','Karnataka');
        CompanySearchAndCreateCtrlNew.compPrevious(obj2,'test','test',terList,'India','Karnataka');
        List<String> terList2 = new List<String>();
        CompanySearchAndCreateCtrlNew.fetchResult('test','','0,1',terList2,'','');
        CompanySearchAndCreateCtrlNew.compNext(obj,'test','',terList2,'India','Karnataka');
        CompanySearchAndCreateCtrlNew.compPrevious(obj2,'test','',terList2,'India','Karnataka');
    }
    
    @isTest
    static void testMethodTwo()
    {
        List<Account> accList = [Select Id,Name From Account limit 1];
        List<String> terList = new List<String>{'APAC'};
                
        String obj = '{"CloudDBCompList":[{"dcdbCompObj":{"Id":"09N2D00000001BMUAY","Name":"Hy-Test Packaging Corp","URL":"www.hy-testpackaging.com","Phone":"+1.973.754.7000","State":"New Jersey","Street":"515 E 41st St","City":"Paterson","LocationStatus":"0","Country":"United States","DunsNumber":"797272903"}}],"companyList":[{"compObj":{"Id":"0016100001G026uAAB","Name":"ntctest","OwnerId":"00561000001zt6XAAQ","Owner":{"Name":"US Cloud IB Sales Team","Id":"00561000001zt6XAAQ"}},"isAccessible":1}],"compLimit":10,"compOffSet":0,"dbLimit":10,"dbOffSet":0,"totalCmp":200,"totalDBComp":2000}';
        String obj2 = '{"CloudDBCompList":[{"dcdbCompObj":{"Id":"09N2D00000001BMUAY","Name":"Hy-Test Packaging Corp","URL":"www.hy-testpackaging.com","Phone":"+1.973.754.7000","State":"New Jersey","Street":"515 E 41st St","City":"Paterson","LocationStatus":"0","Country":"United States","DunsNumber":"797272903"}}],"companyList":[{"compObj":{"Id":"0016100001G026uAAB","Name":"ntctest","OwnerId":"00561000001zt6XAAQ","Owner":{"Name":"US Cloud IB Sales Team","Id":"00561000001zt6XAAQ"}},"isAccessible":1}],"compLimit":10,"compOffSet":10,"dbLimit":10,"dbOffSet":10,"totalCmp":200,"totalDBComp":2000}';
        
        CompanySearchAndCreateCtrlNew.dbCompNext(obj,'test','0,1');
        CompanySearchAndCreateCtrlNew.dbCompPrevious(obj2,'test','0,1');
        
    }
    
    @isTest
    static void testMethodRequestAccess()
    {
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorgracktest.rktestcom';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Rackspace Seller-INTL'];
        User u = new User(Alias = 'stdt123', Email='standarduser@testorgracktest.rktestcom',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,Group__c='US Ent',Region__c='AMER',
        TimeZoneSidKey='America/Los_Angeles',
         UserName=uniqueUserName);
         
        List<Account> accList = [Select Id,Name From Account limit 1];
        String obj = '{"CloudDBCompList":[{"dcdbCompObj":{"Id":"09N2D00000001BMUAY","Name":"Hy-Test Packaging Corp","URL":"www.hy-testpackaging.com","Phone":"+1.973.754.7000","State":"New Jersey","Street":"515 E 41st St","City":"Paterson","LocationStatus":"0","Country":"United States","DunsNumber":"797272903"}}],"companyList":[{"compObj":{"Id":"0016100001G026uAAB","Name":"ntctest","OwnerId":"00561000001zt6XAAQ","Owner":{"Name":"US Cloud IB Sales Team","Id":"00561000001zt6XAAQ"}},"isAccessible":1}],"compLimit":10,"compOffSet":0,"dbLimit":10,"dbOffSet":0,"totalCmp":200,"totalDBComp":2000}';
        CompanySearchAndCreateCtrlNew.requestCompanyRecordAccess(obj,accList[0].Id);
        
        
        System.runAs(u){
            CompanySearchAndCreateCtrlNew.requestCompanyRecordAccess(obj,accList[0].Id);
            CompanySearchAndCreateCtrlNew.importDandBCompany(obj,accList[0].Id);
        }
        
        
    }
    
    
}