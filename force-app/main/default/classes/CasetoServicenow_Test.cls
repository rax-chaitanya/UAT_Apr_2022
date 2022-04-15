@isTest
public class CasetoServicenow_Test {
    
    static testmethod void UpdateCaseValues(){
   Case abc = new Case();
        abc.Status = 'New';
        abc.Tool__c = 'QM';
        abc.RecordTypeId = [Select Id, Name,developername from RecordType where developername = 'Salesforce_Help'].id; 
        abc.Support_Reason__c = 'QM Support';
        insert abc;
            CaseServiceNowController.GetCaseValues(abc.Id);     
    }    
}