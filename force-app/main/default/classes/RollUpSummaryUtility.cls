public class RollUpSummaryUtility {
    
	public enum Method {COUNT, SUM, MIN, MAX, AVG}
	
    public static Id testParentId; 
	public static List<sObject> parentList;
    public static Set<String> calcFieldAPIs = new Set<String>();
	
    public static List<sObject> populateRollupSummary(Method calculationMethod, String parentObjectAPI, String childObjectRelAPI, String rollUpFieldAPI, String lookupFieldAPI, String calcFieldAPI){
        
        Set<Id> parentIds = getparentIds(lookupFieldAPI);
        
        List<sObject> parentRecordsToUpdate = new List<sObject>();
		if(!calcFieldAPIs.contains(calcFieldAPI) && !String.isEmpty(calcFieldAPI)){
			calcFieldAPIs.add(calcFieldAPI);
			parentList = null;
		}
        if(parentIds.size() > 0){
            String query = 'SELECT Id, '+rollUpFieldAPI+', (SELECT Id ';
			for(String fieldAPI : calcFieldAPIs){
				query += ', '+fieldAPI;
			}
			query += ' FROM '+childObjectRelAPI+') FROM '+parentObjectAPI+' WHERE Id IN: parentIds';
			
			if(parentList == null){
				parentList = Database.query(query);
			}
            List<sObject> parentRecordList = parentList;
            
           
            for(sObject parent : parentRecordList){
				Decimal value;
				Decimal count = 0;
				Decimal sum = 0;
				List<sObject> children = (List<Sobject>)(parent.getSObjects(childObjectRelAPI));
				children = children == null ? new List<sobject>() : children;
				count = children.size();
				if(calculationMethod == Method.COUNT){
					value = count;
				}else{
					for(sObject child : children){
						if((calculationMethod == Method.SUM || calculationMethod == Method.AVG) && child.get(calcFieldAPI)!=null){
							
                            sum += (Decimal)child.get(calcFieldAPI);
                            
                            
						}
						if(calculationMethod == Method.MAX && (value == null || value < (Decimal)child.get(calcFieldAPI)) && child.get(calcFieldAPI)!=null){
							value = (Decimal)child.get(calcFieldAPI);
						}
						if(calculationMethod == Method.MIN && (value == null || value > (Decimal)child.get(calcFieldAPI)) && child.get(calcFieldAPI)!=null){
							value = (Decimal)child.get(calcFieldAPI);
						}
					}
					if(calculationMethod == Method.SUM){
						value = sum;
					}
					if(calculationMethod == Method.AVG && count > 0){
						value = sum/count;
					}
				}
				parent.put(rollUpFieldAPI, value);
                parentRecordsToUpdate.add(parent);
            }
    
        }
        
        return parentRecordsToUpdate;
        
    }
	
    public static Set<Id> getparentIds( String lookupFieldAPI){
        Set<Id> parentIds = new Set<Id>();
        
        if(Trigger.IsExecuting){
            if(Trigger.isInsert || Trigger.isUndelete || Trigger.isUpdate){
                for(sObject child : (List<sObject>)Trigger.new ){
                    if(Trigger.isUpdate && child.get(lookupFieldAPI) != ((Map<Id, sObject>)Trigger.oldMap).get(child.Id).get(lookupFieldAPI)){
                        parentIds.add((Id)child.get(lookupFieldAPI));
                        parentIds.add((Id)((Map<Id, sObject>)Trigger.oldMap).get(child.Id).get(lookupFieldAPI));
                    }else{               
                        parentIds.add((Id)child.get(lookupFieldAPI));
                    }
                }
            }
            if(Trigger.isDelete){
                for(sObject child : (List<sObject>)Trigger.old ){   
                    parentIds.add((Id)child.get(lookupFieldAPI));
                }
            }
        }
        if(Test.isRunningTest()){
            parentIds.add(testParentId);
        }
        
        return parentIds;
    }
}