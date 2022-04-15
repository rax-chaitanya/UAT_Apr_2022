({
    
    getCompanyHelper : function(component, resolve, reject) {
        console.log('Queueing getCompany');
        var getCompany = component.get("c.getCompany");
        
        getCompany.setParams({
            recordId	: 	component.get("v.recordId")
        });
        
        getCompany.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.set("v.record", response.getReturnValue());    
                
                if (resolve) {
                    resolve("doInitHelper success");
                }
            } else {
                if (reject) {
                    reject("doInitHelper failed");
                }
                
                
            }
        });
        console.log('Queueing getCompany');
        $A.enqueueAction(getCompany);        
    },
    
    
    validateId : function (component, resolve, reject) {
        
        var recordId = component.get("v.recordId");
        
        if ( (recordId.length == 15 || recordId.length == 18 ) && recordId.startsWith("001") ) {
            resolve("validateId was successful");
        } else {
            throw new Error("Invalid Id");
            reject ("validateId was unsuccessful");
        }
        
    },
    
    
    getUserRecordAccessHelper : function (component, resolve, reject) {
        var getUserRecordAccess = component.get("c.getUserRecordAccess");
        
        getUserRecordAccess.setParams({
            recordId	: 	component.get("v.recordId")
        });
        
        getUserRecordAccess.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                console.log(response.getReturnValue());
                component.set("v.userRecordAccess", response.getReturnValue());
                
                if (resolve) {
                    resolve("getUserRecordAccessHelper success");
                }
                
            } else {
                alert(response.getError());
                
                if (reject) {
                    reject("getUserRecordAccessHelper success");
                }
                
                
            }
        });
        console.log('Queueing getUserRecordAccess');
        $A.enqueueAction(getUserRecordAccess);  
        
    },
    
    
    requestAccess : function (component, resolve, reject) {
        console.log('Queueing requestAccess');
        var requestAccess = component.get("c.requestAccess");
        
        requestAccess.setParams({
            recordId	: 	component.get("v.recordId")
        });
        
        requestAccess.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.set("v.pendingAP", response.getReturnValue());    
                
                if (resolve) {
                    component.set("v.pressed", true);
                    alert("You have successfully requested access to " + component.get("v.record.Name"));
                    resolve("requestAccess success");
                }
            } else {
                alert("There was an error. Please try again.");
                if (reject) {
                    reject("requestAccess failed");
                }
                
                
            }
        });
        console.log('Queueing requestAccess');
        $A.enqueueAction(requestAccess);           
        
        
    },
    
    
    
    
    
    
    findProcessInstanceHelper : function(component, resolve, reject) {
        console.log('Queueing findProcessInstance');
        var findProcessInstance = component.get("c.findProcessInstance");
        
        findProcessInstance.setParams({
            recordId	: 	component.get("v.recordId")
        });
        
        findProcessInstance.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.set("v.pendingAP", response.getReturnValue());    
                
                if (resolve) {
                    resolve("findProcessInstance success");
                }
            } else {
                alert(response.getError());
                if (reject) {
                    reject("findProcessInstance failed");
                }
                
                
            }
        });
        console.log('Queueing findProcessInstance');
        $A.enqueueAction(findProcessInstance);               
        
    },
    
    showMessage : function (component, title, message, severity) {
        $A.createComponents
        (
            [
                ["ui:message",{
                    "title" : title,
                    "closable" : true,
                    "severity" : severity,
                }],
                ["ui:outputText",{
                    "value" : message
                }]
            ],
            function(components, status, errorMessage){
                if (status === "SUCCESS") {
                    var message = components[0];
                    var outputText = components[1];
                    // set the body of the ui:message to be the ui:outputText
                    message.set("v.body", outputText);
                    var div1 = component.find("div1");
                    // Replace div body with the dynamic component
                    div1.set("v.body", message);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                    // Show offline error
                }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                        // Show error message
                    }
            }
        );            
    }
    ,    
    
    goBackHelper : function (component) {
        console.log('Queueing goBack');
        var goBack = component.get("c.goBack");
        
        goBack.setParams({
            recordId	: 	component.get("v.recordId")
        });
        
        goBack.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                window.open(response.getReturnValue(), "_self"); 
                
            } else {
                alert(response.getError());
                
                
            }
        });
        console.log('Queueing goBack');
        $A.enqueueAction(goBack);               

        
    }
    
    ,
    promise : function(component, helperFunction) {
        return new Promise($A.getCallback(function(resolve, reject) {
            helperFunction(component, resolve, reject);
        }));
    }    
})