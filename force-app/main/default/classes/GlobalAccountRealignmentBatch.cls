global class GlobalAccountRealignmentBatch Implements Schedulable, Database.Batchable<sObject>{
    global void execute(SchedulableContext sc) {
        Database.executeBatch(this);
    }
    
    //This is the query that is passed to the execute method.  It queries all of the Contacts who have passed
    String query = 'Select Id FROM Realignment_Request_Item__c WHERE (Request_Status__c = \'Approved\' OR Request_Status__c =\'Auto Approved\') AND Move_Date__c <= TODAY AND Processed__c = False ORDER BY CreatedDate';
    
    global database.queryLocator start(Database.BatchableContext BC) {
        return database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Realignment_Request_Item__c> scope) {
        Database.update(scope);
    }
    
    global void finish(Database.BatchableContext BC) {}
}