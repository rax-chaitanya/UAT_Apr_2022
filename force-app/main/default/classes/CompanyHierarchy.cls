public class CompanyHierarchy {
    
    //1 3 7 15 31 63 127 255 
    
    
    public static Map<ID, Account> getCompanyHierarchy(Set<Id> parent_ids) {
        Map<ID, Account> ret = new map<id, account>();
        Set<ID> root_ids = new Set<ID>();
        root_ids = parent_ids;
        
        Integer count = 1;
        while (root_ids.size() > 0) {
            System.debug('iteration: ' + count);
            set<id> temp = new set<id>();
            for (Account a : CompanyHierarchy.getCompanyMap(root_ids).values()) {
                ret.put(a.id, a);
                if(a.Parent.Parent.Parent.Parent.Parent.ParentId != null) {
                    temp.add(a.Id);
                }
            }
            list<account> comps = [select id, name from account where id in :temp];
            for (account a : comps) {
                system.debug(a.name + ' set at iteration ' + count);
            }
            root_ids = temp;
            count++;
        }
        return ret;
    }    
    
    
    
    
    public static Map<Id, Account> getCompanyMap(Set<Id> parent_company_ids) {
        Map<ID, account> companyMap = new Map<Id,Account>([
            SELECT Id, Name, accountsource,
            ParentID,									
            Parent.ParentID, parent.name, 							
            Parent.Parent.ParentID,						
            Parent.Parent.Parent.ParentID,				
            Parent.Parent.Parent.Parent.ParentID,		
            Parent.Parent.Parent.Parent.Parent.ParentId	
            FROM   Account
            WHERE 
            ParentId IN :parent_company_ids OR									
            Parent.ParentId IN :parent_company_ids OR								
            Parent.Parent.ParentId IN :parent_company_ids OR						
            Parent.Parent.Parent.ParentId IN :parent_company_ids OR				
            Parent.Parent.Parent.Parent.ParentId IN :parent_company_ids OR		
            Parent.Parent.Parent.Parent.Parent.ParentId IN :parent_company_ids
        ]);
        return companyMap;
    }
    
    
    
    
    
    
    
    
    
    
    
}