({
	doInit : function(component, event, helper) {
        var d = new Date();
		component.set("v.copyrightYear", d.getFullYear());
	}
})