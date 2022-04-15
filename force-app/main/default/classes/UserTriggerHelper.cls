/*
###########################################################################
# File..................: UserTriggerHelper.cls
# Version...............: 1.0
# Created by............: Kartikeya Tewari (RDC)
# Created Date..........: 12-Apr-2017
# Description...........: This is an Apex class to hold business logic for User triggers.
*/
public with sharing class UserTriggerHelper {
    
    //method to be called on insert and update of User records.
    //will populate SSO Username with the Federation Id . 
    //arg1 - Trigger.New list
    //returns nothing
    public static void populateSSOFromFederation(List<User> triggerNew) {
        for(User u : triggerNew) {
            //iterate over Users' list and populate SSO Username from  FederationIdentifier if its not matching.
            if(String.isNotBlank(u.FederationIdentifier) && u.FederationIdentifier != u.SSO_Username__c) {
                u.SSO_Username__c = u.FederationIdentifier;
            }
            //add error if either Federation Id or SSO Username is blank
            if((String.isBlank(u.SSO_Username__c) || String.isBlank(u.FederationIdentifier)) && !System.Label.Partner_Profiles.contains(u.ProfileId) && u.UserType == 'Standard'){
                u.FederationIdentifier.addError(System.Label.Federation_Id_Mandatory_EM);
            }
        }
    }
    //Added by Saswati For SFDC-3576
    public static void removeUserFromPackage(){
        Set<id> inactiveUserIds = new Set<id>();
        list<UserPackageLicense> packageLicenses = new list<UserPackageLicense>();
        for(User u : (List<User>) Trigger.new) {
        User oldUser = (User)Trigger.oldMap.get(u.id);

        if(!u.IsActive && oldUser.isActive){
            inactiveUserIds.add(u.Id);  
            }
        }
        if(!inactiveUserIds.isEmpty()){
            packageLicenses = [SELECT Id FROM UserPackageLicense WHERE UserId IN :inactiveUserIds];
        }
        if(!packageLicenses.isEmpty()){
            delete packageLicenses;    
        }
    }
        //Added By sundarayya E for SFDC-6013
    // contacts recordtype will be updatted to PSA RecordType or Employee based on PSA Resource on User level
    public static void updateContactRecordTypePSA(){
        Map<Id, User> newUserMap = (Map<Id, User>)Trigger.NewMap;
        Map<Id,user> oldUserMap = (Map<Id, User>)Trigger.OldMap;
        Map<Id, Boolean> userIdToPSAResource = new Map<Id, Boolean>();
        list<Contact> updateContactList = new List<Contact>();
        List<Contact> contactListToUpdate = new List<Contact>();
        for(User u : (List<User>)Trigger.new){
            if(!u.isActive && u.PSA_Resource__c != oldUserMap.get(u.id).PSA_Resource__c && u.PSA_Resource__c == true){
                u.addError('You cannot enable PSA Resource on inactive user');
            }else{
                if(u.isActive && u.PSA_Resource__c != oldUserMap.get(u.id).PSA_Resource__c && u.PSA_Resource__c == true){
                    userIdToPSAResource.put(u.Id, u.PSA_Resource__c);
                }
            }
        }
        updateContactList = [Select Id, pse__Salesforce_User__c, RecordTypeId from Contact where  pse__Salesforce_User__c IN: userIdToPSAResource.KeySet()];
        if(updateContactList.size() > 0){
            for(Contact con : updateContactList){
                if(userIdToPSAResource.containsKey(con.pse__Salesforce_User__c) && userIdToPSAResource.get(con.pse__Salesforce_User__c) == true && 
                   !System.Label.PSA_RecordType.contains(con.RecordTypeId)){
                    con.RecordTypeId = System.Label.PSA_RecordType;
                        //system.Label.Employee_Contact_Record_Type;
                     contactListToUpdate.add(con);
                }/*else if(userIdToPSAResource.containsKey(con.pse__Salesforce_User__c) && userIdToPSAResource.get(con.pse__Salesforce_User__c) == false &&
                        !System.Label.Employee_Contact_Record_Type.contains(con.RecordTypeId)){
                    con.RecordTypeId = system.Label.Employee_Contact_Record_Type;
                        contactListToUpdate.add(con);
                }*/
            }
            if(contactListToUpdate.size()> 0){
                try{
                    Update contactListToUpdate;
                }catch(Exception e){
                    ExceptionHandler.postToAll(e);
                    throw new CustomException(ExceptionHandler.getBody(e));
                }
            }
        }
    }
    //SFDC-6013 ends Added by Sundarayya E
}