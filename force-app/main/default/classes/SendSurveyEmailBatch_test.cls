@isTest

Public class SendSurveyEmailBatch_test{

    Public static TestMethod Void TestSurveyemail(){
        
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
            
         string companyRecordTypeId =  Schema.sObjectType.account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();

    	string productAccountRecordTypeId =  Schema.sObjectType.account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
      
       Account Company = new Account(Name='Test Survey Company',RecordTypeId =companyRecordTypeId,BillingCountry='India',ShippingCountry='India',territory__c = 'ANZ');
        insert Company ;
      
            System.debug('Company:' + company);
            List<Account>lstacc=New List<Account>();
            for(integer i=0;i<5;i++){
                Account acc=new Account();
                acc.Name='Test Survey Account'+i;
                acc.Company_Name__c=company.id;
                acc.Total_MRR__c=10000+ i;
                acc.RecordTypeId =productAccountRecordTypeId;
               acc.Account_Manager__c=adminUser.id;
                lstacc.add(acc);
            }
            Account acc1=new Account();
            acc1.Name='Test Survey Account6';
            acc1.Company_Name__c=company.id;
            acc1.Total_MRR__c=10004;
             acc1.RecordTypeId =productAccountRecordTypeId;
            acc1.Account_Manager__c=adminUser.id;
            lstacc.add(acc1);
        
            Account acc2=new Account();
            acc2.Name='Test Survey Account6';
            acc2.Company_Name__c=company.id;
            acc2.Total_MRR__c=10004;
            acc2.Account_Manager__c=adminUser.id;
            acc2.RecordTypeId =productAccountRecordTypeId;
            lstacc.add(acc2);
        
            insert lstacc;        
            System.debug('lstacc:' + lstacc);
   
        try{ 
          OPC_Account_Survey__c opcNew =New OPC_Account_Survey__c();                
            opcNew.Account_Name__c=lstacc[0].id;
            opcNew.Account_Manager__c=adminUser.id;
            opcNew.Survey_Date__c=System.today().addDays(8);
            opcNew.survey_Complete_Date__c =System.today().addDays(20);
      		insert opcNew; 
            
               Datetime pastCreatedDate = System.now().addDays(20);
     		 Test.setCreatedDate(opcNew.Id, pastCreatedDate);
            
             }catch(DmlException e){
             System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION' , e.getDmlStatusCode(0) ); 
        }    
        
      
          
	try{
    	OPC_Account_Survey__c opcNew2 =New OPC_Account_Survey__c();                
            opcNew2.Account_Name__c=lstacc[1].id;
            opcNew2.Account_Manager__c=adminUser.id;
            opcNew2.Survey_Date__c=System.today().addDays(8);
            opcNew2.survey_Complete_Date__c = System.today().addDays(20);
      		insert opcNew2; 
              }catch(DmlException e){
             System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION' , e.getDmlStatusCode(0) ); 
        }  
        
          Test.starttest();
            List<OPCPilotUser__c> opcpilotuserlist = [select id,name,isactive__c from OPCPilotUser__c where isactive__c=True];
                Set<string> userlist=new Set<string>();
                for(OPCPilotUser__c opc:opcpilotuserlist){
                    userlist.add(opc.name);                    
                }
        
               SendSurveyEmailBatch sendemail=New SendSurveyEmailBatch(userlist);
                Database.executebatch(sendemail);          
        
            Test.stopTest();
    }

    

    Public Static TestMethod void scheduleClass(){
        test.starttest();
         SendSurveyEmailSchedule firstTUE = new SendSurveyEmailSchedule();
        String sched1 = '0 0 6 ? 1/1 TUE#1 *';
     //  System.schedule('JobOn1stTuesdayTest',sched1,firstTUE);
           
                
        SendSurveyEmailSchedule firstTHU = new SendSurveyEmailSchedule();
        String sched2 = '0 0 6 ? 1/1 THU#1 *';
        System.schedule('JobOn1stThursdayTest',sched2,firstTHU);
        
        SendSurveyEmailSchedule secondTUE = new SendSurveyEmailSchedule();
        String sched3 = '0 0 6 ? 1/1 TUE#2 *';
        System.schedule('JobOn2ndTuesdayTest',sched3,secondTUE);
        
        SendSurveyEmailSchedule secondTHU = new SendSurveyEmailSchedule();
        String sched4 = '0 0 6 ? 1/1 THU#2 *';
        System.schedule('JobOn2ndThursdayTest',sched4,secondTHU);
        test.stopTest();
    }
}