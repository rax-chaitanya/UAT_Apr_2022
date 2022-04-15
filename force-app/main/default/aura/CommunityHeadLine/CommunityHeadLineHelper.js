({ 
    getPickListValues:function(component, fieldName, elementId){
        var action = component.get("c.getPicklistvalues");
        action.setParams({ 
            "fieldAPIName": fieldName
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var opts = []; 
            if(state == "SUCCESS"){
                var result = response.getReturnValue(); 
                if(result != undefined && result.length > 0){ 
                    for (var i = 0; i < result.length; i++) { 
                        opts.push({
                            class: "optionClass",
                            label: result[i],
                            value: result[i]
                        });
                    }
                    component.find(elementId).set("v.options", opts);
                    this.fetchheadline(component, event, result[0]);
                }  
            }else{ 
                alert('Error in getting data'); 
            }
        });
        $A.enqueueAction(action);
        
        
    },
    fetchuserprofile:function(component, event, helper) {
        var action = component.get("c.getUserInfo");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                var result = response.getReturnValue();
                if(result != null){
                    if(result == 'Admin'){
                        this.getPickListValues(component, 'Contract_Type__c', 'ContractType'); 
                        component.set("v.isValidProfile",true); 
                    }
                    else{
                        console.log('result',result);
                        this.fetchheadline(component, event, result);
                    }
                }
                
            }else{
                alert('Error in getting data'); 
            }
        });
        $A.enqueueAction(action);
    },
    fetchheadline : function(component, event, ContracttypeVal) { 
        var action = component.get("c.getExistingRecord"); 
        action.setParams({ 
            "Contracttype": ContracttypeVal
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var message = response.getReturnValue(); 
                if(message != null){
                    component.set("v.headerMessage",message.Head_Line__c);
                    component.set("v.dataId",message.Id);
                }
                else {
                    component.set("v.dataId",null);
                    component.set("v.headerMessage","");
                }
            }
            else {
                alert('Error in getting data');
            }
        });
        
        $A.enqueueAction(action);
    } ,
    
    updateHeadlineWithContractType : function(component, event, helper, selectedContractType){
        var action = component.get("c.updateHeadLineWithContractType");
        action.setParams({"headline": component.get("v.headerMessage"),
                          "Contracttype":selectedContractType,
                          "recordId": component.get("v.dataId")
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var cmpTarget = component.find('Modalbox');
                var cmpBack = component.find('Modalbackdrop');
                $A.util.removeClass(cmpBack,'slds-backdrop--open');
                $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
            }else {
                
                alert('Error in updating HeadLine');
            }
        });
        
        $A.enqueueAction(action);
    }   
})