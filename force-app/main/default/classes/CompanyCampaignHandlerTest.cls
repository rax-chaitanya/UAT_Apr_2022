@isTest
public class CompanyCampaignHandlerTest {
    
    @isTest
    public static void countCampaignTest()
    {
        TestClassUtility.setTestSetupData();
        Account acc=new Account();
        acc.Name='TestAcc';
        acc.Phone='6577878656';
        insert acc;
        
        Campaign c=new Campaign();
        c.Name='EricenTest';
        c.IsActive=True;
        insert c;
        List<Company_Campaign__c> ccList=new List<Company_Campaign__c>();
        Company_Campaign__c cc=new Company_Campaign__c();
        for(integer i=1;i<200;i++)
        {
        cc.Campaign__c=c.Id;
        cc.Company__c=acc.Id;
        }
       ccList.add(cc);
       insert ccList;
      Company_Campaign__c  campaign=[SELECT Id,Campaign__c,Company__c FROM Company_Campaign__c WHERE  Campaign__c=:c.Id ];
        cc.Campaign__c=campaign.Campaign__c;
        cc.Company_Campaign__c=(campaign.Campaign__c +'_'+ campaign.Company__c);
        update cc;
    }
     @isTest
public static void testEmptyMethods()
{
    CompanyCampaignHandler ch=new CompanyCampaignHandler();
    ch.afterInsert();
    ch.beforeDelete();
    ch.afterDelete();
    ch.afterUpdate();
    ch.afterUndelete();
}

}