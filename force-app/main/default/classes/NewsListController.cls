public class NewsListController {
    @AuraEnabled
    public static List<NewsContent> dataItems{set;get;}
    @AuraEnabled
    public static List<NewsContent> getNewsList(){
        try{
            dataItems = new List<NewsContent>();
            ContentWorkspace  contentWork = [SELECT ID FROM ContentWorkspace WHERE DeveloperName=:System.Label.News];  
            Set<Id> contDocIds = new Set<Id>();
            Map<String,Id> contDocImgId = new Map<String,Id>();
            for(ContentDocument contentDoc: [SELECT Id,FileType,Title,LatestPublishedVersionId FROM ContentDocument WHERE ParentId =:contentWork.Id]){
                if(contentDoc.FileType == 'LINK'){
                    contDocIds.add(contentDoc.Id);
                }
                else{
                    contDocImgId.put(contentDoc.Title,contentDoc.LatestPublishedVersionId);
                }
            }
            //   Map<Id,ContentVersion> contVersionData = new Map<Id,ContentVersion>([SELECT Id,FileType,Description,Title,Thumbnail_Img_Name__c FROM ContentVersion WHERE ContentDocumentId IN: contDocIds]);
            
            for(ContentVersion contVersion :[SELECT Id,FileType,ContentUrl ,Description,Title,Thumbnail_Img_Name__c FROM ContentVersion WHERE ContentDocumentId IN: contDocIds Order By LastmodifiedDate DESC]){
                if(contVersion.FileType != 'JPG'){                       
                       dataItems.add(new NewsContent(contVersion,contDocImgId.get(contVersion.Thumbnail_Img_Name__c)));                        
                                    
                }
            }
            
            return dataItems;  
        }
        catch(Exception e){
            return null; 
        }
    }
    
    public class NewsContent{
        @AuraEnabled 
        public String thumbnailImg{set;get;}
        @AuraEnabled
        public ContentVersion ContVersion{set;get;}
        public NewsContent(ContentVersion ContVersion,String thumbnailImg){
            this.thumbnailImg = thumbnailImg;
            this.ContVersion = ContVersion;
        } 
    }
}