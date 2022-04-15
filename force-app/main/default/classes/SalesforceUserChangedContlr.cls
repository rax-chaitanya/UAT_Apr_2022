public class SalesforceUserChangedContlr {
@AuraEnabled
    public static string revertContact(string contactId, String salesforceUserId){
        string returnedSuccessfull;
        contact con = new contact();
        con.Id = contactId;
        con.pse__Salesforce_User__c = salesforceUserId;
         Database.SaveResult updateResult = Database.update(con, false); 
        if(updateResult.isSuccess()){
            returnedSuccessfull = 'success';
        }else{
            DataBase.Error error = updateResult.errors.get(0);
            returnedSuccessfull = error.getMessage();
        }
        system.debug('returnedSuccessfull'+returnedSuccessfull);
        return returnedSuccessfull;
    }
}