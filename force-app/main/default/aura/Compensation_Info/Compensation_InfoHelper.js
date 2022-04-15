({
	getPartnerLevel: function(component,event,helper) {
		var action = component.get("c.partnerLevelType");
        action.setCallback(this,function(response){
        component.set("v.PartnerLevel",response.getReturnValue());             
        });
        $A.enqueueAction(action);
	},
})