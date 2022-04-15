public class UpdateTerritory{
    /* As per GTMO-660 optimized the below code by Rajasekhar */
    public static void populateTerritory(List<SObject> Records, Map<Id, SObject> tMap, String Name)
    {
        try {
            // Added by Anjaneyulu to Avoid 101 SOQl queries on Lead Conversion -- Starts
            // List<FieldMapping__c> fieldMapping = [Select Id, CompName__c, SourceField__c, TargetField__c , createdby.name from FieldMapping__c where CompName__c =: Name];
            String fieldMappingName;
            FieldMapping__c fieldMapping = new FieldMapping__c();
            if(Name == 'Account'){
                fieldMappingName = 'Territory-Company';
                fieldMapping = FieldMapping__c.getValues(fieldMappingName); 
            }else if(Name == 'Contact'){
                fieldMappingName = 'Territory-Contact';
                fieldMapping = FieldMapping__c.getValues(fieldMappingName); 
            }else if(Name == 'Lead'){
                fieldMappingName = 'Territory-Lead';
                fieldMapping = FieldMapping__c.getValues(fieldMappingName); 
            }else{
                fieldMappingName = Name;
            }   
                        
            // Added by Anjaneyulu to Avoid 101 SOQl queries on Lead Conversion -- Ends
            for(SObject c : Records)
            {
                    String str = '';                
                    //System.debug('CompName__c:' + fieldMapping.CompName__c);
                    if(Name == fieldMapping.CompName__c)
                    {
                        if(trigger.isInsert || trigger.isUpdate)
                        {
                            //System.debug('SourceField:' + fieldMapping.SourceField__c);
                            str = Territory((String)c.get(fieldMapping.SourceField__c));
                            //System.debug('territoryStr:' + str);
                            c.put(fieldMapping.TargetField__c, str);
                            
                            // Added by Anjaneyulu for SFDC-2829 -- Starts
                            if(Name == 'Lead' && String.isBlank(str))
                                c.put(fieldMapping.TargetField__c, 'Unassigned');
                            // Added by Anjaneyulu for SFDC-2829 -- Ends
                        }
                    } 
                        
            }
        }
        catch (Exception e) {
            ExceptionHandler.postToAll(e, true);  
        }
    }
    
    public static string Territory(String str){    
        String territory = '';    
        //System.debug('Sourcestr:' + str);
        if(String.isNotBlank(str))
        {
           //Start-By Divya for SFDC-2564     
         str = str.replace('\'', '_'); 
         //End- By Divya for SFDC-2564 
          if(str.length() > 35)
             str = str.substring(0,35);
            if(CountryTerritoryMapping__c.getInstance(str) != null)
                territory = CountryTerritoryMapping__c.getInstance(str).Territory_Name__c;
              /*if(CountryCodeTerritoryMapping__c.getInstance(str) != null)
                territory = CountryCodeTerritoryMapping__c.getInstance(str).Territory_Name__c;*/   
                //System.debug('territory:' + territory);
        } 
        return territory;  
    }     
}