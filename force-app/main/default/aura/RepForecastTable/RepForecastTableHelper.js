({
    
    getOwnedAccounts: function(component) {
        var action = component.get("c.getOwnedAccounts");
        
        var self = this;
        
        action.setParams({
            "rec_id" : component.get("v.rec_id")
        });        
        
        action.setCallback(this, function(actionResult) {
            component.set('v.accounts', actionResult.getReturnValue());                       
        });
        $A.enqueueAction(action);
    },


    massUpdate: function(component, event) {
        var recordIds = $A.util.json.encode( component.get("v.accounts"));
        
        var action = component.get("c.massUpdateAccounts");
        action.setParams({
            "recordIds" : recordIds
        });
        
        action.setCallback(this, function(actionResult) {
            component.set("v.accounts", actionResult.getReturnValue());
        });
        
        $A.enqueueAction(action);
        
        
    },
    
    getForecastedDates: function(component) {
        var action = component.get('c.getForecastedDates');
        
        // Set up the callback
        // setCallback() function sets a function to run after the action finishes
        // callbacks can get us the value of the action right after it returns, without bogging the computer down while it's waiting.
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set('v.forecasted_dates', actionResult.getReturnValue());            
        });
        $A.enqueueAction(action);
    },
    
    setHoveredHelper: function(component) {
        alert("hi");
        
        component.set('v.hovered', 'hi');
    }
    
    ,
    showHelper: function (component, event) {
        var spinner = component.find("mySpinner");
        
        $A.util.addClass(component.find("mySpinner"), 'slds-hide');
    },
    
    hideHelper: function (component, event) {
        var spinner = component.find("mySpinner");
        
        $A.util.removeClass(component.find("mySpinner"), 'slds-hide');
    },
    
    editHelper: function (component) {
        
        //helper.showHelper(component, event);
        //find all the rows by aura:id named "row"
        
        
        var rows = component.find("row");
        var forecasts = [];
		// for some reason, rows.length is undefined when there is only one record shown... 
        if (rows.length == undefined && rows != undefined) {
           	console.log("edit row of 1");
            rows.editRow();
        } else {
            
            // call aura:method named editRow that is linked to the edit action for each row
            for (var i = 0; i < rows.length; ++i) {
                console.log("in row num" + i);
                console.log(rows[i]);
                //rows[i].editRow();   
                rows[i].editRow();
            }            
        }

        
        //helper.showHelper(component, event);        
        
        
    },
    
    toggleEditButton: function (component) {
        $A.util.toggleClass(component.find("edit-all"), 'slds-hide');
    },
    
    toggleCancelButton: function (component) {
        $A.util.toggleClass(component.find("cancel-all"), 'slds-hide');
    },
    
    toggleSaveButton: function (component) {
        $A.util.toggleClass(component.find("save-all"), 'slds-hide');
    },
    
    toggleButtonGroup: function(component, event, helper) {
        helper.toggleEditButton(component);
        helper.toggleSaveButton(component);
        helper.toggleCancelButton(component);
        
    },
    
   upsertHelper: function(component) {
        
        
        //helper.toggle(component, event);
        
        
        //grab the revenue forecasts in the row
                
        var row_aura_id = "row";
        var forecast_aura_id = "rep-forecast-account";
        
        var rows = component.find( row_aura_id );
        var all_forecasts = [];           
           if(rows.length == undefined && rows != undefined){
               var fcRows = component.find( row_aura_id ).find(forecast_aura_id);                    
               //BEFORE SUCCESS 
               all_forecasts = this.hlprBeforeAfterSuccess(fcRows,'','BEFORE SUCCESS');                  
           } 
            //for each row
			for (var i = 0; i < rows.length; ++i) {
				// find revenue forecasts in the row
				var forecasts = rows[i].find( forecast_aura_id );      
                //BEFORE SUCCESS
				all_forecasts = this.hlprBeforeAfterSuccess(forecasts,'','BEFORE SUCCESS');
				//all_forecasts.push( forecasts );
			}
			
			//all_forecasts = all_forecasts.concat.apply([], all_forecasts);
			
			console.log(all_forecasts);
			
			
			var action = component.get("c.upsertRevenueForecasts");
			
			action.setParams({
				revenue_forecasts : all_forecasts
			});
			
			action.setCallback(this, function (a)  {
				var state = a.getState();
				
				if (state == 'SUCCESS') {
					
					
					var rev_forecast_map = a.getReturnValue();                
					
					//07-2017
					var newer = [];
						
                    if(rows.length == undefined && rows != undefined){
                        var fcRows = component.find( row_aura_id ).find(forecast_aura_id);                    
                        newer = this.hlprBeforeAfterSuccess(fcRows,rev_forecast_map,state);                  
                    }
		
					for (var i = 0; i < rows.length; ++i) {
						// find revenue forecasts in the row
						var forecasts = rows[i].find( forecast_aura_id );						
						newer = this.hlprBeforeAfterSuccess(forecasts,rev_forecast_map,state);												
					}
					
				} else {
					console.log('ERROR!!!');
				}
			    
			});
			
			$A.enqueueAction(action);         
                
    },
        
    hlprBeforeAfterSuccess: function(forecasts,rev_forecast_map,stateval){
                if(stateval == 'SUCCESS' && forecasts.length != undefined){
                    var newer = [];
                    	for(var j = 0; j < forecasts.length; ++j)
                        {                        
                            if (forecasts[j].get("v.clicked")) {
                                var forecast = forecasts[j].get("v.rev_forecast");
                                
                                var dateKey = forecast.Month__c + '-' + forecast.Year__c;
                                
                                console.log(forecast);
                                
                                if (dateKey in rev_forecast_map[forecast.Account__c] && forecast.Id == undefined) {
                                    console.log('before: ' + forecast.Id);
                                    
                                    
                                    forecast.Id = rev_forecast_map[forecast.Account__c][dateKey].Id;
                                    
                                    
                                    //forecasts[j].Id = rev_forecast_map[forecast.Account__c][dateKey].Id;
                                    console.log('after: ' + forecast.Id);
                                    
                                    
                                    
                                } 
                                
                                forecasts[j].set("v.rev_forecast", forecast);
                                
                                
                                
                                newer.push(forecast);
                                
                                console.log(forecasts[j].get("v.rev_forecast"));
                                
                                //component.set(forecasts[j].get("v.rev_forecast"), forecasts[j] );
                                
                                
                                forecasts[j].set("v.clicked", false);
                                
                                
                                
                                
                            }
                        }
                    return newer;
                }else if(stateval == 'BEFORE SUCCESS' && forecasts.length != undefined){    
                    var all_forecasts = []; 
        			 for (var j = 0; j < forecasts.length; ++j) {
                         if (forecasts[j].get("v.clicked")) {                                        
                             //console.log(forecasts[j].get())
                             all_forecasts.push( forecasts[j].get("v.rev_forecast"));
                         }
                     }
                    return all_forecasts;
                }
        
    }
    
})