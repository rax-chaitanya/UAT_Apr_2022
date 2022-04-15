({
    doInit : function(component, event, helper) {
        var assignSeismicLicense = component.get("c.assignSeismicLicense");
        assignSeismicLicense.setCallback(this, function(response){
            if(response.getState()=='SUCCESS'){
                var result = response.getReturnValue();
                if(result.Licensed == false){
                    alert('You do not have permission to access this page. Please contact your administrator.');
                }
                if(result.Refresh == true){
                    location.reload();
                }
            }
        });
        $A.enqueueAction(assignSeismicLicense);
    }
})