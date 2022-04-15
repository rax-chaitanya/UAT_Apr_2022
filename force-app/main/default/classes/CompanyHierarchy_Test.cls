@isTest(seeAllData = false)
public class CompanyHierarchy_Test {
    private static final Integer LEVELS = 10;
    private static final Integer SPINES = 3;
    private static final Integer MAX_LEVELS_DOWN = 6;
        
    
    @testSetup static void testSetup() {
       TestClassUtility.setTestSetupData();
        
    }
    
    @isTest static void test_getCompanyMap() {
         for (Integer i = 0; i < SPINES; ++i) {
            TestDataHelper.createSpineTree(LEVELS, 'Spine #' + String.valueOf(i+1));
        }
        Account a1 =  new Account(Name='Test Account123411',DunsNumber='006220594',BillingCountry='India',ShippingCountry='India',CleanStatus = 'Matched');
        insert a1;
        Set<ID> roots = new Map<Id, Account>([Select Id from Account where ParentID = null]).keySet();
        
         Map<ID, account> companyMap = new Map<Id,Account>([
            SELECT Id, Name, accountsource,
            ParentID,									
            Parent.ParentID,							
            Parent.Parent.ParentID,						
            Parent.Parent.Parent.ParentID,				
            Parent.Parent.Parent.Parent.ParentID,		
            Parent.Parent.Parent.Parent.Parent.ParentId	
            FROM   Account
            WHERE 
            ParentId IN :roots OR									
            Parent.ParentId IN :roots OR								
            Parent.Parent.ParentId IN :roots OR						
            Parent.Parent.Parent.ParentId IN :roots OR				
            Parent.Parent.Parent.Parent.ParentId IN :roots OR		
            Parent.Parent.Parent.Parent.Parent.ParentId IN :roots]);
        
        System.assertEquals(companyMap.keySet() , CompanyHierarchy.getCompanyMap(roots).keyset());
        System.debug('Size : '+companyMap.keySet().size());
        CompanyHierarchy.getCompanyHierarchy(companyMap.keySet());
        
        
        
    }

    

    
    
    
}