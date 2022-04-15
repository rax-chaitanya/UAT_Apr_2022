({
	doInit : function(component, event, helper) {
		//invokingand getting data from  getLeadData method
		//alert('From Lead companyid=='+component.get("v.companyid"));            
        if(!$A.util.isUndefinedOrNull(component.get("v.companyid"))){
            var compId = component.get("v.companyid");
            var action = component.get("c.getLeadData");
            action.setParams({
                "companyid":compId
            });
            action.setCallback(this, function(response) {
                if(!$A.util.isUndefinedOrNull(response.getReturnValue())){
                    var result = response.getReturnValue();
                    console.log('result-----'+JSON.stringify(result));
                    if(!$A.util.isUndefinedOrNull(result.LeadsCreated)){
                        component.set("v.LeadsCreatedW", result.LeadsCreated);              	
                    }else{
                        component.set("v.LeadsCreatedW", 0);              	
                    }
                    if(!$A.util.isUndefinedOrNull(result.LeadsConverted)){
                        component.set("v.LeadsConvertedW", result.LeadsConverted);
                    }else{
                        component.set("v.LeadsConvertedW", 0);
                    }   
                }                          	
                //console.log('LeadsCreated-----'+JSON.stringify(component.get("v.LeadsCreatedW"))+','+JSON.stringify(component.get("v.LeadsConvertedW")));
            })
            $A.enqueueAction(action);
        }        
	}
})