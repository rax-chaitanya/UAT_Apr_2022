/*
* @Summary: Entity to represent a json version of a picklist entry
* so that the validFor property becomes exposed
*/
public class TPicklistEntry{
    public string active {get;set;}
    public string defaultValue {get;set;}
    public string label {get;set;}
    public string value {get;set;}
    public string validFor {get;set;}
    public TPicklistEntry(){
        
    }
}