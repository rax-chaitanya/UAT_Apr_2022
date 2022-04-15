({
    handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            // record is loaded (render other component which needs record data value)
            console.log("Record is loaded successfully.");
            
            
            $A.get("e.force:closeQuickAction").fire();        
            
            
            var urlEvent = $A.get("e.force:navigateToURL");
            var acc = component.get("v.simpleRecord");
            
            console.log("go to crm: " + $A.get("$Label.c.Go_to_CRM"));
            let url = $A.get("$Label.c.Go_to_CRM")  + acc.DP_CustomerId__c;
            
            console.log("the url: " + url);
            
            urlEvent.setParams({
                "url": url
            });
            urlEvent.fire();

            
            
            
        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
    }    
})