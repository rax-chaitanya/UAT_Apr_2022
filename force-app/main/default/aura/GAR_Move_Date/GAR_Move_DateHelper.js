({
	hideSpinner : function(component) {
		var spinner = component.find("spinner");
        $A.util.addClass(spinner, 'slds-hide');
	},
    
    showSpinner : function(component) {
		var spinner = component.find("spinner");
        $A.util.removeClass(spinner, 'slds-hide');
	}
})