({
 
    doInit: function(component, event, helper) {
        
        
        helper.getChildRecors(component, event);
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
 
    updateSelected: function(component, event, helper) {
         
        
        var countryName=component.get("v.conRecord.MailingCountryCode");
        var stateName=component.get("v.conRecord.MailingStateCode");
       
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
           alert("Please choose at least one Account Contact Role to update address."); 
        }
        else{
            var addempty = false; 
			if(countryName == null && stateName == null){ 
				addempty = true; 
			} 
            var confm = false; 

			if(addempty){ 
				confm = confirm("Country and State are empty. Do you want to Update address?"); 
			}else{ 
				confm = confirm("Click ''OK'' to update Account Contact Roles Address."); 
				} 
            if(confm == true){
                helper.updateSelectedHelper(component, event, tempIDs);
            }
        } 
        
    },
    
})