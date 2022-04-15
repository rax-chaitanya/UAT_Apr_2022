public with sharing class ProjectViewRedirectController 
{
    public Project__c proj;
    
    public ProjectViewRedirectController(ApexPages.StandardController controller){
        proj = (Project__c)controller.getRecord();
    }
    
    public pageReference redirectViewPage(){
        String rTypeName = [Select id, Name from RecordType WHERE Id=:proj.RecordTypeId].Name;  
        if(rTypeName == Label.ProjectRecordTypeEMEAProServces)
        {
            PageReference CustomViewPage = new PageReference('/apex/ProjectEMEAProServView').setRedirect(true);
            CustomViewPage.getParameters().put('id', proj.Id);
            return CustomViewPage;
        }
        PageReference StandardPage = new PageReference('/' +proj.Id).setRedirect(true);
        StandardPage.getParameters().put('nooverride', '1');
        return StandardPage;
        
        
    }
}