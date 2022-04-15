@isTest
public class CreateMilestoneforFinancialforce_Test {
    @testsetup
    public static  void testMethod1(){
        TestDataFactory.getOrgConstants();
        TestDataFactory.triggerManagerFlagValue  = true;
        TestDataFactory.getTriggerManagers();
        Account a = new Account(Is_Created_From_Lead__c=true,Name='Test Account1234',BillingCountry='India',ShippingCountry='India',RecordTypeId =Label.Standard_Company_RecordTypeId);
        insert a;
        Contact c = new Contact(firstname='test', lastname='test1',pse__Salesforce_User__c=userInfo.getUserId());
        insert c;
        Account ac = new Account(Name='Test C Account',Company_Name__c=a.Id,ShippingCountry='India', RecordTypeId =Label.Account_Prospect_RecordType_ID);
        insert ac;
        pse__Region__c region = New pse__Region__c();  
        region.Name = 'North America';
        region.pse__Hierarchy_Depth__c = 0;
        insert region;      
        pse__Proj__c p =new pse__Proj__c(pse__Is_Active__c=true,pse__Account__c= a.Id,Name='Test Pro',pse__region__c=region.id);   
        insert p;
        pse__Vendor_Invoice__c v =new pse__Vendor_Invoice__c(pse__Account__c=a.Id,Project__c=p.Id,amount__c=100,Vendor_Invoice_Name__c='test',pse__Date__c=system.today());
        insert v;
        
        
        
    }
    @isTest private static void senario1(){
        database.executeBatch(new CreateMilestoneforFinancialforce(), 200);
    }
    
}