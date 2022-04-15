@isTest
public class ProjectViewController_Test {

    @isTest static void redirectTest(){
          Project__c p = new Project__c(Project_Name__c='Test Account',Proposal_Stage__c = 'Pre Qualify',Milestone_Due_Date__c = System.today());
        ApexPages.StandardController sc = new ApexPages.StandardController(p);
        ProjectViewController pvc = new ProjectViewController(sc);
        System.assert(pvc.edit() != null);
        System.assert(pvc.cancel() != null);
    }
}