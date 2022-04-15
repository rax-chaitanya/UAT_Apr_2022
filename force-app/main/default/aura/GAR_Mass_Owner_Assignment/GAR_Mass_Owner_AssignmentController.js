({
    close : function(component, event, helper) {
        component.set("v.showMassOwnerAssignmentModal", false);
    },
    
    assignOwner : function(component, event, helper) {
        var owner = component.get("v.owner");
        console.log('owner : '+JSON.stringify(owner));
        if(owner == null){
            var message = 'Please select a new Owner';
            var title = 'Error';
            var type='error';
            helper.showMessage(component,type,title,message);            
            return;
        }
        var companies = component.get("v.companies");
        for(var companyIndex in companies){
            var company = companies[companyIndex];
            for(var accountIndex in company.Account_Info){
                var account = company.Account_Info[accountIndex];
                if(account.selected){
                    account.Request_Item_New_Owner = owner;
                }
            }
        }
        component.set("v.companies", companies);
    },
    
    assignReason : function(component, event, helper) {
        var selectedReason = component.get("v.selectedReason");
        console.log('selectedReason : '+JSON.stringify(selectedReason));
        if(selectedReason == null || selectedReason == ""){
            var message = 'Please select a reason';
            var title = 'Error';
            var type='error';
            helper.showMessage(component,type,title,message);
            return;
        }
        var companies = component.get("v.companies");
        for(var companyIndex in companies){
            var company = companies[companyIndex];
            for(var accountIndex in company.Account_Info){
                var account = company.Account_Info[accountIndex];
                if(account.selected){
                    account.Request_Item_Reason = selectedReason;
                }
            }
        }
        component.set("v.companies", companies);
    },
    assignMoveDate : function(component, event, helper) {
        var moveDate = component.get("v.defaultDate");
        if($A.util.isEmpty(moveDate)){
            var message = 'Please select a Move Date';
            var title = 'Error';
            var type='error';
            helper.showMessage(component,type,title,message);
            return;
        }
        var companies = component.get("v.companies");
        for(var companyIndex in companies){
            var company = companies[companyIndex];
            for(var accountIndex in company.Account_Info){
                var account = company.Account_Info[accountIndex];
                if(account.selected){
                    account.Request_Item_Move_Date = moveDate;
                }
            }
        }
        component.set("v.companies", companies);
    },
})