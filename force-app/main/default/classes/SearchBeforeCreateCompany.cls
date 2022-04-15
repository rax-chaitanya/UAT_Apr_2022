public without sharing class SearchBeforeCreateCompany extends Framework {
    
    
    public class CustomException extends Exception {
        
    }
    public String companyString {get; set;}
    public String dAndBString {get; set;}
    
    public Account company {get; set;}                                      // 
    
    public String companyName, companyState, companyCountry, companyWebsite;    //
    
    public Map<Id, Account> companiesMap {get; set;}                        // collection to hold companies
    public Map<Id, DataCloudDandBCompany> dandBsMap {get; set;}             // collection to hold dandBs
    
    public String locationType {get; set;}                                  // 0, 1, or 0 and 1..., the Location Status fields filtered on a DataCloudDandBCompany
    public List<SelectOption> locationTypeOptions {get; set;}               // options that enable a user to filter by LocationStatus on a DataCloudDandBCompany
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // @developer   :    Diego Castro
    // @date        :    09/19/2017
    // @story       :    SFDC-638
    // @description :    Company Search before Create - Multiple Countries
    //////////////////////////////////////////////////////////////////////////////////////////////////
    public List<SelectOption> territoryOptions {get; set;}
    public String[] companyTerritories {get; set;}
    
    ///////////////////////////////////////end SFDC-638///////////////////////////////////////////////    
    
    public Boolean isSearched {get; set;}                                   // boolean value that displays results tables when a user hits search
    
    public Map<String, TableState> tableState {get; set;}                   // maintains state of the tables' current offsets and maximum offsets
    
    
    public String queryID {get; set;}                                       // value that is used for all action functions, typically an id of some sort
    public String page {get; set;}                                          // 
    
    
    
    public map<String, Access> companyAccessMap {get; set;}
    
    public map<string, string> DunsToDandBMap {get; set;}
    
    
    public class Access {
        public Integer state {get; set;}
        public String requestor {get; set;}
        
        public Access(Integer some_state) {
            state = some_state;
        }
        public Access(Integer some_state, String some_requestor) {
            state = some_state;
            requestor = some_requestor;
        }
        
    }
    
    public List<Account> getCompanies() {
        return companiesMap.values();
    }
    
    
    public List<DataCloudDandBCompany> getDandBCompanies() {
        return dandBsMap.values();
    }
    
    public void setLocationTypeOptions() {
        LocationTypeOptions = new List<SelectOption>();
        locationTypeOptions.add(new SelectOption('1', 'Headquarters Only'));
        locationTypeOptions.add(new SelectOption('0', 'Single Locations Only'));
        locationTypeOptions.add(new SelectOption('0,1', 'HQ + Single Locations')); 
        locationType = locationTypeOptions[2].getValue();
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // @developer   :    Diego Castro
    // @date        :    09/19/2017
    // @story       :    SFDC-638
    // @description :    Company Search before Create - Multiple Countries
    //////////////////////////////////////////////////////////////////////////////////////////////////
    public void setTerritoryOptions() {
        territoryOptions = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult = Account.Territory__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple) {
            territoryOptions.add(new SelectOption(f.getLabel(), f.getValue()));
        }               
    }
    ///////////////////////////////////////end SFDC-638///////////////////////////////////////////////    
    
    
    public SearchBeforeCreateCompany(ApexPages.StandardController controller) {
        super('CompanySearchBeforeCreate');
        try {
            companyString = VF_Query_Manager__c.getInstance('ComSBC-1').Query_Id__c;
            dAndBString   = VF_Query_Manager__c.getInstance('ComSBC-3').Query_Id__c;        
        } catch (Exception e) {
            ExceptionHandler.postToAll(e);
            throw new CustomException('The instance for this Query Manager is not populated with an ID.');
        } 

        
        
        company = new Account();
        companyTerritories = new list<String>();					//SFDC-638
        DunsToDandBMap = new map<String, string>();
        companyAccessMap = new Map<String, Access>();
        dAndBsMap = new Map<Id, DataCloudDandBCompany>();
        
        setLocationTypeOptions();     
        setTerritoryOptions();
        
        
        tableState = new Map<String, TableState>();
    }
   
    
    public void executeSearch() {
        
        companyName =  company.Name + '%';
        company.TradeStyle = companyName;
        
        //////////////////////////////////////////////////////////////////////////////////////////////////
        // @developer   :    Diego Castro
        // @date        :    09/19/2017
        // @story       :    SFDC-638
        // @description :    Company Search before Create - Multiple Countries
        //////////////////////////////////////////////////////////////////////////////////////////////////
        company.Territory__c = (companyTerritories.size() > 0) ? String.join(companyTerritories, ';') : '';	//populate territory w value so it gets picked up in query
        ///////////////////////////////////////end SFDC-638///////////////////////////////////////////////    
        companyState = String.valueOf(company.get('BillingStateCode'));
        companyWebsite = (String.isNotBlank(company.website)) ?  company.Website + '%' : company.website;
        companyCountry = String.valueOf(company.get('BillingCountryCode'));
        
        tableState.put(companyString, new TableState());
        tableState.put(dandBString, new TableState());
        
        
        searchForCompanies();
        if(!Test.isRunningTest())
        searchForDandBCompanies();
        
        isSearched = true;

    }
    
    public void searchForCompanies() {
        queryBuilder.setSObject(company);
        
        Integer off = tableState.get(companyString).currOffset;
        TableState ts = tableState.get(companyString);
        
        
        System.debug('companyName: ' + companyName);
        
        //368
        String[] fields = new list<string>{'BillingCountryCode', 'Website', 'BillingStateCode', 'Territory__c'};
            String[] satisfiedFields = new list<string>();
        
        for (String f : fields) {
            if (String.isNotBlank( String.valueOf(company.get(f) )  ) ) {
                satisfiedFields.add(f);
            }
        }        
        
        String satisfiedFieldsJoined = String.join(satisfiedFields, '-');
        System.debug('satisfiedFieldsJoined: ' + satisfiedFieldsJoined);
        
        String sourceFormat = '';
        if (String.isNotBlank(satisfiedFieldsJoined)) {
            
            sourceFormat = [Select SourceField__c from FieldMapping__c where CompName__c = :satisfiedFieldsJoined].SourceField__c;
            String[] lst = sourceFormat.split(',');
            System.debug(lst);
            System.debug(lst.size());
            
            for (Integer i = 0; i < lst.size(); ++i) {
                System.debug('lst[' + i + '] =' + lst[i] + 'next');
            }
            
            
        }
        
        
        
        
        String toQueryValues = queryBuilder.getQueryString(companyString);
        toQueryValues = String.format( toQueryValues, sourceFormat.split(','));
        
        System.debug('going to use: ' + toQueryValues);
        //368

        String toQueryCount = queryBuilder.getQueryString(  VF_Query_Manager__c.getInstance('ComSBC-2').Query_ID__c    );
        toQueryCount = String.format(toQueryCount, sourceFormat.split(','));
        
        System.debug('going to use for count: ' + toQueryCount);
        companiesMap = new map<ID, Account>( (List<Account>) Database.query( toQueryValues ) );

        ts.totalCount = Database.countQuery(toQueryCount);    //totalCount of contacts
        ts.queryLimit = Integer.valueOf(queryBuilder.querylookup.get(companyString).Query_Limit__c);
        
        
        if (companiesMap.size() == 0) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO,'No companies were found.');  
            ApexPages.addMessage( msg );
        }
        
        setCompanyAccessStateMap();

        
    }
    
    public void setCompanyAccessStateMap() {
        queryBuilder.setsObject(null);
        Id userID = UserInfo.getUserId();
        Set<Id> companyIDs = companiesMap.keySet();
        
        for (UserRecordAccess ua : Database.query( queryBuilder.getQueryString( VF_Query_Manager__c.getInstance('ComSBC-4').Query_ID__c ) ))
        {
            if (!companyAccessMap.containsKey(ua.RecordId)) {
                //Integer state = (ua.HasReadAccess) ? 1 : 0;             	// 1 denotes true, 0 denotes false
                Integer state = (ua.HasEditAccess) ? 1 : 0;             	// SFDC-368
                companyAccessMap.put(ua.RecordId, new Access(state));
            }

        }
    }
    

    public void requestCompanyRecordAccess() {
        ApexPages.Message msg; 
        
        System.debug('Record ID: ' + queryID);
        if (String.isBlank(queryId)) {
            msg = new ApexPages.Message(ApexPages.Severity.ERROR,('Could not identify company record. Please refresh this page and try again.'));  
        } else {
            try {
                ProcessInstance pi = Database.query ( queryBuilder.getQueryString(  VF_Query_Manager__c.getInstance('ComSBC-5').Query_ID__c  ));
                String uName  = pi.CreatedBy.Name;
                
                msg = new ApexPages.Message(ApexPages.Severity.ERROR,('User ' + uName + ' has already placed this company in an approval process. Please wait until it has been approved or rejected.'));  
                CompanyAccessMap.put(queryId, new Access(3, uName));            
            } catch (QueryException qe) {
                //there is no pending approval process for this company 
                
                try {
                    //stamping this field with a user will kick off the approval process
                    companiesMap.get(queryId).company_Access_Submitter__c = UserInfo.getUserId();
                    update companiesMap.get(queryID);
                    msg = new ApexPages.Message(ApexPages.Severity.CONFIRM,('You have successfully requested access to ' + companiesMap.get(queryId).Name));  
                    CompanyAccessMap.put(queryId, new Access(2));            
                                
                    
                } catch (DMLException dmlEx) {
                    ExceptionHandler.postToAll(dmlEx);
                    System.debug('Error when trying to stamp company access subimtter: ' + dmlEx);
                    msg = new ApexPages.Message(ApexPages.Severity.ERROR,('There was an issue in kicking off the approval process for this company. Please refresh the page and try again.'));  
                } catch (Exception other) {
                    ExceptionHandler.postToAll(other);
                    msg = new ApexPages.Message(ApexPages.Severity.ERROR,('There was an issue in kicking off the approval process for this company. Please refresh the page and try again.'));  
                    
                    
                }
                
            }
        }        
        
       
        ApexPages.addMessage( msg );
    }    
    
    public Set<String> getConvertedCompanyDUNS() {
        List<Account> companies = new list<Account>();
        Set<String> dunsSet = new Set<String>();
        Set<String> dunsToDandBKeySet = DunsToDandBMap.keySet();            // var used in dynamic query below
        
        companies = Database.query( queryBuilder.getQueryString( VF_Query_Manager__c.getInstance('ComSBC-6').Query_ID__c ) );
        for (Account c : companies) {
            if (String.IsNotBlank(c.DunsNumber)) {
                dunsSet.add(c.DunsNumber);
            }
        }
        return dunsSet;
    }
    
    public void searchForDandBCompanies() {
        queryBuilder.setSObject(null);
            
        TableState ts = tableState.get(dAndBString);
        
        //concern for when we can't use an sObject to plug into model to identify populated values via query filters...ie tradestyle for datacloud dandbcompany
        List<String> locations = locationType.split(',');
        System.debug('locations : ' + locations);
        Integer off = tableState.get(dAndBString).currOffset;
        
        //System.debug('tmp variable: ' + ts.QueryLimit);

        dAndBsMap = new Map<Id, DataCloudDandBCompany>();
        String tmpCompanyName = companyName;
        
        companyname = company.Name;
        System.debug(queryBuilder.getQueryString (dAndBString));
        
        for (DataCloudDandBCompany db :  Database.query( queryBuilder.getQueryString (dAndBString))   ) {
            
            if (String.isNotBlank(db.DunsNumber)) {
                DunsToDandBMap.put(db.DunsNumber, db.id);
            }
            
            dAndBsMap.put(db.id, db);
        }
        

        
        //grab already imported companies from DandB and iterate over each of them
        for (String convertedCompanyDuns : getConvertedCompanyDUNS()) {
            
            System.debug('converted Company Duns: ' + convertedCompanyDuns);
            
            //if the set of returned DandB duns numbers contains one of the already converted company duns numbers
            if (DunsToDandBMap.containsKey(convertedCompanyDuns)) {
                //remove the dbID from the dAndBsMap 
                dAndBsMap.remove( DunsToDandBMap.get(convertedCompanyDuns) );
            }
        }

        
        ts.queryLimit = Integer.valueOf(queryBuilder.querylookup.get(dAndBString).Query_Limit__c);
        Integer tmp = ts.queryLimit;
        
        ts.totalCount = 2000;
        companyName = tmpCompanyName;
    }
    
    
    public void importDandBCompany() {
        DataCloudDandBCompany  dCloudAndb = dAndBsMap.get(queryId);
        
        DandBCompany migratedDandB = new DandBCompany();
        Account migratedCompany = new Account();
        
        for (FieldMapping__c fm : Database.query ( queryBuilder.getQueryString(  VF_Query_Manager__c.getInstance('ComSBC-7').Query_ID__c   ))) {             
            if (fm.CompName__c == 'SBC-Company-Company') {
                migratedCompany.put(fm.TargetField__c, Reusable.getValue(dCloudAndb, fm.SourceField__c)); 
            } else if (fm.CompName__c == 'SBC-Company-DB') {
                migratedDandB.put(fm.TargetField__c, Reusable.getValue(dCloudAndb, fm.SourceField__c)); 
            }
            
        }

        
        try {
            insert migratedDandB;
            migratedCompany.DandBCompanyId = migratedDandB.id;
            
            insert migratedCompany;
            companyAccessMap.put(migratedCompany.Id, new Access(1));
            companiesMap.put(migratedCompany.Id, migratedCompany);
            dandBsMap.remove(queryId);
            
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.CONFIRM,('D and B Company successfully migrated.'));  
            ApexPages.addMessage(msg);
            
        } catch (Exception e) {
            ExceptionHandler.postToAll(e);
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,('Error: ' + e));  
            ApexPages.addMessage(msg);
            
        }
        
    }
    
    
    
 
    public void genericFunction() {
        System.debug('queryId is ' + queryId);
        System.debug('page is: ' + page);
        
        
        TableState ts = tableState.get(queryId);

        if (page == 'first') ts.first();
        if (page == 'prev') ts.prev();
        if (page == 'next') ts.next();
        if (page == 'last') ts.last();
        
        if (queryId == companyString) {
            searchForCompanies();
        } else if (queryId == dAndBString) {
            searchForDandBCompanies();
        }
        
        
    }    
    
    public PageReference initNewSObject() {
        try {
            
            String ret =  URL.getSalesforceBaseUrl().toExternalForm()+ '/001/e?nooverride=1&'  ;
            
            list<string> strs = new list<string>();  
            
            for (FieldMapping__c fm : [Select Id, SourceField__c, TargetField__c, CompName__c  from FieldMapping__c where CompName__c =  'SBC-Company-Create-Company']) {
                if ( String.isNotBlank( (String) company.get(fm.SourceField__c) ) ) {
                    strs.add(fm.TargetField__c + (String) company.get( (string) fm.SourceField__c) );
                }
            }        
            
            if (strs.size() == 0) {
                CustomException ce = new CustomException('There are no FieldMapping records that match the criteria specified. SourceField should contain field API name, and TargetField should contain the select ID from HTML.');
                ExceptionHandler.postToAll(ce, false);
                
                
            }
            
            ret += String.join(strs,'&');
            return new PageReference(ret );
        } catch (exception e) {
            ExceptionHandler.postToAll(e, false);
            return null;
        }
        
    }
    
    public void resetSearchParameters() {
        company = new Account();
        companyTerritories = new list<String>();
        isSearched = false;
        
    }

}