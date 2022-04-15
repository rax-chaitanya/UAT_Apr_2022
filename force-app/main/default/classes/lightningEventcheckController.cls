public class lightningEventcheckController {
    
    @AuraEnabled
    public static String isAddressVerified(String objId, String objectName){
        Map<String, Address_Doctor_Fields_Config__mdt> mapOfFieldsToAddressType = new Map<String, Address_Doctor_Fields_Config__mdt>();
        List<String> fields = new List<String>();
        String retString = 'No AddrDoc';
        if(!String.isBlank(objId) && !String.isBlank(ObjectName)){
            for(Address_Doctor_Fields_Config__mdt mapping : Database.query('Select Address_Type__c,Address_Bypassed__c, Address_Verified__c, City_Api_Name__c, Country_Api_Name__c, PostalCode_Api_Name__c, State_Api_Name__c, Street_Api_Name__c from Address_Doctor_Fields_Config__mdt where Object_Name__c =: objectName')){
                mapOfFieldsToAddressType.put(mapping.Address_Type__c, mapping);
                fields.add(mapping.Address_Verified__c);
                fields.add(mapping.Address_Bypassed__c);
            }
        }
        
            system.debug('Query Result'+'Select '+ String.join(fields , ', ') +' from '+objectName +' where id =: objId');
            for(sobject eachRec: (List<sObject>)Database.query('Select '+ String.join(fields , ', ') +' from '+objectName +' where id =: objId')){
                //response = new AddressRes(null, null, null, acc.BillingStreet, acc.BillingCity, acc.BillingState, acc.BillingPostalCode, acc.BillingCountry, null);
                //Integer i=0;
                
                for(String key : mapOfFieldsToAddressType.keySet()){
                    system.debug(objId+'======='+eachRec.get(mapOfFieldsToAddressType.get(key).Address_Verified__c));
                    if(!(Boolean)eachRec.get(mapOfFieldsToAddressType.get(key).Address_Verified__c) && 
                      !(Boolean)eachRec.get(mapOfFieldsToAddressType.get(key).Address_Bypassed__c)){
                        return 'AddrDoc,'+objId; 
                    }
                }
                return retString;    
            }
       
        return retString;
    }
}