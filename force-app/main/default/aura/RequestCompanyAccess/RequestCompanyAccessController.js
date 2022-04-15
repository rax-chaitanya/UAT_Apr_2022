({
    doInit	: function (component, event, helper) {
        helper.promise(component, helper.validateId)            
        .then(function() {
            helper.promise(component, helper.getCompanyHelper)            
        })
        .then(function() {
            return helper.promise(component, helper.getUserRecordAccessHelper)            
        })
        .then(function() {
            //return helper.helperFunctionAsPromise(component, helper.getObjectsFromResult)
        })
        .then(function() {
            console.log('Done, no errors');
        })
        .catch(function(err) {
            helper.showMessage(component,"Error", err.message, "error");

        })
        .then(function() {
            //console.log('A bit like finally');
        });
    },
    
    handleSubmit : function (component, event, helper) {
        
        
        var alreadyPressed = component.get("v.pressed");
        
        if (alreadyPressed) {
            
            
            
        } else {
            
            helper.promise(component, helper.findProcessInstanceHelper)
            .then(function() {
                
                var pendingAP = component.get("v.pendingAP");                        
                console.log(pendingAP);
                if (pendingAP != null) {
                    alert( component.get("v.pendingAP.CreatedBy.Name") +  " has already placed this company in an approval process. Please wait until it has been approved or rejected.");
                    //helper.showMessage(component,"Error", "Someone has already requested", "error");
                    component.set("v.pressed", true);
                    console.log("showed the message");
                } else {
                    
                    helper.promise(component, helper.requestAccess)    
                    .catch(function(err) {

                    })
                    .then(function() {
                        console.log('Finished with helper.requestAccess');
                    });            
                }
            })
            .catch(function(err) {
                console.log(err.message);
            })
            .then(function() {
                console.log('finished with helper.findProcessInstanceHelper');
            });            
            
        }
        
        
    },
    
    goToURL : function (component, event, helper) {
        helper.goBackHelper(component);
    },
    
     close : function (component, event, helper) {
        window.close();
    }
})