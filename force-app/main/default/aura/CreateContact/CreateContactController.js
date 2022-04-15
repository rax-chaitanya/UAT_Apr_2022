({
    doInit : function(component, event, helper) {
        var pickListDataAction = component.get('c.getPickListData');
        
        pickListDataAction.setCallback(this, function(response){
            helper.hideSpinner(component);
            if(response.getState() == 'SUCCESS'){ 
                var returnValue = response.getReturnValue();
                component.set("v.SalutationList", returnValue.SalutationValues);
                component.set("v.LanguageList", returnValue.LanguageValues);
                component.set("v.billingCountryOptions", returnValue.MailingCountryOptions);
                component.set("v.billingStateValues", returnValue.MailingStateValues);
                component.set("v.billingStateOptions", returnValue.MailingStateValues[returnValue.MailingCountryOptions[0]]);
            }
        });
        
        $A.enqueueAction(pickListDataAction);
        helper.showSpinner(component);
        
    },
    
    SaveContact : function(component, event, helper) {
        
        var button = component.find('disablebuttonid');
        var FirstName = component.get("v.FirstName");
        var LastName = component.get("v.LastName");
        var Email = component.get("v.Email");
        var lang = component.find("ContactLanguage").get("v.value");
        var salu = component.find("ContactSalutation").get("v.value");
        var action = component.get("c.Createcontact");
        if(FirstName=='' || LastName =='' || Email ==''){
            alert('Please fill all the required fields.'); 
        }else{
            action.setParams({
                "Fname" : component.get("v.FirstName"),
                "Lname" : component.get("v.LastName"),
                "Salu" : salu,
                "Tit" : component.get("v.Title"),  
                "Email": component.get("v.Email"),
                "Phone" : component.get("v.Phone"),
                "Fax" : component.get("v.Fax"),
                "Mob" : component.get("v.Mobile"),
                "lang":lang,
                "mailcon" : component.get("v.billingCountry"),
                "mailstate" : component.get("v.billingState"),
                "city" : component.get("v.BillingCity"),
                "pcode" : component.get("v.BillingZip"), 
                "address" : component.get("v.BillingStreet")
                
            });
            
            action.setCallback(this, function(response){
                helper.hideSpinner(component);
                
                if (response.getState() === "SUCCESS") {
                    button.set('v.disabled',true);
                    var navigationSObject = $A.get("e.force:navigateToSObject");
                    helper.pollToRedirect(component, response.getReturnValue());
                } 
                
                else{
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        type : "fail",
                        title : "Failure!",  
                        message : "The email id is already exists.Please try with new email id."  
                    });
                    toastEvent.fire(); 
                }
                
                
            }); 
            $A.enqueueAction(action);
            helper.showSpinner(component);
        }
    },
    handleCountryChange : function(component, event, helper) {
        component.set("v.billingState", "");
        var country = component.get("v.billingCountry");
        if(country == '--None--'){
            component.set("v.statePickEnable", true);
        }else{
            component.set("v.statePickEnable", false);
        }  
        
        var stateValues = component.get("v.billingStateValues");
        component.set("v.billingStateOptions", stateValues[country]);
        
    }
    
    
})