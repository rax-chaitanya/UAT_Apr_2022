@isTest
public class ProjectCreateRedirectController_Test {
    
    
    @isTest
    static void selectRecordType(){
        Id recId= [Select id from RecordType where sobjectType='Project__c' and Name='EMEA ProServices' limit 1].id;
        Apexpages.currentPage().getParameters().put('RecordType',recId);
        
        Project__c p = new Project__c(Project_Name__c='Test Account');
        ApexPages.StandardController sc = new ApexPages.StandardController(p);
        ProjectCreateRedirectController con = new ProjectCreateRedirectController(sc);
        PageReference pr =  con.redirectPage();
        System.assert(pr != null);
        
    }
    
    @isTest
    static void selectRecordType1(){
        Id recId= [Select id from RecordType where sobjectType='Project__c' and Name='Professional Services' limit 1].id;
        Apexpages.currentPage().getParameters().put('RecordType',recId);
        
        Project__c p = new Project__c(Project_Name__c='Test Account');
        ApexPages.StandardController sc = new ApexPages.StandardController(p);
        ProjectCreateRedirectController con = new ProjectCreateRedirectController(sc);
        PageReference pr =  con.redirectPage();
        System.assert(pr != null);
        
    }
    
    @isTest static void testAsDefault(){
        String pId=[select id,name from Profile where name='Rackspace ProServ - INTL' limit 1].id;
        User conuser = new User(firstname='Connection',Alias = 'standt', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Connection', 
                                LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = pId,TimeZoneSidKey='America/Los_Angeles', UserName='connection@rackspace.com');
        
        
        insert conuser;
        
        System.runAs(conuser){
            Project__c p = new Project__c(Project_Name__c='Test Account');
            ApexPages.StandardController sc = new ApexPages.StandardController(p);
            ProjectCreateRedirectController con = new ProjectCreateRedirectController(sc);
            PageReference pr =  con.redirectPage();
            System.assert(pr != null);
        }
    }
}