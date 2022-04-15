({
    handleSaveRecord: function(component, event, helper) {
        component.find("recordEditor").saveRecord($A.getCallback(function(saveResult) {
            
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                console.log("Save completed successfully.");
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving record, error: ' +
                           JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));
    },
        
        
        
        handleRecordUpdated: function(component, event, helper) {
            

        var eventParams = event.getParams();
        if(eventParams.changeType === "CHANGED") {
            //console.log('Fields that are changed: ' +component.get("v.simpleRecord.DDI__c"));
            // get the fields that changed for this record
            var changedFields = eventParams.changedFields;
            const changedFieldsParsed = JSON.parse(JSON.stringify(changedFields));
            console.log('Fields that are changed parsed: ' + JSON.stringify(changedFields));
            //console.log('Fields that are DDI===>: ' +changedFieldsParsed.DDI__c);
            // ddiValues;
           
            if(component.get("v.simpleRecord.Type")=='AWS' && component.get("v.simpleRecord.QuotingSystem__c")=='Onica' && component.get("v.simpleRecord.Account__r.Type") =='Prospect')
            {
                
            if(changedFieldsParsed.DDI__c){
            	var ddiValues = changedFieldsParsed.DDI__c;
            }
            //console.log('Old values===> '+ddiValues.oldValue);
            //console.log('new values===> '+ddiValues.value);
            // record is changed, so refresh the component (or other component logic)
            
                if(ddiValues){
                var action = component.get("c.accountDdi");
                    action.setParams({
                     ddiNumber : ddiValues.value
                 });
                    var accRec;
                 action.setCallback(this, function(response) {
                     console.log('status'+response.getState());
                         if(response.getState() === "SUCCESS") {
                           accRec = response.getReturnValue();
                             console.log('accRec>>>> '+accRec);
                             
                        }
                      });
                 $A.enqueueAction(action);
               // console.log('Fields ===>: ' + DDI__c);
               console.log('accRec after success>>>> '+accRec);
               window.setTimeout(
                    $A.getCallback(function() {
                        if(ddiValues.oldValue != ddiValues.value && accRec =='Account not Found' && component.get("v.simpleRecord.CAC_Integration_Status__c")!='Success' && component.get("v.simpleRecord.MuleSoft_Acknowledge__c")!=true){
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Saved",
                        "message": "Are you sure you want to enter DDI; DDI will be overwritten during Close process."
                    });
                    resultsToast.fire();
                }
                    }), 2000
                );
                    
                    
                    
            }
            }
        }else if(eventParams.changeType === "LOADED") {
            console.log('Fields that are loaded: ' +component.get("v.simpleRecord.DDI__c"));
            console.log('Account type: ' + component.get("v.simpleRecord.Account__r.Type"));
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted and removed from the cache
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving or deleting the record
        }
    }

})