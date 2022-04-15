({
	doInit : function(component, event, helper) {
		var recordId = component.get("v.recordId");
        var loadRecordAction = component.get('c.validateAndLoadRecord');
        loadRecordAction.setParams({"recordId" : recordId});
        loadRecordAction.setCallback(this, function(response){
            helper.hideSpinner(component);
            if(response.getState() == 'SUCCESS'){
                var returnValue = response.getReturnValue();
                console.log('returnValue : '+JSON.stringify(returnValue));
                if(returnValue.isSuccess){
                    component.set("v.record", returnValue.Record);
                    component.set("v.hasMessage", false);
                    component.set("v.today", returnValue.Today);
                }
                else{
                    component.set("v.message", returnValue.Message);
                    component.set("v.severity", "error");
                    component.set("v.hasMessage", true);
                }
            }else{
                component.set("v.message", 'Something went wrong!');
                component.set("v.severity", "error");
                component.set("v.hasMessage", true);
            }
        });
        $A.enqueueAction(loadRecordAction);
        helper.showSpinner(component);
	},
    
    changeMoveDate : function(component, event, helper) {
		var record = component.get("v.record");
        console.log('record : '+JSON.stringify(record));
        var saveAction = component.get("c.saveRecord");
        
        var moveDate = new Date(record.Move_Date__c);
        console.log('record.Move_Date__c : '+record.Move_Date__c);
        console.log('moveDate : '+moveDate);
        console.log('today : '+component.get("v.today"));
        if(moveDate < new Date(component.get("v.today"))){
            alert('Please select valid move date');
            return;
        }
        saveAction.setParams({"record" : record});
        saveAction.setCallback(this, function(response){
            helper.hideSpinner(component);
            if(response.getState() == 'SUCCESS'){
                component.set("v.message", "Saved successfully.");
                component.set("v.severity", "success");
                component.set("v.hasMessage", true);
            }else{
                component.set("v.message", "Something went wrong!");
                component.set("v.severity", "error");
                component.set("v.hasMessage", true);
            }
        });
        
        $A.enqueueAction(saveAction);
        helper.showSpinner(component);
	}
})