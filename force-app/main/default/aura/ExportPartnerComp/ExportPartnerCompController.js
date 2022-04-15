({
    doInit : function(component, event, helper) {        
        var action = component.get("c.getbaseUrl");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                $A.get("e.force:closeQuickAction").fire();
                var recordId = component.get("v.recordId");                 
                var url = response.getReturnValue()+'/partners/apex/ExportCompensationDetails?recId=' + recordId;
                window.location = url;
                //var urlEvent = $A.get("e.force:navigateToURL");
                //urlEvent.setParams({
                //    "url": url
                //});
                //urlEvent.fire();                
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    }
})