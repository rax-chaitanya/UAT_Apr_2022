({
    doInit : function(component, event, helper) {
        helper.getOwnedAccounts(component);
        helper.getForecastedDates(component);		// helper method to get the headers of the forecasted dates
    },
    
    changeHovered: function(component, event, helper) {
        alert("hello world");
        var button_name = event.getSource().get("v.name");        
        alert(button_name);
        helper.setHoveredHelper(component);
        
    },


    handle: function(component, event, helper) {
        console.log("stopping propagation");
        event.stopPropagation();
        
    },    
    
    sendClick: function(component, event, helper) {
        console.log('sendClick');

        
        component.set("v.selected", !component.get("v.selected"));        
        
    },
    
    
    showSpinner: function(component, event, helper) {
        helper.showHelper(component, event);
    },
    

    hideSpinner: function (component, event, helper) {
        helper.hideHelper(component, event);
    },    
    
        
    edit: function (component, event, helper) {
        helper.editHelper(component);
        helper.toggleButtonGroup(component, event, helper);        
    },
    
    save: function (component, event, helper) {
        	helper.upsertHelper(component);
            helper.toggleButtonGroup(component, event, helper);               
            helper.getOwnedAccounts(component);                        
    },
    cancel: function(component, event, helper) {
        helper.getOwnedAccounts(component);
        helper.toggleButtonGroup(component, event, helper);        
    }
    
    
    
    
    
}      
 
 })