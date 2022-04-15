({
    optIn : function(component, event, helper) {
        if(!component.get("v.agreed")){
            alert('Please mark the agreement checkbox');
            return;
        }
        var optInAction = component.get("c.optInGamification");
        optInAction.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                helper.markAsOptedIn(component, event, helper);
            }else{
                alert("Unexpected error occured!");
            }
        });
        $A.enqueueAction(optInAction);
        component.set("v.doneLoading", false);
    },
    
})