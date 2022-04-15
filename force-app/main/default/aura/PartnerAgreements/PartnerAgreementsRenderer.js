({
rerender : function(component, helper) {
   	this.superRerender();
    var once = component.get("v.staticImp");
    var step = component.get("v.stepNum");
    var companyval = component.get("v.company");
    
    if(companyval && step == 1 && once==1 && (companyval.onboard_step__c=="agreements" || companyval.onboard_step__c=="completed")){

        component.set("v.staticImp",2);
        if(companyval.Partner_Level__c=="Strategic" || companyval.Partner_Level__c == "Master Agent"
          || companyval.Partner_Level__c=="Master Agent EMEA"){
        	component.set("v.strategic",true);
        }else if(companyval.Partner_Level__c=="StrategicEMEA"){
            if(companyval.Click_To_Agree__c == true){
                component.set("v.strategicemea",true);
                if(companyval.onboard_step__c!="completed"){
                var myEvent = component.getEvent("buttonDisplay");
     			  myEvent.setParams({"showButtons": false});
      			  myEvent.fire();
                }
            }else{
				component.set("v.strategic",true);   
            }
        }else{
            if(companyval.Click_To_Agree__c == true){
                component.set("v.otherPartners",true);
                if(companyval.Partner_Level__c=="Referral"){
        	component.set("v.docReferral",true);
                  
        }if(companyval.Partner_Level__c=="Reseller"){
        	component.set("v.docReseller",true);
                   
        }if(companyval.Partner_Level__c=="Referral/Reseller"){
        	component.set("v.docReferralReseller",true);
                  
        }if(companyval.Partner_Level__c=="ResellerReferral"){
        	component.set("v.docReferralReseller",true);
                  
        }if(companyval.Partner_Level__c=="ReferralEMEA"){
        	component.set("v.docReferralEMEA",true);
                 
        }if(companyval.Partner_Level__c=="ResellerEMEA"){
        	component.set("v.docResellerEMEA",true);
                    
        }if(companyval.Partner_Level__c=="ResellerReferralEMEA"){
        	component.set("v.docResellerReferralEMEA",true);
                    
        }
             if(companyval.onboard_step__c!="completed"){
                var myEvent = component.getEvent("buttonDisplay");
                myEvent.setParams({"showButtons": false});
                myEvent.fire();
             }
        	}
            
        }
    }
    if(step != 1){
       // console.log('step',step, '  ', component.get("v.otherPartners"));
       //s component.set("v.otherPartners",false);
    }
	
	}})