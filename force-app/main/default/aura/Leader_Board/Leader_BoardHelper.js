({
    loadMemberLeaderboard : function(component) {
        var action = component.get('c.getMemberRanks');
        action.setCallback(this,function(response){
            component.set('v.MemberLeaderboard',response.getReturnValue()); 
        });
        $A.enqueueAction(action);
	},
    
    loadPartnerLeaderboard : function(component) {
        var action = component.get('c.getPartnerRanks');
        action.setCallback(this,function(response){
            component.set('v.PartnerLeaderboard',response.getReturnValue()); 
        });
        $A.enqueueAction(action);
	},
    
    loadUserDetails : function(component) {
        var action = component.get('c.getUserDetails');
        action.setCallback(this,function(response){
            component.set('v.IsPartner',response.getReturnValue().IsPartner); 
        });
        $A.enqueueAction(action);
	}
})