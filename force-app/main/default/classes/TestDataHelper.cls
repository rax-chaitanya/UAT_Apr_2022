public class TestDataHelper {
    
    /*********************************************************************************************************
* Methods to generate Company (Account) records for testing purposes
*********************************************************************************************************/
    
    //Instantiate and return a single Company (Account) record with the minimum required fields
    public static Account createTestCompany() {
        List<Account> companyList = createTestCompanies(1);
        return companyList[0];
    }
    
    //Instantiate and return n-many Company (Account) records with the minimum required fields
    public static List<Account> createTestCompanies(Integer numOfRecords) {
        List<Account> companyList = new List<Account>();
        Account newCompany;
        
        for(Integer i=0; i<numOfRecords; i++) {
            newCompany = new Account(Name = 'Test Account ' + i+1,BillingCountry = 'Canada', ShippingCountry = 'Canada');
            companyList.add(newCompany);
        }
        
        return companyList;
    }
    
     
    
    public static List<Lead> createTestLeads(Integer numOfRecords) {
        List<Lead> companyList = new List<Lead>();
        Lead newCompany;
        
        for(Integer i=0; i<numOfRecords; i++) {
            newCompany = new Lead(FirstName = 'Fake ' + (i+1), LastName = 'Last', Company = 'Fake Company', Country = 'United States', State = 'Texas');
            companyList.add(newCompany);
        }
        
        return companyList;
    }
    
    
    
    public static List<Contact> createTestContacts(Integer numOfRecords) {
        List<Contact> companyList = new List<Contact>();
        Contact newCompany;
        
        for(Integer i=0; i<numOfRecords; i++) {
            newCompany = new Contact(FirstName = 'First' + i+1, LastName = 'Last Name');
            companyList.add(newCompany);
        }
        
        return companyList;
    }
    
    
    
    public static Contact createTestContact() {
        List<Contact> contactList = createTestContacts(1);
        return contactList[0];
    }
    
    public static Map<Integer, Account> createSpineTree(Integer levels, String accountSource) {
        Map<Integer, Account> companyMap = new Map<Integer , Account>();
        for (Integer i = 0; i < levels; ++i) {
            Account company = new Account(Name = String.valueOf(i+1),
                                          AccountSource = accountSource
                                         );
            companyMap.put((i+1), company);
        }
        try {
            insert companyMap.values();            
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage() + e.getCause());
            return null;
        }
        
        for (Integer i = levels; i > 1; --i) {
            companyMap.get(i).ParentId = companyMap.get(i-1).Id;
        }
        update companyMap.values();
        
        return companyMap;
        
    }
    
    
    
    public static AccountInvoiceSummary[] generateAccountInvoiceSummaries(Integer amount) {
        AccountInvoiceSummary[] details = new List<AccountInvoiceSummary>();
        
        DateTime d = DateTime.now();
        d = d.addMonths(-1);
        
        for (Integer i = 0; i < amount; ++i) {
            AccountInvoiceSummary c = new AccountInvoiceSummary();
            String monthName = d.format('MMMMM').substring(0,3);
            String yearName = d.format('YY'); 
            c.invoiceMonth = monthName + '-' + yearName;
            c.invoiceLocalCurrency = 'USD';
            c.dataAsOf = '10/19/2016';
            c.invoiceAmount = 10.8;
            c.monthOverMonthDeltaAmount = -7.01;
            c.invoiceLocalAmount = 10.8;
            c.companyId = '0016100000TizBFAAZ';
            c.dunsNumber = '303171060';
            c.companyStatus = 'Active';
            c.revenueForecast = new Revenue_Forecast__c(Amount__C = 100);
 
            details.add(c);
            
            d = d.addMonths(-1);
            
        }
        return details;
    }  
    
    
    public static AccountInvoiceDetail[] generateAccountInvoiceDetails(Integer amount) {
        AccountInvoiceDetail[] details = new List<AccountInvoiceDetail>();
        
        DateTime d = DateTime.now();
        for (Integer i = 0; i < amount; ++i) {
            AccountInvoiceDetail c = new AccountInvoiceDetail();
            c.customerCreditAmount = 0.0;
            d = d.addMonths(-1);
            String monthName = d.format('MMMMM').substring(0,3);
            String yearName = d.format('YY'); 
            c.invoiceMonth = monthName + '-' + yearName;
            c.invoiceLocalCurrency = 'USD';
            c.invoiceAmount = 10.8;
            c.dataAsOf = '10/19/2016';
            c.invoiceLocalAmount = 10.8;
            c.companyId = '123456789012345';
            c.discountAmount = 1.01;
            c.dunsNumber = '303171060';
            c.companyStatus = 'Active';
            details.add(c);
        }
        return details;
    }    
    
    
    public static AccountsInvoiceSummary[] generateAccountsCInvoiceSummary(Integer amount) {
        AccountsInvoiceSummary[] details = new List<AccountsInvoiceSummary>();
        DateTime d = DateTime.now();
        d = d.addMonths(-1);
        
        
        for (Integer i = 0; i < amount; ++i) {
            AccountsInvoiceSummary a = new AccountsInvoiceSummary();
            String month = d.format('MMM');
            String year = d.format('YYYY'); 
            a.invoiceMonth =  month + '-' + year; //year + month ;
            a.bdom = 4;
            a.businessUnit = 'Dummy FAWS';      
            a.accountNumber =  'DummyAccountNumber';
            a.invoiceLocalCurrency = 'USD';
            a.invoiceAmount = 10.8;
            a.dataAsOf = '2017-03-14T00:00:00.000-05:00';
            a.monthOverMonthDeltaAmount = 11.11;
            a.accountStatus = 'Active';
            a.invoiceLocalAmount = 150;
            a.accountType = 'Cloud Customer';
            a.accountSubType = 'Cloud Customer';
            a.revenueForecast = new Revenue_Forecast__c(Amount__c = 100);
            details.add(a);
            
            d = d.addMonths(-1);
            
        }
        return details;
    }            
    
    
    public static AccountsInvoiceDetail[] generateAccountsCInvoiceDetails(Integer amount) {
        AccountsInvoiceDetail[] details = new List<AccountsInvoiceDetail>();
        DateTime d = DateTime.now();
        d = d.addMonths(-1);
        
        
        for (Integer i = 0; i < amount; ++i) {
            AccountsInvoiceDetail a = new AccountsInvoiceDetail();
            String month = d.format('MMM');
            String year = d.format('YYYY'); 
            a.invoiceMonth =  month  + '-' + year;
            a.bdom = 4;
            a.businessUnit = 'Americas';            
            a.accountNumber = '1000003';
            a.invoiceLocalCurrency = 'USD';
            a.focusArea = 'AWS';
            a.invoiceAmount = 10.8;
            a.dataAsOf = '2017-03-14T00:00:00.000-05:00';
            a.accountStatus = 'Active';
            a.invoiceLocalAmount = 150;
            a.accountType = 'Cloud Customer';
            a.accountSubType = 'Cloud Customer';
            a.discountAmount = 1.01;            
            a.customerCreditAmount = 150.23;
            details.add(a);
            d = d.addMonths(-1);
            
        }
        return details;
    }        
    
    
    public static void quickSetup() {
        insertTriggerSettings();
        insertCountryTerritoryMapping();
        insertFieldMappings();
        insertOrgConstants();
    }
    
  public static void insertTriggerSettings() {
    List<Trigger_Manager__c> triggerSettings = new List<Trigger_Manager__c>();
    triggerSettings.add(new Trigger_Manager__c(Name = 'CompanyTrigger', Is_Active__c = true));
    triggerSettings.add(new Trigger_Manager__c(Name = 'cLogTgr', Is_Active__c = true));
    triggerSettings.add(new Trigger_Manager__c(name='OpportunityTgr',Is_Active__c=true));
    insert triggerSettings;
  }
  
  public static void insertCountryTerritoryMapping() {
    List<CountryTerritoryMapping__c> mappings = new List<CountryTerritoryMapping__c>();
    mappings.add(new CountryTerritoryMapping__c(Name = 'Canada', Territory_Name__c = 'US/CANADA'));
    insert mappings;
  }
  
  public static void insertFieldMappings() {
    List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
    fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
    insert fieldMappings;
  }
  
  public static void insertOrgConstants() {
    Organization o = [SELECT Id FROM Organization LIMIT 1];
    ProcessDefinition p = [SELECT Id FROM ProcessDefinition WHERE DeveloperName = 'Company_Access_Request' AND Type = 'Approval' AND
                TableEnumOrId = 'Account' LIMIT 1];
    User u = [SELECT Id FROM User WHERE alias = 'sysadmin' AND UserType = 'Standard' AND isActive = TRUE LIMIT 1];
    List<OrgConstants__c> constants = new List<OrgConstants__c>();
    constants.add(new OrgConstants__c(Name = 'Prod Org ID', Non_Prod_Value__c = o.Id, Prod_Value__c = o.Id));
    constants.add(new OrgConstants__c(Name = 'System Administrator ID', Non_Prod_Value__c = u.Id, Prod_Value__c = u.Id));
    constants.add(new OrgConstants__c(Name = 'Company Approval Process ID', Non_Prod_Value__c = p.Id, Prod_Value__c = p.Id));
    constants.add(new OrgConstants__c(Name = '#salesforce-errors', Non_Prod_Value__c = 'https://www.google.com', Prod_Value__c = 'https://www.google.com'));
    insert constants;
  }
    
    
    
    public static Map<Integer, User> createUsers(Integer numberOfUsers) {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        String endEmail = '@test.com';
        String user = 'userijklbhim';
        
        Map<Integer, User> userMap = new Map<Integer, User>();
        
        for (Integer i = 1; i <= numberOfUsers; i++) {
            String iPlusOne = String.valueOf(i);
            
            
            User u = new User(Alias = 'Ali'+i, Email= i + user + i + endEmail, 
                              CommunityNickname ='Nick123'+i, 
                              FederationIdentifier = 'TestUser917' +i,
                              
                              EmailEncodingKey='UTF-8',FirstName = user+i, LastName='User'+i, LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName = i + user + i + endEmail);   
            userMap.put(i, u);
        }        
        insert userMap.values();
        return userMap;
        
        
    }
    
    
    private static Map<Integer, Account> associate(Map<Integer, Account> companyMap) {
        for (Integer i : companyMap.keySet()) {
            Integer left = Integer.valueOf(2 * i);
            Integer right = left + 1;
            
            if (companyMap.get(left) != null) {
                companyMap.get(left).ParentId = companyMap.get(i).Id;
            }
            if (companyMap.get(right) != null) {
                companyMap.get(right).ParentId = companyMap.get(i).Id;
            }
        }
        return companyMap;
    }
    
    public static Map<Integer, Account> createCompanyHierarchy(Integer numCompanies, String accountSource) {
        Map<Integer, Account> NumberToCompanyMap = new Map<Integer, Account>();
        for (Integer i = 0; i < numCompanies; ++i) {
            String companyName = String.valueOf(i+1);
            Account company = new Account(Name = companyName);
            if (accountSource != '' || accountSource != null) {
                company.AccountSource = accountSource;
            }
            NumberToCompanyMap.put(i+1, company);
        }
       
            insert NumberToCompanyMap.values();
            NumberToCompanyMap = associate(NumberToCompanyMap);
            update NumberToCompanyMap.values();
            
       
        return NumberToCompanyMap;        
        
    }
    
    public static Map<Integer, Account> createCompanyHierarchy(Integer numCompanies) {
        return createCompanyHierarchy(numCompanies, null);
    }
    
    
    
    
    public static void generateUSDedicatedAllCombos() {
        list<recordtype> rts = [select id, name,DeveloperName,sobjecttype from recordtype where sobjecttype in ('Opportunity', 'Account') and DeveloperName!= 'Read_Only' and Name != 'Opportunity-US'];
        
        map<string, id> typeMap = new map<string, id>();
        
        for (RecordType rt : rts) {
            typeMap.put(rt.Name, rt.Id);
        }
        
    //  Account company = new Account(id= '0014C000006OspWQAS');
        
        
        
        
        
    }
    
    public static List<SelectOption> oppOptions() {
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult =
            Opportunity.type.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    }
    
    public static Account generateCompany() {
        String theDate = (System.now()).format('EEEE, MMMM d, yyyy');
        Account c = new Account();
        c.Company_Review_Status__c = 'Reviewed';
        c.Name = 'JUST A FAKE COMPANY @ ' + theDate;
        c.Industry = 'Technology';
        c.Phone = '(210 312-4000)';
        c.BillingStreet = '1 Fanatical pl';
        c.BillingCity = 'Windcrest';
        c.BillingCountry = 'United States';
        c.BillingState = 'Texas';
        c.BillingPostalcode = '78218';
        c.Billing_County__c = 'Bexar';
        c.ShippingStreet = '1 Fanatical pl';
        c.ShippingCity = 'Windcrest';
        c.ShippingCountry = 'United States';
        c.RecordTypeId = Label.Standard_Company_RecordTypeId;
        c.ShippingState = 'Texas';
        c.ShippingPostalcode = '78218';
        
        insert c;
        return c;
    }
    
    public static List<Account> generateAccounts() {
        map<id, recordtype> accounts_map = new map<id, recordtype>([select id, name, sobjecttype from recordtype where sobjecttype = 'Account' and Name = 'Prospect']);
        List<Account> accounts = new List<Account>();
        Account c = generateCompany();
        for (Id i : accounts_map.keySet()) {
            Account acc = new Account();
            acc.Company_Name__c = c.Id;
            acc.RecordTypeId = i;
            acc.Account_Review_Status__c = 'Reviewed';
            acc.Name = accounts_map.get(i).name + ' Account';
            acc.ShippingStreet = '1 Fanatical pl';
            acc.ShippingCity = 'Windcrest';
            acc.ShippingState = 'Texas';
            acc.ShippingCountry = 'United States';
            acc.ShippingPostalCode = '78218';
            acc.BillingStreet = '1 Fanatical pl';
            acc.BillingCity = 'Windcrest';
            acc.BillingState = 'Texas';
            acc.BillingCountry = 'United States';
            acc.RecordTypeId = Label.Account_Prospect_RecordType_ID;
            acc.BillingPostalCode = '78218';
            System.debug(acc);
            accounts.add(acc);
        }
        
        insert accounts;
        return accounts;
    }
    
    public static void generateCompanyWithOppsAndAccounts() {
      
            
        List<SelectOption> options = new List<SelectOption>();
        options = oppOptions();
        
        map<id, recordtype> rt_Map = new map<id, recordtype>([select id, name, sobjecttype from recordtype where sobjecttype = 'Opportunity' and Name != 'Read Only' and Name != 'Opportunity-US']); 
        map<id, recordtype> accounts_map = new map<id, recordtype>([select id, name, sobjecttype from recordtype where sobjecttype = 'Account' and DeveloperName = 'Prospect']);
                
        String theDate = (System.now()).format('EEEE, MMMM d, yyyy');
        Account c = new Account();
        c = generateCompany();
        
        //012000000000000AAA 
        List<Account> accounts = new List<Account>();
        accounts = generateAccounts();
        
        Date d = Date.today() + 60;
        d.addYears(10);
        List<Opportunity> opps = new List<Opportunity>();
        for (ID rtId : rt_Map.keySet()) {
            
            for (Account acc : accounts) {
                
                for (SelectOption o : options) {
                    
                    Opportunity opp = new Opportunity();
                    opp.RecordTypeId = rt_Map.get(rtId).id;
                    opp.Type = o.getValue();
                    opp.AccountId = c.id;
                    opp.Account__c = acc.id;
                    opp.Name = rt_Map.get(rtId).name + ' (Type: ' + opp.Type + ')' + '(Customer Type: ' + accounts_map.get(acc.RecordTypeId).Name + ')'  ;
                    opp.StageName = 'Stage 3 - Proposal & Quote';
                    opp.CloseDate = d;
                    opp.Focus_Area__c = 'Amazon;Dedicated;Digital';
                    opp.Contract_Received__c = true;
                    
                    opps.add(opp);
                    System.debug(opp);
                    
                }
            }
        }
        
        insert opps;
       
    }      
    
}