/**********************************************************************************

Author: Thirupathi Aeneni
Description: This apex class is created to reset the Count of activities and Move Account for every quarter. Epic : SFDC-2278.

**********************************************************************************/
global class GAR_ActivityCountResetBatch Implements Schedulable, Database.Batchable<sObject>{
    global void execute(SchedulableContext sc) {
        Database.executeBatch(this);
    }
    
    global database.queryLocator start(Database.BatchableContext BC) {
        return database.getQueryLocator('Select Id,Named_Account__c  FROM Account WHERE Named_Account__c = \'ABM\'');
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        //for(Accounts__c a : scope )
          //  a.Move_Account__C='No';
        Database.update(scope, false);
    }
    
    global void finish(Database.BatchableContext BC) {}
}