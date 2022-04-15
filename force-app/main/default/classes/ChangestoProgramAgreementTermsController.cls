/**
* Created by  : Chaitanya
* Created Date: 08/06/2020
* Description: This is the controller for ChangestoProgramAgreementTerms Lightning component for Community page 'Changes to Program terms'
*  
* */

public class ChangestoProgramAgreementTermsController {
    // SFDC-4500
    
    //To return initial pat records
    @AuraEnabled(cacheable=true)
    public static PatWrapper getPatRecords(Integer initialRows){
        PatWrapper patWrapper= new PatWrapper();
        UserWrapper userwrapper = new UserWrapper();
        try{
            if(userwrapper.partnerUser.AccountID != NULL){
                String usercontracttype= [select id,Contract_Type__c from account where id=:userwrapper.partnerUser.AccountID].get(0).Contract_Type__c;
                
                patWrapper.patList = [Select id,Name,Description__c,URL__c,CreatedDate
                                      from Partner_Community_Data__c where  Active__c=true AND Contract_Type__c includes (:usercontracttype) 
                                      AND RecordTypeId=:userwrapper.recordTypeId  ORDER BY Createddate DESC LIMIT :initialRows OFFSET 0];
                patWrapper.totalRecords = [SELECT COUNT() FROM Partner_Community_Data__c where Contract_Type__c includes (:usercontracttype) 
                                           AND RecordTypeId=:userwrapper.recordTypeId];
            }
            else{
                patWrapper.patList=[Select id,Name,Description__c,URL__c,CreatedDate from Partner_Community_Data__c where  Active__c=true AND RecordTypeId=:userwrapper.recordTypeId  ORDER BY Createddate DESC LIMIT :initialRows OFFSET 0];
                patWrapper.totalRecords = [SELECT COUNT() FROM Partner_Community_Data__c where RecordTypeId=:userwrapper.recordTypeId AND Active__c=true];
            }
            patWrapper.message = 'Program Agreement terms records are loaded';
            patWrapper.success = true;
        }
        catch(Exception e){
            patWrapper.message = e.getMessage();
            patWrapper.success = false;
        }
        return patWrapper;
    }
    
    //To return additional records based on offset
    @AuraEnabled(cacheable=true)
    public static List<Partner_Community_Data__c> loadPatRecords(Integer rowLimit,Integer rowOffset){
        UserWrapper userwrapper = new UserWrapper();
        List<Partner_Community_Data__c> PatRecords = new List<Partner_Community_Data__c>();
        system.debug('aaaaaaaaa'+userwrapper.partnerUser.AccountID);
        if(userwrapper.partnerUser.AccountID != NULL){  
            String usercontracttype= [select id,Contract_Type__c from account where id=:userwrapper.partnerUser.AccountID].get(0).Contract_Type__c;
            
            PatRecords= [Select id,Name,Description__c,URL__c,CreatedDate
                         from Partner_Community_Data__c where Active__c=true AND Contract_Type__c includes (:usercontracttype) 
                         AND RecordTypeId=:userwrapper.recordTypeId  ORDER BY Createddate DESC LIMIT :rowLimit OFFSET :rowOffset];
            
        }
        else{
            PatRecords= [Select id,Name,Description__c,URL__c,CreatedDate from Partner_Community_Data__c where RecordTypeId=:userwrapper.recordTypeId AND Active__c=true ORDER BY Createddate DESC LIMIT :rowLimit OFFSET:rowOffset];
            
        }
        return PatRecords;
    }
    
    // wrapper class
    public class PatWrapper{
        @AuraEnabled
        public Integer totalRecords = 0;
        @AuraEnabled
        public List<Partner_Community_Data__c> patList = new List<Partner_Community_Data__c>();
        @AuraEnabled
        public String message;
        @AuraEnabled
        public Boolean success;
    }
    Public class UserWrapper{
        Id recordTypeId =Schema.SObjectType.Partner_Community_Data__c.getRecordTypeInfosByDeveloperName().get('Program_Agreement_Terms').getRecordTypeId();
        User partnerUser = [Select id,ContactId,AccountId From User Where Id=: UserInfo.getUserId()];
        
        
    }
    
}