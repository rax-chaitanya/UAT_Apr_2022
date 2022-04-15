({
    doInit : function(component, event, helper) {
        var action = component.get("c.RecordTypeId");
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                component.set("v.recordTypeId", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        
        $A.enqueueAction(action);
    },
    handleOnLoad : function(component, event, helper) {
        component.set("v.loaded",false);
        var action = component.get("c.getChildAcc");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var accMap = [];
                for(var key in result){
                    
                    console.log(key);
                    accMap.push({key: key, value: result[key]});
                }
                if(accMap.length > 0){
                    component.set("v.display", true);
                }
                component.set("v.accountrtvalues", accMap);
                
            } 
        });
        
        $A.enqueueAction(action);
    },
    
    handleOnSubmit : function(component, event, helper) {
        
        component.set("v.loaded",true);
        var slectedRec = component.get("v.selectedValue");
        console.log(slectedRec);
        
        if(slectedRec != null){
            
            component.set("v.SubAgent",component.get("v.selectedValue"));
        }else{
            
            component.set("v.SubAgent", null);
        }
        
        event.preventDefault();
        
        component.find("leadForm").submit();
        
        $A.util.addClass(cmp.find("spinner"), 'slds-hide');
        
    },
    // Added to make state mandatory only when country=us sfdc-5888
    checkmandatorycountry  : function(component, event, helper) {
        //  var countrycode=component.find("countryCode").get("V.Value");
        var selectedValue=  event.getSource().get("v.value");
        console.log(selectedValue);
        //var countrycode=component.get("v.countrycode");
        //console.log('selected value'+countrycode);
        var checkmandatory= false;
        if (selectedValue == "US"){
            checkmandatory = true;
            //    alert('This is us');
        } else {
            checkmandatory= false;
            //      alert('This is not us');
        }  
        console.log(checkmandatory);
        component.set("v.checkmandatory", checkmandatory);
    },
    //added to make subagent info mandatory if region is not null-by sundarayya- SFDC-6194
    checkmandatorySubAgent : function(component, event, helper) {
        var slectedRec = component.get("v.selectedValue");
        console.log(slectedRec);
        var checkmandatory= false;
        if(slectedRec != null && slectedRec != ''){
            checkmandatory = true;
           
        }else{
            checkmandatory =false;
           
        }
        console.log(checkmandatory);
        
        component.set("v.checkrequired", checkmandatory);
    },
    
    
    handleOnSuccess : function(component, event, helper) {
        component.set("v.loaded",false);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Lead has been created.",
            "type": "success"
        });
        toastEvent.fire();
        var payload = event.getParams().response;
        
        var navService = component.find("navService");
        
        var pageReference = {
            type: 'standard__recordPage',
            attributes: {
                "recordId": payload.id,
                "objectApiName": "Lead",
                "actionName": "view"
            }
        }
        event.preventDefault();
        navService.navigate(pageReference);  
    },
    
    handleOnError : function(component, event, helper) {
        component.set("v.loaded",false);
        //var error = event.getParams();
        var error1 = event.getParam("message");
        var error2 = event.getParam("detail");
        //var error3 = event.getParam("output").name;
        //var message = '';
        //added by sundarayya e for SFDC-5765
        var errormsg = event.getParams();
        console.log('fielderror.........'+JSON.stringify(errormsg));  
        console.log(errormsg);
        var errormessages = errormsg.output;
        var  fieldError = event.getParam('output').fieldErrors;
        var separator = ' ';
        var errmessage = Object.values(fieldError).map(field => {
            return field.map(error => error.message).join(separator);
        }).join(separator);
        console.log('message verified'+ errmessage);
        
        if(error2  == "Use one of these records?"){
            component.find('OppMessage').setError('Duplicate data found please modify lead name');
        }else if(error2){
            component.find('OppMessage').setError(error2);
        }else{
            
            component.find('OppMessage').setError(errmessage);
        }
        
    } 
    
})