({
	fetchTheResponse: function(component, streetAH, cityAH, stateAH, zipAH, countryAH, modeAH) {
        component.set("v.isRunning", true);
        var action = component.get("c.serveBatchMode");
        action.setParams({
            "streetString": streetAH,
            "cityString": cityAH,
            "stateString": stateAH,
            "countryString": countryAH,
            "zipString": zipAH,
            "mode": modeAH
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                if(!allValues.isError && allValues.lstAddress.length>0){
                component.set("v.ifResults", true); 
                console.log('@@ '+allValues);
                component.set("v.statusA", allValues.verCode);
                component.set("v.serchedResC", allValues.lstAddress);
                    console.log('no error',allValues.lstAddress);
                }else{
                    console.log('error',response.getReturnValue());
                    //call the event for error  
                    var compEvent = component.getEvent("eSelectedAddress");
                    //set the Selected sObject Record to the event attribute.  
                    compEvent.setParams({"isError" : true, "errorMessage" :  allValues.message});  
                    //fire the event  
                    compEvent.fire();
                }
            }else{
                //component.set("v.isRunning", false);
            }
            component.set("v.isRunning", false);
        });
        $A.enqueueAction(action);
    },
    searchActive : function(component){
        console.log('$$$$$$$$$$',JSON.stringify(component.get("v.initRecordC")));
    	var countryLabel = $A.get("$Label.c.Exclude_Country")
        var streetA = component.get("v.initRecordC.street");
        var cityA = component.get("v.initRecordC.city");
        var stateA = component.get("v.initRecordC.province");
        var zipA = component.get("v.initRecordC.zip");
        var countryA = component.get("v.initRecordC.country");
        console.log("changes field");
        if(streetA && cityA && zipA && stateA && countryA && (countryLabel.includes(countryA))){
            console.log("changes field nul");
            component.set("v.isSearchActive", false); 
        }else if(streetA && cityA && countryA && !(countryLabel.includes(countryA))){
            component.set("v.isSearchActive", false); 
        }else{
            component.set("v.isSearchActive", true);
        }
	},
    fetchCountryList: function(component) {
        var action = component.get("c.fetchCountryList");
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
               var allValues = response.getReturnValue();
               component.set("v.lstCountry", allValues); 
            }
        });
        $A.enqueueAction(action);
    	}
  		
})