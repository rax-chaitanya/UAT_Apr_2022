public class DDIValidationController {
    @AuraEnabled
    public static String accountDdi(string ddiNumber) {
        system.debug('ddiNumber>>>> '+ddiNumber);
          List<Account> accRec = new List<Account>();
          accRec  = [Select id, DDI__c from Account where DDI__c=:ddiNumber limit 1];
          
          if(accRec.size()>0){
              return 'Account Found';
          }else{
              return 'Account not Found';
          }
            
     
        

    }
}