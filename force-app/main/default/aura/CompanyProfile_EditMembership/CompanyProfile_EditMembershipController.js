({
     init: function(component,event,helper) {
          var action = component.get("c.getCompanyProfile");
            action.setCallback(this,function(response){  
            var retval = response.getReturnValue();
                if(retval!=''){
                    //alert(JSON.stringify(retval));
            component.set("v.PartnerCompany",retval);
            }
          });
        $A.enqueueAction(action);
        
         helper.fetchuserprofile(component, event, helper); 
         
    },
     openmodal:function(component,event,helper) {
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');  
    }, 
    closeModal:function(component,event,helper){ 
        
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop'); 
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        $A.get('e.force:refreshView').fire();
    },
    doSave : function(component, event, helper) {
        var selectedValue = component.find("MemberShipLevel");
        var selectedMembershiplevel = selectedValue.get("v.value");
        helper.updateHeadlineWithContractType(component, event, helper, selectedMembershiplevel); 
    },
     onPicklistChange: function(component, event, helper) {
        var selectedValue = component.find("MemberShipLevel");
        var selectedMembershiplevel = selectedValue.get("v.value");
        helper.fetchheadline(component, event, selectedMembershiplevel);
    }
    
})