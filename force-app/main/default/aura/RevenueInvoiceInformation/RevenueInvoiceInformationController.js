({
    doInit : function(component, event, helper) 
    {
        console.log('initializing header... with record id: ' + component.get("v.recordId"));
        var serialize = component.get("c.serialize");
        serialize.setParams({
            recordId: component.get("v.recordId")
        });
        
        serialize.setCallback(this, function(response) {
            var state = response.getState();
            console.log('stateValue: ' + state);
            if (state == 'SUCCESS') {
                if(!$A.util.isUndefinedOrNull(response.getReturnValue()) &&
                   !$A.util.isEmpty(response.getReturnValue())){                    
                    var objMap = [];
                    objMap = JSON.parse(response.getReturnValue());
                    for(var key in objMap){
                        component.set("v.objType",key);
                        component.set("v.sObj", JSON.stringify(objMap[key]));
                        component.set("v.record", objMap[key]);    
                    }				             
                }                    
            }
            else {
                console.log("Error at information init");
            }
        });
        $A.enqueueAction(serialize); 
        
        
    },
    handleApplicationEvent : function (component, event, helper) {
        var record = event.getParam("record");
        console.log("the record from fired event");
        console.log(record);
        
        // set the handler attributes based on event data
        component.set("v.information", record);
    },
    
    showSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();
    },
    
    hideSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : false });
        evt.fire();
    }
    
    
})