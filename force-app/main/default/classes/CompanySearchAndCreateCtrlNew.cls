/**
* File : CompanySearchAndCreateCtrlNew.cls
* Description : Search and create company
* Created Date : 16/July/2018
* @author : Anil
* Purpose : with OffSet SOQL for POC
*/
public without sharing class CompanySearchAndCreateCtrlNew{
    
    //Location Type Picklist
    @AuraEnabled
    public static List<Map<String, String>> fetchLocationType(){
        List<Map<String, String>> items = new List<Map<String, String>>();
        items.add(new Map<String, String>{'value' => '0,1', 'label' => 'HQ + Single Locations'});
        items.add(new Map<String, String>{'value' => '1', 'label' => 'Headquarters Only'});
        items.add(new Map<String, String>{'value' => '0', 'label' => 'Single Locations Only'});       
        
        return items;
    }
    
    //Territory Picklist
    @AuraEnabled
    public static List<Map<String, String>> getTerritory(){
        List<Map<String, String>> items = new List<Map<String, String>>();        
        Schema.DescribeFieldResult fieldResult = account.Territory__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();                
        for( Schema.PicklistEntry f : ple)
        {
            items.add(new Map<String, String>{'value' => f.getValue(), 'label' => f.getLabel()});             
        }       
        
        return items;
    }
    
    @AuraEnabled
    public static Map<String, List<String>> getDependentCountryState(){
        
        return ApexDependentPicklistUtility.getDependentOptions('Account', 'BillingCountryCode', 'BillingStateCode');
    }
    
    //Country Picklist
    @AuraEnabled
    public static List<Map<String, String>> getCountry(){
        List<Map<String, String>> items = new List<Map<String, String>>();        
        Schema.DescribeFieldResult fieldResult = account.BillingCountryCode.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();                
        for( Schema.PicklistEntry f : ple)
        {
            items.add(new Map<String, String>{'value' => f.getValue(), 'label' => f.getLabel()});             
        }       
        
        return items;
    }
    
    @AuraEnabled
    public static CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper fetchResult(String companyName,String website,String locationSel,List<String> territorySel,String countrySel,String stateSel){
        
        map<string, string> DunsToDandBMap = new map<String, string>();
        
        
        Map<Id, Account> companiesMap;
        Map<Id, DataCloudDandBCompany> dAndBCompaniesMap;
        Set<Id> compIdList = new Set<Id>();
        String userId = Userinfo.getUserid();
        List<CompanySearchAndCreateCtrlNew.CompanyWrapper> cmpWrplist;
        List<CompanySearchAndCreateCtrlNew.DandBCompWrapper> dbCmpWrplist;
        String companyQuery = '';
        String dandBCompQuery = '';        
        String companyFilters = '';
        String dAndBCompany = '';
        
        //Changes for - 3863
        Id RBURecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('RBU').getRecordTypeId();
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String MyProflieName = PROFILE[0].Name;
        
        if(String.isNotEmpty(companyName)) {
            String compName = '%' + companyName.trim() + '%';
            companyFilters += ' ( Name LIKE :compName OR TradeStyle LIKE :compName ) ';
            String dbCompName = companyName.trim();
            dAndBCompany += ' Name LIKE :dbCompName ';//AND LocationStatus IN :(0,1)
        }
        if(String.isNotEmpty(website)) {
            String wbSite = '%' + website.trim() + '%';
            companyFilters += ' AND website LIKE :wbSite ';          
        }
        if(String.isNotEmpty(locationSel)) {
            List<String> cmpLoc =  locationSel.split(',');          
            dAndBCompany += ' AND LocationStatus IN:cmpLoc ';
        }
        if(territorySel.size() > 0) {
            List<String> terList = territorySel;
            companyFilters += ' AND Territory__c IN:terList ';          
        }
        if(String.isNotEmpty(countrySel)) {          
            companyFilters += ' AND BillingCountry =:countrySel ';
        }
        if(String.isNotEmpty(stateSel)) {          
            companyFilters += ' AND BillingState =:stateSel ';
        }
         if(MyProflieName =='RBU Profile'){
        companyFilters+=' And RecordtypeId=:RBURecTypeId';
        }
        if(MyProflieName!='RBU Profile'){
        companyFilters+=' And RecordtypeId!=:RBURecTypeId';
        }
        
        companyQuery = 'SELECT ID, Name, TradeStyle, DunsNumber, Company_Access_Submitter__c, OwnerId, Owner.Name, Website, Phone, BillingState, BillingCity, BillingCountry, Owner.ManagerId, Territory__c FROM Account  WHERE ' + companyFilters + ' LIMIT 10';
        
        
        dandBCompQuery = 'SELECT Id, Name, Tradestyle1, URL, Phone, State, Street, City, LocationStatus, Country, DunsNumber, MailingState, MailingCountry FROM DataCloudDandBCompany  WHERE ' + dAndBCompany + ' LIMIT 10';
        
        Integer companyQueryCount = Database.countQuery('SELECT count() From Account  WHERE ' + companyFilters + ' LIMIT 200');
        Integer dandBCompQueryCount = 2000;//Database.countQuery('SELECT count() From DataCloudDandBCompany  WHERE ' + dAndBCompany + ' LIMIT 2000');
        
        
        companiesMap = new Map<Id, Account>();
        for(Account ac:Database.Query(companyQuery))
            companiesMap.put(ac.Id,ac);
        
        dAndBCompaniesMap = new Map<Id, DataCloudDandBCompany>();
        for(DataCloudDandBCompany db:Database.Query(dandBCompQuery))
            dAndBCompaniesMap.put(db.Id,db);
        System.debug('dAndBCompaniesMap:'+dAndBCompaniesMap.size());
        System.debug('companiesMap:'+companiesMap.size());             
        cmpWrplist = new List<CompanySearchAndCreateCtrlNew.CompanyWrapper>();
        compIdList = companiesMap.keySet();
        for (UserRecordAccess ua : Database.query('Select RecordID, HasReadAccess, HasEditAccess From UserRecordAccess Where UserID=:userId AND RecordId IN:compIdList'))
        {
            if(ua.HasEditAccess){
                cmpWrplist.add(new CompanyWrapper(companiesMap.get(ua.RecordId),1));
            }else{
                cmpWrplist.add(new CompanyWrapper(companiesMap.get(ua.RecordId),0));
            }
        }
        
        ///////////////////
        Map<String,DataCloudDandBCompany> queryResultMap = new Map<String,DataCloudDandBCompany>();
        for(DataCloudDandBCompany dbc:dAndBCompaniesMap.values()){
            if(String.isNotBlank(dbc.DunsNumber)){
                DunsToDandBMap.put(dbc.DunsNumber, dbc.id);
            }
            queryResultMap.put(dbc.Id,dbc);
        }
        System.debug('queryResultMap Keyset :'+queryResultMap.keySet());
        System.debug('DunsToDandBMap:'+DunsToDandBMap.keySet());
        
        for (String convertedCompanyDuns : getConvertedCompanyDUNS(DunsToDandBMap)) {            
            System.debug('converted Company Duns: ' + DunsToDandBMap.containsKey(convertedCompanyDuns));            
            //if the set of returned DandB duns numbers contains one of the already converted company duns numbers
            if (DunsToDandBMap.containsKey(convertedCompanyDuns)) {
                //System.debug('convertedCompanyDuns:'+convertedCompanyDuns);
                //System.debug('queryResultMap:'+queryResultMap.get(DunsToDandBMap.get(convertedCompanyDuns)));             
                System.debug('converted Company Duns: ' + convertedCompanyDuns+ '----'+DunsToDandBMap.containsKey(convertedCompanyDuns)+' ID:'+DunsToDandBMap.get(convertedCompanyDuns));
                queryResultMap.remove(DunsToDandBMap.get(convertedCompanyDuns));
            }            
        }
        System.debug('queryResultMap 2:'+queryResultMap.size());
        ///////////////////
        
        dbCmpWrplist = new List<CompanySearchAndCreateCtrlNew.DandBCompWrapper>();
        for(DataCloudDandBCompany db: queryResultMap.values()){
            dbCmpWrplist.add(new DandBCompWrapper(db));
        }
        
        
        CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper resultObj = new CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper(cmpWrplist,0,10,companyQueryCount,dbCmpWrplist,0,10,dandBCompQueryCount);
        
        System.debug('cList:'+resultObj.companyList.size());
        System.debug('dbList:'+resultObj.cloudDBCompList.size());
        
        return resultObj;
    }
    
    public static Set<String> getConvertedCompanyDUNS(map<string, string> DunsToDandBMap) {
        List<Account> companies = new list<Account>();
        Set<String> dunsSet = new Set<String>();
        Set<String> dunsToDandBKeySet = DunsToDandBMap.keySet();            // var used in dynamic query below
        
        companies = Database.query('Select Id,DunsNumber From Account Where DunsNumber IN:dunsToDandBKeySet');
        System.debug('companies--->'+companies.size());
        for (Account c : companies) {
            if (String.IsNotBlank(c.DunsNumber)) {
                dunsSet.add(c.DunsNumber);
            }
        }
        System.debug('Duset:::::'+dunsSet);
        System.debug('Duset:::::'+dunsSet.size());
        return dunsSet;
    }
    
    @AuraEnabled
    public static CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper compNext(String obj,String companyName,String website,List<String> territorySel,String countrySel,String stateSel){
        System.debug('obj------>'+obj);
        System.debug('companyName>>>'+companyName);
        System.debug('territorySel>>>'+territorySel);
        System.debug('countrySel>>>'+countrySel);
        System.debug('stateSel------>'+stateSel);
        CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper objJson = (CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper)JSON.deserializeStrict(obj, CompanyAndCloudDBCompWrapper.class);
        System.debug('objJson------>'+objJson);
        String companyQuery = '';
        String companyFilters = '';
        
         Id RBURecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('RBU').getRecordTypeId();
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String MyProflieName = PROFILE[0].Name;
        
        if(String.isNotEmpty(companyName)) {
            String compName = '%' + companyName.trim() + '%';
            companyFilters += ' ( Name LIKE :compName OR TradeStyle LIKE :compName ) ';          
        }
        if(String.isNotEmpty(website)) {
            String wbSite = '%' + website.trim() + '%';
            companyFilters += ' AND website LIKE :wbSite ';          
        } 
        if(territorySel.size() > 0) {
            List<String> terList = territorySel;
            companyFilters += ' AND Territory__c IN:terList ';          
        }
        if(String.isNotEmpty(countrySel)) {          
            companyFilters += ' AND BillingCountry =:countrySel ';
        }
        if(String.isNotEmpty(stateSel)) {          
            companyFilters += ' AND BillingState =:stateSel ';
        }
        
        if(MyProflieName =='RBU Profile'){
        companyFilters+=' And RecordtypeId=:RBURecTypeId';
        }
        if(MyProflieName!='RBU Profile'){
        companyFilters+=' And RecordtypeId!=:RBURecTypeId';
        }
        objJson.compOffSet = objJson.compOffSet + 10;
        
        Integer cLimit = objJson.compLimit;
        Integer cOffSet = objJson.compOffSet;
        String userId = Userinfo.getUserid();
        
        
        //System.debug('Limit:'+cLimit+'   OffSet:'+cOffSet);
        
        companyQuery = 'SELECT ID, Name, TradeStyle, DunsNumber, Company_Access_Submitter__c, OwnerId, Owner.Name, Website, Phone, BillingState, BillingCity, BillingCountry, Owner.ManagerId, Territory__c FROM Account  WHERE ' + companyFilters + ' LIMIT :cLimit OFFSET :cOffSet';
        
        Map<Id, Account> companiesMap = new Map<Id, Account>((List<Account>)Database.Query(companyQuery));               
        objJson.companyList = new List<CompanyWrapper>();
        Set<Id> compIdList = companiesMap.keySet();
        for (UserRecordAccess ua : Database.query('Select RecordID, HasReadAccess, HasEditAccess From UserRecordAccess Where UserID=:userId AND RecordId IN:compIdList'))
        {
            if(ua.HasEditAccess){
                objJson.companyList.add(new CompanyWrapper(companiesMap.get(ua.RecordId),1));
            }else{
                objJson.companyList.add(new CompanyWrapper(companiesMap.get(ua.RecordId),0));
            }
        }        
        
        objJson.compOffSet = cOffSet;
        //System.debug('objJson.compLimit:'+objJson.compLimit+'   objJson.compOffSet:'+objJson.compOffSet);
        CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper resultObj;// = new CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper(objJson.companyList,cOffSet,cLimit,objJson.totalCmp);
        
        return objJson;
    }
    
    @AuraEnabled
    public static CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper compPrevious(String obj,String companyName,String website,List<String> territorySel,String countrySel,String stateSel){
        System.debug('obj------>'+obj);
        CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper objJson = (CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper)JSON.deserializeStrict(obj, CompanyAndCloudDBCompWrapper.class);
        System.debug('objJson------>'+objJson);
        System.debug('stateSel------>'+stateSel);
        String companyQuery = '';
        String companyFilters = '';
        
        Id RBURecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('RBU').getRecordTypeId();
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String MyProflieName = PROFILE[0].Name;
        
        if(String.isNotEmpty(companyName)) {
            String compName = '%' + companyName.trim() + '%';
            companyFilters += ' ( Name LIKE :compName OR TradeStyle LIKE :compName ) ';          
        }
        if(String.isNotEmpty(website)) {
            String wbSite = '%' + website.trim() + '%';
            companyFilters += ' AND website LIKE :wbSite ';          
        } 
        if(territorySel.size() > 0) {
            List<String> terList = territorySel;
            companyFilters += ' AND Territory__c IN:terList ';          
        }
        if(String.isNotEmpty(countrySel)) {          
            companyFilters += ' AND BillingCountry =:countrySel ';
        }
        if(String.isNotEmpty(stateSel)) {          
            companyFilters += ' AND BillingState =:stateSel ';
        }
        
         if(MyProflieName =='RBU Profile'){
        companyFilters+=' And RecordtypeId=:RBURecTypeId';
        }
        
        if(MyProflieName!='RBU Profile'){
        companyFilters+=' And RecordtypeId!=:RBURecTypeId';
        }
        
        objJson.compOffSet = objJson.compOffSet - 10;
        
        Integer cLimit = objJson.compLimit;
        Integer cOffSet = objJson.compOffSet;
        String userId = Userinfo.getUserid();
        
        System.debug('Limit:'+cLimit+'   OffSet:'+cOffSet);
        
        companyQuery = 'SELECT ID, Name, TradeStyle, DunsNumber, Company_Access_Submitter__c, OwnerId, Owner.Name, Website, Phone, BillingState, BillingCity, BillingCountry, Owner.ManagerId, Territory__c FROM Account  WHERE ' + companyFilters + ' LIMIT :cLimit OFFSET :cOffSet';
        
        Map<Id, Account> companiesMap = new Map<Id, Account>((List<Account>)Database.Query(companyQuery));               
        objJson.companyList = new List<CompanyWrapper>();
        Set<Id> compIdList = companiesMap.keySet();
        for (UserRecordAccess ua : Database.query('Select RecordID, HasReadAccess, HasEditAccess From UserRecordAccess Where UserID=:userId AND RecordId IN:compIdList'))
        {
            if(ua.HasEditAccess){
                objJson.companyList.add(new CompanyWrapper(companiesMap.get(ua.RecordId),1));
            }else{
                objJson.companyList.add(new CompanyWrapper(companiesMap.get(ua.RecordId),0));
            }
        }
        
        //objJson.compLimit = cLimit;
        objJson.compOffSet = cOffSet;
        System.debug('objJson.compLimit:'+objJson.compLimit+'   objJson.compOffSet:'+objJson.compOffSet);
        CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper resultObj;// = new CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper(objJson.companyList,cOffSet,cLimit,objJson.totalCmp);
        
        return objJson;
    }
    
    @AuraEnabled
    public static CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper dbCompNext(String obj,String companyName,String locationSel){
        System.debug('companyName>>>'+companyName);
        System.debug('locationSel>>>'+locationSel);
        
        System.debug('obj------>'+obj);
        CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper objJson = (CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper)JSON.deserializeStrict(obj, CompanyAndCloudDBCompWrapper.class);
        System.debug('objJson------>'+objJson);
        
        Map<Id, DataCloudDandBCompany> dAndBCompaniesMap;
        Set<Id> compIdList = new Set<Id>();       
        List<CompanySearchAndCreateCtrlNew.CompanyWrapper> cmpWrplist;
        List<CompanySearchAndCreateCtrlNew.DandBCompWrapper> dbCmpWrplist;
        
        String dandBCompQuery = '';
        String dAndBCompany = '';
        
        if(String.isNotEmpty(companyName)) {
            String compName = companyName.trim();          
            dAndBCompany += ' Name LIKE :compName';//AND LocationStatus IN :(0,1)
        }        
        if(String.isNotEmpty(locationSel)) {
            List<String> cmpLoc =  locationSel.split(',');          
            dAndBCompany += ' AND LocationStatus IN:cmpLoc ';
        }
        
        objJson.dbOffSet = objJson.dbOffSet + 10;
        
        Integer dbLimit = objJson.dbLimit;
        Integer dbOffSet = objJson.dbOffSet;
        System.debug('----->'+dbLimit);
        System.debug('------>'+dbOffSet);
        
        
        dandBCompQuery = 'SELECT Id, Name, Tradestyle1, URL, Phone, State, Street, City, LocationStatus, Country, DunsNumber, MailingState, MailingCountry FROM DataCloudDandBCompany  WHERE ' + dAndBCompany + ' LIMIT :dbLimit OFFSET :dbOffSet';
        
        //system.debug('\ncontactQuery is : ' + companyQuery + ' \nAND leadQuery is : ' + dandBCompQuery);
        
        dAndBCompaniesMap = new Map<Id, DataCloudDandBCompany>();
        for(DataCloudDandBCompany db:Database.Query(dandBCompQuery))
            dAndBCompaniesMap.put(db.Id,db);
        
        objJson.CloudDBCompList = new List<DandBCompWrapper>();
        
        ///////////////////
        map<string, string> DunsToDandBMap = new map<String, string>();
        Map<String,DataCloudDandBCompany> queryResultMap = new Map<String,DataCloudDandBCompany>();
        for(DataCloudDandBCompany dbc:dAndBCompaniesMap.values()){
            if(String.isNotBlank(dbc.DunsNumber)){
                DunsToDandBMap.put(dbc.DunsNumber, dbc.id);
            }
            queryResultMap.put(dbc.Id,dbc);
        }
        
        for (String convertedCompanyDuns : getConvertedCompanyDUNS(DunsToDandBMap)) {            
            System.debug('converted Company Duns: ' + DunsToDandBMap.containsKey(convertedCompanyDuns));           
            System.debug('converted Company Duns: ' + convertedCompanyDuns+ '----'+DunsToDandBMap.containsKey(convertedCompanyDuns)+' ID:'+DunsToDandBMap.get(convertedCompanyDuns)); 
            //if the set of returned DandB duns numbers contains one of the already converted company duns numbers
            if (DunsToDandBMap.containsKey(convertedCompanyDuns)) {
                String dbId = DunsToDandBMap.get(convertedCompanyDuns);             
                queryResultMap.remove(DunsToDandBMap.get(convertedCompanyDuns));
            }            
        }
        ///////////////////
        
        //for(DataCloudDandBCompany db: dAndBCompaniesMap.values()){
        for(DataCloudDandBCompany db: queryResultMap.values()){
            objJson.CloudDBCompList.add(new DandBCompWrapper(db));
        }       
        objJson.dbOffSet = dbOffSet;
        
        return objJson;
    }
    
    @AuraEnabled
    public static CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper dbCompPrevious(String obj,String companyName,String locationSel){
        
        System.debug('companyName>>>'+companyName);
        
        System.debug('obj------>'+obj);
        CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper objJson = (CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper)JSON.deserializeStrict(obj, CompanyAndCloudDBCompWrapper.class);
        System.debug('objJson------>'+objJson);
        
        Map<Id, DataCloudDandBCompany> dAndBCompaniesMap;
        Set<Id> compIdList = new Set<Id>();       
        List<CompanySearchAndCreateCtrlNew.CompanyWrapper> cmpWrplist;
        List<CompanySearchAndCreateCtrlNew.DandBCompWrapper> dbCmpWrplist;
        
        String dandBCompQuery = '';
        String dAndBCompany = '';
        
        if(String.isNotEmpty(companyName)) {
            String compName = companyName.trim();          
            dAndBCompany += ' Name LIKE :compName';//AND LocationStatus IN :(0,1)
        }
        if(String.isNotEmpty(locationSel)) {
            List<String> cmpLoc =  locationSel.split(',');          
            dAndBCompany += ' AND LocationStatus IN:cmpLoc ';
        }        
        
        objJson.dbOffSet = objJson.dbOffSet - 10;
        
        Integer dbLimit = objJson.dbLimit;
        Integer dbOffSet = objJson.dbOffSet;
        
        
        dandBCompQuery = 'SELECT Id, Name, Tradestyle1, URL, Phone, State, Street, City, LocationStatus, Country, DunsNumber, MailingState, MailingCountry FROM DataCloudDandBCompany  WHERE ' + dAndBCompany + ' LIMIT :dbLimit OFFSET :dbOffSet';
        
        //system.debug('\ncontactQuery is : ' + companyQuery + ' \nAND leadQuery is : ' + dandBCompQuery);
        
        dAndBCompaniesMap = new Map<Id, DataCloudDandBCompany>();
        for(DataCloudDandBCompany db:Database.Query(dandBCompQuery))
            dAndBCompaniesMap.put(db.Id,db);
        
        objJson.CloudDBCompList = new List<DandBCompWrapper>();
        
        ///////////////////
        map<string, string> DunsToDandBMap = new map<String, string>();
        Map<String,DataCloudDandBCompany> queryResultMap = new Map<String,DataCloudDandBCompany>();
        for(DataCloudDandBCompany dbc:dAndBCompaniesMap.values()){
            if(String.isNotBlank(dbc.DunsNumber)){
                DunsToDandBMap.put(dbc.DunsNumber, dbc.id);
            }
            queryResultMap.put(dbc.Id,dbc);
        }
        
        for (String convertedCompanyDuns : getConvertedCompanyDUNS(DunsToDandBMap)) {            
            System.debug('converted Company Duns: ' + DunsToDandBMap.containsKey(convertedCompanyDuns));    
            System.debug('converted Company Duns: ' + convertedCompanyDuns+ '----'+DunsToDandBMap.containsKey(convertedCompanyDuns)+' ID:'+DunsToDandBMap.get(convertedCompanyDuns));        
            //if the set of returned DandB duns numbers contains one of the already converted company duns numbers
            if (DunsToDandBMap.containsKey(convertedCompanyDuns)) {
                String dbId = DunsToDandBMap.get(convertedCompanyDuns);             
                queryResultMap.remove(DunsToDandBMap.get(convertedCompanyDuns));
            }            
        }
        ///////////////////
        
        for(DataCloudDandBCompany db: queryResultMap.values()){
            objJson.CloudDBCompList.add(new DandBCompWrapper(db));
        }       
        objJson.dbOffSet = dbOffSet;
        
        return objJson;
    }
    
    @AuraEnabled
    public static CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper requestCompanyRecordAccess(String obj,String compId){
        System.debug('Company Id:'+compId);
        CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper objJson;// = (CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper)JSON.deserializeStrict(obj, CompanyAndCloudDBCompWrapper.class);
        
        if (String.isBlank(compId)) {
            //msg = new ApexPages.Message(ApexPages.Severity.ERROR,('Could not identify company record. Please refresh this page and try again.'));  
        } else {
            try {
                String status = 'Pending';
                ProcessInstance pi = Database.query ('Select ID, TargetObjectID, CreatedBy.Name From ProcessInstance Where Status =:status AND TargetObjectID =:compId ');
                String uName  = pi.CreatedBy.Name;
                
                objJson = (CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper)JSON.deserializeStrict(obj, CompanyAndCloudDBCompWrapper.class);                
                for(CompanyWrapper cw:objJson.companyList){
                    if(cw.compObj.Id == compId){                        
                        cw.isAccessible = 3;
                    }                                               
                }       
            } catch (QueryException qe) {
                
                try {
                    //stamping this field with a user will kick off the approval process
                    Account companyRecord = new Account();
                    
                    objJson = (CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper)JSON.deserializeStrict(obj, CompanyAndCloudDBCompWrapper.class);
                    for(CompanyWrapper cw:objJson.companyList){
                        if(cw.compObj.Id == compId){
                            cw.compObj.company_Access_Submitter__c = UserInfo.getUserId();                            
                            companyRecord = cw.compObj;
                            cw.isAccessible = 2;
                        }                                               
                    }
                    update companyRecord;
                    System.debug('companyRecord-->'+companyRecord);
                    
                } catch (DMLException dmlEx) {
                    for(CompanyWrapper cw:objJson.companyList){
                        if(cw.compObj.Id == compId){
                            cw.isAccessible = 0;
                        }                                               
                    }                                
                    System.debug('Error when trying to stamp company access subimtter: ' + dmlEx);                   
                } catch (Exception other) {
                    for(CompanyWrapper cw:objJson.companyList){
                        if(cw.compObj.Id == compId){
                            cw.isAccessible = 0;
                        }                                               
                    }
                    System.debug('Error when trying to stamp company access subimtter Other: ' + other);
                }
                
            }
        }
        
        return objJson;
    }
    
    @AuraEnabled
    public static CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper importDandBCompany(String obj,String compId){
        System.debug('compId--->'+compId);        
        
        CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper objJson;
        DataCloudDandBCompany  dCloudAndb ;   
        DandBCompany migratedDandB = new DandBCompany();
        Account migratedCompany = new Account();
        objJson = (CompanySearchAndCreateCtrlNew.CompanyAndCloudDBCompWrapper)JSON.deserializeStrict(obj, CompanyAndCloudDBCompWrapper.class);                
        System.debug('dAndBCompList Size--->'+objJson.CloudDBCompList.size());
        for(Integer i=0;i < objJson.CloudDBCompList.size(); i++){//DataCloudDandBCompany dbc:dAndBCompList){
            if(objJson.CloudDBCompList[i].dcdbCompObj.Id == compId){
                dCloudAndb = objJson.CloudDBCompList[i].dcdbCompObj;
                objJson.CloudDBCompList.remove(i);
                //System.debug('dAndBCompList index--->'+i+'-'+objJson.CloudDBCompList[i]);
            }    
        }
        System.debug('dAndBCompList After Size--->'+objJson.CloudDBCompList.size());
        
        String cmpName = 'SBC-Company%';
        
        for (FieldMapping__c fm : Database.query ('Select CompName__c, SourceField__c, TargetField__c From FieldMapping__c Where CompName__c Like : cmpName')) {             
            if (fm.CompName__c == 'SBC-Company-Company') {
                migratedCompany.put(fm.TargetField__c, Reusable.getValue(dCloudAndb, fm.SourceField__c)); 
            } else if (fm.CompName__c == 'SBC-Company-DB') {
                migratedDandB.put(fm.TargetField__c, Reusable.getValue(dCloudAndb, fm.SourceField__c)); 
            }            
        }
        try {
            if(dCloudAndb != null && new List <DandBCompany>([select id from DandBCompany where DunsNumber=:dCloudAndb.DunsNumber]).size() == 0 )
                insert migratedDandB;   
            
            migratedCompany.DandBCompanyId = migratedDandB.id;
            
            insert migratedCompany;
            objJson.companyList.add(new CompanyWrapper(migratedCompany,1));
        } catch (Exception e) {
            
        }
        
        
        return objJson;
    }
    
    public class CompanyWrapper{
        @AuraEnabled
        public Integer isAccessible{get;set;}
        @AuraEnabled
        public Account compObj{get;set;}
        
        public CompanyWrapper(Account cmp,Integer flag){
            compObj = cmp;
            isAccessible = flag;
        }
    }
    
    public Class DandBCompWrapper{
        @AuraEnabled
        public DataCloudDandBCompany dcdbCompObj{get;set;}
        
        public DandBCompWrapper(DataCloudDandBCompany dbComp){
            dcdbCompObj = dbComp;
        }
    }
    
    public class CompanyAndCloudDBCompWrapper{
        @AuraEnabled
        public List<CompanyWrapper> companyList{get;set;}
        @AuraEnabled
        public Integer compOffSet{get;set;}
        @AuraEnabled
        public Integer compLimit{get;set;}
        @AuraEnabled
        public Integer totalCmp{get;set;}
        
        @AuraEnabled
        public List<DandBCompWrapper> CloudDBCompList{get;set;}
        @AuraEnabled
        public Integer dbOffSet{get;set;}
        @AuraEnabled
        public Integer dbLimit{get;set;}
        @AuraEnabled
        public Integer totalDBComp{get;set;}
        
        public CompanyAndCloudDBCompWrapper(List<CompanyWrapper> cmpList,Integer cmpOffSet,Integer cmpLimit,Integer tot){
            companyList = cmpList;
            compOffSet = cmpOffSet;
            compLimit = cmpLimit;
            totalCmp = tot;
        }
        
        public CompanyAndCloudDBCompWrapper(List<DandBCompWrapper> dbCmpList,Integer dbCmpOffSet,Integer dbCmpLimit,Integer tot){
            cloudDBCompList = dbCmpList;
            dbOffSet = dbCmpOffSet;
            dbLimit = dbCmpLimit;
            totalDBComp = tot;
        }
        
        public CompanyAndCloudDBCompWrapper(List<CompanySearchAndCreateCtrlNew.CompanyWrapper> cmpList,Integer cmpOffSet,Integer cmpLimit,Integer cTot,List<CompanySearchAndCreateCtrlNew.DandBCompWrapper> dbCmpList,Integer dbCmpOffSet,Integer dbCmpLimit,Integer dbTot){
            companyList = cmpList;
            compOffSet = cmpOffSet;
            compLimit = cmpLimit;
            totalCmp = cTot;
            
            cloudDBCompList = dbCmpList;
            dbOffSet = dbCmpOffSet;
            dbLimit = dbCmpLimit;
            totalDBComp = dbTot;
        }
    }
}