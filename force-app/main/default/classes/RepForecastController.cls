public class RepForecastController {    
    
    @AuraEnabled
    public static List<Account> getOwnedAccounts(String rec_id) {
        Integer nextN = Integer.valueOf(Label.Next_N_Months);
        Id userId = UserInfo.getUserId();
        Integer lim = 10;
        Account[] accs = new list<Account>();
        
        String query = 'SELECT Id, name, Account_Number__c, Type, (Select Id, Name, Amount__c, Account__c, Month__c, Year__c, CurrencyIsoCode  from Revenue_Forecasts__r WHERE Period__c = THIS_MONTH OR Period__c = NEXT_N_MONTHS:' + nextN + ' Order by Year__c, Month__c) FROM Account ';
        String whereClause = 'WHERE';
        //if there is nothing passed into the rec_id URL param, query accounts owned by the user in context
        if (String.isBlank(rec_id)) {
            System.debug(query + whereClause);
            whereClause += ' OwnerId = :userId ORDER BY createdDate ASC LIMIT :lim';
        } else {    // otherwise query all revenue forecasts that exist under the account id
            whereClause += ' Id = :rec_id';
        }
        
        accs = Database.query(query + whereClause);
        return accs;
    }
    
    
    
     @AuraEnabled
    public static Revenue_Forecast__c getRevenueForecast(String theID) {
        Revenue_Forecast__c[] ret = new List<Revenue_Forecast__c>();
        
        ret = [Select Id, Name, Amount__c, Account__c, Month__c, Year__c, CurrencyIsoCode from Revenue_Forecast__C WHERE Id = :theId LIMIT 1];
        
        if (ret.size() != 1) {
            ret.add(new Revenue_Forecast__c(Amount__c = 0.00 ) );
        }
        
        return ret[0];
    }
    
    
    @AuraEnabled
    public static map<Id, Revenue_Forecast__c> getRevenueForecastsByAccountIdMap(String accountID) {
        System.debug('accountID: ' + accountID);
        Integer nextN = Integer.valueOf(Label.Next_N_Months);
         map<Id, Revenue_Forecast__c>  ret = new map<Id, Revenue_Forecast__c>();
        ret =  new map<id, revenue_forecast__c>( (Revenue_Forecast__c[])
            Database.query('Select Id, Name, Amount__c, Account__c, Month__c, Year__c, CurrencyIsoCode  from Revenue_Forecast__c WHERE Account__c = :accountID AND (Period__c = THIS_MONTH OR Period__c = NEXT_N_MONTHS:' + nextN + ') Order by Year__c, Month__c ')
        );
        System.debug('map: ' + ret);
        return ret;
    }
    
    
    @AuraEnabled
    public static Map<Id, map<string, Revenue_Forecast__c>> upsertRevenueForecasts(Revenue_Forecast__c[] revenue_forecasts) {
    Map<Id, map<string, Revenue_Forecast__c>> ret = new Map<Id, map<string, Revenue_Forecast__c>>();
        list<revenue_forecast__c> rets = new list<revenue_forecast__c>();
        for (Revenue_Forecast__c rf : revenue_forecasts) {
            if (String.isBlank((String.valueOf(rf.Amount__c) ) ) ){            
                rf.Amount__c = 0.00;
            }
            rets.add(rf);
            System.debug('RepForecastController::upsertRevenueForecasts::rev_forecast'+rf);
        }
        upsert rets;
        
        for (Revenue_Forecast__c rf : revenue_forecasts) {
            String formattedDate = rf.Month__c + '-' + rf.Year__c;
            if (ret.containsKey(rf.Account__c)) {
                ret.get(rf.Account__c).put( formattedDate,  rf);
            } else {
               ret.put( rf.Account__c, new map<string, revenue_forecast__c>{ formattedDate => rf});
            }
            
        }
        return ret;
    }
    
    
    @AuraEnabled
    public static String upsertRevenueForecast(Revenue_Forecast__c rev_forecast, String theID) {
        try{
            System.debug('RepForecastController::upsertRevenueForecast::rev_forecast.id'+rev_forecast.ID);
            System.debug('RepForecastController::upsertRevenueForecast::rev_forecast'+rev_forecast);
            
            if(rev_forecast != null){
                if (String.isNotBlank(rev_forecast.id)) {
                    update rev_forecast;
                }  else if (String.isNotBlank(theId)) {
                    rev_forecast.id = theId;
                    update rev_forecast;
                }
                else {
                    insert rev_forecast;
                }
                return rev_forecast.id;
            }
            return 'null object passed';
            
        } catch (Exception ex){
            return ex.getMessage();
        }        
    }

    
    
    @AuraEnabled
    public static Revenue_Forecast__c newRevenueForecast() {
        return (Revenue_Forecast__c)Revenue_Forecast__c.sObjectType.newSObject(null, true);
    }    
    
    @AuraEnabled
    public static Revenue_Forecast__c findRevenueForecast(String accountId, String period) {
        try {
            System.debug('accountId: ' + accountId + ', period: ' + period);
            List<Revenue_Forecast__c> forecast = [Select Id, Name from Revenue_Forecast__c where Account__c = :accountId AND Name = :period LIMIT 1];
            if (forecast.size() > 0) {
                return forecast[0];
            } 
        } catch (Exception e) {
            throw new CustomException('e: ' + e.getMessage());
        }
        return null;
    }
    
    @AuraEnabled
    public static Date[] getForecastedDates() {
        Integer nextN = Integer.valueOf(Label.Next_N_Months);
        Date[] forecastedDates = new list<Date>();
        for (Integer i = 0; i <= nextN; ++i) {
            Date d = Date.today().addMonths(i);
            Date dt = Date.newInstance(d.year(),d.month(),d.day());//.format('MMMM yyyy');
            forecastedDates.add(dt);
        }
        return forecastedDates;
    }
    
    @AuraEnabled
    public static Account saveAccount(Account acc) {
        upsert acc;
        return acc;
    }        
    

}