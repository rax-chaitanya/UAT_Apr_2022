({
    getRaxInfo : function(component,event,helper) {
        var action = component.get("c.raxinfo");
        action.setCallback(this,function(response){
            
            var retval = response.getReturnValue();
            
            if(retval == 'NotSigned'){
             
                 window.location.href = '/'+$A.get("$Label.c.PartnerPortalName")+'/Onboarding';
               /*var address = '/partner-onboarding';
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                      "url": address,
                      "isredirect" :true
                    });
   				 urlEvent.fire();*/
            
               
                
               //  // window.location = '/partnerOnboaring.app/';
               //c/AccRedirect.app?accountNumber
                
            }else{
                component.set("v.Info",retval); 
            }
            
        });
        $A.enqueueAction(action);
    }
})