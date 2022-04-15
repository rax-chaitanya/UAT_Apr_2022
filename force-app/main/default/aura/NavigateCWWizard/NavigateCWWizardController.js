({
  //Added By shravan Start
 doInit : function(component, event, helper) {
     var OppId = component.get("v.recordId");
     var url = '';
     //sfdc-6367,start
    
     var opp = component.get("v.simpleRecord");
       var action = component.get("c.getRaptorURL");
     action.setParams({
         opptyId : OppId
     });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                url = response.getReturnValue();
                if(url!= null){
                console.log('url in Doin it=='+url);
                url = url.replace(':OPPORTUNITYID', OppId);
                //console.log('url2 in Doin it=='+url);
                component.set("v.raptorURL", url);
				console.log('Final URL ====='+component.get("v.raptorURL"));
            }
            }
        
        });
        $A.enqueueAction(action);
     
     //sfdc-6367,end
     var action = component.get("c.getLegalApprovalInfo");
     action.setParams({
         opptyId : OppId
     });
     action.setCallback(this, function(response) {
         console.log('status'+response.getState());
             if(response.getState() === "SUCCESS") {
                console.log("Opportunity Details ");
             		var opptyRecord = response.getReturnValue();
                	console.log('Onica_Type__c.....'+opptyRecord.Onica_Type__c);
                 //component.set("v.simpleRecord",opptyRecord);
                 //console.log('simpleRecord.....'+JSON.stringify(component.get("v.simpleRecord")));
                if(opptyRecord.Onica_Primary_Approval__c!=null){
                    component.set("v.legalApprovalStatus", opptyRecord.Onica_Primary_Approval__r.Status__c);
                }
            }
          });
     $A.enqueueAction(action);
      var checkddi = '';
 var action = component.get("c.checkgovtopptydetails");
     action.setParams({
         opptyId : OppId
     });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                checkddi = response.getReturnValue();
                component.set("v.checkddi", checkddi);
               
            }
            
             });
         
        $A.enqueueAction(action);
 },

// Added by Shravan End
    handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            // record is loaded (render other component which needs record data value)
            console.log("Record is loaded successfully.");
            helper.promise(component, helper.getUserInfo)
            .then(function() {
                return helper.promise(component, helper.validate)
            })
            .catch(function(err) {
                //use below code when this component/application is embedded in a record detail page.
                //currently, it doesn't work when it's a standalone component or application
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: 'Error',
                    type: 'error',
                    message: err.message
                });
                toastEvent.fire();
                component.set("v.error", err.message);
                //alert("error:" + err.message);
            })
            .then(function() {
                if (!component.get("v.recordError")) {
                    helper.navigateToURL(component, event);
                } else {
                    console.log("errorrrr");
                }
            });
            /*
            console.log("finished validating");  
            console.log("will navigate to URL?" + !component.get("v.recordError"));
            */
        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
    },
        handleRaptorDoc: function(component, event, helper) {
        //alert("handleRaptorDoc calling");
        console.log("handleRaptorDoc calling");
        //close the hijacked quick action
        $A.get("e.force:closeQuickAction").fire();
        var urlEvent1 = $A.get("e.force:navigateToURL");
        urlEvent1.setParams({ 
            "url": "/lightning/r/Opportunity/" + component.get("v.recordId") +"/view"
        });
        urlEvent1.fire();
    },

})