/**********************************************************************************
Author: Ashok Cherapalli
Description: This apex class is created for the Trigger Framework. This class 
has all the working methods to be called by the PartnerCommunityDataHandler.
**********************************************************************************/
public class PartnerCommunityDataHelper {
    
    public static void PartnerCommunityDataValidation(){
        
        List<String> ContractTypes = new List<String>();
        Map<String,Id> contractData = new Map<String,Id>();
        for(Partner_Community_Data__c data :(List<Partner_Community_Data__c>) Trigger.new){
            if(data.Active__c && String.isNotBlank(data.Contract_Type__c))ContractTypes.addAll(data.Contract_Type__c.split(';'));
        }
        
        if(!ContractTypes.isEmpty()){
            String types = '(\''+String.join(ContractTypes,'\',\'')+'\')';
            String query  = 'SELECT ID,Contract_Type__c FROM Partner_Community_Data__c WHERE RecordType.Name=\'Header\' AND Active__c=true AND Contract_Type__c INCLUDES ';
            query += types;
            if(trigger.newMap != null){
                Set<Id> ids = trigger.newMap.keySet();
                query += ' AND Id NOT IN :ids';
            }
            
            List<String> existedContracts = new List<String>();
            for(Partner_Community_Data__c existdata:database.query(query)){
                existedContracts.addAll(existdata.Contract_Type__c.split(';'));
            }
            for(Partner_Community_Data__c pdata : (List<Partner_Community_Data__c>) Trigger.new){
               /* for(String newContract:pdata.Contract_Type__c.split(';')){
                     if(existedContracts.contains(newContract))pdata.addError('The selected Contract Type already exists.');
                    else existedContracts.add(newContract); 
                   
                }*/
                 existedContracts.addAll(pdata.Contract_Type__c.split(';'));
            }
            
        } 
    }
    
}