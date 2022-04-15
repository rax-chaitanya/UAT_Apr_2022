/**
*  @author: Diego Castro 
*  @story: SFSB-616
*  @class: QLDeleteOppIDBatch
*  @date: 04/28/2017
*  @description: batch apex to deletes SFDCDevices under an opportunity. should be scheduled to run in off-peak hours
*  @return: 
*/    
global class QLDeleteOppIDBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String[] oppIds = Label.QLDeleteOppID.split(',');
        String query = 'Select Id from Quote_Line__c where Opportunity_Quote__c IN :oppIds'; 
        return Database.getQueryLocator( query );
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        try {
            delete scope;
            
            System.debug('just deleted: ' + scope.size() + 'records'); 
        } catch (Exception e) {
            if (!Test.isRunningTest()) {
                ExceptionHandler.postToAll(e, false);
            } 
        }
    }
    
    
    global void finish(Database.BatchableContext BC) {
        
    }
    

    
    
    
    
}