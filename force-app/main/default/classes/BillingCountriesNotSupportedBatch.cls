global class BillingCountriesNotSupportedBatch implements Database.Batchable<sObject>, Schedulable
{
    
    String query;
    global Set<String> SetBillingCountries = new Set<String>();

    global BillingCountriesNotSupportedBatch () 
    {
        
        for(CBDBillingCountry__c country : CBDBillingCountry__c.getAll().values())
        {
            SetBillingCountries.add(country.Name);
        }

        query = 'SELECT Id, BillingCountry, Country_Not_Supported__c ' +
                'FROM Account ' + 
                'WHERE ((BillingCountry != null ' +
                'OR BillingCountry != \'\') ' +
                'AND BillingCountry NOT IN :SetBillingCountries)';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Account> scope) 
    {
        List<Account> companiesToUpdate = new List<Account>();
        for(Account acc : scope)
        {
            acc.Country_Not_Supported__c = true;
            companiesToUpdate.add(acc);
        }

        if(companiesToUpdate != null)
        {
            update companiesToUpdate;
        }

    }
    
    global void finish(Database.BatchableContext BC) {
        
    }

    global void execute(SchedulableContext sc) 
    {
        BillingCountriesNotSupportedBatch b = new BillingCountriesNotSupportedBatch ();
        database.executebatch(b, 200);
    }    
    
}