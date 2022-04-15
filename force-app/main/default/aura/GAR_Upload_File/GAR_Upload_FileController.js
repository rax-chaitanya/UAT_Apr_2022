({  
    save : function(component, event, helper) {
        var clear = component.get("v.clear");
        $A.enqueueAction(clear);
        helper.save(component);
    },
    
    closeProgressModal : function(component, event, helper){
        component.set("v.progress", []);
        var progressModal = component.find("progress-modal");
        $A.util.addClass(progressModal, "slds-hide");
    },
    
    clearFile : function(component, event, helper){
        event.target.value = '';
    },
    
    afterSheetJSLoaded : function(component, event, helper){
        component.set("v.inputFileDisabled", false);
    }
})