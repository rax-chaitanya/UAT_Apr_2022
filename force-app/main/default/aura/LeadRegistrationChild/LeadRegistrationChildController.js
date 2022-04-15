({
	/* selectAccount : function(component, event, helper){      
    // get the selected Account from list  
      var getSelectAccount = component.get("v.oAccount");
    // call the event   
      var compEvent = component.getEvent("oSelectedAccountEvent");
    // set the Selected Account to the event attribute.  
         compEvent.setParams({"accountByEvent" : getSelectAccount });  
    // fire the event  
         compEvent.fire();
    },*/
   selectAccount : function(component, event, helper){      
    // get the selected record from list  
      var getSelectAccount = component.get("v.oAccount");
      // console.log(getSelectAccount);
    // call the event   
      var compEvent = component.getEvent("oSelectedLeadEvent");
    // set the Selected sObject Record to the event attribute.  
         compEvent.setParams({"accountByEvent" : getSelectAccount });  
    // fire the event  
         compEvent.fire();
    }
})