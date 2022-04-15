({
    showSpinner : function(component) {
        var targetCmp = component.find('spinner');
        $A.util.removeClass(targetCmp, 'slds-hide');
        $A.util.addClass(targetCmp, 'slds-show');
    },
    
    hideSpinner : function(component) {
        var targetCmp = component.find('spinner');
        $A.util.removeClass(targetCmp, 'slds-show');
        $A.util.addClass(targetCmp, 'slds-hide');
    },
    
    showError : function(component, message){
        component.set("v.Message", message);
        component.set("v.hasMessage", true);
        component.set("v.severity", "error");
    },
    
    showMessage : function(component, message){
        component.set("v.Message", message);
        component.set("v.hasMessage", true);
        component.set("v.severity", "message");
    },
})