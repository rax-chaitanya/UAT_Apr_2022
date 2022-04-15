({
  GoTofolder : function(component, event, helper) {

      var a = event.currentTarget.dataset.val;
       var attributeValue = component.get("v.menu");  
      var evt = $A.get("e.c:LibrariesEvent");
      evt.setParams({ "result": a,
                    "resource":attributeValue+'-'+a
                    
                    });
      
      evt.fire();
   }
})