({
	doInit : function(component, event, helper) {
		helper.doFetchLead(component);
	},
    next: function (component, event, helper) {
        helper.next(component, event);
    },
    previous: function (component, event, helper) {
        helper.previous(component, event);
    },
})