({
    doInit : function(component, event, helper) {
        helper.fetchCountryList(component);
        helper.searchActive(component);
    },
    search: function(component, event, helper) {
        //add a method: send our country name component.get("v.initRecordC.country") to check for coutry code
        //return : all the countries related to that coutry code
        //cusotm setting eg: united kingdom . =gb
        //					great britain = gb
        //					xyz = gb

        helper.fetchTheResponse(component, component.get("v.initRecordC.street"), component.get("v.initRecordC.city"), component.get("v.initRecordC.province"), component.get("v.initRecordC.zip"), component.get("v.initRecordC.country"), 'INTERACTIVE');
	},
    onGroup : function(component, event, helper){
     	 var target = event.target;
		 var dataEle = target.getAttribute("data-selected-Index");
        if(dataEle=="bypassed"){
            console.log("bypassed");
            component.set("v.selectedAddNo", dataEle);
            console.log('value resultNo '+dataEle);
            component.set("v.showAddrCheck", true); 
            var selectedObject = component.get("v.serchedResC")[0];
             selectedObject.ifVerified = false;
            console.log("bypassed addr?",JSON.stringify(selectedObject));
            //call the event   
              var compEvent = component.getEvent("eSelectedAddress");
            //set the Selected sObject Record to the event attribute.  
              compEvent.setParams({"recordSelectEvent" : selectedObject });  
            //fire the event  
              compEvent.fire();
        }else{
            component.set("v.selectedAddNo", dataEle-1);
         console.log('value resultNo '+dataEle);
         console.log('value result data '+component.get("v.serchedResC")[dataEle-1].houseNo);
         component.set("v.showAddrCheck", true); 
        var selectedObject = component.get("v.serchedResC")[dataEle-1];
        selectedObject.ifVerified = true;
        //call the event   
          var compEvent = component.getEvent("eSelectedAddress");
        //set the Selected sObject Record to the event attribute.  
          compEvent.setParams({"recordSelectEvent" : selectedObject });  
        //fire the event  
          compEvent.fire();
        }
         
    },
    methodName : function(component, event, helper){
        console.log("passed");
        helper.searchActive(component);
    }
})