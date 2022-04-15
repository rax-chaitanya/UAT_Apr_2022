({
    upsertHelper : function(component) {
        console.log('Create record');
        
        //getting the candidate information
        var rev_forecast = component.get("v.rev_forecast");        
        rev_forecast.Account__c = component.get("v.account.Id");
        rev_forecast.Amount__c = component.get("v.rev_forecast.Amount__c");       
        rev_forecast.CurrencyIsoCode = component.find("currencies").get("v.value");
        
        
        //Calling the Apex Function
        var action = component.get("c.upsertRevenueForecast");
        
        console.log('revenue forecast before putting it into param w/amount: ' + component.get("v.rev_forecast.Amount__c"));
        console.log(rev_forecast);
        //Setting the Apex Parameter
        var theID = rev_forecast.Id;
        console.log('the id: ' + theID);
        action.setParams({
            rev_forecast : rev_forecast,
            theID : theID
        });
        
        //Setting the Callback
        action.setCallback(this,function(a){
            //get the response state
            var state = a.getState();
            
            //check if result is successfull
            if(state == "SUCCESS"){
                if (rev_forecast.ID == undefined) {
                    console.log('return value: ' + a.getReturnValue());
                    
                    // for some reason, marking rev_forecast with "ID" will ensure that when and end user makes an inline edit, that it won't create a brand new rev forecast
                    //rev_forecast.ID = String(a.getReturnValue());
                    
                    //marking with .Id will ensure that when an edit is cancelled by row, that the amount from the database will show up 
                    rev_forecast.Id = String(a.getReturnValue());
                    
                }
                
         
                //resetting the Values in the form
                component.set("v.rev_forecast",rev_forecast);            
                
                console.log('rev_forecast below');
                console.log(rev_forecast);
                //alert(a.getReturnValue());
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            }
        });
        
        //adds the server-side action to the queue        
        $A.enqueueAction(action);      
    },
    
    getRevenueForecast: function (component, event) {
        var action = component.get("c.getRevenueForecast");
        
        action.setParams({theID : component.get("v.rev_forecast").Id});
        
        //Setting the Callback
        action.setCallback(this,function(a){
            var state = a.getState();
            if(state == "SUCCESS"){
                component.set("v.rev_forecast", a.getReturnValue());
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            }
        });
        
        $A.enqueueAction(action);             
    }
    ,
    
    toggleHelper : function (component, event) {
        var selected = event.getParam("selected");
        
        component.set("v.clicked", true);
        
        console.log('in toggle mode for children');
    }
})