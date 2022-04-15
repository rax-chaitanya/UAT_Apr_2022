({
    init: function(component,event,helper) {
        helper.fetchuserprofile(component, event, helper); 
    },
    closeModal:function(component,event,helper){ 
        
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop'); 
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        $A.get('e.force:refreshView').fire();
    },
    openmodal:function(component,event,helper) {
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
    }, 
    
    doSave : function(component, event, helper) {
        var selectedValue = component.find("ContractType");
        var selectedContractType = selectedValue.get("v.value");
        helper.updateHeadlineWithContractType(component, event, helper, selectedContractType);
        
        
    },
    onPicklistChange: function(component, event, helper) {
        var selectedValue = component.find("ContractType");
        var selectedContractType = selectedValue.get("v.value");
        helper.fetchheadline(component, event, selectedContractType);
    }
})