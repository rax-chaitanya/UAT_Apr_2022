({
	doInit : function(component, event, helper) {
		component.set("v.isRunning", true); 
		var recId = component.get("v.recordId");
        var objectName = component.get("v.sObjectName");
        console.log("recId "+recId);
        console.log("sObjectName "+component.get("v.sObjectName"));
        var action = component.get("c.serveInitAddress");
        action.setParams({
            "objId": recId,
            "objectName": objectName
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                console.log('## '+allValues);
                component.set('v.initialRes', response.getReturnValue());
                component.set("v.initRecord", {});
                component.set("v.isRunning", false);
            }else{
                component.set("v.isRunning", false);
            }
        });
        $A.enqueueAction(action);
	},
    onSave: function(component, event, helper){
        console.log("inside save");
        var resultNo = component.get("v.selectedAddNo");
        if(resultNo>=0){
        //console.log('value result data '+component.get("v.serchedRes")[resultNo].houseNo);
        helper.updateRecordWithAddress(component);    
        }
        var isClose = event.getSource().get("v.value");
        if(isClose == 'true')
          $A.get("e.force:closeQuickAction").fire();
    },
    save : function(component, event, helper) {
    	component.set("v.isRunning", true);
        component.set("v.closeOnSave", true);
    	component.find("edit").get("e.recordSave").fire();
        setTimeout(function(){component.set("v.isRunning", false)}, 2000);
        //var isClose = event.getSource().get("v.value");
        //if(isClose == 'true')
          //$A.get("e.force:closeQuickAction").fire(); 
	},
    saveAndUpdateAddress : function(component, event, helper) {
        component.set('v.showConfirmation', true);
	},
    gotoAddress : function(component, event, helper) {
    	component.set("v.showAddress", false);   
    	component.set("v.showSearch", true);
        var type = event.getSource().get("v.value");
        var index = event.getSource().get("v.name");
        component.set("v.typeOfAddress", type);
        component.set("v.indexOfAddress", index);
          		var currRecord = component.get('v.initialRes')[index];
                component.set("v.initRecord.street", currRecord.eachAddress.street);
                component.set("v.initRecord.city", currRecord.eachAddress.city);
                component.set("v.initRecord.country", currRecord.eachAddress.country);
                component.set("v.initRecord.province", currRecord.eachAddress.province);
                component.set("v.initRecord.zip", currRecord.eachAddress.zip);
	},
    saveSuccessHandle : function(component, event, helper) {
        component.set("v.isRunning", false);
        var closeOnSave = component.get("v.closeOnSave");
        if(closeOnSave){
          $A.get("e.force:closeQuickAction").fire();
        }else{
            helper.showAddress(component);
        }
        //component.set("v.showEdit", false); 
        //component.set("v.showAddress", true);
    },
    doUpdateStatus : function(component, event, helper) {
        var addResults = [];
        if(event.target.checked)
        component.get("v.addressResultSet").push(event.target.value);
        else
		component.get("v.addressResultSet").pop(event.target.value);            
        console.log("toggled"+event.target.value);
        console.log("toggled"+event.target.checked);
        //component.set("v.addressResultSet", addResults);
		console.log(component.get("v.addressResultSet"));		
    },
    cancel : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire(); 
    },
    dismissError : function (component, event, helper) {
        component.set('v.hasError', false);
        component.set('v.errorMessage', '');
    },
    goBack : function (component, event, helper) {
        helper.showAddress(component);
    },
    saveYes : function (component, event, helper) {
        component.set('v.showConfirmation', false);
        component.set("v.isRunning", true);  
        component.set("v.closeOnSave", false);
        setTimeout(function(){component.set("v.isRunning", false)}, 3000);
    	component.find("edit").get("e.recordSave").fire();
        //helper.showAddress(component);
    },
    saveNo : function (component, event, helper) {
        component.set('v.showConfirmation', false);
        helper.showAddress(component);
    },
    handleComponentEvent : function(component, event, helper) {
     // check for any error 
     var isError = event.getParam("isError");  
        if(isError){
            helper.showErrorMmodal(component, event.getParam("errorMessage")); 
        }else{  
           // get the selected Account record from the COMPONETN event	 
           var selectedAccountGetFromEvent = event.getParam("recordSelectEvent");
           console.log('event fired '+selectedAccountGetFromEvent);
           component.set("v.initRecord" , selectedAccountGetFromEvent);
           component.set("v.showAddrCheck", true);
        }     
	}
})