({
	showSpinner : function(component) {
		var spinner = component.find("spinner");
        $A.util.removeClass(spinner, 'slds-hide');    
	},
   
    hideSpinner : function(component) {
		var spinner = component.find("spinner");
        $A.util.addClass(spinner, 'slds-hide');
	},
    
    pollToRedirect : function(component, contactId){
        console.log('polling');
        console.log(contactId);
        var redirectionPolling = component.get("c.redirectionPolling");
        redirectionPolling.setParams({
            "contactId" : contactId
        });
        redirectionPolling.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                console.log(response.getState());
                console.log(response.getReturnValue());
                if(response.getReturnValue()){
                    console.log("Inside the If block");
                    window.location.href = '/partners/s/detail/'+contactId;
                }else{
                    console.log("Insife Else block");
                    this.pollToRedirect(component, contactId);
                }
            }else{
                window.location.href = '/partners/s/detail/'+contactId;
            }
        });
        
        $A.enqueueAction(redirectionPolling);
    }
})