/**********************************************************************************

Author: Thirupathi Aeneni
Description: This  apex class is created for the Global Account Realignment. Epic : SFDC-2278.

**********************************************************************************/
public without sharing class LookupUtilityController {
    @AuraEnabled
    public static List<sObject> fetchLookUpValues(String searchKeyWord, String ObjectName , String activeUsers) {
        String searchKey ='%'+ searchKeyWord + '%';
        
        List <sObject> returnList = new List <sObject> ();
        String sQuery;
        if(activeUsers != null && activeUsers == 'Active'){
            sQuery =  'select id,Name,isActive,ManagerId,UserRoleId,UserRole.Name from ' +ObjectName + ' where isActive = true AND Name LIKE: searchKey order by Name ASC Limit 5';
        }
        else{
            sQuery =  'select id,Name,ManagerId,UserRoleId,UserRole.Name from ' +ObjectName + ' where Name LIKE: searchKey order by Name ASC Limit 5';
        }
        List <sObject> lstOfRecords = Database.query(sQuery);
        
        
        return lstOfRecords;
    }
}