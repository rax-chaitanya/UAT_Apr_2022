({
    getChildRecors: function(component, event) {
        
        var action = component.get('c.getACRs');
        action.setParams({
            "ParentId": component.get("v.recordId")
        });
        action.setCallback(this, function(actionResult) {
            var state = actionResult.getState();
            if (state == 'SUCCESS') {
                
                component.set('v.ChildRecordList', actionResult.getReturnValue());
              
            }
        });
        $A.enqueueAction(action);
    },
 
    updateSelectedHelper: function(component, event, childRecordsIds) {
        
        var action = component.get('c.updateSelectedACRs');
 		
        action.setParams({
            "ParentId": component.get("v.recordId"), 
            "lstOfContactIds": childRecordsIds
        });
 
        action.setCallback(this, function(actionResult) {
           
            var state = actionResult.getState();
            
            if (state == 'SUCCESS') {
               
                alert('Selected Account Contact Roles Address has been updated');
                 
              
                
                $A.get('e.force:refreshView').fire();
                
                
                this.getChildRecors(component,event);
                  
            }else { 
				alert("failed to update Account Contact Roles Address"); 
		}
        });
        $A.enqueueAction(action);
    },
})