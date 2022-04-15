({
    
    doInit : function(component, event, helper) {
        console.log("initializing repForecastAccount");
        var revenue_forecasts = component.get("v.account.Revenue_Forecasts__r");
        var dateString = component.get("v.forecasted_date");
        var year = dateString.split('-')[0];
        var month = dateString.split('-')[1];
        
        var theDefault = {
            'sobjectType': 'Revenue_Forecast__c',
            'Account__c' : component.get("v.account.Id"),
            'Name'		: month + '-' + year,
            'Month__c' : month,
            'Year__c' : year,
            'Amount__c': 0
        };    
        
        //if there are no revenue forecasts found
        if (revenue_forecasts == undefined) {
            component.set("v.rev_forecast", theDefault);              
            component.set("v.previous", theDefault);                          
        } else {

            var matched = false;
            var i = 0;
            
            
            while (!matched && i < revenue_forecasts.length) {
                if (revenue_forecasts[i].Month__c == month && revenue_forecasts[i].Year__c == year) {
                    component.set("v.rev_forecast", revenue_forecasts[i]);
                    component.set("v.previous", revenue_forecasts[i]);                    
                    matched = true;
                }
                i++;
            }
            
            if (!matched) {
                component.set("v.rev_forecast", theDefault );           
                component.set("v.previous", theDefault);                              
                // console.log( component.get("v.rev_forecast") );
            }
            
        }
    },
    
    
    showSpinner: function(component, event, helper) {
        var aura = "rfSpinner";
        var spinner = component.find(aura);
        
        console.log('spinner: below');
        console.log(spinner);
        
        $A.util.removeClass(component.find(aura), 'slds-hide');
        
        console.log('spinner');
        console.log(spinner);
        
        
    },
    
    
    editMode : function(component, event, helper) {
        component.set("v.clicked", !component.get("v.clicked"));
    },
    
    changeClass: function(component, event, helper) {
        //change the td element's class to show that it has been edited
        
        $A.util.addClass(component.find("clickable"), 'slds-cell-edit slds-is-edited');
        
        console.log(event.getParams().keyCode);        
        console.log("key code" + event.getParams().keyCode + ".... previous value: " + component.get("v.previous").Amount__c + ', current value: ' + component.get("v.rev_forecast").Amount__c);        
        
        console.log('pressing key code: ' + event.getParams().keyCode);
        if(event.getParams().keyCode == 13){	// if enters
            helper.upsertHelper(component, event, helper);
            component.set("v.clicked", !component.get("v.clicked")); 

        } 
    },
    
    
    toggleMode: function(component, event, helper) {
        helper.toggleHelper(component);
    },
    
    
    cancel: function (component, event, helper) {
        helper.getRevenueForecast(component, event);
        component.set("v.clicked", !component.get("v.clicked"));
    },
    
    readMode: function(component, event, helper) {
        console.log("executed the function!");
        
        helper.upsertHelper(component);
        
        //toggle whether it's an input or an output        
        component.set("v.clicked", !component.get("v.clicked"));
        
        //component.find("edit-icon").focus();
        
    }            
    
})