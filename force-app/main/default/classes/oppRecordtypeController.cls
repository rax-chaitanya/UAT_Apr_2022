//Class created to give selection of record type

public class oppRecordtypeController {
    public static Map<Id, String> recordtypemap {get;set;}
    
   @AuraEnabled        
    public static List<String> fetchRecordTypeValues(){
        List<Schema.RecordTypeInfo> recordtypes = Opportunity.SObjectType.getDescribe().getRecordTypeInfos();    
        recordtypemap = new Map<Id, String>();
        for(RecordTypeInfo rt : recordtypes){
         if(rt.isAvailable()){
            if(rt.getName() != 'Master')
            recordtypemap.put(rt.getRecordTypeId(), rt.getName());
            }
        }        
        return recordtypemap.values();
    }
    
    @AuraEnabled
    public static Id getRecTypeId(String recordTypeLabel){
        Id recid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();        
        return recid;
    } 
    /*@AuraEnabled  
    public static Accounts__c getDetailsFromAcc(string recordId){
       Accounts__c acc = [select Id,Name,Company_Name__c
        from Accounts__c Where Id = :recordId limit 1];
       return acc;
    }    */
        @AuraEnabled  
    public static Account getDetailsFromAcc(string recordId){
       Account acc = [select Id,Name,Company_Name__c
        from Account Where Id = :recordId limit 1];
       return acc;
    }  
}