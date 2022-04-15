/*
Designer & Reviewer 					-			Seshagiri Bandila		
DeveloperName							-			Shravan Godha				
US										-		 	https://jira.rax.io/browse/SFDC-6344	
Project 								-			ACE CRM				
Test Class  - Coverage 					-			StateandCountryPicklistValues_Test - 100%						
Description								-			Mulesoft will call this Apex Method to validate the state picklist in Salesforce From AWS  
*/
/////////////////////////////////////////////////////////////
/* Below are some sample Input and outputs
Input format :  
A||B
IN||TG     
US||FL
United States||TX 
United States||TTT 
India||Hyderabad

Output  : 
        A||B                   = Unknown||Unknown
        IN||TG                 = IN||InValid
        US||FL                 = United States||Florida
        United States||TX   = United States||Texas
        United States||TTT  = United States||Unknown		
		India||Hyderabad	= India||Invalid
*/

@RestResource(urlMapping='/StateCountryValues/*')
Global With sharing class StateandCountryPicklistValues {
    @HttpPost
    global static Map<String,String> CountryStateValues(List<String> CountryStateLabel)
    {
        Map<String,List<String>> controllingInfo = new Map<String,List<String>>();
        Schema.SObjectType objType = Schema.getGlobalDescribe().get('User');
        Schema.DescribeSObjectResult describeResult = objType.getDescribe();
        Schema.DescribeFieldResult controllingFieldInfo = describeResult.fields.getMap().get('CountryCode').getDescribe();
        Schema.DescribeFieldResult dependentFieldInfo = describeResult.fields.getMap().get('StateCode').getDescribe();
        List<Schema.PicklistEntry> controllingValues = controllingFieldInfo.getPicklistValues();
        List<Schema.PicklistEntry> dependentValues = dependentFieldInfo.getPicklistValues();
        Map<String,String> Countryvalus =New Map<String,String>();
        for(Schema.PicklistEntry currControllingValue : controllingValues)
        {
            controllingInfo.put(currControllingValue.getLabel(),new List<String>());
            controllingInfo.put(currControllingValue.getValue(),new List<String>());
            controllingInfo.put(currControllingValue.getLabel().toLowerCase(),new List<String>());
            controllingInfo.put(currControllingValue.getValue().toLowerCase(),new List<String>());
            Countryvalus.put(currControllingValue.getValue(),currControllingValue.getLabel()); 
            Countryvalus.put(currControllingValue.getLabel(),currControllingValue.getLabel());
            Countryvalus.put(currControllingValue.getLabel().toLowerCase(),currControllingValue.getLabel());
            Countryvalus.put(currControllingValue.getValue().toLowerCase(),currControllingValue.getLabel());
            
        }
        for(Schema.PicklistEntry currDependentValue : dependentValues)
        {
            String jsonString = JSON.serialize(currDependentValue);
            MyPickListInfo info = (MyPickListInfo) JSON.deserialize(jsonString, MyPickListInfo.class);
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
                    controllingInfo.get(controllingValues[baseCount + 0].getValue()).add(currDependentValue.getLabel());
                    controllingInfo.get(controllingValues[baseCount + 0].getLabel().toLowerCase()).add(currDependentValue.getLabel());
                    controllingInfo.get(controllingValues[baseCount + 0].getValue().toLowerCase()).add(currDependentValue.getLabel());
                    //controllingInfo.get(controllingValues[baseCount + 0].getLabel()).add(currDependentValue.getValue());
                    //controllingInfo.get(controllingValues[baseCount + 0].getValue()).add(currDependentValue.getValue());
                    
                }
                if((val & 4) == 4)
                {
                    controllingInfo.get(controllingValues[baseCount + 1].getLabel()).add(currDependentValue.getLabel());
                    controllingInfo.get(controllingValues[baseCount + 1].getLabel()).add(currDependentValue.getValue());
                    controllingInfo.get(controllingValues[baseCount + 1].getValue()).add(currDependentValue.getLabel());
                    controllingInfo.get(controllingValues[baseCount + 1].getLabel().toLowerCase()).add(currDependentValue.getLabel());
                    controllingInfo.get(controllingValues[baseCount + 1].getValue().toLowerCase()).add(currDependentValue.getLabel());
                    //controllingInfo.get(controllingValues[baseCount + 1].getLabel()).add(currDependentValue.getValue());
                    //controllingInfo.get(controllingValues[baseCount + 1].getValue()).add(currDependentValue.getValue());
                }
                if((val & 2) == 2)
                {
                    controllingInfo.get(controllingValues[baseCount + 2].getLabel()).add(currDependentValue.getLabel());
                    controllingInfo.get(controllingValues[baseCount + 2].getValue()).add(currDependentValue.getLabel());
                    controllingInfo.get(controllingValues[baseCount + 2].getLabel().toLowerCase()).add(currDependentValue.getLabel());
                    controllingInfo.get(controllingValues[baseCount + 2].getValue().toLowerCase()).add(currDependentValue.getLabel());
                    //controllingInfo.get(controllingValues[baseCount + 2].getLabel()).add(currDependentValue.getValue());
                    //controllingInfo.get(controllingValues[baseCount + 2].getValue()).add(currDependentValue.getValue());
                    
                }
                if((val & 1) == 1)
                {
                    //System.debug('Dependent Field: ' + currDependentValue.getLabel() + ' Partof ControllingField:' + controllingValues[baseCount + 3].getLabel());
                    controllingInfo.get(controllingValues[baseCount + 3].getLabel()).add(currDependentValue.getLabel());
                    controllingInfo.get(controllingValues[baseCount + 3].getValue()).add(currDependentValue.getLabel());
                    controllingInfo.get(controllingValues[baseCount + 3].getLabel().toLowerCase()).add(currDependentValue.getLabel());
                    controllingInfo.get(controllingValues[baseCount + 3].getValue().toLowerCase()).add(currDependentValue.getLabel());
                    //controllingInfo.get(controllingValues[baseCount + 3].getLabel()).add(currDependentValue.getValue());
                    //controllingInfo.get(controllingValues[baseCount + 3].getValue()).add(currDependentValue.getValue());
                    
                }
                baseCount += 4;
            }            
        }
        Map<String,String> CountryStateMap =New Map<String,String>();
        Map<String,String> USStates=New Map<String,String>();
        List<String> CountryStates  = new List<String>();
        List<String> StateLabelList  = new List<String>();
        List<String> States = new List<String>();
        String countryname; String  statename;
        String countrynameLCase;
        String statenameLCase;
        for(String s: CountryStateLabel)
        {       
            StateLabelList.add(s.subStringAfter('||'));
            if(s.subStringBefore('||') != null && s.subStringBefore('||') == 'United States' &&  s.subStringBefore('||') == 'US')
                CountryStates.add(s);
        }
        
        list<State_and_StateCodes__mdt> USAStates = [Select State__c,State_Code__c,Country__c from State_and_StateCodes__mdt where country__c = 'United States'];
        if(CountryStates != null)
        {
            String USCodeLower = '';
            String USLabelLower = '';
            for(State_and_StateCodes__mdt US_states : USAStates)
            {               
                USStates.put(US_states.State__c, US_states.State__c);
                USStates.put(US_states.State_Code__c, US_states.State__c);
                USCodeLower = US_states.State_Code__c; 
                USLabelLower = US_states.State__c; 
                USStates.put(USCodeLower.toLowerCase(), US_states.State__c);
                USStates.put(USLabelLower.toLowerCase(), US_states.State__c);
                
                controllingInfo.get('United States').add(US_states.State_Code__c);
                controllingInfo.get('United States').add(USCodeLower.toLowerCase());
                controllingInfo.get('United States').add(USLabelLower.toLowerCase());
                controllingInfo.get('US').add(USCodeLower.toLowerCase());
                controllingInfo.get('US').add(USLabelLower.toLowerCase());
                controllingInfo.get('US').add(US_states.State_Code__c);
            }
        }
        for(String AWS : CountryStateLabel){
            {    
                countryname = AWS.subStringBefore('||');
                statename = AWS.subStringAfter('||');
                countrynameLCase = countryname.toLowerCase();
                statenameLCase=statename.toLowerCase();
                if( Countryvalus.containsKey(countryname) || controllingInfo.containsKey(countryname) ){
                    if(controllingInfo.get(countryname).contains(statename) || 
                       controllingInfo.get(countrynameLCase).contains(statenameLCase) || 
                       controllingInfo.get(countryname).contains(statenameLCase) || 
                       controllingInfo.get(countrynameLCase).contains(statename))
                    {
                        for(string str : controllingInfo.get(countryname))
                        {
                            if(str.equalsIgnoreCase(statename) || str.toLowerCase()==statenameLCase){
                                if((countryname == 'United States' || countryname == 'US' ||
                                    countrynameLCase == 'US') && countryname.toLowerCase() == countrynameLCase)
                                { 
                                    str=USStates.get(str);
                                }
                                CountryStateMap.put(AWS,Countryvalus.get(countryname) +'||'+ str);  
                            }
                        }
                    }
                    else {
                        if((countryname == 'United States' || countryname == 'US' ||
                            countrynameLCase == 'US') && countryname.toLowerCase() == countrynameLCase)
                        {
                            CountryStateMap.put(AWS, Countryvalus.get(countryname) +'||'+ 'Unknown');
                        }
                        else {
                            CountryStateMap.put(AWS, Countryvalus.get(countryname) +'||'+ 'Invalid');
                        }
                        
                    }
                }
                else{
                    CountryStateMap.put(AWS,'Unknown' +'||'+ 'Unknown');  
                }
            }
        }
        //system.debug('CountryStateMap@@@@@'+ CountryStateMap);
        return CountryStateMap;
    }
    public class MyPickListInfo{   
        public String validFor;
    }
    
}