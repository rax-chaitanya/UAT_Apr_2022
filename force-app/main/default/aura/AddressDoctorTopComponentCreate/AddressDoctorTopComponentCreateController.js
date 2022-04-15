({
	doInit : function(component, event, helper) {
        var myPageRef = component.get("v.pageReference");
        var recId = myPageRef && myPageRef.state ? myPageRef.state.c__recordId : "World";
        var objName = myPageRef && myPageRef.state ? myPageRef.state.c__objName : "World";
        var recCheck = component.get("v.recordId");
        var objCheck = component.get("v.sObjectName");
        console.log(recCheck,objCheck);
        if(recId!='World' && objName!='World'){
            console.log('innn');
            component.set("v.recordId", recId);
        	component.set("v.sObjectName",objName);
        }
        component.set("v.isRunning", true); 
		var recId = component.get("v.recordId");
        var objectName = component.get("v.sObjectName");
        component.set("v.isRunning", true);  
        component.set("v.closeOnSave", false);
        setTimeout(function(){component.set("v.isRunning", false)}, 3000);
       // helper.showAddress(component);
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
               // console.log('## '+JSON.stringify(allValues));
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
        var resultNo = component.get("v.selectedAddNo");
        if(resultNo>=0 ){
        //console.log('value result data '+component.get("v.serchedRes")[resultNo].houseNo);
        helper.updateRecordWithAddress(component);    
        }
        var isClose = event.getSource().get("v.value");
        if(isClose == 'true')
          $A.get("e.force:closeQuickAction").fire();
    },
   /* save : function(component, event, helper) {
    	component.set("v.isRunning", true);
        component.set("v.closeOnSave", true);
    	component.find("edit").get("e.recordSave").fire();
        setTimeout(function(){component.set("v.isRunning", false)}, 2000);
        
	},*/
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
                component.set("v.initRecord.state", currRecord.eachAddress.state);
                component.set("v.initRecord.country", currRecord.eachAddress.country);
                component.set("v.initRecord.province", currRecord.eachAddress.province);
                component.set("v.initRecord.zip", currRecord.eachAddress.zip);
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
        
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            console.log(JSON.stringify(response));
            var focusedTabId = response.tabId;  
            if(response.isSubtab){
             workspaceAPI.closeTab({tabId: focusedTabId});
           //  component.set("v.openTab",true);
                //set variable to open tab
            }else{
                $A.get("e.force:closeQuickAction").fire();
            }
        })
        .catch(function(error) {
            console.log(error);
        });
        //var newTabLink = "/lightning/r/"+response[i].pageReference.attributes.objectApiName
        //       
        //                			         					+"/"+response[i].recordId+"/view";
        if(component.set("v.openTab")){                			         		
        workspaceAPI.openTab({           
           					pageReference: {
                "type": "standard__recordPage",
                "attributes": {
                    "recordId": component.get("v.recordId"),
                    "actionName":"view"
                },
                "state": {}
            }, 
                            focus: true
                            }).then(function(responseC){
                                })
                                .catch(function(error) {
                                    console.log(error);
                                });
    }
    },
    dismissError : function (component, event, helper) {
        component.set('v.hasError', false);
        component.set('v.errorMessage', '');
    },
    goBack : function (component, event, helper) {
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