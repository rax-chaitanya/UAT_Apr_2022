@isTest
public class RequestOpportunityAccessController_Test{
  public static final String teamRole= OpportunityTeamMember.TeamMemberRole.getDescribe().getPicklistValues()[0].getValue();

  @testSetup
  public static void createTestData(){
        TestDataFactory.getOrgConstants(); 
        TestDataFactory.getTriggerManagers();
        TestDataFactory.creteTeamMemberRoles();
        TestDataFactory.createFeatureFlags();
         Id PartnerrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
         Id ProspectrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
         
        Account a = new Account(Name='Test Comp1234',recordTypeId = PartnerrecordTypeId, BillingCountry='India',ShippingCountry='India', phone= '1212121212');
        insert a;
        Contact c = new Contact(firstname='Test Contact',LastName='Test Last',AccountId=a.id);
        insert c;
        Account ac = new Account(Name='Test Account', recordTypeId = ProspectrecordTypeId, Company_Name__c=a.Id, phone= '222222222');
        insert ac;
        Account ac1 = new Account(Name='Test Account', recordTypeId = ProspectrecordTypeId, Company_Name__c=a.Id, phone= '222222222');
        insert ac1;
        Opportunity opty = new Opportunity(Name='Test Opportunity',AccountId=a.Id,Account__c=ac1.id,Skip_validation__c=True,Type='Azure',Why_Did_We_Lose__c = 'Price',Lost_Reason__c='Price',DDI__c='12345655',StageName='Closed Won',CloseDate=System.today().addDays(-15),OwnerId=UserInfo.getUserId(),Access_Request_Status__c ='Pending'); 
        insert opty;         
        Opportunity opty1 = new Opportunity(Name='Test Opport1',Skip_validation__c=False,Type='Azure',Why_Did_We_Lose__c = 'Price',Lost_Reason__c='Price',AccountId=a.Id,Account__c=ac.id,DDI__c='12345655',StageName='Stage 1 - Planning & Identification',CloseDate=System.today().addDays(15),OwnerId=UserInfo.getUserId(),Access_Request_Status__c = 'Pending');
        insert opty1; 
        OpportunityTeamMember otm=new OpportunityTeamMember( Skip_Validation__c = true,OpportunityId = opty.Id,OpportunityAccessLevel = opty.RecordType.Name =='Read only' ? 'Read' : 'Edit',UserId = UserInfo.getUserId(),TeamMemberRole ='TestSolution');
        insert otm;
    
    }
    @isTest
    static void getTeamMemberRolesTest(){
        Opportunity  opty = [SELECT ID,Skip_validation__c,Name,Requester_Team_Role__c,Opportunity_Access_Submitter__c FROM Opportunity WHERE Name='Test Opportunity' LIMIT 1];
         List<RequestOpportunityAccessController.Option> options = RequestOpportunityAccessController.getTeamMemberRoles(opty.Id);  
         System.assertEquals(options!=null, true);      
    }
    //Check Opportunity Owner
    @isTest
    static void checkAccess(){        
        Opportunity  opty = [SELECT ID FROM Opportunity WHERE Name='Test Opportunity' LIMIT 1];   
        RequestOpportunityAccessController.checkAccess(opty.Id); 
    } 
    @isTest
    static void checkAccess1(){
        UserRole SARole = [Select Id,Name from UserRole Where Name LIKE '%RackSpace Corporate%' LIMIT 1];   
        User testUser =new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name ='Rackspace - Standard Support User US' limit 1].Id,
            LastName = 'testSAUser123',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = SARole.Id
        );  
        Opportunity  opty = [SELECT ID,Access_Request_Status__c FROM Opportunity WHERE Name='Test Opportunity' LIMIT 1]; 
                     
        system.runAs(testUser){
            Map<String,Object> result  = RequestOpportunityAccessController.checkAccess(opty.Id); 
            if(result != null && result.get('Action')=='Select Role'){
                RequestOpportunityAccessController.submitForApproval(opty.Id,'Account Manager');
                System.debug('------'+opty);
                 List<RequestOpportunityAccessController.Option> options = RequestOpportunityAccessController.getTeamMemberRoles(opty.Id);  
                 
                 RequestOpportunityAccessController.checkAccess(opty.Id);
            }
        }
        
    }
    
    @isTest
    static void checkCatchBlock(){        
        RequestOpportunityAccessController.checkAccess(null);    
        RequestOpportunityAccessController.submitForApproval(null,null); 
    }
    
    @isTest
    static void checkAccess2(){
          
       // User u = [Select ID from user where Email ='puser000@amamama.com' limit 1];
        UserRole SARole = [Select Id,Name from UserRole Where Name LIKE '%US SA - AWS%' LIMIT 1]; 
        User u =new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name ='Rackspace - Standard Support User US' limit 1].Id,
            LastName = 'testSAUser123',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = SARole.Id
        );  
        insert u;
        Opportunity  opty = [SELECT ID,OwnerId,RecordType.Name FROM Opportunity WHERE Name='Test Opportunity' LIMIT 1];          
        system.runAs(u){       
        RequestOpportunityAccessController.checkAccess(opty.Id); 
        }
        
    }
    
    @isTest
    static void checkAccess3(){
        UserRole SARole = [Select Id,Name from UserRole Where Name LIKE '%EMEA Portfolio Architect - ACQ%' LIMIT 1];   
        User testUser =new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name ='Rackspace - Standard Support User US' limit 1].Id,
            LastName = 'testSAUser123',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = SARole.Id
        );  
        Opportunity  opty = [SELECT ID FROM Opportunity WHERE Name='Test Opportunity' LIMIT 1];                
        system.runAs(testUser){
            Map<String,Object> result  = RequestOpportunityAccessController.checkAccess(opty.Id); 
            if(result != null && result.get('Action')=='Select Role'){
                RequestOpportunityAccessController.submitForApproval(opty.Id,'Account Manager');
            }
        }
        
    }
     @isTest
    static void checkAccess4(){
        UserRole SARole = [Select Id,Name from UserRole Where Name LIKE '%RackSpace Corporate%' LIMIT 1];   
        User testUser =new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name ='Rackspace - Standard Support User US' limit 1].Id,
            LastName = 'testSAUser123',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = SARole.Id
        );  
        Opportunity  opty = [SELECT ID,Access_Request_Status__c FROM Opportunity WHERE Name='Test Opportunity' LIMIT 1]; 
                    
        system.runAs(testUser){
            Map<String,Object> result  = RequestOpportunityAccessController.checkAccess(opty.Id); 
            if(result != null && result.get('Action')=='Select Role'){
                RequestOpportunityAccessController.submitForApproval(opty.Id,'Account Manager');
                
            }
        }
        
    } 
   
     @isTest
    static void checkAccess5(){
    Opportunity  opty = [SELECT ID,OwnerId,RecordType.Name,Access_Request_Status__c FROM Opportunity WHERE Name='Test Opportunity' LIMIT 1];   
    opty.Access_Request_Status__c = 'Approved';
    opty.Opportunity_Access_Submitter__c = Userinfo.getUserId();
    update opty;
        RequestOpportunityAccessController.createOpportunityTeamMember();
    }   
    @isTest
    static void checkAccess6(){
        UserRole SARole = [Select Id,Name from UserRole Where Name LIKE '%US Sub-Segment - Tech Sales%' LIMIT 1];   
        User testUser =new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name ='Rackspace - Standard Support User US' limit 1].Id,
            LastName = 'testSAUser123',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = SARole.Id
        );  
        Opportunity  opty = [SELECT ID,Access_Request_Status__c FROM Opportunity WHERE Name='Test Opport1' LIMIT 1]; 
                     
        system.runAs(testUser){
            Map<String,Object> result  = RequestOpportunityAccessController.checkAccess(opty.Id); 
            RequestOpportunityAccessController.submitForApproval(opty.Id,'Account Manager');
        }
        
    }
    @isTest
    static void checkAccess7(){
        UserRole SARole = [Select Id,Name from UserRole Where Name LIKE '%Hong Kong Sales Engineer%' LIMIT 1];   
        User testUser =new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name ='Rackspace - Standard Support User US' limit 1].Id,
            LastName = 'testSAUser123',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = SARole.Id
        );  
        Opportunity  opty = [SELECT ID,Access_Request_Status__c FROM Opportunity WHERE Name='Test Opport1' LIMIT 1]; 
                     
        system.runAs(testUser){
            Map<String,Object> result  = RequestOpportunityAccessController.checkAccess(opty.Id); 
            RequestOpportunityAccessController.submitForApproval(opty.Id,'Account Manager');
        }
        
    }
}