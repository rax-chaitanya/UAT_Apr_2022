/*
@Name            : ProductCompatibilityController
@Author          : customersuccess@cloud62.com
@Date            : July 16, 2013
@Description     : 
*/
public class DP_ProductCompatibilityController{
    public Product2 prod{get;set;}
    public Product2 chProd{get;set;}
    public Integer noOfRecords{get; set;}
    public Integer size{get;set;}
    public DP_Product_Compatibility__c prodCamp{get;set;}
    public DP_Product_Compatibility__c editProdCamp{get;set;}
    
    /*
    @Name   :ProductCompatibilityController
    @Description :Constructor
    */
    public DP_ProductCompatibilityController(ApexPages.StandardController controller) {
        this.prod = (Product2)controller.getRecord();
      /*  if(prod.ID != null){
            prod = [Select Id,Name,DP_Asset_Type__c,ProductCode,DP_Service_Type__c,Description,IsActive,Family,DP_kW__c,DP_Cost__c,DP_Availability__c,CurrencyIsoCode, 
                    DP_Formula_Exempt__c,DP_Markup__c,DP_Max_Discount__c,DP_Manufacturer_Part_Number__c,DP_Formatted_Quantity__c,DP_Ext_Id__c, 
                    DP_Formatted_Quantity_Descriptor__c,DP_Data_Center__c,DP_Procurement_Profit__c,DP_Datapipe_Part_Number__c,DP_Setup__c, 
                    DP_Product_Category__c,DP_Product_Type__c,DP_CAPEX__c,DP_LandedCost__c,DP_Account__c,DP_Overage_Unit_Price__c, DP_Unit_Of_Measure__c,FocusArea__c
                    FROM Product2 WHERE ID=: prod.ID LIMIT 1];
        }*/
        chProd = new Product2();
        prodCamp = new DP_Product_Compatibility__c();
    }
    
    /*
    @Name   :saveProd
    @Description : upsert Product2 record.
    */
    public PageReference saveProd(){
        if(prod != null){
            try{
                upsert prod;
            }catch(DMLException dex){
                for (Integer i = 0; i < dex.getNumDml(); i++) {
                    // Process exception here
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: The insert/update is failed due to following reason.'+dex.getDmlMessage(i) +' Please try again or contact your system administrator.'));
                }           
                return null;
            }catch(Exception ex){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: The insert/update is failed due to following reason.'+ex.getMessage() +' Please try again or contact your system administrator.'));
                return null;
            }
        }
        getProductCompatibility();
        return null;
    }
    
    /*
    @Name   :setCon
    @Description :Get the DP_Product_Compatibility__c List
    */
    public ApexPages.StandardSetController setCon {
        get{
            if(setCon == null){
                size = 20;
                string queryString = 'Select Id, Name, DP_Allow_Multiple_Instances__c, DP_Base_Quantity__c, ' +
                                     'DP_Child_Product__c, DP_Child_Product__r.Name, DP_Product_Type__c, DP_Increment_Quantity__c, ' + 
                                     'DP_Maximum_Quantity__c, DP_Minimum_Quantity__c, DP_Parent_Product__c FROM DP_Product_Compatibility__c' +
                                     ' WHERE DP_Parent_Product__c =\''+prod.ID+'\'';
                if(chProd.DP_Product_Type__c !=null && chProd.DP_Product_Type__c != ''){
                    queryString = queryString + 'AND DP_Product_Type__c =\''+chProd.DP_Product_Type__c+'\'';
                }
                if(chProd.DP_Datapipe_Part_Number__c !=null && chProd.DP_Datapipe_Part_Number__c != ''){
                    queryString = queryString + 'AND DP_Child_Product__r.DP_Datapipe_Part_Number__c =\''+chProd.DP_Datapipe_Part_Number__c+'\'';
                }
                
                queryString = queryString + ' order by Name';
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize();
            }
            return setCon;
        }set;
    }
    
