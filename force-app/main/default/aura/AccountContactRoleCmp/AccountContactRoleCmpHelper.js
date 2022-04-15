({
    queryContact: function(component,  event, helper) {
        var recordId = component.get("v.recordId");
        if(recordId!=undefined){
            var action = component.get("c.getDetailsFromContact");
            action.setParams({recordId: recordId});
            action.setCallback(this, function(response){
                
                if (response.getState() === "SUCCESS") {
                    helper.createContactRecord(component, event, helper,response.getReturnValue());
                }
                
            });
            
            $A.enqueueAction(action);
        }
    },
    createContactRecord : function (component, event, helper,con) {
       
        var createAcountContactEvent = $A.get("e.force:createRecord");
        createAcountContactEvent.setParams({
            "entityApiName": "Account_Contact_Role__c",
            "defaultFieldValues": {
                'Contact__c' : con.Id,   
                'Email__c' : con.Email
         
            }
        });
        createAcountContactEvent.fire();
    },
    
})