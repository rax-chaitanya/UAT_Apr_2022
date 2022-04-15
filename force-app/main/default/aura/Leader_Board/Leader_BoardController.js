({
	doInit : function(component, event, helper) {
        helper.loadUserDetails(component);
        helper.loadMemberLeaderboard(component);
        helper.loadPartnerLeaderboard(component);
	},
    
    refreshIcons : function(component, event, helper) {
        var action = component.get('c.updateLevelIcons');
        action.setCallback(this,function(response){
            component.set("v.doneLoading", true);
            if(response.getState() == 'SUCCESS'){
                $A.enqueueAction(component.get("c.doInit"));
            }
        });
        $A.enqueueAction(action);
        component.set("v.doneLoading", false);
    }
})