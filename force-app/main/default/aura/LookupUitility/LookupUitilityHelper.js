({
	searchHelper : function(component,event,getInputkeyWord) {
	  
     var action = component.get("c.fetchLookUpValues");
        
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName"),
            'activeUsers' : component.get("v.fieldValue")
          });
          
        action.setCallback(this, function(response) {
          $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
              
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                
                component.set("v.listOfSearchRecords", response.getReturnValue());
            }
 
        });
       
        $A.enqueueAction(action);
    
	},
})