public class CreateAccountContactRole {
 @AuraEnabled  
    public static Contact getDetailsFromContact(string recordId){
       return [select Id,Email from Contact Where Id = :recordId limit 1];
     
    }
}