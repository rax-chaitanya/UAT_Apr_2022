({
    doInit : function(component, event, helper) {
        
        try{
            var action = component.get("c.checkAccess");
            
            action.setParams({"recordId":component.get("v.recordId")});
            action.setCallback(this,function(response){
                helper.hideSpinner(component);
                //console.log("checkAccess : "+JSON.stringify(response.getReturnValue()));
                if(response.getState() === "SUCCESS"){
                    var returnValue = response.getReturnValue();
                    component.set("v.Action",returnValue.Action);
                    if(returnValue.Action == 'None'){
						component.set("v.message", returnValue.Message);
					}
					if(returnValue.Action == 'Error'){
						component.set("v.message", returnValue.Message);
					}
					if(returnValue.Action == 'Select Role'){
						//Select role
						component.set("v.message", returnValue.Message);
					}
                }
             
             else
                    component.set("v.message","Something went wrong please try again..Thank you.");
            
            });
            $A.enqueueAction(action);
            helper.showSpinner(component);
            var action1 = component.get("c.getTeamMemberRoles");
            var recordId = component.get("v.recordId");
            action1.setParams({"oppId" : recordId});
            action1.setCallback(this,function(response){
                helper.hideSpinner(component);
                //console.log("getTeamMemberRoles : "+JSON.stringify(response.getReturnValue()));
                if(response.getState() === "SUCCESS")
                    component.set("v.roles",response.getReturnValue()); 
            });
            
            $A.enqueueAction(action1);
            helper.showSpinner(component);
        }catch(e){
            alert(e);
            console.log(e);
        }
    },
    
    requestforApproval:function(component, event, helper){
        
        var action = component.get("c.submitForApproval");
        var teamRole =component.get("v.teamRole");
       
        
        if(teamRole == ''){
            alert('Please select a Role');
            return;
        }
        if(teamRole)
        action.setParams({"recordId":component.get("v.recordId"),"teamRole":teamRole});
        action.setCallback(this,function(response){
            helper.hideSpinner(component);
            //console.log("submitForApproval : "+JSON.stringify(response.getReturnValue()));
            if(response.getState() === "SUCCESS"){
                //component.set("v.message",response.getReturnValue());
                var returnValue = response.getReturnValue();
                    component.set("v.Action",returnValue.Action);
                    if(returnValue.Action == 'None'){
						component.set("v.message", returnValue.Message);
					}
					if(returnValue.Action == 'Error'){
						component.set("v.message", returnValue.Message);
					}
               
            }
                 
            
        });
        $A.enqueueAction(action);
        helper.showSpinner(component);
    },
})