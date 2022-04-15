({
    
    doInit : function(component,event,helper){
       helper.getAccRecordTypes(component,event,helper); 
    },
    
     optionSelected : function(component,event,helper){        
        var recordName = event.target.getAttribute("value");             
        var recordTypes = component.get("v.availableRecordTypes");
        for(var i=0;i<recordTypes.length;i++){
            if(recordName==recordTypes[i].value){	
                component.set("v.recordTypeId",recordTypes[i].key);                
                break;
            }
        }        
    },
    
    createAccount : function(component,event,helper){   
        //var ProspVal = 'Prospect,Create Prospect Record Type from Custom Account to Standard';
        var recordTypes = component.get("v.availableRecordTypes");    
        var firstRTVal = recordTypes[0].value;
        if(firstRTVal==recordTypes[0].value && component.get("v.recordTypeId") == ''){	
            component.set("v.recordTypeId",recordTypes[0].key);
            helper.createAccountHlpr(component,event,helper);
        }else if(component.get("v.recordTypeId") != ''){
         	helper.createAccountHlpr(component,event,helper);   
        }else{
            var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                 "type": "info",   
                 "title": "Error: ",
                 "message": "Please select anyone of the RecordType."
                 });
                 toastEvent.fire();
        }        
    },
    
    cancel : function(component,event,helper){
        var closeQA = $A.get("e.force:closeQuickAction");
        closeQA.fire();
    }
    	    
})