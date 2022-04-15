public class ContactTriggerHelper {
    
    public static void populateDefaultCostRate(){
        String psa_resource_recordType_Id= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('PSA Resource').getRecordTypeId();
        Set<Id> regionPracticeGroupIds = new Set<Id>();
        Set<String> resourceRoles = new Set<String>();
        for(Contact con : (List<Contact>)Trigger.new){
            if(con.RecordTypeId == psa_resource_recordType_Id){
                
                if(String.isNotBlank(con.pse__Region__c))
                regionPracticeGroupIds.add(con.pse__Region__c);
                if(String.isNotBlank(con.pse__Practice__c))
                regionPracticeGroupIds.add(con.pse__Practice__c);
                if(String.isNotBlank(con.pse__Group__c))
                regionPracticeGroupIds.add(con.pse__Group__c);
                if(String.isNotBlank(con.pse__Resource_Role__c))
                resourceRoles.add(con.pse__Resource_Role__c);
            }
        }
        
        if(!regionPracticeGroupIds.isEmpty()){
            
            Map<String, pse__Rate_Card__c> rateCardMap = new Map<String,pse__Rate_Card__c>();
            for(pse__Rate_Card__c rateCard : [SELECT Id, pse__Role__c, pse__Practice__c, pse__Region__c, pse__Group__c, pse__Suggested_Bill_Rate__c FROM pse__Rate_Card__c WHERE pse__Role__c IN : resourceRoles OR pse__Region__c IN: regionPracticeGroupIds OR pse__Practice__c IN : regionPracticeGroupIds OR pse__Group__c IN : regionPracticeGroupIds]){
                
                String key = '';
              Key = String.isNotBlank(rateCard.pse__Role__c) ? Key+ rateCard.pse__Role__c : key;
              Key = String.isNotBlank(rateCard.pse__Region__c) ? Key+ rateCard.pse__Region__c : key;
                Key = String.isNotBlank(rateCard.pse__Practice__c) ? Key+ rateCard.pse__Practice__c : key;
                 Key = String.isNotBlank(rateCard.pse__Group__c) ? Key+ rateCard.pse__Group__c : key;
                rateCardMap.put(key, rateCard);
            }
            
            for(Contact resource : (List<Contact>)Trigger.new){
                if(resource.RecordTypeId == psa_resource_recordType_Id){
                    if(rateCardMap.containsKey(resource.pse__Resource_Role__c + resource.pse__Region__c + resource.pse__Group__c + resource.pse__Practice__c )){
                        resource.pse__Default_Cost_Rate__c = rateCardMap.get(resource.pse__Resource_Role__c + resource.pse__Region__c + resource.pse__Group__c + resource.pse__Practice__c ).pse__Suggested_Bill_Rate__c;
                    }else if(rateCardMap.containsKey(resource.pse__Resource_Role__c + resource.pse__Region__c + resource.pse__Group__c )){
                        resource.pse__Default_Cost_Rate__c = rateCardMap.get(resource.pse__Resource_Role__c + resource.pse__Region__c + resource.pse__Practice__c ).pse__Suggested_Bill_Rate__c;
                    }else if(rateCardMap.containsKey(resource.pse__Resource_Role__c + resource.pse__Group__c + resource.pse__Practice__c)){
                        resource.pse__Default_Cost_Rate__c = rateCardMap.get(resource.pse__Resource_Role__c + resource.pse__Group__c + resource.pse__Practice__c).pse__Suggested_Bill_Rate__c;
                    }
                    else if(rateCardMap.containsKey(resource.pse__Resource_Role__c + resource.pse__Region__c + resource.pse__Practice__c)){
                        resource.pse__Default_Cost_Rate__c = rateCardMap.get(resource.pse__Resource_Role__c + resource.pse__Region__c + resource.pse__Practice__c).pse__Suggested_Bill_Rate__c;
                    }else if(rateCardMap.containsKey(resource.pse__Resource_Role__c + resource.pse__Group__c)){
                        resource.pse__Default_Cost_Rate__c = rateCardMap.get(resource.pse__Resource_Role__c + resource.pse__Group__c).pse__Suggested_Bill_Rate__c;
                    }
                    else if(rateCardMap.containsKey(resource.pse__Resource_Role__c + resource.pse__Region__c)){
                        resource.pse__Default_Cost_Rate__c = rateCardMap.get(resource.pse__Resource_Role__c + resource.pse__Region__c).pse__Suggested_Bill_Rate__c;
                    }
					else if(rateCardMap.containsKey(resource.pse__Resource_Role__c + resource.pse__Practice__c)){
                        resource.pse__Default_Cost_Rate__c = rateCardMap.get(resource.pse__Resource_Role__c + resource.pse__Practice__c).pse__Suggested_Bill_Rate__c;
                    }
                    
                }
                
            }
        }
        
    }
}