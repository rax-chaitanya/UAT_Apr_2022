/**********************************************************************************

Author: Omkar Narkar,Thirupathi Aeneni
Description: This utility apex class is created for the Global Account Realignment. Epic : SFDC-2278.
* Last modified : MAR 2022,Dev- Chaitanya,Jira - SFDC-7193 and SFDC-7420
* Test Class - GlobalAccountSearchController_Test
**********************************************************************************/
public without sharing class GlobalAccountSearchController {
    
    private static Map<String, UploadedRecord> uploadedFileMap = new Map<String, UploadedRecord>();
    private static Integer count = 0;
    private static Integer Totalcount = 0;

    private static Set<String> uploadedAccountNumbers = new Set<String>();
    
    @AuraEnabled
    Public static Object getInitData(){
        Map<String, Object> result = new Map<String, Object>();
        
        result.put('isValidUser', isValidUser());
        result.put('Reasons', ApexDependentPicklistUtility.getPicklistValues('Realignment_Request_Item__c', 'Reason_for_Move__c'));
        //Commented For GTMO-608
        result.put('showWarning', !AccountRealignmentUtility.canProcessRealignmentRequests());
        result.put('warningMessage', 'Realignment requests will be processed on or after '+CalendarUtility.getNthBusinessDay(Datetime.now().dateGMT(), 6).format());
        result.put('Today', ''+Date.today().year()+'-'+Date.today().month()+'-'+Date.today().day());
        /* SFDC-7193 changes
* 
*/
        //result.put('Type', ApexDependentPicklistUtility.getPicklistValues('Account', 'Type'));
        result.put('OwnerRegion', ApexDependentPicklistUtility.getPicklistValues('User', 'Region__c'));
        //result.put('OwnerSubRegion', ApexDependentPicklistUtility.getPicklistValues('User', 'Sub_Region__c'));
        result.put('RegiontodependentSubRegion', ApexDependentPicklistUtility.getDependentOptions('User', 'Region__c','Sub_Region__c'));
        result.put('Industry', ApexDependentPicklistUtility.getPicklistValues('Account', 'Industry'));
        return result;
    }
    
    private static boolean isValidUser(){
        return FeatureManagement.checkPermission('Global_Account_Realignment');
    }
    
    
    //public static Object getSearchResults(String accName, List<String> accNumbers, String accType, String accOwner, Boolean matchingAccounts){
    /* SFDC-7193 changes
* 
*/
    @AuraEnabled
    public static Object getSearchResults(String accName, List<String> accNumbers, 
                                          String accOwnerRegion ,String accOwnerSubRegion ,String accIndustry ,
                                          String accOwner, Boolean matchingAccounts,Integer recLimit)
    {
        
        Map<String, Object> searchResult = new Map<String, Object>();
        accNumbers = accNumbers == null ? new List<String>() : accNumbers;
        
        Set<String> accNumberSet = new Set<String>(accNumbers);
        accNumberSet.remove(null);
        accNumberSet.remove('');
        
        uploadedAccountNumbers.addAll(accNumberSet);
        
        //List<Id> CMPIds = CMPorACCRecordType_Utility.query_Utility(Label.CompanyRecordTypes);
        List<Id> CMPIds = CMPorACCRecordType_Utility.query_Utility(Label.GARTCompanyRecTypes);
        
        Set<Id> accountIds = new Set<Id>();
        String queryLike = '';
        string totalCountQuery='';
        String query = 'Select Id, Company_Name__c From Account where Id != null AND RecordTypeId IN : CMPIds ';
        if(String.isNotBlank(accName)){
            query += 'AND Name like \''+accName+'%\' ';
        }
        if(accNumberSet!=null && !accNumberSet.isEmpty()){
            query += 'AND Company_Number__c IN: accNumberSet ';
        }
                /* SFDC-7193 changes
* 
*/
        /*if(String.isNotBlank(accType)){
            query += 'AND Type =\''+accType+'\' ';
        }*/
        if(String.isNotBlank(accOwner)){
            query += 'AND OwnerId =\''+accOwner+'\' ';
        }
        /* SFDC-7193 changes
* 
*/
        if(String.isNotBlank(accOwnerRegion)){
            query += 'AND Owner.Region__c =\''+accOwnerRegion+'\' ';
        }
        if(String.isNotBlank(accOwnerSubRegion)){
            query += 'AND Owner.Sub_Region__c =\''+accOwnerSubRegion+'\' ';
        }
        if(String.isNotBlank(accIndustry)){
            query += 'AND Industry =\''+accIndustry+'\' ';
        }
        if(String.isNotBlank(accOwner)){
            query += 'AND OwnerId =\''+accOwner+'\' ';
        }
        if(recLimit>0){
            totalCountQuery= String.valueOf(query);
 
            query += 'Limit '+recLimit;
            
        }
        
        if(!matchingAccounts){
        }
        for(Account ac : Database.query(query)){
            accountIds.add(ac.id);
        }     
        if(accountIds.size()>0){

            if(String.isNotBlank(totalCountQuery)) 
            {totalCount= Database.query(totalCountQuery).size();}
            
            String resultQuery = 'SELECT Id, Name, Company_Number__c,RecordType.DeveloperName,RecordType.Name ,Account_Number__c, Type, BillingCountry, OwnerId, Owner.ManagerId, Owner.UserRoleId, Owner.UserRole.Name,Owner.Name,Owner.isActive FROM Account';
            if(matchingAccounts){
                resultQuery += ' WHERE Id IN: accountIds ';
            }else{
                resultQuery += ' WHERE Id In : accountIds ORDER BY Name ASC'; 
            }            
            List<Account> companies = Database.query(resultQuery);
            searchResult.put('result', getWrapperDetails(accountIds));
            searchResult.put('count', count);   
            searchResult.put('totalCount', totalCount);         
            
            if(!uploadedAccountNumbers.isEmpty()){
                String accountNumbers = JSON.serialize(uploadedAccountNumbers);
                accountNumbers = accountNumbers.removeStart('[');
                accountNumbers = accountNumbers.removeEnd(']');
                accountNumbers = accountNumbers.remove('"');
                accountNumbers = accountNumbers.replaceAll(',', ', ');
                searchResult.put('missingAccounts', accountNumbers);
                
            }
            return searchResult;
        }else return null;
    }
    
    @AuraEnabled
    public static Object processRealignmentRequest(List<Realignment_Request_Item__c> requestItems){
        return AccountRealignmentUtility.process(requestItems);
    }
    
    @AuraEnabled
    public static Object getUploadedFileDetails(String dataString){
        
        List<UploadedRecord> uploadedRecords = (List<UploadedRecord>)JSON.deserialize(dataString, List<UploadedRecord>.class);
        Set<String> newOwnerIds = new Set<String>();
        List<String> accountNumbers = new List<String>();
        for(UploadedRecord record : uploadedRecords){
            newOwnerIds.add(record.New_Owner_Id);
            accountNumbers.add(record.Account_Number);
            try{
                record.Move_Date_Value = Date.valueOf(record.Move_Date);
            }catch(Exception e){}
        }
        Map<Id, User> userMap = new Map<Id, User>([SELECT Id, Name, UserRole.Name FROM User WHERE Id IN: newOwnerIds]);
        for(UploadedRecord record : uploadedRecords){
            record.New_Owner = userMap.get(record.New_Owner_Id);
            uploadedFileMap.put(record.Account_Number, record);
        }
        
        //return getSearchResults(null, accountNumbers, null, null, true);
        /* SFDC-7193 changes
* 
*/
        return getSearchResults(null, accountNumbers,null,null,null,null, true,0);
        
    }
    
    public class AccountSearchWrapper{
        @AuraEnabled
        public Account Company_info {get;set;}
        @AuraEnabled
        public List<AccountSearchWrapperChild> Account_Info {get;set;}
    }
    
    public class AccountSearchWrapperChild{
        @AuraEnabled
        public Boolean isSearchResult{get;set;}
        @AuraEnabled
        public id Account_id{get;set;}
        @AuraEnabled
        public String Account_Name{get;set;}
        @AuraEnabled
        public String Account_Number{get;set;} 
        @AuraEnabled
        public String Account_Type{get;set;}
        @AuraEnabled
        public String Account_Country{get;set;}
        @AuraEnabled
        public User Account_Current_Owner{get;set;}
        @AuraEnabled
        public Id Account_Current_Owner_Id{get;set;}
        @AuraEnabled
        public Date Request_Item_Move_Date{get;set;}
        @AuraEnabled
        public User Request_Item_New_Owner{get;set;}
        @AuraEnabled
        public String Request_Item_Reason{get;set;}
        @AuraEnabled
        public String Request_Item_Validation{get;set;}
        @AuraEnabled
        public Boolean hasPendingRequestItems{get;set;}
        @AuraEnabled
        public String accountRecordType{get;set;}
        @AuraEnabled
        public Boolean opportunityUpdation{get;set;} //SFDC-6993
    }
    
    public class UploadedRecord{
        @AuraEnabled
        public String Account_Number;
        @AuraEnabled
        public String New_Owner_Id;
        @AuraEnabled
        public String Request_Reason;
        @AuraEnabled
        public String Move_Date;
        @AuraEnabled
        public User New_Owner;
        @AuraEnabled
        public Date Move_Date_Value;
    }
    
    private static List<AccountSearchWrapper> getWrapperDetails(Set<Id> accountIds){
        List<AccountSearchWrapper> wrappedResultList = new List<AccountSearchWrapper>();
        List<String> reasons = ApexDependentPicklistUtility.getPicklistValues('Realignment_Request_Item__c', 'Reason_for_Move__c');
        count = 0;
        for(Account comp : [SELECT Id, Name, Company_Number__c,RecordType.DeveloperName,RecordType.Name ,Account_Number__c, Type, BillingCountry, OwnerId, Owner.ManagerId, Owner.UserRoleId, Owner.UserRole.Name,Owner.Name,Owner.isActive
                            FROM Account WHERE Id IN:accountIds])
        {
            AccountSearchWrapper asw = new AccountSearchWrapper();  
            asw.Company_info = comp;
            asw.Account_Info = new List<AccountSearchWrapperChild>();           
            AccountSearchWrapperChild aswc = new AccountSearchWrapperChild();
            aswc.isSearchResult = accountIds.contains(comp.id);
            aswc.Account_id = comp.id;
            aswc.Account_Name = comp.name;
            aswc.Account_Number = comp.Company_Number__c;
            aswc.Account_Type = comp.Type;
            aswc.Account_Country = comp.BillingCountry;
            aswc.Account_Current_Owner = comp.Owner;
            aswc.Request_Item_Move_Date = System.today();
            aswc.accountRecordType = comp.RecordType.Name;
            aswc.opportunityUpdation = true;
            If(comp.Type == 'Cloud Customer')
                aswc.Request_Item_Move_Date = CalendarUtility.getNthBusinessDay(Date.today().addMonths(1), 6);
            aswc.Request_Item_New_Owner = new User();
            aswc.Request_Item_Reason = '';
            if(uploadedFileMap.containsKey(comp.Company_Number__c)){
                UploadedRecord record = uploadedFileMap.get(comp.Company_Number__c);
                aswc.Request_Item_New_Owner = record.New_Owner;
                aswc.Request_Item_Reason = reasons.contains(record.Request_Reason) ? record.Request_Reason : '';
                aswc.Request_Item_Move_Date = record.Move_Date_Value!=null && record.Move_Date_Value > Date.today() ? record.Move_Date_Value : System.today();
            }
            aswc.Request_Item_Validation = '';
            asw.Account_Info.add(aswc);
            count++;
            
            uploadedAccountNumbers.remove(comp.Company_Number__c);
            wrappedResultList.add(asw);
        }
        return wrappedResultList;
    }
    
}