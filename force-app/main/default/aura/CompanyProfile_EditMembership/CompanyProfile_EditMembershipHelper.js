({ 
    updateHeadlineWithContractType : function(component, event, helper, selectedMembershiplevel){
        var rmvtag=component.get("v.headerMessage2");
					rmvtag = rmvtag.replace('<p>','');
                    var rmvtag2=rmvtag.replace('</p>','');
        var action = component.get("c.updateHeadLineWithContractType2");
        action.setParams({"headline": rmvtag2,
                          "MembershipLevel":selectedMembershiplevel,
                          "recordId": component.get("v.dataId")
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            var success = response.getReturnValue();
           
            if (state === "SUCCESS" || success === 'Success'){
                var cmpTarget = component.find('Modalbox');
                var cmpBack = component.find('Modalbackdrop');
                $A.util.removeClass(cmpBack,'slds-backdrop--open');
                $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
                component.set("v.headerMessage",rmvtag2);
               
            }else {
                 
                alert('Error in updating HeadLine');
            }
        });
        
        $A.enqueueAction(action);
    },
    fetchheadline : function(component, event, selectedMembershiplevelval) { 
        var action = component.get("c.getExistingRecord2"); 
        action.setParams({ 
            "MembershipLevel": selectedMembershiplevelval
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var message = response.getReturnValue(); 
                if(message != null){
                    component.set("v.headerMessage2",message.Head_Line__c);
                    component.set("v.dataId",message.Id)
                   var rmvtag=component.get("v.headerMessage2");
                     if(rmvtag!=null ){
					rmvtag = rmvtag.replace('<p>','');
                    var rmvtag2=rmvtag.replace('</p>',''); 
                    component.set("v.headerMessage",rmvtag2);
                    }
                }
                else if(message == null){
                    component.set("v.dataId","");
                    component.set("v.headerMessage2","");
                    component.set("v.headerMessage","");
                }   
            }
            else {
                alert('Error in getting data');
            }
        });
        
        $A.enqueueAction(action);
       
    },
     getPickListValues:function(component, fieldName, elementId){
        var action = component.get("c.getPicklistvalues");
        action.setParams({ 
            "fieldAPIName": fieldName
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var opts = []; 
            if(state == "SUCCESS"){
                var result = response.getReturnValue(); 
                if(result != undefined && result.length > 0){ 
                    for (var i = 0; i < result.length; i++) { 
                        opts.push({
                            class: "optionClass",
                            label: result[i],
                            value: result[i]
                        });
                    }
                    component.find(elementId).set("v.options", opts);
                    this.fetchheadline(component, event, result[0]);
                }  
            }else{ 
                alert('Error in getting data'); 
            }
        });
        $A.enqueueAction(action);        
    },
     fetchuserprofile:function(component, event, helper) {
        var action = component.get("c.getUserInfo2");
        action.setCallback(this, function(response) {
            var state = response.getState();
           
            if(state == "SUCCESS"){ 
                var result = response.getReturnValue();
                console.log('---'+result);
                if(result != null){
                   
                   if(result == 'Admin'){
                        this.getPickListValues(component, 'Membership_Level__c', 'MemberShipLevel'); 
                        component.set("v.isValidProfile",true); 
                    }
                    else{
                        this.fetchheadline(component, event, result);
                    }    
                }
                
            }else{
                alert('Error in getting data2'); 
            }
        });
        $A.enqueueAction(action);
    }
})