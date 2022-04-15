({
	doInit: function(component, event, helper) {
    	var recordId = component.get("v.recordId");
    	var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": 'https://rax.lightning.force.com/lightning/r/'+recordId+'/related/CampaignMembers/view'
    		});
    	urlEvent.fire();
    }
})