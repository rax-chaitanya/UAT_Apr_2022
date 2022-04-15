({
	getEnforcedAgreements: function(component, event) {
        
        var action = component.get('c.EnforcedAgreements');
        action.setParams({
            "AccountId": component.get("v.recordId")
          
        });
        action.setCallback(this, function(actionResult) {
            var state = actionResult.getState();
            if (state == 'SUCCESS') {
                var result = actionResult.getReturnValue();
                if(result == null){
                    alert('There is no enforced pilot agreement available to remove');
                     $A.get("e.force:closeQuickAction").fire();
                }
                else{
                    component.set('v.AgreementsList', result);
                }
                
                
            }
            else{
                alert('Something went wrong .Please try again or Contact System Admin for the same.Thanks')
            }
        });
        $A.enqueueAction(action);
    },
    
    removeSelectedAgreements : function(component, event, agreementIds) {
       // alert('Id'+component.get("v.recordId"));
        //alert('AgreementIds'+agreementIds);
        var action = component.get('c.RemoveSelectedAgreements');
        
        action.setParams({
            "AccountId": component.get("v.recordId"),
            "listOfAgreementids": agreementIds
        });
        
        action.setCallback(this, function(actionResult) {
            
            var state = actionResult.getState();
            
            if (state == 'SUCCESS') {
                
                alert('Selected Pilot Agreements has been Removed successfully.');
                
                
                
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();
                
                
                
            }else { 
                alert("Something went wrong .Please try again or Contact System Admin for the same.Thanks"); 
            }
        });
        $A.enqueueAction(action);
    },

})