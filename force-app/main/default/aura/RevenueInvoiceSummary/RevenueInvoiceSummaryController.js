({
    doInit	: function (component, event, helper) {
        helper.promise(component, helper.getObjectsFromResult)            
        .then(function() {
            return helper.promise(component, helper.getRevenueForecasts)            
        })
        .then(function() {
            //return helper.helperFunctionAsPromise(component, helper.getObjectsFromResult)            
        })
        .then(function() {
            //return helper.helperFunctionAsPromise(component, helper.getObjectsFromResult)
        })
        .then(function() {
            console.log('Done, no errors');
        })
        .catch(function(err) {
            /*
           	use below code when this component/application is embedded in a record detail page. 
            currently, it doesn't work when it's a standalone component or application
              
            var toastEvent = $A.get("e.force:showToast");
            
            toastEvent.setParams({
                title: 'Error',
                type: 'error',
                message: err.message
            });
            
            toastEvent.fire();
            */
            
            
            component.set("v.error", err.message);
            
            //alert("error:" + err.message);
        })
        .then(function() {
            //console.log('A bit like finally');
        });
    },
    handleSomethingChange : function (component) {
        //alert('i was called');
    }
})