({
    rerender : function(component, helper) {
   		this.superRerender();
        var companyval = component.get("v.PartnerCompany");
        var once = component.get("v.static");
        if( companyval!=null){
            if(once ==1){
                component.set("v.static",2);
                component.set("v.name",companyval.Name);
                component.set("v.description",companyval.Description);
                component.set("v.city",companyval.BillingCity);
                component.set("v.state",companyval.BillingState);
                component.set("v.country",companyval.BillingCountry);
                component.set("v.website",companyval.Website);
            }
    	}
    }
})