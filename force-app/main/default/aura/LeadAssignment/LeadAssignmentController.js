({
    loadQueues: function(component, event, helper) {
        //request from server
        var action1 = component.get("c.isAuthorised");
        action1.setCallback(this, function(response) {
        		var state = response.getState();
        		var isAuthorised = response.getReturnValue();
        		console.log(isAuthorised);
            if (component.isValid() && state == "SUCCESS" && isAuthorised) {
            		console.log('Success');
            		var action2 = component.get("c.getQueues");
            		action2.setCallback(this, function(response) {
		            var queues = response.getReturnValue();
		            console.log(queues);
		            component.set("v.queues", queues);
            		});
                $A.enqueueAction(action2);
            }
            else {
                console.log(response);
            		console.log('Error, not authorised');
            		var toastEvent = $A.get("e.force:showToast");
            		toastEvent.setParams({
                	"title": "Error!",
                	"type": "error",
                	"message": "You are not authorised to use this function, kindly close the window"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action1);
    },
    
    assignLead: function (component, event, helper) {
    		component.set("v.clickedOnce", true);
        var recId = component.get("v.recordId");
        var qId = component.get("v.selectedValue");
        var action = component.get("c.assignLeads");
        action.setParams({
            "queueId": qId,
            "leadId": recId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS") {
                console.log('Success');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                	"title": "Success!",
                	"type": "success",
                	"message": "Lead has been assigned successfully"
                });
                toastEvent.fire();
                helper.navigateToURL(component, event);                   
            } else {
                console.log('Error during owner update');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                	"title": "Error!",
                	"type": "error",
                	"message": "There was a problem assigning the Lead, kindly contact your administrator"
                });
                toastEvent.fire(); 
            }
        });
        $A.enqueueAction(action);
    }
})