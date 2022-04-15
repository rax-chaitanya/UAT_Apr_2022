({
    getAgreements: function(component, event) {
        
        var action = component.get('c.getAgreements');
        action.setParams({
            "AccountId": component.get("v.recordId")
          
        });
        action.setCallback(this, function(actionResult) {
            var state = actionResult.getState();
            if (state == 'SUCCESS') {
                var result = actionResult.getReturnValue();
                if(result.agreementsList== null){
                    alert('There is no Pilot agreement available or The partner already enforced with maximum of six agreements.');
                     $A.get("e.force:closeQuickAction").fire();
                }
                else{
                    component.set('v.AgreementsList', result.agreementsList);
                }
                component.set('v.count',result.agreementscount);
                
            }
            else{
                alert('Something went wrong .Please try again or Contact System Admin for the same.Thanks')
            }
        });
        $A.enqueueAction(action);
    },
    
    enforceSelectedAgreements : function(component, event, agreementIds) {
       // alert('Id'+component.get("v.recordId"));
        //alert('AgreementIds'+agreementIds);
        var action = component.get('c.updateSelectedAgreements');
        
        action.setParams({
            "AccountId": component.get("v.recordId"),
            "listOfAgreementids": agreementIds
        });
        
        action.setCallback(this, function(actionResult) {
            
            var state = actionResult.getState();
            
            if (state == 'SUCCESS') {
                
                alert('Selected Pilot Agreements has been Enforced successfully.');
                
                
                
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();
                
                
                
            }else { 
                alert("Something went wrong .Please try again or Contact System Admin for the same.Thanks"); 
            }
        });
        $A.enqueueAction(action);
    },
})