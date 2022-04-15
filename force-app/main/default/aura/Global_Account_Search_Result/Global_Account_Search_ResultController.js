({
	handleRecordSelect: function(component,event,helper){
       /* var abc = component.get("v.selectedLookUpRecord");
        var def = String(abc.Id);
       // alert(def);
        component.set("v.accountOwner",def);
        */
       //var selectedHeaderCheck = event.getSource().get("v.value");
        //console.log(selectedHeaderCheck);
    // var test = event.getSource().getElement().innerHTML;
       // console.log("44444444",test);

    },
    onParentChange:function(component, event, helper){
        helper.changeChildCheck(component,event,helper);
        
    },
    childChecked:function(component, event, helper){
    	helper.processChildCheck(component,event,helper);
        
        
	}
})