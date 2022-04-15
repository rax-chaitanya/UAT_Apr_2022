({
	/*afterRender: function (component, helper) {
    	this.superAfterRender();
        console.log('after render call');
        var eveCreate = component.get('v.isTabCreated');
        var eveUpdate = component.get('v.isTabUpdated');
        if(eveCreate){
            
            setTimeout(function(){helper.openNewTab(component, event, helper)}, 2000);
        }
        if(eveUpdate){
            setTimeout(function(){helper.newRefreshed(component, event, helper)}, 2000);
            
        }
	},*/
    rerender : function(component, helper) {
       
   		this.superRerender();
        console.log('test rerender');
    }
  
})