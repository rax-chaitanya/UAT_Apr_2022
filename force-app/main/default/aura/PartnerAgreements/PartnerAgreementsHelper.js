({
    getAgreementsHandler :  function(component, event) {
        var agrree = component.get('c.getAgreements');
        //action.setParams({});
        agrree.setCallback(this, function(response) {
            //var state = actionResult.getState();
            //alert(actionResult.getState());
            var state = response.getState();
            console.log("STATE"+state);
            console.log(response.getState());
            console.log(response.getReturnValue());
           if (response.getState() === 'SUCCESS') {
                var result = response.getReturnValue();
            
                component.set("v.Us_Reseller", result.Us_Reseller);
                component.set("v.Us_Referral", result.Us_Referral);
                component.set("v.Intl_reseller", result.Intl_Reseller);
                component.set("v.Intl_referral", result.Intl_Referral);
                component.set("v.Intl_str", result.Intl_Strategic);  
           }
            else{
               alert('Something went wrong .Please try again or Contact System Admin for the same.Thanks1');
            } 
        });
        $A.enqueueAction(agrree);
    }
})