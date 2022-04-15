({
	getToAgreeUrls : function(component, event) {
       
		var action = component.get('c.getPreviewUrls');
        var self = this;
        action.setCallback(this, function(actionResult) {
            var state = actionResult.getState();
            if (state == 'SUCCESS') {
                if(actionResult.getReturnValue() == null){
                    
                    //toAgreeAgreementsSize = 1;
                    //component.set("v.toAgreesize",toAgreeAgreementsSize);
                    
                   
                }
                
                component.set('v.previewUrls', actionResult.getReturnValue());
                    
            }
            else{
                alert('Something went wrong .Please try again or Contact System Admin for the same.Thanks');
            } 
        });
        $A.enqueueAction(action);
	},
    getAgreedUrls : function(component, event){
        var action1 = component.get('c.getPreviewedUrls');
        action1.setCallback(this, function(actionResult) {
            var state = actionResult.getState();
            if (state == 'SUCCESS') {
                if(actionResult.getReturnValue() == null){
                    //AgreedagreementsSize = 1;
                    //component.set("v.agreedSize",AgreedagreementsSize);
                }
               
                 component.set('v.previewedUrls', actionResult.getReturnValue());
          
            }
            else{
                alert('Something went wrong .Please try again or Contact System Admin for the same.Thanks');
            }
        });
        $A.enqueueAction(action1);
        
    },
    disableTab : function(component, event){
      
        var action2 = component.get('c.disablePilotAgreementTab');
        var self = this;
        action2.setCallback(this, function(actionResult) {
            var state = actionResult.getState();
            if (state == 'SUCCESS') {
             
                     
            }
           
        });
        $A.enqueueAction(action2);
    }
})