@isTest
public class SendReminderMailTest {
    @isTest(SeeAllData=false) static void test1() {
     
       Id STId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        Account company = new Account(Name = 'TestCompany', Opt_Out__c = false,BillingCountry = 'Canada', ShippingCountry = 'Canada',RecordTypeId=STId,Company_Access_Submitter__c = UserInfo.getUserId());
        insert company;
     
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setComments('Submitting request for approval.');
        app.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        app.setObjectId(company.id);
        app.setSubmitterId(UserInfo.getUserId());
        app.setProcessDefinitionNameOrId('Company_Access_Request_1');
        Approval.ProcessResult result = Approval.process(app);
        Datetime lastweek = Datetime.now().addDays(-10);
        Test.setCreatedDate(result.getEntityId(), lastweek);
        Test.setCreatedDate(result.getInstanceId(), lastweek);
        Test.setCreatedDate(company.ID, lastweek);
         User u = [Select id, name, email from User where alias = 'sysadmin' AND UserType = 'Standard'  LIMIt 1];
        system.runas(u){
            Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
            Account a = new Account(RecordTypeId =devRecordTypeId,Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
            insert a;
           // u.Email='testAbc@gmail.com';
           
            //update u;
        processInstance pi = [select id, TargetObjectId  from processInstance where TargetObjectId = :company.id LIMIT 1];
        processInstanceWorkITem wi = [select id , actorid,actor.email, ProcessInstanceId from processInstanceWorkItem  limit 1];
        wi.ProcessInstanceId = pi.id;
        wi.ActorId = u.id;
       // wi.actor.email=u.Email;    
      update u;
       Test.setCreatedDate(wi.ID, lastweek);
            
        
        Test.startTest();
         Id batchJObId=Database.executeBatch(new SendReminderMail(), 200);
            
        Test.stopTest();
     }


    }
     @isTest static void testMethod1(){
        user us =[select id from user where managerid != null LIMIT 1];
        List<Trigger_Manager__c> tms = new List<Trigger_Manager__c>();
        tms.add( new Trigger_Manager__c(name='CompanyTrigger',Is_Active__c=true));
       // insert tms;
        Id STId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        Account company = new Account(Name = 'TestCompany', Opt_Out__c = false,BillingCountry = 'Canada', ShippingCountry = 'Canada',RecordTypeId=STId,Company_Access_Submitter__c = us.ID);
        insert company;
        //Account company = new Account(Name = 'Test Account',RecordTypeId=PartnerrecordTypeId,Partner_Account_Status__c ='Approved',phone ='1212121212', BillingCountry = 'India', ShippingCountry = 'India',BillingState='Karnataka');
        //insert company;
        
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setComments('Submitting request for approval.');
        app.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        app.setObjectId(company.id);
        app.setSubmitterId(UserInfo.getUserId());
        app.setProcessDefinitionNameOrId('Company_Access_Request_1');
        Approval.ProcessResult result = Approval.process(app);
        Datetime lastweek = Datetime.now().addDays(-10);
        Test.setCreatedDate(result.getEntityId(), lastweek);
        Test.setCreatedDate(result.getInstanceId(), lastweek);
        Test.setCreatedDate(company.ID, lastweek);
         User u = [Select id, name, email from User where id=: UserInfo.getUserId()];
        system.runas(u){
            Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
            Account a = new Account(RecordTypeId =devRecordTypeId,Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
            insert a;
           
            //update u;
        processInstance pi = [select id, TargetObjectId  from processInstance where TargetObjectId = :company.id LIMIT 1];
        processInstanceWorkITem wi = [select id , actorid,actor.email, ProcessInstanceId from processInstanceWorkItem  LIMIT 1];
        wi.ProcessInstanceId = pi.id;
        wi.ActorId = u.id;
        update u;
        Test.setCreatedDate(wi.ID, lastweek);       
         // wit.ElapsedTimeInDays = 10;
        //Test.setCreatedDate(wit.id, lastweek);
        //update wi;
        
       /*processInstance piw = [select id, TargetObjectId  from processInstance where TargetObjectId = :company.id LIMIT 1];
        ProcessInstanceWorkitem pworkItem = new ProcessInstanceWorkitem();
        pworkItem.ActorId = userinfo.getuserId();
        pworkItem.OriginalActorId = userinfo.getuserId();
        pworkItem.ProcessInstanceId = piw .id;
        insert pworkItem;*/
        Test.startTest();
            
        Id batchID= Database.executeBatch(new SendReminderMail(), 2000);
            SchedulableContext sc = null;
            sendRemainderMailSchedular sms=new sendRemainderMailSchedular();
            sms.execute(sc);
            
        Test.stopTest();
   }
     }
}