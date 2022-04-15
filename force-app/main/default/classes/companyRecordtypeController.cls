//Class created to give selection of record type

public class companyRecordtypeController {
    public static Map<Id, String> recordtypemap {get;set;}
    
    @AuraEnabled        
    public static List<String> fetchRecordTypeValues(){
        List<Schema.RecordTypeInfo> recordtypes = Opportunity.SObjectType.getDescribe().getRecordTypeInfos();    
        recordtypemap = new Map<Id, String>();
        for(RecordTypeInfo rt : recordtypes){
            if(rt.getName() != 'Master'&& rt.isAvailable())
                recordtypemap.put(rt.getRecordTypeId(), rt.getName());
        }        
        return recordtypemap.values();
    }
    
    @AuraEnabled
    public static Id getRecTypeId(String recordTypeLabel){
        Id recid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();        
        return recid;
    }  
    list<account> acclist = new list<account>();
    
    
    @AuraEnabled  
    public static Account getDetailsFromAcc(string recordId){
        string recordType;
        account acc;
        recordType = [select Id,Name,RecordTypeId
                      from Account Where id = :recordId limit 1].RecordTypeId;
        system.debug('recordType........'+recordType);
        try{
     //   if(Schema.sObjectType.account.fields.name.isCreateable() && Schema.sObjectType.account.fields.name.isUpdateable()){
            if(System.Label.CompanyRecordTypes.contains(recordType)){
                acc = [select Id,Name,Company_Name__c,RecordTypeId
                       from Account Where Company_Name__c = :recordId limit 1];
                system.debug('Company if........'+acc);
                
            } else {
                acc = [select Id,Name,Company_Name__c,createddate,RecordTypeId
                       from Account Where id = :recordId];      
                system.debug('Product account else........'+acc);
            }
          //  }
            
        }
        catch(exception ex){
            system.debug('exception........'+ex);
        }
    return acc;

    }  
}