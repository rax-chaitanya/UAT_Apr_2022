({
	getaccessQuikrPageValues: function(component, event, helper) {  
       var action = component.get("c.accessQuikrPage");   
       action.setParams({
           getvalues: "getvalues"
       });
       action.setCallback(this, function(response){
           var state = response.getState();
           if (state === "SUCCESS") {
               var acc = response.getReturnValue();
               helper.useQuikrValue(component, event, acc)  
           }
       });
       $A.enqueueAction(action); 
    },
    useQuikrValue: function(component, event, acc) {
        console.log("Work accepted.");
        var workItemId = event.getParam('workItemId');
        console.log(workItemId);
        if(acc === true){
            var workspaceAPI = component.find("workspace");
            var urlSub = '/apex/QuikrApplicationPage?tId='+workItemId;
            workspaceAPI.getAllTabInfo().then(function(response) {
                var jsonParser = component.get("c.parseTabInfowrapper");
                jsonParser.setParams({
                    tabInfoResult: JSON.stringify(response),
                    WorkItemID: workItemId
                });
                jsonParser.setCallback(this, function(tabInfoResponse){
                    var state = tabInfoResponse.getState();
                    if (state === "SUCCESS") {
                        console.log('Json parser Call back Success');
                        var getTabID = tabInfoResponse.getReturnValue();
                        console.log('getTabID - '+ getTabID);
                        setTimeout(function(){
                            workspaceAPI.openSubtab({                            
                                parentTabId: getTabID,
                                url: urlSub,
                                focus: false,
                                closeable: false   
                            }).then(function(response){                           
                                workspaceAPI.setTabHighlighted({
                                    tabId: response,
                                    highlighted: true
                                });
                                console.log('Subtab Successfully Opened -'+response);
                            }).catch(function(error) {
                                console.log(error);
                            });
                        }, 1500);     
                    }
                });$A.enqueueAction(jsonParser);  
            }).catch(function(error) {
                console.log(error);
            });  
        }
    },  
    
    getRepChatSurveyValues: function(component, event, helper) {   
        var wItemId = event.getParam('workItemId');
        /*
       var action = component.get("c.accessRepChatSurveyPage");
       action.setParams({   
           getvalues: "getvalues"
       });
       */
        var action = component.get("c.isRepChatPageAccessible");
        action.setStorable(); // caches the return value
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                let popUpChatPage = response.getReturnValue();
                var checkChatEnd = component.get("c.checkChatEnd");
                checkChatEnd.setParams({
                    WorkItemID: wItemId
                });
                checkChatEnd.setCallback(this, function(response){
                    console.log('Call back');
                    var respState = response.getState();
                    if (respState === "SUCCESS") {
                        console.log('Call back Success');
                        var cStatus = response.getReturnValue();
                        console.log('Return Value - '+ cStatus);
                      if(cStatus === true){   
                      if (popUpChatPage) {    
                            console.log(popUpChatPage);  
                            helper.openRepChatSurveyLEX(component, event);
                        }
                        }  
                        if(cStatus == true){
                            console.log('Calling Helper method');
                            //helper.openRepChatSurveyLEX(component, event);
                            // helper.useRepChatValue(component, event, repChatValue);   
                        } 
                    }
                });
                $A.enqueueAction(checkChatEnd);  
            }
        });
        $A.enqueueAction(action);  
    },
    
    useRepChatValue: function(component, event, repChatValue) {
        console.log("Work Closed.");
        var transcriptId = event.getParam('workItemId');
        console.log(transcriptId);
        if(repChatValue === true){
            var workspaceAPI = component.find("workspace");
            workspaceAPI.openTab({
                recordId: transcriptId,
                focus: false,
            }).then(function(primaryResponse){
                setTimeout(function(){
                    workspaceAPI.openSubtab({
                        parentTabId: primaryResponse,
                        url: '/apex/RepPostChatSurvey?&transcriptId='+transcriptId,
                        focus: true,
                    }).then(function(response){
                        console.log('Subtab Successfully Opened -'+response);
                        workspaceAPI.setTabHighlighted({
                            tabId: response,
                            highlighted: true
                        }).then(function(response){
                            alert('Please fill the chat survey');
                        }).catch(function(error){
                            console.log(error);    
                        });
                    }).catch(function(error){
                        console.log(error);
                    });
                },1500);
            }).catch(function(error) {
                   console.log(error);
            });
        }
     },
    openRepChatSurveyLEX	: function(component, event) {
        var transcriptId = event.getParam('workItemId');
        console.log(event.getParams());
        
        //if (transcriptId != undefined && transcriptId.startsWith('570')) {
        //refreshes the utility bar component with the completed chat surveys
        // could use this event to pass the transcript and prepend it to the list...
        
        // event to refresh the pending post chat surveys component
        var appEvent = $A.get("e.c:workItemClosedEvent");
        appEvent.fire();
        
        var utilityAPI = component.find("utilitybar");
        utilityAPI.getAllUtilityInfo().then(function(response) {
            var myUtilityInfo = response[4];
            
            utilityAPI.openUtility({
                utilityId : myUtilityInfo.id
            });
            
            utilityAPI.setUtilityHighlighted({
                highlighted : true
            });
            
        }).catch (function (error) {
            alert(error);
        });
        //}
    },
	// END CHAT Code Merge
    onChatEnded: function(cmp, evt, hlp) {  
        var conversation = cmp.find("conversationKit");
        var recordId = evt.getParam("recordId");
        var omniAPI = cmp.find("omniToolkit");        
        omniAPI.getAgentWorks().then(function(result) {           
            var action = cmp.get("c.getWorkId");   
            action.setParams({workItemId: recordId});
            action.setCallback(this, function(response){   
                if (response.getState() === "SUCCESS") {
                    omniAPI.closeAgentWork({workId: response.getReturnValue()}).then(function(res) {
                        if (res) {   
                            console.log("Closed work successfully");
                        } else {
                            console.log("Close work failed");
                        }  
                    }).catch(function(error) {
                        console.log(error);
                    }); 
                }
            });   
            $A.enqueueAction(action);
        });        
    }    
})