({
	navigate : function(component, event, helper) {
        
        //close the hijacked quick action
        $A.get("e.force:closeQuickAction").fire();        
        
        var url = "/apex/SearchBeforeCreateCompany";
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": url
        });
        urlEvent.fire();        
		
	}
})