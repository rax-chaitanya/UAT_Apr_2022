/**********************************************************************************

Author: Pradeep Guttha
Description: This apex class is created for the FieldMapping on all the SObjects across the Org. It uses FieldMapping__c custom settings to retrieve corresponding source fields and target fields of different Sobjects.

ChangeLog:
Edited: 10/15/16. Converted the for loop over all field mappings to a for loop over queried field mapping that match the specified Comp Name
Developer: Diego Castro
**********************************************************************************/
public class FieldMappingHandler
{
    //Auto pouplate Address,Phone and Email fields on AccountContactRole object records from their contact 
    public static void AcrAddressMapping()
    {
        try {
            
            List<FieldMapping__c> fieldMapping = [Select Id, SourceField__c, TargetField__c , createdby.name from FieldMapping__C where CompName__c = 'AccountContactRoleHandler'];
            Set<Id> conIds = new Set<Id>();
            for(SObject obj : (List<SObject>)Trigger.new)
            {
                for(FieldMapping__c cus : fieldMapping)
                {
                    if(String.isBlank((String)obj.get(cus.TargetField__c)))
                    {
                        conIds.add((String)obj.get('contact__c'));
                        break;
                    }    
                }
            }
            
            //Dynamic SOQL on Contact to retrive fields from custom setting
            String Tquery = 'Select id,';
            for(FieldMapping__c c : fieldMapping)
            {
                Tquery += c.SourceField__c + ',';
            }
            Tquery = Tquery.removeEnd(',');
            Tquery += ' ' + 'from contact where id in : conIds';
            
            Map<id, SObject> conMap = new Map<id, SObject>(Database.Query(Tquery));
            
            try
            { 
                for(SObject acr : (List<SObject>)Trigger.new)
                {
                    SObject c = conMap.get((String)acr.get('contact__c'));
                    
                    for(FieldMapping__c cus : fieldMapping)
                    {
                        if(String.isBlank((String)acr.get(cus.TargetField__c)) && String.isNotBlank((String)c.get(cus.SourceField__c)))
                        {
                            acr.put(cus.TargetField__c, c.get(cus.SourceField__c));                  
                        }      
                    }
                }
            }
            catch (Exception e)
            {
                ExceptionHandler.postToAll(e);
                throw new CustomException(ExceptionHandler.getBody(e));
            }
        } catch (Exception ex) {
            ExceptionHandler.postToAll(ex);
            throw new CustomException(ExceptionHandler.getBody(ex));
        } 
    }
}