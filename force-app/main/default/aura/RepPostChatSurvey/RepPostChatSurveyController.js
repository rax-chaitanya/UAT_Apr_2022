({
    doInit: function(component, event, helper) {
        /*
        //component.set("v.survey", {sobjectType : "Rep_Chat_Survey__c"});
        var action = component.get("c.getSurveyCount");
        action.setParams({recordId	: component.get("v.recordId")});
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                //alert(response.getReturnValue());
                if (response.getReturnValue() > 0) {
                    component.set("v.showSurvey", false);
                }
            }
        });
        
        $A.enqueueAction(action);
        */
    },

    handleSaveSurvey: function(component, event, helper) {
        // stamp the sobject's Live Chat Transcript with the record Id in context
        component.set("v.survey.Live_Chat_Transcript__c", component.get("v.recordId"));
        
        // pass the survey as an attribute in the param
        var action = component.get("c.saveSurvey");
        action.setParams({survey	: component.get("v.survey")});
        
        
        //based on the response, do the following
        action.setCallback(this, function(response) {
            // if successful
            if (response.getState() === "SUCCESS") {
                //hide the survey component from the detail page
                component.set("v.showSurvey", false);
                
                // publish an event [so the pending post chat surveys can refresh]
                // 
                var appEvent = $A.get("e.c:workItemClosedEvent");
                appEvent.fire();    
                
                
                var toast = $A.get("e.force:showToast");
                toast.setParams({
                    type	: "success",
                    title : "Success!",
                    message	: "Thanks for completing the post chat survey."  
                });
                toast.fire();
                
            }
        });
        
        $A.enqueueAction(action);
        
        
        
        

    },
    
    handleApplicationEvent	: function(component, event, helper) {
        var message = event.getParam("lctId");
        if (message) {
            component.set("v.recordId", message);
            component.set("v.showSurvey", true );
        }
        
    }
})