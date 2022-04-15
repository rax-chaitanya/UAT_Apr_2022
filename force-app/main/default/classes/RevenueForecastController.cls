public class RevenueForecastController {
    //public static Boolean isProduction = UserInfo.getOrganizationId() ==  ProdOrgIDSetting__c.getInstance().ProdOrgId__c;
    
    @AuraEnabled
    public static string getDomain() {
        return String.valueOf ( OrgConstants__c.getInstance('RO-Domain').get( getFieldName() ) );
    }
    
    @AuraEnabled
    public static string getCertificateName() {
        return String.valueOf ( OrgConstants__c.getInstance('RO-Certificate Name').get( getFieldName() ) );
    }
    
    @AuraEnabled
    public static string getFieldName() {
        Boolean isProduction = UserInfo.getOrganizationId() ==  ProdOrgIDSetting__c.getInstance().ProdOrgId__c;        
        return isProduction ? 'Prod_Value__c' : 'Non_Prod_Value__c';        
    }
    
    @AuraEnabled
    public static String getURL(String settingName) {
        return ( getDomain() + String.valueOf( OrgConstants__c.getInstance(settingName).get( getFieldName() ) ) );
    }
    
    @AuraEnabled
    public static Map<string,sObject> getsObject(Id recordId) {
        try {
            String sObjectName = recordId.getSobjectType().getDescribe().getName();
            List<Id> CMPIds = CMPorACCRecordType_Utility.query_Utility(Label.CompanyRecordTypes);
            List<Id> AccIds = CMPorACCRecordType_Utility.query_Utility(Label.AccountRecordTypes);
            String objType;
            if (sObjectName == 'Account') {
                //System.debug(JSON.serialize([Select Id, Name from Account where Id = :recordId]) );
                List<sObject> accList = new List<sObject>();
                accList = [SELECT Id, Name, (SELECT Id, Name, DDI__c, Account_Number__c, Type, BillingCity, Status__c FROM Account__r) FROM Account where Id = :recordId AND RecordTypeId IN : CMPIds];
                objType = 'Company';
                if(accList.isEmpty()){
                    accList = [Select Id, Name, Type, Sub_Type__c, RecordType.Name, Account_Number__c, DDI__c from Account where Id = :recordId AND RecordTypeId IN : AccIds];
                    objType = 'Account';                        
                }   
                //System.debug('accList3:' + accList.size());
                if(!accList.isEmpty()){ 
                    Map<string,sObject> objMap = new Map<string,sObject>();
                    objMap.put(objType,(Account) accList[0]);                   
                    return objMap;
                }
               
            } 
        }  
        
        catch (AuraHandledException ex) {
            AuraHandledException e = new AuraHandledException(ex.getMessage());
            throw e;
        }
        
        
        return null;
    }
    
    
    @AuraEnabled
    public static string serialize(Id recordId) {
        return JSON.serialize(getSObject(recordId));
    }
    
    
    @AuraEnabled
    public static string getObjectName(Id recordId) {
        return recordId.getSobjectType().getDescribe().getName();        
    }
    
    
    
    @AuraEnabled
    public static Object[] getObjectsFromResult(Id recordId, String record, String classType, string settingName) {
        System.debug('recordId: ' + recordId);
        System.debug('classType: ' + classType);
        System.debug('settingName: ' + settingName);
        System.debug('record (as string) : ' + record);
        
        sObject realRecord = (sObject) JSON.deserialize(record, sObject.class);
        System.debug('converted record: ' + realRecord);
        
        Type resultType = Type.forName(classType);
        Object[] objects = new list<Object>();
        
        if (classType == 'AccountsInvoiceSummary') {
            DateTime d = DateTime.newInstance(Date.today().year(), Date.today().month(), 2);
            Integer next_N_Months = Integer.valueOf ( Label.RIS_Next_N_Months );
            
            d = d.addMonths ( next_N_Months );
            
            for (Integer i = 0; i <= next_N_Months; ++i ) {
                AccountsInvoiceSummary ais = new AccountsInvoiceSummary();
                ais.invoiceMonth = d.format('MMM-yyyy');
                objects.add(ais);
                d = d.addMonths(-1);
            }
        }
        
        for (integer i = 0; i < objects.size(); ++i) {
            system.debug(objects[i]);
        }
        
        JSONParser parser = JSON.createParser( getBody(recordId, realRecord, settingName)  );
        
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        Object inv = (Object) parser.readValueAs(resultType);
                        System.debug('inv: ' + inv);
                        objects.add(inv);
                    }
                }
            }
        }          
        return objects;
    }
    
    
    @AuraEnabled
    public static string getBody(Id recordId, sObject recordJSON, String settingName) {
        try {
            
            System.debug('getBody.recordId: ' + recordId);
            System.debug('getBody.recordJSON: ' + recordJSON);
            System.debug('getBody.settingName: ' + settingName);
            
            String sObjectName = getObjectName(recordId);
            String[] params = new list<string>();
            
            if ((recordJSON instanceof Account) && (settingName == 'RO-Summary-Account' || settingName == 'RO-Detail-Account')) {
                params.add(recordId);
            } else if ((recordJSON instanceof Account) && (settingName == 'RO-Summary-Accounts' || settingName == 'RO-Detail-Accounts')) {
                Account acc = (Account) recordJSON;
                if (String.isNotBlank( String.valueOf ( acc.get('Id') ))) {
                    params.add( String.valueOf ( acc.get('Id')));
                    params.add('SalesforceAccount');
                } else {
                    System.debug('acc record id is blank');
                    throw new AuraHandledException('No linkage Id found');
                }
            }
            
            System.debug('getBody.record: ' + recordJSON);
            System.debug('getBody.params: ' + params);
            System.debug(String.format( getURL (settingName), params ));
            
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint( String.format( getURL(settingName), params) );
            req.setMethod('GET');
            req.setClientCertificateName(getCertificateName());
            System.debug('Request####:'+ req);
            System.debug('CERT####:'+ getCertificateName());
            HttpResponse res = h.send(req);
            
            System.debug('Callout Response####:'+res.getBody());  
            
            return res.getBody();
        } catch (CalloutException ce) {
            throw new AuraHandledException('Error: ' + ce.getMessage());
        }
    }
    
    
    
    
    @AuraEnabled
    public static map<string, Account> getAccountsByNumber(String field, String[] accountNumbers) {
        System.debug('field: ' + field);
        System.debug('accountNumbers:'  + accountNumbers);
        map<string, Account> accs = new map<string, Account>();
        List<Id> AccIds = CMPorACCRecordType_Utility.query_Utility(Label.AccountRecordTypes);
        if (String.isNotBlank(field) && accountNUmbers.size() > 0) {    
            for (Account acc : Database.query('SELECT Id, DDI__c, Account_Number__c from Account WHERE ' + field + ' IN :accountNumbers AND RecordTypeId IN :AccIds') ) {
                accs.put(String.valueOf ( acc.get(field)), acc);
            }
        }
        
        return accs;
    }
    
    
    
    @AuraEnabled
    public static map<string, Revenue_Forecast__c> getForecastsByKey(Id recordId) {
        System.debug('getForecastsByKey.recordId: ' + recordId);
        map<String, Revenue_Forecast__c>  ret = new map<String, Revenue_Forecast__c>();
        
        for (Revenue_Forecast__c forecast : Database.query('Select Id, Name, Key__c, Amount__c, CurrencyIsoCode, Account__c, Month__c, Year__c  from Revenue_Forecast__c WHERE Account__c = :recordID AND (Period__c = LAST_N_MONTHS:' + Label.RIS_Last_N_Months + ' OR Period__c = THIS_MONTH OR Period__c = NEXT_N_MONTHS:' + Label.RIS_Next_N_Months + ') Order by Key__c '))        
        {
            ret.put(forecast.Key__c, forecast);
        }
        return ret;
    }  
}