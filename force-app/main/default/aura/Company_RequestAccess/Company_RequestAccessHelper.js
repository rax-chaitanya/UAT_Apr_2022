({
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // @developer   :    Diego Castro
    // @date        :    01/07/2018
    // @story       :    Lightning Migration Epic for 02/19/17 release
    // @description :    at the time of writing this, there was no global value provider to pull user info.
    // 					 this means that any user info (like Profile Id) must be grabbed from a server trip.
    // 					 this method grabs user info that pertains to validating whether or not a given user 
    // 					 will be able to get to the CW wizard. 
    // 					 - related apex class: NavigateCWWizardController.apxc
    //////////////////////////////////////////////////////////////////////////////////////////////////    
    getUserRecordAccess : function(component, resolve, reject) { 
        console.log("getting the user record access");
        var action = component.get("c.getUserRecordAccess");
        
        
        console.log("recordId: " + component.get("v.recordId"));
        action.setParams({
            recordId	: component.get("v.recordId")
        });
        
        console.log("got here");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.set("v.userRecordAccess", response.getReturnValue() );
                
                if(resolve) {
                    console.log('resolving getting user info');
                    resolve('succeeded');
                }
            } else {
                console.log(response.getError());
                if(reject) {
                    console.log('rejecting getting the user record access action');
                    reject(Error(response.getError()[0].message));
                }
            }
        });
        console.log('Queueing getting the user record access');
        $A.enqueueAction(action);
    },  
    
    
    
    validate	: function(component, resolve, reject) {
        console.log("getting the process isntance");
        var action = component.get("c.getProcessInstance");
        action.setParams({
            recordId	: component.get("v.recordId")
        });
        
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                
                var ura = component.get("v.userRecordAccess");
                
                var errors  = [];
                
                console.log("user record access is below!!!");
                console.log(ura);
                console.log("the process instnace is below!!!");
                console.log(response.getReturnValue());
                
                
                
                if (ura.HasEditAccess) {   
                    errors.push("You already have edit access to the company. No approval request is necessary.");
                    //component.set("v.recordError", );
                } else if (response.getReturnValue().length == 1 && response.getReturnValue()[0].CreatedBy) 
                {
                    console.log("the length is 1 for process instance...");
                    errors.push("User " + (response.getReturnValue())[0].CreatedBy.Name + " has already placed this company in an approval process. Please wait until it has been approved or rejected.");                    
                    //component.set("v.recordError", "User " + (response.getReturnValue())[0].CreatedBy.Name + " has already placed this company in an approval process. Please wait until it has been approved or rejected.");
                } 

                
                if (errors.length > 0) {
                    console.log("errors");
                    console.log(errors);
                    component.set("v.recordError", errors.join("\n"));
                    
                    errors.forEach(function (e) {
                        var toastEvent = $A.get("e.force:showToast");
                        
                        toastEvent.setParams({
                            title: 'Error',
                            type: 'error',
                            message: e
                        });
                        
                        toastEvent.fire();                            
                        
                    });
                       
                    
                }
                
                
                
                if(resolve) {
                    console.log('resolving getting the process instance');
                    resolve('succeeded');
                }
            } else {
                console.log(response.getError());
                if(reject) {
                    console.log('rejecting getting the process instance');
                    reject(Error(response.getError()[0].message));
                }
            }
        });
        console.log('Queueing getting the process instance');
        $A.enqueueAction(action);
        
        
    },
    
    
    navigateToURL: function(component, event) {
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            // check to make sure the recordId is case safe at 18 digits
            "url": "/c/RequestCompanyAccess.app?recordId=" + component.get("v.recordId")
        });
        urlEvent.fire();              
        
    }
})