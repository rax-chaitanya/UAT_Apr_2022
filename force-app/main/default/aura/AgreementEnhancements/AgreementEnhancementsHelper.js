({
    getPartnerLevel : function(component, event,helper) {
  	 var action = component.get('c.PartnerLevelValid');
        action.setParams({
            "AccountId": component.get("v.recordId")
        });
         action.setCallback(this, function(actionResult) {
           if(actionResult.getReturnValue() == "show"){
               component.set("v.hideAgr",false);
                helper.getAgreements(component,event);
           }else if(actionResult.getReturnValue() == "uncontract"){
               alert('Please select appropriate contract type & partnerlevel to proceed');
                     $A.get("e.force:closeQuickAction").fire();
           }else if(actionResult.getReturnValue() == "inactive"){
               alert('Contract Status should be \'Active\' to proceed');
                     $A.get("e.force:closeQuickAction").fire();
           }else if(actionResult.getReturnValue() == "hide"){
               alert('This feature is available only for strategic partners');
                     $A.get("e.force:closeQuickAction").fire();
               
                //component.set("v.hideAgr",true);
            }
         });
         $A.enqueueAction(action);        
    },
	getAgreements: function(component, event) {
        var action = component.get('c.getAttachment');
        action.setParams({
            "AccountId": component.get("v.recordId")
          
        });
        action.setCallback(this, function(actionResult) {
            var state = actionResult.getState();
            if (state == 'SUCCESS') {
                var result = actionResult.getReturnValue();
                if(result== null){
                    alert('There is no agreement available to add');
                     $A.get("e.force:closeQuickAction").fire();
                }
                else{
                    component.set('v.AgreementsListAdd', result[0]);
                    component.set('v.AgreementsListRemove', result[1]);
                }
                
            }
            else{
                
                
                alert('Something went wrong .Please try again or Contact System Admin for the same.Thanks')
            }
            
        });
        $A.enqueueAction(action);
    },

     enforceSelectedAgreements : function(component, event, agreementIds) {
        var action = component.get('c.updateSelectedAgreements');
         var Account = {}; 
        action.setParams({
            "AccountId": component.get("v.recordId"),
            "listOfAgreementids": agreementIds
        });
        
        action.setCallback(this, function(actionResult) {
            
            var state = actionResult.getState();
            
            if (state == 'SUCCESS') {
                
                alert('Selected Agreement has been added successfully.');
                
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();
                
                
                
            }else { 
                alert("Something went wrong .Please try again or Contact System Admin for the same.Thanks"); 
            }
        });
        $A.enqueueAction(action);
    },
       removeSelectedAgreements : function(component, event, agreementIds) {
        var action = component.get('c.updateSelectedAgreementsRemove');
        
        action.setParams({
            "AccountId": component.get("v.recordId"),
            "listOfAgreementids": agreementIds
        });
        
        action.setCallback(this, function(actionResult) {
            
            var state = actionResult.getState();
            
            if (state == 'SUCCESS') {
                
                alert('Selected Agreement has been Removed successfully.');
                
                
                
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();
                
                
                
            }else { 
                alert('Selected Agreement is not added'); 
            }
        });
        $A.enqueueAction(action);
    },
})