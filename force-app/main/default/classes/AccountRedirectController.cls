public class AccountRedirectController {
   @AuraEnabled
    public static String getAccountId(String accNumber){
        
        try{
            //changed reference from custom account to standard account
            return [Select Id from Account where Account_Number__c =: accNumber].Id;
          
        }catch(Exception e){
             return null;
        }
       
    }
}