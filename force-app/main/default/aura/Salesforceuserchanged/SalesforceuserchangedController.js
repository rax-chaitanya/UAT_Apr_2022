({
    handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        
        if(eventParams.changeType === "CHANGED")
        {
            var changedFields = eventParams.changedFields;
            var salesforceUser = changedFields.pse__Salesforce_User__c;
            console.log(salesforceUser);
            if(salesforceUser != null){
                var newsalesforceuser = changedFields.pse__Salesforce_User__c.value;
                var oldSalesforceUser = changedFields.pse__Salesforce_User__c.oldValue;
                console.log(newsalesforceuser);
                console.log(oldSalesforceUser);
                if(newsalesforceuser != 'undefined' && oldSalesforceUser != 'undefined' &&!$A.util.isUndefined(oldSalesforceUser) && (newsalesforceuser != oldSalesforceUser)){
                  console.log(oldSalesforceUser);
                    var recvalue = component.get("v.recorddata");
                    console.log(recvalue);
                       if(recvalue != newsalesforceuser && recvalue != 'undefined' && !$A.util.isUndefined(oldSalesforceUser) && oldSalesforceUser != 'undefined'){
                       component.set("v.isModalOpen", true);
                       component.set("v.recorddata",oldSalesforceUser);
                   }
                   
                }
                
            }
            
        } else if(eventParams.changeType === "LOADED") {
            // record is loaded in the cache
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted and removed from the cache
        } else if(eventParams.changeType === "ERROR") {
        }
    },
    closeModel: function(component, event, helper) {
        component.set("v.recorddata",'');
        $A.get('e.force:refreshView').fire();
        component.set("v.isModalOpen", false);
    },
    submitDetails: function(component, event, helper) {
        var oldUser = component.get("v.recorddata");
        console.log(oldUser);
        console.log(component.get("v.recordId"));
        var action =component.get('c.revertContact');
        action.setParams({
            "contactId": component.get("v.recordId"),
            "salesforceUserId" : oldUser
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var message = response.getReturnValue();
                console.log(message);
                if(message == 'success'){
                    //component.set("v.recorddata",' ');
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Success!",
            			"message": "Salesforce User Reverted successfully",
            			"type": "success"
                       
                    });
                    resultsToast.fire();
                    $A.get('e.force:refreshView').fire();
                    //component.set("v.isModalOpen", false);
                }
            }
        });
        $A.enqueueAction(action);
        component.set("v.isModalOpen", false);
    },
})