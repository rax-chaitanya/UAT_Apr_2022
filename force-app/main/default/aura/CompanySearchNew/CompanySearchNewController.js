({
	doInit : function(component, event, helper) {        
		helper.fetchPickListVal(component, event, helper);        
        helper.fetchTerritoryListVal(component, event, helper);
        helper.fetchCountryListVal(component, event, helper);
        
        helper.fetchDependentCountryState(component, event, helper);
	},
    searchCompaniesdAndBCompanies: function (component, event, helper) {
        
        var companyName = component.find('inputcmpName').get('v.value');
        if(companyName != '' && companyName != undefined){            
            helper.searchCompaniesdAndBCompanies(component, event, helper);
        }else{            
            component.find('inputcmpName').showHelpMessageIfInvalid();
        }        
    },
    clearFrom : function (component, event, helper) {       
       component.set("v.showCmpTbl", false);
        component.set("v.cmpName", '');
        component.set("v.website", '');
        component.set("v.selectedCntry", '');
        component.set("v.selectedState", '');
        component.set("v.statePickEnable", true);
        component.set("v.territorySelected", '');
        
        var stateLst = [];
        stateLst.push('--None--');          
        component.set("v.statePickList", stateLst);
    },
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    },
    validateState : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       var selSt = component.get("v.selectedState");
        if(selSt == '--None--'){
            component.set("v.selectedState",'');
        }
    },
    
    getState: function(component, event, helper) {
        // get the value of select option
        var stateLst = [];
        stateLst.push('--None--');
        console.log(event.getSource().get("v.value"));        
        var selectedCountry = component.get("v.selectedCntry");
        console.log('---->'+selectedCountry);
        var stateList = component.get('v.pickListMap')[selectedCountry];        
        for ( var key in stateList ) {
        	stateLst.push(stateList[key]);
        }        
        component.set('v.statePickList',stateLst);
        console.log('---->'+component.get('v.statePickList'));
        if(selectedCountry == '--None--'){
            component.set("v.statePickEnable", true);
            component.set("v.selectedState",'');
            component.set("v.selectedCntry",'');
        }else{
            component.set("v.statePickEnable", false);
        }
		
    },

    createAcRecord : function (component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Account",
             "defaultFieldValues":{
                 "Name" : component.get("v.cmpName"),
                }
        });
        createRecordEvent.fire();
    },
})