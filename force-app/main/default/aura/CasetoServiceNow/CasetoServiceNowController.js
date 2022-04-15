({
    MovetoServiceNow : function(component,event,helper) {
        
        var action = component.get("c.GetCaseValues");
        action.setParams({ recordId : component.get("v.recordId") });
        action.setCallback(this, function(response){           
            var state = response.getState();        
            if (state === "SUCCESS") {                   
            var sample = response.getReturnValue();                   
                var urlEvent = $A.get("e.force:navigateToURL");
                //var enc = encodeURI(sample.Link__c);
                //var dec = decodeURI(sample.Link__c);
                var urlAttribute = sample.Federation_ID__c +'&sysparm_quotelink='+ sample.Quote_Link__c +'&sysparm_reqDesc='+sample.Description;
                urlEvent.setParams({
                    "url": 'https://rackspace.service-now.com/rack_sp?id=sc_cat_item&sys_id=4bb14bc2c84f4e0087fd91e81c4cff48&&sysparm_salesrep=' + urlAttribute
                });
                urlEvent.fire();                                                
            }                        
        });
        
        $A.enqueueAction(action);
    }
})