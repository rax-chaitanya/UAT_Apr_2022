({
    doInit: function(component, event, helper) {
        helper.getEnforcedAgreements(component,event);
    },
    selectAll: function(component, event, helper) {
        
        var selectedHeaderCheck = event.getSource().get("v.value");
        
        var getAllId = component.find("checkBox");
        
        if(! Array.isArray(getAllId)){
            if(selectedHeaderCheck == true){ 
                component.find("checkBox").set("v.value", true);
                
            }else{
                component.find("checkBox").set("v.value", false);
                
            }
        }else{
            
            if (selectedHeaderCheck == true) {
                for (var i = 0; i < getAllId.length; i++) {
                    component.find("checkBox")[i].set("v.value", true);
                    
                }
            } else {
                for (var i = 0; i < getAllId.length; i++) {
                    component.find("checkBox")[i].set("v.value", false);
                    
                }
            } 
        }  
        
    },
    
    removePilotOnSelected: function(component, event, helper) {
        
        //var decCount = component.get('v.count');
        //var agreementscount = parseInt(decCount);
        //var remCount = 6-agreementscount;
        //alert(remCount);
        var tempIDs = [];
        
        
        var getAllId = component.find("checkBox");
        
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
        
        
        if(tempIDs.length<1){
            alert("Please choose at least one Pilot Agreement to Enforce Pilot Agreement"); 
        }
        
        else{
            
            var confm = false;
            confm = confirm("Click ''OK'' to Remove selected Pilot Agreements."); 
            
            if(confm == true){
                helper.removeSelectedAgreements(component, event, tempIDs);
            }
        } 
        
    },
    
})