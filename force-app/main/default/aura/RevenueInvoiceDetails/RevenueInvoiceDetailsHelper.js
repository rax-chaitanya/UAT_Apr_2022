({
    
    getObjectsFromResult : function(component, resolve, reject) {
        var getObjectsFromResult = component.get("c.getObjectsFromResult");
        
        console.log("component.get('v.record') below");
        console.log(JSON.stringify( component.get("v.record")) ) ;
        
		var sobjectType = component.get("v.record").attributes.type.replace('__c', '');
        
        if(sobjectType == 'Account' && component.get("v.objType") == 'Account'){
            sobjectType = 'Accounts';
        }/*else if(sobjectType == 'Account' && component.get("v.objType") == 'Company'){
            sobjectType = 'Account';
        }*/
        //alert('RIDetails sobjectTypeDetails:' + sobjectType);
        getObjectsFromResult.setParams({
            recordId	: 	component.get("v.recordId"),
            record		: 	JSON.stringify( component.get("v.record") ) ,
            classType	: 	 sobjectType + "InvoiceDetail",
            settingName	: 	"RO-Detail-" + sobjectType
        });
        
        getObjectsFromResult.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                
                console.log("success for details get");
                var results = response.getReturnValue();
                
                console.log(results);
                results.forEach( function (result) {
                    result.Id = component.get("v.recordId");
                });
                console.log("after for each");
                component.set("v.results", results);
                
                console.log("results"  + results.length);
                

                var reduced = results.reduce(function(pv, cv) {
                    for (var key in cv) {
                        if (typeof(cv[key]) == "number") {
                            if ( pv[key] ) {
                                pv[key] += cv[key];
                            } else {
                                pv[key] = cv[key];
                            }
                        }
                    }
                    return pv;
                }, {});
                
                component.set("v.totals", reduced);
                
                
                console.log("before date instantiantion");
                var t = new Date();
                var d = new Date(t.getFullYear(), t.getMonth(), 1, 0, 0, 0, 0)
                component.set("v.todaysDate", d.toISOString().slice(0,10) );
                
                console.log("todays date: " + component.get("v.todaysDate"));

                
                if(resolve) {
                    console.log('resolving appendViaApex');
                    resolve('appendViaApexPromise succeeded');
                }
            } else {
                console.log(response.getError());
                if(reject) {
                    console.log('rejecting getObjectsFromResult');
                    reject(Error(response.getError()[0].message));
                }
            }
        });
        console.log('Queueing getObjectsFromResult');
        $A.enqueueAction(getObjectsFromResult);
    }
    ,
    
    
    
    
    promise : function(component, helperFunction) {
        return new Promise($A.getCallback(function(resolve, reject) {
            helperFunction(component, resolve, reject);
        }));
    }    

    
    
})