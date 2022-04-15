({
    handleRecordUpdated: function(component, event, helper) {     
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            // record is loaded (render other component which needs record data value)
            console.log("Record is loaded successfully.");
            component.set("v.simpleRecord.Company_Access_Submitter__c", $A.get('$SObjectType.CurrentUser.Id'));
            
            
            helper.promise(component, helper.getUserRecordAccess) 
            .then(function() {
                return helper.promise(component, helper.validate)            
            })
            
            .catch(function(err) {
                //use below code when this component/application is embedded in a record detail page. 
                //currently, it doesn't work when it's a standalone component or application
                
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    title: 'Error',
                    type: 'error',
                    message: err.message
                });
                
                toastEvent.fire();
                
                
                component.set("v.error", err.message);
                
                //alert("error:" + err.message);
            })
            .then(function() {
                //close the hijacked quick action
                $A.get("e.force:closeQuickAction").fire();        
                
                
                if (!component.get("v.recordError")) {                    
                    helper.navigateToURL(component, event);
                } 
            });
        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
            // get the fields that changed for this record
            /*
            var changedFields = eventParams.changedFields;
            console.log('Fields that are changed: ' + JSON.stringify(changedFields));
            // record is changed, so refresh the component (or other component logic)
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                "title": "Saved",
                "message": "The record was updated."
            });
            resultsToast.fire();
            */
            
            //alert("record is changed");
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
            //alert("record deleted");
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
            //alert("there was an error saving");
        }
    }
})