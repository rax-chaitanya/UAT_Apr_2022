({
		doInit: function(component, event, helper) {
		   var getUrlsAction = component.get('c.getUrls');
        getUrlsAction.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var returnValue = response.getReturnValue();
                component.set("v.pUser", returnValue.territoryCountry[0]);
                component.set("v.w8urls", 'https://apps.irs.gov/app/picklist/list/formsInstructions.html?value=w-8&criteria=formNumber');
                component.set("v.w9urls", returnValue.W9Urls);
                component.set("v.achurls", returnValue.achUrls);
                component.set("v.supplierUrls", returnValue.supplierUrls);
                console.log("Terri"+component.get("v.pUser.Account.Territory__c"));
                console.log("coun"+component.get("v.pUser.Account.BillingCountry"));
                component.set("v.initSuccess", true);
            }
            else{
                alert(''+response.getReturnValue());
                alert('Something went wrong . Please contact system admin for further details');
            }    
            
        });
        
        $A.enqueueAction(getUrlsAction);
		
	}
})