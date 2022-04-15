@istest
public class ATMHandler_Test
{   
     @testSetup static void setupTestData() {
        insertTriggerSettings();        
        
    }
    
    Public static void insertTriggerSettings() {
        List<Trigger_Manager__c> triggerSettings = new List<Trigger_Manager__c>();
        triggerSettings.add(new Trigger_Manager__c(Name = 'ATMTrigger', Is_Active__c = true));
        insert triggerSettings;
    }
    
    @isTest static void ATMTestHelper(){    
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId(); 
        Account comp = new Account(Name = 'test', BillingCountry = 'Canada', ShippingCountry = 'Canada');
        insert comp;
        Account acc = new Account(Name = 'test',ShippingCountry='India', Company_Name__c = comp.Id, RecordTypeId = rtId);
        insert acc;
        
        AccountTeamMember atm = new AccountTeamMember(AccountId=comp.Id,
                                                           UserId = Userinfo.getUserId(),
                                                           OpportunityAccessLevel='Edit',
                                                           contactaccesslevel='Edit',
                                                           accountaccesslevel='Edit',
                                                           caseaccesslevel='Edit',
                                                           TeamMemberRole='Additional Sales Rep');
       insert atm;   
       
       CheckATMRecursion.run = true;
       
       atm.TeamMemberRole='Account Executive';
       update atm;      
       
       CheckATMRecursion.run = false;
              
       ATMHandler atmh = new ATMHandler();
       atmh.beforeDelete();                                           
       atmh.afterDelete();                                           
       atmh.afterUndelete();                                           
    }                

    @isTest static void ATMNegTest(){        
        CheckATMRecursion.run = false;
        CheckATMRecursion.runOnce();
        ATMHandler atmh = new ATMHandler();
        atmh.isActive();
    }
    
}