({
	doInit: function (component, event, helper) {
		var recId = component.get('v.recordId');
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/apex/DP_NewEditQuote?id=" + recId,
            "isredirect": "true"
        });
        urlEvent.fire();
	}
})