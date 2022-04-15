({
    doInit: function(component, event, helper) {
        helper.checkfridaymethod(component);
        var recordId = component.get("v.AccManager");   
        var action = component.get("c.getPickListValuesIntoList");          
        action.setParams({
            objectType: 'OPC_Account_Survey__c',
            selectedField: 'Customer_s_Current_Pulse__c'
        });
        action.setCallback(this, function(response) {
            var list = response.getReturnValue();
            component.set("v.picklistValues", list);            
        })
        $A.enqueueAction(action);
        helper.displaySurveys(component, event, recordId, helper);        
    },
})