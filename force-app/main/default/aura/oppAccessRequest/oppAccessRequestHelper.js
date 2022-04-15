({
	getRoles : function(component) {
		 var action1 = component.get("c.getTeamMemberRoles");
        action1.setParams({});
        action1.setCallback(this,function(response){
            helper.hideSpinner(component);
            //console.log("getTeamMemberRoles : "+JSON.stringify(response.getReturnValue()));
            if(response.getState() === "SUCCESS")
               component.set("v.roles",response.getReturnValue()); 
        });
        $A.enqueueAction(action);
        helper.showSpinner(component);
	},
    
    getStatus: function(component){
        var action = component.get("c.checkAccess");
        var action = component.get("c.submitForApproval");
        action.setParams({"recordId":component.get("v.recordId"),"teamRole":teamRole});
        
        action.setCallback(this,function(response){
            helper.hideSpinner(component);
            //console.log("submitForApproval : "+JSON.stringify(response.getReturnValue()));
            if(response.getState() === "SUCCESS"){
                    var returnValue = response.getReturnValue();
                //console.log(response.getReturnValue());
                    component.set("v.Action",returnValue.Action);
                    if(returnValue.Action == 'None'){
						component.set("v.message", returnValue.Message);
					}
					if(returnValue.Action == 'Error'){
						component.set("v.message", returnValue.Message);
					}
                
					
            }else 
                component.set("v.message","Something went wrong please try again..Thank you.");
        });
    },
    
    showSpinner : function(component){
        var spinner = component.find("spinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    hideSpinner : function(component){
        var spinner = component.find("spinner");
        $A.util.addClass(spinner, "slds-hide");
    }
})