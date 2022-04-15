({
	 getCompanyInfo : function(component,event,helper) {
        var action = component.get("c.getCompanyProfile");
        action.setCallback(this,function(response){
            
            var retval = response.getReturnValue();
            component.set("v.PartnerCompany",retval);
             component.set("v.chk2",retval.Membership__c);
        });
        $A.enqueueAction(action);
    },
    checkPrimary : function(component,event,helper) {
        var action = component.get("c.checkPrimary");
        action.setCallback(this,function(response){
            var retval = response.getReturnValue();
            component.set("v.isPrimary",retval);
        });
        $A.enqueueAction(action);
         
    },
    getPickListValues : function(component,event,helper) {
        var action = component.get("c.getPickListValuesIntoList"); 
       
        action.setParams({
            objectType: 'Account',
            country:'BillingCountryCode',
            partnerSolution: 'Partner_Solution__c',
            partnerProduct: 'Partner_Product__c',
            industry:'Industry',
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
           
            component.set("v.countryValues", result.pCountry); 
            component.set("v.solutionValues", result.pSolution); 
            component.set("v.industryValues", result.pIndustry); 
            component.set("v.productValues", result.pProduct); 
           
            
        });
        $A.enqueueAction(action);         
    },


})