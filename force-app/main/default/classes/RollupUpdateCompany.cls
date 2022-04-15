/*Creating to update towner and Recordtype on Product accounts*/
global class RollupUpdateCompany implements Database.Batchable<sObject>,database.stateful{
    
    String query;
    
    global RollupUpdateCompany(){
        //Migration Record type:recordtypeid = \'0123f000000XdHMAA0\''
        /* query = 'SELECT Id,Number_of_Accounts__c,Total_of_Prospects__c,Number_of_Cloud_Customer_Accounts__c,Number_of_Cloud_Accounts__c,Number_of_Customer_Accounts__c,Total_of_Former_Cloud_Customers__c,Total_of_Former_Customers__c' +
            ' FROM Account where custom_account_sfdc_id__c = null';*/
        
        query = 'SELECT Id,Number_of_Accounts_Old__c,Total_of_Prospects_Old__c,Number_of_Cloud_Customer_Accounts_Old__c,Number_of_Cloud_Accounts_Old__c,Number_of_Customer_Accounts_Old__c,Total_of_Former_Cloud_Customers_Old__c,Total_of_Former_Customers_Old__c' +
            ' FROM Account where custom_account_sfdc_id__c = null';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        list<account> acclist = new list<account>();
        for(Account ac : scope){
          ac.Number_of_Accounts__c= ac.Number_of_Accounts_Old__c;
            ac.Total_of_Prospects__c= ac.Total_of_Prospects_Old__c;
            ac.Number_of_Cloud_Customer_Accounts__c= ac.Number_of_Cloud_Customer_Accounts_Old__c;
            ac.Number_of_Cloud_Accounts__c= ac.Number_of_Cloud_Accounts_Old__c;
            ac.Number_of_Customer_Accounts__c= ac.Number_of_Customer_Accounts_Old__c;
            ac.Total_of_Former_Cloud_Customers__c= ac.Total_of_Former_Cloud_Customers_Old__c;
            ac.Total_of_Former_Customers__c= ac.Total_of_Former_Customers_Old__c; 
            
            /*ac.Number_of_Accounts__c= ac.Number_of_Accounts__c;
            ac.Total_of_Prospects__c= ac.Total_of_Prospects__c;
            ac.Number_of_Cloud_Customer_Accounts__c= ac.Number_of_Cloud_Customer_Accounts__c;
            ac.Number_of_Cloud_Accounts__c= ac.Number_of_Cloud_Accounts__c;
            ac.Number_of_Customer_Accounts__c= ac.Number_of_Customer_Accounts__c;
            ac.Total_of_Former_Cloud_Customers__c= ac.Total_of_Former_Cloud_Customers__c;
            ac.Total_of_Former_Customers__c= ac.Total_of_Former_Customers__c;*/
            acclist.add(ac);
        }
        if(acclist.size() > 0){
            update acclist;
        }
    }
    global void finish(Database.BatchableContext BC){
        
    }
}