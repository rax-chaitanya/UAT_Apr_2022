public class SearchLookupClass {
    @AuraEnabled
    public static List <sObject> fetchLookUpValues(String searchKeyWord, String sObjectName) {
        
        String searchKey = '%' + searchKeyWord + '%';

        List <sObject> returnList = new List <sObject> ();
        
        String sQuery = '';
        
        if(sObjectName == 'Queue__c') {
             sQuery =  'select id, Name,isActive__c from ' +sObjectName + ' where isActive__c= true AND Name LIKE: searchKey order by createdDate DESC limit 5';    
        }else {
             sQuery =  'select id, Name from ' +sObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 5';
        }
        List <sObject> lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
}