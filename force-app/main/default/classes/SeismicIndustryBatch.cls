/**********************************************************************************

Author: Vinod Thupakula
Description: This batch apex class is created for the update on Company(Account) object with matching industry.
**********************************************************************************/
global class SeismicIndustryBatch implements Database.Batchable<SObject>{
    Map<String,String> seismicSettings;
    global SeismicIndustryBatch(Map<String,String> seismicSettings){
        this.seismicSettings= seismicSettings;         
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Set<String> industries = seismicSettings.keySet();
         
        String query = 'SELECT Id,Name,Industry FROM Account WHERE Industry IN:industries And Vertical__C =null';       
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Account> scope) { 
            for(Account acc:scope){
                if(String.isNotBlank(acc.Industry)&&seismicSettings.containsKey(acc.Industry)){
                    acc.Vertical__c = seismicSettings.get(acc.Industry);
                }
                else{
                     acc.Vertical__c = '';
                }
            }         
        
        update scope;
    }
     
    global void finish(Database.BatchableContext BC) {}
}