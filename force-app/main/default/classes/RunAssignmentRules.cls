public class RunAssignmentRules {

    public static boolean RUN_ASSIGNMENT_RULES = true;
   
    @InvocableMethod
    public static void runAssignmentRules(List<Id> ids){
              
        Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule= true;  
        List<Case> records = new List<Case>();
        for(Id i : ids){
            Case ob = new Case(Id=i);
            ob.setOptions(dmo);
            records.add(ob);
        }
        
            update records;
    }
    
   
    public static void runLeadAssignmentRules(Set<Id> ids){
      
        Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule= true;  
        List<sObject> records = new List<sObject>();
        for(Id i : ids){
            sObject ob = Schema.getGlobalDescribe().get('Lead').newSObject();
            ob.put('id', i);
            ob.setOptions(dmo);
            records.add(ob);
        }
         
            update records;
    }
    
    public static void runLeadTerritoryAssignmentRules(List<Lead> leads){
      
      /*  Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule= true;  
              for(Lead l : leads){
            
            l.setOptions(dmo);
          
        }*/
         
            update leads;
    }
}