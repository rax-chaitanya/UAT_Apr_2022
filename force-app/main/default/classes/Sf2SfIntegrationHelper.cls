/**
* Created by  : Dharmavaram Anjaneyulu
* Created Date: 19/08/2016
* Description: It helps to get the connections for the target org
* and publish the records of different objects to target organization.
*  
* */

public class Sf2SfIntegrationHelper{
   
    public static void publishRecords(List<sObject> publishingRecords){
        
        List<PartnerNetworkRecordConnection> recordsToPublish  = new List<PartnerNetworkRecordConnection>();
        Id connectionId = Label.Sf2SfConnectionName;
        
        for (sObject shareRecord : publishingRecords){
            PartnerNetworkRecordConnection newrecord = new PartnerNetworkRecordConnection();
            newrecord.ConnectionId = connectionId;
            newrecord.LocalRecordId = shareRecord.Id;
            recordsToPublish.add(newrecord);
        }
        try {
            insert recordsToPublish;
        } catch (Exception e) {
            ExceptionHandler.postToAll(e);
            if(!Test.isRunningTest())
            throw new CustomException(ExceptionHandler.getBody(e)); 
        }
        
        
        
    }
    
    public static void publishChildRecordsWithParent(List<sObject> publishingRecords,String objectName){
        
        String parentField = Connection_Object_Formula_Fields__c.getValues(objectName+'_Parent').Field_API_Name__c;
        List<PartnerNetworkRecordConnection> recordsToPublish  = new List<PartnerNetworkRecordConnection>();
        Id connectionId = Label.Sf2SfConnectionName;
        
        for (sObject shareRecord : publishingRecords){
            PartnerNetworkRecordConnection newrecord = new PartnerNetworkRecordConnection();
            newrecord.ConnectionId = connectionId;
            newrecord.LocalRecordId = shareRecord.Id;
            newrecord.ParentRecordId = (Id)shareRecord.get(parentField); 
            recordsToPublish.add(newrecord);
        }
        
        if(!Test.isRunningTest()){
            try {
                insert recordsToPublish;
            } catch (Exception e) {
                ExceptionHandler.postToAll(e);
                throw new CustomException(ExceptionHandler.getBody(e)); 
            }
        }
        
    }
    public static void publishAttachmentRecords(List<Attachment> publishingRecords,String objectName){
        
        // String parentField = Connection_Object_Formula_Fields__c.getValues(objectName+'_Parent').Field_API_Name__c;
        List<PartnerNetworkRecordConnection> recordsToPublish  = new List<PartnerNetworkRecordConnection>();
        Id connectionId = Label.Sf2SfConnectionName;
        
        
        for (Attachment shareRecord : publishingRecords){
            if(shareRecord.ParentId.getSobjectType() == Lead.SobjectType){ 
                PartnerNetworkRecordConnection newrecord = new PartnerNetworkRecordConnection();
                newrecord.ConnectionId = connectionId;
                newrecord.LocalRecordId = shareRecord.Id;
                newrecord.ParentRecordId = shareRecord.ParentId;  
               // recordsToPublish.add(newrecord); sfdc 242
            }
        }
        if(!Test.isRunningTest()){
            try {
                insert recordsToPublish;
            } catch (Exception e) {
                ExceptionHandler.postToAll(e);
                throw new CustomException(ExceptionHandler.getBody(e));     //or a more fitting exception message… 
            }
            
        }
        
    }
    public static void updateRecordsToGetIds(Set<Id> ids,String type) {
        
        List<sObject> recordsToUpdate = new List<sObject>();
        for(Id i : ids){
            sObject ob = Schema.getGlobalDescribe().get(type).newSObject();
            ob.put('id', i);
            recordsToUpdate.add(ob); 
        }
        try {
            update recordsToUpdate;
        } catch (Exception e) {
            ExceptionHandler.postToAll(e);
            throw new CustomException(ExceptionHandler.getBody(e));     //or a more fitting exception message… 
        }
        
        
    }
    
