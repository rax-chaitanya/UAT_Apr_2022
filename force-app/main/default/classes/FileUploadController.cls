public class FileUploadController {

     @AuraEnabled  
    public static List<ContentDocument> getFiles(string recordId, String documentId){ 
        Set<Id> recordIds=new Set<Id>{recordId};
        Set<Id> documentIds = new Set<Id>();
        
        ContentVersion uploadedDocument = [SELECT Id, IsLatest, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: documentId AND IsLatest = true LIMIT 1];
        Account account = new account(Id = recordId);
        account.LogoURL__c= '/sfc/servlet.shepherd/version/download/'+ uploadedDocument.Id ;
        Database.update(account);
        
        List<ContentDocumentLink> cdl=[SELECT id,LinkedEntityId,ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN:recordIds];  
        for(ContentDocumentLink cdLink:cdl){  
            documentIds.add(cdLink.ContentDocumentId);  
        }      
        return [SELECT Id,Title,FileType FROM ContentDocument WHERE id IN: documentIds];  
    } 
    
    @AuraEnabled  
    public static void deleteFiles(string sdocumentId){ 
        delete [SELECT Id,Title,FileType from ContentDocument WHERE id=:sdocumentId];       
    }  
    
}