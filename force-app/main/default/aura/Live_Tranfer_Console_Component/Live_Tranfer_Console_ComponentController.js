({
    doInit : function(component,event,helper) {
        var action= component.get("c.getStatus");
        action.setCallback(this,function(response){
            var state= response.getState();
            $A.log(response);
            if(state == "SUCCESS"){
                if(response.getReturnValue()==true)
                    component.set("v.checked",true);
                else
                    component.set("v.checked",false);
            }
            else if(state === "ERROR"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"Error",
                    "title":"Error",
                    "message": "Some Error Occured.Please Contact your System Admin" 
                });
                toastEvent.fire();
            }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"Error",
                        "title":"Error",
                        "message": "Please try after complete Page Load." 
                    });
                    toastEvent.fire();
                }
        });
        $A.enqueueAction(action);
    },
    doUpdateStatus : function(cmp, event, helper) {
        //var checkbox = document.getElementById('checkbox-indeterminate-01');
        //alert('checkbox'+checkbox)
        console.log("toggled"+cmp.find("toggle").getElement().checked);
        var action = cmp.get("c.createUpdateLiveTransfer");
        var statusValue=cmp.find("toggle").getElement().checked;
        //console.log('status'+cmp.find("sta").get("v.value"));
        action.setParams({ status :  statusValue?"online":"Away"});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("Suucess");
                console.log("From server: " + JSON.stringify(response.getReturnValue()));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": response.getReturnValue().isSuccess?"success":"warning",
                    "title": response.getReturnValue().isSuccess?"success":"warning",
                    "message": response.getReturnValue().message 
                });
                toastEvent.fire();
                if(!response.getReturnValue().isSuccess)
                    cmp.find("toggle").getElement().checked = false;
            }
            else if(state === "ERROR"){
                console.log('Error');
                console.log("From server: " + response.getReturnValue());
            }
                else{
                    console.log('Unknown Error');
                }
        });
        $A.enqueueAction(action);
    }
    
})