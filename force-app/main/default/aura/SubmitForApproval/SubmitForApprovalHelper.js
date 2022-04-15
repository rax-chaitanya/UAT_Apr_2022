({
    submitforapproval : function(component, event, helper) {
        console.log('In Helper');
        var action = component.get("c.getPartnerfundclaimdata");
        var partnerid = component.get("v.recordId");
        var errorMsgs = [];
        console.log('partnerid'+partnerid );
        action.setParams({ 
            PFCid : partnerid 
        })
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('In Helper state' + state);
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('results$$$$$$$$$$$'+ results);
                errorMsgs+= results;
                component.set("v.recordError", errorMsgs);
            }
            else if(status === 'ERROR'){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Error Message',
                            message:errors[0].message,
                            duration:' 8000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'sticky'
                        });
                        toastEvent.fire();
                    }
                }
            }
            $A.get('e.force:refreshView').fire();
            
        });
        $A.enqueueAction(action); 
        
    }
})