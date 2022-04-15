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
                    var record = returnValue.Record;
                    for(var i in record.Realignment_Request_Items__r){
                        var item = record.Realignment_Request_Items__r[i];
                        item.selected = true;
                    }
                    component.set("v.record", record);
                    component.set("v.hasMessage", false);
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
	},
    
    approve : function(component, event, helper){
        var action = 'Approve';
        var record = component.get("v.record");
        for(var i in record.Realignment_Request_Items__r){
            var item = record.Realignment_Request_Items__r[i];
            if(item.selected){
                item.Request_Status__c = 'Pending for Approval';
            }else{
                item.Request_Status__c = 'Rejected';
            }
        }
        console.log('record : '+JSON.stringify(record));
        helper.process(component, action, record);
    },
    
    reject : function(component, event, helper){
        var action = 'Reject';
        var record = component.get("v.record");
        for(var i in record.Realignment_Request_Items__r){
            var item = record.Realignment_Request_Items__r[i];
            item.Request_Status__c = 'Rejected';
        }
        console.log('record : '+JSON.stringify(record));
        helper.process(component, action, record);
    }
})