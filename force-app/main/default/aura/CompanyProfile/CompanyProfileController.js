({
      doSomething: function(component, event, helper) {
           component.set("v.openEditHeaderWindow", true); 
      },
    doInit: function(component, event, helper) {
          var action = component.get("c.getCompanyProfile");
       
        action.setCallback(this,function(response){
            
            var retval = response.getReturnValue();
            component.set("v.PartnerCompany",retval);
                       
        });
        
        $A.enqueueAction(action);
        
        helper.checkPrimary(component, event, helper);
        helper.getPickListValues(component, event, helper);      

    },
    save:function(component,event){ 
       //alert(component.get("v.Product"));
       //alert(component.get("v.PartnerCompany.Partner_Product__c"));
        var IndustryVar=component.get("v.Industry");
        var IndustryVar2;
		var solutionVar= component.get("v.solution");
		var solutionVar2
        var productVar=component.get("v.Product");
        var productVar2;
		var countryVar=component.get("v.country");
        var countryVar2;
        if(IndustryVar==undefined){          
            IndustryVar2=component.get("v.PartnerCompany.Industry");
        }else{
             IndustryVar2=component.get("v.Industry");
        }
        if( solutionVar==undefined ){          
			solutionVar2=component.get("v.PartnerCompany.Partner_Solution__c");
        }else{        
			 solutionVar2=component.get("v.solution");
        }
        if( productVar==undefined ){         
			productVar2=component.get("v.PartnerCompany.Partner_Product__c");
        }else{
			 productVar2=component.get("v.Product");
        }
		if( countryVar==undefined ){         
			countryVar2=component.get("v.PartnerCompany.BillingCountry");
        }else{
			 countryVar2=component.get("v.country");
        }
        
        var action = component.get("c.setCompanyProfile");
        action.setParams({
            "acc":component.get("v.PartnerCompany"),
            "description":component.get("v.description"),
            "solution":solutionVar2,
            "product":productVar2,
            "industry":IndustryVar2,
            "country":countryVar2
        });
        action.setCallback(this,function(response){
            alert(response.getReturnValue());
             //alert('Save');
        });
        $A.enqueueAction(action);
    },
    
   showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
    
 // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner  
   
       component.set("v.Spinner", false);
    },
        //Calling a logos component
    gotoLogosComp:function(component,event,helper){
        component.set("v.openLogosWindow", true); 
        //alert('Calling gotoLogosComp');
    },
    setLogoBoolean:function(component,event,helper){
        component.set("v.openLogosWindow", false); 
        //alert('Calling setLogoBoolean method');
    },
    
})