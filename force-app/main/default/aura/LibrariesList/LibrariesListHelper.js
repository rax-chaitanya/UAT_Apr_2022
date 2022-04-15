({
    
    getLibraries: function(component) {
        
        var action = component.get('c.getLibraries');
        
        // Set up the callback
        var self = this;
        action.setCallback(this, function(actionResult) {
            
            component.set('v.libraries', actionResult.getReturnValue());
            
            
        });
        $A.enqueueAction(action);
        
    }
    
})