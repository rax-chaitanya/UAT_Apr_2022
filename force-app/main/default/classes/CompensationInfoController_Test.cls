@isTest
public class CompensationInfoController_Test {
    @IsTest
    static void partnerTypeTest()
    {
        TestClassUtility.setTestSetupData();
        Account acc=new Account();
        acc.Name='TestPartners';
        acc.Partner_Level__c='Referral';
        acc.RecordTypeId='01261000000X4tgAAC';
        insert acc;
        Contact con=new Contact();
        con.Lastname='TestCons';
        con.AccountId=acc.Id;
        con.Email='contest@gmail.com';
        con.Phone='656856867';
        con.RecordtypeId='01261000000X4thAAC';
        insert con;
        Profile p = [select Id,name from Profile where name='Rackspace-Partners' limit 1];
        User newUser = new User(
            profileId = p.id,
            username = 'newPartners@rax.com',
            email = 'Partbbn@ff.com',
            emailencodingkey = 'UTF-8',
            localesidkey = 'en_US',
            languagelocalekey = 'en_US',
            timezonesidkey = 'America/Los_Angeles',
            alias='hello1',
            lastname='partnersss',
            contactId = con.id
        );
        insert newUser;
        System.runAs(newUser)
        {
            User u=[SELECT Id,Name,ContactId,AccountId FROM User WHERE Id=:newUser.Id LIMIT 1];
            Map<Id,User> testUser=new Map<Id,User>();
            testUser.put(u.AccountId,u);
            Account company=[SELECT Id,Name,Partner_Level__c FROM Account WHERE  Id=:testUser.keySet() ];
            System.assertEquals(company.Partner_Level__c, CompensationInfoController.partnerLevelType());
        }
        
    }
    
}