    public static void populateLookupFields(List<sObject> objects,String objectName){
        
        Map<String,Integer> lookUpFieldsVsOrder = new Map<String,Integer>();
        Map<String,String> filedsVsOldIds = new Map<String,String>();
        Map<String,String> fieldsVsSoql = new Map<String,String>();
        Map<String,String> fieldVsId = new Map<String,String>();
        Map<String,String> fieldVsfieldkey = new Map<String,String>();
        String formulaField = Connection_Object_Formula_Fields__c.getValues(objectName).Field_API_Name__c;
        for(Populate_Lookup_Fields__c plf : 
            [select Field_API_Name__c,Order__c,Object_API_Name__c,Old_Record_Id_Field_Name__c,SOQL__c,Target_Object_Api_Name__c from Populate_Lookup_Fields__c where Object_API_Name__c =: objectName]){
                lookUpFieldsVsOrder.put(plf.Field_API_Name__c,plf.Order__c.intValue());
                fieldsVsSoql.put(plf.Field_API_Name__c, plf.SOQL__c); 
                filedsVsOldIds.put(plf.Field_API_Name__c, '');
                fieldVsfieldkey.put(plf.Field_API_Name__c, plf.Old_Record_Id_Field_Name__c);
            }
        for(sObject obj : objects){
            //  System.debug('formula field '+formulaField);
            String lookupIds = (String)obj.get(formulaField);
            if(lookupIds == null)
                lookupIds='';   
            String[] oldids = lookupIds.split(',');
            
            for(String field : fieldsVsSoql.keySet()){
                String exist = filedsVsOldIds.get(field);
                if(!oldids.isEmpty() && oldids.size()>lookUpFieldsVsOrder.get(field) &&  oldids[lookUpFieldsVsOrder.get(field)].trim() != ''){
                    if(exist =='') exist='\''+oldids[lookUpFieldsVsOrder.get(field)].trim()+'\'';
                    else  exist = exist+',\''+oldids[lookUpFieldsVsOrder.get(field)].trim()+'\'';
                    filedsVsOldIds.put(field, exist);
                    fieldVsId.put(field+'_'+obj.id, oldids[lookUpFieldsVsOrder.get(field)]) ; 
                }
            }
        }
        
        Map<String,Map<String,String>> fieldsVsRecordIds = new Map<String,Map<String,String>>();
        
        for(String field : fieldsVsSoql.keySet()){
            
            if(filedsVsOldIds.get(field) != '' && !String.isEmpty(filedsVsOldIds.get(field))){
                Map<String,String> oldIdVsnewId = new Map<String,String>();
                
                for(sObject ob : Database.query(fieldsVsSoql.get(field)+' ('+filedsVsOldIds.get(field)+' )'))
                    oldIdVsnewId.put((String)ob.get(fieldVsfieldkey.get(field).trim()), ob.id);
                fieldsVsRecordIds.put(field, oldIdVsnewId);
            }
        }
        
        for(sObject obj : objects){
            for(String field : fieldsVsSoql.keySet()){
                Map<String,String> oldVsNew = fieldsVsRecordIds.get(field);
                if(oldVsNew != null){
                    if(field =='Ownerid' && fieldVsId.get(field+'_'+obj.id) != null && oldVsNew.get(fieldVsId.get(field+'_'+obj.id).trim()) != null)
                        obj.put(field, oldVsNew.get(fieldVsId.get(field+'_'+obj.id).trim()));
                    if(field !='Ownerid' && fieldVsId.get(field+'_'+obj.id) != null)
                        obj.put(field, oldVsNew.get(fieldVsId.get(field+'_'+obj.id).trim()));   
                }                  
                
                
            }
        }
    }
    
    public static boolean isPartnerShared(){
        
        //return true;
        return (UserInfo.getUserType() == 'PartnerNetwork' && UserInfo.getName() == 'Connection User');
    }
    
}