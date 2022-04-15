@istest
public class DDIValidationControllerTest {
    
    @isTest
     static  void method1()
    {
         
     Account a = new Account();
        a.Name='Comp account';
        a.BillingCountry='India';
        a.ShippingCountry='India';
        a.DDI__c='12345678';
        insert a ; 
        
       Account a1 = new Account();
        a1.Name='Comp account1';
        a1.BillingCountry='India';
        a1.ShippingCountry='India';
       	a1.DDI__c='12312323';
        insert a1;
        
       Test.startTest(); 
        Id companyId = [Select Id,Name from Account limit 1 ].Id;
        DDIValidationController.accountDdi(companyId);
      
       Test.stopTest(); 
    }

        
}