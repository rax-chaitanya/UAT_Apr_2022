({
    handleSaveQuickText : function(component, event, helper) {
  var action = component.get("c.insertQuickText"); 
        var NameFieldBlank = component.find("quicktextselect");
        var MsgFieldBlank = component.find("quicktextselect1");
        var CategoryFieldBlank = component.find("quicktextselect2");
        action.setParams({name : component.get("v.quicktextname"),
                          message : component.get("v.message"),
                          category : component.get("v.category"),   
                         });
        action.setCallback(this, function(response) {   
            if (response.getState() === "SUCCESS") {
                console.log('Response'+response);
             var toast = $A.get("e.force:showToast");
                toast.setParams({
                    type : "success",
                    title : "Success!",  
                    message : "Quick Text is Created."  
                });
                toast.fire();  
                NameFieldBlank.set("v.value",'');
                MsgFieldBlank.set("v.value",'');
                CategoryFieldBlank.set("v.value",'');
            }else{
                var toast = $A.get("e.force:showToast");
                toast.setParams({
                    type : "fail",
                    title : "Failure!",  
                    message : "Please fill all the required fields."  
                });
                toast.fire();  
            }
        });
        
        $A.enqueueAction(action);  
 }  
})