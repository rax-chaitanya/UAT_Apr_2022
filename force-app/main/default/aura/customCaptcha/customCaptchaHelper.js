({
	refreshCaptcha : function(component, event, helper) {
        var length = 6;
		var res    = '';
        var char   = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz012345678901234567890123456789';
        var charLen = char.length;
        for ( var i = 0; i < length; i++ ) {
           res += char.charAt(Math.floor(Math.random() * charLen));
        }
        component.set("v.captcha",res);
	},
    checkCaptcha : function(component, event, helper) {
        var cap = component.get("v.captcha");
        var inp = component.get('v.valueEntered');
        if(cap == inp){
            helper.setCookie("verified",true);
            var myEvent = component.getEvent("checkCaptcha");
     			  myEvent.setParams({"captchaVerified": "true"});
      			  myEvent.fire();
            	  
            window.location.href = '/'+$A.get("$Label.c.Support_Community_Name")+'/s/guest-task';
            
        }else{
            alert("captcha incorrect try again");
            helper.refreshCaptcha(component, event, helper);
        }
	},
    setCookie: function (cname, cvalue) {
        var d = new Date();
        d.setTime(d.getTime() + 1800000);
        var expires = "expires="+d.toUTCString();
        document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
    },
    getCookie: function (cname) {
        var name = cname + "=";
        var ca = document.cookie.split(';');
        for(var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) == ' ') {
                c = c.substring(1);
            }
            if (c.indexOf(name) == 0) {
                return c.substring(name.length, c.length);
            }
        }
        return "";
    }
    

})