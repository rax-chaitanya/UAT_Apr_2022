/* Last Modified by - Chaitanya Nov 2021
 * SFDC-6972 Opportunity Notes data to be made visible in Partner Portal
 * shareNotes - Added this Method which is being called in before insert for setting sharing type to All Users
 * Test Class - ContentDocumentLinkHelper_Test
 * 
 */
public class ContentDocumentLinkHelper {
    
    public static void ContentDocumentLinkMethod(List<ContentDocumentLink> FileList)
    {
        
        //collect all the parentId's into a set
        set<Id> pIds = new set<Id>();
        
        //list of all role to be updated with the flag
        List<Partner_Role__c> toUpdate = new List<Partner_Role__c>();
        
        //Collect all parentIds
        for(ContentDocumentLink a : FileList){
            pIds.add(a.LinkedEntityId);
        }
        if(pIds.size()>0)
        {
            for(Partner_Role__c PR : [select Id, Has_Attachment__c, Status__c from Partner_Role__c where id IN :pIds and Role__c='Influence'])
            {
                PR.Has_Attachment__c = true;
                PR.Status__c= 'Pending Approval';
                
                toUpdate.add(PR);
            }
        }
        if(toUpdate.size()>0){
            try { Update toUpdate; 
                 system.debug('toUpdate@@@@@@' + toUpdate);
                } catch (Exception e) {ExceptionHandler.postToAll(e);throw new CustomException(ExceptionHandler.getBody(e));}
        }
    }
    
    public static void updateFileNameMDF(List<ContentDocumentLink> FileList){
        
        //collect all the parentId's into a set
        set<Id> pIds = new set<Id>();
        Set<Id> contDocId = new set<Id>();
        //Map<Id,Id> linkedIdByPartnerClaimIdMap = new Map<Id,Id>();
        map<Id, ContentDocument> mapContentDocuments ;
        
        //Collect all parentIds
        for(ContentDocumentLink a : FileList){
            pIds.add(a.LinkedEntityId);
            contDocId.add(a.ContentDocumentId);
            //linkedIdByPartnerClaimIdMap.put(a.LinkedEntityId,a.Id);
        }
        Map<Id,PartnerFundClaim> partnerFundClaimMap;
        //Map<Id, List<ContentDocumentLink>> filesListByPartnerClaimsMap = new Map<Id, List<ContentDocumentLink>>();
        if(pIds.size()>0){
            
            partnerFundClaimMap = new Map<Id,PartnerFundClaim>([select Id, Title,Request__c  from PartnerFundClaim where id IN :pIds]);
            
        }
        List<ContentDocument> docRecList = new List<ContentDocument>();
        if(partnerFundClaimMap.size()>0){
            mapContentDocuments = new map<Id, ContentDocument>([SELECT Id, Title, FileExtension FROM ContentDocument WHERE Id IN :contDocId]);
            for(ContentDocumentLink cdlIterator : FileList){
                if(partnerFundClaimMap.containsKey(cdlIterator.LinkedEntityId)){
                    ContentDocument docRec = mapContentDocuments.get(cdlIterator.ContentDocumentId);
                    String requestName = partnerFundClaimMap.get(cdlIterator.LinkedEntityId).Request__c;
                    //String requestName = partnerFundClaimMap?.get(cdlIterator.LinkedEntityId)?.Request__c;
                    if(docRec.Title.Contains('Invoice')){
                        String docName = docRec.Title;
                        String newName = 'Invoice_'+requestName+'-';
                        docRec.Title = docName.replace('Invoice',newName );
                    }
                    docRecList.add(docRec );
                }
            }
        }
        update docRecList;
    }
    
    
    // Updated as part of  SFDC- 7195 - Email notification to Partner Contact when Sharing Notes On Opporutnities -Rishabh 12/02/22
    public static void shareNotes(List<ContentDocumentLink> FileList){
        Set<Id> notesOppId = new Set<Id>(); //SFDC-7195
        for(ContentDocumentLink cont : FileList)
        { 
            if((cont.LinkedEntityId.getSObjectType() == Opportunity.sObjectType)) {
                
                cont.Visibility = 'AllUsers'; 
                notesOppId.add(cont.LinkedEntityId);//SFDC-7195
                
            }
        } 
        if(!notesOppId.isEmpty()){
            PartnerRolesEmailController.processOpportunities(notesOppId);//SFDC-7195
        }
        
    }
    
}