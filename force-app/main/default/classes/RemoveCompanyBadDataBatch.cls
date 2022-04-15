global class RemoveCompanyBadDataBatch implements Database.Batchable<sObject>, Database.Stateful, Schedulable
{
    String query;
    global Set<String> SetUSRackspaceAddress = new Set<String>();
    global Set<String> SetUKRackspaceAddress = new Set<String>();
    global Set<String> SetUSAccountNames = new Set<String>();
    global Set<String> SetUKAccountNames = new Set<String>();
    global Set<String> SetBadCompanies = new Set<String>();
    global Set<String> SetBadPotentialAccounts = new Set<String>();
    global Set<String> SetBadWebsites = new Set<String>();
    global Set<String> SetWebsiteDomains = new Set<String>();
    global Boolean isUpdateFlag = false;
    global List<Account> CompaniesToUpdate = new list<Account>();
    global Set<String> SetStatusValues = new set<String>{'In Sync','Different','Reviewed','Inactive'};
       
    global RemoveCompanyBadDataBatch()
    {
        
        query = 'SELECT Id, Name, Website, BillingStreet, BillingCity, ' +
                'BillingCountry, BillingState, BillingPostalcode, Phone ' +
                'FROM Account ' +
                'WHERE CleanStatus NOT IN :SetStatusValues';
        
        for(CBDStreetAddress__c stAdd : CBDStreetAddress__c.getAll().values())
        {
            if(stAdd.Country__c == 'US')
            {
                SetUSRackspaceAddress.add(stAdd.Name);    
            }
            else if(stAdd.Country__c == 'UK')
            {
                SetUKRackspaceAddress.add(stAdd.Name);
            }
        }

        for(CBDCompanyName__c compName : CBDCompanyName__c.getAll().values())
        {
            if(compName.Type__c == 'Set Duns Number - US')
            {
                SetUSAccountNames.add(compName.Name);
            }
            else if(compName.Type__c == 'Set Duns Number - UK')
            {
                SetUKAccountNames.add(compName.Name);
            }
            else if(compName.Type__c == 'Remove From Company Name')
            {
                SetBadCompanies.add(compName.Name);
            }
            else if(compName.Type__c == 'Personal Cloud Account')
            {
                SetBadPotentialAccounts.add(compName.Name);
            }
        }
        
        for(CBDWebsite__c site : CBDWebsite__c.getAll().values())
        {
            if(site.Type__c == 'clear out the Website')
            {
                SetBadWebsites.add(site.Name);
            }
            else if(site.Type__c == 'SetWebsiteDomains')
            {
                SetWebsiteDomains.add(site.Name);
            }
        }
    }
    
    // Start method to execute Query
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);        
    }
    
    // Excute method to run and update Companies by removing bad data
    global void execute(Database.BatchableContext BC, List<Account> scope)
    {
        for(Account acc : scope)
        {
            // US DUNS Number & UK DUNS Numbers  
        
            for(String usAccountName : SetUSAccountNames)
            {
                if(acc.Name.contains(usAccountName))
                {
                    for(String usRackspaceAddress : SetUSRackspaceAddress)
                    {
                        if(acc.BillingStreet.contains(usRackspaceAddress)) 
                        {
                            acc.DunsNumber = label.US_DunsNumber;
                            isUpdateFlag = true;
                            break;
                        }      
                    }
                }
            }

            for(String ukAccountName : SetUKAccountNames)
            {
                if(acc.Name.contains(ukAccountName))
                {
                    for(String ukRackspaceAddress : SetUKRackspaceAddress)
                    {
                        if(acc.BillingStreet.contains(ukRackspaceAddress))
                        {
                            acc.DunsNumber = label.UK_DunsNumber;
                            isUpdateFlag = true;
                            break;
                        }
                    }
                }
            }
            

            // Remove Bad Websites & Personal Cloud Account
            if(acc.Website != NULL)
            {
                // Remove Bad Websites
                for(String badWebSite : SetBadWebsites)
                {
                    if(acc.Website.contains(badWebSite))
                    {
                        acc.Website = '';
                        isUpdateFlag = true;
                        break;
                    }
                }
                // Personal Cloud Account
                for(String account : SetBadPotentialAccounts)
                {
                    for(String website : SetWebsiteDomains)
                    {
                        if(acc.Website.contains(website) || acc.Name.contains(account))
                        {
                            acc.Name = 'Personal Cloud Account';
                            isUpdateFlag = true;
                            break;
                        }
                    }
                }

            }
        
            // Billing Fields
            if(acc.BillingStreet == 'null' || acc.BillingStreet == 'N/A')
            {
                acc.BillingStreet = '';
                isUpdateFlag = true;
            }
            
            if(acc.BillingCity == 'null' || acc.BillingCity == 'N/A')
            {
                acc.BillingCity = '';
                isUpdateFlag = true;
            }
            
            if(acc.BillingCountry == 'null' || acc.BillingCountry == 'N/A')
            {
                acc.BillingCountry = '';
                isUpdateFlag = true;
            }
            
            if(acc.BillingState == 'null' || acc.BillingState == 'N/A')
            {
                acc.BillingState = '';
                isUpdateFlag = true;
            }

            if(acc.BillingPostalCode == 'null' || acc.BillingPostalCode == 'N/A')
            {
                acc.BillingPostalCode = '';
                isUpdateFlag = true;
            }
            
            //Remove bad Company words from the company name
            for(String badCompany : SetBadCompanies) 
            {
                if(acc.Name.contains(badCompany))
                {
                    acc.Name = acc.Name.remove(badCompany);    
                    isUpdateFlag = true;
                }
            }
            
            

            // Company Phone
            String NewPhone = '';
            if(acc.phone != null && !acc.phone.isNumeric() )
            {
                for (String ph : acc.phone.split('|'))
                {
                    if(ph.isNumeric())
                    {
                        NewPhone += ph;
                    }
                }
            acc.Phone = NewPhone;
            isUpdateFlag = true;
            }
            
            if(isUpdateFlag == true)
            {
                CompaniesToUpdate.add(acc);             
            }
        }
        
        if(!CompaniesToUpdate.isEmpty())
        {
            Update CompaniesToUpdate;
        } 
    }
    
    // Finish method
    global void finish(Database.BatchableContext BC){
    }   

    global void execute(SchedulableContext sc) 
    {
        RemoveCompanyBadDataBatch  b = new RemoveCompanyBadDataBatch ();
        database.executebatch(b, 200);
    }    

}