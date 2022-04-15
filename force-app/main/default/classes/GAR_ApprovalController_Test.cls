@isTest
public class GAR_ApprovalController_Test{
    @testSetup
    public static void testSetup(){
       // UserRole SARole = [Select Id,Name from UserRole Where Name LIKE '%US Commercial SMB - ATX 1%' LIMIT 1];
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' limit 1];
        user adminUser = new User(
            ProfileId = adminProfile.Id,
            LastName = 'testAdminUser123',
            Email = 'puser000@amamama.com',
            Username = 'adminuser@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
           // UserRoleId = SARole.Id,
            Region__c = 'US',
            Group__c = 'US Other'
        );
        Insert adminUser;
        
        User testOwner1 = new User(
            ProfileId = adminProfile.Id,
            LastName = 'testOwner1',
            Email = 'puser000@amamama.com',
            Username = 'testowner1@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
          //  UserRoleId = SARole.Id,
            ManagerId = adminUser.Id,
            Group__c = 'US Other',
            Region__c = 'US'
        );
        User testOwner2 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            LastName = 'testOwner2',
            Email = 'puser000@amamama.com',
            Username = 'testowner2@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
           // UserRoleId = SARole.Id,
            ManagerId = adminUser.Id,
            Group__c = 'US Other',
            Region__c = 'US'
        );
        Insert new List<User>{testOwner1, testOwner2};
        
        //Account company;
        System.runAs(adminUser){
            TestDataFactory.getOrgConstants();
            
            TestDataFactory.triggerManagerFlagValue  = false;
            List<Trigger_Manager__c> triggerManagers = TestDataFactory.getTriggerManagers();
            
            
           Account company = new Account(Name = 'Test Account 1',BillingCountry = 'Canada', ShippingCountry = 'Canada', RecordTypeId = Label.Standard_Company_RecordTypeId);
        insert company;
        Account account = new Account(Name = 'TestAccount111', Company_Name__c = company.Id, BillingCountry = 'Canada', ShippingCountry = 'Canada', RecordTypeId = Label.Account_Prospect_RecordType_ID);
        insert account;
            
        }
    }
    
    @isTest
    public static void testMethod1(){
        User adminUser = [SELECT Id, Name FROM User WHERE LastName = 'testAdminUser123' AND IsActive = true limit 1];
        User testOwner1 = [SELECT Id, Name FROM User WHERE LastName = 'testOwner1' AND IsActive = true limit 1];
        User testOwner2 = [SELECT Id, Name FROM User WHERE LastName = 'testOwner2' AND IsActive = true limit 1];
        Account account = [SELECT Id, Name FROM Account WHERE Name = 'TestAccount111' LIMIT 1];
        System.runAs(adminUser){
            List<Realignment_Request_Item__c> requestItems = new List<Realignment_Request_Item__c>();
            requestItems.add(new Realignment_Request_Item__c(
                Account__c = account.Id,
                Move_Date__c = System.today(),
                New_Account_Owner__c = testOwner2.Id,
                Previous_Account_Owner__c = testOwner1.Id,
                Request_Status__c = 'New',
                Reason_for_Move__c = 'New Rep'
            ));
            AccountRealignmentUtility.process(requestItems);
            Account_Realignment_Request__c request = [SELECT Id, 
                                                  Name, 
                                                  Approver__c, 
                                                  Status__c,
                                                  Approver_Type__c,
                                                  (SELECT Id, 
                                                   Name, 
                                                   Account__c, 
                                                   Account__r.Name, 
                                                   Submitter__c, 
                                                   Submitted_date__c, 
                                                   Previous_Account_Owner__c, 
                                                   Previous_Account_Owner__r.Name, 
                                                   Previous_Account_Owner__r.UserRole.Name, 
                                                   Previous_Account_Owner__r.IsActive, 
                                                   New_Account_Owner__c, 
                                                   New_Account_Owner__r.Name, 
                                                   New_Account_Owner__r.UserRole.Name, 
                                                   New_Account_Owner__r.IsActive, 
                                                   Request_Status__c, 
                                                   Approver_Comments__c, 
                                                   Move_Date__c, 
                                                   Account_Number__c, 
                                                   Reason_for_Move__c 
                                                   FROM Realignment_Request_Items__r) 
                                                  FROM Account_Realignment_Request__c LIMIT 1];
            
            GAR_ApprovalController.validateAndLoadRecord(request.Id);
            
            request.Status__c = 'New';
            Update request;
            GAR_ApprovalController.validateAndLoadRecord(request.Id);
            
            request.Approver__c = testOwner1.Id;
            request.Approver_Type__c = 'Manager';
            Update request;
            
            AccountRealignmentUtility.invokeApprovalProcess(new List<sObject>{request});
            try{
                GAR_ApprovalController.processApproval('Approve', request, request.Realignment_Request_Items__r, 'Approved');
            }catch(Exception e){}
            
            request.Approver__c = testOwner1.Id;
            request.Approver_Type__c = 'Business Manager';
            Update request;
            
            AccountRealignmentUtility.invokeApprovalProcess(new List<sObject>{request});
            try{
                GAR_ApprovalController.processDML('Approve', request, request.Realignment_Request_Items__r, 'Approved');
            }catch(Exception e){}
            try{
                GAR_ApprovalController.processApproval('Approve', request, request.Realignment_Request_Items__r, 'Approved');
            }catch(Exception e){}
        }
        
    }
}