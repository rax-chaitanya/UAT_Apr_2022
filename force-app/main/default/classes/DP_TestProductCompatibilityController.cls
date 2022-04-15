/*
@Name : TestDP_ProductCompatibilityController
@Author : customersuccess@cloud62.com
@Date : 07-19-2013
@Description : Test functionality for DP_ProductCompatibilityController class.
*/
@isTest (seeAllData=true)
private class DP_TestProductCompatibilityController {
    
    /*
    @Name :testDP_ProductCompatibilityCls
    @Description : test functionality for DP_ProductCompatibilityController class.
    */
    static testmethod void DP_testProductCompatibilityCls(){
        Pricebook2 pbk1 = [Select Id, Name, IsActive From Pricebook2 where IsStandard = true LIMIT 1];
        Product2 p = getProduct2();
        Product2 cprod = getProduct2();
        DP_Product_Compatibility__c pcam = new DP_Product_Compatibility__c(DP_Parent_Product__c=p.ID,DP_Child_Product__c=cprod.ID,
                DP_Base_Quantity__c=10,DP_Increment_Quantity__c=10,DP_Minimum_Quantity__c=10,DP_Maximum_Quantity__c=10);
        insert pcam;
        //start test
        Test.startTest();
        ApexPages.StandardController ctl = new ApexPages.StandardController(p);
        DP_ProductCompatibilityController pc = new DP_ProductCompatibilityController(ctl);
        pc.prod.DP_Markup__c=0.25;
        pc.prod.DP_Max_Discount__c=0.25;
        pc.saveProd();
        ApexPages.currentPage().getParameters().put('editid', pcam.id);
        pc.editProdCompatibility();
        pc.editProdCamp.DP_Base_Quantity__c=200;
        pc.saveEdit();
        System.assertEquals(200, [Select DP_Base_Quantity__c FROM DP_Product_Compatibility__c WHERE ID=:pcam.id][0].DP_Base_Quantity__c);
        pc.cancelEdit();
        ApexPages.currentPage().getParameters().put('delid', pcam.id);
        pc.del();
        //validate if pc rec is deleted.
        System.assertEquals(0, [SELECT Count() FROM DP_Product_Compatibility__c where ID=:pcam.id]);
        pc.prodCamp.DP_Child_Product__c = cprod.ID;
        pc.prodCamp.DP_Base_Quantity__c=10;
        pc.prodCamp.DP_Increment_Quantity__c=10;
        pc.prodCamp.DP_Minimum_Quantity__c=10;
        pc.prodCamp.DP_Maximum_Quantity__c=10;
        pc.addProdCompatibility();
        //validate if pc rec is added
        pc.chProd.DP_Product_Type__c = 'Software';
        pc.chProd.DP_Datapipe_Part_Number__c='Testing';
        pc.refresh();
        pc.cancel();
        //stop test
        Test.stopTest();
    }
    
    /*
    @Name :DP_testProductCompatibility
    @Description : test functionality for ProductCompatibilityController class.
    */
    static testmethod void DP_testProductCompatibility(){
        Pricebook2 pbk1 = [Select Id, Name, IsActive From Pricebook2 where IsStandard = true LIMIT 1];
        Product2 p = getProduct2();
        Product2 cprod = getProduct2();
        DP_Product_Compatibility__c pcam = new DP_Product_Compatibility__c(DP_Parent_Product__c=p.ID,DP_Child_Product__c=cprod.ID,
                DP_Base_Quantity__c=10,DP_Increment_Quantity__c=10,DP_Minimum_Quantity__c=10,DP_Maximum_Quantity__c=10);
        insert pcam;
        //start test
        Test.startTest();
        ApexPages.StandardController ctl = new ApexPages.StandardController(p);
        DP_ProductCompatibilityController pc = new DP_ProductCompatibilityController(ctl);
        pc.saveProd();
        ApexPages.currentPage().getParameters().put('editid', pcam.id);
        pc.editProdCompatibility();
        pc.editProdCamp.DP_Base_Quantity__c=200;
        pc.saveEdit();
        System.assertEquals(200, [Select DP_Base_Quantity__c FROM DP_Product_Compatibility__c WHERE ID=:pcam.id][0].DP_Base_Quantity__c);
        pc.addProdCompatibility();
        ApexPages.currentPage().getParameters().put('delid', '000000');
        pc.del();
        pc.saveEdit();
        //stop test
        Test.stopTest();
    }
    
    /*
    @Name :getProduct2
    @Description : prepare the test data for Account record.
    */
    private static Product2 getProduct2(){
        Product2 p = new Product2(Name='Testing',DP_Product_Type__c = 'Software',   FocusArea__c='DataPipe',
                            DP_Datapipe_Part_Number__c='Testing',DP_CAPEX__c=23,DP_Product_Category__c='Hardware', DP_MAX_Discount__C = 0);
        insert p;
        return p;
    }
}