({
	handleClick : function(component, event, helper) {
        //var theComp = event.getSource().getLocalId();
        var theComp = component.find("section");
        //alert(theComp);
        $A.util.toggleClass(theComp, 'slds-is-open');
        
        
        var aria_hidden = theComp.get("v.aria-hidden");

		console.log(theComp);
        
        //var myLabel = component.find("button1").get("v.label");
		
	}
})