({
    validateApprovalAction : function(component, event, helper) {
        console.log('ValidateAction');
        var recordId = component.get("v.recordId");
        var action = component.get("c.validateAction");
        action.setParams({"recordId" : recordId});
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS'){
                var returnValue = response.getReturnValue();
                console.log(JSON.stringify(returnValue));
                if(returnValue.status == 'ERROR'){
                    helper.showError(component, returnValue.message);
                }
            }
            else{
                helper.showError(component, "Something went wrong!");
            }
            helper.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    
    submit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var comments = component.get("v.Comments");
        
        var action = component.get("c.submitForApproval");
        action.setParams({
            "recordId" : recordId,
            "comments" : comments
        });
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS' && response.getReturnValue()){
                helper.showMessage(component, "Record submitted for approval.");
            }else{
                helper.showError(component, "Something went wrong!");
            }
            helper.hideSpinner(component);
        });
        
        $A.enqueueAction(action);
        helper.showSpinner(component);
    },
    
    cancel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire()
    }
})