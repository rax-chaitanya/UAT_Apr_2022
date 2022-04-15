({	
    doInit : function (component, event, helper) {
        var recId = component.get("v.recordId");
        if(recId.includes('a1B')){
        	component.set("v.isVisible",true);    
        }          
    },
    handleClick : function (component, event, helper) {        
        var action = component.get("c.getbaseUrl");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                $A.get("e.force:closeQuickAction").fire();
                var recordId = component.get("v.recordId");                 
                var url = response.getReturnValue()+'/partners/apex/ExportCompensationDetails?recId=' + recordId;
                window.location = url;                                
            }                 
        });
        $A.enqueueAction(action);
    }
})