@isTest
public class OPCAccountSurveyTriggerHelperTest {
    @isTest 
     static void requiredFieldsTest(){
         Trigger_Manager__c tm = new Trigger_Manager__c(name = 'OPCAccountSurveyTrigger',Is_Active__c= True);
         insert tm;
        //User u = [SELECT Id,name FROM User WHERE isActive = True LIMIT 1];
     /*   Account a = new Account(Name='Test Account1234',BillingCountry='India',ShippingCountry='India');
        insert a;
        Accounts__c ac = new Accounts__c(Name='Test C Account',Company_Name__c=a.Id,Shipping_Country__c='India');
        insert ac; */
         string companyRecordTypeId =  Schema.sObjectType.account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
    
    string productAccountRecordTypeId =  Schema.sObjectType.account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
       Account cmpAc = new Account(Name='Comp account',RecordTypeId =companyRecordTypeId,BillingCountry='India',ShippingCountry='India',territory__c = 'ANZ');
        insert cmpAc ;
        
         Account a = new Account(Name='Test Account1234',RecordTypeId =productAccountRecordTypeId,BillingCountry='India',ShippingCountry='India',company_name__C = cmpAc.id);
        insert a;
         
        OPC_Account_Survey__c opc = new OPC_Account_Survey__c();
        //opc.Name=OPC-{000000};
        opc.Account_Name__c=a.id;
        opc.CurrencyIsoCode='USD';
       // opc.Account_Manager__c=u.id;
        opc.Survey_Date__c=System.today().addDays(8);
        opc.Survey_Complete_Date__c=System.today().addDays(10);
        opc.Monthly_Call_Recap__c='yes';
        opc.Customer_s_Current_Pulse__c='Customer is engaged and happy with Rackspace Public Cloud';
        insert opc;
       
        opc.Customer_s_Current_Pulse__c='Customer is exhibiting churn indicators (including lack of interactions)Customer is leaving Rackspace';
        opc.Expected_START_Churn_Date__c=System.today().addDays(22);
        opc.Expected_STOP_Churn_Date__c=System.today().addDays(25);
        
        update opc;
         opc.Survey_Complete_Date__c = null;
         try{
              update opc;
         }
         catch(exception e){
         }
          opc.Survey_Complete_Date__c=System.today().addDays(10);
       
         opc.Customer_s_Current_Pulse__c = null;
         try{
              update opc;
         }
         catch(exception e){
         }
         
         opc.Customer_s_Current_Pulse__c='Customer is engaged and happy with Rackspace Public Cloud';
         opc.Monthly_Call_Recap__c = null;
         try{
              update opc;
         }
         catch(exception e){
         }
         opc.Monthly_Call_Recap__c= 'Submitted';
         opc.Customer_s_Current_Pulse__c = 'Customer is exhibiting churn indicators (including lack of interactions)Customer is leaving Rackspace';
                
          opc.Expected_START_Churn_Date__c = null;
         try{
              update opc;
         }
         catch(exception e){
         }
         opc.Expected_START_Churn_Date__c = System.today().addDays(22); 
         opc.Expected_STOP_Churn_Date__c= null;
         try{
              update opc;
         }
         catch(exception e){
         }
         
         
     

         Delete opc;
         Undelete opc;
         
        
        
    }
}