public class ErrorLogHelper {

    public static void logErrorRecord(String errorMessage,string actionType){
        try{
            ErrorLog__c errordetails=new Errorlog__c();
            errordetails.Message__c = errorMessage;
            errordetails.Action_Type__c = actionType;
            Database.insert(errordetails,false);
        } catch(Exception e){
             System.debug('Error :'+e.getMessage());
        }
    }
    
    public static void logErrorRecords(List<Database.Saveresult> updateResult,List<SObject> listToUpdate,string actionType){
        try{
            List<ErrorLog__c> errorslist=new  List<ErrorLog__c>();
            
            for(Integer i=0;i<updateResult.size();i++){
                if (!updateResult.get(i).isSuccess()){            
                    Database.Error error = updateResult.get(i).getErrors().get(0);
                    system.debug('Failed ID: '+listToUpdate.get(i).Id + 'Error msg: '+ error.getMessage());
                    ErrorLog__c errordetails = new Errorlog__c();
                    errordetails.RecordID__c = (String)listToUpdate.get(i).Id;
                    errordetails.Message__c = error.getMessage();
                    errordetails.Action_Type__c = actionType;
                    errorslist.add(errordetails);
                }                
            }
            
            if(errorslist.size()> 0){
                Database.insert(errorslist,false);
            }            
        } catch(Exception e){
            System.debug('Error :'+e.getMessage());
        }
        
    }
    public static void ClogErrorRecord(String errorMessage,string actionType){
        try{
            CLog__c errordetails=new Clog__c();
            errordetails.Error_Description__c = errorMessage;
            errordetails.Action_Name__c = actionType;
            Database.insert(errordetails,false);
        } catch(Exception e){
             System.debug('Error :'+e.getMessage());
        }
    }
}