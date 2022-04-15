({
    doInit: function(component, event, helper) {
        helper.getAgreements(component,event);
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
    
    enforcePilotOnSelected: function(component, event, helper) {
        
        var decCount = component.get('v.count');
        var agreementscount = parseInt(decCount);
        var remCount = 6-agreementscount;
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
        
        if(tempIDs.length<1 || tempIDs.length>6){
            if(tempIDs.length<1)
                alert("Please choose at least one Pilot Agreement to Enforce Pilot Agreement"); 
            if(tempIDs.length>6)
                alert("You can only enforce maximum of six pilot agreements to a partner."); 
        }
        else if(remCount<tempIDs.length){
            if(remCount == 1 || agreementscount == 1 ){
                if(remCount == 1)
                	alert("You have already enforced "+agreementscount+" Pilot Agreements.Now,You can only enforce "+remCount+" Pilot Agreement");
            	else
                    alert("You have already enforced "+agreementscount+" Pilot Agreement.Now,You can only enforce "+remCount+" Pilot Agreements");
            }
            else
                alert("You have already enforced "+agreementscount+" Pilot Agreements.Now,You can only enforce "+remCount+" Pilot Agreements");
        }
            else{
                
                var confm = false;
                confm = confirm("Click ''OK'' to Enforce Pilot Agreements."); 
                
                if(confm == true){
                    helper.enforceSelectedAgreements(component, event, tempIDs);
                }
            } 
        
    },
    
})