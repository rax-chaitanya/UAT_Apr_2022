({
    doInit : function(component, event, helper) {        
        var searchResults = component.get("v.resultObj");        
        var start = searchResults.compOffSet + 1;
        var end = searchResults.compLimit;                
        component.set("v.startRec",start);
        component.set("v.endRec",end);
    },
    next : function(component, event, helper) {
        //console.log('====>>>'+component.get("v.resultObj"));
        //console.log('====>>>'+JSON.stringify(component.get("v.resultObj")));
        var resultObj = component.get("v.resultObj");
        var compName = component.get("v.cmpName");
        var website = component.get("v.website"); 
		var terSelected = component.get("v.territorySelected");
        var cntrySelected = component.get("v.selectedCntry");
        var stateSelected = component.get("v.selectedState");
        
        var action = component.get("c.compNext");
        action.setParams({
            "obj": JSON.stringify(resultObj),
            "companyName": compName,
            "website":website,            
            "territorySel":terSelected,
            "countrySel":cntrySelected,
            "stateSel":stateSelected
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS") {
                console.log('Success');
                var searchResults = response.getReturnValue();
                //console.log('------<'+JSON.stringify(searchResults));                
                component.set("v.PaginationList",searchResults.companyList);
                component.set("v.resultObj",searchResults);
                var start = component.get("v.startRec") + searchResults.compLimit;
                var end = component.get("v.endRec") + searchResults.compLimit;
                component.set("v.startRec",start);
                component.set("v.endRec",end);
                
            }
        });
        $A.enqueueAction(action);
    },
    previous : function(component, event, helper) {
        //console.log('====>>>'+component.get("v.resultObj"));
        //console.log('====>>>'+JSON.stringify(component.get("v.resultObj")));
        var resultObj = component.get("v.resultObj");
        var compName = component.get("v.cmpName");
        var website = component.get("v.website");
        var terSelected = component.get("v.territorySelected");
        var cntrySelected = component.get("v.selectedCntry");
        var stateSelected = component.get("v.selectedState");
        
        var action = component.get("c.compPrevious");
        action.setParams({
            "obj": JSON.stringify(resultObj),
            "companyName": compName,
            "website":website,
            "territorySel":terSelected,
            "countrySel":cntrySelected,
            "stateSel":stateSelected
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS") {
                console.log('Success');
                var searchResults = response.getReturnValue();
                //console.log('------<'+JSON.stringify(searchResults));                
                component.set("v.PaginationList",searchResults.companyList);
                component.set("v.resultObj",searchResults); 
                //console.log('------<'+searchResults.compOffSet); 
                var start = component.get("v.startRec") - searchResults.compLimit;
                var end = component.get("v.endRec") - searchResults.compLimit;
                component.set("v.startRec",start);
                component.set("v.endRec",end);
            }
        });
        $A.enqueueAction(action);
    },
    handleRequestAccess: function (component, event,helper) {
        var idx = event.target.id;   //company Id of request clicked
        console.log('Id:::'+idx);
        helper.handlePermissionRequestAccess(component, event,idx);        
    },
    handleApplicationEvent:function (component, event,helper) {
        var searchResults = event.getParam("resultObj");
        //alert(JSON.stringify(searchResults));
        component.set("v.PaginationList",searchResults.companyList);
		component.set("v.resultObj",searchResults); 
	}
})