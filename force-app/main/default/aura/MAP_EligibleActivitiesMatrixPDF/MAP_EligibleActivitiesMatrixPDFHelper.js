({
    
    getAgreements : function(component,event,helper){ 
        var action = component.get("c.getPDFDocument");
        console.log('in getPDF method');
        action.setParams({ });
        action.setCallback(this,function(response){
            var returnvalue = response.getReturnValue();
            if(returnvalue != null){
                console.log(returnvalue);
                component.set("v.contentDocs",returnvalue);
            } 
        });
        $A.enqueueAction(action);
    }
})