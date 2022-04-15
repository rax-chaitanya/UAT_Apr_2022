@isTest
Public class TaskHandler_test{
    @TestSetUp
    static void setDataUp(){
        TestClassUtility.setTestSetupData();
           List<FieldMapping__c> fieldMappings = new List<FieldMapping__c>();
             fieldMappings.add(new FieldMapping__c(Name = 'Territory-Company', CompName__c = 'Account', SourceField__c = 'BillingCountry', TargetField__c = 'Territory__c'));
             fieldMappings.add(new FieldMapping__c(Name = 'Territory-Contact', CompName__c = 'Contact', SourceField__c = 'MailingCountry', TargetField__c = 'Territory__c'));
             fieldMappings.add(new FieldMapping__c(Name = 'Territory-Lead', CompName__c = 'Lead', SourceField__c = 'Country', TargetField__c = 'Territory__c'));
             insert fieldMappings;
     
        Account acc = new Account(Name = 'Test Acc', BillingCountry = 'United States', ShippingCountry = 'United States', Is_Created_From_Lead__c = true);
        Insert acc;
        
        Contact con = new Contact(FirstName = 'Rackspace', LastName = 'Test Contact', AccountId = acc.id);
        Insert con;  
        
        Opportunity opp = new Opportunity(Name = 'Test opp', Type = 'Azure',
        closedate=date.today(),accountId=acc.Id,Focus_Area__c = 'Amazon', StageName = 'Stage 1 - Planning & Identification');
        Insert opp;
        
        OpportunityContactRole oppCont = new OpportunityContactRole(ContactId = con.id, OpportunityId = opp.id, IsPrimary = true);
        Insert oppCont;
    }
    
    static testmethod void TaskHandlerTest1(){
        Account acc = [SELECT id FROM Account WHERE Name = 'Test Acc' and recordtype.DeveloperName = 'Standard_Company'];
        Contact con  = [SELECT id FROM Contact WHERE AccountId =: acc.id];
        
        Task ts = new Task(Subject='Test Task', Status='New', Priority='Normal', CallType='Outbound', Whatid= acc.id, Whoid= con.id);
        Insert ts;        
        Update ts;        
        Delete ts;
        
        TaskHandler tsh = new TaskHandler();
        tsh.afterUndelete();
    }
    
    static testmethod void TaskHandlerTest2(){
        Account acc = [SELECT id FROM Account WHERE Name = 'Test Acc' and recordtype.DeveloperName = 'Standard_Company'];
        Contact con  = [SELECT id FROM Contact WHERE AccountId =: acc.id];
        User usr = [SELECT id FROM User WHERE id=: Label.FMWFoundationUser];
        System.runAs(usr){
            Task ts = new Task(Subject='Test Task', Status='New', Priority='Normal', CallType='Outbound', Whatid= acc.id, Whoid= con.id);
            Insert ts;        
            Update ts;
        }
    }
    
    static testmethod void TaskHandlerTest3()
    {
        Contact con = [select id from contact where FirstName='Rackspace'];
    Opportunity opp = [select id from Opportunity where Name = 'Test opp'];
    
    OpportunityContactRole oppContact = [select contactId, OpportunityId from OpportunityContactRole where OpportunityId =: opp.Id and IsPrimary =true];
    
     Task ts = new Task(Subject='Test Task', Status='New', Priority='Normal', CallType='Outbound', Whatid= opp.id);
     Insert ts;
    }
}