    /*
    @Name   :getProductCompatibility
    @Description : get Product Compatibility record List
    */
    public List<DP_Product_Compatibility__c> getProductCompatibility(){
        List<DP_Product_Compatibility__c> pcList = new List<DP_Product_Compatibility__c>();
        if(prod.ID != null){
            for(DP_Product_Compatibility__c pc : (List<DP_Product_Compatibility__c>)setCon.getRecords()){
                pcList.add(pc);
            }
        }
        return pcList;
    }
    
    /*
    @Name   :refresh
    @Description : refresh Product Compatibility list
    */
    public pageReference refresh() {
        setCon = null;
        getProductCompatibility();
        setCon.setPageNumber(1);
        return null;
    }
        
    /*
    @Name   :addProdCompatibility
    @Description : Insert Product Compatibility record
    */
    public PageReference addProdCompatibility(){
        if(prodCamp != null && prod.ID != null){
            prodCamp.DP_Parent_Product__c = prod.ID;
            if(prodCamp.DP_Child_Product__c != null){
               List<Product2> prod2 = [SELECT Id,DP_Product_Category__c, DP_Product_Type__c FROM Product2 WHERE Id=:prodCamp.DP_Child_Product__c];
               if(prod2.size()>0 && prod2[0].DP_Product_Type__c != null && prod2[0].DP_Product_Type__c != ''){
                   prodCamp.DP_Product_Type__c = prod2[0].DP_Product_Type__c;
               }
            }
            try{
                insert prodCamp;
            }catch(DMLException dex){
                for (Integer i = 0; i < dex.getNumDml(); i++) {
                    // Process exception here
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: The insert/update is failed due to following reason.'+dex.getDmlMessage(i) +' Please try again or contact your system administrator.'));
                }           
                return null;
            }catch(Exception ex){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: The insert/update is failed due to following reason.'+ex.getMessage() +' Please try again or contact your system administrator.'));
                return null;
            }
        }
        prodCamp = new DP_Product_Compatibility__c();
        refresh();
        return null;
    }
    
    
    /*
    @Name   :cancel
    @Description : redirect to product2 or product2 home page
    */
    public PageReference cancel(){
        String reRecordID = '';
        if(prod.ID != null){
            reRecordID = prod.ID;
        }else{
            reRecordID = '01t/o';
        }
        PageReference p = new PageReference('/' + reRecordID);
        p.setRedirect(true);
        return p;
    }
    
    /*
    @Name   :del
    @Description :delete the selected record
    */
    public PageReference del() {
        try {
            String delid = ApexPages.currentPage().getParameters().get('delid');
            DP_Product_Compatibility__c prodCampDel = [SELECT Id FROM DP_Product_Compatibility__c WHERE ID=:delid];
            DELETE prodCampDel;
            refresh();
        } catch (Exception e) {
            ApexPages.addMessages(e);
        }
        return null;
    }
    
    /*
    @Name   :editProdCompatibility
    @Description :get the edited product compatibility record
    */
    public PageReference editProdCompatibility() {
        String editid = ApexPages.currentPage().getParameters().get('editid');
        editProdCamp = [SELECT Id, Name, DP_Allow_Multiple_Instances__c, DP_Base_Quantity__c, DP_Child_Product__c, 
                        DP_Child_Product__r.Name, DP_Product_Type__c, DP_Increment_Quantity__c, DP_Maximum_Quantity__c, 
                        DP_Minimum_Quantity__c, DP_Parent_Product__c
                        FROM DP_Product_Compatibility__c WHERE id=:editid];
        return null;
    }
    
    /*
    @Name   :cancelEdit
    @Description :nullify the editProdCamp object
    */
    public PageReference cancelEdit() {
        editProdCamp = null;
        return null;
    }
    
    /*
    @Name   :saveEdit
    @Description :update the edit record
    */
    public PageReference saveEdit() {
        try {
            UPDATE editProdCamp;
            refresh();
            editProdCamp = null;
        } catch (Exception e) {
            ApexPages.addMessages(e);
        }
        return null;
    }
    
}