({
    doInit : function(component, event, helper) {
        
       
    },
    clickToAgree: function(component, event, helper) {
        
        var action = component.get('c.updatePilotAgreementDate');
        action.setParams({
            "ContentDistId": event.getSource().get('v.value')
        });
        action.setCallback(this, function(actionResult) {
            var state = actionResult.getState();
            if (state == 'SUCCESS') {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"SUCCESS",
                    "title":"SUCCESS",
                    "message": "You have successfully agreed the agreement. Thank you." 
                });
                toastEvent.fire();
                var btn = event.getSource();
                btn.set("v.disabled",true);
                $A.get('e.force:refreshView').fire();
                
            }
            else{
                alert('something went wrong.Please contact System administrator for the same.');
            }
        });
        $A.enqueueAction(action);
        
        
    }
})