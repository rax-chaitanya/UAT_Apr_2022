({
	openNewTab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        var state = component.get("v.addrDocState");
        
        console.log("Tab created.");
        
        workspaceAPI.getAllTabInfo().then(function(response) {
            var focusedTabId;
            //= response.tabId;
            workspaceAPI.getFocusedTabInfo().then(function(response) {
                                    focusedTabId = response.tabId;
                     				console.log('focus tab',focusedTabId);
                     				
                                })
                                .catch(function(error) {
                                    console.log(error);
                                });
            setTimeout(function(){
            for(var i=0;i<response.length;i++){
                console.log("resp tab",response[i].tabId); 
                if(response[i].tabId == focusedTabId){
                   
                if(response[i].pageReference.attributes.actionName=="new"){
                    console.log("record being created");
                    component.set("v.newTab",response[i].tabId);
                    break;
                    
                }
                if(response[i].pageReference.attributes.actionName=="view"){
               		if(response[i].recordId != null && response[i].recordId != component.get("v.recordId") 
                      ){
                       if(response[i].pageReference.attributes.objectApiName=="Contact"||
                           response[i].pageReference.attributes.objectApiName=="Account"||
                           response[i].pageReference.attributes.objectApiName=="Accounts__c"||
                          response[i].pageReference.attributes.objectApiName=="Account_Contact_Role__c"
                          ){
                           console.log('########');
                       component.set("v.stopAddr",true);
                        var respo = response[i];
                        component.set("v.recordId",response[i].recordId);
                        component.set('v.sObjectName',response[i].pageReference.attributes.objectApiName);
                        var action = component.get("c.isAddressVerified");
                        var recId = component.get("v.recordId");
                        var objectName = component.get("v.sObjectName");
                           //console.log('$$$$$$$$$$',recId,'%%%%%%%%%%%%',objectName);
                        action.setParams({
                            "objId": recId,
                            "objectName": objectName
                        });
                        action.setCallback(this, function(resp) {
                            if (resp.getState() == "SUCCESS") {
                                var retVal = resp.getReturnValue().split(',');
                                if(retVal[0]=="AddrDoc" && retVal[1]==recId){
                                    console.log(JSON.stringify(respo));
                                    component.set("v.stopAddr",false);
                                    console.log('$$$$$$$$$$',recId,'%%%%%%%%%%%%',objectName);
                                    helper.launchAddressDoctor(component,respo);
                                }
                            }else{
                                component.set("v.isRunning", false);
                            }
                        });
                        $A.enqueueAction(action);
                    }
                    }
                    break;
                }
            }
            }
                }, 1000);
       })
        
        .catch(function(error) {
            console.log(error);
        });
		
	},
    
	newRefreshed : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        var state = component.get("v.addrDocState");
        var newTabId = component.get('v.newTab');
        console.log('Tab refreshed');
        if(newTabId!='empty'){
        workspaceAPI.getAllTabInfo().then(function(response) {
           
            setTimeout(function(){
                for(var i=0;i<response.length;i++){
                    console.log('resp tab',response[i].tabId);
                    console.log('tets in');
                    if(response[i].tabId==newTabId && response[i].pageReference.attributes.actionName=='view'){
                    if(response[i].recordId != null && response[i].recordId != component.get("v.recordId")){
                        if(response[i].pageReference.attributes.objectApiName=="Contact"||
                               response[i].pageReference.attributes.objectApiName=="Account"||
                               response[i].pageReference.attributes.objectApiName=="Accounts__c"||
                              response[i].pageReference.attributes.objectApiName=="Account_Contact_Role__c"
                              ){
                        //console.log('test',response[i].recordId,'test',component.get("v.recordId"));
                            var respo = response[i];
                            component.set("v.recordId",response[i].recordId);
                            component.set('v.sObjectName',response[i].pageReference.attributes.objectApiName);
                            helper.launchAddressDoctor(component,respo);
                    }    
                }
            	break;
                }
            	
            }
            
            }, 3000);
            
       })
        .catch(function(error) {
            console.log(error);
        });  
    }
	},    
    launchAddressDoctor: function(component,res){
         var openList = component.get("v.recIdOpen");
         var workspaceAPI = component.find("workspace");
        component.set("v.stopAddr",false);
                        if(res.pageReference.attributes.objectApiName=="Contact"||
                           res.pageReference.attributes.objectApiName=="Account"||
                           res.pageReference.attributes.objectApiName=="Accounts__c"||
                          res.pageReference.attributes.objectApiName=="Account_Contact_Role__c"
                          ){
                            if(component.get('v.newTab')!='empty'){component.set('v.newTab','empty');}
                            
                            //////////////////////////
                         workspaceAPI.openSubtab({
                             parentTabId: res.tabId,
                             
                             pageReference: {
                                    "type": "standard__component",
                                    "attributes": {
                                        "componentName": "c__AddressDoctorTopComponentCreate",  // c__<comp Name>
                                        
                                    },
                                    "state": {
                                        "uid": 1,
                                       "c__recordId": component.get('v.recordId'),
                                        "c__objName":component.get('v.sObjectName')
                                    }
                                },
                             focus: false
                          }).then(function(responseC){
                         	workspaceAPI.setTabLabel({
                                    tabId: responseC,
                                    label: "Address Doctor"
                                });
                                workspaceAPI.setTabIcon({
                                    tabId: responseC,
                                    icon: "action:edit_relationship"
                                });
                         }).catch(function(error) {
                            console.log(error);
                        	});
                        
                        component.set("v.stopAddr",false);    
                        }
                        
    }
})