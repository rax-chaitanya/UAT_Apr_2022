//TermsandConditionsTrigger_Test
public class TermsandConditionsTriggerHelper {
    public static void afterInsertOperations(List<Terms_and_Conditions__c> TermsConditions){
        List<Contentdocumentlink> fileinsert = new List<Contentdocumentlink>();
        for (Terms_and_Conditions__c TandD : TermsConditions) {
            if(TandD.Contact__c!=null){
                Contentdocumentlink CDL = new Contentdocumentlink();
                CDL.ContentDocumentId=System.Label.TandDDocumentid;//'069020000003xZjAAI';//
                CDL.LinkedEntityId=TandD.Contact__c;
                CDL.ShareType='V';
                CDL.Visibility='AllUsers';
                fileinsert.add(CDL);
            }
        }
        Insert fileinsert;
    }
}