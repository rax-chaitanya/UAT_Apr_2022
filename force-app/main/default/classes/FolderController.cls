public class FolderController{
    @AuraEnabled
    public static Map<String,String> getLibraryNames(String libraryID){ 
    	Map<String,String> tabValues = new Map<String,String>();
        if(String.isNotBlank(libraryID)){
            for(ContentWorkspace content : [SELECT Id, Name FROM ContentWorkspace where Id =:libraryID] ){
                tabValues.put(null+'-'+content.Id,content.Name);
            }
        }
        return tabValues;
    }
    @AuraEnabled
    public static Map<String,String> getFoderNames(String rootID){  
        Set<String> ids = new Set<String>();
        Map<String,String> tabValues = new Map<String,String>();
        if(String.isNotBlank(rootID)){
            List<String> folderIds = new List<String>();
            if(rootID.contains('-')){
                String recentFolderId = rootID.substringAfterLast('-'); 
                String ParentFolderId = rootID.substringBefore(recentFolderId); 
                if(ParentFolderId.contains(recentFolderId)){
                    rootID = rootID.substringBefore(recentFolderId);
                } 
                if(rootID.contains('-')){                
                    ids.addAll(rootID.split('-')); 
                }
                else{
                    ids.add(rootID);
                }
                
            }
            else{
                ids.add(rootID); 
            } 
            Map<Id,ContentFolderItem> content = new Map<Id,ContentFolderItem>([SELECT Id,ParentContentFolderId,Title  FROM ContentFolderItem WHERE Id IN:ids]) ;
            Map<Id,ContentWorkspace> conWorkspace = new Map<Id,ContentWorkspace>([SELECT Id, RootContentFolderId, Name FROM ContentWorkspace where RootContentFolderId IN:ids]);
            String contentId = '';
            for(String newId:ids){
                if(content.size()>0){                    
                    if(String.isNotBlank(contentId)){
                        contentId += '-'+newId;
                    }
                    else{
                        contentId = newId;
                    }
                    boolean flag =false;
                    if((content.get(newId).Title.length() == 15 || content.get(newId).Title.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', content.get(newId).Title)) {
                        flag = true;
                    }
                    if(flag && conWorkspace.containsKey(content.get(newId).Title)){
                        tabValues.put(contentId,conWorkspace.get(content.get(newId).Title).Name);
                    }
                    else{
                        tabValues.put(contentId,content.get(newId).Title);
                    }
                }
            }
            
        } 
        return tabValues;
    }
    @AuraEnabled
    public static List<folderData> getContentDocument(String parentId){
        Set<Id>  ids = new Set<Id>(); 
        if(String.isNotBlank(parentId)){    
            for(ContentDocument cDoc:[SELECT Id FROM ContentDocument WHERE ParentId =:parentId]){
                ids.add(cDoc.Id);
            }
        } 
        return getDocuments(ids,null);
    } 
    @AuraEnabled
    public static List<folderData> recentVideos(){
        List<folderData> fData  = new List<folderData>();
        for(ContentVersion contVersion:[SELECT ContentDocumentId,ContentUrl,Description,FileType,Id,Title,LastModifiedDate  FROM ContentVersion WHERE (IsLatest = true AND FileType ='LINK') AND (ContentUrl like '%youtube%' OR ContentUrl like '%embed%') Order By LastModifiedDate DESC LIMIT 4]){
        	fData.add(new folderData(contVersion.Id,null,contVersion));  
        }
        return fData;
    }
    @AuraEnabled
    public static List<folderData> getFolderData(String parentFolderId){
        List<folderData> fData  = new List<folderData>();
        Map<String,Id> iconIds = new Map<String,Id>();
        Set<Id> docIds = new Set<Id>();
        for(ContentDocument cdoc:[Select Id,Title,LatestPublishedVersionId  From ContentDocument where ParentId =:System.Label.Asset_Library_Id]){
            iconIds.put(cdoc.Title,cdoc.LatestPublishedVersionId);
        }
        if(String.isNotBlank(parentFolderId)){
            for(ContentFolderItem item : [SELECT Id,IsFolder,ParentContentFolderId,Title,FileType  FROM ContentFolderItem WHERE ParentContentFolderId=:parentFolderId Order By Title]){
                if(item.IsFolder && String.isBlank(item.FileType)){
                    if(iconIds.get(item.Title) != null){ 
                        fData.add(new folderData(iconIds.get(item.Title),item,null));
                    }
                    else{ 
                        fData.add(new folderData(iconIds.get('FolderIcon'),item,null));
                    }                
                } 
                else{
                    docIds.add(item.Id);
                }            
            }
            if(docIds.size()>0){
                fData.addAll(getDocuments(docIds,iconIds));
            }
            
        }      
        return fData;  
    }
    
    private static list<folderData> getDocuments(Set<Id> docIds,Map<String,Id> iconIds){ 
        List<folderData> fDocs  = new List<folderData>();
        if(docIds.size()>0){
            for(ContentVersion contVersion:[SELECT ContentDocumentId,ContentUrl,Description,FileType,Id,Title FROM ContentVersion WHERE (ContentDocumentId IN:docIds AND IsLatest =true) Order By LastModifiedDate DESC]){
                if(iconIds != null && iconIds.get(contVersion.Title) != null){
                    fDocs.add(new folderData(iconIds.get(contVersion.Title),null,contVersion));             
                }
                else{
                    fDocs.add(new folderData(contVersion.Id,null,contVersion));             
                }
                
            }
        }
        return fDocs;
    }
    
    
    public class folderData{
        @AuraEnabled public boolean ISfolder{set;get;}
        @AuraEnabled public boolean ISyoutube{set;get;}
        @AuraEnabled public String folderId{set;get;}
        @AuraEnabled public String title{set;get;}
        @AuraEnabled public String folderIconId{set;get;}
        @AuraEnabled public String fileId{set;get;} 
        @AuraEnabled public String fileType{set;get;} 
        @AuraEnabled public String description{set;get;} 
        @AuraEnabled public String contentUrl{set;get;} 
        
        public folderData(String iconId ,ContentFolderItem folderItem,ContentVersion conVersion){
            this.folderIconId = iconId;
            
            if(folderItem != null){
                this.ISfolder=true;
                this.folderId = folderItem.Id;
                this.title = folderItem.Title;           
            }
            if(conVersion != null){ 
                if(conVersion.ContentUrl != null && (conVersion.ContentUrl.contains('youtube') || conVersion.ContentUrl.contains('embed') )){
                    this.ISyoutube = true;
                }            
                this.title = conVersion.Title;      
                this.fileId = conVersion.ContentDocumentId; 
                this.fileType = conVersion.FileType;
                this.description = conVersion.Description;
                this.contentUrl = conVersion.ContentUrl;
            }        
            
        }
    } 
    
}