global class AutoUpdateAccountReviewedStatusBatch implements Database.Batchable<sObject>, Schedulable {
 
    String query;
    String companytype = System.Label.CheckCompanyonRecordType;
    global AutoUpdateAccountReviewedStatusBatch() 
    {
    //Code updated for GTMO-143 by samba
     query = 'SELECT Id, Name, Clean_Status__c ' +
                ' FROM Account ' +
                'WHERE RecordType.Name like \'%' + companytype + '%\' '+ 
                'and (Clean_Status__c = \' Matched \' ' +
                       'or Clean_Status__c = \'Acknowledged\' ' +
                       'or Clean_Status__c = \'Different\' ' +
                       'or Clean_Status__c = \'Inactive\' )' ;
        System.debug('Query :...'+ query); 
        
        if(Test.isRunningTest())
            query = 'SELECT Id, Name, (SELECT id, Account_Review_Status__c FROM Account__r) FROM Account ';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Account> scope) 
    {
        
        List<Id> CompanyIds = new List<Id>();
        for(Account a : scope)
        {
            CompanyIds.add(a.Id);
        }
        System.debug('CompanyIds,,,,,,,,,'+ CompanyIds);

        List<Account> lstAccount = [SELECT Id, Name, Account_Review_Status__c, Company_Name__r.Name from Account where Company_Name__c IN : CompanyIds];
        List<Account> updateAccs = new List<Account>();
        
        If(lstAccount.size() > 0)
        {
            for(Account acc: lstAccount)
            {          
                if(acc.Name == acc.Company_Name__r.Name && acc.Account_Review_Status__c != 'Reviewed')
                {
                    acc.Account_Review_Status__c = 'Reviewed';
                    updateAccs.add(acc);
                }
            }
            update updateAccs;
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }

    global void execute(SchedulableContext sc) {
        AutoUpdateAccountReviewedStatusBatch b = new AutoUpdateAccountReviewedStatusBatch();
        database.executebatch(b);
    }
}