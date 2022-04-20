/********************************************************************
// Purpose              : SFDC-7281 -- Partner Company Historical records are shared Upto 3 level Parent Partner Company
// Author               : Rackspace [Rishabh]
// Parameters           : List<Account>
//  Returns             : null
//JIRA Reference        : SFDC-7281 -- Partner Company Historical records are shared Upto 3 level Parent Partner Company
//********************************************************************/
public class ProcessingExistingRecordsBatch implements Database.Batchable<sObject> {

 
    ProcessingExistingRecordsHelper batchhelper;

    public ProcessingExistingRecordsBatch() {
        batchhelper = new ProcessingExistingRecordsHelper();
    }
    
    String querystring;
    String accountRecordType = 'Partner Company';
    String partnerStatus = 'Approved';

    public Database.QueryLocator start(Database.BatchableContext bc){
        querystring = '';            
        querystring = 'Select Id,ParentId,Parent.ParentId,Parent.Parent.ParentId,RecordTypeId,Partner_Account_Status__c FROM Account';
        querystring += ' WHERE Partner_Account_Status__c =: partnerStatus AND '; 
        querystring += ' RecordType.Name =: accountRecordType';

        return Database.getQueryLocator(querystring);
    }

    public void execute(Database.BatchableContext bc, List<Account> scope){
        batchhelper.updateRecords(scope);
    }

    public void finish(Database.BatchableContext bc){
        System.debug('Inside Finish method');
    }
}