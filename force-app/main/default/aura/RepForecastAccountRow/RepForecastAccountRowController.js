({
    edit: function(component, event, helper) {
		helper.toggleRowSelected(component);         
        
        var edit_row = component.find('edit-row');
        
        $A.util.toggleClass(edit_row, 'slds-transition-hide');
        
        var rep_forecast_accounts = component.find("rep-forecast-account");        
        
        
        //var stuff = [];
        for (var i = 0; i < rep_forecast_accounts.length;  ++i) {
            var acc = rep_forecast_accounts[i];
            
            //console.log(acc.get("v.clicked"));
            acc.set("v.clicked", true);
            //console.log(acc.get("v.rev_forecast"));
            //stuff.push(acc.get("v.rev_forecast"));
        }
    },
    
    cancel: function (component, event, helper) {
        helper.resetRowHelper(component, event, helper);
    },
    
    save: function (component, event, helper) {
        //save all in the row
        helper.upsertHelper(component, event, helper);
    }        
   
    
})