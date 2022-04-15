public class ProductAccountController {
    @AuraEnabled
    public static Map<String,List<String>> getAccRecordTypeList(){
        
        Map<String,List<String>> recordTypeMap = new Map<String,List<String>>();
        Map<String,List<String>> recordTypeMap2 = new Map<String,List<String>>();
        List<RecordType> listRec = new List<RecordType>();
        System.debug('Outside ProductAccountCreationRestricted_Profiles');
        if(!System.Label.ProductAccountCreationRestricted_Profiles.contains(UserInfo.getProfileId())){
            System.debug('Insideside ProductAccountCreationRestricted_Profiles');
            Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
            List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
            
            for(RecordType rec : [SELECT Id, Name, Description FROM RecordType WHERE SobjectType = 'Account']) {
                if(rec != null){
                    listRec.add(rec);   
                }            
            }
            
            if(!listRec.isEmpty()){
                for( Schema.RecordTypeInfo recordType : RT )
                {
                    List<String> nameAndDesc = new List<String>(); 
                    if(recordType.isAvailable())
                    {
                        String rtId = recordType.getRecordTypeId();
                        if(System.Label.AccountRecordTypes.contains(rtId)) {
                            for(RecordType rList: listRec){
                                if(rList.Id==recordType.getRecordTypeId()){
                                    nameAndDesc.add(rList.Name);
                                    nameAndDesc.add(rList.Description);
                                    break;                                
                                }
                            }
                            if(System.Label.Account_Prospect_RecordType_ID == String.valueof(recordType.getRecordTypeId())){
                                recordTypeMap.put(recordType.getRecordTypeId(),nameAndDesc);
                            }else{
                                recordTypeMap2.put(recordType.getRecordTypeId(),nameAndDesc);
                            }
                            
                
                            /*System.debug('isDefault:::'+recordType.isDefaultRecordTypeMapping());
                            if(recordType.isDefaultRecordTypeMapping()){                                           
                                recordTypeMap.put('isDefault',nameAndDesc);                                  
                            }*/    
                            
                                                     
                        }    
                    }
                }
                if(!recordTypeMap2.isEmpty())
                    recordTypeMap.putAll(recordTypeMap2);    
            }
        }    
        return recordTypeMap;
    }
}