({
    renderer:function(component,event,helper){
        this.superRerender();
alert('rerender');
       var action = component.get("c.getOnboarding");
        action.setCallback(this,function(response){
            
            var retval = response.getReturnValue();
            alert(retval);
            if(retval <= 2){
              
                window.location.reload();// = '/partners/s/partner-onboarding';
                
            }
        });
        $A.enqueueAction(action);
    }
    
})