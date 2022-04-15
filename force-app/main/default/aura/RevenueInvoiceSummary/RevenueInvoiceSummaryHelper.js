({
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // @developer   :   Diego Castro
    // @date        :   08/23/2017
    // @story       :   SFDC-537, SFDC-538
    // @description :	1) calls server method 'getObjectsFromResult', which lives in RevenueForecastController. 
    // 					2) return value from FMW payload to 
    // 					-- thus making it displayable.
    // 					
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
    getObjectsFromResult : function(component, resolve, reject) {   
        console.log("Summary.getObjectsFromResult");
        console.log("component.get('v.record') below");
        console.log(JSON.stringify( component.get("v.record")) ) ;
        console.log('objType:' + component.get("v.objType")) ;
        
        var getObjectsFromResult = component.get("c.getObjectsFromResult");
        
        var sobjectType = component.get("v.record").attributes.type.replace('__c', '');
        
        if(sobjectType == 'Account' && component.get("v.objType") == 'Account'){
            sobjectType = 'Accounts';
        }/*else if(sobjectType == 'Account' && component.get("v.objType") == 'Company'){
            sobjectType = 'Account';
        }*/
        //alert('sobjectTypeSummary:' + sobjectType);
        getObjectsFromResult.setParams({
            recordId	: 	component.get("v.recordId"),
            record		: 	JSON.stringify( component.get("v.record") ) ,
            classType	: 	 sobjectType + "InvoiceSummary",
            settingName	: 	"RO-Summary-" + sobjectType
        });
        
        getObjectsFromResult.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var results = response.getReturnValue();
                console.log("[PAYLOAD] /accountinvoicesummary/ ");
                console.log(results);
                
                var today = new Date();
                var firstOfMonth = new Date(today.getFullYear(), today.getMonth(), 1, 0, 0, 0, 0)
                component.set("v.todaysDate", firstOfMonth.toISOString().slice(0,10) );
                
                console.log("todays date: " + component.get("v.todaysDate"));
                
                for (var i = 0; i < results.length; ++i) {
                    results[i].Id = component.get("v.recordId");
                    
                }
                component.set("v.results", results);
                
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
                
                
                var appEvent = $A.get("e.c:populateInvoiceInformationAfterLoad");
                
                var nextNMonths = Number ( $A.get("$Label.c.RIS_Next_N_Months") );
                //alert('results.length: ' + results.length + ', RIS_Next_N_Months: ' + nextNMonths);
                if (results.length > nextNMonths) {
                    
                    appEvent.setParams({
                        "record" : results[nextNMonths + 1] });
                    appEvent.fire();        
                }
                
                
                
                
                if(resolve) {
                    console.log('resolving appendViaApex');
                    resolve('appendViaApexPromise succeeded');
                }
            } else {
                console.log(response.getError());
                if(reject) {
                    console.log('rejecting RevenueInvoiceSummary getObjectsFromResult');
                    reject(Error(response.getError()[0].message));
                }
            }
        });
        console.log('Queueing getObjectsFromResult');
        $A.enqueueAction(getObjectsFromResult);
    },
    
    getRevenueForecasts	: function(component, resolve, reject) {
        if (component.get("v.record.attributes.type") == 'Account' && component.get("v.objType") == 'Account') {
            
            var getForecastsByKey = component.get("c.getForecastsByKey");
            
            getForecastsByKey.setParams({recordId	: 	component.get("v.recordId")});      
            
            getForecastsByKey.setCallback(this, function(response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    component.set("v.forecasts", response.getReturnValue());
                    
                    var forecasts = response.getReturnValue();
                    
                    var rep_forecast_accounts = component.find("rep-forecast-account");
                    
                    if (rep_forecast_accounts != undefined) {
                        var total = 0;                
                        for (var i = 0; i < rep_forecast_accounts.length; ++i) {
                            var forecast = rep_forecast_accounts[i].get("v.rev_forecast");
                            total += forecast.Amount__c;
                            
                            console.log(forecast.Amount__c);
                            var key = forecast.Account__c + '-' + forecast.Month__c + '-' + forecast.Year__c;
                            
                            if (key in forecasts) {
                                total += forecasts[key].Amount__c;
                                rep_forecast_accounts[i].set("v.rev_forecast", forecasts[key]);
                            }
                        }
                        var totalsAttr = component.get("v.totals");
                        totalsAttr.forecastTotal = total;
                        component.set("v.totals", totalsAttr);
                    }
                    
                    
                    
                    
                    if(resolve) {
                        console.log('resolving getForecastsByKey');
                        resolve('getForecastsByKey succeeded');
                    }
                } else {
                    console.log(response.getError());
                    if(reject) {
                        console.log('rejecting getForecastsByKey');
                        reject(Error(response.getError()[0].message));
                    }
                }
            });
            console.log('Queueing getForecastsByKey');
            $A.enqueueAction(getForecastsByKey);      
        }
    },
    
    promise : function(component, helperFunction) {
        return new Promise($A.getCallback(function(resolve, reject) {
            helperFunction(component, resolve, reject);
        }));
    }    
    
    
    
})