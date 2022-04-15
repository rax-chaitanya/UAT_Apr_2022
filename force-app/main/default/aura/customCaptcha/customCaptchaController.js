({
	doInit : function(component, event, helper) {
        console.log('in captcha',helper.getCookie("verified"));
        if(helper.getCookie("verified")=='true'){
            window.location.href = '/'+$A.get("$Label.c.Support_Community_Name")+'/s/guest-task';
        }else{
			helper.refreshCaptcha(component, event, helper);
        }
	},
    
    test : function(component, event, helper) {
    	helper.refreshCaptcha(component, event, helper);
	},
    checkCaptcha : function(component, event, helper) {
        //console.log(component.get('v.valueEntered'));
        helper.checkCaptcha(component, event, helper);
	}
})