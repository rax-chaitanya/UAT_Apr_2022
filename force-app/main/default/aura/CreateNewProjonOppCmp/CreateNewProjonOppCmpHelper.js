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
   
     createRecord: function(component, event, helper) {
      component.set("v.isOpen", true);
 		var recId = component.get("v.recordId");
      //  alert(recId)
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
               "entityApiName": 'Project__c',
               "recordTypeId": RecTypeID,
                "defaultFieldValues": {                    
                    "Opportunity__c" : recId,         
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