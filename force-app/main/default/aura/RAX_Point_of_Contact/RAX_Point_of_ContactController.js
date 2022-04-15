({
	doInit: function(component, event, helper) {
      //call the helper function with pass [component, Controller field and Dependent Field] Api name 
      component.set("v.testuser","none");
      helper.getRaxInfo(component, event, helper);
    }
    ,
    afterRender : function(cmp,helper) {
        //if(document.readyState === "complete") {
    /*    	var lItems = parent.document.getElementsByClassName("slds-is-relative slds-list__item");
			var bttn = parent.document.body.getElementsByTagName("button");
     
        //Unable to save below statement error: Invalid SecureWindow API, opener was blacklisted
        	//var comp = window.opener.document.body.getElementsByTagName("button");
        
        	//was able to change the color of the parent window
        	// parent.document.body.style.backgroundColor = "red";     
        	
            console.log('**list bttns '+ JSON.stringify(bttn));        	
        	console.log('**parents location '+ parent.location);
            console.log('**list items '+ JSON.stringify(lItems));
       
     */   
        //}    
    }
})