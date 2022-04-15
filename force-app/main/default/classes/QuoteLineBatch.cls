public class QuoteLineBatch implements Database.Batchable<sobject>{

    
    public Database.QueryLocator start(Database.BatchableContext bc){
        
        return Database.getQueryLocator('SELECT Id FROM Quote_Line__c');
    }
    
    public void execute(Database.BatchableContext bc, List<sobject> records){
        
        update records;
    }
    
    public void finish(Database.BatchableContext bc){
        
    }
    
}