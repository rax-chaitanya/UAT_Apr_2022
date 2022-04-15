public without sharing class LibrariesController { 
    @AuraEnabled 
    public static List<DataFiles> getLibraries() { 
        List<DataFiles> contentDocs = new List<DataFiles>(); 
        Map<Id,Id> contentDoc = new Map<Id,Id>();
        String emptyIconId;
        for(ContentDocument cdoc:[Select Title,LatestPublishedVersionId,ContentAssetId From ContentDocument where ParentId =:System.Label.Asset_Library_Id]){
            if(cdoc.Title.equalsIgnoreCase('LibraryIcon')){
                emptyIconId = cdoc.LatestPublishedVersionId;
            }
            contentDoc.put(cdoc.ContentAssetId,cdoc.LatestPublishedVersionId);
        } 
        List<String> libraryNames = new List<String>(); 
        for(LibrarySetting__c libs:LibrarySetting__c.getAll().values()){
             libraryNames.add(libs.Name);
        }
        for(ContentWorkspace cWork : [SELECT Id, Name, Description,WorkspaceImageId,RootContentFolderId  FROM ContentWorkspace where Name NOT IN:libraryNames Order By Name]){
            if(cWork.WorkspaceImageId != null){
                contentDocs.add(new DataFiles(cWork ,contentDoc.get(cWork.WorkspaceImageId))); 
            }
            else{
                contentDocs.add(new DataFiles(cWork ,emptyIconId)); 
            }            
        } 
        return contentDocs;
        
    }
    public class DataFiles{
        @AuraEnabled public String fileId {set;get;}
        @AuraEnabled public String Id{set;get;}
        @AuraEnabled public String Name{set;get;}
        @AuraEnabled public String description{set;get;}
        @AuraEnabled public String iconId{Set;get;}
        public DataFiles(ContentWorkspace content, Id cDocId){
            this.description = content.Description ;
            this.Name = content.Name;
            this.Id = content.Id;
            this.fileId  = content.RootContentFolderId +'-'+content.Id;
            this.iconId = cDocId;  
        }
    }
}