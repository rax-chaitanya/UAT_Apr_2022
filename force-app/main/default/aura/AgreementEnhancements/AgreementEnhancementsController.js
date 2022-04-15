({
	    doInit: function(component, event, helper) {
            helper.getPartnerLevel(component,event,helper);
             
    },
     selectAllAdd: function(component, event, helper) {
        
        var selectedHeaderCheck = event.getSource().get("v.value");
        
        var getAllId = component.find("checkBoxAdd");
         if(getAllId!=null){
        if(! Array.isArray(getAllId)){
            if(selectedHeaderCheck == true){ 
                component.find("checkBoxAdd").set("v.value", true);
                
            }else{
                component.find("checkBoxAdd").set("v.value", false);
                
            }
        }else{
            
            if (selectedHeaderCheck == true) {
                for (var i = 0; i < getAllId.length; i++) {
                    component.find("checkBoxAdd")[i].set("v.value", true);
                    
                }
            } else {
                for (var i = 0; i < getAllId.length; i++) {
                    component.find("checkBoxAdd")[i].set("v.value", false);
                    
                }
            } 
        }  
     }  
    },
    selectAllRemove: function(component, event, helper) {
        
        var selectedHeaderCheck = event.getSource().get("v.value");
        
        var getAllId = component.find("checkBoxRemove");
         if(getAllId!=null){
        if(! Array.isArray(getAllId)){
            if(selectedHeaderCheck == true){ 
                component.find("checkBoxRemove").set("v.value", true);
                
            }else{
                component.find("checkBoxRemove").set("v.value", false);
                
            }
        }else{
            
            if (selectedHeaderCheck == true) {
                for (var i = 0; i < getAllId.length; i++) {
                    component.find("checkBoxRemove")[i].set("v.value", true);
                    
                }
            } else {
                for (var i = 0; i < getAllId.length; i++) {
                    component.find("checkBoxRemove")[i].set("v.value", false);
                    
                }
            } 
        }  
         } 
    },
     enforcePilotOnSelected: function(component, event, helper) {
       
        var tempIDs = [];
        var getAllId = component.find("checkBoxAdd");
         if(getAllId!=null){
        if(! Array.isArray(getAllId)){
            if (getAllId.get("v.value") == true) {
                tempIDs.push(getAllId.get("v.text"));
            }
        }
        else{
            for (var i = 0; i < getAllId.length; i++) {
                
                if (getAllId[i].get("v.value") == true) {
                    tempIDs.push(getAllId[i].get("v.text"));
                    
                }
            }
        }
         if(tempIDs==null || tempIDs.length<1){
          
               alert("Please select an agreement to add");
         }
         else{
             var confm = false;
                confm = confirm("Click ''OK'' to Add agreement."); 
                
                if(confm == true){
                    helper.enforceSelectedAgreements(component, event, tempIDs);
                }
         }
         }else{
             alert("No agreement available to add");
         }
    },
    removePilotOnSelected: function(component, event, helper) {
        
        var tempIDs = [];
        
        
        var getAllId = component.find("checkBoxRemove");
        if(getAllId!=null){
        if(! Array.isArray(getAllId)){
            if (getAllId.get("v.value") == true) {
                tempIDs.push(getAllId.get("v.text"));
            }
        }
        else{
            for (var i = 0; i < getAllId.length; i++) {
                
                if (getAllId[i].get("v.value") == true) {
                    tempIDs.push(getAllId[i].get("v.text"));
                    
                }
            }
        }
        
        console.log('3333333333',tempIDs);
        if(tempIDs==null || tempIDs.length<1){
            alert("Please choose at least one Agreement to Remove"); 
        }
        
        else{
            
            var confm = false;
            confm = confirm("Click ''OK'' to Remove selected Agreements."); 
            
            if(confm == true){
                helper.removeSelectedAgreements(component, event, tempIDs);
            }
        } 
       }else{
             alert("No Selected attachment available to remove");
         } 
    }
})