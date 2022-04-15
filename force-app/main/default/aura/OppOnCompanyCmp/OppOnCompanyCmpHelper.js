({
	 openModal: function(component, event, helper) {
      // set "isOpen" attribute to true to show model box
      component.set("v.isOpen", true);
   },
    fetchListOfRecordTypes: function(component, event, helper) {
      
      var action = component.get("c.fetchRecordTypeValues");
      action.setCallback(this, function(response) {
         component.set("v.lstOfRecordType", response.getReturnValue());
      });
      $A.enqueueAction(action);
       
       helper.openModal(component, event, helper);
       
   },
     getAccountValues: function(component,  event, helper) {
      var recordId = component.get("v.recordId");
     
        if(recordId!=undefined){
        
        
        //alert(recordId);
        var action = component.get("c.getDetailsFromAcc");
        action.setParams({
            recordId: recordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
          
            if (state === "SUCCESS") {
                var acc = response.getReturnValue();
              
                console.log(acc);
                component.set("v.accName", acc.Id); 
                component.set("v.compName",acc.Company_Name__c);  
            }
           
        });
        
        $A.enqueueAction(action);
        }
    },
     createRecord: function(component, event, helper) {
      component.set("v.isOpen", true);
 		var accName =component.get("v.accName");
        var compName=component.get("v.compName");
        
      var action = component.get("c.getRecTypeId");
      var recordTypeLabel = component.find("selectid").get("v.value");
      action.setParams({
         "recordTypeLabel": recordTypeLabel
      });
      action.setCallback(this, function(response) {
         var state = response.getState();
          
         if (state === "SUCCESS") {
            var createRecordEvent = $A.get("e.force:createRecord");
            var RecTypeID  = response.getReturnValue();
            createRecordEvent.setParams({
               "entityApiName": 'Opportunity',
               "recordTypeId": RecTypeID,
                "defaultFieldValues": {
                    
                    "Account__c" : accName, 
                    "AccountId"  : compName
        
    	          }
                
            });
            createRecordEvent.fire();
             
         } else if (state == "INCOMPLETE") {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
               "title": "Oops!",
               "message": "No Internet Connection"
            });
            toastEvent.fire();
             
         } else if (state == "ERROR") {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
               "title": "Error!",
               "message": "Please contact your administrator"
            });
            toastEvent.fire();
         }
      });
      $A.enqueueAction(action);
   }
})