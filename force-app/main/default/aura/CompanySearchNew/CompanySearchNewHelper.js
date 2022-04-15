({
	fetchPickListVal: function(component, event, helper) {
        var action = component.get("c.fetchLocationType");        
        // Set up the callback
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            var resultsToast = $A.get("e.force:showToast");
            if(state === "SUCCESS"){
                //if successful stores query results in ipRecordTypes
                var locList = response.getReturnValue();
                console.log('getRecordTypes returned: ' +locList);                
                component.set('v.locationType', response.getReturnValue());
            } else if (state === "ERROR") {                
                var errors = response.getError();
                console.error(errors);
            }
        }));        
        $A.enqueueAction(action);
    },
    
    fetchTerritoryListVal: function(component, event, helper) {
        var action = component.get("c.getTerritory");        
        // Set up the callback
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();            
            if(state === "SUCCESS"){
                //if successful stores query results in ipRecordTypes
                var terList = response.getReturnValue();
                console.log('getRecordTypes returned: ' +terList);                
                component.set('v.territoryList', response.getReturnValue());
            } else if (state === "ERROR") {                
                var errors = response.getError();
                console.error(errors);
            }
        }));        
        $A.enqueueAction(action);
    },
    fetchCountryListVal: function(component, event, helper) {
        var action = component.get("c.getCountry");        
        // Set up the callback
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();            
            if(state === "SUCCESS"){
                component.set('v.countryList', response.getReturnValue());
            } else if (state === "ERROR") {                
                var errors = response.getError();
            }
        }));        
        $A.enqueueAction(action);
    },
    fetchDependentCountryState: function(component, event, helper) {
        var action = component.get("c.getDependentCountryState");        
        // Set up the callback
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();            
            if(state === "SUCCESS"){
                //if successful stores query results in ipRecordTypes
                var countryLst = [];
                var pickList = response.getReturnValue();
                //component.set('v.pickListObj',pickList);
                component.set('v.pickListMap',pickList);
                //console.log('Dependent PickList : ' +component.get('v.pickListMap').Afghanistan);  
                //console.log('Dependent PickList : ' +JSON.stringify(pickList));
                countryLst.push('--None--');
                for ( var key in pickList ) {
                     countryLst.push(key);
                }
                component.set('v.countryPickList',countryLst);
                console.log('Country List ::'+component.get('v.countryPickList'));
            } else if (state === "ERROR") {                
                var errors = response.getError();
                console.error(errors);
            }
        }));        
        $A.enqueueAction(action);
    },
    searchCompaniesdAndBCompanies: function (component, event, helper) {
       
        //var countrySel = component.get("v.acc.BillingCountryCode");
        console.log('1==>'+component.get("v.selectedloc"));   
        console.log('1==>'+component.get("v.selectedState"));           
        var compName = component.get("v.cmpName");
        var website = component.get("v.website");  
        var locSelected = component.get("v.selectedloc");
        var terSelected = component.get("v.territorySelected");
        var cntrySelected = component.get("v.selectedCntry");
        var stateSelected = component.get("v.selectedState");
        var action = component.get("c.fetchResult");
        action.setParams({
            "companyName": compName,
            "website":website,
            "locationSel":locSelected,
            "territorySel":terSelected,
            "countrySel":cntrySelected,
            "stateSel":stateSelected
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS") {
                console.log('Success');
                var searchResults = response.getReturnValue();
                console.log('------<'+JSON.stringify(searchResults));                
                component.set("v.CompanyPaginationList",searchResults.companyList);
                component.set("v.DBPaginationList",searchResults.CloudDBCompList);
                component.set("v.resultObj",searchResults);
                component.set("v.showCmpTbl",true);
                
                component.set("v.startRec",searchResults.compOffSet + 1);
                component.set("v.endRec",searchResults.compLimit);
                component.set("v.dbstartRec",searchResults.dbOffSet + 1);
                component.set("v.dbendRec",searchResults.dbLimit);
            }
        });
        $A.enqueueAction(action);
    }
})