({
    doInit : function(component, event, helper) {

        helper.promise(component, helper.getObjectsFromResult)
        .then(function() {
            //return helper.promise(component, helper.getRevenueForecasts)
        })
        .then(function() {
            //return helper.promise(component, helper.calculateTotals)
        })
        .then(function() {
            console.log("then3");
            
            //return helper.helperFunctionAsPromise(component, helper.getObjectsFromResult)
        })
        .then(function() {
            console.log('Done with Revenue Invoice Details controller, no errors');
        })
        .catch(function(err) {
            /*
            var toastEvent = $A.get("e.force:showToast");
            
            toastEvent.setParams({
                title: 'Error',
                type: 'error',
                message: err.message
            });
            
            toastEvent.fire();
            */
            console.log("error: " + err.message);
        })
        .then(function() {
            console.log('A bit like finally');
        });        
        
        
    }
})