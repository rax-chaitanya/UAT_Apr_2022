({
    queryAccountById: function(component, event) {
        
        // start here
        
        //Calling the Apex Function
        var action = component.get("c.getRevenueForecastsByAccountIdMap");
        
        //add parameters to the method that will be called in Apex        
        action.setParams({
            accountID : component.get("v.account.Id"),
        });
        
        
        //Setting the Callback
        action.setCallback(this,function(a){
            //get the response state
            var state = a.getState();
            
            
            //check if result is successfull
            if(state == "SUCCESS"){
                
                
                var revenue_forecast_map = a.getReturnValue();
                
                console.log('revenue_forecast_map below');
                console.log(revenue_forecast_map);
                
                
                var revenue_forecasts = component.find("rep-forecast-account");                        
                
                var theDefault = {
                    sobjectType: 'Revenue_Forecast__c',
                    'Account__c' : '',
                    'Month__c' : '',
                    'Year__c' : '',
                    'Amount__c': 0
                };
                
                
                
                //console.log("=== revenue forecast map keys: " + revenue_forecast_map.keys())
                
                
                console.log("revenue forecasts below:");
                for (var i = 0; i < revenue_forecasts.length; ++i) {
                    
                    var rev_forecast = revenue_forecasts[i].get("v.rev_forecast");
                    
                    if (rev_forecast.Id in revenue_forecast_map) {
                        rev_forecast =  revenue_forecast_map[rev_forecast.Id];
                        revenue_forecasts[i].set("v.rev_forecast", rev_forecast);
                    } else {
                        console.log("setting the default for rev forecast id" + rev_forecast.Id);
                        revenue_forecasts[i].set("v.rev_forecast", theDefault);
                    }
                }
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            }
        });
        
        //adds the server-side action to the queue        
        $A.enqueueAction(action);      
    },
    
    setReadOnly: function(component, event) {
        
        var rep_forecast_accounts = component.find("rep-forecast-account");
        
        console.log("rep forecasts accounts in toggleReadOnly are below");
        
        
        for (var i = 0; i < rep_forecast_accounts.length;  ++i) {
            var repForecastAccount = rep_forecast_accounts[i];
            
            //set each revenue forecast's "clicked" attribute under the account to be the opposite of what it was beforehand
            repForecastAccount.set("v.clicked", false);
        }
    },
    
    //probably will move this into the set read only function as to prevent duplicate iteration over the collection    
    removeEditedHighlight: function (component) {
        var rep_forecast_accounts = component.find("rep-forecast-account");
        
        for (var i = 0; i < rep_forecast_accounts.length; ++i) {
            var td = rep_forecast_accounts[i].find("clickable");
            console.log("td below: ");
            console.log(td);
            
            //find the "clickabke" aura:id that is marked on the td attributes for revenue forecasts on an account
            $A.util.removeClass(td, 'slds-cell-edit slds-is-edited');
        }
    },
    
    toggleRowSelected: function(component) {
        component.set("v.row_selected", !component.get("v.row_selected"));
    },
    
    resetRowHelper: function(component, event, helper) {
        //toggle the row selected        
        helper.toggleRowSelected(component);         
        
        
        // query the database for the revenue forecasts under the relevant account id
        helper.queryAccountById(component, event);
        
        
        //set the revenue forecasts of this account to be read only 
        helper.setReadOnly(component, event);
        
        helper.removeEditedHighlight(component);        
        
        
    }    
    ,
    
    upsertHelper : function(component, event, helper) {

		//helper.toggle(component, event);

        
        //grab the revenue forecasts in the row
        var rev_forecasts = component.find("rep-forecast-account");         
        var forecasts = [];
        
        for (var i = 0; i < rev_forecasts.length; ++i) {
            var rev_forecast = rev_forecasts[i].get("v.rev_forecast");            
            var dateString = rev_forecasts[i].get("v.forecasted_date");                
            forecasts.push(rev_forecast);                        
        }        
        
        console.log("forecasts below");
        console.log(forecasts);
        
        //var rev_forecast = revenue_forecasts[i].get("v.rev_forecast");        
        
        //get the apex method 
        var action = component.get("c.upsertRevenueForecasts");
        
        
        //add parameters to the method that will be called in Apex        
        action.setParams({
            revenue_forecasts : forecasts,
        });
        
        
        
        action.setCallback(this, function (a) {
            
            var state = a.getState();
            if (state == 'SUCCESS') {
                console.log("successfully upserted information");
                
                //TODO write the wiring of the Ids to the recently inserted revenue forecasts
                
                var rev_forecast_map = a.getReturnValue();
                
                for (var i = 0; i < forecasts.length; ++i) {
                    var forecast = forecasts[i];
                    
                    //07-2017
                    var dateKey = forecast.Month__c + '-' + forecast.Year__c;
                    if (dateKey in rev_forecast_map[forecast.Account__c]) {
                        console.log('before: ' + forecasts[i].Id);
                        forecasts[i].Id = rev_forecast_map[forecast.Account__c][dateKey].Id;
                        console.log('after: ' + forecasts[i].Id);
                    } 
                }
                
                
            } else {
                alert(a.getState());
            }
            
        });
        
        //adds the server-side action to the queue        
        $A.enqueueAction(action);     
        
        
        helper.resetRowHelper(component, event, helper);
        
        
		//helper.toggle(component, event);
        
    },
        
    show: function (component, event) {
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    hide: function (component, event) {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    }
    
})