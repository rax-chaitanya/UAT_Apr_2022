@isTest
public class ProjectViewRedirectController_Test {

    @isTest static void redirectTest(){
        Id recId= [Select id from RecordType where sobjectType='Project__c' and Name='EMEA ProServices' limit 1].id;
        Apexpages.currentPage().getParameters().put('RecordType',recId);
        
        Project__c p = new Project__c(Project_Name__c='Test Account',Close_Date__c = system.today()+2,RecordTypeId = recId,Milestone_Due_Date__c = System.today());
        insert p;
        ApexPages.StandardController sc = new ApexPages.StandardController(p);
        ProjectViewRedirectController pvrc = new ProjectViewRedirectController(sc);
        System.assert(pvrc.redirectViewPage() != null);
    }
    
    @isTest static void redirectTest1(){
        Id recId= [Select id from RecordType where sobjectType='Project__c' and Name='Professional Services' limit 1].id;
        Apexpages.currentPage().getParameters().put('RecordType',recId);
        
        Project__c p = new Project__c(Project_Name__c='Test Account',Close_Date__c = system.today()+2,RecordTypeId = recId,Milestone_Due_Date__c = System.today());
        insert p;
        ApexPages.StandardController sc = new ApexPages.StandardController(p);
        ProjectViewRedirectController pvrc = new ProjectViewRedirectController(sc);
        System.assert(pvrc.redirectViewPage() != null);
    }
}