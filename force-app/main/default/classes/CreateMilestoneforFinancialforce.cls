/*
Author- Raushan Kumar
Date-Nov 6th 2018
Story-SFDC-2663
Description-Created this class to eliminate the data descripancy issue during FF migration.
*/

Global class CreateMilestoneforFinancialforce implements database.batchable<sObject>{

Global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator( [select id,name,(select id,name,amount__c,Vendor_Invoice_Name__c,pse__Date__c,Project__c from Vendor_Invoices__r) from pse__Proj__c Where Id IN(Select Project__c From pse__Vendor_Invoice__c) AND pse__region__r.name='North America' ]
        );
    }
   global void execute(Database.BatchableContext bc, List<pse__proj__c> scope){
   List<pse__milestone__c> listmile=new List<pse__milestone__c>();
for(pse__proj__c pro: scope){
    for(pse__Vendor_Invoice__c vendor: pro.Vendor_Invoices__r){
        pse__milestone__c mile=new pse__milestone__c();
        mile.Name=vendor.Vendor_Invoice_Name__c;
        mile.pse__Target_Date__c=vendor.pse__Date__c;
        mile.pse__Actual_Date__c=vendor.pse__Date__c;
        mile.pse__Milestone_Amount__c=vendor.Amount__c;
        mile.pse__Project__c=vendor.Project__c;
        mile.pse__Description__c='Created for Milestone Linking '+vendor.name;
        listmile.add(mile);
    }
    
}
if(listmile.size()>0)       
insert listmile;
   }
global void finish(database.batchablecontext bc){}

}