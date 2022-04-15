/**********************************************************************************
Author: Vinod Thupakula
Description: This batch class is created for the creating Partner Company records in CompensationOwner table
             from Account object on every month end
Story: SFDC-2425  
**********************************************************************************/
global class CompensationOwnerBatch implements Database.Batchable<SObject>,Schedulable {   

   global Database.QueryLocator start(Database.BatchableContext BC){
      Id accRID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId(); 
      return Database.getQueryLocator('Select Id, OwnerId from Account where IsPartner = true and RecordTypeId=:accRID and Partner_Account_Status__c = \'Approved\'');
   }

   global void execute(Database.BatchableContext BC, List<Account> scope){
     List<Compensation_Owner__c> compensations = new  List<Compensation_Owner__c>();     
     for(Account acc : scope){
         Compensation_Owner__c comp = new Compensation_Owner__c();
         comp.Partner_Company__c = acc.Id;
         comp.Partner_Company_Owner__c = acc.OwnerId;
         comp.Month__c =  String.valueOf(system.Date.today().Month());
         comp.Year__c = String.valueOf(system.Date.today().Year());
         compensations.add(comp);
     }

     if(compensations.size()>0){insert compensations;}
    }

   global void finish(Database.BatchableContext BC){
   }
   
   global void execute(SchedulableContext sc) 
    {   database.executebatch(new CompensationOwnerBatch(),200);
    }
}