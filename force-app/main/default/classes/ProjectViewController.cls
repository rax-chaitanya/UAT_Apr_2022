public with sharing class ProjectViewController
{
    Private Project__C proj;
    
    public ProjectViewController(ApexPages.StandardController controller){
        this.proj = (Project__C)controller.getRecord();
    }
    
    public pageReference Edit(){
        PageReference CustomEditPage = new PageReference('/apex/ProjectEMEAProServEditOnly').setRedirect(true);
        CustomEditPage.getParameters().put('id',proj.Id);
        return CustomEditPage;
    }
    
    public pageReference Cancel(){
        return  new pageReference(Label.ProjectListViewURL).setRedirect(true);
    }
    
}