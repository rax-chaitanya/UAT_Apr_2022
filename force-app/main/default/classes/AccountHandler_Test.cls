@isTest
public class AccountHandler_Test {
    @TestSetUp
    static void setDataUp(){
		List<Trigger_Manager__c> tms = new List<Trigger_Manager__c>();
            tms.add( new Trigger_Manager__c(name='AccountTrigger',Is_Active__c=true));
		insert tms;
        
    }
    
    @isTest static void testAccountHanlder(){
     Id devRecordTypeId3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard Company').getRecordTypeId();
        Account acc = new Account(RecordTypeId =devRecordTypeId3,Name='Test Account1234',BillingCountry='Australia',ShippingCountry='Australia',Partner_Account_Status__c='Approved');
        insert acc;
        
        User u=[Select id from User where id=:Label.FMW_API_User];
		System.runAs(u){  
            Accounts__c acc2 =new Accounts__c(Name = 'testComp', Company_Name__c = acc.Id, Shipping_Country__c = 'United States', 
                        Menu_Pricing_Approved__c = TRUE,DDI__c='1234');
            insert acc2;
            acc2.Shipping_Country__c ='India';
            update acc2;
            delete acc2;
        }
    }

}