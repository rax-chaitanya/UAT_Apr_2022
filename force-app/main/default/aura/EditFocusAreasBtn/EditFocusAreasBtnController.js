({
	doInit : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/apex/EditFocusAreas?oid=" + component.get("v.recordId")
        });
        urlEvent.fire();
	}
})