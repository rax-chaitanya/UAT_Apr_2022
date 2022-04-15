({
    fetchPickListVal: function(component, fieldName, elementId) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.find(elementId).set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
    },
    
    saveTaskHelper : function(component) {
        var saveAction = component.get("c.saveCallTask");
        var tskObjc = JSON.stringify(component.get("v.tsk"));
        //saveAction.setParams({ "tskObj" : component.get("v.tsk") });
        saveAction.setParams({ "tskObj" : tskObjc });
        saveAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log("save done");
                component.set("v.isOpen", false);
                sforce.one.navigateToSObject(storeResponse);
            }
        });
        $A.enqueueAction(saveAction);
    },
    
    getCampaignName : function(component, WhatId) {
        var campaignName = component.get("c.getCampaigName");
        campaignName.setParams({ "whatId" : WhatId });
        campaignName.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();  
                if(storeResponse != null){
                    component.set("v.CampaignName","Lead Campaign Code "+storeResponse); 
                    component.set("v.tsk.Description","Lead Campaign Code "+storeResponse);
                    
                }
                
                
            }
        });
        $A.enqueueAction(campaignName);  
        
    },
    getContactName : function(component, WhoId) {
        console.log("WhoId in helper class"+WhoId);
        var contactName = component.get("c.getContactName");
        contactName.setParams({ "WhoId" : WhoId });
        contactName.setCallback(this, function(response) {
            var state1 = response.getState();
            if (state1 === "SUCCESS") {
                var storeResponse1 = response.getReturnValue();  
                if(storeResponse1 != null){
                    component.set("v.nameContact",storeResponse1);        
                }
            }
        });
        $A.enqueueAction(contactName);
    }
    
    
    
})