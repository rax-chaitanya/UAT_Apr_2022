({
	handlePermissionRequestAccess: function (component, event,idx) {        
        var resultObj = component.get("v.resultObj");
        var action = component.get("c.requestCompanyRecordAccess");
        action.setParams({
            "obj": JSON.stringify(resultObj),
            "compId": idx            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS") {
                console.log('Success');
                var searchResults = response.getReturnValue();
                console.log('------<'+JSON.stringify(searchResults));                
                component.set("v.PaginationList",searchResults.companyList);
                component.set("v.resultObj",searchResults); 
            }
        });
        $A.enqueueAction(action);
    }
})