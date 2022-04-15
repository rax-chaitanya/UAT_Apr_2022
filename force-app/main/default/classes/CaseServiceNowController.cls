/*
* File : CaseServiceNowController.apxc
* Description : Used to fetch fields and change the status of case to close.
* Ticket : SFDC-3140
* Created Date : October 2019
* @author : RDC (Anirudh)
*/

public without sharing class CaseServiceNowController {   
    @AuraEnabled
    public static Case GetCaseValues(String recordId){
        Case cs = [select Id,status,Federation_ID__c, Quote_Link__c, Description FROM Case where id=:recordId];       
        cs.status = 'closed';
        update cs;
        return cs;             
    }    
}