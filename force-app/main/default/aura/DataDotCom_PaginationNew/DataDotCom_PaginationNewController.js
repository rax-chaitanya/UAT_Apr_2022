({
	doInit : function(component, event, helper) {
		var searchResults = component.get("v.dbResultObj");        
        var start = searchResults.dbOffSet + 1;
        var end = searchResults.dbLimit;
        
        component.set("v.startRec",start);
        component.set("v.endRec",end);
	},
    dbNext : function(component, event, helper) {
		//console.log('====>>>'+component.get("v.resultObj"));
        //console.log('====>>>'+JSON.stringify(component.get("v.resultObj")));
        var dbResultObj = component.get("v.dbResultObj");
        var compName = component.get("v.cmpName");        
        var locSelected = component.get("v.selectedloc");
        console.log('1====>>>'+compName);
        console.log('2====>>>'+locSelected);
        
        var action = component.get("c.dbCompNext");
        action.setParams({
            "obj": JSON.stringify(dbResultObj),
            "companyName": compName,
            "locationSel":locSelected
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS") {
                console.log('Success');
                var searchResults = response.getReturnValue();
                console.log('------<'+JSON.stringify(searchResults));                
                component.set("v.dbPaginationList",searchResults.CloudDBCompList);
                component.set("v.dbResultObj",searchResults);
                
                var start = component.get("v.startRec") + searchResults.dbLimit;
                var end = component.get("v.endRec") + searchResults.dbLimit;
                component.set("v.startRec",start);
                component.set("v.endRec",end);
            }
        });
        $A.enqueueAction(action);
	},
    dbPrevious : function(component, event, helper) {
		//console.log('====>>>'+component.get("v.resultObj"));
        //console.log('====>>>'+JSON.stringify(component.get("v.resultObj")));
        var dbResultObj = component.get("v.dbResultObj");
        var compName = component.get("v.cmpName");
        var website = component.get("v.website");   
        var locSelected = component.get("v.selectedloc");
        
        console.log('1====>>>'+compName);
        console.log('2====>>>'+locSelected);
        
        var action = component.get("c.dbCompPrevious");
        action.setParams({
            "obj": JSON.stringify(dbResultObj),
            "companyName": compName,
            "locationSel":locSelected
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS") {
                console.log('Success');
                var searchResults = response.getReturnValue();
                console.log('------<'+JSON.stringify(searchResults));                
                component.set("v.dbPaginationList",searchResults.CloudDBCompList);
                component.set("v.dbResultObj",searchResults);
                
                var start = component.get("v.startRec") - searchResults.dbLimit;
                var end = component.get("v.endRec") - searchResults.dbLimit;
                component.set("v.startRec",start);
                component.set("v.endRec",end);
            }
        });
        $A.enqueueAction(action);
	},
    handleImport: function (component, event,helper) {
        var idx = event.target.id;   //company Id of request clicked
        console.log('Id:::>>'+idx); 
        var dbResultObj = component.get("v.dbResultObj");
        console.log('dbResultObj:::>>'+JSON.stringify(dbResultObj));
        var action = component.get("c.importDandBCompany");
        action.setParams({
            "obj": JSON.stringify(dbResultObj), 
            "compId": idx
        });        
        // Set up the callback
        action.setCallback(this, $A.getCallback(function (response) {
            //alert('2');
            var state = response.getState();            
            if(state === "SUCCESS"){
                //if successful stores query results in ipRecordTypes
                var importResult = response.getReturnValue();
                console.log('importResult---> ' +JSON.stringify(importResult));                
                component.set("v.dbPaginationList", importResult.CloudDBCompList);
                component.set("v.dbResultObj",importResult);
                
                //Registering event with updated Company List
                var companyEvent = $A.get("e.c:CompanySearchEventNew");
                companyEvent.setParams({
                    "resultObj" : importResult
                });
                companyEvent.fire();
                
                /*var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Success Message",
                    "message": "Record imported successfully.",
                    "type": "success",
                    "mode":"dismissible",
                    "key": "info_alt",
                });
                resultsToast.fire();*/
                
            } else if (state === "ERROR") {                
                var errors = response.getError();
                console.error(errors);
            }
        }));        
        $A.enqueueAction(action);
    }
})