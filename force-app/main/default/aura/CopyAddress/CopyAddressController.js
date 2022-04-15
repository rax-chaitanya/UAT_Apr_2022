({        
	addressupdate : function(component, event, helper) {
         //$A.get('e.force:refreshView').fire();
    	var action = component.get('c.saveCompany');
    	action.setParams({
            "recordid": component.get('v.recordId')
        });
    	action.setCallback(this, function(response) {
    		var state = response.getState(); 
             if(state == 'SUCCESS') {
               
                  $A.get('e.force:refreshView').fire();
            }
    	});
     	$A.enqueueAction(action);
     
	},
    cancel : function(component, event, helper) {
         $A.get("e.force:closeQuickAction").fire();
    }
})