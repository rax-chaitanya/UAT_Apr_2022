Public class ApexDependentPicklistUtility
{
    public String validFor;    
    
    public static Map<String, List<String>> getDependentOptions(String objApiName, String contrfieldApiName, String depfieldApiName)
    {
        Map<String, List<String>> controllingInfo = new Map<String, List<String>>();
        
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objApiName);
        Schema.DescribeSObjectResult describeResult = objType.getDescribe();
        Schema.DescribeFieldResult contrfieldApiNameInfo = describeResult.fields.getMap().get(contrfieldApiName).getDescribe();
        Schema.DescribeFieldResult depfieldApiNameInfo = describeResult.fields.getMap().get(depfieldApiName).getDescribe();
        
        List<Schema.PicklistEntry> controllingValues = contrfieldApiNameInfo.getPicklistValues();
        List<Schema.PicklistEntry> dependentValues = depfieldApiNameInfo.getPicklistValues();
        
        for(Schema.PicklistEntry currControllingValue : controllingValues)
        {
            controllingInfo.put(currControllingValue.getLabel(), new List<String>());
        }
        
        for(Schema.PicklistEntry currDependentValue : dependentValues)
        {
            String jsonString = JSON.serialize(currDependentValue);
            
            PicklistEntry info = (PicklistEntry) JSON.deserialize(jsonString, PicklistEntry.class);
            
            String hexString = EncodingUtil.convertToHex(EncodingUtil.base64Decode(info.validFor)).toUpperCase();
            
            Integer baseCount = 0;
            
            for(Integer curr : hexString.getChars())
            {
                Integer val = 0;
                
                if(curr >= 65)
                {
                    val = curr - 65 + 10;
                }
                else
                {
                    val = curr - 48;
                }
                
                if((val & 8) == 8)
                {                
                    controllingInfo.get(controllingValues[baseCount + 0].getLabel()).add(currDependentValue.getLabel());
                }
                if((val & 4) == 4)
                {               
                    controllingInfo.get(controllingValues[baseCount + 1].getLabel()).add(currDependentValue.getLabel());                    
                }
                if((val & 2) == 2)
                {               
                    controllingInfo.get(controllingValues[baseCount + 2].getLabel()).add(currDependentValue.getLabel());                    
                }
                if((val & 1) == 1)
                {               
                    controllingInfo.get(controllingValues[baseCount + 3].getLabel()).add(currDependentValue.getLabel());                    
                }
                
                baseCount += 4;
            }            
        } 
        
        return controllingInfo;
    }
    
    public class PicklistEntry{
        
        public PicklistEntry(){            
        }
        public String active {get;set;}
        public String defaultValue {get;set;}
        public String label {get;set;}
        public String value {get;set;}
        public String validFor {get;set;}
    }
    
    public static List<String> getPicklistValues(String objApiName, String fieldApiName){
        List<String> result = new List<String>();
        
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objApiName);
        Schema.DescribeSObjectResult describeResult = objType.getDescribe();
        Schema.DescribeFieldResult fieldApiNameInfo = describeResult.fields.getMap().get(fieldApiName).getDescribe();
        
        List<Schema.PicklistEntry> fieldPicklistValues = fieldApiNameInfo.getPicklistValues();
        
        for(Schema.PicklistEntry value : fieldPicklistValues)
        {
            result.add(value.getLabel());
        }
        return result;
    }
}