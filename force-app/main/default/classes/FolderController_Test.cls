@isTest(seeAlldata=true)
public class FolderController_Test{
    @isTest
    public static void libraryContentTest(){
        ContentWorkspace cWork = [SELECT Id, Name, Description,WorkspaceImageId,RootContentFolderId  FROM ContentWorkspace where RootContentFolderId != null AND Name !='Asset Library' limit 1]; 
        FolderController.getContentDocument(cWork.Id);
        FolderController.getLibraryNames(cWork.Id);
        FolderController.getFoderNames(cWork.RootContentFolderId);
        FolderController.getFolderData(cWork.RootContentFolderId);
        FolderController.recentVideos();
        
    }
    @isTest
    public static void libraryContentTest1(){
        Set<Id> ids = new Set<Id>();
        for(ContentWorkspace cwork :[SELECT Id, Name, Description,WorkspaceImageId,RootContentFolderId  FROM ContentWorkspace where Name !='Asset Library']){
            if(cwork.RootContentFolderId != null){
                ids.add(cwork.RootContentFolderId);
            }
        }
        if(ids.size()>0){
            ContentFolderItem  content = [SELECT Id,ParentContentFolderId,Title  FROM ContentFolderItem WHERE  ParentContentFolderId IN:ids Limit 1];
            FolderController.getFoderNames(content.ParentContentFolderId+'-'+content.Id);
        }
        
    }
    
}