({  
    navigateToURL: function(component, event) {
        $A.get("e.force:closeQuickAction").fire();        
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "one/one.app#/sObject/" + component.get("v.recordId")
        });
        urlEvent.fire();              
    }
})