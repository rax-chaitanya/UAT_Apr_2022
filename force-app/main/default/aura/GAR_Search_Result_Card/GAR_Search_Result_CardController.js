({
	onCompanySelectUnselect : function(component, event, helper) {
		var company = component.get("v.company");
        var selected = company.selected ==true ? true : false;
        for(var accountIndex in company.Account_Info){
            var account = company.Account_Info[accountIndex];
            account.selected = selected;
        }
        component.set("v.company",  company);
	},
    
    onAccountSelectUnselect : function(component, event, helper) {
		var company = component.get("v.company");
        var selected = event.target.checked ? true : false;
        company.selected = selected;
        component.set("v.company",  company);
        console.log('company : '+JSON.stringify(company));
	},
    
    recalculateCheckbox : function(component, event, helper) {
        console.log("calling recalculateCheckbox");
        var recalculateCheckbox = component.get("v.recalculateCheckbox");
        if(recalculateCheckbox){
            var company = component.get("v.company");
            var result = true;
            if(company==null){
                return;
            }
            for(var accountIndex in company.Account_Info){
                var account = company.Account_Info[accountIndex];
                result = result && account.selected;
            }
            company.selected = result;
            component.set("v.company",  company);
        }
        component.set("v.recalculateCheckbox", false);
    }
})