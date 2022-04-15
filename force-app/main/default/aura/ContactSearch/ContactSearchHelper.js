({
	searchContactAndLead: function (component, event, helper) {
        
		this.showSpinner(component, event);
        //component.set("v.clickedOnce", true);        
        //var countrySel = component.get("v.acc.BillingCountryCode");
        //console.log('Country==>'+countrySel);         
        var firstName = component.get("v.firstName");
        var lastName = component.get("v.lastName");   
        var email = component.get("v.email"); 
        var compName = component.get("v.companyName");
        var action = component.get("c.fetchSearchResultData");
        action.setParams({
            "fName": firstName,
            "lName":lastName,
            "email":email,
            "cmpName":compName            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(component.isValid() && state == "SUCCESS") {
                console.log('Success');
                var searchResults = response.getReturnValue();
                console.log('------<'+JSON.stringify(searchResults));                
                component.set("v.contactList", searchResults.contactWrapList);
                component.set("v.leadList", searchResults.leadWrapList);
                component.set("v.showTable", true);
                
                //Loading ContactTable_Pagination Component dynamically
                $A.createComponent(
                    "c:ContactTable_Pagination",
                    {
                        "ContactData": component.get("v.contactList"),                        
                        "startPage": "1",
                        "endPage":"10"                        
                    },
                    function(msgBox){                
                        if (component.isValid()) {
                            var targetCmp = component.find('contactDataTable');
                            //alert('targetCmp'+targetCmp);
                            targetCmp.set("v.body","");//clearing if anything in body
                            //alert('----'+targetCmp.get("v.body"));
                            var body = targetCmp.get("v.body");
                            body.push(msgBox);
                            //alert('body'+body);
                            targetCmp.set("v.body", body); 
                        }
                    }
                );
                
                //Loading Lead data by calling LeadTable_Pagination component dynamically
                $A.createComponent(
                    "c:LeadTable_Pagination",
                    {
                        "LeadData": component.get("v.leadList"),                        
                        "startPage": "1",
                        "endPage":"10"
                        
                    },
                    function(msgBox){                
                        if (component.isValid()) {
                            var targetCmp = component.find('leadDataTable');
                            //alert('targetCmp'+targetCmp);
                            targetCmp.set("v.body","");//clearing if anything in body
                            //alert('----'+targetCmp.get("v.body"));
                            var body = targetCmp.get("v.body");
                            body.push(msgBox);
                            //alert('body'+body);
                            targetCmp.set("v.body", body); 
                        }
                    }                    
                );
                this.hideSpinner(component, event);
            }
            
        });
        $A.enqueueAction(action);
        
    },
    
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        //component.set("v.Spinner", true); 
        
        var spinner = component.find("spinnerId");        
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
        //component.set("v.Spinner", false);
        
        var spinner = component.find("spinnerId");        
        $A.util.addClass(spinner, "slds-hide");
        $A.util.removeClass(spinner, "slds-show");
    },
    
    // LTCSF-140 : fetch Contact RecordTypes available for current user
    fetchContactRecordTypes: function(component, event, helper){
        this.showSpinner(component, event);
        var action = component.get("c.fetchContactRecordTypes");
        action.setCallback(this, function(response) {
            // Get callback response
            var state = response.getState();
            // On success response, assign Map values to the List component attribute
            if (component.isValid() && state == "SUCCESS") {
                var cMap1 = [];
                var cMap2 = response.getReturnValue();
                var selectedList = 'Employee';
                for(var key in cMap2) {
                    if(!selectedList.includes(cMap2[key])) { 
                        cMap1.push({value: key, key: cMap2[key] + ' Contact' });
                    }                    
                } 
                component.set("v.contactRecordTypes", cMap1);
                this.hideSpinner(component, event);
            }
        });
        $A.enqueueAction(action);
    }
})