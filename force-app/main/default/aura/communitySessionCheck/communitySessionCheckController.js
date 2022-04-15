({
	doInit : function(component, event, helper) {
        console.log('in sess',helper.getCookie("verified"));
        if(helper.getCookie("verified")=='true' ){
			//helper.setSessTime(component, event, helper);
			console.log('in sess',helper.getCookie("verified"));
            if(window.location.href == $A.get("$Label.c.Support_Community_URL")){
            	window.location.href = '/'+$A.get("$Label.c.Support_Community_Name")+'/s/guest-task';
        	}
			window.setTimeout(
                $A.getCallback(function() {
                   helper.setCookie("verified",false);
                   alert("Seesion Timed Out");
                   window.location.href = '/'+$A.get("$Label.c.Support_Community_Name")+'/s/';
                }), 1800000
    		);
        }else if(window.location.href != $A.get("$Label.c.Support_Community_URL") && window.location.href != $A.get("$Label.c.Support_Community_URL")+'/s/'
                && !window.location.href.includes('livepreview')){
            console.log( $A.get("$Label.c.Support_Community_URL")+'/s/','$$$$$$$',window.location.href);
            window.location.href = '/'+$A.get("$Label.c.Support_Community_Name")+'/s/';
        }
            
	},
   
})