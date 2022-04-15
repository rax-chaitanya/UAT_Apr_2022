({
    
    getAccRecordTypes : function(component,event,helper){
        var action = component.get("c.getAccRecordTypeList");
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('getAccRecordTypes ctrl calling:');        
            if(state === "SUCCESS"){
                console.log('ss:' + response.getReturnValue());        
                console.log('SSJSON:' + JSON.stringify(response.getReturnValue()));        
                if(!$A.util.isUndefinedOrNull(response.getReturnValue()) &&
                   !$A.util.isEmpty(response.getReturnValue())){
                	var returning = [];
                    var recordTypes = response.getReturnValue();
                    for(var key in recordTypes){
                        returning.push({key:key,value:recordTypes[key]});                                                   
                    }
                    component.set("v.availableRecordTypes",returning);
                    //alert(JSON.stringify(component.get("v.availableRecordTypes")));    
                    if(component.get("v.availableRecordTypes.length") == 1){
                        component.set("v.recordTypeId",component.get("v.availableRecordTypes[0].key"));
                        helper.createAccountHlpr(component,event,helper);                        
                    }else{
                        component.set("v.retrievedTypes",true);						
                    }                        
                }else{
                     var toastEvent = $A.get("e.force:showToast");
                     toastEvent.setParams({
                     "type": "info",   
                     "mode": "sticky",    
                     "title": "Error: ",
                     "message": "Looks like you don’t have access to create Account. Please contact your System Admin."
                     });
                     toastEvent.fire();                
                }                                                                         
            }
            else{
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                 "type": "info",   
                 "mode": "sticky",    
                 "title": "Error: ",
                 "message": "There is a problem in getting RecordType. Please contact your System Admin."
                 });
                 toastEvent.fire();                
            }
        });
        $A.enqueueAction(action); 
    },
    
	createAccountHlpr : function(component,event,helper){
		
        /*var accDefaultValues = { Company_Name__c: component.get("v.recordId"), Name: component.get("v.AccRecord.Name"), 
                                 BillingCountryCode: component.get("v.AccRecord.BillingCountryCode"), BillingCity: component.get("v.AccRecord.BillingCity"), 
                                 BillingPostalCode: component.get("v.AccRecord.BillingPostalCode"), BillingStreet: component.get("v.AccRecord.BillingStreet"),
                                 BillingStateCode:component.get("v.AccRecord.BillingStateCode"), NotifiedSystems__c: component.get("v.AccRecord.NotifiedSystems__c"), 
                                 Status__c: 'New', Type: 'Prospect', ShippingCountryCode: component.get("v.AccRecord.BillingCountryCode"), Billing_County__c: component.get("v.AccRecord.Billing_County__c"),
                                 ShippingCity: component.get("v.AccRecord.ShippingCity"), ShippingPostalCode: component.get("v.AccRecord.ShippingPostalCode"), 
								 ShippingStateCode: component.get("v.AccRecord.ShippingStateCode"), ShippingStreet: component.get("v.AccRecord.ShippingStreet")
                               }; */
        /*var accDefaultValues = { Company_Name__c: component.get("v.recordId"), Name: component.get("v.AccRecord.Name"), 
                                 Type: 'Prospect'
                               };*/
       
                  
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Account",
            "recordTypeId": component.get("v.recordTypeId"),
            "defaultFieldValues": {
                Company_Name__c: component.get("v.recordId")
            }
            
        });
        createRecordEvent.fire();
    }
})