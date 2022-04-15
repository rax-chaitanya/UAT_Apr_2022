({
	handleClickhelper : function(component,event) {
		if(component.get('{!v.surveyCompletedDate}')===undefined){            
            alert('Please fill Survey Completed Date.');
        }
        else if(component.get('{!v.MonthlyRecap}')===undefined){
            alert('Please fill Monthly call Recap.');
        }
            else if(component.get('{!v.CustomersCurrentPulse}')===undefined){
                alert('Please fill Customer Current Pulse.');                
            }
                else if((component.get('{!v.CustomersCurrentPulse}')==='Customer is exhibiting churn indicators (including lack of interactions)Customer is leaving Rackspace' )&&(component.get('{!v.startchurndate}')===undefined || component.get('{!v.stopchurndate}')===undefined)	) {                   
                    alert('If Customer Pulse is - Customer is exhibiting churn indicators (including lack of interactions)Customer is leaving Rackspace. Please fill Start and Stop Churn Date.');
                }
                    else {                  
                            var saveAction = component.get("c.saveSurveyRecord");
                            saveAction.setParams({ "surveyId" : component.get('{!v.surveyId}'),
                                                  "surveyCompletedDate" : component.get('{!v.surveyCompletedDate}'),
                                                  "CustomersCurrentPulse" :component.get('{!v.CustomersCurrentPulse}'),
                                                  "startchurndate":component.get('{!v.startchurndate}'),
                                                  "stopchurndate":component.get('{!v.stopchurndate}'),
                                                  "MonthlyRecap":component.get('{!v.MonthlyRecap}'),
                                                  "MRRLoss":component.get('{!v.MRRLoss}'),
                                                 });                            
                            saveAction.setCallback(this, function(response) {
                                var state = response.getState();                                       
                                if (state === "SUCCESS") {
                                    var storeResponse = response.getReturnValue();                                      
                                    if(storeResponse != null){
                                        let button = event.getSource();
                                    	button.set('v.disabled',true);
										var reloadInIt = component.getEvent("reloadDoInIt");
                                        reloadInIt.getParam("reloadEvent");                
                                        reloadInIt.fire();                                
                                    }       
                                    
                                }
                                else if(state==="ERROR"){                                   
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "type":"Error",
                                        "title":"Error",
                                        "message": "Survey Record is incomplete. Please fill all the Required fields." ,                       
                                    });
                                    toastEvent.fire();                                                                       
                                }                                
                            });
                            $A.enqueueAction(saveAction);                                                                      
                    }
	}
})