/**********************************************************************************

Author:Thirupathi Aeneni
Description: This utility apex class is created for the Story : SFDC-2278.

**********************************************************************************/
global class Company_ActivityCountResetBatch Implements Schedulable, Database.Batchable<sObject>{
    global void execute(SchedulableContext sc) {
        Database.executeBatch(this);
    }
    
    global database.queryLocator start(Database.BatchableContext BC) {
        return database.getQueryLocator('Select Id,Company_Named_Account__c FROM Account WHERE Company_Named_Account__c = \'ABM\' ');
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        Database.update(scope, false);
    }
    
    global void finish(Database.BatchableContext BC) {}
}