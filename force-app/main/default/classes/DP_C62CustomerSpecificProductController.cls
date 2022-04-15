/*
@Name            : C62CustomerSpecificProductController
@Author          : customersuccess@cloud62.com
@Date            : March 14, 2014
@Description     : 
*/

public with sharing class DP_C62CustomerSpecificProductController {
    public Product2 theProduct {get;set;}
    public DP_Customer_Specific_Product__c theNewCSP {get;set;}


    public DP_C62CustomerSpecificProductController(ApexPages.StandardController controller) {
       this.theProduct = (Product2)controller.getRecord();
       theProduct = [SELECT ID, DP_CAPEX__c, DP_Cost__c, CurrencyIsoCode, DP_LandedCost__c, DP_Max_Discount__c, DP_Setup__c, Name, DP_Formula_Exempt__c, DP_Markup__c, DP_Service_Type__c FROM Product2 WHERE ID = :theProduct.ID];
       theNewCSP = new DP_Customer_Specific_Product__c();
       theNewCSP.DP_Product__c = theProduct.ID;
       theNewCSP.DP_CAPEX__c = theProduct.DP_CAPEX__c;
       theNewCSP.DP_Cost__c = theProduct.DP_Cost__c;
       theNewCSP.CurrencyIsoCode = theProduct.CurrencyIsoCode;
       theNewCSP.DP_LandedCost__c = theProduct.DP_LandedCost__c;
       theNewCSP.DP_Max_Discount__c = theProduct.DP_Max_Discount__c;
       theNewCSP.DP_Setup__c = theProduct.DP_Setup__c;
       theNewCSP.Name = theProduct.Name;
       theNewCSP.DP_Formula_Exempt__c = theProduct.DP_Formula_Exempt__c;
       theNewCSP.DP_Markup__c = theProduct.DP_Markup__c;
       theNewCSP.DP_Service_Type__c = theProduct.DP_Service_Type__c;
    }
    
    public PageReference save(){
        PageReference p = new PageReference('/' + theProduct.ID);
        //set landed cost based on the field set on Product2
        if(theNewCSP.DP_CAPEX__c == 0){
            theNewCSP.DP_LandedCost__c = theNewCSP.DP_Cost__c/(1-theNewCSP.DP_Markup__c);
        } else {
            theNewCSP.DP_LandedCost__c = theNewCSP.DP_CAPEX__c/(1-theNewCSP.DP_Markup__c);
        }
        if(theNewCSP != null && theNewCSP.DP_Account__c != null && theNewCSP.DP_Product__c != null){
            try{
                insert theNewCSP;
            }catch(DMLException dex){
                for (Integer i = 0; i < dex.getNumDml(); i++) {
                    // Process exception here
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: The insert failed due to following reason.'+dex.getDmlMessage(i) +' Please try again or contact your system administrator.'));
                }           
                return null;
            }catch(Exception ex){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: The insert failed due to following reason.'+ex.getMessage() +' Please try again or contact your system administrator.'));
                return null;
            }
        }
        return p;
    }
    
    public PageReference cancel(){
        String reRecordID = '';
        if(theProduct.ID != null){
            reRecordID = theProduct.ID;
        }else{
            reRecordID = '01t/o';
        }
        PageReference p = new PageReference('/' + reRecordID);
        p.setRedirect(true);
        return p;
    }

}