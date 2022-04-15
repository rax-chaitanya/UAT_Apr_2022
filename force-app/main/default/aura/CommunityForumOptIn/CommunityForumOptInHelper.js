({
    markAsOptedIn : function(component, event, helper) {
        var checkIfOptedIn = component.get("c.markAsOptedIn");
        checkIfOptedIn.setCallback(this, function(response){
            component.set("v.doneLoading", true);
            if(response.getState() == 'SUCCESS'){
                location.reload();
            }else if(!response.getReturnValue()){
                alert("Unexpected error occured!");
            }
        });
        $A.enqueueAction(checkIfOptedIn);
        component.set("v.doneLoading", false);
    }
})