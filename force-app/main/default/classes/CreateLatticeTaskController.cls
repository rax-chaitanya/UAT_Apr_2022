/**
* File :  CreateLatticeContact.cls
* Description : Create task activity for Lattice contact.
* Created Date : 15/Jan/2019
* Author : RDC
*/
public class CreateLatticeTaskController{
    
    @AuraEnabled 
    public static user fetchUser(){
        // query current user information  
        User oUser; 
        oUser = [select id,Name FROM User Where id =: userInfo.getUserId()];
        return oUser;
    }
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        allOpts.sort();
        return allOpts;
    }
    
    @AuraEnabled 
    public static string saveCallTask(string tskObj){
        // query current user information  
        User oUser;
        oUser = [select id,Name FROM User Where id =: userInfo.getUserId()];
        Task ts = (Task)JSON.deserialize(tskObj, Task.class);
        if(ts != null){
            ts.RecordTypeId = System.Label.Task_Sales_Activity_Record_Type;
            insert ts;
        }
        return ts.id;
    }
    @AuraEnabled
    public static String getCampaigName(string whatId){
        String campaignName;
        if(whatId!= null || whatId!=''){
            List<Campaign> campaignList = [Select Name From Campaign where id=:whatId LIMIT 1];
            for(Campaign c:campaignList){
                campaignName = c.Name;
            }
        }
        return campaignName;
    }
    
    @AuraEnabled
    public static String getContactName(string WhoId){
        String contactName;
        if(WhoId!= null || WhoId!=''){
            List<contact> contactList = [Select Name From Contact where id=:WhoId LIMIT 1];
            for(contact c:contactList){
                contactName = c.Name;
            }
        }
        return contactName;
    }  
}