@isTest
Public class UpdateOPCController_test{

    Public Static TestMethod Void Updatecontrollertest(){
    
        Trigger_Manager__c tm = new Trigger_Manager__c(name = 'OPCAccountSurveyTrigger',Is_Active__c= True);
             insert tm;
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
                Region__c = 'AMER',
                SSO_Username__c='Test.test',
                Group__c = 'US Other'
            );
            Insert adminUser;
            
            OPCPilotUser__c opcuser =new OPCPilotUser__c(name='Test.test', isActive__c=true);
            insert opcuser;
            
            //User u = [SELECT Id,name FROM User WHERE isActive = True LIMIT 1];
                Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        Id precordType = [Select Id from RecordType where sobjectType='Account' and DeveloperName ='Prospect'].Id;

            Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId=devRecordTypeId);
            insert a;
        
            Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,ShippingCountry='India', RecordTypeId=precordType);
            insert ac;
            OPC_Account_Survey__c opc = new OPC_Account_Survey__c();
                //opc.Name=OPC-{000000};
                opc.Account_Name__c=ac.id;
                opc.CurrencyIsoCode='USD';
               // opc.Account_Manager__c=u.id;
                opc.Survey_Date__c=System.today().addDays(8);
                //opc.Survey_Complete_Date__c=System.today().addDays(10);
                opc.Monthly_Call_Recap__c='yes';
                opc.Customer_s_Current_Pulse__c='Customer is engaged and happy with Rackspace Public Cloud';
                opc.createddate=system.now();
                insert opc;
                opc.Survey_Complete_Date__c=System.today().addDays(10);
                opc.Expected_STOP_Churn_Date__c=system.now().addDays(5);
                opc.Expected_START_Churn_Date__c=system.now().addDays(3);
                opc.MRR_Loss__c=13000;
                update opc;
                string opcobject='OPC_Account_Survey__c';
                Test.starttest();
                    UpdateOPCController.displaySurveys(ac.Account_Manager__c);
                    UpdateOPCController.checkfriday();
                    UpdateOPCController.getPickListValuesIntoList('OPC_Account_Survey__c','Customer_s_Current_Pulse__c');
                    UpdateOPCController.saveSurveyRecord(opc.id,opc.Survey_Complete_Date__c,opc.Customer_s_Current_Pulse__c,opc.Expected_START_Churn_Date__c,opc.Expected_STOP_Churn_Date__c,opc.Monthly_Call_Recap__c,opc.MRR_Loss__c);        
                Test.stoptest();
    }
}