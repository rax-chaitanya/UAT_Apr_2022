({
    doInit: function(component, event, helper) {
        //invokingand getting deta from  getOpportunityDeta method
        //alert('From OppCompany RecordId:' + component.get("v.recordId"));            
        if(!$A.util.isUndefinedOrNull(component.get("v.recordId"))){
            var compId = component.get("v.recordId");
            var action = component.get("c.getOpportunityDeta");
            action.setParams({
                "companyid":compId
            }); 
            //alert('companyid'+compId);
            action.setCallback(this, function(response) {
                if(!$A.util.isUndefinedOrNull(response.getReturnValue())){
                    var result = response.getReturnValue();
                    //console.log('result-----'+JSON.stringify(result));
                    if(!$A.util.isUndefinedOrNull(result.pipelinesCeated)){
                        component.set("v.PipelinesCreated", result.pipelinesCeated);  	
                    }
                    if(!$A.util.isUndefinedOrNull(result.openPipeLines)){
                        component.set("v.OpenPipelines", result.openPipeLines); 
                    }
                    if(!$A.util.isUndefinedOrNull(result.bookedlines)){
                        component.set("v.Bookings", result.bookedlines);
                    }
                    //console.log('PipelinesCreated-----'+JSON.stringify(component.get("v.PipelinesCreated"))+','+JSON.stringify(component.get("v.OpenPipelines"))+','+JSON.stringify(component.get("v.Bookings")));
                }
            })
            $A.enqueueAction(action);
        }   
    }
})