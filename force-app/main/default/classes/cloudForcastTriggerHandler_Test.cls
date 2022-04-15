@isTest
public class cloudForcastTriggerHandler_Test {     
    static testMethod void myUnitTest(){
       Profile p = [SELECT Id FROM Profile WHERE Name='Read Only'];        
       User u = new User();       
           u.FirstName = 'David';
           u.LastName  = 'Liu';
           u.Email     = 'dvdkliu+sfdc99@gmail.com';
           u.Username  = 'sfdc-dreamerprogtest@rackspace.com.test';
           u.Alias     = 'fatty';
           u.ProfileId = p.id;
           u.TimeZoneSidKey    = 'America/Denver';
           u.LocaleSidKey      = 'en_US';
           u.EmailEncodingKey  = 'UTF-8';
           u.LanguageLocaleKey = 'en_US';
           u.Forecast_Group_1__c  = 'CApps';
           u.Region__c = 'US';       
       insert u;
        
       Cloud_Forecast__c c = new Cloud_Forecast__c();
           c.User_Segment__c = u.Forecast_Group_1__c;
           c.Region__c = u.Region__c;
           c.User__c = u.Id;
           c.CRF_Date__c = system.today()+2;  
           c.Azure_Support__c =1;
           c.Azure__c=1;
           c.FAWS_Support__c=2;
           c.FAWS__c=2;
           c.RAX_Cloud_Support__c=2;
           c.RAX_Cloud__c=1;
           
           
            insert c;
       
        c.CRF_Date__c = system.today()-30;
        update c;
        c.CRF_Date__c = system.today()-60;
        update c;
        c.CRF_Date__c = system.today()-90;
        update c;
        c.CRF_Date__c = system.today()-120;
        update c;
        c.CRF_Date__c = system.today()+30;
        update c;
        c.CRF_Date__c = system.today()+60;
        update c;
        c.CRF_Date__c = system.today()+90;
        update c;
        c.CRF_Date__c = system.today()+120;
        update c;
        c.CRF_Date__c = system.today()+150;
        update c;
        c.CRF_Date__c = system.today()+180;
        update c;
        c.CRF_Date__c = system.today()+210;
        update c;
    }
}