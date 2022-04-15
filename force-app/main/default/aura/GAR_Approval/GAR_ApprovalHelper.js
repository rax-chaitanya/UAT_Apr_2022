({
	hideSpinner : function(component) {
		var spinner = component.find("spinner");
        $A.util.addClass(spinner, 'slds-hide');
	},
    
    showSpinner : function(component) {
		var spinner = component.find("spinner");
        $A.util.removeClass(spinner, 'slds-hide');
	},
    
    process : function(component, action, record){
        var processApprovalAcction = component.get("c.processDML");
        processApprovalAcction.setParams({
            "action" : action,
            "request" : record,
            "items" : record.Realignment_Request_Items__r,
            "comments" : component.get("v.comments")
        });
        processApprovalAcction.setCallback(this, function(response){
            this.hideSpinner(component);
            if(response.getState() == 'SUCCESS'){
                this.processApproval(component, action, record);
            }
        });
        
        $A.enqueueAction(processApprovalAcction);
        this.showSpinner(component);
    },
    
    processApproval : function(component, action, record){
        var processApprovalAcction = component.get("c.processApproval");
        processApprovalAcction.setParams({
            "action" : action,
            "request" : record,
            "items" : record.Realignment_Request_Items__r,
            "comments" : component.get("v.comments")
        });
        processApprovalAcction.setCallback(this, function(response){
            this.hideSpinner(component);
            if(response.getState() == 'SUCCESS'){
                var record = response.getReturnValue();
                component.set("v.record", response.getReturnValue());
                component.set("v.processed", true);
            }
        });
        
        $A.enqueueAction(processApprovalAcction);
        this.showSpinner(component);
    }
})