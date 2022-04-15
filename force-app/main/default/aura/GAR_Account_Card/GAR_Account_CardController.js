({
    handleSelectedChange : function(component, event, helper) {
        var account = component.get("v.account");
        component.set("v.recalculateCheckbox", true);
    },
    
    handleOppChange : function(component, event, helper) {
        var account = component.get("v.account");
        var oppFlag = component.find("chck");
    }
    
})