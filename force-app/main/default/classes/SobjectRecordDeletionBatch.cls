global class SobjectRecordDeletionBatch implements Database.Batchable<sObject>,Schedulable 
{
    public String sobjectname;
    public SobjectRecordDeletionBatch(String sobjectname){this.sobjectname = sobjectname;}
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        Records_Deletion__c rd = Records_Deletion__c.getValues(sobjectname);
		return Database.getQueryLocator('Select id from '+sobjectname+' where '+rd.Filtered_Field__c+' '+rd.Filtered_Operator__c+' '+rd.Filtered_Value__c);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope) 
    {
        Delete scope;
    }
    global void finish(Database.BatchableContext BC) {
    }
    global void execute(SchedulableContext sc) 
    {
        database.executebatch(new SobjectRecordDeletionBatch(sobjectname),200);
    }
}