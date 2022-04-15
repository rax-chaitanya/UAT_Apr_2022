({
	handleChange : function(component,event) 
    {
		var changeVal = event.getParam("value");
        component.set("v.value",changeVal);
	}
})