/*
@Name : TestCustomerSpecificProductController
@Author : customersuccess@cloud62.com
@Date : 07-07-2014
@Description : Test functionality for ProductCompatibilityController class.
*/
@isTest (seeAllData=true)
private class DP_TestCustomerSpecificProductController {
    
    /*
    @Name :testProductCompatibilityCls
    @Description : test functionality for ProductCompatibilityController class.
    */
    static testmethod void testCustomerSpecificProductCls(){
        Pricebook2 pbk1 = [Select Id, Name, IsActive From Pricebook2 where IsStandard = true LIMIT 1];
        Product2 p = getProduct2();
        DP_BillingSystem__c bs = getBillingSystem();
        Account a = getAccount(bs);
        Product2 cprod = getProduct2();
        DP_Product_Compatibility__c pcam = new DP_Product_Compatibility__c(DP_Parent_Product__c=p.ID,DP_Child_Product__c=cprod.ID,
                DP_Base_Quantity__c=10,DP_Increment_Quantity__c=10,DP_Minimum_Quantity__c=10,DP_Maximum_Quantity__c=10);
        insert pcam;
        //start test
        Test.startTest();
        ApexPages.StandardController ctl = new ApexPages.StandardController(p);
        DP_C62CustomerSpecificProductController pc = new DP_C62CustomerSpecificProductController(ctl);
        System.assertEquals(p.DP_CAPEX__c, pc.theNewCSP.DP_CAPEX__c);
        pc.theNewCSP.DP_Account__c = a.id;
        pc.save();
        pc.cancel();
        //stop test
        Test.stopTest();
    }

    /*
    @Name :getProduct2
    @Description : prepare the test data for Account record.
    */
    private static Product2 getProduct2(){
        Product2 p = new Product2(Name='Testing',DP_Product_Type__c = 'Software',
                            DP_Datapipe_Part_Number__c='Testing',DP_CAPEX__c=23, DP_Cost__c = 1, DP_LandedCost__c = 1, DP_Setup__C = 0, DP_Formula_Exempt__c = false, DP_Markup__c = 0,DP_Product_Category__c='Hardware',isactive=true, DP_Max_Discount__c = 0);
        insert p;
        return p;
    }
    
    /*
    @Name :getBillingSystem
    @Description : prepare the test data for DP_BillingSystem__c record.
    */
    private static DP_BillingSystem__c getBillingSystem(){
        DP_BillingSystem__c bs = new DP_BillingSystem__c(Name='Test BS', DP_BillingSystemID__c=12345);
        insert bs;
        return bs;
    }

    /*
    @Name :getAccount
    @Description : prepare the test data for Account record.
    */
    private static Account getAccount(DP_BillingSystem__c bs){
        Account a = new Account(Name='Test',Phone='(456) 238-1212',Website='http://test.com',
                    Industry='Charitable / Non Profit'
                                //,DP_BillingSystem__c=bs.ID commented out - diego castro
                                );
        insert a;
        return a;
    }
    
}