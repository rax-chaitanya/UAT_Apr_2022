@isTest(SeeAllData = true)
public class SearchBeforeCreateCompany_Test {
    
    private static testmethod void testSearch() {        
        Test.startTest();        
        Account company = new Account();
        ApexPages.StandardController controller = new ApexPages.StandardController(company);
        SearchBeforeCreateCompany sbc = new SearchBeforeCreateCompany(controller);        
        sbc.tableState.put(sbc.companyString, new TableState());
        sbc.tableState.put(sbc.dandBString, new TableState());        
        sbc.resetSearchParameters();        
        sbc.company.name = 'a';
        sbc.company.Tradestyle = 'a';        
        sbc.getDynamicPage();        
        sbc.executeSearch();
        //sbc.searchForCompanies();         //can't execute search for d and b companies        
        System.debug('sbc companies map size: ' + sbc.companiesMap.size());        
        sbc.queryId = sbc.companiesMap.values().get(0).id;
        sbc.requestCompanyRecordAccess();
        sbc.initNewSObject();
        Test.stopTest();
    }
}