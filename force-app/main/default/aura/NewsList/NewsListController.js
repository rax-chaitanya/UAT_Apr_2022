({
	doInit : function(component, event, helper) {
		var action ;
        action = component.get('c.getNewsList');
        action.setCallback(this,function(actionresult){
            component.set('v.newsList',actionresult.getReturnValue());            
        });
        $A.enqueueAction(action);
	}
})