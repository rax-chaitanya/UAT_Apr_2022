({
    getInput: function (component,event, helper) { 
        var userName = component.find("username").get("v.value"); 
        var password = component.find("password").get("v.value"); 
        component.set("v.userMessage", "");
        component.set("v.pasMessage", "");
        if (userName === undefined || userName === '') {            
            component.set("v.userMessage", "Please enter valid username ");
        }  
        
        if (password === undefined || password === '') {            
            component.set("v.pasMessage", "Please enter valid password ");
        }  
        
        if(userName !== undefined && password !== undefined){
           var action = component.get("c.checkPortal");
            action.setParams({
                username: userName,
                password: password
            });
            // Add callback behavior for when response is received
            action.setCallback(this,function (response) {
                
                var rtnValue =response.getReturnValue();
                
                if (rtnValue !==null && rtnValue === $A.get("$Label.c.Loginfailed")) {
                    component.set("v.loginmessage",'Your login attempt has failed. Make sure <br/> the username and password are correct.');
                }
                else if (rtnValue !==null && rtnValue === $A.get("$Label.c.UsernameTextHide")) {
                    component.set("v.loginmessage",null);
                }
                    else if (rtnValue !==null && rtnValue === $A.get("$Label.c.PasswordTextHide")) {
                        component.set("v.loginmessage",null);
                    }
            });
            
            
            $A.enqueueAction(action);
        }
    },
    EnterKeyPress: function(component, event, helper) {
		if (event.keyCode === 13) {
            var a = component.get('c.getInput');
               $A.enqueueAction(a);
		}
    },
    EnterKeyPress: function(component, event, helper) {
		if (event.keyCode === 13) {
            var a = component.get('c.getInput');
               $A.enqueueAction(a);
		}
    },
    
    showSpinner: function (component,event, helper) {
        component.set("v.Spinner",true);
    },
    hideSpinner: function (component,event, helper) {
        component.set("v.Spinner",false);
    },
})